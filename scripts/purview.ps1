$suffix=''
$sqlPassword = ""
$sqlPasswordSecure = $(ConvertTo-SecureString -String $sqlPassword -AsPlainText -Force)

$purviewAccount = "purview-${suffix}"
$purviewEndpoint = "https://${purviewAccount}.purview.azure.com/"
$sqlEndpoint = "sqlserver-${suffix}.database.windows.net"
$keyvaultEndpoint = "https://keyvault-${suffix}.vault.azure.net/"

Install-Module -name Az.Purview
Install-Module -name SqlServer
Connect-AzAccount # not sure if this is necessary when working with a managed identity?

# Retrieve storage account key
$storageAccountKey = "$(az storage account keys list --account-name datalake${suffix} --resource-group rg-dp-500-platform --query "[0].{value:value}" --output tsv)"

# Import datawarehouse into SQL
New-AzSqlDatabaseImport -ResourceGroupName rg-dp-500-platform -ServerName "sqlserver-${suffix}" -DatabaseName "AdventureWorksDW2022-DP-500" -StorageKeyType "StorageAccessKey" -StorageKey $storageAccountKey -StorageUri "https://datalake${suffix}.blob.core.windows.net/landing/Allfiles/DatabaseBackup/AdventureWorksDW2022-DP500.bacpac" -AdministratorLogin azureuser -AdministratorLoginPassword $sqlPasswordSecure -Edition "GeneralPurpose" -ServiceObjectiveName "GP_S_Gen5_1" -DatabaseMaxSizeBytes 10GB

# Retrieve existing registered data sources from Purview
$datasources = (Get-AzPurviewDataSource -Endpoint $purviewEndpoint | Select-Object -ExpandProperty Name)

# If not exists, setup a Keyvault connection
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

    # $sql = "CREATE USER [${purviewAccount}] FROM EXTERNAL PROVIDER; EXEC sp_addrolemember 'db_owner', [${purviewAccount}]; CREATE MASTER KEY;"
    # Invoke-Sqlcmd -Query $sql -ServerInstance $sqlEndpoint -Database AdventureWorksLT -Username azureuser -Password $sqlPassword

    $sql_scan = New-AzPurviewAzureSqlDatabaseCredentialScanObject -Kind 'AzureSqlDatabaseCredential' -CollectionReferenceName $purviewAccount -CollectionType 'CollectionReference' -CredentialReferenceName 'sqlauth' -CredentialType 'SqlAuth' -DatabaseName 'AdventureWorksLT' -ScanRulesetName 'AzureSqlDatabase' -ScanRulesetType 'System' -ServerEndpoint $sqlEndpoint
    New-AzPurviewScan -Endpoint $purviewEndpoint -DataSourceName "AzureSQL" -Name "DataScan-AdventureWorksLT" -Body $sql_scan
}

# If not exists, setup an Azure Synapse source, configure and start a scan 
if ($datasources -NotContains "Synapses") {
    $synapse = New-AzPurviewAzureSynapseWorkspaceDataSourceObject -Kind "AzureSynapseWorkspace" -CollectionReferenceName $purviewAccount -CollectionType "CollectionReference" -DedicatedSqlEndpoint "synapse-${suffix}.sql.azuresynapse.net" -ServerlessSqlEndpoint "synapse-${suffix}-ondemand.sql.azuresynapse.net"
    New-AzPurviewDataSource -Endpoint $purviewEndpoint -Name "Synapses" -Body $synapse
}