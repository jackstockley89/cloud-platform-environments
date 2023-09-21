module "court_case_service_rds" {
  source                      = "github.com/ministryofjustice/cloud-platform-terraform-rds-instance?ref=6.0.0"
  vpc_name                    = var.vpc_name
  team_name                   = var.team_name
  business_unit               = var.business_unit
  namespace                   = var.namespace
  application                 = var.application
  environment_name            = var.environment-name
  infrastructure_support      = var.infrastructure_support
  is_production               = var.is_production
  allow_major_version_upgrade = false
  db_engine_version           = "13"
  db_instance_class           = "db.t3.xlarge"
  rds_family                  = "postgres13"
  db_allocated_storage        = "35"
  enable_rds_auto_start_stop  = true

  snapshot_identifier = "court-case-service-manual-snapshot-1670251827"

  providers = {
    aws = aws.london
  }
}

resource "kubernetes_secret" "court_case_service_rds" {
  metadata {
    name      = "court-case-service-rds-instance-output"
    namespace = var.namespace
  }
  data = {
    rds_instance_endpoint = module.court_case_service_rds.rds_instance_endpoint
    database_name         = module.court_case_service_rds.database_name
    database_username     = module.court_case_service_rds.database_username
    database_password     = module.court_case_service_rds.database_password
    rds_instance_address  = module.court_case_service_rds.rds_instance_address
    url                   = "postgres://${module.court_case_service_rds.database_username}:${module.court_case_service_rds.database_password}@${module.court_case_service_rds.rds_instance_endpoint}/${module.court_case_service_rds.database_name}"
  }
}
