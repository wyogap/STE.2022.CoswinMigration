-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_005_master_meter_pre;
drop procedure if exists ste_0005_master_meter_pre;
GO

CREATE PROCEDURE ste_0005_master_meter_pre 
	@PackageLogID INT
AS
BEGIN
	-- truncate existing data
	delete from meter where STE_MIGRATIONID is not null;

END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_005_master_meter_post;
drop procedure if exists ste_0005_master_meter_post;
GO

CREATE PROCEDURE ste_0005_master_meter_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_cnt int;
	declare @v_max_id bigint;
	declare @PackageName varchar(250);

	-- update identity column
	select @v_max_id=max(METERID) from METER;
	update maxsequence set maxreserved=@v_max_id+1 where tbname='METER' and name='METERID';

	-- get package name
	select @PackageName = package_name from [dbo].[ste_migration_logs] where id = @PackageLogID;
	if (@PackageName is null) return;

	-- update start_id and end_id for ITEM_
	select @v_cnt=count(STE_MIGRATIONID) from person
	where STE_MIGRATIONID is not null and STE_MIGRATIONSOURCE = 'RES_EMPL' AND STATUS = 'ACTIVE';

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
		, 'RES_EMPL (ACTIVE)'
		, 'LOG'
		, CONCAT('COUNT: ', @v_cnt)
	);

	-- update start_id and end_id
	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID) from meter
	where STE_MIGRATIONID is not null;

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
           ('0005_Master_Meter'
           ,'version'
           ,'3'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO