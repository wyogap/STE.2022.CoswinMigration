/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- Add custom columns
-- ------------------
IF COLUMNPROPERTY(OBJECT_ID('dbo.failurereport'), 'STE_MIGRATIONWOID', 'ColumnId') is null
ALTER TABLE failurereport
ADD STE_MIGRATIONWOID varchar(20) default null;

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0406_WO_FailureReport_post
GO

CREATE PROCEDURE ste_0406_WO_FailureReport_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_cnt int;
	declare @v_max_id bigint;
	declare @PackageName varchar(250);

	declare @v_cnt_symptom int;
	declare @v_cnt_defect int;
	declare @v_cnt_cause int;
	declare @v_cnt_action int;

	-- update identity column
	select @v_max_id=max(failurereportid) from failurereport;
	update maxsequence set maxreserved=coalesce(@v_max_id,0)+1 where tbname='FAILUREREPORT' and name='FAILUREREPORTID';

	-- get package name
	select @PackageName = package_name from [dbo].[ste_migration_logs] where id = @PackageLogID;
	if (@PackageName is null) return;

	-- update start_id and end_id for ITEM_
	select @v_cnt=count(STE_MIGRATIONID)
		, @v_cnt_symptom=sum(case when STE_MIGRATIONTYPE='SYMPTOM' then 1 else 0 end)
		, @v_cnt_defect=sum(case when STE_MIGRATIONTYPE='DEFECT' then 1 else 0 end)
		, @v_cnt_cause=sum(case when STE_MIGRATIONTYPE='CAUSE' then 1 else 0 end)
		, @v_cnt_action=sum(case when STE_MIGRATIONTYPE='ACTION' then 1 else 0 end)
	from failurereport
	where STE_MIGRATIONID is not null 
		and COALESCE(STE_MIGRATIONWOID,0) != 0 and wonum is null;

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
		, 'NOMATCH-WO'
		, 'LOG'
		, CONCAT('COUNT: ', @v_cnt, ', SYMPTOM: ', coalesce(@v_cnt_symptom,0), ', PROBLEM: ', coalesce(@v_cnt_defect,0)
			, ', CAUSE: ', coalesce(@v_cnt_cause,0), ', REMEDY: ', coalesce(@v_cnt_action,0))
	);

	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from failurereport
	where STE_MIGRATIONID is not null and STE_MIGRATIONTYPE='SYMPTOM';

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
		, 'SYMPTOM'
		, 'COMPLETED'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from failurereport
	where STE_MIGRATIONID is not null and STE_MIGRATIONTYPE='DEFECT';

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
		, 'PROBLEM'
		, 'COMPLETED'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from failurereport
	where STE_MIGRATIONID is not null and STE_MIGRATIONTYPE='CAUSE';

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
		, 'CAUSE'
		, 'COMPLETED'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from failurereport
	where STE_MIGRATIONID is not null and STE_MIGRATIONTYPE='ACTION';

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
		, 'REMEDY'
		, 'COMPLETED'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from failurereport
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
           ('0406_WO_FailureReport'
           ,'version'
           ,'2'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO