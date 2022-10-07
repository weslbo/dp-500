# Module 3: Model, query, and explore data in Azure Synapse

## Introduction to Azure Synapse Analytics [[learn module]](https://learn.microsoft.com/training/modules/introduction-azure-synapse-analytics)

- [x] Go to the [https://web.azuresynapse.net](https://web.azuresynapse.net) and sign in to your workspace.
- [x] Explore the home page
- [x] Explore the **Data** section. In the **linked** section, you should be able to browse the datalake, and navigate inside the **landing** container
- [x] Explore the **Develop** section. You should be able to see some pre-populated SQL Scripts and a Power BI section with nothing inside it.
- [x] Explore the **Integrate** section and notice some pipelines are already there. The pipeline_00_setupdata is for example used to copy various files into the datalake
- [x] Explore the **Monitor** section. If you did run a **pipeline** earlier, it should be visible. You can also look at the **SQL requests** that executed the last 24 hours
- [x] Explore the **Manage** section.
  - Here you can see we have a **Serverless SQL Pool** and we could create a **Dedicated SQL Pool** if we want.
  - We have already setup some **linked services** to various data sources. Explorer them.
  - Notice also that **Git configuration** has been setup. Point out that you should create a branch everytime you want to add something and create a pull request when finished. Lastly, you need to publish your changes.

## Use Azure Synapse serverless SQL pool to query files in a data lake  [[learn module]](https://learn.microsoft.com/training/modules/query-data-lake-using-azure-synapse-serverless-sql-pools)

Query a CSV file using the Serverless pool

- [x] Go to the **Data** section, navigate to the data lake \landing\adventureworks\tables\csv\ and choose any .csv file. Right-click, select TOP 100 records.
- [x] Navigate to the **Develop** section and open the **01_sql_serverless_csv** SQL Script. Walk through the file and execute each SQL statement individually.
  - Makes sure the datalake URL is correct
  - The first example just is a copy of the auto generated code. It has 2 issues:
    - Notice 1) column headers are not promoted
    - Notice 2) have a look at the messages: "Potential conversion error while reading VARCHAR column 'C1' from UTF8 encoded text. Change database collation to a UTF8 collation or specify explicit column schema in WITH clause and assign UTF8 collation to VARCHAR columns."
  - You will fix this by running the other scripts

Query a JSON file using the Serverless pool

- [x] Go back to the **Data** section, navigate to the data lake \landing\adventureworks\tables]\json\ and choose any .json file. Right-click, select TOP 100 records. Notice all the data is one line.
- [x] Navigate to the **Develop** section and open the **02_sql_serverless_json** SQL Script. Walk through the file and execute each SQL statement individually.

Query a Parquet file using the Serverless pool

- [x] Go back to the **Data** section, navigate to the data lake \landing\adventureworks\tables\parquet\ and choose any .parquet file. Right-click, select TOP 100 records.
- [x] Open the **03_sql_serverless_parquet** SQL Script. Walk through the file and execute each SQL statement individually.
  - Notice: We can specify our own column names to select and replace data types, this will improve performance

Create views and external tables

- [x] Create a database, external data source, external file format and external table using the Serverless pool
- [x] Open the **04_sql_serverless_views** SQL Script. Walk through the file and execute each SQL statement individually.
- [x] Open the **05_sql_serverless_external_tables** SQL Script. Walk through the file and execute each SQL statement individually.

## Analyze data with Apache Spark in Azure Synapse Analytics [[learn module]](https://learn.microsoft.com/training/modules/understand-big-data-engineering-with-apache-spark-azure-synapse-analytics)

Query a file using an Spark Notebook

- [x] Go to the **Data** section, navigate to the data lake \landing\adventureworks\tables\ and choose any .csv file. Right-click, select New Notebook > Load to dataframe.
- [x] Attach to Spark Pool and start when necessary

Use Spark SQL on the data just loaded and apply some filter on the data frame

- [x] Navigate to the **Develop** section and open the **\Module 02\01_query_csv** notebook. Explorer the notebook and execute each cell separately.

Create a chart on the resulting data

- [x] Explore the **02_create_charts** notebook and execute each cell separately.

## Analyze data in a relational data warehouse [[learn module]](https://learn.microsoft.com/training/modules/design-multidimensional-schema-to-optimize-analytical-workloads)

- [x] Create a dedicated pool (named DP500DWH) with a performance level of DW100c (watch out for cost $1,102.30/Average per month). Notice this can take a few minutes...
- [x] Explore 06_sql_dedicated_create_tables.sql to create some dimension, fact and staging tables.
- [x] Explore 07_sql_dedicated_load_data.sql to load some data using the COPY statement.
- [x] Explore 08_sql_date_dimension.sql to create a date dimension.
- [x] Query the data using GROUP BY and/or RANK
