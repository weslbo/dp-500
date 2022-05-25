# deployment

```bash
read -s "password?Password for SQL Admin:?"

az deployment sub create --name dp-500-demo-deployment-uksouth --location uksouth --template-file main.bicep --parameters sqlAdministratorLoginPassword=$password
```

Regions that should work:

- "australiaeast"
- "northeurope"
- "southeastasia"
- "uksouth"
- "westeurope"
- "westus"
- "westus2"
