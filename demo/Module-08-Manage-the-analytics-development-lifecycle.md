# Module 8: Manage the analytics development lifecycle

## Build reports using Power BI within Azure Synapse Analytics [[learn module]](https://learn.microsoft.com/training/modules/build-reports-using-power-bi-azure-synapse-analytics)

## Design a Power BI application lifecycle management strategy [[learn module]](https://learn.microsoft.com/training/modules/design-power-bi-application-lifecycle-management-strategy)

- Demonstrate how to setup a deployment pipeline and deploy reports/datasets to test. Change the connection string

## Create and manage a Power BI deployment pipeline [[learn module]](https://learn.microsoft.com/training/modules/power-bi-deployment-pipelines)

- Explore the lineage view

## Create and manage Power BI assets [[learn module]](https://learn.microsoft.com/training/modules/create-manage-power-bi-assets)

- Enable read-write connectivity for a PPU workspace: [here](https://app.powerbi.com/admin-portal/ppuTenantSettings)
- Grab the workspace connection URL: powerbi://api.powerbi.com/v1.0/myorg/DP-500%20ppu
- Open SQL Server Management Studio and connect to the workspace
- Unlike configuring refresh in the POwer BI service, refresh operations throught the XMLA endpoint are not limited to 45 refreshes per day, and the scheduled refresh timeout is not imposed!

![image](/demo/Module-08-assets/xmla.png)