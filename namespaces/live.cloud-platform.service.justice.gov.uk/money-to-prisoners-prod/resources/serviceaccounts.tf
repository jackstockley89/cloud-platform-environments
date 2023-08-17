# generated by https://github.com/ministryofjustice/money-to-prisoners-deploy
resource "kubernetes_role" "deploy" {
  metadata {
    namespace = var.namespace
    name      = "deploy"
  }

  rule {
    api_groups = [""]
    resources  = ["configmaps", "pods"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["batch"]
    resources  = ["cronjobs", "jobs"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["extensions", "apps"]
    resources  = ["deployments"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups     = [""]
    resources      = ["configmaps"]
    verbs          = ["patch"]
    resource_names = ["app-versions"]
  }

  rule {
    api_groups = ["extensions", "apps"]
    resources  = ["deployments"]
    verbs      = ["patch"]
    resource_names = [
      "default",
      "api",
      "cashbook",
      "bank-admin",
      "noms-ops",
      "send-money",
      "start-page",
      "emails",
    ]
  }

  rule {
    api_groups = ["batch"]
    resources  = ["cronjobs"]
    verbs      = ["patch"]
    resource_names = [
      "transaction-uploader",
    ]
  }

  rule {
    api_groups = [""]
    resources  = ["secrets"]
    verbs      = ["get"]
    resource_names = [
      "route53-app-domain",
      "route53-send-money",
      "route53-start-page",
      "route53-start-page-alias",
      "ecr",
      "irsa-deploy",
      "irsa-api",
      "irsa-cashbook",
      "irsa-bank-admin",
      "irsa-noms-ops",
      "irsa-send-money",
      "irsa-emails",
      "rds",
      "s3",
    ]
  }
}

resource "kubernetes_role_binding" "deploy" {
  metadata {
    namespace = var.namespace
    name      = "deploy"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.deploy.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    namespace = var.namespace
    name      = module.irsa-deploy.service_account.name
  }
}
