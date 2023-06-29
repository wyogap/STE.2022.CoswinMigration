/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
alter table dbo.relatedrecord
alter column STE_MIGRATIONTYPE varchar(50);

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0407_WO_RelatedRecord_pre
GO

CREATE PROCEDURE ste_0407_WO_RelatedRecord_pre 
	@PackageLogID INT
AS
BEGIN
	-- truncate existing data
	delete from relatedrecord where STE_MIGRATIONID is not null;
	
END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0407_WO_RelatedRecord_post
GO

CREATE PROCEDURE ste_0407_WO_RelatedRecord_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_cnt int;
	declare @v_max_id bigint;
	declare @PackageName varchar(250);

	-- update identity column
	select @v_max_id=max(relatedrecordid) from relatedrecord;
	update maxsequence set maxreserved=coalesce(@v_max_id,0)+1 where tbname='RELATEDRECORD' and name='RELATEDRECORDID';

	-- get package name
	select @PackageName = package_name from [dbo].[ste_migration_logs] where id = @PackageLogID;
	if (@PackageName is null) return;

	-- update start_id and end_id for ITEM_
	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from relatedrecord
	where STE_MIGRATIONID is not null and STE_MIGRATIONTYPE='WO-FOLLOWUP-WO';

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
		, 'WO-FOLLOWUP-WO'
		, 'COMPLETED'
		, CONCAT('COUNT: ', @v_cnt/2, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from relatedrecord
	where STE_MIGRATIONID is not null and STE_MIGRATIONTYPE='WO-FOLLOWUP-SR';

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
		, 'WO-FOLLOWUP-SR'
		, 'COMPLETED'
		, CONCAT('COUNT: ', @v_cnt/2, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from relatedrecord
	where STE_MIGRATIONID is not null and STE_MIGRATIONTYPE='SR-FOLLOWUP-WO (WO-REQNO)';

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
		, 'SR-FOLLOWUP-WO (WO-REQNO)'
		, 'COMPLETED'
		, CONCAT('COUNT: ', @v_cnt/2, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from relatedrecord
	where STE_MIGRATIONID is not null and STE_MIGRATIONTYPE='SR-FOLLOWUP-WO (SR-WOREF)';

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
		, 'SR-FOLLOWUP-WO (SR-WOREF)'
		, 'COMPLETED'
		, CONCAT('COUNT: ', @v_cnt/2, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from relatedrecord
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
           ('0407_WO_RelatedRecord'
           ,'version'
           ,'3'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO