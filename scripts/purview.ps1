$suffix=''

$purviewAccount = "purview-${suffix}"
$purviewEndpoint = "https://${purviewAccount}.purview.azure.com/"
$sqlEndpoint = "sqlserver-${suffix}.database.windows.net"
$keyvaultEndpoint = "https://keyvault-${suffix}.vault.azure.net/"

Install-Module -name Az.Purview
Install-Module -name SqlServer
Connect-AzAccount # not sure if this is necessary when working with a managed identity?

# Retrieve existing registered data sources from Purview
$datasources = (Get-AzPurviewDataSource -Endpoint $purviewEndpoint | Select-Object -ExpandProperty Name)

# If not exists, setup a Keyvault connection
# This will be required in order to retrieve credentials
$keyvaultConnections = (Get-AzPurviewKeyVaultConnection -Endpoint $purviewEndpoint | Select-Object -ExpandProperty Name)
if ($keyvaultConnections -NotContains "KeyVaultConnection") {
    $kvConn = New-AzPurviewAzureKeyVaultObject -BaseUrl $keyvaultEndpoint -Description 'Connection to Key Vault'
    New-AzPurviewKeyVaultConnection -Endpoint $purviewEndpoint -KeyVaultName "KeyVaultConnection" -Body $kvConn
}

# If not exists, setup a DataLake source, configure and start a scan on it
if ($datasources -NotContains "DataLake") {
    $adls = New-AzPurviewAdlsGen2DataSourceObject -Kind "AdlsGen2" -CollectionReferenceName $purviewAccount -CollectionType "CollectionReference" -Endpoint "https://datalake${suffix}.dfs.core.windows.net"
    New-AzPurviewDataSource -Endpoint $purviewEndpoint -Name "DataLake" -Body $adls

    $adls_scan = New-AzPurviewAdlsGen2MsiScanObject -Kind "AdlsGen2Msi" -CollectionReferenceName $purviewAccount -CollectionType "CollectionReference" -ScanRulesetName "AdlsGen2" -ScanRulesetType "System"
    New-AzPurviewScan -Endpoint $purviewEndpoint -DataSourceName "DataLake" -Name "DataScan-${suffix}" -Body $adls_scan
    
    $adls_scan_runid = New-Guid
    Start-AzPurviewScanResultScan -Endpoint $purviewEndpoint -DataSourceName "DataLake" -ScanName "DataScan-${suffix}" -ScanLevel 'Full' -RunId $adls_scan_runid    
}

# If not exists, setup an Azure SQL database source, configure and start a scan on AdventureWorks
if ($datasources -NotContains "AzureSQL") {
    $sql = New-AzPurviewAzureSqlDatabaseDataSourceObject -Kind "AzureSqlDatabase" -CollectionReferenceName $purviewAccount -CollectionType "CollectionReference" -ServerEndpoint $sqlEndpoint
    New-AzPurviewDataSource -Endpoint $purviewEndpoint -Name "AzureSQL" -Body $sql

    # Before you set up your scan, we have to create a new credential
    # Unfortunatly, there is no PowerShell command available yet. 
    # Check out https://docs.microsoft.com/en-us/powershell/module/az.purview/?view=azps-8.0.0#purview
    # So, we need to manually create the credential in Azure Purview
    # - Name: sqlauth
    # - Authentication method: SQL Authentication
    # - Username: azureuser
    # - Password: <keyvault connection>
    # - Secret name: sqlpassword
    # - Secret version: use latest version

    $AdventureWorksLT_scan = New-AzPurviewAzureSqlDatabaseCredentialScanObject -Kind 'AzureSqlDatabaseCredential' -CollectionReferenceName $purviewAccount -CollectionType 'CollectionReference' -CredentialReferenceName 'sqlauth' -CredentialType 'SqlAuth' -DatabaseName 'AdventureWorksLT' -ScanRulesetName 'AzureSqlDatabase_AdventureWorksLT' -ScanRulesetType 'System' -ServerEndpoint $sqlEndpoint
    $AdventureWorksDW_scan = New-AzPurviewAzureSqlDatabaseCredentialScanObject -Kind 'AzureSqlDatabaseCredential' -CollectionReferenceName $purviewAccount -CollectionType 'CollectionReference' -CredentialReferenceName 'sqlauth' -CredentialType 'SqlAuth' -DatabaseName 'AdventureWorksDW2022-DP-500' -ScanRulesetName 'AzureSqlDatabase_AdventureWorksDWH' -ScanRulesetType 'System' -ServerEndpoint $sqlEndpoint

    New-AzPurviewScan -Endpoint $purviewEndpoint -DataSourceName "AzureSQL" -Name "DataScan-AdventureWorksLT" -Body $AdventureWorksLT_scan
    New-AzPurviewScan -Endpoint $purviewEndpoint -DataSourceName "AzureSQL" -Name "DataScan-AdventureWorksDWH" -Body $AdventureWorksDW_scan

    $db_lt_scan_runid = New-Guid
    $db_dwh_scan_runid = New-Guid

    Start-AzPurviewScanResultScan -Endpoint $purviewEndpoint -DataSourceName "AzureSQL" -ScanName "DataScan-AdventureWorksLT" -ScanLevel 'Full' -RunId $db_lt_scan_runid
    Start-AzPurviewScanResultScan -Endpoint $purviewEndpoint -DataSourceName "AzureSQL" -ScanName "DataScan-AdventureWorksDWH" -ScanLevel 'Full' -RunId $db_dwh_scan_runid
}

# If not exists, setup an Azure Synapse source, configure and start a scan 
if ($datasources -NotContains "Synapses") {
    $synapse = New-AzPurviewAzureSynapseWorkspaceDataSourceObject -Kind "AzureSynapseWorkspace" -CollectionReferenceName $purviewAccount -CollectionType "CollectionReference" -DedicatedSqlEndpoint "synapse-${suffix}.sql.azuresynapse.net" -ServerlessSqlEndpoint "synapse-${suffix}-ondemand.sql.azuresynapse.net"
    New-AzPurviewDataSource -Endpoint $purviewEndpoint -Name "Synapse" -Body $synapse

    $synapse_credential = New-AzPurviewAzureSynapseWorkspaceCredentialScanObject -Kind 'AzureSynapseWorkspaceCredential' -CollectionReferenceName $purviewAccount -CollectionType 'CollectionReference' -CredentialReferenceName 'sqlauth' -CredentialType 'SqlAuth' -ScanRulesetName 'AzureSynapseSQL' -ScanRulesetType 'System'

    # TODO
}