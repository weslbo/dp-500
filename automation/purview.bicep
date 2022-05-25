targetScope = 'resourceGroup'

@description('Please specify a location')
param location string = resourceGroup().location

var purview_name = 'purview-${uniqueString(resourceGroup().id)}'
var purview_managedResourceGroupName = 'm${resourceGroup().name}-purview'

resource purview 'Microsoft.Purview/accounts@2021-07-01' = {
  name: purview_name
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    managedResourceGroupName: purview_managedResourceGroupName
    publicNetworkAccess: 'Enabled'
  }
}

output purview_resourceId string = purview.id
output purview_name string = purview.name
output purview_managed_identity string = purview.identity.principalId
