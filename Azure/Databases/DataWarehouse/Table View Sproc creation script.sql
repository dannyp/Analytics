CREATE SCHEMA AdventureWorks AUTHORIZATION dbo;
GO

CREATE TABLE [AdventureWorks].[Product_Staging](
	[ProductID] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[ChangesetType] [varchar](20) NOT NULL,
/*	[ProductNumber] [varchar](25) NOT NULL,
	[Color] [varchar](15) NULL,
	[StandardCost] [money] NOT NULL,
	[ListPrice] [money] NOT NULL,
	[Size] [varchar](5) NULL,
	[Weight] [decimal](8, 2) NULL,
	[ProductCategoryID] [int] NULL,
	[ProductModelID] [int] NULL,
	[IsToBeDeleted] [char](1) NULL,
*/ CONSTRAINT [PK_AdventureWorks_Product_Staging_ProductID] PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [AdventureWorks].[Product](
	[ProductID] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[RowVersion] datetime2(7) NOT NULL,
/*	[ProductNumber] [varchar](25) NOT NULL,
	[Color] [varchar](15) NULL,
	[StandardCost] [money] NOT NULL,
	[ListPrice] [money] NOT NULL,
	[Size] [varchar](5) NULL,
	[Weight] [decimal](8, 2) NULL,
	[ProductCategoryID] [int] NULL,
	[ProductModelID] [int] NULL,
*/ CONSTRAINT [PK_AdventureWorks_Product_ProductID] PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [AdventureWorks].[SalesOrder_Staging](
	[OrderDate] [datetime] NOT NULL,
	[ShipToAddressID] [int] NULL,
	[SalesOrderID] [int] NOT NULL,
	[SalesOrderDetailID] [int] NOT NULL,
	[ProductID] [int] NOT NULL,
	[UnitPrice] [money] NOT NULL,
	[OrderQty] [smallint] NOT NULL,
	[LineTotal] [numeric](38, 6) NULL,
	[ChangesetType] [varchar](20) NOT NULL,
 CONSTRAINT [PK_AdventureWorks_SalesOrder_Staging_SalesOrderID] PRIMARY KEY CLUSTERED 
(
	[SalesOrderID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [AdventureWorks].[SalesOrder](
	[OrderDate] [datetime] NOT NULL,
	[ShipToAddressID] [int] NULL,
	[SalesOrderID] [int] NOT NULL,
	[SalesOrderDetailID] [int] NOT NULL,
	[ProductID] [int] NOT NULL,
	[UnitPrice] [money] NOT NULL,
	[OrderQty] [smallint] NOT NULL,
	[LineTotal] [numeric](38, 6) NULL,
	[RowVersion] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_AdventureWorks_SalesOrder_SalesOrderID] PRIMARY KEY CLUSTERED 
(
	[SalesOrderID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


--Stored Procedures, first one a CRUD operation, the second a CTAS for Data Warehouse
CREATE PROC [AdventureWorks].[up_CRUD_Product] AS
BEGIN

	DELETE AdventureWorks.Product
		WHERE
			ProductID IN (SELECT
								ProductID
							FROM
								AdventureWorks.Product_Staging
							WHERE
								ChangesetType = 'Deleted');

	INSERT INTO AdventureWorks.Product
			([ProductID]
			,[Name]
			--,[ProductNumber]
			--,[Color]
			--,[StandardCost]
			--,[ListPrice]
			--,[Size]
			--,[Weight]
			--,[ProductCategoryID]
			--,[ProductModelID]
			,[RowVersion])
		SELECT	
				s.[ProductID]
				,s.[Name]
				--,s.[ProductNumber]
				--,s.[Color]
				--,s.[StandardCost]
				--,s.[ListPrice]
				--,s.[Size]
				--,s.[Weight]
				--,s.[ProductCategoryID]
				--,s.[ProductModelID]
				,SYSDATETIME()
			FROM
				AdventureWorks.Product_Staging s
			LEFT JOIN AdventureWorks.Product t
				ON t.ProductID = s.ProductID
			WHERE
				t.ProductID IS NULL
				AND s.ChangesetType = 'InsertedOrUpdated';

	UPDATE t
		SET
			[Name] = s.[Name]
			--,[ProductNumber] = s.[ProductNumber]
			--,[Color] = s.[Color]
			--,[StandardCost] = s.[StandardCost]
			--,[ListPrice] = s.[ListPrice]
			--,[Size] = s.[Size]
			--,[Weight] = s.[Weight]
			--,[ProductCategoryID] = s.[ProductCategoryID]
			--,[ProductModelID] = s.[ProductModelID]
			,[RowVersion] = SYSDATETIME()
		FROM
			AdventureWorks.Product t
		JOIN AdventureWorks.Product_Staging s
			ON t.ProductID = s.ProductID
		WHERE
			s.ChangesetType = 'InsertedOrUpdated';
				
END
GO

CREATE PROC [AdventureWorks].[up_Merge_Product] AS
BEGIN

	MERGE INTO AdventureWorks.Product t
		USING AdventureWorks.Product_Staging s
			ON t.ProductID = s.ProductID

		WHEN MATCHED AND s.ChangesetType = 'Deleted' THEN
			DELETE

		WHEN MATCHED AND s.ChangesetType = 'InsertedOrUpdated' THEN
			UPDATE
				SET
					[Name] = s.[Name]
					--,ProductNumber = s.ProductNumber
					--,Color = s.Color
					--,StandardCost = s.StandardCost
					--,ListPrice = s.ListPrice
					--,Size = s.Size
					--,Weight = s.Weight
					--,ProductCategoryID = s.ProductCategoryID
					--,ProductModelID = s.ProductModelID
					,[RowVersion] = SYSDATETIME()

		WHEN NOT MATCHED BY TARGET THEN
			INSERT
					([ProductID]
					,[Name]
					--,[ProductNumber]
					--,[Color]
					--,[StandardCost]
					--,[ListPrice]
					--,[Size]
					--,[Weight]
					--,[ProductCategoryID]
					--,[ProductModelID]
					,[RowVersion])
				VALUES
					(s.[ProductID]
					,s.[Name]
					--,s.[ProductNumber]
					--,s.[Color]
					--,s.[StandardCost]
					--,s.[ListPrice]
					--,s.[Size]
					--,s.[Weight]
					--,s.[ProductCategoryID]
					--,s.[ProductModelID]
					,SYSDATETIME());

	/* For SQL DW, use CTAS instead (Create Table As Select) */
/*	CREATE TABLE AdventureWorksLT.Product_New
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
				,[ProductNumber]
				,[Color]
				,[StandardCost]
				,[ListPrice]
				,[Size]
				,[Weight]
				,[ProductCategoryID]
				,[ProductModelID]
				,SYSDATETIME() AS [RowVersion]
			FROM
				AdventureWorksLT.Product_Staging
			WHERE
				IsToBeDeleted = 'N'

		UNION ALL  

		/* Keep rows that are not referenced in the Staging table - this will remove the rows marked IsToBeDeleted = 'Y' */
		SELECT
				t.[ProductID]
				,t.[Name]
				,t.[ProductNumber]
				,t.[Color]
				,t.[StandardCost]
				,t.[ListPrice]
				,t.[Size]
				,t.[Weight]
				,t.[ProductCategoryID]
				,t.[ProductModelID]
				,t.[RowVersion]
			FROM
				AdventureWorksLT.Product t
			LEFT JOIN AdventureWorksLT.Product_Staging s
				ON t.ProductID = s.ProductID
			WHERE
				s.ProductID IS NULL;

	RENAME OBJECT AdventureWorksLT.Product TO Product_Old;
	RENAME OBJECT AdventureWorksLT.Product_New TO Product;
*/
END
GO

