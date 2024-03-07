module "serviceaccount_formbuilder-user-datastore-live-dev" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-serviceaccount?ref=1.0.0"

  namespace = var.namespace
  kubernetes_cluster = var.kubernetes_cluster

  serviceaccount_token_rotated_date = "07-03-2024"

  serviceaccount_name = "formbuilder-user-datastore-live-dev"
  role_name = "formbuilder-user-datastore-live-dev"
  rolebinding_name = "formbuilder-user-datastore-live-dev"

  # Uncomment and provide repository names to create github actions secrets
  # containing the ca.crt and token for use in github actions CI/CD pipelines
  # github_repositories = ["my-repo"]
}

