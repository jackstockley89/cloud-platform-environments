module "visit_scheduler_rds" {
  source                 = "github.com/ministryofjustice/cloud-platform-terraform-rds-instance?ref=6.0.1"
  vpc_name               = var.vpc_name
  team_name              = var.team_name
  business_unit          = var.business_unit
  application            = var.application
  is_production          = var.is_production
  environment_name       = var.environment
  infrastructure_support = var.infrastructure_support
  namespace              = var.namespace

  allow_major_version_upgrade = "false"
  prepare_for_major_upgrade   = false
  db_engine                   = "postgres"
  db_engine_version           = "15.5"
  rds_family                  = "postgres15"
  db_instance_class           = "db.t4g.small"
  db_max_allocated_storage    = "16300"
  db_allocated_storage        = "16000"
  maintenance_window          = "Tue:22:00-Wed:03:00"
  db_password_rotated_date    = "2023-05-11"
  performance_insights_enabled = true

  providers = {
    aws = aws.london
  }
}

resource "kubernetes_secret" "visit_scheduler_rds" {
  metadata {
    name      = "visit-scheduler-rds"
    namespace = var.namespace
  }

  data = {
    rds_instance_endpoint = module.visit_scheduler_rds.rds_instance_endpoint
    database_name         = module.visit_scheduler_rds.database_name
    database_username     = module.visit_scheduler_rds.database_username
    database_password     = module.visit_scheduler_rds.database_password
    rds_instance_address  = module.visit_scheduler_rds.rds_instance_address
  }
}
