# Module 7: Implement and manage an analytics environment

## Provide governance in a Power BI environment [[learn module]](https://learn.microsoft.com/training/modules/power-bi-admin-governance)

- Show where to configure tenant settings [here](https://app.powerbi.com/admin-portal/tenantSettings)
- Deploy a custom organizational visual [here](https://app.powerbi.com/admin-portal/organizationVisuals)
- Show embed codes (first publish a report to web from within power bi service, then copy embed code and use private window), then consult embed code and revoke it [here](https://app.powerbi.com/admin-portal/embedCodes)
- Show where to set up custom help and support menu in the Power BI tenant [here](https://app.powerbi.com/admin-portal/tenantSettings)

## Facilitate collaboration and sharing in Power BI [[learn module]](https://learn.microsoft.com/training/modules/power-bi-admin-collaboration)

- Demonstrate creation of a workspace
- Show how to add a user/group and assign a role
- Create an app and share it with some people
- Show where to configure the data privacy isolation levels

## Monitor and audit usage [[learn module]](https://learn.microsoft.com/training/modules/power-bi-admin-monitor)

- Have a look at the usage metrics in the Admin portal [here](https://app.powerbi.com/admin-portal/usageMetrics)
- View the metrics for a specific report
- Consult the audit logs in the Admin portal [here](https://app.powerbi.com/admin-portal/auditLogs)
- Consult the audit logs in Powershell:

```pwsh
Install-Module -Name MicrosoftPowerBIMgmt

Connect-PowerBIServiceAccount

Get-PowerBIActivityEvent -StartDateTime 2022-10-12T00:00:00 -EndDateTime 2022-10-12T20:00:00   #cannot span multiple UTC days

Get-PowerBIActivityEvent -StartDateTime 2022-10-12T00:00:00 -EndDateTime 2022-10-12T20:00:00 | ConvertFrom-Json | Format-Table -AutoSize

Get-PowerBIActivityEvent -StartDateTime 2022-10-12T00:00:00 -EndDateTime 2022-10-12T20:00:00 | ConvertFrom-Json | Select CreationTime, UserId, ClientIP, Activity, IsSuccess, ItemName, WorkspaceName, DataSetName | Format-Table -AutoSize
```

## Provision Premium capacity in Power BI [[learn module]](https://learn.microsoft.com/training/modules/power-bi-admin-premium)

- Show how to configure BYOK in Power BI/Azure Key Vault [here](https://learn.microsoft.com/en-us/power-bi/enterprise/service-encryption-byok)

## Establish a data access infrastructure in Power BI [[learn module]](https://learn.microsoft.com/training/modules/power-bi-admin-infrastructure)

- Show how to install/configure the on-premises gateway
- Setup a dataset to refresh over the gateway
- Consult the logs
- Show who can use the gateway

## Broaden the reach of Power BI [[learn module]](https://learn.microsoft.com/training/modules/power-bi-admin-reach)

- Show how to setup a Power BI Embedded capacity [here](https://portal.azure.com/?feature.customportal=false#create/Microsoft.PowerBIDedicated), create also a workspace in the embedded capacity and then pause it. (When the service is paused the embedded content will not load, and you will not be charged for the service.)
- Create a dataflow
- Install a template app [Power BI Release plan app](https://appsource.microsoft.com/en-us/product/power-bi/pbicat.powerbi-release-plan?tab=overview)
- Show where to find the Power BI REST API in the docs [here](https://learn.microsoft.com/en-us/rest/api/power-bi/)
- Show the use of Logic App in Azure and us it to refresh / get data from a dataset

![image](/demo/Module-07-assets/Logic%20App.png)

```dax
EVALUATE VALUES(GetDateFromSQLServerDirectQuery)
```

- Show where to find the Power BI CmdLets in the docs [here](https://learn.microsoft.com/en-us/powershell/power-bi/overview?view=powerbi-ps)
- Install CmdLets and login to the Power BI tenant

```pwsh
Install-Module -Name MicrosoftPowerBIMgmt

Connect-PowerBIServiceAccount

Get-PowerBIDataset -Scope Organization | Format-Table -AutoSize

Get-PowerBIDatasource -DatasetId b5a9d5fd-afe2-4271-82e5-252a4fd72f85 -Scope Organization | Select ConnectionDetails | ConvertTo-Json
```

## Automate Power BI administration [[learn module]](https://learn.microsoft.com/training/modules/power-bi-admin-automate)
