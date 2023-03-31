/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- Add custom columns
-- ------------------
IF COLUMNPROPERTY(OBJECT_ID('dbo.ROUTES'), 'STE_CSWNGRCD', 'ColumnId') IS NULL
ALTER TABLE [ROUTES]
ADD STE_CSWNGRCD varchar(20) default null;

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_009_master_routes_pre
GO

CREATE PROCEDURE ste_009_master_routes_pre 
	@PackageLogID INT
AS
BEGIN
	-- truncate existing data
	DELETE FROM [routes] WHERE STE_MIGRATIONID IS NOT NULL;

END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_009_master_routes_post
GO

CREATE PROCEDURE ste_009_master_routes_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_max_id bigint;

	-- update identity column
	select @v_max_id=max(routesid) from [ROUTES];

	-- update maximo seq
	update maxsequence set maxreserved=@v_max_id+1 where tbname='ROUTES' and name='ROUTESID';

	-- update start_id and end_id
	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID) from [ROUTES]
	WHERE STE_MIGRATIONID IS NOT NULL;

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
           ('0009_Master_Routes'
           ,'version'
           ,'2'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO