variable "cluster_name" {
}

variable "cluster_state_bucket" {
}

module "hmpps_assessments_rds" {
  source                 = "github.com/ministryofjustice/cloud-platform-terraform-rds-instance?ref=5.6"
  cluster_name           = var.cluster_name
  cluster_state_bucket   = var.cluster_state_bucket
  team_name              = var.team_name
  business-unit          = var.business-unit
  application            = var.application
  is-production          = var.is-production
  environment-name       = var.environment-name
  infrastructure-support = var.infrastructure-support
  rds_family             = var.rds-family


  providers = {
    aws = aws.london
  }
}

resource "kubernetes_secret" "hmpps_assessments_rds" {
  metadata {
    name      = "hmpps_assessments-rds-instance-output"
    namespace = var.namespace
  }

  data = {
    rds_instance_endpoint = module.hmpps_assessments_rds.rds_instance_endpoint
    database_name         = module.hmpps_assessments_rds.database_name
    database_username     = module.hmpps_assessments_rds.database_username
    database_password     = module.hmpps_assessments_rds.database_password
    rds_instance_address  = module.hmpps_assessments_rds.rds_instance_address
    access_key_id         = module.hmpps_assessments_rds.access_key_id
    secret_access_key     = module.hmpps_assessments_rds.secret_access_key
    url                   = "postgres://${module.hmpps_assessments_rds.database_username}:${module.hmpps_assessments_rds.database_password}@${module.hmpps_assessments_rds.rds_instance_endpoint}/${module.hmpps_assessments_rds.database_name}"
  }
}

