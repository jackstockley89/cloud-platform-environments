variable "application" {
  default = "court-case-service"
}

variable "namespace" {
  default = "court-probation-dev"
}

variable "business-unit" {
  default = "HMPPS"
}

variable "team_name" {
  default = "Probation in Court Team"
}

variable "environment-name" {
  default = "development"
}

variable "infrastructure-support" {
  default = "Probation in Court Team: probation-in-court-team@digital.justice.gov.uk"
}

variable "is-production" {
  default = "false"
}

variable "rds-family" {
  default = "postgres11"
}

variable "db_engine_version" {
  default = "11"
}

variable "team_name_hyphenated" {
  default = "probation-in-court-team"
}

