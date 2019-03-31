-- Create Schema for External Tables
CREATE SCHEMA Ext AUTHORIZATION dbo;
GO

-- Create a Master Key to protect private keys
CREATE MASTER KEY ENCRYPTION BY PASSWORD='MyP@ssword123secretword';
GO

-- Create a Credential to access the Blob storage - the Secret is the Access Key for the Blob storage
CREATE DATABASE SCOPED CREDENTIAL mycredential  
WITH IDENTITY = 'credential', Secret = 'fYRv0+MWcDIxknZ6KVoPGANDTJ40NAxm9NMIH7FORO41HKvyGAEjGwtuoDza8DG1a02H5NJE0PaD4bitruB69w==';
GO

-- Create an External Data Source to point to the Blob storage 
CREATE EXTERNAL DATA SOURCE myBlobStorage
WITH (
    TYPE = HADOOP,
    LOCATION = 'wasbs://dev@mickblob.blob.core.windows.net/',
    CREDENTIAL = mycredential
);
GO

-- Create External File Formats
CREATE EXTERNAL FILE FORMAT [CsvWithHeaderRowFileFormat] WITH (FORMAT_TYPE = DELIMITEDTEXT, FORMAT_OPTIONS (FIELD_TERMINATOR = N',', FIRST_ROW = 2, USE_TYPE_DEFAULT = True));
GO
CREATE EXTERNAL FILE FORMAT [ParquetFileFormat] WITH (FORMAT_TYPE = PARQUET, DATA_COMPRESSION = N'org.apache.hadoop.io.compress.SnappyCodec');
GO

-- Create External Tables
IF OBJECT_ID('Ext.AdventureWorks_Product') IS NOT NULL
	DROP EXTERNAL TABLE [Ext].[AdventureWorks_Product];
GO

CREATE EXTERNAL TABLE [Ext].[AdventureWorks_Product]
(
	[ProductID] [int] NOT NULL,
	[Name] varchar(100) NOT NULL
	--,
	--[ProductNumber] [varchar](25) NOT NULL,
	--[Color] [varchar](15) NULL,
	--[StandardCost] [decimal](13, 2) NOT NULL,
	--[ListPrice] [decimal](13, 2) NOT NULL,
	--[Size] [varchar](5) NULL,
	--[Weight] [decimal](8, 2) NULL,
	--[ProductCategoryID] [int] NULL,
	--[ProductModelID] [int] NULL,
	--[SellStartDate] [datetime2](3) NOT NULL,
	--[SellEndDate] [datetime2](3) NULL,
	--[DiscontinuedDate] [datetime2](3) NULL,
	--[ThumbnailPhotoFileName] [varchar](50) NULL,
	--[ModifiedDate] [datetime2](3) NOT NULL
)
WITH (DATA_SOURCE = [myBlobStorage],LOCATION = N'/AdventureWorks/Product/Current',FILE_FORMAT = [ParquetFileFormat],REJECT_TYPE = VALUE,REJECT_VALUE = 0);
GO

CREATE STATISTICS [stat_Product]   
ON [Ext].[AdventureWorks_Product] (ProductID)
   WITH SAMPLE 10 PERCENT; 
GO

IF OBJECT_ID('Ext.AdventureWorks_Product_History') IS NOT NULL
	DROP EXTERNAL TABLE [Ext].[AdventureWorks_Product_History];
GO

CREATE EXTERNAL TABLE [Ext].[AdventureWorks_Product_History]
(
	[ProductID] [int] NOT NULL,
	[Name] varchar(100) NOT NULL,
	[DataDate] char(8) NOT NULL
	--,
	--[ProductNumber] [varchar](25) NOT NULL,
	--[Color] [varchar](15) NULL,
	--[StandardCost] [decimal](13, 2) NOT NULL,
	--[ListPrice] [decimal](13, 2) NOT NULL,
	--[Size] [varchar](5) NULL,
	--[Weight] [decimal](8, 2) NULL,
	--[ProductCategoryID] [int] NULL,
	--[ProductModelID] [int] NULL,
	--[SellStartDate] [datetime2](3) NOT NULL,
	--[SellEndDate] [datetime2](3) NULL,
	--[DiscontinuedDate] [datetime2](3) NULL,
	--[ThumbnailPhotoFileName] [varchar](50) NULL,
	--[ModifiedDate] [datetime2](3) NOT NULL
)
WITH (DATA_SOURCE = [myBlobStorage],LOCATION = N'/AdventureWorks/Product/History',FILE_FORMAT = [ParquetFileFormat],REJECT_TYPE = VALUE,REJECT_VALUE = 0);
GO

CREATE STATISTICS [stat_Product_History]   
ON [Ext].[AdventureWorks_Product_History] (DataDate, ProductID)
   WITH SAMPLE 10 PERCENT; 
GO

IF OBJECT_ID('Ext.AdventureWorks_Product_Changeset') IS NOT NULL
	DROP EXTERNAL TABLE [Ext].[AdventureWorks_Product_Changeset];
GO

CREATE EXTERNAL TABLE [Ext].[AdventureWorks_Product_Changeset]
(
	[ProductID] [int] NOT NULL,
	[Name] varchar(100) NOT NULL,
	[ChangesetType] varchar(20) NOT NULL
	--,
	--[ProductNumber] [varchar](25) NOT NULL,
	--[Color] [varchar](15) NULL,
	--[StandardCost] [decimal](13, 2) NOT NULL,
	--[ListPrice] [decimal](13, 2) NOT NULL,
	--[Size] [varchar](5) NULL,
	--[Weight] [decimal](8, 2) NULL,
	--[ProductCategoryID] [int] NULL,
	--[ProductModelID] [int] NULL,
	--[SellStartDate] [datetime2](3) NOT NULL,
	--[SellEndDate] [datetime2](3) NULL,
	--[DiscontinuedDate] [datetime2](3) NULL,
	--[ThumbnailPhotoFileName] [varchar](50) NULL,
	--[ModifiedDate] [datetime2](3) NOT NULL
)
WITH (DATA_SOURCE = [myBlobStorage],LOCATION = N'/AdventureWorks/Product/Changeset',FILE_FORMAT = [ParquetFileFormat],REJECT_TYPE = VALUE,REJECT_VALUE = 0);
GO

--DROP STATISTICS [Ext].[AdventureWorks_Product_Changeset].[stat_Product_Changeset];
CREATE STATISTICS [stat_Product_Changeset]   
ON [Ext].[AdventureWorks_Product_Changeset] (ProductID, ChangesetType)
   WITH SAMPLE 10 PERCENT; 
GO

IF OBJECT_ID('Ext.AdventureWorks_SalesOrder') IS NOT NULL
	DROP EXTERNAL TABLE [Ext].[AdventureWorks_SalesOrder];
GO

CREATE EXTERNAL TABLE [Ext].[AdventureWorks_SalesOrder]
(
	[OrderDate] [datetime] NOT NULL,
	[ShipToAddressID] int NULL,
	[SalesOrderID] int NOT NULL,
	SalesOrderDetailID int NOT NULL,
	ProductID int NOT NULL,
	UnitPrice money NOT NULL,
	OrderQty smallint NOT NULL,
	LineTotal numeric(38, 6)
)
WITH (DATA_SOURCE = [myBlobStorage],LOCATION = N'/AdventureWorks/SalesOrder/Current',FILE_FORMAT = [ParquetFileFormat],REJECT_TYPE = VALUE,REJECT_VALUE = 0);
GO

CREATE STATISTICS [stat_SalesOrder]   
ON [Ext].[AdventureWorks_SalesOrder] (OrderDate, ProductID, ShipToAddressID)
   WITH SAMPLE 10 PERCENT; 
GO



-- Query the External Tables
SELECT * FROM Ext.AdventureWorks_Product;
SELECT *, CAST(DataDate AS date) AS DataDate_Date FROM Ext.AdventureWorks_Product_History;
SELECT * FROM Ext.AdventureWorks_Product_Changeset;
SELECT * FROM Ext.AdventureWorks_SalesOrder;
