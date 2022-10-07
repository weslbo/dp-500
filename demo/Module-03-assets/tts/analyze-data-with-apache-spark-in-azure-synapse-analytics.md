# Analyze data with Apache Spark in Azure Synapse Analytics

Let's see a few examples and explore how we can analyze data with Spark.

## 19 - Analyze data with Spark

You can start very easily by navigating to a file in your data lake, and create a notebook that will load the data into a dataframe. Spark DataFrames are the distributed collections of data organized into rows and columns. The actual load of the data into memory is deferred until an action takes place, for example when call the display function. Note that when we execute the cell in the notebook, the first time it will take some time as the spark pool needs to start.

In the next example, we will read a number of CSV delimited text files from our data lake. The notebook has been set up with multiple cells, including markdown cells that contains descriptive information. Notice we can use a wildcard to read in multiple files at once. Next, we want to explore the schema, but as we can see, there is currently no header information available. So, let's define our own explicit schema.

The Dataframe API is part of a Spark library named Spark SQL, which enables data analysts to use SQL expressions to query and manipulate data. One of the simplest ways to make data in a dataframe available for querying in the Spark SQL is to create a temporary view. The view is temporary, meaning that it's automatically deleted at the end of the current session. You can also create tables that are persisted in the catalog to define a database that can be queried using Spark SQL. Once defined, you can use the SQL magic to run SQL code like demonstrated here. We are search for all the customers that have a name staring with the uppercase letter E.

We can also apply grouping and mathematical operations like sum.

## 20 - Visualize with spark

One of the most intuitive ways to analyze the results of data queries is to visualize them as charts.

When you display a dataframe or run a SQL query in a Spark notebook in Azure Synapse Analytics, the results are displayed under the code cell. By default, results are rendered as a table, but you can also change the results view to a chart and use the chart properties to customize how the chart visualizes the data.

## 21 - Visualize with spark

When you want to have more control over how the data is formatted, you should consider using a graphics package to create your own visualizations. There are many graphics packages that you can use to create data visualizations in code. In particular, Python supports a large selection of packages; most of them built on the base Mat plot lib library.

## Thanks

Thanks for watching!
