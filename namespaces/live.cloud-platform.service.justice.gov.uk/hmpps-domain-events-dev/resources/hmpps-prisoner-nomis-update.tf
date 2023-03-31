
######################################## VISITS

module "hmpps_prisoner_to_nomis_visit_queue" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-sqs?ref=4.10.1"

  environment-name           = var.environment-name
  team_name                  = var.team_name
  infrastructure-support     = var.infrastructure_support
  application                = var.application
  sqs_name                   = "hmpps_prisoner_to_nomis_visit_queue"
  encrypt_sqs_kms            = "true"
  message_retention_seconds  = 1209600
  visibility_timeout_seconds = 120
  namespace                  = var.namespace

  redrive_policy = <<EOF
  {
    "deadLetterTargetArn": "${module.hmpps_prisoner_to_nomis_visit_dead_letter_queue.sqs_arn}","maxReceiveCount": 3
  }
EOF
  providers = {
    aws = aws.london
  }
}

resource "aws_sqs_queue_policy" "hmpps_prisoner_to_nomis_visit_queue_policy" {
  queue_url = module.hmpps_prisoner_to_nomis_visit_queue.sqs_id

  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Id": "${module.hmpps_prisoner_to_nomis_visit_queue.sqs_arn}/SQSDefaultPolicy",
    "Statement":
      [
        {
          "Effect": "Allow",
          "Principal": {"AWS": "*"},
          "Resource": "${module.hmpps_prisoner_to_nomis_visit_queue.sqs_arn}",
          "Action": "SQS:SendMessage",
          "Condition":
            {
              "ArnEquals":
              {
                "aws:SourceArn": "${module.hmpps-domain-events.topic_arn}"
              }
            }
        }
      ]
  }
EOF
}

module "hmpps_prisoner_to_nomis_visit_dead_letter_queue" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-sqs?ref=4.10.1"

  environment-name       = var.environment-name
  team_name              = var.team_name
  infrastructure-support = var.infrastructure_support
  application            = var.application
  sqs_name               = "hmpps_prisoner_to_nomis_visit_dlq"
  encrypt_sqs_kms        = "true"
  namespace              = var.namespace

  providers = {
    aws = aws.london
  }
}

resource "kubernetes_secret" "hmpps_prisoner_to_nomis_visit_queue" {
  metadata {
    name      = "sqs-nomis-update-visit-secret"
    namespace = "hmpps-prisoner-to-nomis-update-dev"
  }

  data = {
    access_key_id     = module.hmpps_prisoner_to_nomis_visit_queue.access_key_id
    secret_access_key = module.hmpps_prisoner_to_nomis_visit_queue.secret_access_key
    sqs_queue_url     = module.hmpps_prisoner_to_nomis_visit_queue.sqs_id
    sqs_queue_arn     = module.hmpps_prisoner_to_nomis_visit_queue.sqs_arn
    sqs_queue_name    = module.hmpps_prisoner_to_nomis_visit_queue.sqs_name
  }
}

resource "kubernetes_secret" "hmpps_prisoner_to_nomis_visit_dead_letter_queue" {
  metadata {
    name      = "sqs-nomis-update-visit-dlq-secret"
    namespace = "hmpps-prisoner-to-nomis-update-dev"
  }

  data = {
    access_key_id     = module.hmpps_prisoner_to_nomis_visit_dead_letter_queue.access_key_id
    secret_access_key = module.hmpps_prisoner_to_nomis_visit_dead_letter_queue.secret_access_key
    sqs_queue_url     = module.hmpps_prisoner_to_nomis_visit_dead_letter_queue.sqs_id
    sqs_queue_arn     = module.hmpps_prisoner_to_nomis_visit_dead_letter_queue.sqs_arn
    sqs_queue_name    = module.hmpps_prisoner_to_nomis_visit_dead_letter_queue.sqs_name
  }
}

resource "aws_sns_topic_subscription" "hmpps_prisoner_to_nomis_visit_subscription" {
  provider  = aws.london
  topic_arn = module.hmpps-domain-events.topic_arn
  protocol  = "sqs"
  endpoint  = module.hmpps_prisoner_to_nomis_visit_queue.sqs_arn
  filter_policy = jsonencode({
    eventType = [
      "prison-visit.booked",
      "prison-visit.changed",
      "prison-visit.cancelled"
    ]
  })
}

######################################## INCENTIVES

module "hmpps_prisoner_to_nomis_incentive_queue" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-sqs?ref=4.10.1"

  environment-name           = var.environment-name
  team_name                  = var.team_name
  infrastructure-support     = var.infrastructure_support
  application                = var.application
  sqs_name                   = "hmpps_prisoner_to_nomis_incentive_queue"
  encrypt_sqs_kms            = "true"
  message_retention_seconds  = 1209600
  visibility_timeout_seconds = 120
  namespace                  = var.namespace

  redrive_policy = <<EOF
  {
    "deadLetterTargetArn": "${module.hmpps_prisoner_to_nomis_incentive_dead_letter_queue.sqs_arn}","maxReceiveCount": 3
  }
EOF
  providers = {
    aws = aws.london
  }
}

resource "aws_sqs_queue_policy" "hmpps_prisoner_to_nomis_incentive_queue_policy" {
  queue_url = module.hmpps_prisoner_to_nomis_incentive_queue.sqs_id

  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Id": "${module.hmpps_prisoner_to_nomis_incentive_queue.sqs_arn}/SQSDefaultPolicy",
    "Statement":
      [
        {
          "Effect": "Allow",
          "Principal": {"AWS": "*"},
          "Resource": "${module.hmpps_prisoner_to_nomis_incentive_queue.sqs_arn}",
          "Action": "SQS:SendMessage",
          "Condition":
            {
              "ArnEquals":
              {
                "aws:SourceArn": "${module.hmpps-domain-events.topic_arn}"
              }
            }
        }
      ]
  }
EOF
}

module "hmpps_prisoner_to_nomis_incentive_dead_letter_queue" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-sqs?ref=4.10.1"

  environment-name       = var.environment-name
  team_name              = var.team_name
  infrastructure-support = var.infrastructure_support
  application            = var.application
  sqs_name               = "hmpps_prisoner_to_nomis_incentive_dlq"
  encrypt_sqs_kms        = "true"
  namespace              = var.namespace

  providers = {
    aws = aws.london
  }
}

resource "kubernetes_secret" "hmpps_prisoner_to_nomis_incentive_queue" {
  metadata {
    name      = "sqs-nomis-update-incentive-secret"
    namespace = "hmpps-prisoner-to-nomis-update-dev"
  }

  data = {
    access_key_id     = module.hmpps_prisoner_to_nomis_incentive_queue.access_key_id
    secret_access_key = module.hmpps_prisoner_to_nomis_incentive_queue.secret_access_key
    sqs_queue_url     = module.hmpps_prisoner_to_nomis_incentive_queue.sqs_id
    sqs_queue_arn     = module.hmpps_prisoner_to_nomis_incentive_queue.sqs_arn
    sqs_queue_name    = module.hmpps_prisoner_to_nomis_incentive_queue.sqs_name
  }
}

resource "kubernetes_secret" "hmpps_prisoner_to_nomis_incentive_dead_letter_queue" {
  metadata {
    name      = "sqs-nomis-update-incentive-dlq-secret"
    namespace = "hmpps-prisoner-to-nomis-update-dev"
  }

  data = {
    access_key_id     = module.hmpps_prisoner_to_nomis_incentive_dead_letter_queue.access_key_id
    secret_access_key = module.hmpps_prisoner_to_nomis_incentive_dead_letter_queue.secret_access_key
    sqs_queue_url     = module.hmpps_prisoner_to_nomis_incentive_dead_letter_queue.sqs_id
    sqs_queue_arn     = module.hmpps_prisoner_to_nomis_incentive_dead_letter_queue.sqs_arn
    sqs_queue_name    = module.hmpps_prisoner_to_nomis_incentive_dead_letter_queue.sqs_name
  }
}

resource "aws_sns_topic_subscription" "hmpps_prisoner_to_nomis_incentive_subscription" {
  provider      = aws.london
  topic_arn     = module.hmpps-domain-events.topic_arn
  protocol      = "sqs"
  endpoint      = module.hmpps_prisoner_to_nomis_incentive_queue.sqs_arn
  filter_policy = jsonencode({ eventType = ["incentives.iep-review.inserted"] })
}

######################################## ACTIVITIES

module "hmpps_prisoner_to_nomis_activity_queue" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-sqs?ref=4.10.1"

  environment-name           = var.environment-name
  team_name                  = var.team_name
  infrastructure-support     = var.infrastructure_support
  application                = var.application
  sqs_name                   = "hmpps_prisoner_to_nomis_activity_queue"
  encrypt_sqs_kms            = "true"
  message_retention_seconds  = 1209600
  visibility_timeout_seconds = 120
  namespace                  = var.namespace

  redrive_policy = <<EOF
  {
    "deadLetterTargetArn": "${module.hmpps_prisoner_to_nomis_activity_dead_letter_queue.sqs_arn}","maxReceiveCount": 3
  }
EOF
  providers = {
    aws = aws.london
  }
}

resource "aws_sqs_queue_policy" "hmpps_prisoner_to_nomis_activity_queue_policy" {
  queue_url = module.hmpps_prisoner_to_nomis_activity_queue.sqs_id

  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Id": "${module.hmpps_prisoner_to_nomis_activity_queue.sqs_arn}/SQSDefaultPolicy",
    "Statement":
      [
        {
          "Effect": "Allow",
          "Principal": {"AWS": "*"},
          "Resource": "${module.hmpps_prisoner_to_nomis_activity_queue.sqs_arn}",
          "Action": "SQS:SendMessage",
          "Condition":
            {
              "ArnEquals":
              {
                "aws:SourceArn": "${module.hmpps-domain-events.topic_arn}"
              }
            }
        }
      ]
  }
EOF
}

module "hmpps_prisoner_to_nomis_activity_dead_letter_queue" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-sqs?ref=4.10.1"

  environment-name       = var.environment-name
  team_name              = var.team_name
  infrastructure-support = var.infrastructure_support
  application            = var.application
  sqs_name               = "hmpps_prisoner_to_nomis_activity_dlq"
  encrypt_sqs_kms        = "true"
  namespace              = var.namespace

  providers = {
    aws = aws.london
  }
}

resource "kubernetes_secret" "hmpps_prisoner_to_nomis_activity_queue" {
  metadata {
    name      = "sqs-nomis-update-activity-secret"
    namespace = "hmpps-prisoner-to-nomis-update-dev"
  }

  data = {
    access_key_id     = module.hmpps_prisoner_to_nomis_activity_queue.access_key_id
    secret_access_key = module.hmpps_prisoner_to_nomis_activity_queue.secret_access_key
    sqs_queue_url     = module.hmpps_prisoner_to_nomis_activity_queue.sqs_id
    sqs_queue_arn     = module.hmpps_prisoner_to_nomis_activity_queue.sqs_arn
    sqs_queue_name    = module.hmpps_prisoner_to_nomis_activity_queue.sqs_name
  }
}

resource "kubernetes_secret" "hmpps_prisoner_to_nomis_activity_dead_letter_queue" {
  metadata {
    name      = "sqs-nomis-update-activity-dlq-secret"
    namespace = "hmpps-prisoner-to-nomis-update-dev"
  }

  data = {
    access_key_id     = module.hmpps_prisoner_to_nomis_activity_dead_letter_queue.access_key_id
    secret_access_key = module.hmpps_prisoner_to_nomis_activity_dead_letter_queue.secret_access_key
    sqs_queue_url     = module.hmpps_prisoner_to_nomis_activity_dead_letter_queue.sqs_id
    sqs_queue_arn     = module.hmpps_prisoner_to_nomis_activity_dead_letter_queue.sqs_arn
    sqs_queue_name    = module.hmpps_prisoner_to_nomis_activity_dead_letter_queue.sqs_name
  }
}

resource "aws_sns_topic_subscription" "hmpps_prisoner_to_nomis_activity_subscription" {
  provider      = aws.london
  topic_arn     = module.hmpps-domain-events.topic_arn
  protocol      = "sqs"
  endpoint      = module.hmpps_prisoner_to_nomis_activity_queue.sqs_arn
  filter_policy = jsonencode({ eventType = ["activities.activity-schedule.created", "activities.scheduled-instances.amended", "activities.prisoner.allocated"] })
}

######################################## APPOINTMENTS ########################################

module "prisoner_to_nomis_appointment_queue" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-sqs?ref=4.10.1"

  environment-name           = var.environment-name
  team_name                  = var.team_name
  infrastructure-support     = var.infrastructure_support
  application                = var.application
  sqs_name                   = "prisoner_to_nomis_appointment_queue"
  encrypt_sqs_kms            = "true"
  message_retention_seconds  = 1209600
  visibility_timeout_seconds = 120
  namespace                  = var.namespace

  redrive_policy = <<EOF
  {
    "deadLetterTargetArn": "${module.prisoner_to_nomis_appointment_dead_letter_queue.sqs_arn}","maxReceiveCount": 3
  }
EOF
  providers = {
    aws = aws.london
  }
}

resource "aws_sqs_queue_policy" "prisoner_to_nomis_appointment_queue_policy" {
  queue_url = module.prisoner_to_nomis_appointment_queue.sqs_id

  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Id": "${module.prisoner_to_nomis_appointment_queue.sqs_arn}/SQSDefaultPolicy",
    "Statement":
      [
        {
          "Effect": "Allow",
          "Principal": {"AWS": "*"},
          "Resource": "${module.prisoner_to_nomis_appointment_queue.sqs_arn}",
          "Action": "SQS:SendMessage",
          "Condition":
            {
              "ArnEquals":
              {
                "aws:SourceArn": "${module.hmpps-domain-events.topic_arn}"
              }
            }
        }
      ]
  }
EOF
}

module "prisoner_to_nomis_appointment_dead_letter_queue" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-sqs?ref=4.10.1"

  environment-name       = var.environment-name
  team_name              = var.team_name
  infrastructure-support = var.infrastructure_support
  application            = var.application
  sqs_name               = "prisoner_to_nomis_appointment_dlq"
  encrypt_sqs_kms        = "true"
  namespace              = var.namespace

  providers = {
    aws = aws.london
  }
}

resource "kubernetes_secret" "prisoner_to_nomis_appointment_queue" {
  metadata {
    name      = "sqs-nomis-update-appointment-secret"
    namespace = "hmpps-prisoner-to-nomis-update-dev"
  }

  data = {
    access_key_id     = module.prisoner_to_nomis_appointment_queue.access_key_id
    secret_access_key = module.prisoner_to_nomis_appointment_queue.secret_access_key
    sqs_queue_url     = module.prisoner_to_nomis_appointment_queue.sqs_id
    sqs_queue_arn     = module.prisoner_to_nomis_appointment_queue.sqs_arn
    sqs_queue_name    = module.prisoner_to_nomis_appointment_queue.sqs_name
  }
}

resource "kubernetes_secret" "prisoner_to_nomis_appointment_dead_letter_queue" {
  metadata {
    name      = "sqs-nomis-update-appointment-dlq-secret"
    namespace = "hmpps-prisoner-to-nomis-update-dev"
  }

  data = {
    access_key_id     = module.prisoner_to_nomis_appointment_dead_letter_queue.access_key_id
    secret_access_key = module.prisoner_to_nomis_appointment_dead_letter_queue.secret_access_key
    sqs_queue_url     = module.prisoner_to_nomis_appointment_dead_letter_queue.sqs_id
    sqs_queue_arn     = module.prisoner_to_nomis_appointment_dead_letter_queue.sqs_arn
    sqs_queue_name    = module.prisoner_to_nomis_appointment_dead_letter_queue.sqs_name
  }
}

resource "aws_sns_topic_subscription" "hmpps_prisoner_to_nomis_appointment_subscription" {
  provider      = aws.london
  topic_arn     = module.hmpps-domain-events.topic_arn
  protocol      = "sqs"
  endpoint      = module.prisoner_to_nomis_appointment_queue.sqs_arn
  filter_policy = jsonencode({ eventType = ["appointments.appointment-instance.created"] })
}

######################################## SENTENCING

module "hmpps_prisoner_to_nomis_sentencing_queue" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-sqs?ref=4.10.1"

  environment-name           = var.environment-name
  team_name                  = var.team_name
  infrastructure-support     = var.infrastructure_support
  application                = var.application
  sqs_name                   = "hmpps_prisoner_to_nomis_sentencing_queue"
  encrypt_sqs_kms            = "true"
  message_retention_seconds  = 1209600
  visibility_timeout_seconds = 120
  namespace                  = var.namespace

  redrive_policy = <<EOF
  {
    "deadLetterTargetArn": "${module.hmpps_prisoner_to_nomis_sentencing_dead_letter_queue.sqs_arn}","maxReceiveCount": 3
  }
EOF
  providers = {
    aws = aws.london
  }
}

resource "aws_sqs_queue_policy" "hmpps_prisoner_to_nomis_sentencing_queue_policy" {
  queue_url = module.hmpps_prisoner_to_nomis_sentencing_queue.sqs_id

  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Id": "${module.hmpps_prisoner_to_nomis_sentencing_queue.sqs_arn}/SQSDefaultPolicy",
    "Statement":
      [
        {
          "Effect": "Allow",
          "Principal": {"AWS": "*"},
          "Resource": "${module.hmpps_prisoner_to_nomis_sentencing_queue.sqs_arn}",
          "Action": "SQS:SendMessage",
          "Condition":
            {
              "ArnEquals":
              {
                "aws:SourceArn": "${module.hmpps-domain-events.topic_arn}"
              }
            }
        }
      ]
  }
EOF
}

module "hmpps_prisoner_to_nomis_sentencing_dead_letter_queue" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-sqs?ref=4.10.1"

  environment-name       = var.environment-name
  team_name              = var.team_name
  infrastructure-support = var.infrastructure_support
  application            = var.application
  sqs_name               = "hmpps_prisoner_to_nomis_sentencing_dlq"
  encrypt_sqs_kms        = "true"
  namespace              = var.namespace

  providers = {
    aws = aws.london
  }
}

resource "kubernetes_secret" "hmpps_prisoner_to_nomis_sentencing_queue" {
  metadata {
    name      = "sqs-nomis-update-sentencing-secret"
    namespace = "hmpps-prisoner-to-nomis-update-dev"
  }

  data = {
    access_key_id     = module.hmpps_prisoner_to_nomis_sentencing_queue.access_key_id
    secret_access_key = module.hmpps_prisoner_to_nomis_sentencing_queue.secret_access_key
    sqs_queue_url     = module.hmpps_prisoner_to_nomis_sentencing_queue.sqs_id
    sqs_queue_arn     = module.hmpps_prisoner_to_nomis_sentencing_queue.sqs_arn
    sqs_queue_name    = module.hmpps_prisoner_to_nomis_sentencing_queue.sqs_name
  }
}

resource "kubernetes_secret" "hmpps_prisoner_to_nomis_sentencing_dead_letter_queue" {
  metadata {
    name      = "sqs-nomis-update-sentencing-dlq-secret"
    namespace = "hmpps-prisoner-to-nomis-update-dev"
  }

  data = {
    access_key_id     = module.hmpps_prisoner_to_nomis_sentencing_dead_letter_queue.access_key_id
    secret_access_key = module.hmpps_prisoner_to_nomis_sentencing_dead_letter_queue.secret_access_key
    sqs_queue_url     = module.hmpps_prisoner_to_nomis_sentencing_dead_letter_queue.sqs_id
    sqs_queue_arn     = module.hmpps_prisoner_to_nomis_sentencing_dead_letter_queue.sqs_arn
    sqs_queue_name    = module.hmpps_prisoner_to_nomis_sentencing_dead_letter_queue.sqs_name
  }
}

resource "aws_sns_topic_subscription" "hmpps_prisoner_to_nomis_sentencing_subscription" {
  provider  = aws.london
  topic_arn = module.hmpps-domain-events.topic_arn
  protocol  = "sqs"
  endpoint  = module.hmpps_prisoner_to_nomis_sentencing_queue.sqs_arn
  filter_policy = jsonencode({
    eventType = [
      "release-date-adjustments.adjustment.inserted",
      "release-date-adjustments.adjustment.updated",
      "release-date-adjustments.adjustment.deleted"
    ]
  })
}
