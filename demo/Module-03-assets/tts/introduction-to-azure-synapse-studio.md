# Demo: Introduction to Azure Synapse Studio

## 1 - Azure Portal

So here we are in the Azure Portal, looking for Azure Synapse workspaces.

In this particular demo, we already have provisioned a workspace ahead of time, as provisioning typically takes a bit more time.

We can get started by opening the Synapse Studio.

## 2 - Synapse Studio Home activity hub

On the home activity hub, we can easily create new artifacts.

Or, we can easily bring in some data using the copy data tool wizard, which will generate the pipelines, datasets and linked services for us automatically.

The home activity hub also surfaces the knowledge center, from where we can browse some samples and use them immediately in our workspace.

## 3 - Synapse Studio Data activity hub

On the data activity hub, we can explore our SQL databases, either as part of serverless SQL pools or as part of our dedicated SQL pools.

Additionally, we can also explore the data from any linked services that we have set up.

For example, we can browse the files located in our data lake.

We can expand the first-level containers, like this landing zone, and then continue to navigate folders and subfolders until we find our files.

## 4 - Synapse Studio Develop activity hub

In the develop activity hub, we can create SQL Scripts, notebooks and Power BI Reports.

We can organize our scripts and notebooks into folders for easier management.

The editor provides us with color formatting and intellisense.

Make sure to always connect to the correct SQL Pool and database before you execute any scripts.

The notebooks allow us to mix markdown documentation with cells that can execute code.

Code can be written in Python, Scala, C# or Spark SQL.

Make sure you set the language correctly and attach the notebook to a Spark Pool before running the notebook.

The Power BI section, allows you to set up Power BI datasets and create reports.

## 5 - Synapse Studio Integrate activity hub

In the Integrate activity hub, you can set up pipelines, either from a template or from scratch.

You can choose from a number of activities and drag them over to the design surface.

One of the most commonly used activities is the copy data activity, which allows you to copy data from or to a huge number of data source types.

Here you can also integrate with many other Azure services, like invoking a machine learning pipeline or executing the code in a Synapse notebook.

The editor can also help you debugging your pipeline for test and validation purposes.

## 6 - Synapse Studio Monitoring Hub

In the Monitoring activity hub, you can monitor previous pipeline runs and inspect any failed activity.

Additionally, you can get copy performance details and troubleshoot any error that might have occurred.

You can also have a look at the individual SQL requests that have executed against your serverless pool or dedicated pool.

You will the duration of each query, as well as how many data had to be processed (which is important for determining the cost of serverless SQL queries).

## 7 - Synapse Studio Manage hub

In the manage activity hub, you can create and configure the SQL pools.

The built-in serverless pool is always available and is exposed over a regular TCP connection.

So you can leverage SQL Server Management Studio or Power BI and simply connect to this pool.

Additionally, you can create new dedicated SQL pools.

You can also create and configure the Apache Spark pool to run different kinds of notebooks.

## 8 - Synapse Studio Linked Services

In the linked services section, you can set up connections to various external data sources.

Think of this like connection strings with all the required information to connect to the data source.

## 9 - Synapse linkedservices sources

We support many connectors to data sources in Azure and other cloud providers.

Through an integration runtime, we can even connect to data sources that are located in an on-premises environment.

## Thanks

Thanks for watching!
