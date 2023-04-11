/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- Add custom columns
-- ------------------
IF COLUMNPROPERTY(OBJECT_ID('dbo.address'), 'STE_MIGRATIONID', 'ColumnId') is null
ALTER TABLE [address]
ADD STE_MIGRATIONID bigint default null,
    STE_MIGRATIONDATE datetime NOT NULL DEFAULT (GETDATE());

IF COLUMNPROPERTY(OBJECT_ID('dbo.address'), 'STE_MIGRATIONSOURCE', 'ColumnId') is null
ALTER TABLE [address]
ADD STE_MIGRATIONVALUE image default null;

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0507_Misc_Address_pre
GO

CREATE PROCEDURE ste_0507_Misc_Address_pre 
	@PackageLogID INT
AS
BEGIN
	-- truncate existing data
	delete from [address] where STE_MIGRATIONID is not null;

END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0507_Misc_Address_post
GO

CREATE PROCEDURE ste_0507_Misc_Address_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_cnt int;
	declare @v_max_id bigint;
	declare @PackageName varchar(250);

	-- update identity column
	select @v_max_id=max(addressid) from [address];
	update maxsequence set maxreserved=coalesce(@v_max_id,0)+1 where tbname='ADDRESS' and name='ADDRESSID';

	-- get package name
	select @PackageName = package_name from [dbo].[ste_migration_logs] where id = @PackageLogID;
	if (@PackageName is null) return;

	-- update start_id and end_id for ITEM_
	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from [address]
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
		, 'ADDRESS'
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
           ('0507_Misc_Address'
           ,'version'
           ,'1'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO