/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- coswin.cn_invoice definition
IF OBJECT_ID(N'dbo.cswn_cn_invoice', N'U') IS NULL
create table cswn_cn_invoice 
   (	pk_cn_invoice numeric(8,0), 
	timestamp numeric(10,0) not null , 
	s_negi_to_cni numeric(8,0), 
	s_inv_to_cni numeric(8,0), 
	cni_date numeric(10,0), 
	cni_value numeric not null
   ) ;


-- coswin.count_ definition
IF OBJECT_ID(N'dbo.cswn_count_', N'U') IS NULL
create table cswn_count_ 
   (	pk_count_ numeric(8,0), 
	timestamp numeric(10,0) not null , 
	sc_code varchar(10) not null , 
	sc_desc varchar(100), 
	sc_cent varchar(16), 
	sc_date numeric(10,0), 
	stkcnt_string1 varchar(20)
   ) ;


-- coswin.del_sched definition
IF OBJECT_ID(N'dbo.cswn_del_sched', N'U') IS NULL
create table cswn_del_sched 
   (	pk_del_sched numeric(8,0), 
	timestamp numeric(10,0) not null , 
	s_po_ds numeric(8,0) not null , 
	ds_qty_tobe_del float, 
	ds_exp_del_dt numeric(10,0) not null , 
	ds_act_qty_del float, 
	ds_dn_ref varchar(10), 
	ds_act_del_dt numeric(10,0)
   ) ;


-- coswin.dem_loc_int definition
IF OBJECT_ID(N'dbo.cswn_dem_loc_int', N'U') IS NULL
create table cswn_dem_loc_int 
   (	pk_dem_loc_int numeric(8,0), 
	timestamp numeric(10,0) not null , 
	s_dem_loc_int numeric(8,0), 
	s_loc_dem_int numeric(8,0), 
	s_iss_loc_int numeric(8,0), 
	dem_loc_qty float, 
	rtn_to_loc float, 
	iss_loc_val float, 
	dem_rcl_qty float, 
	dem_loc_ask float
   ) ;


-- coswin.dir_inv_po definition
IF OBJECT_ID(N'dbo.cswn_dir_inv_po', N'U') IS NULL
create table cswn_dir_inv_po 
   (	pk_dir_inv_po numeric(8,0), 
	timestamp numeric(10,0) not null , 
	s_po_dip numeric(8,0), 
	s_inv_dip numeric(8,0), 
	inv_date numeric(10,0)
   ) ;


-- coswin.dir_rct_po definition
IF OBJECT_ID(N'dbo.cswn_dir_rct_po', N'U') IS NULL
create table cswn_dir_rct_po 
   (	pk_dir_rct_po numeric(8,0), 
	timestamp numeric(10,0) not null , 
	s_po_drp numeric(8,0), 
	s_rct_drp numeric(8,0), 
	rec_date numeric(10,0) 
   ) ;


-- coswin.s_earl definition
IF OBJECT_ID(N'dbo.cswn_s_earl', N'U') IS NULL
create table cswn_s_earl 
   (	commonkey numeric(8,0) not null , 
	indx numeric(3,0) not null , 
	s_earl numeric(5,0)
   ) ;


-- coswin.s_late definition
IF OBJECT_ID(N'dbo.cswn_s_late', N'U') IS NULL
create table cswn_s_late 
   (	commonkey numeric(8,0)  not null , 
	indx numeric(3,0) not null , 
	s_late numeric(5,0)
   ) ;


-- coswin.s_ord_qty_val definition
IF OBJECT_ID(N'dbo.cswn_s_ord_qty_val', N'U') IS NULL
create table cswn_s_ord_qty_val 
   (	commonkey numeric(8,0) not null , 
	indx numeric(3,0) not null , 
	s_ord_qty_val float
   ) ;


-- coswin.s_pay definition
IF OBJECT_ID(N'dbo.cswn_s_pay', N'U') IS NULL
create table cswn_s_pay 
   (	commonkey numeric(8,0) not null , 
	indx numeric(3,0) not null , 
	pay_days numeric(5,0), 
	pay_discp float
   ) ;



-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0803_Others_MasterTables3_pre;
drop procedure if exists ste_0708_Others_TransactionTables3_pre;
GO

CREATE PROCEDURE ste_0708_Others_TransactionTables3_pre
	@PackageLogID INT
AS
BEGIN
	-- truncate existing data
	truncate table cswn_cn_invoice;
	truncate table cswn_count_;
	truncate table cswn_del_sched;
	truncate table cswn_dem_loc_int;
	truncate table cswn_dir_inv_po;
	truncate table cswn_dir_rct_po;
	truncate table cswn_s_earl;
	truncate table cswn_s_late;
	truncate table cswn_s_ord_qty_val;
	truncate table cswn_s_pay;

END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0803_Others_MasterTables3_post;
drop procedure if exists ste_0708_Others_TransactionTables3_post;
GO

CREATE PROCEDURE ste_0708_Others_TransactionTables3_post
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
	select @v_start_id=min(pk_cn_invoice), @v_end_id=max(pk_cn_invoice), @v_cnt=count(pk_cn_invoice) from cswn_cn_invoice;

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
		, 'cn_invoice'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_count_), @v_end_id=max(pk_count_), @v_cnt=count(pk_count_) from cswn_count_;

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
		, 'count_'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_del_sched), @v_end_id=max(pk_del_sched), @v_cnt=count(pk_del_sched) from cswn_del_sched;

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
		, 'del_sched'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_dem_loc_int), @v_end_id=max(pk_dem_loc_int), @v_cnt=count(pk_dem_loc_int) from cswn_dem_loc_int;

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
		, 'dem_loc_int'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_dir_inv_po), @v_end_id=max(pk_dir_inv_po), @v_cnt=count(pk_dir_inv_po) from cswn_dir_inv_po;

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
		, 'dir_inv_po'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_dir_rct_po), @v_end_id=max(pk_dir_rct_po), @v_cnt=count(pk_dir_rct_po) from cswn_dir_rct_po;

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
		, 'dir_rct_po'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(commonkey), @v_end_id=max(commonkey), @v_cnt=count(commonkey) from cswn_s_earl;

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
		, 's_earl'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(commonkey), @v_end_id=max(commonkey), @v_cnt=count(commonkey) from cswn_s_late;

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
		, 's_late'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(commonkey), @v_end_id=max(commonkey), @v_cnt=count(commonkey) from cswn_s_ord_qty_val;

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
		, 's_ord_qty_val'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(commonkey), @v_end_id=max(commonkey), @v_cnt=count(commonkey) from cswn_s_pay;

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
		, 's_pay'
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
           ('0708_Others_TransactionTables3'
           ,'version'
           ,'1'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO