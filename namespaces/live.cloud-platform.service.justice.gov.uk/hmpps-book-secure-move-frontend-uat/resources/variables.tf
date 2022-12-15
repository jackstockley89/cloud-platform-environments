variable "team_name" {
  default = "book-a-secure-move"
}

variable "environment-name" {
  default = "uat"
}

variable "is-production" {
  default = "false"
}

variable "infrastructure-support" {
  default = "pecs-digital-tech@digital.justice.gov.uk"
}

variable "application" {
  default = "HMPPS Book a secure move frontend"
}

variable "namespace" {
  default = "hmpps-book-secure-move-frontend-uat"
}

variable "repo_name" {
  default = "hmpps-book-secure-move-frontend"
}

# The following variable is provided at runtime by the pipeline.

variable "vpc_name" {
}


