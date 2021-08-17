# generated by https://github.com/ministryofjustice/money-to-prisoners-deploy
resource "aws_route53_zone" "app_domain" {
  name = "prisoner-money.service.justice.gov.uk."

  tags = {
    application            = var.application
    is-production          = var.is-production
    namespace              = var.namespace
    environment-name       = var.environment-name
    owner                  = var.team_name
    infrastructure-support = var.email
  }
}

resource "kubernetes_secret" "app_domain" {
  metadata {
    name      = "route53-app-domain"
    namespace = var.namespace
  }

  data = {
    zone_id      = aws_route53_zone.app_domain.zone_id
    name_servers = join("\n", aws_route53_zone.app_domain.name_servers)
  }
}

resource "aws_route53_record" "app_domain_cname_email" {
  name    = "email.prisoner-money.service.justice.gov.uk."
  zone_id = aws_route53_zone.app_domain.zone_id
  type    = "CNAME"
  ttl     = "300"
  records = ["eu.mailgun.org"]
}

resource "aws_route53_record" "app_domain_txt_root" {
  name    = "prisoner-money.service.justice.gov.uk."
  zone_id = aws_route53_zone.app_domain.zone_id
  type    = "TXT"
  ttl     = "300"
  records = [
    "v=spf1 include:eu.mailgun.org ~all",
    "google-site-verification=IUBR5QDuFJbCicN27PV70pqWQHtiRMCBHzYKgF_dWw0"
  ]
}

resource "aws_route53_record" "app_domain_txt_smtp_domainkey" {
  name    = "smtp._domainkey.prisoner-money.service.justice.gov.uk."
  zone_id = aws_route53_zone.app_domain.zone_id
  type    = "TXT"
  ttl     = "300"
  records = [
    "k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0rIehv2VfJOHCm7qxuEfTrDuQFftKUF75jmt7I3EgfCDo+Bf1oagrCLGIAdTpwc399kx4GSQ8Fg32tKA2mxR9+xYKTNp1c6yvAyeRUCzmZ6ZKSgA9vOjvbY/NifKVL3+iHQ+tWs7QWGa+zoxYd5Bi8uXS++NZdmFFSVRFDNdZxnp5q1A0SLoETjEd+rbS54pRdnyqeEzFY\"\"GUIBuNW18bRewvEQdrDz/vHlsCnlm5CEskO5srgxOd9EaLzT1Za1Db9pT+wiVBIn/d0wyulRDjsQFdMZI0O1il9EMnRpW1kC/ohx9IQmiqbd3+LRolknQzoCbtXyea7nxnKNUkk9BRXQIDAQAB"
  ]
}

resource "aws_route53_record" "app_domain_mx" {
  name    = "prisoner-money.service.justice.gov.uk."
  zone_id = aws_route53_zone.app_domain.zone_id
  type    = "MX"
  ttl     = "300"
  records = ["10 mxa.eu.mailgun.org", "10 mxb.eu.mailgun.org"]
}

resource "aws_route53_zone" "send_money" {
  name = "send-money-to-prisoner.service.gov.uk."

  tags = {
    application            = var.application
    is-production          = var.is-production
    namespace              = var.namespace
    environment-name       = var.environment-name
    owner                  = var.team_name
    infrastructure-support = var.email
  }
}

resource "kubernetes_secret" "send_money" {
  metadata {
    name      = "route53-send-money"
    namespace = var.namespace
  }

  data = {
    zone_id      = aws_route53_zone.send_money.zone_id
    name_servers = join("\n", aws_route53_zone.send_money.name_servers)
  }
}

resource "aws_route53_record" "send_money_cname_email" {
  name    = "email.send-money-to-prisoner.service.gov.uk."
  zone_id = aws_route53_zone.send_money.zone_id
  type    = "CNAME"
  ttl     = "300"
  records = ["mailgun.org"]
}

resource "aws_route53_record" "send_money_txt_root" {
  name    = "send-money-to-prisoner.service.gov.uk."
  zone_id = aws_route53_zone.send_money.zone_id
  type    = "TXT"
  ttl     = "300"
  records = [
    "v=spf1 include:mailgun.org ~all",
    "google-site-verification=T2qg1AVVzK0DAQSY2SmnS-rRN-hsJFUMeBLiMoyrahY"
  ]
}

resource "aws_route53_record" "send_money_txt_mailo_domainkey" {
  name    = "mailo._domainkey.send-money-to-prisoner.service.gov.uk."
  zone_id = aws_route53_zone.send_money.zone_id
  type    = "TXT"
  ttl     = "300"
  records = [
    "k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCuOs26XfsArjkmoN/tAy9OzgZi/ohE8JDaTZFoow6O+ft3ilrkfoWT+duiOUggwO4lPzQ0kFD5yqZeDUGyPOwHFyMRkeAHEruBXAS4hefUR+ZiTVCsKYPQJZ/NuUCU2tkVQ7muKUnLT90ggNu6q0PaTnxxaYUjSfdeyxLUVTxiwwIDAQAB"
  ]
}

resource "aws_route53_record" "send_money_mx" {
  name    = "send-money-to-prisoner.service.gov.uk."
  zone_id = aws_route53_zone.send_money.zone_id
  type    = "MX"
  ttl     = "300"
  records = ["10 mxa.mailgun.org", "10 mxb.mailgun.org"]
}

resource "aws_route53_zone" "start_page" {
  name = "sendmoneytoaprisoner.justice.gov.uk."

  tags = {
    application            = var.application
    is-production          = var.is-production
    namespace              = var.namespace
    environment-name       = var.environment-name
    owner                  = var.team_name
    infrastructure-support = var.email
  }
}

resource "kubernetes_secret" "start_page" {
  metadata {
    name      = "route53-start-page"
    namespace = var.namespace
  }

  data = {
    zone_id      = aws_route53_zone.start_page.zone_id
    name_servers = join("\n", aws_route53_zone.start_page.name_servers)
  }
}

resource "aws_route53_record" "start_page_cname_email" {
  name    = "email.sendmoneytoaprisoner.justice.gov.uk."
  zone_id = aws_route53_zone.start_page.zone_id
  type    = "CNAME"
  ttl     = "300"
  records = ["mailgun.org"]
}

resource "aws_route53_record" "start_page_txt_root" {
  name    = "sendmoneytoaprisoner.justice.gov.uk."
  zone_id = aws_route53_zone.start_page.zone_id
  type    = "TXT"
  ttl     = "300"
  records = [
    "v=spf1 include:mailgun.org ~all",
    "google-site-verification=weAYdFuWe6PfocCiQ66wBE18XZP0vqC1_FRx5BLtr5o"
  ]
}

resource "aws_route53_record" "start_page_txt_smtp_domainkey" {
  name    = "smtp._domainkey.sendmoneytoaprisoner.justice.gov.uk."
  zone_id = aws_route53_zone.start_page.zone_id
  type    = "TXT"
  ttl     = "300"
  records = [
    "k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCiKXT4bXJkdvmDtdogyzBSbT0r47xoUdAzKIGXWTpD4fcK73QZg1A/Mya3yOyatd1PQnS5qVCT15TYOBi446xHbGOaWwSrJJv0JfqcJF/oU4xoFVyb5RyEfDrtEVv3VAznjFDQwc8ji8AqKE3/Od0H86hmryF9zE7PfTne/T2uVQIDAQAB"
  ]
}

resource "aws_route53_record" "start_page_mx" {
  name    = "sendmoneytoaprisoner.justice.gov.uk."
  zone_id = aws_route53_zone.start_page.zone_id
  type    = "MX"
  ttl     = "300"
  records = ["10 mxa.mailgun.org", "10 mxb.mailgun.org"]
}

resource "aws_route53_zone" "start_page_alias" {
  name = "sendmoneytoaprisoner.service.justice.gov.uk."

  tags = {
    application            = var.application
    is-production          = var.is-production
    namespace              = var.namespace
    environment-name       = var.environment-name
    owner                  = var.team_name
    infrastructure-support = var.email
  }
}

resource "kubernetes_secret" "start_page_alias" {
  metadata {
    name      = "route53-start-page-alias"
    namespace = var.namespace
  }

  data = {
    zone_id      = aws_route53_zone.start_page_alias.zone_id
    name_servers = join("\n", aws_route53_zone.start_page_alias.name_servers)
  }
}
