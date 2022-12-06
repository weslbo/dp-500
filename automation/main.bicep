// setting target scope to 'subscription'
targetScope = 'subscription'

@description('Please specify a location')
param location string = deployment().location

@description('Please specify a username for the Azure SQL Server administrator (default "azureuser")')
param sqlAdministratorLogin string = 'azureuser'

@secure()
@description('Please specify a password for the Azure SQL Server administrator')
param sqlAdministratorLoginPassword string

@description('Specifies the object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault. The object ID must be unique for the list of access policies. Get it by using Get-AzADUser or Get-AzADServicePrincipal cmdlets.')
param userObjectId string

resource rg_platform 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-dp-500-platform'
  location: location
}

// resource rg_infra 'Microsoft.Resources/resourceGroups@2021-04-01' = {
//   name: 'rg-dp-500-infra'
//   location: location
// }

// deploy datalake using module
module datalake 'datalake.bicep' = {
  name: 'datalake-deployment'
  scope: rg_platform
  params: {
    location: location
  }
}

module synapse 'synapse.bicep' = {
  name: 'synapse-deployment'
  scope: rg_platform
  params: {
    location: location
    sqlAdministratorLogin: sqlAdministratorLogin
    sqlAdministratorLoginPassword: sqlAdministratorLoginPassword
    dfs_endpoint: datalake.outputs.dfs_endpoint
    purview_resourceId: purview.outputs.purview_resourceId
  }
}

module purview 'purview.bicep' = {
  name: 'purview-deployment'
  scope: rg_platform
  params: {
    location: location
  }
}

module sql 'sql.bicep' = {
  name: 'sql-deployment'
  scope: rg_platform
  params: {
    location: location
    sqlAdministratorLogin: sqlAdministratorLogin
    sqlAdministratorLoginPassword: sqlAdministratorLoginPassword
  }
}

module permissions 'permissions.bicep' = {
  name: 'permissions-deployment'
  scope: rg_platform
  params: {
    datalake_name: datalake.outputs.datalake_name
    synapse_name: synapse.outputs.synapse_name
    purview_name: purview.outputs.purview_name
    userObjectId: userObjectId
  }
}

module keyvault 'keyvault.bicep' = {
  name: 'keyvault-deployment'
  scope: rg_platform
  params: {
    location: location
    purview_managed_identity: purview.outputs.purview_managed_identity
    synapse_managed_identity: synapse.outputs.synapse_managed_identity
    sqlAdministratorLoginPassword: sqlAdministratorLoginPassword
  }
}

// module vmpowerbi 'infra.bicep' = {
//   name: 'infra-deployment'
//   scope: rg_infra
//   params: {
//     location: location
//     sqlAdministratorLogin: sqlAdministratorLogin
//     sqlAdministratorLoginPassword: sqlAdministratorLoginPassword
//   }
// }
