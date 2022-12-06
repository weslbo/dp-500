# deployment

In order to deploy the demo environment, execute the following commands:

```bash
az provider register --namespace 'Microsoft.Purview'
az provider register --namespace 'Microsoft.Storage'
az provider register --namespace 'Microsoft.EventHub'

read -s "password?Password for SQL Admin:?"

USEROBJECTID=$(az ad signed-in-user show --query id -o tsv)
EMAIL=$(az ad signed-in-user show --query mail -o tsv)

az deployment sub create --name dp-500-demo-deployment-uksouth --location uksouth --template-file main.bicep --parameters sqlAdministratorLoginPassword=$password userObjectId=$USEROBJECTID

az deployment group create --name dp-500-powerbiembedded  --resource-group rg-dp-500-platform --template-file powerbiembedded.bicep --parameters admin=$EMAIL
```

This will deploy the following resources:

| **Resource Group**  | **Resource**  | **Notes**  |
|---|---|---|
| rg-dp-500-platform  |  datalake-xxxxxx | Azure Storage account with hierarchical namespace. Following default containers will be added [analytics], [conformance], [dataproducts], [landing], [standardized], [synapse] |
| rg-dp-500-platform  |  synapse-xxxxxx | Azure Synapse account is linked to Purview and to a Git repo containing various assets |
| rg-dp-500-platform  |  purview-xxxxxx | Azure Purview account  |
| rg-dp-500-platform  |  AdventureWorksDW2022-DP-500 |  SQL Database (currently empty, should be imported from bacpac) |
| rg-dp-500-platform  |  AdventureWorksLT |  SQL Database (sample database) |
| rg-dp-500-platform  |  keyvault-xxxxxx |  Azure KeyVault with sqlpassword. Purview and Synapse managed identities have access |

Permissions (automatically configured):

- Synapse managed identity becomes a Storage Blob Data Contributor
- Current user becomes a Storage Blob Data Contributor
- Purview managed identity becomes a Storage Blob Data Reader

Manual steps:

- Grant the Synapse workspace's managed identity Data Curator role on your Microsoft Purview root collection. (currently not possible to automate this)
