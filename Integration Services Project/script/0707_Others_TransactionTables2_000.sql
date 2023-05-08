/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- coswin.earl definition
IF OBJECT_ID(N'dbo.cswn_earl', N'U') IS NULL
create table cswn_earl 
   (commonkey numeric(8,0) not null , 
	indx numeric(3,0) not null , 
	earl numeric(5,0)
   );


-- coswin.group_ptd definition
IF OBJECT_ID(N'dbo.cswn_group_ptd', N'U') IS NULL
create table cswn_group_ptd 
   (commonkey numeric(8,0) not null , 
	indx numeric(3,0) not null , 
	grp_ptd_cd varchar(1), 
	grp_open_val float, 
	grp_rct_val float, 
	grp_iss_val float, 
	grp_adj_val float
   ) ;


-- coswin.late definition
IF OBJECT_ID(N'dbo.cswn_late', N'U') IS NULL
create table cswn_late 
   (	commonkey numeric(8,0) not null , 
	indx numeric(3,0) not null , 
	late numeric(5,0)
   ) ;


-- coswin.po_item_other definition
IF OBJECT_ID(N'dbo.cswn_po_item_other', N'U') IS NULL
create table cswn_po_item_other 
   (	commonkey numeric(8,0) not null , 
	indx numeric(3,0) not null , 
	po_item_pcnt float, 
	po_item_oth_chr float, 
	po_item_parm_cd varchar(2), 
	po_item_on numeric(3,0)
   ) ;


-- coswin.po_other definition
IF OBJECT_ID(N'dbo.cswn_po_other', N'U') IS NULL
create table cswn_po_other 
   (	commonkey numeric(8,0) not null , 
	indx numeric(3,0) not null , 
	po_pcnt float, 
	po_oth_chr float, 
	po_parm_cd varchar(2), 
	po_on numeric(3,0)
   ) ;


-- coswin.rc_abinfo definition
IF OBJECT_ID(N'dbo.cswn_rc_abinfo', N'U') IS NULL
create table cswn_rc_abinfo 
   (	commonkey numeric(8,0) not null , 
	indx numeric(3,0) not null , 
	rc_abhr numeric(5,0), 
	rc_abreason varchar(40)
   ) ;


-- coswin.res_hour definition
IF OBJECT_ID(N'dbo.cswn_res_hour', N'U') IS NULL
create table cswn_res_hour 
   (	pk_res_hour numeric(8,0), 
	timestamp numeric(10,0) not null , 
	rt_rh_35 numeric(8,0) not null , 
	rh_year numeric(5,0) not null , 
	rh_wk1_no numeric(5,0), 
	rh_wk1_off numeric(5,0), 
	rh_code numeric(3,0) not null
	);


-- coswin.rh_hrs definition
IF OBJECT_ID(N'dbo.cswn_rh_hrs', N'U') IS NULL
create table cswn_rh_hrs 
   (	commonkey numeric(8,0) not null , 
	indx numeric(3,0) not null , 
	rh_hrs float
	);

-- coswin.s_disc_pri definition
IF OBJECT_ID(N'dbo.cswn_s_disc_pri', N'U') IS NULL
create table cswn_s_disc_pri 
   (	commonkey numeric(8,0) not null , 
	indx numeric(3,0) not null , 
	s_disc_pri float
   ) ;


-- coswin.s_disc_ratep definition
IF OBJECT_ID(N'dbo.cswn_s_disc_ratep', N'U') IS NULL
create table cswn_s_disc_ratep 
   (	commonkey numeric(8,0) not null , 
	indx numeric(3,0) not null , 
	s_disc_ratep float
   ) ;

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0802_Others_MasterTables2_pre;
drop procedure if exists ste_0707_Others_TransactionTables2_pre;
GO

CREATE PROCEDURE ste_0707_Others_TransactionTables2_pre
	@PackageLogID INT
AS
BEGIN
	-- truncate existing data
	truncate table cswn_earl;
	truncate table cswn_group_ptd;
	truncate table cswn_late;
	truncate table cswn_po_item_other;
	truncate table cswn_po_other;
	truncate table cswn_rc_abinfo;
	truncate table cswn_res_hour;
	truncate table cswn_rh_hrs;
	truncate table cswn_s_disc_pri;
	truncate table cswn_s_disc_ratep;

END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0802_Others_MasterTables2_post;
drop procedure if exists ste_0707_Others_TransactionTables2_post;
GO

CREATE PROCEDURE ste_0707_Others_TransactionTables2_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_cnt int;
	declare @v_max_id bigint;
	declare @PackageName varchar(250);

	-- get package name
	select @PackageName = package_name from [dbo].[ste_migration_logs] where id = @PackageLogID;
	if (@PackageName is null) return;

	-- update start_id and end_id for ITEM_
	select @v_start_id=min(commonkey), @v_end_id=max(commonkey), @v_cnt=count(commonkey) from cswn_earl;

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
		, 'earl'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(commonkey), @v_end_id=max(commonkey), @v_cnt=count(commonkey) from cswn_group_ptd;

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
		, 'group_ptd'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(commonkey), @v_end_id=max(commonkey), @v_cnt=count(commonkey) from cswn_late;

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
		, 'late'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(commonkey), @v_end_id=max(commonkey), @v_cnt=count(commonkey) from cswn_po_item_other;

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
		, 'po_item_other'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(commonkey), @v_end_id=max(commonkey), @v_cnt=count(commonkey) from cswn_po_other;

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
		, 'po_other'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(commonkey), @v_end_id=max(commonkey), @v_cnt=count(commonkey) from cswn_rc_abinfo;

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
		, 'rc_abinfo'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_res_hour), @v_end_id=max(pk_res_hour), @v_cnt=count(pk_res_hour) from cswn_res_hour;

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
		, 'res_hour'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(commonkey), @v_end_id=max(commonkey), @v_cnt=count(commonkey) from cswn_rh_hrs;

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
		, 'rh_hrs'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(commonkey), @v_end_id=max(commonkey), @v_cnt=count(commonkey) from cswn_s_disc_pri;

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
		, 's_disc_pri'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(commonkey), @v_end_id=max(commonkey), @v_cnt=count(commonkey) from cswn_s_disc_ratep;

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
		, 's_disc_ratep'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	UPDATE [dbo].[ste_migration_logs] SET
	  [start_id] = 0
	, [end_id] = 0
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
           ('0707_Others_TransactionTables2'
           ,'version'
           ,'1'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO