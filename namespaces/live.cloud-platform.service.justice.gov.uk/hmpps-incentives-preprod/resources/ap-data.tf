
module "analytical-platform" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-irsa?ref=1.0.3"

  namespace        = var.namespace
  role_policy_arns = [aws_iam_policy.analytical-platform.arn]
  service_account  = "${var.namespace}-analytical-platform"
  # NB: service account name must be unique within Cloud Platform (IAM role name is derived from it)
}

resource "aws_iam_policy" "analytical-platform" {
  name   = "${var.namespace}-analytical-platform"
  policy = data.aws_iam_policy_document.analytical-platform.json
  # NB: IAM policy name must be unique within Cloud Platform

  tags = {
    business-unit          = var.business_unit
    team_name              = var.team_name
    application            = var.application
    is-production          = var.is_production
    namespace              = var.namespace
    environment-name       = var.environment
    owner                  = var.team_name
    infrastructure-support = var.infrastructure_support
  }
}

data "aws_iam_policy_document" "analytical-platform" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:GetObjectAcl",
    ]
    resources = [
      module.analytical_platform_s3_bucket.bucket_arn
    ]
  }
}

resource "kubernetes_secret" "analytical-platform" {
  metadata {
    name      = "analytical-platform"
    namespace = var.namespace
  }

  data = {
    role            = module.analytical-platform.aws_iam_role_name
    role_arn        = module.analytical-platform.aws_iam_role_arn
    service_account = module.analytical-platform.service_account_name.name
  }
}
