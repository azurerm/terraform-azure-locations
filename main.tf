locals {
  locations_data = jsondecode(file("${path.module}/locations.json"))

  locations_name = {
    for location in local.locations_data.locations : location.name => {
      name                = location.name
      display_name         = location.displayName
      short_name           = location.shortName
      regional_display_name = location.regionalDisplayName
      paired_region_name    = location.pairedRegionName
    }
  }

  locations_display_name = {
    for location in local.locations_data.locations : location.displayName => {
      name                = location.name
      display_name         = location.displayName
      short_name           = location.shortName
      regional_display_name = location.regionalDisplayName
      paired_region_name    = location.pairedRegionName
    }
  }

  location = coalesce(
    lookup(local.locations_name, var.location, null),
    lookup(local.locations_display_name, var.location, "none")
  )
}
