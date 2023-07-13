/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- Add custom columns
-- ------------------
IF COLUMNPROPERTY(OBJECT_ID('dbo.ROUTE_STOP'), 'STE_MIGRATIONID', 'ColumnId') is null
ALTER TABLE [ROUTE_STOP]
ADD STE_MIGRATIONID bigint default null,
    STE_MIGRATIONDATE datetime NOT NULL DEFAULT (GETDATE());

IF COLUMNPROPERTY(OBJECT_ID('dbo.ROUTE_STOP'), 'STE_MIGRATIONEQCD', 'ColumnId') is null
ALTER TABLE [ROUTE_STOP]
ADD STE_MIGRATIONEQCD varchar(20) default null,
	STE_MIGRATIONASSETID varchar(40) default null,
	STE_MIGRATIONGRCD varchar(20) default null;

---- will be created through maximo

---- force make sure eqcode from coswin is not truncated
---- originally is varchar(12)
--ALTER TABLE [ROUTE_STOP]
--ALTER COLUMN [route] varchar(20) NOT NULL;

---- force make sure eqcode from coswin is not truncated (the same column in ASSET table is already varchar(24))
---- originally is varchar(12)
---- DROP SOME INDEX FIRST
--DROP INDEX [route_stop_ndx2] ON [dbo].[route_stop];
--DROP INDEX [route_stop_ndx3] ON [dbo].[route_stop];

---- ALTER THE COLUMN
--ALTER TABLE [ROUTE_STOP]
--ALTER COLUMN [assetnum] varchar(20) NOT NULL;

---- RECREATE THE INDEX
--CREATE NONCLUSTERED INDEX [route_stop_ndx2] ON [dbo].[route_stop]
--(
--	[siteid] ASC,
--	[route] ASC,
--	[stopsequence] ASC,
--	[assetnum] ASC,
--	[location] ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
--GO
--SET ANSI_PADDING ON
--GO

--CREATE NONCLUSTERED INDEX [route_stop_ndx3] ON [dbo].[route_stop]
--(
--	[siteid] ASC,
--	[assetnum] ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
--GO
--SET ANSI_PADDING ON
--GO

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0108_asset_routestop_pre
GO

CREATE PROCEDURE ste_0108_asset_routestop_pre 
	@PackageLogID INT
AS
BEGIN
	-- truncate existing data
	truncate table [ROUTE_STOP];

END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0108_asset_routestop_post
GO

CREATE PROCEDURE ste_0108_asset_routestop_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_max_id bigint;

	-- update identity column
	select @v_max_id=max(route_stopid) from [ROUTE_STOP];
	update maxsequence set maxreserved=@v_max_id+1 where tbname='ROUTE_STOP' and name='ROUTE_STOPID';

	-- update start_id and end_id
	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID) from [ROUTE_STOP];

	UPDATE [dbo].[ste_migration_logs] SET
	  [start_id] = @v_start_id
	, [end_id] = @v_end_id
	WHERE [id] = @PackageLogID

END
GO

-- update migration params
-- -----------------------
INSERT INTO [dbo].[ste_migration_params]
           ([package_name]
           ,[parameter_name]
           ,[parameter_value]
           ,[created_on]
           ,[created_by]
           ,[modified_on]
           ,[modified_by])
     VALUES
           ('0108_Asset_RouteStop'
           ,'version'
           ,'1'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO