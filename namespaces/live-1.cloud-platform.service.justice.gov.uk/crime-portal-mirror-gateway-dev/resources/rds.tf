/*
 * When using this module through the cloud-platform-environments, the following
 * two variables are automatically supplied by the pipeline.
 *
 */

variable "cluster_name" {
}

variable "cluster_state_bucket" {
}

module "crime_portal_mirror_gateway_rds" {
  source               = "github.com/ministryofjustice/cloud-platform-terraform-rds-instance?ref=5.3"
  cluster_name         = var.cluster_name
  cluster_state_bucket = var.cluster_state_bucket
  team_name            = "probation-in-court"
  business-unit        = "hmpps"
  application          = "crime-portal-mirror-gateway"
  is-production        = "false"
  performance_insights_enabled = true
  db_engine_version      = "10"
  environment-name       = "development"
  infrastructure-support = "john.evans@digital.justice.gov.uk"
  rds_family = "postgres10"
  apply_method = "pending-reboot"
  allow_major_version_upgrade = "true"
  force_ssl = true

  providers = {
    aws = aws.london
  }
}

resource "kubernetes_secret" "crime_portal_mirror_gateway_rds" {
  metadata {
    name      = "crime-portal-mirror-gateway-rds-instance-output"
    namespace = "crime-portal-mirror-gateway-dev"
  }

  data = {
    rds_instance_endpoint = module.crime_portal_mirror_gateway_rds.rds_instance_endpoint
    database_name         = module.crime_portal_mirror_gateway_rds.database_name
    database_username     = module.crime_portal_mirror_gateway_rds.database_username
    database_password     = module.crime_portal_mirror_gateway_rds.database_password
    rds_instance_address  = module.crime_portal_mirror_gateway_rds.rds_instance_address
    access_key_id         = module.crime_portal_mirror_gateway_rds.access_key_id
    secret_access_key     = module.crime_portal_mirror_gateway_rds.secret_access_key
    database_url          = "jdbc:postgresql://${module.crime_portal_mirror_gateway_rds.rds_instance_endpoint}/${module.crime_portal_mirror_gateway_rds.database_name}?ssl=true&sslmode=require"
  }
}