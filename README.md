# Azure locations module

This Terraform module is designed to provide information on Azure locations.

It provides for an Azure location name or display name : name, display name, regional display name, short name and paired region name.

Please refer to the [locations.json](locations.json) file for available locations.

## List creation/update process

The list was built following this process:

```
# Fetch Azure locations, without short names
az account list-locations --query "[].{regionalDisplayName: regionalDisplayName, name: name, displayName: displayName, pairedRegionName: metadata.pairedRegion[0].name}" > azureLocations.json

# Copy Azure Geo-code mapping from https://learn.microsoft.com/en-us/azure/backup/scripts/geo-code-list into geoCodeMapping.xml

# Convert geoCodeMapping.xml to json, using xq
<geoCodeMapping.xml xq-python '.GeoCodeList.GeoCodeRegionNameMap | map({ displayName: .["@RegionName"], shortName: .["@GeoCode"] | ascii_downcase })' > geoCodeMapping.json

# Build locations
jq --null-input --slurpfile azureLocations azureLocations.json --slurpfile geoCodeMapping geoCodeMapping.json '{ locations: [ $azureLocations[0][] | . as $account | { name, displayName, shortName: ($geoCodeMapping[0] | map(select(.displayName == $account.displayName)))[0].shortName, regionalDisplayName, pairedRegionName } ] | sort }' > locations.json
```

## Usage

```
module "azure_location" {
  source  = "azurerm/locations/azure"
  version = "x.x.x"

  location = "West Europe"
}
```

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| location | The location/region name or displayName to get information. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| location | Map of information for the location. Return 'none' if location is not found. |
| name | Standard name of the location. Return 'none' if location is not found. |
| display_name | Display name of the location. Return 'none' if location is not found. |
| short_name | Short name of the location. Return 'none' if location is not found and null if there is no short name for this location. |
| regional_display_name | Regional display name of the location. Return 'none' if location is not found. |
| paired_region_name | Paired region name of the location. Return 'none' if location is not found and null if there is no paired region name for this location.  |


## Related documentation

[Azure regions](https://azure.microsoft.com/en-us/global-infrastructure/regions/)  
[Azure Geo-code mapping](https://learn.microsoft.com/en-us/azure/backup/scripts/geo-code-list)  
[Terrafomr modules](https://developer.hashicorp.com/terraform/registry/modules/publish)  
[Terraform Best Practices](https://www.terraform-best-practices.com/)  