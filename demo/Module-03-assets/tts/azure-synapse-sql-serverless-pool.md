# Use Azure Synapse serverless SQL pool to query files in a data lake

Let's explore how we can query data files like delimited text files, JSON files and Parquet files, using serverless SQL Pools.

## 10 - CSV File

We start by navigating back to the Synapse Studio, and open the Data hub.

Since the files are located in our data lake, we need to open the linked services tab.

In this data lake, we have a number of containers like this landing zone.

We browse the different folders until we find a set of delimited text files that we want to analyze.

We can get a preview of the data.

Next, we will right click on the file to select the top 100 records.

This generates a T-SQL statement that uses the openrowset function.

As we can see, the location of the file is configured as a parameter, as well as the CSV format.

When we run this statement, we observe in this particular demo that the headers don't seem to be correct.

Secondly, when we look at the messages, we get all kinds of potential conversion errors while reading varchar columns.

This is because the files that we're working with in this demo, are encoded with UTF 16 and not with UTF 8.

## 11 - Fix issues

We can fix the header problem by configuring the header row parameter in the openrowset function.

As we run this statement, notice that the header information is now correct.

The UTF encoding problem can be solved as well, but requires you to specify the data types for each of the fields.

So, in the next T-SQL statement, we modified the query to include all the field names and their corresponding data types.

Notice that we use N VARCHAR instead of VARCHAR.

## 12 - JSON

Let's go back and explore some other file formats.

JSON or Javascript Object Notation Files require some special handling.

If we open up the preview of one of these files, we notice that there are all kinds of curly brackets, key-value pairs and so on.

Let's generate a T-SQL Script the same way as we did before.

Notice that the openrowset function still uses the CSV format parameter.

When we run the statement, we observe we only get one row, containing all the data.

This is clearly not what we want.

To fix this, we have to explicitly define the column names and make use of the JSON VALUE function.

Notice that the resulting data is now correct.

We can also specify our own data types, just like before.

For this, we need to make use of the CROSS APPLY OPEN JSON function.

Optionally, we can override the name of a column as well.

## 13 - Parquet

For the final file format, we are going to have a look at parquet files.

Apache Parquet is a file format designed to support fast data processing for complex data.

It is self-describing in the sense that it already contains schema information.

Parquet files are also highly optimized in terms of storage, as it is column-oriented – meaning the values of each table column are stored next to each other, rather than those of each record.

We can also improve the performance by only selecting the fields we want to be returned.

Again, since parquet is column-oriented, it can do this very efficiently.

## Thanks

Thanks for watching!
