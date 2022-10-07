-- Do this only once!
CREATE DATABASE AdventureWorksLTServerless

-- Change database
USE AdventureWorksLTServerless
GO

-- Create a separate schema (optional)
CREATE SCHEMA Ext
GO

-- Create external file format
IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'SynapseParquetFormat') 
	CREATE EXTERNAL FILE FORMAT [SynapseParquetFormat] 
	WITH ( FORMAT_TYPE = PARQUET)
GO

-- Create external data source, pointing to the data lake
-- Remember to change datalake url
IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'DataLakeLandingZone') 
	CREATE EXTERNAL DATA SOURCE [DataLakeLandingZone] 
	WITH (
		LOCATION = 'abfss://landing@datalakecn32xts6vteh6.dfs.core.windows.net' 
	)
GO

-- Note: updated the data types to match the orginal (instead of relying on nvarchar(4000) all the time)
CREATE EXTERNAL TABLE [Ext].[Address] (
	[AddressID] int,
	[AddressLine1] nvarchar(60),
	[AddressLine2] nvarchar(60),
	[City] nvarchar(30),
	[StateProvince] nvarchar(50),
	[CountryRegion] nvarchar(50),
	[PostalCode] nvarchar(15),
	[rowguid] UNIQUEIDENTIFIER,
	[ModifiedDate] datetime2(7)
	)
	WITH (
	LOCATION = 'adventureworkslt/tables/parquet/SalesLT.Address.parquet',
	DATA_SOURCE = [DataLakeLandingZone],
	FILE_FORMAT = [SynapseParquetFormat]
	)
GO

CREATE EXTERNAL TABLE [Ext].[Customer] (
	[CustomerID] [int],
	[NameStyle] bit,
	[Title] [nvarchar](8),
	[FirstName] NVARCHAR(50),
	[MiddleName] nvarchar(50),
	[LastName] nvarchar(50),
	[Suffix] [nvarchar](10),
	[CompanyName] [nvarchar](128),
	[SalesPerson] [nvarchar](256),
	[EmailAddress] [nvarchar](50),
	[Phone] nvarchar(25),
	[PasswordHash] [varchar](128),
	[PasswordSalt] [varchar](10),
	[rowguid] [uniqueidentifier],
	[ModifiedDate] [datetime2](7)
	)
	WITH (
	LOCATION = 'adventureworkslt/tables/parquet/SalesLT.Customer.parquet',
	DATA_SOURCE = [DataLakeLandingZone],
	FILE_FORMAT = [SynapseParquetFormat]
	)
GO

CREATE EXTERNAL TABLE [Ext].[CustomerAddress] (
	[CustomerID] [int],
	[AddressID] [int],
	[AddressType] nvarchar(50),
	[rowguid] [uniqueidentifier],
	[ModifiedDate] [datetime2](7)
	)
	WITH (
	LOCATION = 'adventureworkslt/tables/parquet/SalesLT.CustomerAddress.parquet',
	DATA_SOURCE = [DataLakeLandingZone],
	FILE_FORMAT = [SynapseParquetFormat]
	)
GO

CREATE EXTERNAL TABLE [Ext].[Product] (
	[ProductID] [int],
	[Name] nvarchar(50),
	[ProductNumber] [nvarchar](25),
	[Color] [nvarchar](15),
	[StandardCost] [money],
	[ListPrice] [money],
	[Size] [nvarchar](5),
	[Weight] [decimal](8, 2),
	[ProductCategoryID] [int],
	[ProductModelID] [int],
	[SellStartDate] [datetime2](7),
	[SellEndDate] [datetime2](7),
	[DiscontinuedDate] [datetime2](7),
	[ThumbNailPhoto] [varbinary](max),
	[ThumbnailPhotoFileName] [nvarchar](50),
	[rowguid] [uniqueidentifier],
	[ModifiedDate] [datetime2](7)
	)
	WITH (
	LOCATION = 'adventureworkslt/tables/parquet/SalesLT.Product.parquet',
	DATA_SOURCE = [DataLakeLandingZone],
	FILE_FORMAT = [SynapseParquetFormat]
	)
GO

CREATE EXTERNAL TABLE [Ext].[ProductCategory] (
	[ProductCategoryID] [int],
	[ParentProductCategoryID] [int],
	[Name] nvarchar(50),
	[rowguid] [uniqueidentifier],
	[ModifiedDate] [datetime2](7)
	)
	WITH (
	LOCATION = 'adventureworkslt/tables/parquet/SalesLT.ProductCategory.parquet',
	DATA_SOURCE = [DataLakeLandingZone],
	FILE_FORMAT = [SynapseParquetFormat]
	)
GO

CREATE EXTERNAL TABLE [Ext].[ProductDescription] (
	[ProductDescriptionID] [int],
	[Description] [nvarchar](400),
	[rowguid] [uniqueidentifier],
	[ModifiedDate] [datetime2](7)
	)
	WITH (
	LOCATION = 'adventureworkslt/tables/parquet/SalesLT.ProductDescription.parquet',
	DATA_SOURCE = [DataLakeLandingZone],
	FILE_FORMAT = [SynapseParquetFormat]
	)
GO

-- Note xml data type is not supported (column CatalogDescription)
CREATE EXTERNAL TABLE [Ext].[ProductModel] (
	[ProductModelID] [int],
	[Name] nvarchar(50),
	[CatalogDescription] nvarchar(4000),
	[rowguid] [uniqueidentifier],
	[ModifiedDate] [datetime2](7)
	)
	WITH (
	LOCATION = 'adventureworkslt/tables/parquet/SalesLT.ProductModel.parquet',
	DATA_SOURCE = [DataLakeLandingZone],
	FILE_FORMAT = [SynapseParquetFormat]
	)
GO

CREATE EXTERNAL TABLE [Ext].[ProductModelProductDescription] (
	[ProductModelID] [int],
	[ProductDescriptionID] [int],
	[Culture] [nchar](6),
	[rowguid] [uniqueidentifier],
	[ModifiedDate] [datetime2](7)
	)
	WITH (
	LOCATION = 'adventureworkslt/tables/parquet/SalesLT.ProductModelProductDescription.parquet',
	DATA_SOURCE = [DataLakeLandingZone],
	FILE_FORMAT = [SynapseParquetFormat]
	)
GO

-- Notice linetotal is a calculated field (isnull(([UnitPrice]*((1.0)-[UnitPriceDiscount]))*[OrderQty],(0.0)))
-- Replaced with numeric(38,6)
CREATE EXTERNAL TABLE [Ext].[SalesOrderDetail] (
	[SalesOrderID] [int],
	[SalesOrderDetailID] [int],
	[OrderQty] [smallint],
	[ProductID] [int],
	[UnitPrice] [money],
	[UnitPriceDiscount] [money],
	[LineTotal] numeric(38,6),
	[rowguid] [uniqueidentifier],
	[ModifiedDate] [datetime2](7)

	)
	WITH (
	LOCATION = 'adventureworkslt/tables/parquet/SalesLT.SalesOrderDetail.parquet',
	DATA_SOURCE = [DataLakeLandingZone],
	FILE_FORMAT = [SynapseParquetFormat]
	)
GO

CREATE EXTERNAL TABLE [Ext].[SalesOrderHeader] (
	[SalesOrderID] [int],
	[RevisionNumber] [tinyint],
	[OrderDate] [datetime2](7),
	[DueDate] [datetime2](7),
	[ShipDate] [datetime2](7),
	[Status] [tinyint],
	[OnlineOrderFlag] bit ,
	[SalesOrderNumber]  nvarchar(23),
	[PurchaseOrderNumber] nvarchar(25),
	[AccountNumber] nvarchar(15),
	[CustomerID] [int],
	[ShipToAddressID] [int],
	[BillToAddressID] [int],
	[ShipMethod] [nvarchar](50),
	[CreditCardApprovalCode] [varchar](15),
	[SubTotal] [money],
	[TaxAmt] [money],
	[Freight] [money],
	[TotalDue] numeric(19,4),
	[Comment] [nvarchar](400),
	[rowguid] [uniqueidentifier],
	[ModifiedDate] [datetime2](7) 
	)
	WITH (
	LOCATION = 'adventureworkslt/tables/parquet/SalesLT.SalesOrderHeader.parquet',
	DATA_SOURCE = [DataLakeLandingZone],
	FILE_FORMAT = [SynapseParquetFormat]
	)
GO


SELECT TOP 100 * FROM [Ext].[Address]
SELECT TOP 100 * FROM [Ext].[Customer]
SELECT TOP 100 * FROM [Ext].[CustomerAddress]
SELECT TOP 100 * FROM [Ext].[Product]
SELECT TOP 100 * FROM [Ext].[ProductCategory]
SELECT TOP 100 * FROM [Ext].[ProductDescription]
SELECT TOP 100 * FROM [Ext].[ProductModel]
SELECT TOP 100 * FROM [Ext].[ProductModelProductDescription]
SELECT TOP 100 * FROM [Ext].[SalesOrderDetail]
SELECT TOP 100 * FROM [Ext].[SalesOrderHeader]
