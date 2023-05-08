/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- coswin.reconcile_inv definition
IF OBJECT_ID(N'dbo.cswn_reconcile_inv', N'U') IS NULL
create table cswn_reconcile_inv 
   (	pk_reconcile_inv numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	dt_reconcile numeric(10,0), 
	rcl_ref varchar(10) not null , 
	rcl_dt numeric(10,0), 
	rcl_string1 varchar(20) 
   ) ;

-- coswin.request_by definition
IF OBJECT_ID(N'dbo.cswn_request_by', N'U') IS NULL
create table cswn_request_by 
   (	pk_request_by numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	ry_code varchar(20) not null , 
	ry_description varchar(100), 
	ry_phone varchar(15), 
	ry_info1 varchar(20), 
	ry_info2 float, 
	ry_info3 numeric(10,0)
   ) ;

-- coswin.sup_perf definition
IF OBJECT_ID(N'dbo.cswn_sup_perf', N'U') IS NULL
create table cswn_sup_perf 
   (	pk_sup_perf numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	sp_id varchar(10) not null , 
	sp_author varchar(16), 
	sp_date numeric(10,0), 
	sp_quality numeric(5,0), 
	sp_item_cd varchar(20), 
	sp_dn_ref varchar(10), 
	sp_supl_cd varchar(20)
   ) ;

-- coswin.temp_tar_det definition
IF OBJECT_ID(N'dbo.cswn_temp_tar_det', N'U') IS NULL
create table cswn_temp_tar_det 
   (	tar_id varchar(14) not null , 
	transactiondate date not null , 
	transactiontype varchar(50)
   ) ;


-- coswin.pr_pq_int definition
IF OBJECT_ID(N'dbo.cswn_pr_pq_int', N'U') IS NULL
create table cswn_pr_pq_int 
   (	pk_pr_pq_int numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	s_pq_pr_int numeric(8,0) not null , 
	s_pr_pq_int numeric(8,0) not null , 
	pr_pq_qty float, 
	pr_pq_ord_qty float
   );
   
-- coswin.rct_cc_int definition
IF OBJECT_ID(N'dbo.cswn_rct_cc_int', N'U') IS NULL
create table cswn_rct_cc_int 
   (	pk_rct_cc_int numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	s_rcti_cc_int numeric(8,0) not null , 
	s_cc_rcti_int numeric(8,0) not null , 
	rct_cc_ref varchar(2), 
	rct_cc_p float
   ) ;
   
   
-- coswin.rct_loc_int definition
IF OBJECT_ID(N'dbo.cswn_rct_loc_int', N'U') IS NULL
create table cswn_rct_loc_int 
   (	pk_rct_loc_int numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	s_rct_item_loc numeric(8,0) not null , 
	s_loc_rct_item numeric(8,0), 
	rct_loc_qty float, 
	rtn_loc_qty float, 
	rct_loc_rcl_qty float, 
	rct_loc_val float
   ) ;
   
   

-- coswin.rep_count_item definition
IF OBJECT_ID(N'dbo.cswn_rep_count_item', N'U') IS NULL
create table cswn_rep_count_item 
   (	pk_rep_count_item numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	s_rep_count_items numeric(8,0) not null , 
	rci_actual_qty float, 
	rci_item_cd varchar(20) not null , 
	rci_store_cd varchar(10) not null , 
	rci_bin_ref varchar(16) not null , 
	rci_batch_ref varchar(12) not null , 
	rci_srl_no varchar(24), 
	rci_item_short varchar(105), 
	rci_updated numeric(3,0), 
	rci_to_update numeric(3,0), 
	rci_locked numeric(3,0), 
	rci_orig_qty float
   ) ;
   
   
-- coswin.stk_adj definition
IF OBJECT_ID(N'dbo.cswn_stk_adj', N'U') IS NULL
create table cswn_stk_adj 
   (	pk_stk_adj numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	s_count_adj numeric(8,0), 
	s_item_adj numeric(8,0) not null , 
	s_loc_adj numeric(8,0), 
	tm_adj numeric(10,0), 
	adj_dt numeric(10,0), 
	adj_cc varchar(16), 
	adj_qty float, 
	adj_val float, 
	adj_unit_cost float, 
	adj_string1 varchar(20)
   ) ;


-- coswin.transfer_ definition
IF OBJECT_ID(N'dbo.cswn_transfer_', N'U') IS NULL
create table cswn_transfer_ 
   (	pk_transfer_ numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	tr_code varchar(10) not null , 
	tr_date numeric(10,0), 
	tr_time numeric(10,0), 
	tr_string1 varchar(20), 
	tr_authority varchar(16), 
	tr_status numeric(5,0), 
	tr_type numeric(5,0), 
	tr_last_dt numeric(10,0)
   ) ;
   

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0807_Others_MasterTables7_pre;
drop procedure if exists ste_0712_Others_TransactionTables7_pre;
GO

CREATE PROCEDURE ste_0712_Others_TransactionTables7_pre
	@PackageLogID INT
AS
BEGIN
	-- truncate existing data
	truncate table cswn_pr_pq_int;
	truncate table cswn_rct_cc_int;
	truncate table cswn_rct_loc_int;
	truncate table cswn_reconcile_inv;
	truncate table cswn_rep_count_item;
	truncate table cswn_request_by;
	truncate table cswn_stk_adj;
	truncate table cswn_sup_perf;
	truncate table cswn_temp_tar_det;
	truncate table cswn_transfer_;


END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0807_Others_MasterTables7_post;
drop procedure if exists ste_0712_Others_TransactionTables7_post;
GO

CREATE PROCEDURE ste_0712_Others_TransactionTables7_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_start_id2 varchar(250);
	declare @v_end_id2 varchar(250);
	declare @v_cnt int;
	declare @v_max_id bigint;
	declare @PackageName varchar(250);

	-- get package name
	select @PackageName = package_name from [dbo].[ste_migration_logs] where id = @PackageLogID;
	if (@PackageName is null) return;

	-- update start_id and end_id for ITEM_
	select @v_start_id=min(pk_reconcile_inv), @v_end_id=max(pk_reconcile_inv), @v_cnt=count(pk_reconcile_inv) from cswn_reconcile_inv;

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
		, 'reconcile_inv'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_request_by), @v_end_id=max(pk_request_by), @v_cnt=count(pk_request_by) from cswn_request_by;

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
		, 'request_by'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_sup_perf), @v_end_id=max(pk_sup_perf), @v_cnt=count(pk_sup_perf) from cswn_sup_perf;

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
		, 'sup_perf'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id2=min(tar_id), @v_end_id2=max(tar_id), @v_cnt=count(tar_id) from cswn_temp_tar_det;

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
		, 'temp_tar_det'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id2, ', END_ID: ', @v_end_id2)
	);

	select @v_start_id=min(pk_pr_pq_int), @v_end_id=max(pk_pr_pq_int), @v_cnt=count(pk_pr_pq_int) from cswn_pr_pq_int;

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
		, 'pr_pq_int'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_rct_cc_int), @v_end_id=max(pk_rct_cc_int), @v_cnt=count(pk_rct_cc_int) from cswn_rct_cc_int;

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
		, 'rct_cc_int'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_rct_loc_int), @v_end_id=max(pk_rct_loc_int), @v_cnt=count(pk_rct_loc_int) from cswn_rct_loc_int;

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
		, 'rct_loc_int'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_rep_count_item), @v_end_id=max(pk_rep_count_item), @v_cnt=count(pk_rep_count_item) from cswn_rep_count_item;

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
		, 'rep_count_item'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_stk_adj), @v_end_id=max(pk_stk_adj), @v_cnt=count(pk_stk_adj) from cswn_stk_adj;

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
		, 'stk_adj'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_transfer_), @v_end_id=max(pk_transfer_), @v_cnt=count(pk_transfer_) from cswn_transfer_;

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
		, 'transfer_'
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
           ('0712_Others_TransactionTables7'
           ,'version'
           ,'1'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO