-- Do this only once!
CREATE DATABASE AdventureWorksLTServerless

-- Change database
USE AdventureWorksLTServerless
GO

-- Create a separate schema (optional)
CREATE SCHEMA SalesLT
GO

-- Create views for every tables, based on PARQUET format
CREATE VIEW SalesLT.Address AS SELECT * FROM OPENROWSET(BULK 'https://datalake3mstaeetovkk4.dfs.core.windows.net/landing/adventureworkslt/tables/parquet/SalesLT.Address.parquet', FORMAT = 'PARQUET') AS [result]
GO
CREATE VIEW SalesLT.Customer AS SELECT * FROM OPENROWSET(BULK 'https://datalake3mstaeetovkk4.dfs.core.windows.net/landing/adventureworkslt/tables/parquet/SalesLT.Customer.parquet', FORMAT = 'PARQUET') AS [result]
GO
CREATE VIEW SalesLT.CustomerAddress AS SELECT * FROM OPENROWSET(BULK 'https://datalake3mstaeetovkk4.dfs.core.windows.net/landing/adventureworkslt/tables/parquet/SalesLT.CustomerAddress.parquet', FORMAT = 'PARQUET') AS [result]
GO
CREATE VIEW SalesLT.Product AS SELECT * FROM OPENROWSET(BULK 'https://datalake3mstaeetovkk4.dfs.core.windows.net/landing/adventureworkslt/tables/parquet/SalesLT.Product.parquet', FORMAT = 'PARQUET') AS [result]
GO
CREATE VIEW SalesLT.ProductCategory AS SELECT * FROM OPENROWSET(BULK 'https://datalake3mstaeetovkk4.dfs.core.windows.net/landing/adventureworkslt/tables/parquet/SalesLT.ProductCategory.parquet', FORMAT = 'PARQUET') AS [result]
GO
CREATE VIEW SalesLT.ProductDescription AS SELECT * FROM OPENROWSET(BULK 'https://datalake3mstaeetovkk4.dfs.core.windows.net/landing/adventureworkslt/tables/parquet/SalesLT.ProductDescription.parquet', FORMAT = 'PARQUET') AS [result]
GO
CREATE VIEW SalesLT.ProductModel AS SELECT * FROM OPENROWSET(BULK 'https://datalake3mstaeetovkk4.dfs.core.windows.net/landing/adventureworkslt/tables/parquet/SalesLT.ProductModel.parquet', FORMAT = 'PARQUET') AS [result]
GO
CREATE VIEW SalesLT.ProductModelProductDescription AS SELECT * FROM OPENROWSET(BULK 'https://datalake3mstaeetovkk4.dfs.core.windows.net/landing/adventureworkslt/tables/parquet/SalesLT.ProductModelProductDescription.parquet', FORMAT = 'PARQUET') AS [result]
GO
CREATE VIEW SalesLT.SalesOrderDetail AS SELECT * FROM OPENROWSET(BULK 'https://datalake3mstaeetovkk4.dfs.core.windows.net/landing/adventureworkslt/tables/parquet/SalesLT.SalesOrderDetail.parquet', FORMAT = 'PARQUET') AS [result]
GO
CREATE VIEW SalesLT.SalesOrderHeader AS SELECT * FROM OPENROWSET(BULK 'https://datalake3mstaeetovkk4.dfs.core.windows.net/landing/adventureworkslt/tables/parquet/SalesLT.SalesOrderHeader.parquet', FORMAT = 'PARQUET') AS [result]
GO

-- PLAYGROUND: Confirm data can be retrieved
SELECT TOP 100 * FROM SalesLT.Address
SELECT TOP 100 * FROM SalesLT.Customer
SELECT TOP 100 * FROM SalesLT.CustomerAddress
SELECT TOP 100 * FROM SalesLT.Product
SELECT TOP 100 * FROM SalesLT.ProductCategory
SELECT TOP 100 * FROM SalesLT.ProductDescription
SELECT TOP 100 * FROM SalesLT.ProductModel
SELECT TOP 100 * FROM SalesLT.ProductModelProductDescription
SELECT TOP 100 * FROM SalesLT.SalesOrderDetail
SELECT TOP 100 * FROM SalesLT.SalesOrderHeader
