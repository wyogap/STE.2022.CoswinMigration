/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID(N'dbo.ste_migration_params', N'U') IS NULL
CREATE TABLE [dbo].[ste_migration_params](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[package_name] [varchar](250) NOT NULL,
	[parameter_name] [varchar](250) NOT NULL,
	[parameter_value] [varchar](250) NOT NULL,
	[created_on] [datetime] NOT NULL DEFAULT (getdate()),
	[created_by] [varchar](250) NULL,
	[modified_on] [datetime] NULL,
	[modified_by] [varchar](250) NULL,
 CONSTRAINT [PK_ste_migration_params] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- ALTER TABLE [dbo].[ste_migration_params] ADD  CONSTRAINT [DF_ste_migration_params_created_on]  DEFAULT (getdate()) FOR [created_on]
-- GO

IF OBJECT_ID(N'dbo.ste_migration_logs', N'U') IS NULL
CREATE TABLE [dbo].[ste_migration_logs](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[package_name] [varchar](250) NOT NULL,
	[version] int NULL,
	[start_date] [datetime] NOT NULL DEFAULT (getdate()),
	[end_date] [datetime] NULL,
	[start_id] [varchar](250) NULL,
	[end_id] [varchar](250) NULL,
	[success] int not null default 0
 CONSTRAINT [PK_ste_migration_logs] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- ALTER TABLE [dbo].[ste_migration_logs] ADD  CONSTRAINT [DF_ste_migration_logs_start_date]  DEFAULT (getdate()) FOR [start_date]
-- GO

IF OBJECT_ID(N'dbo.ste_migration_log_details', N'U') IS NULL
CREATE TABLE [dbo].[ste_migration_log_details](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[package_name] [varchar](250) NOT NULL,
	[log_id] [bigint] NOT NULL,
	[event] [varchar](250) NOT NULL,
	[event_type] [varchar](250) NULL,
	[event_description] [varchar](2000) NULL,
	[timestamp] [datetime] NOT NULL DEFAULT (getdate()),
 CONSTRAINT [PK_ste_migration_log_details] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- ALTER TABLE [dbo].[ste_migration_log_details] ADD  CONSTRAINT [DF_ste_migration_log_details_timestamp]  DEFAULT (getdate()) FOR [timestamp]
-- GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_migration_InitPackageLog
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE ste_migration_InitPackageLog 
	@PackageName VARCHAR(250)
	,@PackageVersion int
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [dbo].[ste_migration_logs] (
		[package_name]
		,[version]
		,[start_date]	
	)
	VALUES (
		@PackageName
		,@PackageVersion
		,GetDate()
	)

	SELECT CAST(Scope_Identity() AS INT) PackageLogID
END

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_migration_EndPackageLog
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE ste_migration_EndPackageLog
  @PackageLogID INT
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE [dbo].[ste_migration_logs] SET
	  [end_date] = GetDate()
	, [success] = 1
	WHERE [id] = @PackageLogID

	SET NOCOUNT OFF;
END
GO

INSERT INTO [dbo].[ste_migration_params]
           ([package_name]
           ,[parameter_name]
           ,[parameter_value]
           ,[created_on]
           ,[created_by]
           ,[modified_on]
           ,[modified_by])
     VALUES
           ('0002_Check_MaximoDB'
           ,'version'
           ,'1'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO