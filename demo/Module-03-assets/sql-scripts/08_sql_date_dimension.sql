CREATE TABLE dbo.DimDate
( 
    DateKey INT NOT NULL,
    DateAltKey DATETIME NOT NULL,
    DayOfMonth INT NOT NULL,
    DayOfWeek INT NOT NULL,
    DayName NVARCHAR(15) NOT NULL,
    MonthOfYear INT NOT NULL,
    MonthName NVARCHAR(15) NOT NULL,
    CalendarQuarter INT  NOT NULL,
    CalendarYear INT NOT NULL,
    FiscalQuarter INT NOT NULL,
    FiscalYear INT NOT NULL
)
WITH
(
    DISTRIBUTION = REPLICATE,
    CLUSTERED COLUMNSTORE INDEX
);

-- Create a temporary table for the dates we need
CREATE TABLE #TmpStageDate (DateVal DATE NOT NULL)

-- Populate the temp table with a range of dates
DECLARE @StartDate DATE
DECLARE @EndDate DATE
SET @StartDate = '2019-01-01'
SET @EndDate = '2022-12-31' 
DECLARE @LoopDate DATE
SET @LoopDate = @StartDate
WHILE @LoopDate <= @EndDate
BEGIN
    INSERT INTO #TmpStageDate VALUES
    (
        @LoopDate
    ) 
    SET @LoopDate = DATEADD(dd, 1, @LoopDate)
END

-- Insert the dates and calculated attributes into the dimension table
INSERT INTO dbo.DimDate 
SELECT  CAST(CONVERT(VARCHAR(8), DateVal, 112) AS int) , -- date key
        DateVal, -- date alt key
        Day(DateVal),  -- day number of month
        datepart(dw, DateVal), -- day number of week
        datename(dw, DateVal), -- day name of week
        Month(DateVal), -- month number of year
        datename(mm, DateVal), -- month name
        datepart(qq, DateVal), -- calendar quarter
        Year(DateVal), -- calendar year
        CASE
            WHEN Month(DateVal) IN (1, 2, 3) THEN 3
            WHEN Month(DateVal) IN (4, 5, 6) THEN 4
            WHEN Month(DateVal) IN (7, 8, 9) THEN 1
            WHEN Month(DateVal) IN (10, 11, 12) THEN 2
        END, -- fiscal quarter (fiscal year runs from Jul to June)
        CASE
            WHEN Month(DateVal) < 7 THEN Year(DateVal)
            ELSE Year(DateVal) + 1
        END -- Fiscal year 
FROM #TmpStageDate
GO


SELECT TOP 10 * FROM dbo.DimDate