# Shared service account for use by the probation integration team to access all queues in the namespace
# Note: each service in the namespace also has a dedicated service account
resource "aws_iam_policy" "irsa_policy" {
  name   = "${var.namespace}-irsa"
  policy = data.aws_iam_policy_document.sqs_console_role_policy_document.json
}

module "shared-service-account" {
  source                 = "github.com/ministryofjustice/cloud-platform-terraform-irsa?ref=2.0.0"
  application            = var.application
  business_unit          = var.business_unit
  eks_cluster_name       = var.eks_cluster_name
  environment_name       = var.environment_name
  infrastructure_support = var.infrastructure_support
  is_production          = var.is_production
  namespace              = var.namespace
  team_name              = var.team_name

  service_account_name = var.application
  role_policy_arns     = { sqs = aws_iam_policy.irsa_policy.arn }
}
