# Create views and external tables in Azure Synapse Serverless SQL Pools

Let's explore a demo on how to create views and external tables in an Azure Synapse Serverless SQL Pool

## Demo 14 - external db

This requires you to execute a number of steps.

First, you create a custom database, just as you would in a regular SQL Server instance.

One consideration is to set the collation of your database so that it supports conversion of text data in files to appropriate Transact-SQL data types.

## Demo 15 - external data source

Next, you create an external data source that references a location in your data lake.

It can point to a specific container and even a folder or subfolder.

This would allow you to read in many files at the relative path.

Optionally, you can also create a database scoped credential, which enables you to provide access to data through SQL without permitting users to access the data directly in the storage account.

This database scoped credential could be configured with a shared access signature or you can use a managed identity.

## Demo 16 - external file format

Next, you would create an external file format, which would provide format details for the file being accessed.

For example, for a delimited text file format, you could specify the field terminator.

Here, we're relying once more on the parquet format. Once defined, you can re-use those external file formats later.

## Demo 17 - external table

Finally, you can create an external table, which users and reporting applications can query using a standard SQL SELECT statement just like any other database table.

The external table references the data source, the location and the file format we created earlier.

Notice that the external table itself does not contain any data, rather it is fetched from the data lake with every query.

## Demo 18 - views

Optionally, you can also create views directly on top of your files located in the data lake.

You would use again the openrowset function, just like before.

## Thanks

Thanks for watching!
