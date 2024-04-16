data "kubernetes_secret" "cloudfront_input_secret" {
  metadata {
    name      = "cloudfront-input"
    namespace = var.namespace
  }
}

locals {
  trusted_key          = {
    encoded_key = data.kubernetes_secret.cloudfront_input_secret.data["AWS_CLOUDFRONT_PUBLIC_KEY"]
    comment     = ""
  }
  expiring_trusted_key = {
    encoded_key = try(data.kubernetes_secret.cloudfront_input_secret.data["AWS_CLOUDFRONT_PUBLIC_KEY_EXPIRING"], null)
    comment     = ""
  }
}

module "cloudfront" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-cloudfront-edits?ref=cloudfront-functions-draft"


  # Configuration
  bucket_id            = module.s3_bucket.bucket_name
  bucket_domain_name   = "${module.s3_bucket.bucket_name}.s3.eu-west-2.amazonaws.com"
  # aliases              = [var.cloudfront_alias]
  # aliases_cert_arn     = aws_acm_certificate.cloudfront_alias_cert.arn
  
  # An array of public keys with comments, to be used for CloudFront. Includes an optional entry for an expiring key
  trusted_public_keys = local.expiring_trusted_key.encoded_key == null ? [trusted_key] : [trusted_key, expiring_trusted_key]

  # Tags
  business_unit          = var.business_unit
  application            = var.application
  is_production          = var.is_production
  team_name              = var.team_name
  namespace              = var.namespace
  environment_name       = var.environment
  infrastructure_support = var.infrastructure_support
}

resource "kubernetes_secret" "cloudfront_url" {
  metadata {
    name      = "cloudfront-output"
    namespace = var.namespace
  }

  data = {
    cloudfront_alias       = var.cloudfront_alias
    cloudfront_url         = module.cloudfront.cloudfront_url
    cloudfront_public_keys = module.cloudfront.cloudfront_public_keys
  }
} 
