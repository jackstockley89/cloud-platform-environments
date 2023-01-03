################################################################################
# CCCD Application Elasticache for ReDiS
# for sidekiq background job processing and internal API cache
# Size: cache.t2.small (1vCPU, 1.55Gib, low/moderate)
# https://aws.amazon.com/elasticache/pricing/
################################################################################

module "cccd_elasticache_redis" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-elasticache-cluster?ref=5.5"

  vpc_name               = var.vpc_name
  application            = var.application
  environment-name       = var.environment-name
  is-production          = var.is-production
  infrastructure-support = var.infrastructure-support
  team_name              = var.team_name
  namespace              = var.namespace

  engine_version        = "4.0.10"
  parameter_group_name  = "default.redis4.0"
  number_cache_clusters = "3"
  node_type             = "cache.t2.small"
}

resource "kubernetes_secret" "cccd_elasticache_redis" {
  metadata {
    name      = "cccd-elasticache-redis"
    namespace = var.namespace
  }

  data = {
    primary_endpoint_address = module.cccd_elasticache_redis.primary_endpoint_address
    auth_token               = module.cccd_elasticache_redis.auth_token
    member_clusters          = jsonencode(module.cccd_elasticache_redis.member_clusters)
    url                      = "rediss://dummyuser:${module.cccd_elasticache_redis.auth_token}@${module.cccd_elasticache_redis.primary_endpoint_address}:6379"
  }
}

