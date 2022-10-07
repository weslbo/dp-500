# Module 4: Prepare data for tabular models in Power BI

## Choose a Power BI model framework [[learn module]](https://learn.microsoft.com/training/modules/choose-power-bi-model-framework)

- Slide: Describe Power BI Fundamentals
  - [x] **Data model**: Open [demo/Module-04-assets/Adventure Works DW 2020.pbix] and navigate to the **Model view**. This represents a data model.
  - [x] **Power BI dataset**: Publish the .pbix file into a Power BI Workspace and navigate to the dataset
  - [x] **Analytic query**: An analytic query has three phases that are executed in this order. 1) Filter, 2) Group and 3) Summarize
    - [x] Add a slicer [Date | Fiscal] to the page and create a column chart with [Product | Model] and [Sales | Sales Amount] on it
  - [x] **Star schema design**: Navigate back to the diagram view and zoom into fact tables/dimension tables
  - [x] **Table storage mode**: Open the advanced settings for the fact table and locate where to find the table storage mode
  - [x] **Model framework**: Can't demo as it would also involve importing data

- Slide: Import model limitations
  - [x] **Model size**
    - Navigate to the Power BI [My Workspace] and open the [settings](https://app.powerbi.com/groups/me/managestorage)
        ![image](/demo/Module-04-assets/Manage%20personal%20storage.png)
    - Navigate to a Premium workspace and open the [Manage group storage] from the settings menu
        ![image](/demo/Module-04-assets/Manage%20Workspace%20storage.png)
    - Navigate to a Premium workspace, select a dataset and open the settings. Look for the setting [Large dataset storage format]
        ![image](/demo/Module-04-assets/Large%20dataset%20storage%20format.png)
  - [x] **Data Refresh**
    - Navigate to the workspace, select a dataset and open the settings. Look for the scheduled refresh settings.
- Slide: Determine when to develop a DirectQuery model
  - [x] Open [/demo/Module-04-assets/AdventureWorksDW2022-DP-500-DirectQuery.pbix]
  - [x] Create a few charts and use performance analyzer. Here you can prove that each visual will send a query to the database (copy the statement)
    ![image](/demo/Module-04-assets/DirectQuerySQLPerformanceAnalyzer.png)
- Slide: DirectQuery model limitations
  - [x] All Power Query (M) transformations are not possible.
    - Open [/demo/Module-04-assets/AdventureWorksDW2022-DP-500-DirectQuery.pbix]
    - Open the Power Query Editor and try to perform a transformation:
      - DimProduct | ProductAlternateKey -> Split column by delimiter (accept the default options)
      - Notice the error message
      ![image](/demo/Module-04-assets/DirectQueryTransformNotSupported.png)
- Slide: Determine when to develop a composite model
  - [x] Open [/demo/Module-04-assets/AdventureWorksDW2022-DP-500-Composite.pbix]. It has the dimension tables imported and the fact tables as direct query.

## Understand scalability in Power BI [[learn module]](https://learn.microsoft.com/training/modules/understand-scalability-power-bi)

- Slide: Use the large dataset feature. Show where to configure Large dataset format storage (for a single dataset and for all datasets in the workspace)
  - [x] Open Power BI Service, navigate to a premium workspace, select a dataset set and open the settings. Locate the Large dataset format option.
    ![image](/demo/Module-04-assets/Large%20dataset%20storage%20format.png)
  - [x] Open a Power BI Premium workspace and open the settings for the workspace
    ![image](/demo/Module-04-assets/PremiumWorkspaceLargeDatasetFormat.png)

## Create and manage scalable Power BI dataflows [[learn module]](https://learn.microsoft.com/training/modules/create-manage-scalable-power-bi-dataflows)
