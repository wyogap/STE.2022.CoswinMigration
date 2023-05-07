/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/

-- Add custom columns
-- ------------------
IF COLUMNPROPERTY(OBJECT_ID('dbo.ITEMORGINFO'), 'STE_MIGRATIONID', 'ColumnId') IS NULL
ALTER TABLE ITEMORGINFO
ADD STE_MIGRATIONSOURCE VARCHAR(100) default null,
	STE_MIGRATIONID bigint default null,
    STE_MIGRATIONDATE datetime NOT NULL DEFAULT (GETDATE());

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_010_master_item_post;
drop procedure if exists ste_0010_master_item_post;
GO

CREATE PROCEDURE ste_0010_master_item_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_cnt int;
	declare @v_max_id bigint;
	declare @PackageName varchar(250);

	-- update identity column
	select @v_max_id=max(itemid) from [ITEM];

	-- update maximo seq
	update maxsequence set maxreserved=@v_max_id+1 where tbname='ITEM' and name='ITEMID';

	-- get package name
	select @PackageName = package_name from [dbo].[ste_migration_logs] where id = @PackageLogID;
	if (@PackageName is null) return;

	-- update start_id and end_id for ITEM_
	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from [ITEM]
	where STE_MIGRATIONID is not null and STE_MIGRATIONSOURCE='ITEM_';

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
		, 'ITEM-ITEM_'
		, 'LOG'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	-- update start_id and end_id for NSITEM
	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from [ITEM]
	where STE_MIGRATIONID is not null and STE_MIGRATIONSOURCE='NSITEM';

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
		, 'ITEM-NSITEM'
		, 'LOG'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	-- update start_id and end_id for DIR_STOCK
	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from [ITEM]
	where STE_MIGRATIONID is not null and STE_MIGRATIONSOURCE='DIR_STOCK';

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
		, 'ITEM-DIR_STOCK'
		, 'LOG'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	-- update start_id and end_id
	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from ITEM
	WHERE STE_MIGRATIONID IS NOT NULL;

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
		, 'ITEM'
		, 'COMPLETED'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	UPDATE [dbo].[ste_migration_logs] SET
	  [start_id] = @v_start_id
	, [end_id] = @v_end_id
	WHERE [id] = @PackageLogID

END
GO


-- Add custom columns
-- ------------------
IF COLUMNPROPERTY(OBJECT_ID('dbo.ITEMORGINFO'), 'STE_MIGRATIONID', 'ColumnId') IS NULL
ALTER TABLE ITEMORGINFO
ADD STE_MIGRATIONSOURCE VARCHAR(100) default null,
	STE_MIGRATIONID bigint default null,
    STE_MIGRATIONDATE datetime NOT NULL DEFAULT (GETDATE());

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0023_master_itemorginfo_pre;
drop procedure if exists ste_0010_master_itemorginfo_pre;
GO

CREATE PROCEDURE ste_0010_master_itemorginfo_pre 
	@PackageLogID INT
AS
BEGIN
	-- truncate existing data
	DELETE FROM [itemorginfo] WHERE STE_MIGRATIONID IS NOT NULL;

END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0023_master_itemorginfo_post;
drop procedure if exists ste_0010_master_itemorginfo_post;
GO

CREATE PROCEDURE ste_0010_master_itemorginfo_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_cnt int;
	declare @v_max_id bigint;
	declare @PackageName varchar(250);

	-- update identity column
	select @v_max_id=max(itemorginfoid) from [itemorginfo];

	-- update maximo seq
	update maxsequence set maxreserved=@v_max_id+1 where tbname='ITEMORGINFO' and name='ITEMORGINFOID';

	-- get package name
	select @PackageName = package_name from [dbo].[ste_migration_logs] where id = @PackageLogID;
	if (@PackageName is null) return;

	-- update start_id and end_id
	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from ITEMORGINFO
	WHERE STE_MIGRATIONID IS NOT NULL;

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
		, 'ITEMORGINFO'
		, 'COMPLETED'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
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
           ('0010_Master_Item_ItemOrgInfo'
           ,'version'
           ,'4'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO