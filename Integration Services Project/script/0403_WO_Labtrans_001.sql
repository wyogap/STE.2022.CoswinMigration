/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- Add custom columns
-- ------------------

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0403_WO_Labtrans_pre
GO

CREATE PROCEDURE ste_0403_WO_Labtrans_pre 
	@PackageLogID INT
AS
BEGIN
	-- truncate existing data
	delete from labtrans where STE_MIGRATIONID is not null;

END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0403_WO_Labtrans_post
GO

CREATE PROCEDURE ste_0403_WO_Labtrans_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_cnt int;
	declare @v_max_id bigint;
	declare @PackageName varchar(250);

	declare @v_cnt_parent int;
	declare @v_cnt_children int;

	-- update identity column
	select @v_max_id=max(labtransid) from labtrans;
	update maxsequence set maxreserved=@v_max_id+1 where tbname='LABTRANS' and name='LABTRANSID';

	-- get package name
	select @PackageName = package_name from [dbo].[ste_migration_logs] where id = @PackageLogID;
	if (@PackageName is null) return;

	-- update start_id and end_id for ITEM_
	select @v_cnt=count(STE_MIGRATIONID) 
		, @v_cnt_parent=sum(case when STE_MIGRATIONTYPE='PARENT' then 1 else 0 end)
		, @v_cnt_children=sum(case when STE_MIGRATIONTYPE='CHILDREN' then 1 else 0 end)
	from labtrans
	where STE_MIGRATIONID is not null and refwo is null;

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
		, CONCAT('COUNT: ', @v_cnt, ', PARENT: ', COALESCE(@v_cnt_parent, 0), ', CHILDREN: ', coalesce(@v_cnt_children,0))
	);

	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from labtrans
	where STE_MIGRATIONID is not null and STE_MIGRATIONTYPE='PARENT';

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
		, 'PARENTWO'
		, 'COMPLETED'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from labtrans
	where STE_MIGRATIONID is not null and STE_MIGRATIONTYPE='CHILDREN';

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
		, 'CHILDWO'
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
           ('0403_WO_Labtrans'
           ,'version'
           ,'2'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO