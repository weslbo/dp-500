-- REMEMBER to replace the datalake account url

-- EXAMPLE: select from JSON file. Here, we have explicitly defined the JSON_VALUE elements
SELECT TOP 100
      JSON_VALUE(jsonContent, '$.ProductID') as ProductId
    , JSON_VALUE(jsonContent, '$.Name') as Name
    , JSON_VALUE(jsonContent, '$.ProductNumber') as ProductNumber
    , JSON_VALUE(jsonContent, '$.Color') as Color
    , JSON_VALUE(jsonContent, '$.StandardCost') as StandardCost
    , JSON_VALUE(jsonContent, '$.ListPrice') as ListPrice
    , JSON_VALUE(jsonContent, '$.Size') as Size
    , JSON_VALUE(jsonContent, '$.Weight') as Weight
    , JSON_VALUE(jsonContent, '$.ProductCategoryID') as ProductCategoryID
    , JSON_VALUE(jsonContent, '$.ProductModelID') as ProductModelID
    , JSON_VALUE(jsonContent, '$.SellStartDate') as SellStartDate
    , JSON_VALUE(jsonContent, '$.SellEndDate') as SellEndDate
    , JSON_VALUE(jsonContent, '$.DiscontinuedDate') as DiscontinuedDate
    , JSON_VALUE(jsonContent, '$.ThumbNailPhoto') as ThumbNailPhoto
    , JSON_VALUE(jsonContent, '$.ThumbnailPhotoFileName') as ThumbnailPhotoFileName
    , JSON_VALUE(jsonContent, '$.rowguid') as rowguid
    , JSON_VALUE(jsonContent, '$.ModifiedDate') as ModifiedDate
FROM
    OPENROWSET(
        BULK 'https://datalakecn32xts6vteh6.dfs.core.windows.net/landing/adventureworkslt/tables/json/SalesLT.Product.json',
        FORMAT = 'CSV',
        FIELDQUOTE = '0x0b',
        FIELDTERMINATOR ='0x0b'
        --ROWTERMINATOR = '0x0b' -- Doesn't work here as lines are separated by a newline (no comma)
    )
    WITH (
        jsonContent varchar(MAX)
    ) AS [result]



-- EXAMPLE: We can specify our own column names and data types
SELECT TOP 100 *
FROM 
    OPENROWSET(
        BULK 'https://datalakecn32xts6vteh6.dfs.core.windows.net/landing/adventureworkslt/tables/json/SalesLT.Product.json',
        FORMAT = 'CSV',
        FIELDQUOTE = '0x0b',
        FIELDTERMINATOR ='0x0b'
    )
    WITH 
    (
        jsonContent varchar(MAX)
    ) AS [result]
    CROSS APPLY openjson(jsonContent)
        WITH 
        (
            ProductID INT,
            Name NVARCHAR(50),
            ProductNumber NVARCHAR(25),
            Color NVARCHAR(15),
            StandardCost MONEY,
            ListPrice MONEY,
            Size NVARCHAR(5),
            Weight DECIMAL,
            ProductCategoryID INT,
            ProductModelID INT,
            SellStartDate DATETIME2,
            SellEndDate DATETIME2,
            DiscontinuedDate DATETIME2,
            ThumbNailPhoto VARBINARY(max), 
            ThumbnailPhotoFileName NVARCHAR(50),
            RowGuid UNIQUEIDENTIFIER '$.rowguid',   -- notice that we can override the name of the column
            ModifiedDate DATETIME2
        )