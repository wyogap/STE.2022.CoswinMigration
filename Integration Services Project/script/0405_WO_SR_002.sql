/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0405_WO_SR_pre
GO

CREATE PROCEDURE ste_0405_WO_SR_pre 
	@PackageLogID INT
AS
BEGIN
	-- truncate existing data
	delete from ticket where STE_MIGRATIONID is not null and class='SR';

END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0405_WO_SR_post
GO

CREATE PROCEDURE ste_0405_WO_SR_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_cnt int;
	declare @v_max_id bigint;
	declare @PackageName varchar(250);

	-- update identity column
	select @v_max_id=max(ticketuid) from ticket;
	update maxsequence set maxreserved=coalesce(@v_max_id,0)+1 where tbname='TICKET' and name='TICKETUID';

	-- get package name
	select @PackageName = package_name from [dbo].[ste_migration_logs] where id = @PackageLogID;
	if (@PackageName is null) return;

	-- update start_id and end_id for ITEM_
	select @v_cnt=count(STE_MIGRATIONID) from ticket
	where STE_MIGRATIONID is not null and class='SR' and COALESCE(STE_MIGRATIONSRCWO,'0') != '0' and origrecordid is not null;

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
		, 'SR-SRCWO-MATCH'
		, 'LOG'
		, CONCAT('COUNT: ', @v_cnt)
	);

	select @v_cnt=count(STE_MIGRATIONID) from ticket
	where STE_MIGRATIONID is not null and class='SR' and COALESCE(STE_MIGRATIONSRCWO,'0') != '0' and origrecordid is null;

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
		, 'SR-SRCWO-NOMATCH'
		, 'LOG'
		, CONCAT('COUNT: ', @v_cnt)
	);

	select @v_cnt=count(STE_MIGRATIONID) from workorder
	where STE_MIGRATIONID is not null and coalesce(STE_MIGRATIONREQNO, '0') != '0' 
		and origrecordid is not null;

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
		, 'WO-REQNO-MATCH'
		, 'LOG'
		, CONCAT('COUNT: ', @v_cnt)
	);

	select @v_cnt=count(STE_MIGRATIONID) from workorder
	where STE_MIGRATIONID is not null and coalesce(STE_MIGRATIONREQNO, '0') != '0'
		and origrecordid is null;

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
		, 'WO-REQNO-NOMATCH'
		, 'LOG'
		, CONCAT('COUNT: ', @v_cnt)
	);

	select @v_cnt=count(a.STE_MIGRATIONID) from ticket a
	left join workorder b on b.ste_cswnwoid=a.STE_MIGRATIONWOREF
	where a.class='SR' and a.STE_MIGRATIONID is not null 
		and a.STE_MIGRATIONWOREF is not null and a.STE_MIGRATIONWOREF!='0'
		and b.wonum is not null;

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
		, 'SR-WOREF-MATCH'
		, 'LOG'
		, CONCAT('COUNT: ', @v_cnt)
	);

	select @v_cnt=count(a.STE_MIGRATIONID) from ticket a
	left join workorder b on b.ste_cswnwoid=a.STE_MIGRATIONWOREF
	where a.class='SR' and a.STE_MIGRATIONID is not null 
		and a.STE_MIGRATIONWOREF is not null and a.STE_MIGRATIONWOREF!='0'
		and b.wonum is null;

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
		, 'SR-WOREF-NOMATCH'
		, 'LOG'
		, CONCAT('COUNT: ', @v_cnt)
	);

	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from ticket
	where STE_MIGRATIONID is not null and class='SR';

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
		, 'SR'
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
           ('0405_WO_SR'
           ,'version'
           ,'3'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO