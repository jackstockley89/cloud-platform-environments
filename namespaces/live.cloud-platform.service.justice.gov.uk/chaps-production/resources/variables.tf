

variable "vpc_name" {
}


variable "kubernetes_cluster" {
}

variable "application" {
  description = "Name of Application you are deploying"
  default     = "Correspondence handling and processing system"
}

variable "namespace" {
  default = "chaps-production"
}

variable "business_unit" {
  description = "Area of the MOJ responsible for the service."
  default     = "HQ"
}

variable "team_name" {
  description = "The name of your development team"
  default     = "dotnet"
}

variable "environment" {
  description = "The type of environment you're deploying to."
  default     = "production"
}

variable "infrastructure_support" {
  description = "The team responsible for managing the infrastructure. Should be of the form team-email."
  default     = "chaps-support@digital.justice.gov.uk"
}

variable "is_production" {
  default = "true"
}

variable "slack_channel" {
  description = "Team slack channel to use if we need to contact your team"
  default     = "cdpt-chaps"
}

variable "github_owner" {
  description = "The GitHub organization or individual user account containing the app's code repo. Used by the Github Terraform provider. See: https://user-guide.cloud-platform.service.justice.gov.uk/documentation/getting-started/ecr-setup.html#accessing-the-credentials"
  default     = "ministryofjustice"
}

variable "github_token" {
  description = "Required by the Github Terraform provider"
  default     = ""
}

variable "github_actions_secret_kube_token" {
  description = "The name of the github actions secret containing the serviceaccount token"
  default     = "KUBE_TOKEN_PRODUCTION"
}

variable "github_actions_secret_kube_cluster" {
  description = "The name of the github actions secret containing the kubernetes cluster name"
  default     = "KUBE_CLUSTER_PRODUCTION"
}

variable "github_actions_secret_kube_namespace" {
  description = "The name of the github actions secret containing the kubernetes namespace name"
  default     = "KUBE_NAMESPACE_PRODUCTION"
}

variable "github_actions_secret_kube_cert" {
  description = "The name of the github actions secret containing the serviceaccount ca.crt"
  default     = "KUBE_CERT_PRODUCTION"
}
