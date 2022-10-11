-- REMEMBER to replace the datalake account url


-- Example: auto generated code (by right-click on a file name)
-- Notice 1) column headers are not promoted
-- Notice 2) have a look at the messages: "Potential conversion error while reading VARCHAR column 'C1' from UTF8 encoded text. Change database collation to a UTF8 collation or specify explicit column schema in WITH clause and assign UTF8 collation to VARCHAR columns."
SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'https://datalake3mstaeetovkk4.dfs.core.windows.net/landing/adventureworkslt/tables/csv/SalesLT.Product.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0'
    ) AS [result]


-- Example: Column headers promoted
SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'https://datalake3mstaeetovkk4.dfs.core.windows.net/landing/adventureworkslt/tables/csv/SalesLT.Product.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0', 
        HEADER_ROW=TRUE
    ) AS [result]

-- Example: We can specify our own column names and data types
-- Notice 1): External data type 'MONEY' is currently not supported. (need to replace to decimal)
-- Notice 2): External data type 'DATETIME' is currently not supported. (need to replace to DATETIME2)
-- Notice 3): External data type 'VARBINARY(MAX)' is currently not supported.
SELECT TOP 100 
    ProductID
    , Name
    , ProductNumber
    , Color
    , StandardCost
    , ListPrice
    , Size
    , Weight
    , ProductCategoryID
    , ProductModelID
    , SellStartDate
    , SellEndDate
    , DiscontinuedDate
    --, ThumbNailPhoto
    , ThumbnailPhotoFileName
    , rowguid
    , ModifiedDate
FROM
    OPENROWSET(
        BULK 'https://datalake3mstaeetovkk4.dfs.core.windows.net/landing/adventureworkslt/tables/csv/SalesLT.Product.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0', 
        HEADER_ROW=TRUE
    )
    WITH 
    (
        ProductID INT,
        Name NVARCHAR(50),
        ProductNumber NVARCHAR(25),
        Color NVARCHAR(15),
        StandardCost DECIMAL, --not supported MONEY
        ListPrice DECIMAL, --not supported MONEY
        Size NVARCHAR(5),
        Weight DECIMAL,
        ProductCategoryID INT,
        ProductModelID INT,
        SellStartDate DATETIME2,
        SellEndDate DATETIME2,
        DiscontinuedDate DATETIME2,
        --ThumbNailPhoto VARBINARY(max), --not supported VARBINARY
        ThumbnailPhotoFileName NVARCHAR(50),
        rowguid UNIQUEIDENTIFIER,
        ModifiedDate DATETIME2
    ) AS [result]
