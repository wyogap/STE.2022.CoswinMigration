/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- coswin.free_tbl5 definition
IF OBJECT_ID(N'dbo.cswn_free_tbl5', N'U') IS NULL
create table cswn_free_tbl5 
   (	pk_free_tbl5 numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	tbl5_code varchar(20) null , 
	tbl5_description varchar(100), 
	tbl5_number1 float, 
	tbl5_date1 numeric(10,0), 
	tbl5_string1 varchar(20), 
	tbl5_string2 varchar(20), 
	tbl5_string3 varchar(20) 
   ) ;


-- dbo.cswn_m_trainalarm definition
IF OBJECT_ID(N'dbo.cswn_m_trainalarm', N'U') IS NULL
create table cswn_m_trainalarm 
   (	alarm_code numeric(18,0), 
	job_desc varchar(200), 
	car_loc numeric(18,0), 
	sub_loc varchar(40), 
	a_type varchar(40), 
	a_number varchar(40)
   );


-- dbo.cswn_wp_work_permit_type definition
IF OBJECT_ID(N'dbo.cswn_wp_work_permit_type', N'U') IS NULL
create table cswn_wp_work_permit_type 
   (	pk_wp_work_permit_type numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	wpt_code varchar(10)  not null , 
	wpt_desc varchar(100), 
	wpt_string1 varchar(20), 
	wpt_string2 varchar(20)
   ) ;


-- dbo.cswn_fm_instance definition
IF OBJECT_ID(N'dbo.cswn_fm_instance', N'U') IS NULL
create table cswn_fm_instance 
   (	pk_fm_instance numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	s_fm_instance numeric(8,0), 
	s_eqp_fmi numeric(8,0), 
	fmi_rate float, 
	fmi_sharable numeric(5,0), 
	fmi_time_unit numeric(5,0)
   ) ;


-- dbo.cswn_fm_usage definition
IF OBJECT_ID(N'dbo.cswn_fm_usage', N'U') IS NULL
create table cswn_fm_usage 
   (	pk_fm_usage numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	s_fmi_usage numeric(8,0), 
	s_wip_fmu numeric(8,0), 
	s_fm_usage numeric(8,0), 
	fmu_actual_rate float, 
	fmu_end_dt numeric(10,0), 
	fmu_end_tm numeric(10,0), 
	fmu_planned numeric(5,0), 
	fmu_requested_time float, 
	fmu_sharable numeric(5,0), 
	fmu_start_dt numeric(10,0), 
	fmu_start_tm numeric(10,0), 
	fmu_status numeric(5,0), 
	fmu_time_unit numeric(5,0), 
	fmu_worked_time float 
   );


-- dbo.cswn_h_dv_items definition
IF OBJECT_ID(N'dbo.cswn_h_dv_items', N'U') IS NULL
create table cswn_h_dv_items 
   (	pk_h_dv_items numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	h_s_items_dv numeric(8,0) not null , 
	h_s_devis_dv numeric(8,0) not null , 
	h_s_dv_item_gen numeric(8,0), 
	h_dv_qty float, 
	h_dv_stor_cd varchar(10), 
	h_dv_unit varchar(6), 
	h_dv_unit_rate float, 
	h_dv_delay numeric(5,0), 
	h_dv_value float, 
	h_dv_discnt numeric(3,0), 
	h_dv_to_order numeric(3,0), 
	h_dv_it_number1 float, 
	h_dv_it_string1 varchar(20), 
	h_dv_s_item_ref varchar(20)
   ) ;


-- dbo.cswn_h_item definition
IF OBJECT_ID(N'dbo.cswn_h_item', N'U') IS NULL
create table cswn_h_item 
   (	pk_h_item numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	h_s_rmk_item numeric(8,0) not null , 
	h_s_ld_item numeric(8,0) not null , 
	h_item_cd varchar(20), 
	h_item_short varchar(100), 
	h_item_grp varchar(10), 
	h_item_units varchar(6), 
	h_item_type numeric(3,0), 
	h_item_authority varchar(16), 
	h_item_number1 float, 
	h_item_number2 float, 
	h_item_date1 numeric(10,0), 
	h_item_string1 varchar(20), 
	h_item_string2 varchar(20), 
	h_item_ns_flag numeric(3,0)
   ) ;


-- dbo.cswn_h_rct_items definition
IF OBJECT_ID(N'dbo.cswn_h_rct_items', N'U') IS NULL
create table cswn_h_rct_items 
   (	pk_h_rct_items numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	h_s_rct_item numeric(8,0) not null , 
	h_s_item_rct numeric(8,0) not null , 
	h_rct_po_ref varchar(10), 
	h_rct_nst_ref numeric(3,0), 
	h_rct_qty float, 
	h_acp_qty float, 
	h_rct_unit varchar(6), 
	h_insp_ref varchar(9), 
	h_insp_dt numeric(10,0), 
	h_insp_stat numeric(3,0), 
	h_rct_unit_rate float, 
	h_rct_val float, 
	h_rct_tp_flg numeric(3,0), 
	h_rtn_to_supl float, 
	h_rct_inv_qty float, 
	h_rct_rcl_qty float, 
	h_rct_act_no numeric(5,0), 
	h_rct_it_number1 float, 
	h_rct_it_string1 varchar(20), 
	h_rct_s_item_ref varchar(20)
   ) ;


-- dbo.cswn_job_catg_int definition
IF OBJECT_ID(N'dbo.cswn_job_catg_int', N'U') IS NULL
create table cswn_job_catg_int 
   (	pk_job_catg_int numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	jd_ct_int numeric(8,0) not null , 
	ct_jd_23 numeric(8,0) not null , 
	job_name varchar(16) not null 
   ) ;


-- dbo.cswn_job_empl definition
IF OBJECT_ID(N'dbo.cswn_job_empl', N'U') IS NULL
create table cswn_job_empl 
   (	pk_job_empl numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	s_eqp_job_empl numeric(8,0) not null , 
	s_empl_eqp_job numeric(8,0) not null , 
	s_job_manr_job_empl numeric(8,0), 
	je_pln_hrs float 
   );


-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0715_Others_MasterTables2_pre
GO

CREATE PROCEDURE ste_0715_Others_MasterTables2_pre
	@PackageLogID INT
AS
BEGIN
	-- truncate existing data
	truncate table cswn_fm_instance;
	truncate table cswn_fm_usage;
	truncate table cswn_free_tbl5;
	truncate table cswn_h_dv_items;
	truncate table cswn_h_item;
	truncate table cswn_h_rct_items;
	truncate table cswn_job_catg_int;
	truncate table cswn_job_empl;
	truncate table cswn_m_trainalarm;
	truncate table cswn_wp_work_permit_type;


END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0715_Others_MasterTables2_post
GO

CREATE PROCEDURE ste_0715_Others_MasterTables2_post
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
	select @v_start_id=min(pk_free_tbl5), @v_end_id=max(pk_free_tbl5), @v_cnt=count(pk_free_tbl5) from cswn_free_tbl5;

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
		, 'free_tbl5'
		, 'LOG'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(alarm_code), @v_end_id=max(alarm_code), @v_cnt=count(alarm_code) from cswn_m_trainalarm;

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
		, 'm_trainalarm'
		, 'LOG'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_wp_work_permit_type), @v_end_id=max(pk_wp_work_permit_type), @v_cnt=count(pk_wp_work_permit_type) from cswn_wp_work_permit_type;

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
		, 'wp_work_permit_type'
		, 'LOG'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_fm_instance), @v_end_id=max(pk_fm_instance), @v_cnt=count(pk_fm_instance) from cswn_fm_instance;

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
		, 'fm_instance'
		, 'LOG'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_fm_usage), @v_end_id=max(pk_fm_usage), @v_cnt=count(pk_fm_usage) from cswn_fm_usage;

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
		, 'fm_usage'
		, 'LOG'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_h_dv_items), @v_end_id=max(pk_h_dv_items), @v_cnt=count(pk_h_dv_items) from cswn_h_dv_items;

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
		, 'h_dv_items'
		, 'LOG'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_h_item), @v_end_id=max(pk_h_item), @v_cnt=count(pk_h_item) from cswn_h_item;

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
		, 'h_item'
		, 'LOG'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_h_rct_items), @v_end_id=max(pk_h_rct_items), @v_cnt=count(pk_h_rct_items) from cswn_h_rct_items;

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
		, 'h_rct_items'
		, 'LOG'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_job_catg_int), @v_end_id=max(pk_job_catg_int), @v_cnt=count(pk_job_catg_int) from cswn_job_catg_int;

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
		, 'job_catg_int'
		, 'LOG'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_job_empl), @v_end_id=max(pk_job_empl), @v_cnt=count(pk_job_empl) from cswn_job_empl;

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
		, 'job_empl'
		, 'LOG'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
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
           ('0715_Others_MasterTables2'
           ,'version'
           ,'1'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO