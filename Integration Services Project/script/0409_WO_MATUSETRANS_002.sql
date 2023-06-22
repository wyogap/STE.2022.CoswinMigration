/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- Add custom columns
-- ------------------
IF COLUMNPROPERTY(OBJECT_ID('dbo.matusetrans'), 'STE_MIGRATIONREFWO', 'ColumnId') is null
ALTER TABLE matusetrans
ADD STE_MIGRATIONREFWO bigint default null;

--IF COLUMNPROPERTY(OBJECT_ID('dbo.matusetrans'), 'STE_REPLFLAG', 'ColumnId') is null
--ALTER TABLE matusetrans
--ADD STE_REPLFLAG varchar(3) default null,
--	STE_PLNFLAG varchar(3) default null;

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0206_inventory_matusetrans_post;
drop procedure if exists ste_0409_wo_matusetrans_post;
GO

CREATE PROCEDURE ste_0409_wo_matusetrans_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_cnt int;
	declare @v_max_id bigint;
	declare @PackageName varchar(250);

	-- update identity column
	select @v_max_id=max(matusetransid) from matusetrans;
	update maxsequence set maxreserved=@v_max_id+1 where tbname='MATUSETRANS' and name='MATUSETRANSID';

	-- get package name
	select @PackageName = package_name from [dbo].[ste_migration_logs] where id = @PackageLogID;
	if (@PackageName is null) return;

	-- update start_id and end_id for ITEM_
	select @v_cnt=count(a.STE_MIGRATIONID) from matusetrans a 
	left join workorder b on b.wonum=a.refwo
	where a.STE_MIGRATIONREFWO!=0 and a.STE_MIGRATIONREFWO is not null
		and b.workorderid is null;

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
		, 'NOMATCH-REFWO'
		, 'LOG'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0))
	);

	select @v_cnt=count(STE_MIGRATIONID) from matusetrans a 
	where STE_MIGRATIONREFWO=0 or STE_MIGRATIONREFWO is null;

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
		, 'INVALID-REFWO'
		, 'LOG'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0))
	);

	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from matusetrans
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
		, 'MATUSETRANS'
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
           ('0409_WO_MATUSETRANS'
           ,'version'
           ,'3'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO