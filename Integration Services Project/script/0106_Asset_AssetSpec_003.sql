IF COLUMNPROPERTY(OBJECT_ID('dbo.ASSETSPEC'), 'STE_MIGRATIONSOURCE', 'ColumnId') IS NULL
ALTER TABLE ASSETSPEC
ADD STE_MIGRATIONSOURCE varchar(50) default null;

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0106_Asset_AssetSpec_post
GO

CREATE PROCEDURE ste_0106_Asset_AssetSpec_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_cnt int;
	declare @v_max_id bigint;
	declare @PackageName varchar(250);

	-- update maximo seq
	select @v_max_id=max(ASSETSPECID) from ASSETSPEC;
	update maxsequence set maxreserved=@v_max_id+1 where tbname='ASSETSPEC' and name='ASSETSPECID';

	-- get package name
	select @PackageName = package_name from [dbo].[ste_migration_logs] where id = @PackageLogID;
	if (@PackageName is null) return;

	-- update start_id and end_id
	select @v_cnt=count(ASSETSPECID) from ASSETSPEC 
	where STE_MIGRATIONID is not null and STE_MIGRATIONSOURCE='EQP_TECH';

	insert into [dbo].[ste_migration_log_details] (
		[package_name]
		,[log_id]
		,[event]
		,[event_type]
		,[event_description]
	)
	values (
		@PackageName
		, @PackageLogID
		, 'ASSETSPEC-EQPTECH'
		, 'LOG'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0))
	);

	select @v_cnt=count(ASSETSPECID) from ASSETSPEC 
	where STE_MIGRATIONID is not null and STE_MIGRATIONSOURCE='ITEM_';

	insert into [dbo].[ste_migration_log_details] (
		[package_name]
		,[log_id]
		,[event]
		,[event_type]
		,[event_description]
	)
	values (
		@PackageName
		, @PackageLogID
		, 'ASSETSPEC-ITEM'
		, 'LOG'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0))
	);

	select @v_cnt=count(ASSETSPECID), @v_start_id=min(ASSETSPECID), @v_end_id=max(ASSETSPECID) from ASSETSPEC 
	where STE_MIGRATIONID is not null;

	insert into [dbo].[ste_migration_log_details] (
		[package_name]
		,[log_id]
		,[event]
		,[event_type]
		,[event_description]
	)
	values (
		@PackageName
		, @PackageLogID
		, 'ASSETSPEC'
		, 'COMPLETED'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

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
           ('0106_Asset_AssetSpec'
           ,'version'
           ,'4'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO