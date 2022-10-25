# Module 6: Implement advanced data visualization techniques by using Power BI

## Understand advanced data visualization concepts [[learn module]](https://learn.microsoft.com/training/modules/understand-advanced-data-visualization-concepts)

- Show where to use find report theme, and how to customize it. Save it as a template .PBIT
- Demonstrate personalized visuals in Power BI Service (remember to configure the power bi Current file options because personalization is not enabled by default)
- Show where to configure alt text, tab order and tooltips

## Monitor data in real-time with Power BI [[learn module]](https://learn.microsoft.com/training/modules/monitor-data-real-time-power-bi)


### Demonstrate Power BI Service Dashboard realtime refresh
- Provision IoT Central app: https://apps.azureiotcentral.com/build/new/solar-panel-monitoring
- Create an Azure Event Hub namespace + event hub in your subscription. iotcentralsolarpanels
- Copy the connection string (RootManageSharedAccessKey), go back to IoT Central app and configure a data export.
- Wait a few minutes for it to become healthy.
- Create stream analytics job connecting to a Power BI workspace/dataset with following query
- Start the job and wait until started
- Create a dashboard in Power BI Service, consuming the telemetry data.

```sql
SELECT deviceId,
       EventProcessedUtcTime,
       telemetry.Efficiency,
       telemetry.EnergyAmountkWh,
       telemetry.NominalVoltage,
       telemetry.PanelStatus,
       telemetry.PowerAmountKW,
       telemetry.Temperature 
INTO [powerbi]
FROM [solarpanels]
```

### Demonstrate Power BI Desktop automatic page refresh

- [Auto page refresh.pbix](/demo/Module-06-assets/Auto%20Page%20Refresh.pbix): Demo on Automatic Page refresh
- [Configure Power BI Service Automatic page refresh](https://app.powerbi.com/admin-portal/ppuTenantSettings)

### Show how to create a streaming dataset

TODO

### Demonstrate paginated report autorefresh

TODO

## Create paginated reports [[learn module]](https://learn.microsoft.com/training/modules/create-paginated-reports-power-bi)

- [Paginated Report.rdl](/demo/Module-06-assets/Paginated%20Report.rdl): demo on paginated report against Azure SQL Database. This can be published to a PPU workspace in Power BI
