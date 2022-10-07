# Analyze data in a relational data warehouse

Let's explore how to analyze data in a relational data warehouse.

## Create dedicated SQL Pool

The simplest way to create a dedicated SQL pool, is to navigate to the manage hub in the Azure Synapse Studio. When provisioning a dedicated SQL pool, you can specify a unique name for the dedicated SQL pool. The performance level for the SQL pool, can range from DW 100 to DW 30000. It determines the cost per hour for the pool when it's running. Remember that you can pause the pool if you do no need it, to prevent unnecessary costs. Usually, you will start with an empty pool, but you can also restore an existing database from a backup. The collation of the SQL pool, determines sort order and string comparison rules for the database. You can't change the collation after creation.

## Create tables

To create tables in the dedicated SQL pool, you use the CREATE TABLE T-SQL statement. Notice it is very similar to creating tables in relational database systems like SQL Server. However, there are some key differences. For example. dedicated SQL pools in Synapse Analytics don't support foreign key and unique constraints. Azure Synapse Analytics dedicated SQL pools use a massively parallel processing, or MPP architecture, in which data can be distributed using a hash, round-robin or replicated.

## Create fact tables

For fact tables, the recommendation is to use hash distribution with clustered column store index to distribute the data from the fact table across compute nodes. The algorithm is deterministic, which means it always hashes the same value to the same distribution.

## Create dimension tables

For the dimension tables, the recommendation is to use replicated distribution, because dimension tables are usually smaller tables. This also avoids data having to be shuffled when joining to distributed fact tables. If tables are too large to store on each compute node, use hash distribution.

## Load data

Staging tables are used as temporary storage for data as it's being loaded into the data warehouse. A typical pattern is to structure the table to make it as efficient as possible to ingest the data from its external source (often files in a data lake) into the relational database, and then use SQL statements to load the data from the staging tables into the dimension and fact tables. For staging tables, you can use round-robin distribution to evenly distribute data across compute nodes. This will also ensure data load operations to be as fast as possible.

## Thanks

Thanks for watching!
