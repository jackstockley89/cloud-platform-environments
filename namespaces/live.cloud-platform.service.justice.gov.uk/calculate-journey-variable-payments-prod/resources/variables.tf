

variable "vpc_name" {
}


variable "application" {
  description = "Name of Application you are deploying"
  default     = "Calculate Journey Variable Payments"
}

variable "namespace" {
  default = "calculate-journey-variable-payments-prod"
}

variable "business_unit" {
  description = "Area of the MOJ responsible for the service."
  default     = "HMPPS"
}

variable "team_name" {
  description = "The name of your development team"
  default     = "calculate-journey-variable-payments"
}

variable "environment" {
  description = "The type of environment you're deploying to."
  default     = "prod"
}

variable "environment-name" {
  description = "The environment name identifier."
  default     = "prod"
}


variable "infrastructure_support" {
  description = "The team responsible for managing the infrastructure. Should be of the form team-email."
  default     = "calculatejourneypayments@digital.justice.gov.uk"
}

variable "is_production" {
  default = "true"
}

variable "slack_channel" {
  description = "Team slack channel to use if we need to contact your team"
  default     = "calculate-journey-payments"
}
variable "github_owner" {
  description = "The GitHub organization or individual user account containing the app's code repo. Used by the Github Terraform provider. See: https://user-guide.cloud-platform.service.justice.gov.uk/documentation/getting-started/ecr-setup.html#accessing-the-credentials"
  type        = string
  default     = "ministryofjustice"
}

variable "github_token" {
  type        = string
  description = "Required by the GitHub Terraform provider"
  default     = ""
}

