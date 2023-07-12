/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- Add custom columns
-- ------------------
IF COLUMNPROPERTY(OBJECT_ID('dbo.commodities'), 'STE_MIGRATIONSRC', 'ColumnId') is null
ALTER TABLE commodities
ADD STE_MIGRATIONSRC varchar(20) default null;

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0022_master_commodities_post
GO

CREATE PROCEDURE ste_0022_master_commodities_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_cnt int;
	declare @v_max_id bigint;
	declare @PackageName varchar(250);

	-- update identity column
	select @v_max_id=max(commoditiesid) from commodities;
	update maxsequence set maxreserved=coalesce(@v_max_id,0)+1 where tbname='COMMODITIES' and name='COMMODITIESID';

	-- get package name
	select @PackageName = package_name from [dbo].[ste_migration_logs] where id = @PackageLogID;
	if (@PackageName is null) return;

	-- update start_id and end_id for ITEM_
	select @v_cnt=count(STE_MIGRATIONID) from commodities
	where STE_MIGRATIONID is not null and STE_MIGRATIONSRC='ITEM_GRP';

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
		, 'ITEM_GRP'
		, 'LOG'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0))
	);

	select @v_cnt=count(STE_MIGRATIONID) from commodities
	where STE_MIGRATIONID is not null and STE_MIGRATIONSRC='ITEM_';

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
		, 'ITEM_'
		, 'LOG'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0))
	);

	select @v_cnt=count(STE_MIGRATIONID) from commodities
	where STE_MIGRATIONID is not null and STE_MIGRATIONSRC='NSITEM';

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
		, 'NSITEM'
		, 'LOG'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0))
	);

	select @v_cnt=count(STE_MIGRATIONID) from commodities
	where STE_MIGRATIONID is not null and STE_MIGRATIONSRC='DIR_STOCK';

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
		, 'DIR_STOCK'
		, 'LOG'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0))
	);

	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from commodities
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
		, 'COMMODITIES'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
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
           ('0022_Master_Commodities'
           ,'version'
           ,'3'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO