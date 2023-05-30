/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- Add custom columns
-- ------------------

--IF COLUMNPROPERTY(OBJECT_ID('dbo.jobplan'), 'STE_CSWNJOBID', 'ColumnId') is null
--ALTER TABLE jobplan
--ADD STE_CSWNJOBID	varchar(16) default null;

IF COLUMNPROPERTY(OBJECT_ID('dbo.jobplan'), 'STE_MIGRATIONSOURCE', 'ColumnId') is null
ALTER TABLE jobplan
ADD STE_MIGRATIONSOURCE	varchar(16) default null;

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
	select @v_max_id=max(cast(jpnum as int)) from jobplan;
	update autokey set seed=@v_max_id+1 where autokeyname='JPNUM';

	-- update identity column
	select @v_max_id=max(jobplanid) from jobplan;
	update maxsequence set maxreserved=coalesce(@v_max_id,0)+1 where tbname='JOBPLAN' and name='JOBPLANID';

	-- get package name
	select @PackageName = package_name from [dbo].[ste_migration_logs] where id = @PackageLogID;
	if (@PackageName is null) return;

	-- update start_id and end_id for ITEM_
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
		, 'COMPLETED'
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
		, 'COMPLETED'
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


-- --------------
-- JOBTASK
-- --------------

-- Add custom columns
-- ------------------
--IF COLUMNPROPERTY(OBJECT_ID('dbo.jobtask'), 'STE_CSWNACTCODE', 'ColumnId') is null
--ALTER TABLE jobtask
--ADD STE_CSWNACTCODE varchar(10) default null;

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0511_Misc_JobTask_pre;
GO

CREATE PROCEDURE ste_0511_Misc_JobTask_pre 
	@PackageLogID INT
AS
BEGIN
	declare @v_seed bigint;
	declare @v_max_id bigint;

	-- truncate existing data
	delete from jobplan where STE_MIGRATIONID is not null;

	-- create autokey if not exist
	select @v_seed=seed from [dbo].[autokey] where [autokeyname]='JPTASK';
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
			,'JPTASK'
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

drop procedure if exists ste_0511_Misc_JobTask_post
GO

CREATE PROCEDURE ste_0511_Misc_JobTask_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_cnt int;
	declare @v_max_id bigint;
	declare @PackageName varchar(250);

	-- update autokey
	select @v_max_id=max(cast(jptask as int)) from jobtask;
	update autokey set seed=@v_max_id+1 where autokeyname='JPTASK';

	-- update identity column
	select @v_max_id=max(jobtaskid) from jobtask;
	update maxsequence set maxreserved=coalesce(@v_max_id,0)+1 where tbname='JOBTASK' and name='JOBTASKID';

	-- get package name
	select @PackageName = package_name from [dbo].[ste_migration_logs] where id = @PackageLogID;
	if (@PackageName is null) return;

	-- update start_id and end_id for ITEM_
	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from jobtask
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
		, 'JOBTASK'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
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
           ('0511_Misc_JobPlan_JPAssetsPLink_JobTask'
           ,'version'
           ,'3'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO