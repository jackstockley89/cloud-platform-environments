variable "namespace" {
  default = "laa-cla-backend-uat"
}

variable "business-unit" {
  default = "LAA"
}

variable "team_name" {
  default = "laa-get-access"
}

variable "application" {
  default = "Backend API for the Civil Legal Aid applications"
}

variable "repo_name" {
  default = "cla_backend"
}

variable "email" {
  default = "civil-legal-advice@digital.justice.gov.uk"
}

variable "environment-name" {
  default = "uat"
}

variable "is-production" {
  default = "false"
}

variable "infrastructure-support" {
  description = "The team responsible for managing the infrastructure. Should be of the form team-email."
  default     = "civil-legal-advice@digital.justice.gov.uk"
}

variable "cluster_name" {
}

variable "vpc_name" {
}

