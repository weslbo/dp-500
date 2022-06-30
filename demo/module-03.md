# Module 3: Model, query, and explore data in Azure Synapse

## Usefull links

- Learning path: [Model, query, and explore data in Azure Synapse](https://docs.microsoft.com/en-us/learn/paths/model-query-explore-data-for-azure-synapse/)
- Lab: [Query files using a serverless SQL pool](https://microsoftlearning.github.io/DP-500-Azure-Data-Analyst/Instructions/labs/01-analyze-data-with-sql.html) (40 min)
- Lab: [Analyze data in a data lake with Spark](https://microsoftlearning.github.io/DP-500-Azure-Data-Analyst/Instructions/labs/02-analyze-files-with-Spark.html) (45 min)
- Lab: [Explore a relational data warehouse](https://microsoftlearning.github.io/DP-500-Azure-Data-Analyst/Instructions/labs/03-Explore-data-warehouse.html) (45 min)

## Topics covered

- Introduction to Azure Synapse Analytics
  - What is Azure Synapse Analytics and how does it work?
  - When to use it
- Implement star schema design and query relational data in Azure
  - Design a data warehouse schema
    - Dimension and Fact tables
    - Data warehouse schema designs (star schema, snowflow schema)
  - Create data warehouse tables
    - Creating a dedicated SQL pool
    - Considerations for creating tables (Data integrity constraints, Indexes, Distribution)
    - Creating dimension tables
    - Time dimension tables
    - Creating fact tables
    - Creating staging tables (Using external tables)
  - Load data warehouse tables
    - Loading data into staging tables
    - Loading staged data into dimension tables
      - Using a CREATE TABLE AS (CTAS) statement
      - Using an INSERT statement
      - Loading time dimension tables
      - Updating dimension tables (SCD Type 0, 1 and 2)
    - Loading staged data into fact tables
    - Post-load optimization
  - Query a data warehouse
    - Aggregating measures by dimension attributes
    - Joins in a snowflake schema
    - Using ranking functions
    - Retrieving an approximate count
- Analyze data with a serverless SQL pool in Azure Synapse Analytics
  - Understand Azure Synapse serverless SQL pool capabilities and use cases
    - When to use serverless SQL pools
  - Query files using a serverless SQL pool
    - Querying delimited text files
    - Specifying the rowset schema
    - Querying JSON files
    - Querying Parquet files
    - Query partitioned data
  - Create external database objects
    - Creating a database
    - Creating an external data source
    - Creating an external file format
    - Creating an external table
- Optimize data warehouse query design
- Analyze data with a Spark Pool in Azure Synapse Analytics
  - How Spark works
  - Spark pools in Azure Synapse Analytics
  - Running Spark code in notebooks
  - Accessing data from a Synapse Spark pool
  - Exploring data with dataframes
  - Filtering and grouping dataframes
  - Using SQL expressions in Spark
  - Using the Spark SQL API to query data
  - Using SQL code
  - Using built-in notebook charts
  - Using graphics packages in code
