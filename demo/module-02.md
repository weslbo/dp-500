# Module 02: Model, query, and explore data in Azure Synapse

## Microsoft Learn Modules

- [Introduction to Azure Synapse Analytics](https://docs.microsoft.com/learn/modules/introduction-azure-synapse-analytics/)
- [Use Azure Synapse serverless SQL pool to query files in a data lake](https://docs.microsoft.com/learn/modules/query-data-lake-using-azure-synapse-serverless-sql-pools/)
- [Analyze data with Apache Spark in Azure Synapse Analytics](https://docs.microsoft.com/learn/modules/understand-big-data-engineering-with-apache-spark-azure-synapse-analytics/)
- [Analyze data in a relational data warehouse](https://docs.microsoft.com/learn/modules/design-multidimensional-schema-to-optimize-analytical-workloads/)

## Labs

- [Query files using a serverless SQL pool](https://aka.ms/mslearn-synapse-sql)
- [Analyze data with Spark](https://aka.ms/mslearn-synapse-spark)
- [Explore a relational data warehouse](https://aka.ms/mslearn-synapse-dw)

## Demos

### Demo: Explore the Azure Synapse Studio

- [x] Go to the [https://web.azuresynapse.net](https://web.azuresynapse.net) and sign in to your workspace.
- [x] Explore the home page
- [x] Explore the **Data** section. In the **linked** section, you should be able to browse the datalake, and navigate inside the **landing** container
- [x] Explore the **Develop** section. You should be able to see some pre-populated SQL Scripts and a Power BI section with nothing inside it.
- [x] Explore the **Integrate** section and notice some pipelines are already there. The pipeline_00_setupdata is for example used to copy various files into the datalake
- [x] Explore the **Monitor** section. If you did run a pipeline earlier, it should be visible. You can also look at the SQL requests that executed the last 24 hours
- [x] Explore the **Manage** section. Here you can see we have a Serverless SQL Pool and we could create a Dedicated SQL Pool if we want. We have already setup some linked services to various data sources. Explorer them. Notice also that Git configuration has been setup. Point out that you should create a branch everytime you want to add something and create a pull request when finished. Lastly, you need to publish your changes.

### Demo: Serverless

Query a CSV file using the Serverless pool
  - Go to the **Data** section, navigate to the data lake \landing\allfiles\01\data\ and choose any .csv file. Right-click, select TOP 100 records.
  - Navigate to the **Develop** section and open the **sql_serverless_csv** SQL Script. Walk through the file and execute each SQL statement individually.
- Query a JSON file using the Serverless pool
  - Go back to the **Data** section, navigate to the data lake \landing\allfiles\01\data\ and choose any .json file. Right-click, select TOP 100 records. Notice all the data is one line.
  - Navigate to the **Develop** section and open the **sql_serverless_json** SQL Script. Walk through the file and execute each SQL statement individually.
- Query a Parquet file using the Serverless pool
  - Open the **sql_serverless_parquet** SQL Script. Walk through the file and execute each SQL statement individually.
- Create a database, external data source, external file format and external table using the Serverless pool
  - Open the **sql_serverless_views** SQL Script. Walk through the file and execute each SQL statement individually.
  - Open the **sql_serverless_external_tables** SQL Script. Walk through the file and execute each SQL statement individually.

### Demo: Spark

- Query a file using an Spark Notebook
  - Go to the **Data** section, navigate to the data lake \landing\allfiles\01\data\ and choose any .csv file. Right-click, select New Notebook > Load to dataframe.
  - Attach to Spark Pool and start when necessary
- Apply some filtering on the dataframe
- Use Spark SQL on the data just loaded
- Create a chart on the resulting data

### Demo: Dedicated pool

- Create a dedicated pool
- Create some dimension, fact and staging tables
- Load some data using the COPY statement
- Query the data using GROUP BY and/or RANK
