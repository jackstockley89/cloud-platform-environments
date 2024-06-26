provider "pingdom" {
}

resource "pingdom_check" "laa-legal-adviser-api-search" {
  type                     = "http"
  name                     = "LAA Legal Adviser API Search [staging]"
  host                     = "laa-legal-adviser-api-staging.apps.live-1.cloud-platform.service.justice.gov.uk"
  resolution               = 1
  notifywhenbackup         = true
  sendnotificationwhendown = 6
  notifyagainevery         = 0
  url                      = "/ping.json"
  encryption               = true
  port                     = 443
  tags                     = "businessunit_${lower(var.business_unit)},application_${lower(var.application)},component_ping,isproduction_${var.is_production},environment_${lower(var.environment-name)},infrastructuresupport_${lower(var.application)}"
  probefilters             = "region:EU"
  integrationids           = [87631, 134947]
}

