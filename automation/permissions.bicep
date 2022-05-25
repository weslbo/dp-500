targetScope = 'resourceGroup'

var rdPrefix = '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions'
var role = {
  Owner: '${rdPrefix}/8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
  Contributor: '${rdPrefix}/b24988ac-6180-42a0-ab88-20f7382dd24c'
  StorageBlobDataReader: '${rdPrefix}/2a2b9908-6ea1-4ae2-8e65-a410df84e7d1'
  StorageBlobDataContributor: '${rdPrefix}/ba92f5b4-2d11-453d-a403-e96b0029c9fe'
}

@description('Please specify the name of the data lake')
param datalake_name string

@description('Please specify the name of the synapse workspace account')
param synapse_name string

@description('Please specify the name of the purview account')
param purview_name string

// Need to reference existing storage account (data lake) in order to assign permission [Storage Blob Data Contributor] to managed identity
resource datalake 'Microsoft.Storage/storageAccounts@2021-09-01' existing = {
  name: datalake_name
}

resource synapse_workspace 'Microsoft.Synapse/workspaces@2021-06-01' existing = {
  name: synapse_name
}

resource purview 'Microsoft.Purview/accounts@2021-07-01' existing = {
  name: purview_name
}

// Synapse managed identity should become a Storage Blob Data Contributor 
resource rolesassignments_synapse_to_datalake 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid('synapse_to_datalake_${resourceGroup().name}')
  scope: datalake
  properties: {
    principalId: synapse_workspace.identity.principalId
    roleDefinitionId: role['StorageBlobDataContributor']
    principalType: 'ServicePrincipal'
  }
}

// Purview managed identity should become a Storage Blob Data Reader
resource rolesassignments_purview_to_datalake 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = {
  name: guid('purvie_to_datalake_${resourceGroup().name}')
  scope: datalake
  properties: {
    principalId: purview.identity.principalId
    roleDefinitionId: role['StorageBlobDataReader']
    principalType: 'ServicePrincipal'
  }
}
