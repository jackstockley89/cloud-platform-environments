module "secret" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-secrets-manager?ref=3.0.0"

  eks_cluster_name = var.eks_cluster_name

  # Secrets configuration
  secrets = {
    "alfresco-license" = {
      description             = "Contents of Alfresco .lic file"
      recovery_window_in_days = 14
      k8s_secret_name         = "alfresco-license"
    },
  }

  # Tags
  business_unit          = var.business_unit
  application            = var.application
  is_production          = var.is_production
  team_name              = var.team_name
  namespace              = var.namespace
  environment_name       = var.environment
  infrastructure_support = var.infrastructure_support
}
