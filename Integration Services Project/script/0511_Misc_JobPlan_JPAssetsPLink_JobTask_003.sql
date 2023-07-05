/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0511_Misc_JobPlan_pre;
GO

CREATE PROCEDURE ste_0511_Misc_JobPlan_pre 
	@PackageLogID INT
AS
BEGIN
	declare @v_seed bigint;
	declare @v_max_id bigint;

	-- truncate existing data
	delete from jobplan where STE_MIGRATIONID is not null;

	-- reset jpnum
	update workorder 
	set 
		jpnum = null
	where woclass='WORKORDER' 
		and STE_MIGRATIONID is not null;

	-- create autokey if not exist
	select @v_seed=seed from [dbo].[autokey] where [autokeyname]='JPNUM';
	if (@v_seed is null)
	begin
		select @v_max_id=maxreserved from [dbo].[maxsequence] where [tbname]='AUTOKEY' and [name]='AUTOKEYID';
		
		insert into [dbo].[autokey] (
			[seed]
			,[autokeyname]
			,[langcode]
			,[autokeyid]
		)
		values (
			1000
			,'JPNUM'
			,'EN'
			,@v_max_id + 1
		);

		update maxsequence set maxreserved=@v_max_id+1 where tbname='AUTOKEY' and name='AUTOKEYID';
	end;

END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0510_Misc_JobPlan_post;
drop procedure if exists ste_0511_Misc_JobPlan_post
GO

CREATE PROCEDURE ste_0511_Misc_JobPlan_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_cnt int;
	declare @v_max_id bigint;
	declare @PackageName varchar(250);

	-- update autokey
	select @v_max_id=max(try_cast(jpnum as int)) from jobplan;
	update autokey set seed=@v_max_id+1 where autokeyname='JPNUM';

	-- update identity column
	select @v_max_id=max(jobplanid) from jobplan;
	update maxsequence set maxreserved=coalesce(@v_max_id,0)+1 where tbname='JOBPLAN' and name='JOBPLANID';

	-- get package name
	select @PackageName = package_name from [dbo].[ste_migration_logs] where id = @PackageLogID;
	if (@PackageName is null) return;

	-- update start_id and end_id for ITEM_
	select @v_cnt=count(STE_MIGRATIONID) from workorder
	where STE_MIGRATIONID is not null and ste_cswnjobid is not null and jpnum is not null;

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
		, 'WO-JPNUM-MATCH'
		, 'LOG'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0))
	);

	select @v_cnt=count(STE_MIGRATIONID) from workorder
	where STE_MIGRATIONID is not null and ste_cswnjobid is not null and jpnum is null;

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
		, 'WO-JPNUM-NOMATCH'
		, 'LOG'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0))
	);

	select @v_cnt=count(STE_MIGRATIONID) from jobplan
	where STE_MIGRATIONID is not null and STE_MIGRATIONSOURCE='EQP_JOBS';

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
		, 'JOBPLAN-EQPJOBS'
		, 'LOG'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0))
	);

	select @v_cnt=count(STE_MIGRATIONID) from jobplan
	where STE_MIGRATIONID is not null and STE_MIGRATIONSOURCE='JOB_DIR';

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
		, 'JOBPLAN-JOBDIR'
		, 'LOG'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0))
	);

	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from jobplan
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
		, 'JOBPLAN'
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
           ('0511_Misc_JobPlan_JPAssetsPLink_JobTask'
           ,'version'
           ,'4'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO