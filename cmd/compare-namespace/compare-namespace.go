package main

import (
	"context"
	"flag"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"path/filepath"
	"strconv"
	"strings"

	"github.com/google/go-github/github"
	"github.com/hashicorp/hcl/v2"
	"github.com/hashicorp/hcl/v2/hclwrite"

	githubaction "github.com/sethvargo/go-githubactions"
	"golang.org/x/oauth2"
)

// github variables
var (
	client    *github.Client
	ctx       context.Context
	token     = flag.String("token", os.Getenv("GITHUB_OAUTH_TOKEN"), "GihHub Personel token string")
	githubref = flag.String("branch", os.Getenv("GITHUB_REF"), "GitHub branch reference.")
	gitRepo   = os.Getenv("GITHUB_REPOSITORY")
	mm        Mismatch
	r         Result
)

var (
	// repo user and repo name
	gitRepoS = strings.Split(gitRepo, "/")
	owner    = gitRepoS[0]
	repo     = gitRepoS[1]

	// get pr owner
	githubrefS = strings.Split(*githubref, "/")
	branch     = githubrefS[2]
	bid, _     = strconv.Atoi(branch)
)

type Mismatch struct {
	RepositoryNamespace,
	File,
	ResourceTypeName,
	ResourceName,
	ResourceNamespace string
}

type Result struct {
	Result string
}

// listFiles will gather a list of tf files to be checked for namespace comparisons
func listFiles() []*github.CommitFile {
	prs, _, err := client.PullRequests.ListFiles(ctx, owner, repo, bid, nil)
	if err != nil {
		log.Fatal(err)
	}
	return prs
}

// decodeFile for kube secrets and return namespaces that the secret is attached to
func decodeFile() ([]*hclwrite.Block, error) {
	var blocks []*hclwrite.Block

	data, err := os.ReadFile(mm.File)

	if err != nil {
		return nil, fmt.Errorf("error reading file %s", err)
	}

	f, diags := hclwrite.ParseConfig(data, mm.File, hcl.Pos{
		Line:   0,
		Column: 0,
	})

	if diags.HasErrors() {
		return nil, fmt.Errorf("error getting TF resource: %s", diags)
	}
	blocks = f.Body().Blocks()

	return blocks, nil
}

// resouceType will search for namespace in all resources in a Pull Request
func resourceType(block *hclwrite.Block) (string, string) {
	var resourceName string
	var namespaceBlock string
	var namespaceVar string

	metadata := block.Body().Blocks()
	for _, m := range metadata {
		if m.Type() == "metadata" {
			for key, attr := range m.Body().Attributes() {
				if key == "name" {
					expr := attr.Expr()
					exprTokens := expr.BuildTokens(nil)
					var valueTokens hclwrite.Tokens
					valueTokens = append(valueTokens, exprTokens...)
					resourceName = strings.TrimSpace(string(valueTokens.Bytes()))
				}
				if key == "namespace" {
					expr := attr.Expr()
					exprTokens := expr.BuildTokens(nil)
					var valueTokens hclwrite.Tokens
					valueTokens = append(valueTokens, exprTokens...)
					namespaceBlock = strings.TrimSpace(string(valueTokens.Bytes()))
					if strings.Contains(namespaceBlock, "var.") {
						ns := strings.SplitAfter(namespaceBlock, ".")
						varNamespace, err := varFileSearch(ns[1])
						if err != nil {
							log.Fatal(err)
						}
						namespaceVar = varNamespace
					} else {
						namespaceVar = namespaceBlock
					}
				}
			}
		}
	}
	return namespaceVar, resourceName
}

// varFileSearch will search for the namespace in the variables.tf file if the search returns a var.namespace
func varFileSearch(ns string) (string, error) {
	path := strings.SplitAfter(mm.File, "resources/")
	data, err := os.ReadFile(path[0] + "variables.tf")
	if err != nil {
		return "", fmt.Errorf("error reading file %s", err)
	}

	v, diags := hclwrite.ParseConfig(data, path[0]+"variables.tf", hcl.Pos{
		Line:   0,
		Column: 0,
	})

	if diags.HasErrors() {
		return "", fmt.Errorf("error getting TF resource: %s", diags)
	}

	var varNamespace string

	blocks := v.Body().Blocks()
	for _, block := range blocks {
		if block.Type() == "variable" {
			for _, label := range block.Labels() {
				if label == ns {
					for key, attr := range block.Body().Attributes() {
						if key == "default" {
							expr := attr.Expr()
							exprTokens := expr.BuildTokens(nil)
							var varTokens hclwrite.Tokens
							varTokens = append(varTokens, exprTokens...)
							varNamespace = strings.TrimSpace(string(varTokens.Bytes()))
						}
					}
				}
			}
		}
	}
	return varNamespace, nil
}

func main() {
	if *token == "" {
		client = github.NewClient(nil)
	} else {
		ctx = context.Background()
		ts := oauth2.StaticTokenSource(
			&oauth2.Token{AccessToken: *token},
		)
		tc := oauth2.NewClient(ctx, ts)

		client = github.NewClient(tc)
	}

	prs := listFiles()
	// setting stdout to a file
	fname := filepath.Join(os.TempDir(), "stdout")
	old := os.Stdout            // keep backup of the real stdout
	temp, _ := os.Create(fname) // create temp file
	os.Stdout = temp

	for _, pr := range prs {
		mm.File = *pr.Filename
		if filepath.Ext(mm.File) == ".tf" {
			fileS := strings.Split(mm.File, "/")
			mm.RepositoryNamespace = fileS[2]
			// mm.File = "/Users/jackstockley/repo/fork/cloud-platform-environments-fork/" + mm.File
			blocks, err := decodeFile()
			if err != nil {
				log.Fatal(err)
			}
			for _, block := range blocks {
				if block.Type() == "resource" {
					rtn := block.Labels()
					mm.ResourceTypeName = rtn[1]
					mm.ResourceNamespace, mm.ResourceName = resourceType(block)
					if !strings.Contains(mm.ResourceNamespace, mm.RepositoryNamespace) {
						githubaction.SetOutput("mismatch", "true")
						r.Result = fmt.Sprintf("\nRepository Namespace: %s\nFile: %s\nResosurce Type Name: %s\nResource Name: %s\nResource Namespace: %s\n", mm.RepositoryNamespace, mm.File, mm.ResourceTypeName, mm.ResourceName, mm.ResourceNamespace)
						fmt.Println(r.Result)
					}
				}
			}
		}
	}
	// back to normal state
	temp.Close()
	os.Stdout = old // restoring the real stdout

	// reading our temp stdout
	out, _ := ioutil.ReadFile(fname)
	// fmt.Print(string(out))
	githubaction.SetOutput("result", string(out))
}
