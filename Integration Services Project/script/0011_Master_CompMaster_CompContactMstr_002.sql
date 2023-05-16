/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- ----------- 
-- COMPMASTER
-- -----------

IF COLUMNPROPERTY(OBJECT_ID('dbo.COMPMASTER'), 'STE_MIGRATIONSOURCE', 'ColumnId') IS NULL
ALTER TABLE COMPMASTER
ADD STE_MIGRATIONSOURCE VARCHAR(20) default null;
;


-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_011_master_compmaster_post;
drop procedure if exists ste_0011_master_compmaster_post;
GO

CREATE PROCEDURE ste_0011_master_compmaster_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_cnt int;
	declare @v_max_id bigint;
	declare @PackageName varchar(250);

	-- update identity column
	select @v_max_id=max(COMPMASTERID) from COMPMASTER;
	update maxsequence set maxreserved=@v_max_id+1 where tbname='COMPMASTER' and name='COMPMASTERID';

	-- get package name
	select @PackageName = package_name from [dbo].[ste_migration_logs] where id = @PackageLogID;
	if (@PackageName is null) return;

	-- update start_id and end_id for ITEM_
	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from COMPMASTER
	where STE_MIGRATIONID is not null AND STE_MIGRATIONSOURCE = 'SUPPLIER_';

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
		, 'SUPPLIER_'
		, 'COMPLETED'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from COMPMASTER
	where STE_MIGRATIONID is not null AND STE_MIGRATIONSOURCE = 'DIR_SUPP';

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
		, 'DIR_SUPP'
		, 'COMPLETED'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from COMPMASTER
	where STE_MIGRATIONID is not null AND STE_MIGRATIONSOURCE = 'DIR_MANF';

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
		, 'DIR_MANF'
		, 'COMPLETED'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from COMPMASTER
	where STE_MIGRATIONID is not null;

	-- update start_id and end_id
	UPDATE [dbo].[ste_migration_logs] SET
	  [start_id] = @v_start_id
	, [end_id] = @v_end_id
	WHERE [id] = @PackageLogID

END
GO

-- ----------------- 
-- COMPCONTACTMSTR
-- -----------------

IF COLUMNPROPERTY(OBJECT_ID('dbo.COMPCONTACTMSTR'), 'STE_MIGRATIONSOURCE', 'ColumnId') IS NULL
ALTER TABLE COMPCONTACTMSTR
ADD STE_MIGRATIONSOURCE VARCHAR(20) default null;
;

IF COLUMNPROPERTY(OBJECT_ID('dbo.COMPCONTACTMSTR'), 'ste_contacttype', 'ColumnId') IS NULL
ALTER TABLE COMPCONTACTMSTR
ADD ste_contacttype VARCHAR(20) default null;

;
-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_011_master_compcontactmstr_post;
drop procedure if exists ste_0011_master_compcontactmstr_post;
GO

CREATE PROCEDURE ste_0011_master_compcontactmstr_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_cnt int;
	declare @v_max_id bigint;
	declare @PackageName varchar(250);

	-- update identity column
	select @v_max_id=max(COMPCONTACTMSTRID) from COMPCONTACTMSTR;
	update maxsequence set maxreserved=@v_max_id+1 where tbname='COMPCONTACTMSTR' and name='COMPCONTACTMSTRID';

	-- get package name
	select @PackageName = package_name from [dbo].[ste_migration_logs] where id = @PackageLogID;
	if (@PackageName is null) return;

	-- update start_id and end_id for ITEM_
	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from COMPCONTACTMSTR
	where STE_MIGRATIONID is not null 
		AND STE_MIGRATIONSOURCE = 'SUPPLIER_' AND ste_contacttype = 'CONTACT';

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
		, 'SUPPLIER_ (CONTACT)'
		, 'COMPLETED'
		, CONCAT('COUNT: ', COALESCE(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from COMPCONTACTMSTR
	where STE_MIGRATIONID is not null 
		AND STE_MIGRATIONSOURCE = 'SUPPLIER_' AND ste_contacttype = 'TECH';

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
		, 'SUPPLIER_ (TECH)'
		, 'COMPLETED'
		, CONCAT('COUNT: ', COALESCE(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from COMPCONTACTMSTR
	where STE_MIGRATIONID is not null 
		AND STE_MIGRATIONSOURCE = 'DIR_SUPP' AND ste_contacttype = 'CONTACT';

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
		, 'DIR_SUPP (CONTACT)'
		, 'COMPLETED'
		, CONCAT('COUNT: ', COALESCE(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from COMPCONTACTMSTR
	where STE_MIGRATIONID is not null 
		AND STE_MIGRATIONSOURCE = 'DIR_SUPP' AND ste_contacttype = 'TECH';

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
		, 'DIR_SUPP (TECH)'
		, 'COMPLETED'
		, CONCAT('COUNT: ', COALESCE(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from COMPCONTACTMSTR
	where STE_MIGRATIONID is not null 
		AND STE_MIGRATIONSOURCE = 'DIR_MANF' AND ste_contacttype = 'CONTACT';

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
		, 'DIR_MANF (CONTACT)'
		, 'COMPLETED'
		, CONCAT('COUNT: ', COALESCE(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from COMPCONTACTMSTR
	where STE_MIGRATIONID is not null 
		AND STE_MIGRATIONSOURCE = 'DIR_MANF' AND ste_contacttype = 'TECH';

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
		, 'DIR_MANF (TECH)'
		, 'COMPLETED'
		, CONCAT('COUNT: ', COALESCE(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
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
           ('0011_Master_CompMaster_CompContactMstr'
           ,'version'
           ,'3'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO