# Some sample Power BI Queries

Currently, this is work in progress

## Population

```m
let
  Source = Csv.Document(Web.Contents("https://ec.europa.eu/eurostat/wdds/rest/data/v2.1/unicode/en/demo_r_pjangrp3?precision=1&sex=T&age=TOTAL"), [Delimiter = "#(tab)", Columns = 66, QuoteStyle = QuoteStyle.None]),
  #"Removed top rows" = Table.Skip(Source, each [Column1] <> "SLICE"),
  #"Promoted headers" = Table.PromoteHeaders(#"Removed top rows", [PromoteAllScalars = true]),
  #"Removed columns" = Table.RemoveColumns(#"Promoted headers", {"SLICE"}),
  #"Filtered rows" = Table.SelectRows(#"Removed columns", each not Text.Contains([NA], "EU") and [NA] <> "NA"),
  #"Removed columns 1" = Table.RemoveColumns(#"Filtered rows", {"NA_1"}),
  #"Filtered rows 1" = Table.SelectRows(#"Removed columns 1", each Text.Length([NA]) > 4),
  #"Removed other columns" = Table.SelectColumns(#"Filtered rows 1", {"NA", "2014", "2015", "2016", "2017", "2018", "2019", "2020", "2021"}),
  #"Unpivoted other columns" = Table.UnpivotOtherColumns(#"Removed other columns", {"NA"}, "Year", "Population"),
  #"Renamed columns" = Table.RenameColumns(#"Unpivoted other columns", {{"NA", "CountryCode"}}),
  #"Split column by delimiter" = Table.SplitColumn(#"Renamed columns", "Population", Splitter.SplitTextByDelimiter("("), {"Population.1", "Population.2"}),
  #"Changed column type" = Table.TransformColumnTypes(#"Split column by delimiter", {{"CountryCode", type text}, {"Population.1", Int64.Type}, {"Population.2", type text}, {"Year", Int64.Type}}),
  #"Removed columns 2" = Table.RemoveColumns(#"Changed column type", {"Population.2"}),
  #"Renamed columns 1" = Table.RenameColumns(#"Removed columns 2", {{"Population.1", "Pop"}})
in
  #"Renamed columns 1"
```

## GeoLocations

```m
let
  Source = Json.Document(Web.Contents("https://gisco-services.ec.europa.eu/distribution/v2/nuts/geojson/NUTS_LB_2021_4326_LEVL_3.geojson")),
  #"Converted to table" = Table.FromRecords({Source}),
  #"Expanded features" = Table.ExpandListColumn(#"Converted to table", "features"),
  #"Expanded features1" = Table.ExpandRecordColumn(#"Expanded features", "features", {"type", "geometry", "properties", "id"}, {"features.type", "features.geometry", "features.properties", "features.id"}),
  #"Expanded features.geometry" = Table.ExpandRecordColumn(#"Expanded features1", "features.geometry", {"type", "coordinates"}, {"features.geometry.type", "features.geometry.coordinates"}),
  #"Split column" = Table.SplitColumn(#"Expanded features.geometry", "features.geometry.coordinates", each _, {"features.geometry.coordinates.0", "features.geometry.coordinates.1"}),
  #"Expanded features.properties" = Table.ExpandRecordColumn(#"Split column", "features.properties", {"NUTS_ID", "LEVL_CODE", "CNTR_CODE", "NAME_LATN", "NUTS_NAME", "MOUNT_TYPE", "URBN_TYPE", "COAST_TYPE", "FID"}, {"features.properties.NUTS_ID", "features.properties.LEVL_CODE", "features.properties.CNTR_CODE", "features.properties.NAME_LATN", "features.properties.NUTS_NAME", "features.properties.MOUNT_TYPE", "features.properties.URBN_TYPE", "features.properties.COAST_TYPE", "features.properties.FID"}),
  #"Expanded crs" = Table.ExpandRecordColumn(#"Expanded features.properties", "crs", {"type", "properties"}, {"crs.type", "crs.properties"}),
  #"Expanded crs.properties" = Table.ExpandRecordColumn(#"Expanded crs", "crs.properties", {"name"}, {"crs.properties.name"}),
  #"Changed column type" = Table.TransformColumnTypes(#"Expanded crs.properties", {{"type", type text}, {"features.type", type text}, {"features.geometry.type", type text}, {"features.geometry.coordinates.0", type number}, {"features.geometry.coordinates.1", type number}, {"features.properties.NUTS_ID", type text}, {"features.properties.LEVL_CODE", Int64.Type}, {"features.properties.CNTR_CODE", type text}, {"features.properties.NAME_LATN", type text}, {"features.properties.NUTS_NAME", type text}, {"features.properties.MOUNT_TYPE", Int64.Type}, {"features.properties.URBN_TYPE", Int64.Type}, {"features.properties.COAST_TYPE", Int64.Type}, {"features.properties.FID", type text}, {"features.id", type text}, {"crs.type", type text}, {"crs.properties.name", type text}}),
  #"Removed other columns" = Table.SelectColumns(#"Changed column type", {"features.properties.NUTS_ID", "features.geometry.coordinates.1", "features.geometry.coordinates.0"}),
  #"Renamed columns" = Table.RenameColumns(#"Removed other columns", {{"features.geometry.coordinates.1", "Lat"}, {"features.geometry.coordinates.0", "Long"}, {"features.properties.NUTS_ID", "CountryCode"}})
in
  #"Renamed columns"
```

## Countries

```m
let
  Source = Csv.Document(Web.Contents("https://ec.europa.eu/eurostat/wdds/rest/data/v2.1/unicode/en/demo_r_pjangrp3?precision=1&sex=T&age=TOTAL"), [Delimiter = "#(tab)", Columns = 66, QuoteStyle = QuoteStyle.None]),
  #"Removed top rows" = Table.Skip(Source, each [Column1] <> "SLICE"),
  #"Removed columns" = Table.SelectColumns(#"Removed top rows", {"Column2", "Column3"}),
  #"Filtered EU" = Table.SelectRows(#"Removed columns", each not Text.Contains([Column2], "EU") and [Column2] <> "NA"),
  #"Added country" = Table.AddColumn(#"Filtered EU", "Country", each if Text.Length([Column2]) = 2 then [Column3] else null),
  #"Added region" = Table.AddColumn(#"Added country", "Region", each if Text.Length([Column2]) = 3 then [Column3] else null),
  #"Added municipality" = Table.AddColumn(#"Added region", "Municipality", each if Text.Length([Column2]) = 4 then [Column3] else null),
  #"Added city" = Table.AddColumn(#"Added municipality", "City", each if Text.Length([Column2]) = 5 then [Column3] else null),
  #"Filled down" = Table.FillDown(#"Added city", {"Country", "Region", "Municipality"}),
  #"Filtered empty city" = Table.SelectRows(#"Filled down", each ([City] <> null)),
  #"Removed column" = Table.RemoveColumns(#"Filtered empty city", {"Column3"}),
  #"Renamed columns" = Table.RenameColumns(#"Removed column", {{"Column2", "CountryCode"}}),
  #"Changed column type" = Table.TransformColumnTypes(#"Renamed columns", {{"CountryCode", type text}, {"Country", type text}, {"Region", type text}, {"Municipality", type text}, {"City", type text}}),
  #"Merged queries" = Table.NestedJoin(#"Changed column type", {"CountryCode"}, GeoLocations, {"CountryCode"}, "GeoLocations", JoinKind.LeftOuter),
  #"Expanded GeoLocations" = Table.ExpandTableColumn(#"Merged queries", "GeoLocations", {"Lat", "Long"}, {"Lat", "Long"})
in
  #"Expanded GeoLocations"
```