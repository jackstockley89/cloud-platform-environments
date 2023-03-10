# generated by https://github.com/ministryofjustice/money-to-prisoners-deploy
terraform {
  backend "s3" {}
}

provider "aws" {
  region = "eu-west-2"

  default_tags {
    tags = {
      GithubTeam = "prisoner-money"
    }
  }
}

provider "aws" {
  alias  = "london"
  region = "eu-west-2"

  default_tags {
    tags = {
      GithubTeam = "prisoner-money"
    }
  }
}

variable "namespace" {
  default = "money-to-prisoners-prod"
}

variable "business_unit" {
  default = "HMPPS"
}

variable "team_name" {
  default = "prisoner-money"
}

variable "application" {
  default = "money-to-prisoners"
}

variable "environment-name" {
  default = "prod"
}

variable "is_production" {
  default = "true"
}

variable "infrastructure_support" {
  default = "money-to-prisoners@digital.justice.gov.uk"
}

variable "eks_cluster_name" {
  description = "The name of the eks cluster to retrieve the OIDC information"
}
