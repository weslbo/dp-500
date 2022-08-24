# This script will import the AdventureWorksDW2022-DP500.bacpac into the SQL Database
# Note, this might take some time before the import has finished.
# Tip: in the Azure Portal, navigate to the SQL (logical) Server, and observe the Import/Export history

$suffix=''
$sqlPassword = ""
$sqlPasswordSecure = $(ConvertTo-SecureString -String $sqlPassword -AsPlainText -Force)

Install-Module -name SqlServer
Connect-AzAccount # not sure if this is necessary when working with a managed identity?

# Retrieve storage account key
$storageAccountKey = "$(az storage account keys list --account-name datalake${suffix} --resource-group rg-dp-500-platform --query "[0].{value:value}" --output tsv)"

# Import datawarehouse into SQL
New-AzSqlDatabaseImport -ResourceGroupName rg-dp-500-platform -ServerName "sqlserver-${suffix}" -DatabaseName "AdventureWorksDW2022-DP-500" -StorageKeyType "StorageAccessKey" -StorageKey $storageAccountKey -StorageUri "https://datalake${suffix}.blob.core.windows.net/landing/Allfiles/00-Setup/DatabaseBackup/AdventureWorksDW2022-DP500.bacpac" -AdministratorLogin azureuser -AdministratorLoginPassword $sqlPasswordSecure -Edition "GeneralPurpose" -ServiceObjectiveName "GP_S_Gen5_1" -DatabaseMaxSizeBytes 10GB
