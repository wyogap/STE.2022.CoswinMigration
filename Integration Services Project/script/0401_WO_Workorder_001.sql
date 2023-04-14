/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- Add custom columns
-- ------------------
IF COLUMNPROPERTY(OBJECT_ID('dbo.workorder'), 'STE_MIGRATIONPREVWOID', 'ColumnId') IS NULL
ALTER TABLE [workorder]
ADD STE_MIGRATIONPREVWOID varchar(10) default null;

--IF COLUMNPROPERTY(OBJECT_ID('dbo.workorder'), 'ste_cswnwoid', 'ColumnId') IS NULL
--ALTER TABLE [workorder]
--ADD ste_cswnwoid varchar(10) default null;

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0201_WO_Workorder_pre;
drop procedure if exists ste_0401_WO_Workorder_pre;
GO

CREATE PROCEDURE ste_0401_WO_Workorder_pre 
	@PackageLogID INT
AS
BEGIN
	declare @v_seed bigint;
	declare @v_max_id bigint;

	-- truncate existing data
	delete from WORKORDER where STE_MIGRATIONID is not null and woclass='WORKORDER' and istask=0;

	-- create autokey if not exist
	select @v_seed=seed from [dbo].[autokey] where [autokeyname]='WONUM';
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
			,'WONUM'
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

drop procedure if exists ste_0201_WO_Workorder_post;
drop procedure if exists ste_0401_WO_Workorder_post;
GO

CREATE PROCEDURE ste_0401_WO_Workorder_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_cnt int;
	declare @v_max_id bigint;
	declare @PackageName varchar(250);

	-- update assetnum
	select @v_max_id=max(cast(WONUM as bigint)) from workorder;
	update autokey set seed=@v_max_id+1 where autokeyname='WONUM';

	-- update identity column
	select @v_max_id=max(WORKORDERID) from WORKORDER;
	update maxsequence set maxreserved=@v_max_id+1 where tbname='WORKORDER' and name='WORKORDERID';

	-- get package name
	select @PackageName = package_name from [dbo].[ste_migration_logs] where id = @PackageLogID;
	if (@PackageName is null) return;

	-- update start_id and end_id for ITEM_
	select @v_cnt=count(STE_MIGRATIONID) from workorder
	where STE_MIGRATIONID is not null and woclass='WORKORDER' and istask=0
		and STE_MIGRATIONTYPE = 'CHILDREN' AND parent IS NULL;

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
		, 'NOMATCH-PARENTWO'
		, 'LOG'
		, CONCAT('COUNT: ', @v_cnt)
	);
	
	select @v_cnt=count(STE_MIGRATIONID) from workorder
	where STE_MIGRATIONID is not null and woclass='WORKORDER' and istask=0
		and coalesce(STE_MIGRATIONPREVWOID,0) != 0 and origrecordid is null;

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
		, 'NOMATCH-PREVWO'
		, 'LOG'
		, CONCAT('COUNT: ', @v_cnt)
	);
	
	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from workorder
	where STE_MIGRATIONID is not null and woclass='WORKORDER' and istask=0
		and STE_MIGRATIONTYPE = 'ROUTE';

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
		, 'WO (ROUTE)'
		, 'COMPLETED'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from workorder
	where STE_MIGRATIONID is not null and woclass='WORKORDER' and istask=0
		and STE_MIGRATIONTYPE = 'ASSET';

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
		, 'WO (ASSET)'
		, 'COMPLETED'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from workorder
	where STE_MIGRATIONID is not null and woclass='WORKORDER' and istask=0
		and STE_MIGRATIONTYPE = 'CHILDREN';

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
		, 'WO (CHILDREN)'
		, 'COMPLETED'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	-- update start_id and end_id
	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID) from WORKORDER
	where STE_MIGRATIONID is not null and woclass='WORKORDER' and istask=0;

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
           ('0401_WO_Workorder'
           ,'version'
           ,'2'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO