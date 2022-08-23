# DP-500 for trainers

Welcome to this repository, targeted to trainers delivering DP-500. It provides a number of usefull resources:

First of all, there is a [set of Bicep templates](/automation/readme.md), allowing you to deploy a DEMO Azure environment for DP-500. It contains the following resources:

- A [Virtual Machine](/automation/infra.bicep) with Power BI Desktop, Report Builder, DAX Studio, Tabular Editor, Data Gateway already installed, as well as a set of lab and demo files from github repos
- A SQL Server Virtual Machine
- An [Azure Synapse Analytics](/automation/synapse.bicep) environment, configured with a number of pipelines (copy data) and scripts (to demo)
- A few Azure [SQL Databases](/automation/sql.bicep) on the serverless tier (AdventureWorksLT and AdventureWorksDW2022-DP-500)
- An Azure [Data Lake](/automation/datalake.bicep) with some containers
- A Microsoft [Purview account](/automation/purview.bicep), with some [scripts](/scripts/purview.ps1) to register the above datasources and start a scan
- Supporting resources like [KeyVault](/automation/keyvault.bicep), a VNET and various [role assignments](/automation/permissions.bicep)

In order to deploy this environment, check out [this page](/automation/readme.md).

Next, there is a set of [demo's and usefull resources](/demo/readme.md) for each module.

- [Module 00: Introduction to data analytics on Azure](/demo/module-00.md)
- [Module 01: Govern data across an enterprise](/demo/module-01.md)
- [Module 02: Model, query, and explore data in Azure Synapse](/demo/module-02.md)
- [Module 03: Prepare data for tabular models in Power BI](/demo/module-03.md)
- [Module 04: Design and build tabular models](/demo/module-04.md)
- [Module 05: Implement advanced data visualization techniques by using Power BI](/demo/module-05.md)
- [Module 06: Implement and manage an analytics environment](/demo/module-06.md)
- [Module 07: Manage the analytics development lifecycle](/demo/module-07.md)
