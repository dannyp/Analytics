/****** Object:  Schema [JSON]    Script Date: 1/04/2019 9:57:08 PM ******/
CREATE SCHEMA [JSON]
GO
/****** Object:  Schema [Process]    Script Date: 1/04/2019 9:57:08 PM ******/
CREATE SCHEMA [Process]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_CurrentBusinessDate]    Script Date: 1/04/2019 9:57:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_CurrentBusinessDate]()
RETURNS date
AS
BEGIN

    DECLARE @BusinessDate date = SYSUTCDATETIME() AT TIME ZONE 'UTC' AT TIME ZONE 'Cen. Australia Standard Time';
    /* Return the result of the function */
    RETURN @BusinessDate;

END

GO
/****** Object:  Table [JSON].[Variable]    Script Date: 1/04/2019 9:57:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [JSON].[Variable](
	[VariableKey] [int] IDENTITY(1,1) NOT NULL,
	[OwningEntity] [varchar](100) NOT NULL,
	[KeyDefiningVariableComposition] [int] NOT NULL,
	[VariableName] [varchar](100) NOT NULL,
	[IsMandatory] [bit] NOT NULL,
	[DefaultValue] [varchar](50) NULL,
 CONSTRAINT [PKC_JSON_Variable] PRIMARY KEY NONCLUSTERED 
(
	[VariableKey] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Process].[DatabaseEntity]    Script Date: 1/04/2019 9:57:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Process].[DatabaseEntity](
	[DatabaseEntityKey] [int] IDENTITY(1,1) NOT NULL,
	[DatabaseEntityName] [varchar](100) NOT NULL,
	[DataDateSuccessfullyProcessed] [date] NOT NULL,
 CONSTRAINT [PK_DatabaseEntity] PRIMARY KEY CLUSTERED 
(
	[DatabaseEntityKey] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Process].[Entity]    Script Date: 1/04/2019 9:57:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Process].[Entity](
	[EntityKey] [int] IDENTITY(1,1) NOT NULL,
	[EntityName] [varchar](100) NULL,
	[ProcessTypeKey] [int] NULL,
	[EntityGroupKey] [int] NULL,
	[SortOrder] [smallint] NULL,
	[DependenciesToCheckForDataIsReady] [varchar](4000) NULL,
	[DependenciesToCheckForDataIsLoaded] [varchar](4000) NULL,
	[DependentEntities] [varchar](4000) NULL,
	[DependencyEntityToSetForDataIsReady] [varchar](100) NULL,
	[VariablesJSON] [varchar](max) NULL,
	[IsActive] [bit] NOT NULL,
	[IsProcessing] [bit] NOT NULL,
	[HasProcessed] [bit] NOT NULL,
	[LastRunStartTime] [datetime2](3) NULL,
	[LastRunEndTime] [datetime2](3) NULL,
	[Result] [varchar](20) NULL,
	[ResultsJSON] [varchar](max) NULL,
 CONSTRAINT [PK_Process_Entity] PRIMARY KEY CLUSTERED 
(
	[EntityKey] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Process].[EntityExecution]    Script Date: 1/04/2019 9:57:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Process].[EntityExecution](
	[EntityExecutionKey] [int] IDENTITY(1,1) NOT NULL,
	[EntityKey] [int] NOT NULL,
	[ExecutionDateTime] [datetime2](3) NOT NULL,
	[Result] [varchar](20) NULL,
	[ResultsJSON] [varchar](max) NULL,
 CONSTRAINT [PK_Process_EntityExecution] PRIMARY KEY CLUSTERED 
(
	[EntityExecutionKey] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Process].[EntityGroup]    Script Date: 1/04/2019 9:57:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Process].[EntityGroup](
	[EntityGroupKey] [int] IDENTITY(1,1) NOT NULL,
	[EntityGroupName] [varchar](100) NOT NULL,
 CONSTRAINT [PKC_Process_EntityGroup] PRIMARY KEY CLUSTERED 
(
	[EntityGroupKey] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Process].[EntityToProcess]    Script Date: 1/04/2019 9:57:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Process].[EntityToProcess](
	[ExecutionKey] [uniqueidentifier] NOT NULL,
	[EntityKey] [int] NOT NULL,
 CONSTRAINT [PKC_Process_EntityToProcess] PRIMARY KEY CLUSTERED 
(
	[ExecutionKey] ASC,
	[EntityKey] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Process].[ProcessType]    Script Date: 1/04/2019 9:57:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Process].[ProcessType](
	[ProcessTypeKey] [int] IDENTITY(1,1) NOT NULL,
	[ProcessTypeName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_ProcessType] PRIMARY KEY CLUSTERED 
(
	[ProcessTypeKey] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_ProcessType] UNIQUE NONCLUSTERED 
(
	[ProcessTypeName] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Process].[Entity] ADD  CONSTRAINT [DF_Entity_ProcessTypeKey]  DEFAULT ((1)) FOR [ProcessTypeKey]
GO
ALTER TABLE [Process].[Entity] ADD  CONSTRAINT [DF_Process_Entity_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [Process].[Entity] ADD  CONSTRAINT [DF_Process_Entity_IsProcessing]  DEFAULT ((0)) FOR [IsProcessing]
GO
ALTER TABLE [Process].[Entity] ADD  CONSTRAINT [DF_Process_Entity_HasProcessed]  DEFAULT ((0)) FOR [HasProcessed]
GO
ALTER TABLE [Process].[Entity]  WITH CHECK ADD  CONSTRAINT [FK_Process_Entity_EntityGroupKey] FOREIGN KEY([EntityGroupKey])
REFERENCES [Process].[EntityGroup] ([EntityGroupKey])
GO
ALTER TABLE [Process].[Entity] CHECK CONSTRAINT [FK_Process_Entity_EntityGroupKey]
GO
ALTER TABLE [Process].[Entity]  WITH CHECK ADD  CONSTRAINT [FK_Process_Entity_ProcessTypeKey] FOREIGN KEY([ProcessTypeKey])
REFERENCES [Process].[ProcessType] ([ProcessTypeKey])
GO
ALTER TABLE [Process].[Entity] CHECK CONSTRAINT [FK_Process_Entity_ProcessTypeKey]
GO
/****** Object:  StoredProcedure [dbo].[up_GetDataDates]    Script Date: 1/04/2019 9:57:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[up_GetDataDates]
	@DatabaseEntityName varchar(100) = NULL
AS

BEGIN
	
	DECLARE @PreviousDataDate date
			,@CurrentBusinessDate date = dbo.fn_CurrentBusinessDate();

	SELECT TOP 1
			@PreviousDataDate = DataDateSuccessfullyProcessed
		FROM
			[Process].DatabaseEntity
		WHERE
			DatabaseEntityName = @DatabaseEntityName
		ORDER BY
			DataDateSuccessfullyProcessed DESC;
		
	SELECT
			CONVERT(varchar(8), @CurrentBusinessDate, 112) AS CurrentBusinessDate
			,CONVERT(varchar(8), DATEADD(DAY, -1, @CurrentBusinessDate), 112) AS CurrentDataDate
			,COALESCE(CONVERT(varchar(8), @PreviousDataDate, 112), '') AS PreviousDataDate;

END

GO
/****** Object:  StoredProcedure [dbo].[up_GetProcessDates]    Script Date: 1/04/2019 9:57:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[up_GetProcessDates]
AS

BEGIN
	
	DECLARE @CurrentBusinessDate date = dbo.fn_CurrentBusinessDate();

	SELECT
			CONVERT(varchar(8), @CurrentBusinessDate, 112) AS CurrentBusinessDate
			,CONVERT(varchar(8), DATEADD(DAY, -1, @CurrentBusinessDate), 112) AS CurrentProcessDate
			,CONVERT(varchar(8), DATEADD(DAY, -2, @CurrentBusinessDate), 112) AS PreviousProcessDate;

END

GO
/****** Object:  StoredProcedure [Process].[up_GetEntitiesToProcess]    Script Date: 1/04/2019 9:57:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Process].[up_GetEntitiesToProcess]
	@EntityGroupKeyList varchar(1000)
	,@ProcessTypeKey int
AS

BEGIN

	SET NOCOUNT ON;

	DECLARE @ExecutionKey uniqueIdentifier = NEWID();
	DECLARE @Sql nvarchar(max) = N'';

	/* Determine the ETL still ready for processing now for the appropriate Group(s) */
	WITH Results AS
	(
		SELECT
				e.EntityKey
				,e.IsProcessing
			FROM
				[Process].Entity e
			JOIN STRING_SPLIT(@EntityGroupKeyList, ',') eg
				ON e.EntityGroupKey = CAST(eg.[value] AS int)
			OUTER APPLY	(SELECT
								MIN(IIF(HasProcessed = 1, 1, 0)) AS HasProcessed
							FROM
								[Process].Entity ent
							JOIN STRING_SPLIT(e.DependentEntities, ',') de
								ON ent.EntityKey = CAST(de.[value] AS int)) dep
			WHERE
				e.ProcessTypeKey = @ProcessTypeKey
				AND e.IsActive = 1
				AND e.HasProcessed = 0
				AND e.IsProcessing = 0
				AND COALESCE(dep.HasProcessed, 1) = 1
	)

	/* Indicate this ETL is now processing */
	UPDATE Results
		SET IsProcessing = 1
		OUTPUT @ExecutionKey, inserted.EntityKey
			INTO Process.EntityToProcess;

	IF (SELECT COUNT(*) FROM Process.EntityToProcess WHERE ExecutionKey = @ExecutionKey) > 0
	BEGIN
		SELECT
			@Sql =	CONCAT('SELECT e.EntityKey, e.DependencyEntityToSetForDataIsReady, '
						,STRING_AGG(CONCAT(IIF(DefaultValue IS NULL, '', 'COALESCE('), 'JSON_VALUE(e.VariablesJSON, ''$.', VariableName, ''')', IIF(DefaultValue IS NULL, '', ', ''' + DefaultValue + ''')'), ' AS ', VariableName), ', ')
						,' FROM Process.Entity e'
						,' JOIN Process.EntityToProcess etp'
						,' ON e.EntityKey = etp.EntityKey'
						,' WHERE etp.ExecutionKey = '''
						,@ExecutionKey
						,''';')
		FROM 
			[JSON].Variable
		WHERE 
			KeyDefiningVariableComposition = @ProcessTypeKey
			AND OwningEntity = 'Process.Entity';

		EXEC sp_executesql @Sql;

		DELETE Process.EntityToProcess 
		WHERE ExecutionKey = @ExecutionKey;
	END
	ELSE
	BEGIN
		SELECT
			@Sql =	CONCAT('SELECT 0 AS EntityKey, '
						,STRING_AGG(CONCAT('NULL AS ', VariableName), ', '))
		FROM 
			[JSON].Variable
		WHERE 
			KeyDefiningVariableComposition = @ProcessTypeKey
			AND OwningEntity = 'Process.Entity';

		EXEC sp_executesql @Sql;
	END;

END;
GO
/****** Object:  StoredProcedure [Process].[up_UpdateDatabaseEntity]    Script Date: 1/04/2019 9:57:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Process].[up_UpdateDatabaseEntity]
	@DatabaseEntityName varchar(100)
	,@DataDate varchar(8)	-- Format yyyymmdd
AS

BEGIN

	SET NOCOUNT ON;

	/* Indicate this Database Entity has been successfully processed for the Data Date */
	INSERT INTO [Process].DatabaseEntity
			(DatabaseEntityName
			,DataDateSuccessfullyProcessed)
		VALUES
			(@DatabaseEntityName
			,CAST(@DataDate AS date));

END;
GO
/****** Object:  StoredProcedure [Process].[up_UpdateEntityDiagnostics]    Script Date: 1/04/2019 9:57:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Process].[up_UpdateEntityDiagnostics]
	@EntityKey int
	,@ExecutionStartTime datetime2(3) = NULL
	,@ExecutionMessage varchar(1000) = NULL
	,@Result varchar(10) 

AS

BEGIN

	DECLARE @JSON varchar(MAX);

	IF @ExecutionMessage IS NOT NULL
		SET @JSON =  JSON_MODIFY('{ }','$.ExecutionMessage', @ExecutionMessage);

	INSERT INTO [Process].EntityExecution
			(EntityKey
			,ExecutionDateTime
			,Result
			,ResultsJSON)
		VALUES
			(@EntityKey
			,@ExecutionStartTime AT TIME ZONE 'UTC' AT TIME ZONE 'Cen. Australia Standard Time'
			,@Result
			,@JSON);

	UPDATE [Process].Entity
		SET IsProcessing = 0
			,HasProcessed = IIF(@Result = 'Success', 1, HasProcessed)
			,LastRunStartTime = @ExecutionStartTime AT TIME ZONE 'UTC' AT TIME ZONE 'Cen. Australia Standard Time'
			,LastRunEndTime = CURRENT_TIMESTAMP AT TIME ZONE 'UTC' AT TIME ZONE 'Cen. Australia Standard Time'
			,Result = @Result
			,ResultsJSON = @JSON
		WHERE
			EntityKey = @EntityKey;

	--IF @DependencyEntityToSetForDataIsReady IS NOT NULL
	--	MERGE INTO Dependency.Entity t
	--		USING (SELECT
	--					@DependencyEntityToSetForDataIsReady AS EntityCode) s
	--			ON t.EntityCode = s.EntityCode
	--		WHEN NOT MATCHED BY TARGET THEN 
	--			INSERT
	--					(EntityCode
	--					,EntityType
	--					,ExpiryTimeframe
	--					,DataExpiryDate
	--					,DataIsLoaded)
	--				VALUES
	--					(s.EntityCode
	--					,'TABLE'
	--					,'DAILY'
	--					,DATEADD(DAY, 1, dbo.fn_CurrentBusinessDate())
	--					,'True')
	--		WHEN MATCHED THEN
	--			UPDATE
	--				SET DataExpiryDate = CASE
	--										WHEN ExpiryTimeframe = 'DAILY' THEN DATEADD(DAY, 1, dbo.fn_CurrentBusinessDate())
	--									 END;

END
GO
