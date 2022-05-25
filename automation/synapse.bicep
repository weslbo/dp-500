targetScope = 'resourceGroup'

@description('Please specify a username for the Azure SQL Server administrator (default "azureuser")')
param sqlAdministratorLogin string = 'azureuser'

@secure()
@description('Please specify a password for the Azure SQL Server administrator')
param sqlAdministratorLoginPassword string

@description('Please specify a location')
param location string = resourceGroup().location

@description('Dfs Endpoint of the data lake account')
param dfs_endpoint string

@description('Resource ID of the Microsoft Purview resource')
param purview_resourceId string = '/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.Purview/accounts/purview${uniqueString(resourceGroup().id)}'

var synapse_name = 'synapse-${uniqueString(resourceGroup().id)}'
var synapse_managedResourceGroupName = 'm${resourceGroup().name}-synapse'
var dfs_endpoint_without_trailing_slash = take(dfs_endpoint, length(dfs_endpoint)-1)

resource synapse_workspace 'Microsoft.Synapse/workspaces@2021-06-01' = {
  name: synapse_name
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    defaultDataLakeStorage: {
      accountUrl: dfs_endpoint_without_trailing_slash
      filesystem: 'synapse'
    }
    purviewConfiguration: {
      purviewResourceId: purview_resourceId
    }
    sqlAdministratorLogin: sqlAdministratorLogin
    sqlAdministratorLoginPassword: sqlAdministratorLoginPassword
    managedResourceGroupName: synapse_managedResourceGroupName
  }
}

// Set firewall to allow everyone
resource synapse_workspace_allowAll 'Microsoft.Synapse/workspaces/firewallRules@2021-06-01' = {
  parent: synapse_workspace
  name: 'allowAll'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '255.255.255.255'
  }
}

// Grant sql control to managed identity
resource synapse_workspace_default 'Microsoft.Synapse/workspaces/managedIdentitySqlControlSettings@2021-06-01' = {
  parent: synapse_workspace
  name: 'default'
  properties: {
    grantSqlControlToManagedIdentity: {
      desiredState: 'Enabled'
    }
  }
}

resource synapse_sparkpool 'Microsoft.Synapse/workspaces/bigDataPools@2021-06-01' = {
  parent: synapse_workspace
  name: 'synapsespark'
  location: location
  properties: {
    nodeCount: 3
    nodeSizeFamily: 'MemoryOptimized'
    nodeSize: 'Small'
    autoScale: {
      enabled: true
      minNodeCount: 3
      maxNodeCount: 10
    }
    autoPause: {
      enabled: true
      delayInMinutes: 15
    }
    sparkVersion: '3.1'
  }
}

output synapse_name string = synapse_workspace.name
output synapse_managed_identity string = synapse_workspace.identity.principalId
