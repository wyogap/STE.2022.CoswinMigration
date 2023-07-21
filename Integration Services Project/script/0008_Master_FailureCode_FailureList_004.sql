/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/

-- FAILURECODE
--

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_008_master_failurecode_post;
drop procedure if exists ste_0008_master_failurecode_post;
GO

CREATE PROCEDURE ste_0008_master_failurecode_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_cnt int;
	declare @v_max_id bigint;
	declare @PackageName varchar(250);

	-- update identity column
	select @v_max_id=max(FailureCodeID) from failurecode;

	-- update maximo seq
	update maxsequence set maxreserved=@v_max_id+1 where tbname='FailureCode' and name='FailureCodeID';

	-- get package name
	select @PackageName = package_name from [dbo].[ste_migration_logs] where id = @PackageLogID;
	if (@PackageName is null) return;

	-- LOGGING
	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from FAILURECODE
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
		, 'FAILURECODE'
		, 'COMPLETED'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	-- update start_id and end_id
	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID) from AssetAttribute
	where STE_MIGRATIONID is not null;

	UPDATE [dbo].[ste_migration_logs] SET
	  [start_id] = @v_start_id
	, [end_id] = @v_end_id
	WHERE [id] = @PackageLogID

END
GO

-- FAILURELIST
--

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_008_master_failurelist_post;
drop procedure if exists ste_0008_master_failurelist_post;
GO

CREATE PROCEDURE ste_0008_master_failurelist_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_cnt int;
	declare @v_max_id bigint;
	declare @PackageName varchar(250);

	-- update identity column
	select @v_max_id=max(failurelist) from failurelist;
	update maxsequence set maxreserved=@v_max_id+1 where tbname='FAILURELIST' and name='FAILURELIST';

	-- get package name
	select @PackageName = package_name from [dbo].[ste_migration_logs] where id = @PackageLogID;
	if (@PackageName is null) return;

	-- update start_id and end_id for ITEM_
	select @v_cnt=count(STE_MIGRATIONID) from failurelist
	where STE_MIGRATIONID is not null and STE_MIGRATIONTYPE = 'FAILCLASS';

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
		, 'FAILURELIST-FAILCLASS'
		, 'LOG'
		, CONCAT('COUNT: ', COALESCE(@v_cnt,0))
	);

	select @v_cnt=count(STE_MIGRATIONID) from failurelist
	where STE_MIGRATIONID is not null and STE_MIGRATIONTYPE = 'PROBLEM';

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
		, 'FAILURELIST-PROBLEM'
		, 'LOG'
		, CONCAT('COUNT: ', COALESCE(@v_cnt,0))
	);

	select @v_cnt=count(STE_MIGRATIONID) from failurelist
	where STE_MIGRATIONID is not null and STE_MIGRATIONTYPE = 'CAUSE';

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
		, 'FAILURELIST-CAUSE'
		, 'LOG'
		, CONCAT('COUNT: ', COALESCE(@v_cnt,0))
	);

	select @v_cnt=count(STE_MIGRATIONID) from failurelist
	where STE_MIGRATIONID is not null and STE_MIGRATIONTYPE = 'REMEDY';

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
		, 'FAILURELIST-REMEDY'
		, 'LOG'
		, CONCAT('COUNT: ', COALESCE(@v_cnt,0))
	);

	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from failurelist
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
		, 'FAILURELIST'
		, 'COMPLETED'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

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
           ('0008_Master_FailureCode_FailureList'
           ,'version'
           ,'5'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO