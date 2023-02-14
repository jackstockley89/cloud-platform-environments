module "hmpps-domain-events" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-sns-topic?ref=4.6.0"

  topic_display_name = "hmpps-domain-events"

  business_unit          = var.business-unit
  application            = var.application
  is_production          = var.is-production
  team_name              = var.team_name
  environment_name       = var.environment-name
  infrastructure_support = var.infrastructure-support
  namespace              = var.namespace

  providers = {
    aws = aws.london
  }
}



