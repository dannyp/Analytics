USE [MasterData]
GO
/****** Object:  Schema [Entity]    Script Date: 31/03/2019 12:00:02 PM ******/
CREATE SCHEMA [Entity]
GO
/****** Object:  Schema [Hierarchy]    Script Date: 31/03/2019 12:00:02 PM ******/
CREATE SCHEMA [Hierarchy]
GO
/****** Object:  Table [Entity].[EntityType]    Script Date: 31/03/2019 12:00:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Entity].[EntityType](
	[EntityTypeKey] [int] IDENTITY(1,1) NOT NULL,
	[EntityTypeName] [varchar](50) NOT NULL,
	[EntityTypeDescription] [varchar](200) NULL,
 CONSTRAINT [PK_EntityType] PRIMARY KEY NONCLUSTERED 
(
	[EntityTypeKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_EntityType] UNIQUE CLUSTERED 
(
	[EntityTypeName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Entity].[Entity]    Script Date: 31/03/2019 12:00:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Entity].[Entity](
	[EntityKey] [int] IDENTITY(1,1) NOT NULL,
	[EntityTypeKey] [int] NOT NULL,
	[EntityName] [varchar](50) NOT NULL,
	[EntityDescription] [varchar](200) NULL,
 CONSTRAINT [PK_Entity] PRIMARY KEY NONCLUSTERED 
(
	[EntityKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_Entity] UNIQUE CLUSTERED 
(
	[EntityName] ASC,
	[EntityTypeKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [Entity].[vw_Generic]    Script Date: 31/03/2019 12:00:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/**********************************************************************************************************************
DESCRIPTION:
	View of Generic Entities.


EXAMPLE:
	SELECT * FROM MasterData.Entity.vw_Generic

REMARKS:
	None.

Modification History
--------------------
User	Date		Comment
MWood	14/08/2017	Initial version.
**********************************************************************************************************************/
CREATE VIEW [Entity].[vw_Generic]
AS

SELECT
		e.EntityKey
		,e.EntityName
	FROM
		Entity.Entity e
	JOIN Entity.EntityType et
		ON e.EntityTypeKey = et.EntityTypeKey
	WHERE
		et.EntityTypeName = 'Generic';

GO
/****** Object:  Table [Hierarchy].[Audit]    Script Date: 31/03/2019 12:00:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hierarchy].[Audit](
	[AuditKey] [int] IDENTITY(1,1) NOT NULL,
	[AuditDate] [datetime2](3) NOT NULL,
	[Action] [varchar](10) NOT NULL,
	[AuditMessage] [varchar](400) NULL,
	[Username] [varchar](20) NULL,
 CONSTRAINT [PK_Audit] PRIMARY KEY CLUSTERED 
(
	[AuditKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Hierarchy].[Hierarchy]    Script Date: 31/03/2019 12:00:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hierarchy].[Hierarchy](
	[HierarchyKey] [int] IDENTITY(1,1) NOT NULL,
	[HierarchyName] [varchar](50) NOT NULL,
	[HierarchyDescription] [varchar](200) NULL,
 CONSTRAINT [PK_Hierarchy] PRIMARY KEY CLUSTERED 
(
	[HierarchyKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_Hierarchy] UNIQUE NONCLUSTERED 
(
	[HierarchyName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Hierarchy].[HierarchyNode]    Script Date: 31/03/2019 12:00:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hierarchy].[HierarchyNode](
	[HierarchyNode] [hierarchyid] NOT NULL,
	[HierarchyNodeKey] [int] NOT NULL,
	[HierarchyKey] [int] NOT NULL,
	[NodeTypeKey] [int] NULL,
	[NodeKey] [int] NULL,
	[NodeDisplayNameOverride] [varchar](50) NULL,
	[ParentHierarchyNodeKey] [int] NULL,
	[HierarchyLevel]  AS ([HierarchyNode].[GetLevel]()),
 CONSTRAINT [PK_HierarchyNode] PRIMARY KEY CLUSTERED 
(
	[HierarchyNode] ASC,
	[HierarchyKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_HierarchyNode_HierarchyNodeKey] UNIQUE NONCLUSTERED 
(
	[HierarchyNodeKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Hierarchy].[HierarchyNodeRole]    Script Date: 31/03/2019 12:00:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hierarchy].[HierarchyNodeRole](
	[HierarchyNodeKey] [int] NOT NULL,
	[RoleKey] [int] NOT NULL,
 CONSTRAINT [PK_HierarchyNodeRole] PRIMARY KEY CLUSTERED 
(
	[HierarchyNodeKey] ASC,
	[RoleKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Hierarchy].[NodeType]    Script Date: 31/03/2019 12:00:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hierarchy].[NodeType](
	[NodeTypeKey] [int] IDENTITY(1,1) NOT NULL,
	[NodeTypeName] [varchar](30) NOT NULL,
	[NodeTypeDescription] [varchar](200) NULL,
	[SqlEntity] [varchar](400) NOT NULL,
	[NodeDisplayColumn] [varchar](50) NOT NULL,
	[NodeKeyColumn] [varchar](50) NOT NULL,
	[AllowNodeToRepeatInHierarchy] [bit] NOT NULL,
	[DetailDisplayColumnCommaSeparatedList] [varchar](200) NULL,
 CONSTRAINT [PK_NodeType] PRIMARY KEY CLUSTERED 
(
	[NodeTypeKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_NodeType] UNIQUE NONCLUSTERED 
(
	[NodeTypeName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Hierarchy].[Role]    Script Date: 31/03/2019 12:00:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hierarchy].[Role](
	[RoleKey] [int] IDENTITY(1,1) NOT NULL,
	[RoleName] [varchar](30) NOT NULL,
	[RoleDescription] [varchar](200) NULL,
 CONSTRAINT [PK_Role] PRIMARY KEY CLUSTERED 
(
	[RoleKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Hierarchy].[NodeType] ADD  CONSTRAINT [DF_NodeType_AllowNodeToRepeatInHierarchy]  DEFAULT ((0)) FOR [AllowNodeToRepeatInHierarchy]
GO
ALTER TABLE [Entity].[Entity]  WITH CHECK ADD  CONSTRAINT [FK_Entity_EntityType] FOREIGN KEY([EntityTypeKey])
REFERENCES [Entity].[EntityType] ([EntityTypeKey])
GO
ALTER TABLE [Entity].[Entity] CHECK CONSTRAINT [FK_Entity_EntityType]
GO
/****** Object:  StoredProcedure [Hierarchy].[up_AlterHierarchy]    Script Date: 31/03/2019 12:00:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [Hierarchy].[up_AlterHierarchy] 
	@HierarchyKey int = NULL
	,@HierarchyName varchar(50) = NULL
	,@HierarchyDescription varchar(200) = NULL
	,@DestinationHierarchyName varchar(50) = NULL
	,@Action varchar(10) = NULL
	,@HierarchyNodeKey int = NULL
	,@DestinationHierarchyKey int = NULL
	,@DestinationParentHierarchyNodeKey int = NULL
	,@NodeTypeKey int = NULL
	,@NodeTypeName varchar(30) = NULL
	,@NodeKey int = NULL
	,@RoleKey int = NULL
	,@NodeDisplayNameOverride varchar(50) = NULL
	,@ParentNodeName varchar(50) = NULL
	,@DestinationParentNodeName varchar(50) = NULL
	,@NodeName varchar(50) = NULL
	,@RoleName varchar(50) = NULL
	,@Username varchar(20) = NULL
	,@NodeNumberOfChildren int = NULL
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @NodeToHighlight int
			,@SourceParentHierarchyNodeKey int
			,@SourceHierarchyNode hierarchyid
			,@ParentHierarchyNode hierarchyid
			,@DestinationParentHierarchyNode hierarchyid
			,@MaxChildNode hierarchyid
			,@sql nvarchar(200)
			,@HierarchyNodeKeyToStartFrom int;

	IF @Action IS NULL 
	BEGIN
		SELECT NULL AS Value, 0 AS Label;
		RETURN;
	END;

	IF @Action = 'CREATE'
	BEGIN
		INSERT INTO Hierarchy.Hierarchy
			(HierarchyName, HierarchyDescription)
			VALUES	
				(@HierarchyName, NULLIF(LTRIM(RTRIM(@HierarchyDescription)), ''));

		SET @HierarchyKey = SCOPE_IDENTITY();

		/* Ensure the Sequence object is set to the correct next-available key value */
		SELECT
				@HierarchyNodeKeyToStartFrom = COALESCE(MAX(HierarchyNodeKey), 0) + 1
			FROM 
				Hierarchy.HierarchyNode;

		SET @sql = N'ALTER SEQUENCE [Hierarchy].[HierarchyNodeKeySequence] RESTART WITH ' + CAST(@HierarchyNodeKeyToStartFrom AS varchar) + ';'
		EXEC sp_executesql @sql;

		INSERT INTO Hierarchy.HierarchyNode
			(HierarchyNode
			,HierarchyNodeKey
			,HierarchyKey
			,NodeDisplayNameOverride)
			VALUES
				(hierarchyid::GetRoot()
				,NEXT VALUE FOR Hierarchy.HierarchyNodeKeySequence
				,@HierarchyKey
				,@HierarchyName);
	END;

	IF @Action = 'DELETE'
	BEGIN
		SELECT
				@NodeToHighlight = ParentHierarchyNodeKey
			FROM
				Hierarchy.HierarchyNode
			WHERE
				HierarchyKey = @HierarchyKey
				AND HierarchyNodeKey = @HierarchyNodeKey;

		SET TRANSACTION ISOLATION LEVEL SERIALIZABLE  
		BEGIN TRANSACTION;

		DELETE Hierarchy.HierarchyNode
			WHERE
				HierarchyKey = @HierarchyKey
				AND HierarchyNodeKey = @HierarchyNodeKey;

		INSERT INTO Hierarchy.Audit
				(AuditDate, Action, AuditMessage, Username)
			VALUES
				(CURRENT_TIMESTAMP
				,@Action
				,CONCAT(@NodeTypeName, ' Node ''', @NodeName,  ''' (Key: ', CAST(@NodeKey AS varchar), ') ', CASE WHEN COALESCE(@NodeNumberOfChildren, 0) = 0 THEN '' ELSE ' and its ' + CAST(@NodeNumberOfChildren AS varchar) + CASE WHEN @NodeNumberOfChildren = 1 THEN ' child ' ELSE ' children ' END END, 'deleted from Hierarchy ''', @HierarchyName, '''.')
				,@Username);
	
		COMMIT;
	END;
		
	IF @Action = 'ADD'	
	BEGIN
		/* Ensure the Sequence object is set to the correct next-available key value */
		SELECT
				@HierarchyNodeKeyToStartFrom = MAX(HierarchyNodeKey) + 1
			FROM 
				Hierarchy.HierarchyNode;

		SET @sql = N'ALTER SEQUENCE [Hierarchy].[HierarchyNodeKeySequence] RESTART WITH ' + CAST(@HierarchyNodeKeyToStartFrom AS varchar) + ';'
		EXEC sp_executesql @sql;

		SELECT @NodeToHighlight = NEXT VALUE FOR Hierarchy.HierarchyNodeKeySequence;

		SELECT
				@ParentHierarchyNode = HierarchyNode
			FROM
				Hierarchy.HierarchyNode
			WHERE
				HierarchyKey = @HierarchyKey 
				AND HierarchyNodeKey = @HierarchyNodeKey;

		SELECT 
				@MaxChildNode = MAX(HierarchyNode)   
			FROM 
				Hierarchy.HierarchyNode
			WHERE 
				HierarchyKey = @HierarchyKey 
				AND HierarchyNode.GetAncestor(1) = @ParentHierarchyNode;  
	  
		SET TRANSACTION ISOLATION LEVEL SERIALIZABLE  
		BEGIN TRANSACTION;

		INSERT INTO Hierarchy.HierarchyNode 
				(HierarchyNode, HierarchyNodeKey, HierarchyKey, NodeTypeKey, NodeKey, ParentHierarchyNodeKey, NodeDisplayNameOverride)  
			VALUES  
				(@ParentHierarchyNode.GetDescendant(@MaxChildNode, NULL)
				,@NodeToHighlight
				,@HierarchyKey
				,@NodeTypeKey
				,@NodeKey
				,@HierarchyNodeKey
				,@NodeDisplayNameOverride);

		IF @RoleKey IS NOT NULL
			INSERT INTO Hierarchy.HierarchyNodeRole
					(HierarchyNodeKey, RoleKey)
				VALUES
					(@NodeToHighlight
					,@RoleKey);

		INSERT INTO Hierarchy.Audit
				(AuditDate, Action, AuditMessage, Username)
			VALUES
				(CURRENT_TIMESTAMP
				,@Action
				,CONCAT(@NodeTypeName, ' Node ''', @NodeName,  ''' (Key: ', CAST(@NodeKey AS varchar), ') ', 'added to Hierarchy ''', @HierarchyName, ''' under Parent ''', RTRIM(LTRIM(@ParentNodeName)), '''', CASE WHEN @RoleName IS NULL THEN '' ELSE ' in the Role of ' + @RoleName END, '.')
				,@Username);
	
		COMMIT;
	END;

	IF @Action = 'MOVE'
	BEGIN
		SELECT 
				@SourceParentHierarchyNodeKey = ParentHierarchyNodeKey
				,@SourceHierarchyNode = HierarchyNode
			FROM
				Hierarchy.HierarchyNode
			WHERE
				HierarchyKey = @HierarchyKey
				AND HierarchyNodeKey = @HierarchyNodeKey;

		SELECT 
				@DestinationParentHierarchyNode = HierarchyNode
			FROM
				Hierarchy.HierarchyNode
			WHERE
				HierarchyKey = @HierarchyKey
				AND HierarchyNodeKey = @DestinationParentHierarchyNodeKey;

		SELECT 
				@DestinationParentHierarchyNode = @DestinationParentHierarchyNode.GetDescendant(MAX(HierarchyNode), NULL)   
			FROM 
				Hierarchy.HierarchyNode 
			WHERE 
				HierarchyKey = @HierarchyKey 
				AND HierarchyNode.GetAncestor(1) = @DestinationParentHierarchyNode;  

		SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
		BEGIN TRANSACTION; 

		UPDATE Hierarchy.HierarchyNode
			SET 
				HierarchyNode = HierarchyNode.GetReparentedValue(@SourceHierarchyNode, @DestinationParentHierarchyNode)  
				,ParentHierarchyNodeKey =	CASE
												WHEN ParentHierarchyNodeKey = @SourceParentHierarchyNodeKey THEN @DestinationParentHierarchyNodeKey
												ELSE ParentHierarchyNodeKey
											END 
			WHERE 
				HierarchyKey = @HierarchyKey 
				AND HierarchyNode.IsDescendantOf(@SourceHierarchyNode) = 1;  

		INSERT INTO Hierarchy.Audit
				(AuditDate, Action, AuditMessage, Username)
			VALUES
				(CURRENT_TIMESTAMP
				,@Action
				,CONCAT(@NodeTypeName, ' Node ''', @NodeName,  ''' (Key: ', CAST(@NodeKey AS varchar), ')', CASE WHEN COALESCE(@NodeNumberOfChildren, 0) = 0 THEN ' ' ELSE ' and its ' + CAST(@NodeNumberOfChildren AS varchar) + CASE WHEN @NodeNumberOfChildren = 1 THEN ' child ' ELSE ' children ' END END, 'moved from Parent ''', @ParentNodeName, ''' to Parent ''', RTRIM(LTRIM(@DestinationParentNodeName)), ''' in Hierarchy ''', @HierarchyName, '''.')
				,@Username);

		COMMIT TRANSACTION;

		SET @NodeToHighlight = @HierarchyNodeKey;
	END;

	IF @Action = 'COPY'
	BEGIN
		/* Ensure the Sequence object is set to the correct next-available key value */
		SELECT
				@HierarchyNodeKeyToStartFrom = MAX(HierarchyNodeKey) + 1
			FROM 
				Hierarchy.HierarchyNode;

		SET @sql = N'ALTER SEQUENCE [Hierarchy].[HierarchyNodeKeySequence] RESTART WITH ' + CAST(@HierarchyNodeKeyToStartFrom AS varchar) + ';'
		EXEC sp_executesql @sql;

		DECLARE @NodesToCopy table (NewHierarchyNodeKey int, OldHierarchyNodeKey int);

		SELECT 
				@SourceParentHierarchyNodeKey = ParentHierarchyNodeKey
				,@SourceHierarchyNode = HierarchyNode
			FROM
				Hierarchy.HierarchyNode
			WHERE
				HierarchyKey = @HierarchyKey
				AND HierarchyNodeKey = @HierarchyNodeKey;

		/* Prepare new HierarchyNodeKeys */
		INSERT INTO @NodesToCopy
				(NewHierarchyNodeKey
				,OldHierarchyNodeKey)
			SELECT
					NEXT VALUE FOR Hierarchy.HierarchyNodeKeySequence
					,HierarchyNodeKey
				FROM 
					Hierarchy.HierarchyNode
				WHERE 
					HierarchyKey = @HierarchyKey 
					AND HierarchyNode.IsDescendantOf(@SourceHierarchyNode) = 1;

		/* Check that the nodes to copy do not violate the 'Not-Repeatable' attribute on the Nodes that already exist in the destination Hierarchy */
		DECLARE @NonRepeatableNodesAlreadyExistInDestinationHierarchy bit = 0;

		WITH NonRepeatableNodes AS
		(
			SELECT
					hn.NodeTypeKey
					,hn.NodeKey
				FROM
					@NodesToCopy ntc
				JOIN Hierarchy.HierarchyNode hn
					ON ntc.OldHierarchyNodeKey = hn.HierarchyNodeKey
				JOIN Hierarchy.NodeType nt
					ON hn.NodeTypeKey = nt.NodeTypeKey
				WHERE
					nt.AllowNodeToRepeatInHierarchy = 0
		)

		SELECT
				@NonRepeatableNodesAlreadyExistInDestinationHierarchy = 1
			FROM
				Hierarchy.HierarchyNode hn
			JOIN NonRepeatableNodes nrn
				ON hn.NodeTypeKey = nrn.NodeTypeKey
				AND hn.NodeKey = nrn.NodeKey				
			WHERE
				hn.HierarchyKey = @DestinationHierarchyKey;		

		IF @NonRepeatableNodesAlreadyExistInDestinationHierarchy = 1
		BEGIN
			SELECT NULL AS Value, -999 AS Label;
			RETURN;
		END;

		SELECT 
				@DestinationParentHierarchyNode = HierarchyNode
			FROM
				Hierarchy.HierarchyNode
			WHERE
				HierarchyKey = @DestinationHierarchyKey
				AND HierarchyNodeKey = @DestinationParentHierarchyNodeKey;

		SELECT 
				@DestinationParentHierarchyNode = @DestinationParentHierarchyNode.GetDescendant(MAX(HierarchyNode), NULL)   
			FROM 
				Hierarchy.HierarchyNode 
			WHERE 
				HierarchyKey = @DestinationHierarchyKey
				AND HierarchyNode.GetAncestor(1) = @DestinationParentHierarchyNode;  

		SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
		BEGIN TRANSACTION; 

		INSERT INTO Hierarchy.HierarchyNode 
				(HierarchyNode, HierarchyNodeKey, HierarchyKey, NodeTypeKey, NodeKey, ParentHierarchyNodeKey, NodeDisplayNameOverride)  
			SELECT
					hn.HierarchyNode.GetReparentedValue(@SourceHierarchyNode, @DestinationParentHierarchyNode)
					,c.NewHierarchyNodeKey
					,@DestinationHierarchyKey
					,hn.NodeTypeKey
					,hn.NodeKey
					,CASE
						WHEN COALESCE(hn.ParentHierarchyNodeKey, -1) = COALESCE(@SourceParentHierarchyNodeKey, -1) THEN @DestinationParentHierarchyNodeKey
						ELSE cParent.NewHierarchyNodeKey
					END
					,hn.NodeDisplayNameOverride
				FROM
					Hierarchy.HierarchyNode hn
				JOIN @NodesToCopy c
					ON hn.HierarchyNodeKey = c.OldHierarchyNodeKey
				LEFT JOIN @NodesToCopy cParent
					ON hn.ParentHierarchyNodeKey = cParent.OldHierarchyNodeKey
				WHERE 
					hn.HierarchyKey = @HierarchyKey 
					AND hn.HierarchyNode.IsDescendantOf(@SourceHierarchyNode) = 1;  

		INSERT INTO Hierarchy.Audit
				(AuditDate, Action, AuditMessage, Username)
			VALUES
				(CURRENT_TIMESTAMP
				,@Action
				,CONCAT(@NodeTypeName, ' Node ''', @NodeName,  ''' (Key: ', CAST(@NodeKey AS varchar), ')', CASE WHEN COALESCE(@NodeNumberOfChildren, 0) = 0 THEN ' ' ELSE ' and its ' + CAST(@NodeNumberOfChildren AS varchar) + CASE WHEN @NodeNumberOfChildren = 1 THEN ' child ' ELSE ' children ' END END, 'copied from Hierarchy ''', @HierarchyName, ''' to Hierarchy ''', @DestinationHierarchyName, ''' under Parent ''', RTRIM(LTRIM(@DestinationParentNodeName)), '''.')
				,@Username);

		COMMIT TRANSACTION;

		SELECT 
				@NodeToHighlight = NewHierarchyNodeKey
			FROM
				@NodesToCopy
			WHERE 
				OldHierarchyNodeKey = @HierarchyNodeKey;

	END;

	SELECT NULL AS Value, @NodeToHighlight AS Label;

END

GO
/****** Object:  StoredProcedure [Hierarchy].[up_Hierarchies]    Script Date: 31/03/2019 12:00:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [Hierarchy].[up_Hierarchies] 
	@ExcludeThisHierarchyKey int = NULL
AS
BEGIN

	SET NOCOUNT ON;

	SELECT
			HierarchyKey AS Value
			,HierarchyName AS Label
		FROM
			Hierarchy.Hierarchy
		WHERE
			@ExcludeThisHierarchyKey IS NULL
			OR HierarchyKey <> @ExcludeThisHierarchyKey
		ORDER BY
			Label;

END


GO
/****** Object:  StoredProcedure [Hierarchy].[up_Hierarchy]    Script Date: 31/03/2019 12:00:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Hierarchy].[up_Hierarchy] 
	@HierarchyKey int
	,@ShowRoleInNodeName bit = 0
	,@HierarchyNodeKey int = NULL
	,@ShowSqlOnly bit = 0
AS
BEGIN

	DECLARE @sql nvarchar(MAX) = '';

	/* If the parameter @HierarchyNodeKey is not null, find the HierarchyNode it corresponds to */
	DECLARE @Node hierarchyid = NULL;
	SELECT
			@Node = HierarchyNode
		FROM
			Hierarchy.HierarchyNode
		WHERE
			HierarchyKey = @HierarchyKey
			AND HierarchyNodeKey = @HierarchyNodeKey;

	IF OBJECT_ID('tempdb..#HierarchyNodes') IS NOT NULL
		DROP TABLE #HierarchyNodes;

	WITH HierarchyNodes AS 
	(
		SELECT DISTINCT
				nt.NodeTypeName
				,nt.SqlEntity
				,nt.NodeDisplayColumn
				,nt.NodeKeyColumn 
			FROM 
				Hierarchy.HierarchyNode hn
			JOIN Hierarchy.NodeType nt
				ON hn.NodeTypeKey = nt.NodeTypeKey
			WHERE
				hn.HierarchyKey = @HierarchyKey
	)

	SELECT
			*
			,ROW_NUMBER() OVER (ORDER BY NodeTypeName) AS RowNum
		INTO
			#HierarchyNodes
		FROM 
			HierarchyNodes;

	SET @sql = 
'WITH Roles AS
(
	SELECT 
			hnr.HierarchyNodeKey
			,MAX(r.Roles) AS Roles
        FROM 
			Hierarchy.HierarchyNodeRole hnr
		JOIN Hierarchy.HierarchyNode hn
			ON hnr.HierarchyNodeKey = hn.HierarchyNodeKey
        CROSS APPLY (SELECT STUFF((	SELECT 
											'', '' + r.RoleName
										FROM 
											Hierarchy.HierarchyNodeRole hnr2
										JOIN Hierarchy.Role r
											ON hnr2.RoleKey = r.RoleKey
										WHERE 
											hnr2.HierarchyNodeKey = hnr.HierarchyNodeKey
										ORDER BY 
											r.RoleName
										FOR XML PATH(''''), TYPE).value(''.'',''VARCHAR(MAX)''), 1, 2, '''') AS Roles) r
		WHERE
			hn.HierarchyKey = ' + CAST(@HierarchyKey AS varchar) + '
        GROUP BY 
			hnr.HierarchyNodeKey
)

,Nodes AS 
(
	SELECT 
			hn.HierarchyNode.ToString() AS LogicalNode
			,hn.HierarchyNode
			,hn.HierarchyNode.GetAncestor(1) AS Parent
			,hn.HierarchyLevel
			,hn.HierarchyNodeKey
			,r.Roles AS RoleName
			,hn.ParentHierarchyNodekey
			,nt.NodeTypeName
			,hn.NodeKey
			,CAST(COALESCE(hn.NodeDisplayNameOverride';
		
	SELECT
			@sql += ', LEFT(t' + CAST(RowNum AS varchar) + '.' + NodeDisplayColumn + ', 50)'
		FROM
			#HierarchyNodes
		ORDER BY 
			RowNum;
		
	SET @sql +=	', '''') AS varchar(50))' + CASE WHEN @ShowRoleInNodeName = 1 THEN ' + COALESCE('' ('' + r.Roles + '')'', '''')' ELSE '' END + ' AS NodeDisplayName 
		FROM 
			[Hierarchy].[HierarchyNode] hn
		LEFT JOIN Hierarchy.NodeType nt
			ON hn.NodeTypeKey = nt.NodeTypeKey
		LEFT JOIN Roles r
			ON hn.HierarchyNodeKey = r.HierarchyNodeKey';

	SELECT
		@sql += CHAR(10) + 
'		LEFT JOIN ' + SqlEntity + ' t' + CAST(RowNum AS varchar) + '
			ON nt.NodeTypeName = ''' + NodeTypeName + '''
			AND hn.NodeKey = t' + CAST(RowNum AS varchar) + '.' + NodeKeyColumn
		FROM
			#HierarchyNodes
		ORDER BY 
			RowNum;

	SET @sql += CHAR(10) +
'		WHERE
			hn.HierarchyKey = ' + CAST(@HierarchyKey AS varchar) + 
		CASE 
			WHEN @HierarchyNodeKey IS NULL THEN ''
			ELSE CHAR(10) + 
				'			AND hn.HierarchyNode.IsDescendantOf((SELECT HierarchyNode FROM Hierarchy.HierarchyNode WHERE HierarchyKey = ' + CAST(@HierarchyKey AS varchar) + ' AND HierarchyNodeKey = ' + CAST(@HierarchyNodeKey AS varchar) + ')) = 1'
		END + CHAR(10) + 
')

,Tree AS 
(
	SELECT
			LogicalNode
			,HierarchyNode
			,Parent
			,HierarchyLevel
			,HierarchyNodeKey
			,RoleName
			,ParentHierarchyNodekey
			,NodeDisplayName
			,NodeTypeName
			,NodeKey 
			,CAST(NULL AS varchar(50)) AS ParentNodeName
			,CAST(''\'' + NodeDisplayName AS varchar(1000)) AS Sort
		FROM
			Nodes
		WHERE 
			' + CASE WHEN @HierarchyNodeKey IS NULL THEN 'Parent IS NULL' ELSE 'HierarchyNodeKey = ' + CAST(@HierarchyNodeKey AS varchar) END + '
        
	UNION ALL
        
	SELECT
			childNode.LogicalNode
			,childNode.HierarchyNode
			,childNode.Parent
			,childNode.HierarchyLevel
			,childNode.HierarchyNodeKey
			,childNode.RoleName
			,childNode.ParentHierarchyNodekey
			,childNode.NodeDisplayName 
			,childNode.NodeTypeName
			,childNode.NodeKey 
			,CAST(lit.NodeDisplayName AS varchar(50)) AS ParentNodeName
			,CAST(lit.sort + ''\'' + childNode.NodeDisplayName AS varchar(1000)) AS Sort
		FROM
			Nodes AS childNode 
		JOIN [Tree] lit
			ON childNode.Parent = lit.HierarchyNode
		WHERE
			childNode.Parent IS NOT NULL
)

SELECT  
		LogicalNode
		,HierarchyLevel
		,HierarchyNodeKey
		,RoleName
		,ParentHierarchyNodekey
		,NodeDisplayName 
		,NodeTypeName
		,NodeKey 
		,ParentNodeName
		,Sort
	FROM
		Tree
	ORDER BY
		Sort;';

	IF @ShowSqlOnly = 1
		PRINT @Sql;
	ELSE
		EXEC sp_executesql @sql;

END

GO
/****** Object:  StoredProcedure [Hierarchy].[up_HierarchyNodeTypes]    Script Date: 31/03/2019 12:00:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Hierarchy].[up_HierarchyNodeTypes] 
AS
BEGIN

	SET NOCOUNT ON;

	SELECT
			NodeTypeKey AS Value
			,NodeTypeName AS Label
		FROM
			Hierarchy.NodeType
		ORDER BY
			Label;

END

GO
/****** Object:  StoredProcedure [Hierarchy].[up_HierarchyParameter]    Script Date: 31/03/2019 12:00:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Hierarchy].[up_HierarchyParameter] 
	@HierarchyKey int
	,@ShowRoleInNodeName bit = 0
	,@HierarchyNodeKey int = NULL
AS
BEGIN

	DECLARE @sql nvarchar(MAX) = '';

	/* If the parameter @HierarchyNodeKey is not null, find the HierarchyNode it corresponds to */
	DECLARE @Node hierarchyid = NULL;
	SELECT
			@Node = HierarchyNode
		FROM
			Hierarchy.HierarchyNode
		WHERE
			HierarchyNodeKey = @HierarchyNodeKey;

	IF OBJECT_ID('tempdb..#HierarchyNodes') IS NOT NULL
		DROP TABLE #HierarchyNodes;

	WITH HierarchyNodes AS 
	(
		SELECT DISTINCT
				nt.NodeTypeName
				,nt.SqlEntity
				,nt.NodeDisplayColumn
				,nt.NodeKeyColumn 
			FROM 
				Hierarchy.HierarchyNode hn
			JOIN Hierarchy.NodeType nt
				ON hn.NodeTypeKey = nt.NodeTypeKey
			WHERE
				hn.HierarchyKey = @HierarchyKey
	)

	SELECT
			*
			,ROW_NUMBER() OVER (ORDER BY NodeTypeName) AS RowNum
		INTO
			#HierarchyNodes
		FROM 
			HierarchyNodes;

	SET @sql = 
'WITH Roles AS
(
	SELECT 
			hnr.HierarchyNodeKey
			,MAX(r.Roles) AS Roles
        FROM 
			Hierarchy.HierarchyNodeRole hnr
		JOIN Hierarchy.HierarchyNode hn
			ON hnr.HierarchyNodeKey = hn.HierarchyNodeKey
        CROSS APPLY (SELECT STUFF((	SELECT 
											'', '' + r.RoleName
										FROM 
											Hierarchy.HierarchyNodeRole hnr2
										JOIN Hierarchy.Role r
											ON hnr2.RoleKey = r.RoleKey
										WHERE 
											hnr2.HierarchyNodeKey = hnr.HierarchyNodeKey
										ORDER BY 
											r.RoleName
										FOR XML PATH(''''), TYPE).value(''.'',''VARCHAR(MAX)''), 1, 2, '''') AS Roles) r
		WHERE
			hn.HierarchyKey = ' + CAST(@HierarchyKey AS varchar) + '
        GROUP BY 
			hnr.HierarchyNodeKey
)

SELECT 
		hn.HierarchyNode.ToString() AS LogicalNode
		,hn.HierarchyLevel
		,hn.HierarchyNodeKey
		,r.Roles AS RoleName
		,hn.ParentHierarchyNodekey
		,COALESCE(hn.NodeDisplayNameOverride';
		
	SELECT
			@sql += ', t' + CAST(RowNum AS varchar) + '.' + NodeDisplayColumn
		FROM
			#HierarchyNodes
		ORDER BY 
			RowNum;
		
	SET @sql +=	', '''')' + CASE WHEN @ShowRoleInNodeName = 1 THEN ' + COALESCE('' ('' + RoleName + '')'', '''')' ELSE '' END + ' AS NodeDisplayName 
		FROM 
			[Hierarchy].[HierarchyNode] hn
		LEFT JOIN Hierarchy.NodeType nt
			ON hn.NodeTypeKey = nt.NodeTypeKey
		LEFT JOIN Roles r
			ON hn.HierarchyNodeKey = r.HierarchyNodeKey';

	SELECT
		@sql += CHAR(10) + 
	'	LEFT JOIN ' + SqlEntity + ' t' + CAST(RowNum AS varchar) + '
			ON nt.NodeTypeName = ''' + NodeTypeName + '''
			AND hn.NodeKey = t' + CAST(RowNum AS varchar) + '.' + NodeKeyColumn
		FROM
			#HierarchyNodes
		ORDER BY 
			RowNum;

	SET @sql += CHAR(10) +
	'	WHERE
			hn.HierarchyKey = ' + CAST(@HierarchyKey AS varchar) + 
		CASE 
			WHEN @HierarchyNodeKey IS NULL THEN ';'
			ELSE CHAR(10) + 
				'		AND hn.HierarchyNode.IsDescendantOf((SELECT HierarchyNode FROM Hierarchy.HierarchyNode WHERE HierarchyNodeKey = ' + CAST(@HierarchyNodeKey AS varchar) + ')) = 1;'
		END;
		 
	EXEC sp_executesql @sql;

END

GO
/****** Object:  StoredProcedure [Hierarchy].[up_HierarchyTypes]    Script Date: 31/03/2019 12:00:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [Hierarchy].[up_HierarchyTypes] 
AS
BEGIN

	SET NOCOUNT ON;

	SELECT
			HierarchyTypeKey AS Value
			,HierarchyTypeName AS Label
		FROM
			Hierarchy.HierarchyType
		ORDER BY
			Label;

END

GO
/****** Object:  StoredProcedure [Hierarchy].[up_Nodes]    Script Date: 31/03/2019 12:00:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [Hierarchy].[up_Nodes] 
	@NodeTypeKey int
	,@HierarchyKey int
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @sql nvarchar(3000) = '';
	DECLARE @sqlDetailColumns nvarchar(1000) = '';

	DECLARE @Results table	(NodeKey int
							,NodeName varchar(50)
							,DetailColumn1Header varchar(50)
							,DetailColumn1Value varchar(50)
							,DetailColumn2Header varchar(50)
							,DetailColumn2Value varchar(50)
							,DetailColumn3Header varchar(50)
							,DetailColumn3Value varchar(50)
							,DetailColumn4Header varchar(50)
							,DetailColumn4Value varchar(50)
							,DetailColumn5Header varchar(50)
							,DetailColumn5Value varchar(50));

	DECLARE @DetailColumns table (ColumnPosition int);

	/* The report allows for up to 5 detail columns to show for a Node */
	INSERT INTO @DetailColumns
			(ColumnPosition)
		VALUES
			(1), (2), (3), (4), (5);

	SELECT
			@sqlDetailColumns = MAX(d.DetailColumns)
		FROM
			Hierarchy.NodeType nt
		CROSS APPLY	(SELECT STUFF((	SELECT 
											CHAR(10) + '		,''' + COALESCE(ds.String, '') + ''' AS DetailColumnHeader' + CAST(dc.ColumnPosition AS varchar) + CHAR(10) + '		,' + COALESCE(ds.String, '''''') + ' AS DetailColumnValue' + CAST(dc.ColumnPosition AS varchar)
										FROM 
											@DetailColumns dc
										LEFT JOIN DataWarehouse.dbo.fn_SplitDelimitedString(nt.DetailDisplayColumnCommaSeparatedList, ',') ds
											ON dc.ColumnPosition = ds.StringPosition
										ORDER BY 
											dc.ColumnPosition
										FOR XML PATH(''), TYPE).value('.','VARCHAR(MAX)'), 1, 0, '') AS DetailColumns) d
		WHERE
			nt.NodeTypeKey = @NodeTypeKey
		GROUP BY
			nt.NodeTypeKey;

	SELECT @sql = 
	'SELECT' + CHAR(10) + 
	'		' + NodeKeyColumn + ' AS NodeKey' + CHAR(10) +
	'		,' + NodeDisplayColumn + ' AS NodeName' + 
	@sqlDetailColumns  + CHAR(10) + 
	'	FROM' + CHAR(10) +
	'		' + SqlEntity + CHAR(10) +
	'	ORDER BY
			NodeName;'
		FROM
			Hierarchy.NodeType
		WHERE
			NodeTypeKey = @NodeTypeKey;

--	PRINT @sql;

	INSERT INTO @Results
		EXEC sp_executesql @sql;

	SELECT
			*
		FROM
			@Results r
		JOIN Hierarchy.NodeType nt
			ON nt.NodeTypeKey = @NodeTypeKey 
		LEFT JOIN Hierarchy.HierarchyNode hn
			ON r.NodeKey = hn.NodeKey
			AND hn.NodeTypeKey = nt.NodeTypeKey
			AND hn.HierarchyKey = @HierarchyKey
		WHERE
			nt.AllowNodeToRepeatInHierarchy = 1
			OR (hn.HierarchyNodeKey IS NULL);

END

GO
/****** Object:  StoredProcedure [Hierarchy].[up_Roles]    Script Date: 31/03/2019 12:00:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [Hierarchy].[up_Roles] 
AS
BEGIN

	SET NOCOUNT ON;

	SELECT
			RoleKey AS Value
			,RoleName AS Label
		FROM
			Hierarchy.Role

	UNION ALL

	SELECT
			NULL AS Value
			,'<None>' AS Label
		ORDER BY
			Label;

END

GO
