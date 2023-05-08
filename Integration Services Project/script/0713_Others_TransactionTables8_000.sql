/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/

-- NOTE: moved to 0709_Others_TransactionTables4
---- coswin.tr_items definition
--IF OBJECT_ID(N'dbo.cswn_tr_items', N'U') IS NULL
--create table cswn_tr_items 
--   (	pk_tr_items numeric(8,0), 
--	timestamp numeric(10,0) default 1 not null , 
--	s_item_tr numeric(8,0) not null , 
--	s_loc_src numeric(8,0), 
--	s_loc_trg numeric(8,0), 
--	s_tr_item numeric(8,0) not null , 
--	tr_qty float, 
--	tr_value float 
--   ) ;

-- coswin.t_lcc_mthly_t definition
IF OBJECT_ID(N'dbo.cswn_t_lcc_mthly_t', N'U') IS NULL
create table cswn_t_lcc_mthly_t 
   (	pk_t_lcc_mthly_t numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	lcc_mthly_eqcd varchar(20), 
	lcc_mthly_total float, 
	lcc_mthly_mth numeric(10,0), 
	lcc_mthly_yr numeric(10,0)
   );

-- coswin.t_lcc_t definition
IF OBJECT_ID(N'dbo.cswn_t_lcc_t', N'U') IS NULL
create table cswn_t_lcc_t 
   (	pk_t_lcc_t numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	set_lcc_lcccurconf numeric(8,0), 
	lcc_eqcd varchar(20), 
	lcc_costvalue float, 
	lcc_mth numeric(10,0), 
	lcc_yr numeric(10,0), 
	lcc_cf_id numeric(10,0)
   );
   
   
-- coswin.wip_ws definition
IF OBJECT_ID(N'dbo.cswn_wip_ws', N'U') IS NULL
create table cswn_wip_ws 
   (	pk_wip_ws numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	wo_ws_58 numeric(8,0) not null , 
	wa_ws_2 numeric(8,0), 
	ws_itcd varchar(20) not null , 
	ws_req_qt float, 
	ws_use_qt float, 
	ws_mat_acost float, 
	ws_stfl numeric(3,0), 
	ws_seq_no numeric(5,0) not null , 
	ws_tot_req_qt float, 
	ws_tot_use_qty float, 
	ws_tot_mat_acost float, 
	ws_repl_flag numeric(3,0), 
	ws_pln_flag numeric(3,0), 
	ws_date1 numeric(10,0) default 0, 
	ws_string1 varchar(20)
   ) ;
   

-- coswin.wo_meterfdbk definition
IF OBJECT_ID(N'dbo.cswn_wo_meterfdbk', N'U') IS NULL
create table cswn_wo_meterfdbk 
   (	pk_wo_meterfdbk numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	s_workorder_meterfdbk numeric(8,0), 
	s_meter_meterfdbk numeric(8,0), 
	wm_date numeric(10,0), 
	wm_timw numeric(10,0), 
	wm_value float
   );
   
   
-- coswin.wp_work_permit definition
IF OBJECT_ID(N'dbo.cswn_wp_work_permit', N'U') IS NULL
create table cswn_wp_work_permit 
   (	pk_wp_work_permit numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	wp_code varchar(10) not null , 
	wp_request_date numeric(10,0), 
	wp_type varchar(10), 
	wp_status numeric(5,0), 
	wp_auth varchar(16), 
	wp_start_date numeric(10,0), 
	wp_end_date numeric(10,0), 
	wp_close_date numeric(10,0), 
	wp_granter varchar(16), 
	wp_job_desc varchar(100), 
	wp_job_request varchar(10), 
	wp_plan numeric(5,0), 
	wp_requester varchar(20), 
	wp_req_auth varchar(16), 
	wp_workorder numeric(10,0), 
	wp_date1 numeric(10,0), 
	wp_string1 varchar(20), 
	wp_string2 varchar(20)
   ) ;
   

-- coswin.wp_work_permit_empl definition
IF OBJECT_ID(N'dbo.cswn_wp_work_permit_empl', N'U') IS NULL
create table cswn_wp_work_permit_empl 
   (	pk_wp_work_permit_empl numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	wpe_workpermit varchar(10), 
	wpe_employee varchar(10), 
	wpe_request_date numeric(10,0), 
	wpe_status numeric(5,0), 
	wpe_cancel numeric(5,0), 
	wpe_start_date numeric(10,0), 
	wpe_end_date numeric(10,0), 
	wpe_close_date numeric(10,0), 
	wpe_granter varchar(16), 
	wpe_requester varchar(20), 
	wpe_date1 numeric(10,0), 
	wpe_string1 varchar(20), 
	wpe_string2 varchar(20)
   ) ;

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0808_Others_MasterTables8_pre;
drop procedure if exists ste_0713_Others_TransactionTables8_pre;
GO

CREATE PROCEDURE ste_0713_Others_TransactionTables8_pre
	@PackageLogID INT
AS
BEGIN
	-- truncate existing data
	--truncate table cswn_tr_items;
	truncate table cswn_t_lcc_mthly_t;
	truncate table cswn_t_lcc_t;
	truncate table cswn_wip_ws;
	truncate table cswn_wo_meterfdbk;
	truncate table cswn_wp_work_permit;
	truncate table cswn_wp_work_permit_empl;


END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0808_Others_MasterTables8_post;
drop procedure if exists ste_0713_Others_TransactionTables8_post;
GO

CREATE PROCEDURE ste_0713_Others_TransactionTables8_post
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
	--select @v_start_id=min(pk_tr_items), @v_end_id=max(pk_tr_items), @v_cnt=count(pk_tr_items) from cswn_tr_items;

	--insert into [dbo].[ste_migration_log_details] (
	--	[package_name]
	--	,[log_id]
	--	,[event]
	--	,[event_type]
	--	,[event_description]
	--)
	--values (
	--	@PackageName
	--	, @PackageLogID
	--	, 'tr_items'
	--	, 'COMPLETED'
	--	, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	--);

	select @v_start_id=min(pk_t_lcc_mthly_t), @v_end_id=max(pk_t_lcc_mthly_t), @v_cnt=count(pk_t_lcc_mthly_t) from cswn_t_lcc_mthly_t;

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
		, 't_lcc_mthly_t'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_t_lcc_t), @v_end_id=max(pk_t_lcc_t), @v_cnt=count(pk_t_lcc_t) from cswn_t_lcc_t;

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
		, 't_lcc_t'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_wip_ws), @v_end_id=max(pk_wip_ws), @v_cnt=count(pk_wip_ws) from cswn_wip_ws;

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
		, 'wip_ws'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_wo_meterfdbk), @v_end_id=max(pk_wo_meterfdbk), @v_cnt=count(pk_wo_meterfdbk) from cswn_wo_meterfdbk;

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
		, 'wo_meterfdbk'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_wp_work_permit), @v_end_id=max(pk_wp_work_permit), @v_cnt=count(pk_wp_work_permit) from cswn_wp_work_permit;

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
		, 'wp_work_permit'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_wp_work_permit_empl), @v_end_id=max(pk_wp_work_permit_empl), @v_cnt=count(pk_wp_work_permit_empl) from cswn_wp_work_permit_empl;

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
		, 'wp_work_permit_empl'
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
           ('0713_Others_TransactionTables8'
           ,'version'
           ,'1'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO