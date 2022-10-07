-- REMEMBER to replace the datalake account url

-- EXAMPLE: This is auto-generated code
-- NOTICE: we do not need to specify data types (inferred from parquet file)
SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'https://datalakecn32xts6vteh6.dfs.core.windows.net/landing/adventureworkslt/tables/parquet/SalesLT.Product.parquet',
        FORMAT = 'PARQUET'
    ) AS [result]

-- EXAMPLE: We can specify our own column names and data types
-- NOTICE this will read only the column name we specify (improve performance)
SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'https://datalakecn32xts6vteh6.dfs.core.windows.net/landing/adventureworkslt/tables/parquet/SalesLT.Product.parquet',
        FORMAT = 'PARQUET'
    )
    WITH 
    (
        ProductID INT,
        Name NVARCHAR(50),
        ProductNumber NVARCHAR(25),
        Color NVARCHAR(15)
    ) AS [result]