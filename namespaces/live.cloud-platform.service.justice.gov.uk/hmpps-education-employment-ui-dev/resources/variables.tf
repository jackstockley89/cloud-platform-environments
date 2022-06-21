
variable "cluster_name" {
}


variable "application" {
  description = "Name of Application you are deploying"
  default     = "hmpps-education-employment"
}

variable "namespace" {
  default = "hmpps-education-employment-ui-dev"
}

variable "business_unit" {
  description = "Area of the MOJ responsible for the service."
  default     = "HMPPS"
}

variable "team_name" {
  description = "The name of your development team"
  default     = "education-skills-work-employment"
}

variable "environment" {
  description = "The type of environment you're deploying to."
  default     = "development"
}

variable "infrastructure_support" {
  description = "The team responsible for managing the infrastructure. Should be of the form team-email."
  default     = "managing.eswe@digital.justice.gov.uk"
}

variable "is_production" {
  default = "false"
}

variable "slack_channel" {
  description = "Team slack channel to use if we need to contact your team"
  default     = "education-skills-work-employment-dev"
}

variable "number_cache_clusters" {
  default = "2"
}
