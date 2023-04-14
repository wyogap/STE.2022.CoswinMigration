/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- Add custom columns
-- ------------------
IF COLUMNPROPERTY(OBJECT_ID('dbo.WORKORDER'), 'STE_MIGRATIONID', 'ColumnId') is null
ALTER TABLE WORKORDER
ADD STE_MIGRATIONID bigint default null,
    STE_MIGRATIONDATE datetime NOT NULL DEFAULT (GETDATE());

IF COLUMNPROPERTY(OBJECT_ID('dbo.WORKORDER'), 'STE_MIGRATIONTYPE', 'ColumnId') is null
ALTER TABLE WORKORDER
ADD STE_MIGRATIONTYPE varchar(16) default null;

--IF COLUMNPROPERTY(OBJECT_ID('dbo.workorder'), 'ste_cswnactionauth', 'ColumnId') IS NULL
--ALTER TABLE [workorder]
--ADD ste_cswnactionauth varchar(16) default null,
--	ste_cswnactiondesc varchar(100) default null,
--	ste_cswncc varchar(16) default null,
--	ste_cswniexfl varchar(3) default null,
--	ste_cswnprjref varchar(10) default null,
--	ste_cswneqpcode varchar(20) default null,
--	ste_cswnjbclu varchar(6) default null,
--	ste_cswnjbcludesc varchar(100) default null,
--	ste_cswnjobid varchar(16) default null,
--	ste_cswnnewserialnum varchar(24) default null,
--	ste_cswnreqdesc varchar(100) default null,
--	ste_cswnrequestauth varchar(16) default null,
--	ste_cswntotcumunits varchar(38) default null,
--	ste_cswnwofnctn varchar(10) default null,
--	ste_cswnwotype varchar(3) default null,
--	ste_cswnwozone varchar(10) default null,
--	ste_eqpphone varchar(13) default null;

---- force make sure jobtype/worktype from coswin is not truncated (originally varchar(5))
--ALTER TABLE WORKORDER
--ALTER COLUMN WORKTYPE varchar(6);

---- force make sure failurecode from coswin is not truncated (originally varchar(8))
--ALTER TABLE WORKORDER
--ALTER COLUMN failurecode varchar(10);

---- force make sure equipmentcode from coswin is not truncated (originally varchar(12))
--ALTER TABLE WORKORDER
--ALTER COLUMN assetnum varchar(20);

-- Create pre-task
-- ---------------
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
           ,'1'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO