resource "pingdom_check" "manage_recalls" {
  type                     = "http"
  name                     = "manage-recalls - DEV"
  host                     = "manage-recalls-preprod.hmpps.service.justice.gov.uk"
  resolution               = 1
  notifywhenbackup         = true
  sendnotificationwhendown = 6
  notifyagainevery         = 0
  url                      = "/"
  encryption               = true
  port                     = 443
  tags                     = "hmpps,ppud-replacement,manage-recalls,preprod,isproduction_false,cloudplatform-managed"
  probefilters             = "region:EU"
  integrationids           = [116726]
}

resource "pingdom_check" "manage_recalls_ui_health" {
  type                     = "http"
  name                     = "manage-recalls-ui /health - DEV"
  host                     = "manage-recalls-preprod.hmpps.service.justice.gov.uk"
  resolution               = 1
  notifywhenbackup         = true
  sendnotificationwhendown = 6
  notifyagainevery         = 0
  url                      = "/health"
  encryption               = true
  port                     = 443
  tags                     = "hmpps,ppud-replacement,manage-recalls,preprod,isproduction_false,cloudplatform-managed"
  probefilters             = "region:EU"
  integrationids           = [116726]
}

resource "pingdom_check" "manage_recalls_api_health" {
  type                     = "http"
  name                     = "manage-recalls-api /health - DEV"
  host                     = "manage-recalls-api-preprod.hmpps.service.justice.gov.uk"
  resolution               = 1
  notifywhenbackup         = true
  sendnotificationwhendown = 6
  notifyagainevery         = 0
  url                      = "/health"
  encryption               = true
  port                     = 443
  tags                     = "hmpps,ppud-replacement,manage-recalls,preprod,isproduction_false,cloudplatform-managed"
  probefilters             = "region:EU"
  integrationids           = [116726]
}
