-- Create Schema for Curated Tables
CREATE SCHEMA AdventureWorks AUTHORIZATION dbo;
GO

IF OBJECT_ID('AdventureWorks.Product', 'U') IS NOT NULL DROP TABLE AdventureWorks.Product;
GO

CREATE TABLE AdventureWorks.Product
	([ProductID] int NOT NULL
	,[Name] varchar(100) NOT NULL
	,[RowVersion] datetime2(7) NOT NULL)
WITH
(   DISTRIBUTION = HASH([ProductID])
	,CLUSTERED COLUMNSTORE INDEX
	--,CLUSTERED INDEX ([ProductID])
);
GO

CREATE VIEW [AdventureWorks].[vw_Source_Product]
AS SELECT
		[ProductID]
		,[Name]
		,[ChangesetType]
	FROM
		Ext.AdventureWorks_Product_Changeset;
GO

CREATE PROC [AdventureWorks].[up_Merge_Product] AS
BEGIN

	CREATE TABLE AdventureWorks.Product_New
	WITH
	(   DISTRIBUTION = HASH([ProductID])
		,CLUSTERED COLUMNSTORE INDEX
		--,CLUSTERED INDEX ([ProductID])
	)
	AS
		/* Inserts and Updates */
		SELECT
				[ProductID]
				,[Name]
				,SYSDATETIME() AS [RowVersion]
			FROM
				AdventureWorks.vw_Source_Product
			WHERE
				ChangesetType = 'InsertedOrUpdated'

		UNION ALL  

		/* Keep rows that are not referenced in the Staging table - this will remove the rows marked ChangesetType = 'Deleted' */
		SELECT
				t.[ProductID]
				,t.[Name]
				,t.[RowVersion]
			FROM
				AdventureWorks.Product t
			LEFT JOIN AdventureWorks.vw_Source_Product s
				ON t.ProductID = s.ProductID
			WHERE
				s.ProductID IS NULL;

	IF OBJECT_ID('AdventureWorks.Product_Old', 'U') IS NOT NULL DROP TABLE AdventureWorks.Product_Old;
	RENAME OBJECT AdventureWorks.Product TO Product_Old;
	RENAME OBJECT AdventureWorks.Product_New TO Product;

END
GO

IF OBJECT_ID('AdventureWorks.SalesOrder', 'U') IS NOT NULL DROP TABLE [AdventureWorks].[SalesOrder];
GO

CREATE TABLE [AdventureWorks].[SalesOrder]
(
	[OrderDate] [datetime] NOT NULL,
	[ShipToAddressID] int NULL,
	[SalesOrderID] int NOT NULL,
	SalesOrderDetailID int NOT NULL,
	ProductID int NOT NULL,
	UnitPrice money NOT NULL,
	OrderQty smallint NOT NULL,
	LineTotal numeric(38, 6)
	,[RowVersion] datetime2(7) NOT NULL
)
WITH
(   DISTRIBUTION = HASH([OrderDate])
	,CLUSTERED COLUMNSTORE INDEX
);
GO

--DROP PROC [AdventureWorks].[up_Merge_SalesOrder]
CREATE PROC [AdventureWorks].[up_Merge_SalesOrder] AS
BEGIN
	
	DELETE AdventureWorks.SalesOrder
		WHERE
			OrderDate >= (SELECT MIN(OrderDate) FROM Ext.AdventureWorks_SalesOrder);

	INSERT INTO AdventureWorks.SalesOrder
			([OrderDate]
			,ShipToAddressID
			,[SalesOrderID]
			,SalesOrderDetailID
			,ProductID
			,UnitPrice
			,OrderQty
			,LineTotal
			,[RowVersion])
		SELECT
				[OrderDate]
				,ShipToAddressID
				,[SalesOrderID]
				,SalesOrderDetailID
				,ProductID
				,UnitPrice
				,OrderQty
				,LineTotal
				,SYSDATETIME()
			FROM
				Ext.AdventureWorks_SalesOrder;
				
/*
	CREATE TABLE AdventureWorks.SalesOrder_New
	WITH
	(   DISTRIBUTION = HASH([OrderDate])
		,CLUSTERED COLUMNSTORE INDEX
	)
	AS
		/* Existing Data */
		SELECT
				*
			FROM
				AdventureWorks.SalesOrder
			WHERE
				OrderDate < (SELECT MIN(OrderDate) FROM Ext.AdventureWorks_SalesOrder)

		UNION ALL  

		/* Keep rows that are not referenced in the Staging table */
		SELECT
				*
				,SYSDATETIME() AS [RowVersion]
			FROM
				Ext.AdventureWorks_SalesOrder;

	IF OBJECT_ID('AdventureWorks.SalesOrder_Old', 'U') IS NOT NULL DROP TABLE AdventureWorks.SalesOrder_Old;
	RENAME OBJECT AdventureWorks.SalesOrder TO SalesOrder_Old;
	RENAME OBJECT AdventureWorks.SalesOrder_New TO SalesOrder;
*/
END
GO


/*
-- Switching from UTC to Local time
SELECT 
		[ProductID]
		,[Name]
		,[RowVersion]
		,TODATETIMEOFFSET([RowVersion], (select current_utc_offset from sys.time_zone_info where name = 'Cen. Australia Standard Time'))	-- Introduce a Time Offset for Australian Central Std Time
		,SWITCHOFFSET([RowVersion], (select current_utc_offset from sys.time_zone_info where name = 'Cen. Australia Standard Time'))		-- Switch offset to make it local time in Australian Central Std Time
	FROM 
		[AdventureWorks].[Product];


--EXEC [AdventureWorks].[up_Merge_SalesOrder]
*/