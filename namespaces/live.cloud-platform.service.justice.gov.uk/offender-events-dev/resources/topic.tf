module "offender_events" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-sns-topic?ref=4.9.0"

  topic_display_name = "offender-events"

  business_unit          = var.business_unit
  application            = var.application
  is_production          = var.is_production
  team_name              = var.team_name
  environment_name       = var.environment
  infrastructure_support = var.infrastructure_support
  namespace              = var.namespace

  providers = {
    aws = aws.london
  }
}

resource "kubernetes_secret" "offender_events" {
  metadata {
    name      = "offender-events-topic"
    namespace = var.namespace
  }

  data = {
    topic_arn         = module.offender_events.topic_arn
  }
}

module "probation_offender_events" {
  source             = "github.com/ministryofjustice/cloud-platform-terraform-sns-topic?ref=4.9.0"
  topic_display_name = "probation-offender-events"

  business_unit          = var.business_unit
  application            = var.application
  is_production          = var.is_production
  team_name              = var.team_name
  environment_name       = var.environment
  infrastructure_support = var.infrastructure_support
  namespace              = var.namespace

  providers = {
    aws = aws.london
  }
}

module "offender_assessments_events" {
  source             = "github.com/ministryofjustice/cloud-platform-terraform-sns-topic?ref=4.9.0"
  topic_display_name = "offender-assessments-events"

  business_unit          = var.business_unit
  application            = var.application
  is_production          = var.is_production
  team_name              = var.team_name
  environment_name       = var.environment
  infrastructure_support = var.infrastructure_support
  namespace              = var.namespace

  providers = {
    aws = aws.london
  }
}

resource "kubernetes_secret" "offender_assessments_events" {
  metadata {
    name      = "offender-assessments-events-topic"
    namespace = var.namespace
  }
  data = {
    topic_arn         = module.offender_assessments_events.topic_arn
  }
}

resource "kubernetes_secret" "offender-events-and-delius-topic-secret" {
  metadata {
    name      = "offender-events-and-delius-topic"
    namespace = "hmpps-probation-integration-services-${var.environment}"
  }
  data = {
    TOPIC_ARN             = module.probation_offender_events.topic_arn
  }
}
