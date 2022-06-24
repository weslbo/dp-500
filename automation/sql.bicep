targetScope = 'resourceGroup'

@description('Please specify a location')
param location string = resourceGroup().location

@description('Please specify a username for the Azure SQL Server administrator (default "azureuser")')
param sqlAdministratorLogin string = 'azureuser'

@secure()
@description('Please specify a password for the Azure SQL Server administrator')
param sqlAdministratorLoginPassword string

var sql_servername = 'sqlserver-${uniqueString(resourceGroup().id)}'

// Azure SQL Server
resource sqlsvr 'Microsoft.Sql/servers@2021-11-01-preview' = {
  name: sql_servername
  location: location
  properties: {
    administratorLogin: sqlAdministratorLogin
    administratorLoginPassword: sqlAdministratorLoginPassword
  }
  resource firewall1 'firewallRules' = {
    name: 'allowAzure'
    properties: {
      startIpAddress: '0.0.0.0'
      endIpAddress: '0.0.0.0'
    }
  }
  resource firewall2 'firewallRules' = {
    name: 'allowAll'
    properties: {
      startIpAddress: '0.0.0.0'
      endIpAddress: '255.255.255.255'
    }
  }
}

// Azure SQL Database
resource sqldb_adventureworkslt 'Microsoft.Sql/servers/databases@2021-02-01-preview' = {
  parent: sqlsvr
  name: 'AdventureWorksLT'
  location: location
  sku: {
    name: 'GP_S_Gen5' // serverless
    tier: 'GeneralPurpose'
    family: 'Gen5'
    capacity: 1
  }
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    catalogCollation: 'SQL_Latin1_General_CP1_CI_AS'
    autoPauseDelay: 60
    requestedBackupStorageRedundancy: 'Local'
    sampleName: 'AdventureWorksLT'
  }
}

// Azure SQL Database
resource sqldb_adventureworksdwh 'Microsoft.Sql/servers/databases@2021-02-01-preview' = {
  parent: sqlsvr
  name: 'AdventureWorksDW2022-DP-500'
  location: location
  sku: {
    name: 'GP_S_Gen5' // serverless
    tier: 'GeneralPurpose'
    family: 'Gen5'
    capacity: 1
  }
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    catalogCollation: 'SQL_Latin1_General_CP1_CI_AS'
    autoPauseDelay: 60
    requestedBackupStorageRedundancy: 'Local'
  }
}

resource securityAlertPolicies 'Microsoft.Sql/servers/securityAlertPolicies@2021-11-01-preview' = {
  name: 'Default'
  parent: sqlsvr
  properties: {
    state: 'Enabled'
  }
}
