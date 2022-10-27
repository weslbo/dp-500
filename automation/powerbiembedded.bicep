targetScope = 'resourceGroup'

@description('Please specify a location')
param location string = resourceGroup().location

@description('Please specify the Power BI capacity administrator')
param admin string

var powerbiembedded_name = 'powerbiembedded${uniqueString(resourceGroup().id)}'

resource powerbi_embedded 'Microsoft.PowerBIDedicated/capacities@2021-01-01' = {
  name: powerbiembedded_name
  location: location
  sku: {
    name: 'A4' // this A4 capacity corresponds to P1 (Premium P1). Check out https://learn.microsoft.com/en-us/power-bi/enterprise/service-admin-premium-testing
  }
  properties: {
    administration: {
      members: [
        admin
      ]
    }
    mode: 'Gen2'
  }
}


