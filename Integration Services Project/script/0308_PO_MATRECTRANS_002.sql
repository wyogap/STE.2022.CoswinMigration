/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- Add custom columns
-- ------------------
-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0308_po_matrectrans_post
GO

CREATE PROCEDURE ste_0308_po_matrectrans_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_cnt int;
	declare @v_max_id bigint;
	declare @PackageName varchar(250);

	-- update identity column
	select @v_max_id=max(matrectransid) from matrectrans;
	update maxsequence set maxreserved=@v_max_id+1 where tbname='MATRECTRANS' and name='MATRECTRANSID';

	-- get package name
	select @PackageName = package_name from [dbo].[ste_migration_logs] where id = @PackageLogID;
	if (@PackageName is null) return;

	-- update start_id and end_id for ITEM_
	select @v_cnt=count(STE_MIGRATIONID) from matrectrans
	where STE_MIGRATIONID is not null and itemnum is null and STE_MIGRATIONITEMPK is not null;

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
		, 'MATRECTRANS-NOMATCH-ITEM'
		, 'LOG'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0))
	);

	select @v_cnt=count(STE_MIGRATIONID) from matrectrans
	where STE_MIGRATIONID is not null and itemnum is null and STE_MIGRATIONNSITEMPK is not null;

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
		, 'MATRECTRANS-NOMATCH-NSITEM'
		, 'LOG'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0))
	);
	
	
	select @v_cnt=count(STE_MIGRATIONID) from matrectrans
	where STE_MIGRATIONID is not null and ponum is not null and itemnum is not null and (polinenum is null or porevisionnum is null);

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
		, 'MATRECTRANS-NOMATCH-POLINE'
		, 'LOG'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0))
	);
	
	
	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from matrectrans
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
		, 'MATRECTRANS'
		, 'COMPLETED'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	-- update start_id and end_id
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
           ('0308_PO_MATRECTRANS'
           ,'version'
           ,'3'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO