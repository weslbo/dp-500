targetScope = 'resourceGroup'

@description('Please specify a location')
param location string = resourceGroup().location

var datalake_name = 'datalake${uniqueString(resourceGroup().id)}'

resource datalake 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: datalake_name
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
    isHnsEnabled: true
    networkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
    }
    accessTier: 'Hot'
  }

  resource service 'blobServices' = {
    name: 'default'
    resource container 'containers' = {
      name: 'synapse'
    }
  }
}

output dfs_endpoint string = datalake.properties.primaryEndpoints.dfs
output datalake_name string = datalake.name
