

module "makeaplea_queue" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-sqs?ref=4.9.1"

  environment-name          = var.environment
  team_name                 = var.team_name
  infrastructure-support    = var.infrastructure_support
  application               = var.application
  sqs_name                  = "makeaplea_queue"
  encrypt_sqs_kms           = "true"
  message_retention_seconds = 1209600
  namespace                 = var.namespace

  redrive_policy = <<EOF
  {
    "deadLetterTargetArn": "${module.makeaplea_dead_letter_queue.sqs_arn}","maxReceiveCount": 3
  }
  EOF

  providers = {
    aws = aws.london
  }
}


resource "aws_sqs_queue_policy" "makeaplea_queue_policy" {
  queue_url = module.makeaplea_queue.sqs_id

  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Id": "${module.makeaplea_queue.sqs_arn}/SQSDefaultPolicy",
    "Statement":
      [
        {
          "Effect": "Allow",
          "Principal": {"AWS": "*"},
          "Resource": "${module.makeaplea_queue.sqs_arn}",
          "Action": "SQS:SendMessage"
        }
      ]
  }
   EOF
}



module "makeaplea_dead_letter_queue" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-sqs?ref=4.9.1"

  environment-name       = var.environment
  team_name              = var.team_name
  infrastructure-support = var.infrastructure_support
  application            = var.application
  sqs_name               = "makeaplea_queue_dl"
  encrypt_sqs_kms        = "true"
  namespace              = var.namespace

  providers = {
    aws = aws.london
  }
}


resource "kubernetes_secret" "makeaplea_queue" {
  metadata {
    name      = "makeaplea-instance-output-sqs-instance-output"
    namespace = "makeaplea-dev"
  }

  data = {
    access_key_id     = module.makeaplea_queue.access_key_id
    secret_access_key = module.makeaplea_queue.secret_access_key
    sqs_id            = module.makeaplea_queue.sqs_id
    sqs_arn           = module.makeaplea_queue.sqs_arn
    sqs_name          = module.makeaplea_queue.sqs_name
  }
}


resource "kubernetes_secret" "makeaplea_dead_letter_queue" {
  metadata {
    name      = "pmakeaplea-sqs-dl-instance-output"
    namespace = "makeaplea-dev"
  }

  data = {
    access_key_id     = module.makeaplea_dead_letter_queue.access_key_id
    secret_access_key = module.makeaplea_dead_letter_queue.secret_access_key
    sqs_id            = module.makeaplea_dead_letter_queue.sqs_id
    sqs_arn           = module.makeaplea_dead_letter_queue.sqs_arn
    sqs_name          = module.makeaplea_dead_letter_queue.sqs_name
  }
}


