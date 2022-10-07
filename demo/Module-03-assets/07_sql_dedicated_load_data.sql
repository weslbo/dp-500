-- !! Make sure to run this against the DP500DWH database!

CREATE SCHEMA [Staging]
GO

CREATE TABLE [Staging].[FactInternetSales]
(
	[SalesOrderNumber] [nvarchar](20) NOT NULL,
	[SalesOrderLineNumber] [tinyint] NOT NULL,
	[CustomerKey] [int] NOT NULL,
	[ProductKey] [int] NOT NULL,
	[OrderDateKey] [int] NOT NULL,
	[DueDateKey] [int] NOT NULL,
	[ShipDateKey] [int] NULL,
	[PromotionKey] [int] NOT NULL,
	[CurrencyKey] [int] NOT NULL,
	[SalesTerritoryKey] [int] NOT NULL,
	[OrderQuantity] [smallint] NOT NULL,
	[UnitPrice] [money] NOT NULL,
	[ExtendedAmount] [money] NOT NULL,
	[UnitPriceDiscountPct] [decimal](7, 4) NOT NULL,
	[DiscountAmount] [float] NOT NULL,
	[ProductStandardCost] [money] NOT NULL,
	[TotalProductCost] [money] NOT NULL,
	[SalesAmount] [money] NOT NULL,
	[TaxAmount] [money] NOT NULL,
	[FreightAmount] [money] NOT NULL,
	[CarrierTrackingNumber] [nvarchar](25) NULL,
	[CustomerPONumber] [nvarchar](25) NULL,
	[RevisionNumber] [tinyint] NOT NULL
	)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO

COPY INTO [Staging].[FactInternetSales]
FROM 'https://datalake3mstaeetovkk4.dfs.core.windows.net/landing/Allfiles/03/data/FactInternetSales.txt'
WITH
(
	FILE_TYPE = 'CSV'
	,MAXERRORS = 0
	,FIELDTERMINATOR = '\t'
	,FIRSTROW = 1
	,ERRORFILE = 'https://datalake3mstaeetovkk4.dfs.core.windows.net/landing/Allfiles/03/errors/'
    ,ENCODING = 'UTF16'
)
GO




CREATE TABLE [Staging].[DimAccount]
( 
	[AccountKey] [int]  NOT NULL,
	[ParentAccountKey] [int]  NULL,
	[AccountCodeAlternateKey] [int]  NULL,
	[ParentAccountCodeAlternateKey] [int]  NULL,
	[AccountDescription] [nvarchar](50)  NULL,
	[AccountType] [nvarchar](50)  NULL,
	[Operator] [nvarchar](50)  NULL,
	[CustomMembers] [nvarchar](300)  NULL,
	[ValueType] [nvarchar](50)  NULL,
	[CustomMemberOptions] [nvarchar](200)  NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO

COPY INTO [Staging].[DimAccount]
FROM 'https://datalake3mstaeetovkk4.dfs.core.windows.net/landing/Allfiles/03/data/DimAccount.txt'
WITH
(
	FILE_TYPE = 'CSV'
	,MAXERRORS = 0
	,FIELDTERMINATOR = '\t'
	,FIRSTROW = 1
	,ERRORFILE = 'https://datalake3mstaeetovkk4.dfs.core.windows.net/landing/Allfiles/03/errors/'
    ,ENCODING = 'UTF16'
)
GO

DROP TABLE [Staging].[DimCurrency]
CREATE TABLE [Staging].[DimCurrency]
( 
	[CurrencyKey] [int]  NOT NULL,
	[CurrencyAlternateKey] [nchar](3)  NOT NULL,
	[CurrencyName] [nvarchar](50)  NOT NULL,
	[FormatString] [nvarchar](20)  NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO

COPY INTO [Staging].[DimCurrency]
FROM 'https://datalake3mstaeetovkk4.dfs.core.windows.net/landing/Allfiles/03/data/DimCurrency.txt'
WITH
(
	FILE_TYPE = 'CSV'
	,MAXERRORS = 0
	,FIELDTERMINATOR = '\t'
	,FIRSTROW = 1
	,ERRORFILE = 'https://datalake3mstaeetovkk4.dfs.core.windows.net/landing/Allfiles/03/errors/'
    ,ENCODING = 'UTF16'
)
GO



CREATE TABLE [Staging].[DimCustomer]
( 
	[CustomerKey] [int]  NOT NULL,
	[GeographyKey] [int]  NULL,
	[CustomerAlternateKey] [nvarchar](15)  NOT NULL,
	[Title] [nvarchar](8)  NULL,
	[FirstName] [nvarchar](50)  NULL,
	[MiddleName] [nvarchar](50)  NULL,
	[LastName] [nvarchar](50)  NULL,
	[NameStyle] [bit]  NULL,
	[BirthDate] [date]  NULL,
	[MaritalStatus] [nchar](1)  NULL,
	[Suffix] [nvarchar](10)  NULL,
	[Gender] [nvarchar](1)  NULL,
	[EmailAddress] [nvarchar](50)  NULL,
	[YearlyIncome] [money]  NULL,
	[TotalChildren] [tinyint]  NULL,
	[NumberChildrenAtHome] [tinyint]  NULL,
	[EnglishEducation] [nvarchar](40)  NULL,
	[SpanishEducation] [nvarchar](40)  NULL,
	[FrenchEducation] [nvarchar](40)  NULL,
	[EnglishOccupation] [nvarchar](100)  NULL,
	[SpanishOccupation] [nvarchar](100)  NULL,
	[FrenchOccupation] [nvarchar](100)  NULL,
	[HouseOwnerFlag] [nchar](1)  NULL,
	[NumberCarsOwned] [tinyint]  NULL,
	[AddressLine1] [nvarchar](120)  NULL,
	[AddressLine2] [nvarchar](120)  NULL,
	[Phone] [nvarchar](20)  NULL,
	[DateFirstPurchase] [date]  NULL,
	[CommuteDistance] [nvarchar](15)  NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO

COPY INTO [Staging].[DimCustomer]
FROM 'https://datalake3mstaeetovkk4.dfs.core.windows.net/landing/Allfiles/03/data/DimCustomer.txt'
WITH
(
	FILE_TYPE = 'CSV'
	,MAXERRORS = 0
	,FIELDTERMINATOR = '\t'
	,FIRSTROW = 1
	,ERRORFILE = 'https://datalake3mstaeetovkk4.dfs.core.windows.net/landing/Allfiles/03/errors/'
    ,ENCODING = 'UTF16'
)
GO
