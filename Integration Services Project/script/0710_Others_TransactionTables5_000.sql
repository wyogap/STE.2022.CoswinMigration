/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- coswin.h_dem_iss definition
IF OBJECT_ID(N'dbo.cswn_h_dem_iss', N'U') IS NULL
create table cswn_h_dem_iss 
   (	pk_h_dem_iss numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	h_s_dem_iss numeric(8,0), 
	h_dem_ref varchar(10) not null , 
	h_dem_dt numeric(10,0), 
	h_dem_status numeric(3,0), 
	h_dem_wo_ref numeric(10,0), 
	h_dem_cc varchar(16), 
	h_dem_type numeric(3,0), 
	h_dem_demander varchar(16), 
	h_dem_issuer varchar(16), 
	h_dem_rmk varchar(20), 
	h_dem_iss_tag numeric(3,0), 
	h_dem_string1 varchar(20), 
	h_dem_string2 varchar(20)
   );


-- coswin.h_dem_loc_int definition
IF OBJECT_ID(N'dbo.cswn_h_dem_loc_int', N'U') IS NULL
create table cswn_h_dem_loc_int 
   (	pk_h_dem_loc_int numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	h_s_iss_loc_int numeric(8,0) not null , 
	h_dem_loc_qty float, 
	h_rtn_to_loc float, 
	h_iss_loc_val float, 
	h_dem_rcl_qty float, 
	h_dli_loc_bins varchar(16), 
	h_dli_loc_st_it varchar(10), 
	h_dli_loc_batch varchar(12), 
	h_dli_srl_no varchar(24), 
	h_dem_loc_ask float
   );


-- coswin.h_devis definition
IF OBJECT_ID(N'dbo.cswn_h_devis', N'U') IS NULL
create table cswn_h_devis 
   (	pk_h_devis numeric(8,0), 
	timestamp numeric(10,0) not null , 
	h_devis_cd varchar(13) not null , 
	h_devis_date numeric(10,0), 
	h_dv_incharge varchar(16), 
	h_dv_text varchar(100), 
	h_dv_cc_cd varchar(16), 
	h_dv_status numeric(5,0), 
	h_dv_po_cd varchar(10), 
	h_dv_preq_ref varchar(10), 
	h_dv_pay_mod varchar(6), 
	h_dv_woid varchar(10), 
	h_dv_exp_ret numeric(10,0), 
	h_dv_supl_cd varchar(20), 
	h_dv_string1 varchar(20), 
	h_dv_string2 varchar(20)
   );


-- coswin.h_iss_items definition
IF OBJECT_ID(N'dbo.cswn_h_iss_items', N'U') IS NULL
create table cswn_h_iss_items 
   (	pk_h_iss_items numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	h_s_items_iss numeric(8,0) not null , 
	h_s_dem_iss_item numeric(8,0) not null , 
	h_iss_ref varchar(8), 
	h_iss_dt numeric(10,0), 
	h_iss_ask_qty float, 
	h_iss_qty float, 
	h_iss_val float, 
	h_rtn_to_store float, 
	h_exp_dt_ret numeric(10,0), 
	h_iss_tp_flg numeric(3,0), 
	h_iss_act_no numeric(5,0), 
	h_iss_it_number1 float, 
	h_iss_it_string1 varchar(20)
   ) ;


-- coswin.h_prequest definition
IF OBJECT_ID(N'dbo.cswn_h_prequest', N'U') IS NULL
create table cswn_h_prequest 
   (	pk_h_prequest numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	h_pr_ref varchar(10) not null , 
	h_pr_dt numeric(10,0), 
	h_pr_type numeric(3,0), 
	h_pr_status numeric(3,0), 
	h_pr_wo_ref varchar(10), 
	h_pr_cc varchar(16), 
	h_pr_est_val float, 
	h_pr_req_by varchar(16), 
	h_pr_string1 varchar(20), 
	h_pr_string2 varchar(20)
   ) ;


-- coswin.h_pr_items definition
IF OBJECT_ID(N'dbo.cswn_h_pr_items', N'U') IS NULL
create table cswn_h_pr_items 
   (	pk_h_pr_items numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	h_s_items_pr numeric(8,0) not null , 
	h_s_pr_item numeric(8,0) not null , 
	h_needed_dt numeric(10,0), 
	h_pr_qty float, 
	h_pr_ord_qty float, 
	h_pr_unit varchar(6), 
	h_pr_nst_ref numeric(3,0), 
	h_pr_tp_flg numeric(3,0), 
	h_pr_pref_supl varchar(20), 
	h_pr_stor_cd varchar(10), 
	h_pr_item_est_val float, 
	h_pr_dev_qty float, 
	h_pr_it_number1 float, 
	h_pr_it_string1 varchar(20)
   ) ;


-- coswin.h_rct_loc_int definition
IF OBJECT_ID(N'dbo.cswn_h_rct_loc_int', N'U') IS NULL
create table cswn_h_rct_loc_int 
   (	pk_h_rct_loc_int numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	h_s_rct_item_loc numeric(8,0) not null , 
	h_rct_loc_qty float, 
	h_rtn_loc_qty float, 
	h_rct_loc_rcl_qty float, 
	h_rct_loc_val float, 
	h_rct_loc_bins varchar(16), 
	h_rct_loc_st_it varchar(10), 
	h_rct_loc_batch varchar(12), 
	h_rct_srl_no varchar(24)
   );


-- coswin.h_receipt definition
IF OBJECT_ID(N'dbo.cswn_h_receipt', N'U') IS NULL
create table cswn_h_receipt 
   (	pk_h_receipt numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	h_dn_ref varchar(10)  not null , 
	h_dn_dt numeric(10,0), 
	h_grn_ref varchar(10) not null , 
	h_grn_dt numeric(10,0), 
	h_rct_dt numeric(10,0), 
	h_transport varchar(15), 
	h_rct_type numeric(3,0), 
	h_rct_dem_wo_ref varchar(10), 
	h_rct_status numeric(3,0), 
	h_rct_supl_cd varchar(20), 
	h_rct_string1 varchar(20), 
	h_rct_string2 varchar(20)
   ) ;


-- coswin.h_transfer definition
IF OBJECT_ID(N'dbo.cswn_h_transfer', N'U') IS NULL
create table cswn_h_transfer 
   (	pk_h_transfer numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	h_tr_code varchar(10) not null , 
	h_tr_authority varchar(16), 
	h_tr_status numeric(5,0), 
	h_tr_type numeric(5,0), 
	h_tr_string1 varchar(20), 
	h_tr_date numeric(10,0), 
	h_tr_last_dt numeric(10,0)
   ) ;


-- coswin.inv_cc_int definition
IF OBJECT_ID(N'dbo.cswn_inv_cc_int', N'U') IS NULL
create table cswn_inv_cc_int 
   (	pk_inv_cc_int numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	s_cc_inv_int numeric(8,0) not null , 
	s_ini_cc_int numeric(8,0) not null , 
	inv_cc_ref varchar(2), 
	inv_cc_p float, 
	inv_cc_val float
   ) ;


-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0805_Others_MasterTables5_pre;
drop procedure if exists ste_0710_Others_TransactionTables5_pre;
GO

CREATE PROCEDURE ste_0710_Others_TransactionTables5_pre
	@PackageLogID INT
AS
BEGIN
	-- truncate existing data
	truncate table cswn_h_dem_iss;
	truncate table cswn_h_dem_loc_int;
	truncate table cswn_h_devis;
	truncate table cswn_h_iss_items;
	truncate table cswn_h_prequest;
	truncate table cswn_h_pr_items;
	truncate table cswn_h_rct_loc_int;
	truncate table cswn_h_receipt;
	truncate table cswn_h_transfer;
	truncate table cswn_inv_cc_int;


END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0805_Others_MasterTables5_post;
drop procedure if exists ste_0710_Others_TransactionTables5_post;
GO

CREATE PROCEDURE ste_0710_Others_TransactionTables5_post
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
	select @v_start_id=min(pk_h_dem_iss), @v_end_id=max(pk_h_dem_iss), @v_cnt=count(pk_h_dem_iss) from cswn_h_dem_iss;

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
		, 'h_dem_iss'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_h_dem_loc_int), @v_end_id=max(pk_h_dem_loc_int), @v_cnt=count(pk_h_dem_loc_int) from cswn_h_dem_loc_int;

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
		, 'h_dem_loc_int'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_h_devis), @v_end_id=max(pk_h_devis), @v_cnt=count(pk_h_devis) from cswn_h_devis;

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
		, 'h_devis'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_h_iss_items), @v_end_id=max(pk_h_iss_items), @v_cnt=count(pk_h_iss_items) from cswn_h_iss_items;

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
		, 'h_iss_items'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_h_prequest), @v_end_id=max(pk_h_prequest), @v_cnt=count(pk_h_prequest) from cswn_h_prequest;

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
		, 'h_prequest'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_h_rct_loc_int), @v_end_id=max(pk_h_rct_loc_int), @v_cnt=count(pk_h_rct_loc_int) from cswn_h_rct_loc_int;

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
		, 'h_rct_loc_int'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_h_receipt), @v_end_id=max(pk_h_receipt), @v_cnt=count(pk_h_receipt) from cswn_h_receipt;

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
		, 'h_receipt'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_h_transfer), @v_end_id=max(pk_h_transfer), @v_cnt=count(pk_h_transfer) from cswn_h_transfer;

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
		, 'h_transfer'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_h_pr_items), @v_end_id=max(pk_h_pr_items), @v_cnt=count(pk_h_pr_items) from cswn_h_pr_items;

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
		, 'h_pr_items'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_inv_cc_int), @v_end_id=max(pk_inv_cc_int), @v_cnt=count(pk_inv_cc_int) from cswn_inv_cc_int;

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
		, 'inv_cc_int'
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
           ('0710_Others_TransactionTables5'
           ,'version'
           ,'1'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO