targetScope = 'resourceGroup'

@description('Please specify a location')
param location string = resourceGroup().location

@description('Managed identity ID of the purview account')
param purview_managed_identity string

@description('Managed identity ID of the synapse workspace account')
param synapse_managed_identity string

@secure()
@description('Please specify a password for the Azure SQL Server administrator')
param sqlAdministratorLoginPassword string

var keyvault_name = 'keyvault-${uniqueString(resourceGroup().id)}'
var tenantId = subscription().tenantId

resource keyvault 'Microsoft.KeyVault/vaults@2021-04-01-preview' = {
  name: keyvault_name
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    enableSoftDelete: false
    tenantId: tenantId
    accessPolicies: [
      {
        tenantId: tenantId
        objectId: synapse_managed_identity
        permissions:{
          secrets: [
            'get'
            'list'
            'set'
            'delete'
            'recover'
            'backup'
            'restore'
          ]
        }
      }
      {
        tenantId: tenantId
        objectId: purview_managed_identity
        permissions: {
          secrets: [
            'get'
            'list'
          ]
        }
      }
    ]
  }
  resource secret 'secrets' = {
    name: 'sqlpassword'
    properties: {
      value: sqlAdministratorLoginPassword
    }
  }
}
