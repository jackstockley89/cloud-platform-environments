module "serviceaccount" {
  source    = "github.com/ministryofjustice/cloud-platform-terraform-serviceaccount?ref=0.5"
  namespace = var.namespace

  github_actions_secret_kube_namespace = KUBE_NAMESPACE_LIVE
  github_actions_secret_kube_cert      = KUBE_CERT_LIVE
  github_actions_secret_kube_token     = KUBE_TOKEN_LIVE
  github_actions_secret_kube_cluster   = KUBE_CLUSTER_LIVE

  # Uncomment and provide repository names to create github actions secrets
  # containing the ca.crt and token for use in github actions CI/CD pipelines
  github_repositories = ["cloud-platform-reference-app-github-action"]
}
