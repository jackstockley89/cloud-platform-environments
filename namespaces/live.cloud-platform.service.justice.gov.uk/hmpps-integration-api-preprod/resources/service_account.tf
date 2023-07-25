module "service_account" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-serviceaccount?ref=0.9.4"

  namespace           = var.namespace
  kubernetes_cluster  = var.kubernetes_cluster
  serviceaccount_name = "circleci"
}
