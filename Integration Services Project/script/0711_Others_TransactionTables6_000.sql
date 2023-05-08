/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- coswin.m_washhist definition
IF OBJECT_ID(N'dbo.cswn_m_washhist', N'U') IS NULL
create table cswn_m_washhist 
   (	pk_m_washhist numeric(8,0), 
	workorderid numeric(10,0), 
	oddcarno varchar(3), 
	datetime varchar(14), 
	washcode varchar(1), 
	status varchar(1)
   ) ;


-- coswin.inv_rct definition
IF OBJECT_ID(N'dbo.cswn_inv_rct', N'U') IS NULL
create table cswn_inv_rct 
   (	pk_inv_rct numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	s_inv_rct numeric(8,0) not null , 
	s_rct_loc_inv numeric(8,0) not null , 
	inv_rct_qty float, 
	inv_rct_val float
   );


-- coswin.item_ptd definition
IF OBJECT_ID(N'dbo.cswn_item_ptd', N'U') IS NULL
create table cswn_item_ptd 
   (	pk_item_ptd numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	s_item_ptd numeric(8,0), 
	s_stores_item_ptd numeric(8,0), 
	dt_itemptd numeric(10,0), 
	tm_itemptd numeric(10,0), 
	td_cd varchar(1), 
	td_opn_qty float, 
	td_opn_val float, 
	td_zero_val_qty float, 
	td_rct_qty float, 
	td_rct_val float, 
	td_iss_qty float, 
	td_iss_val float, 
	td_adj_qty float, 
	td_adj_val float, 
	td_po_qty float, 
	td_po_val float, 
	td_dlv_qty float, 
	td_rej_qty float, 
	td_pr_qty float, 
	td_def_qty float, 
	td_def_no numeric(5,0), 
	td_rej_no numeric(5,0), 
	td_iss_no numeric(5,0), 
	td_rct_no numeric(5,0), 
	td_pr_no numeric(5,0), 
	td_out_no numeric(5,0), 
	td_po_no numeric(5,0), 
	td_rct_avg_price float, 
	td_iss_avg_cost float, 
	td_avg_iss_qty float, 
	td_avg_rct_qty float, 
	td_avg_lead_time numeric(5,0), 
	td_tran_qty float, 
	td_tran_val float
   ) ;


-- coswin.item_srl definition
IF OBJECT_ID(N'dbo.cswn_item_srl', N'U') IS NULL
create table cswn_item_srl 
   (	pk_item_srl numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	s_item_srl numeric(8,0) not null , 
	i_srl_no varchar(24) not null , 
	i_rep_status numeric(5,0)
   );

-- coswin.i_consp_qty definition
IF OBJECT_ID(N'dbo.cswn_i_consp_qty', N'U') IS NULL
create table cswn_i_consp_qty 
   (	commonkey numeric(8,0) not null , 
	indx numeric(3,0) not null , 
	i_consp_qty float
   ) ;


-- coswin.neg_inv definition
IF OBJECT_ID(N'dbo.cswn_neg_inv', N'U') IS NULL
create table cswn_neg_inv 
   (	pk_neg_inv numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	ni_ref varchar(10) not null , 
	ni_dt numeric(10,0), 
	ni_tot_val float, 
	ni_string1 varchar(20), 
	ni_supl varchar(20), 
	ni_status numeric(3,0)
   ) ;

-- coswin.neg_inv_cc definition
IF OBJECT_ID(N'dbo.cswn_neg_inv_cc', N'U') IS NULL
create table cswn_neg_inv_cc 
   (	pk_neg_inv_cc numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	s_neg_inv_cc numeric(8,0) not null , 
	s_cc_neg_inv numeric(8,0) not null , 
	neg_val float
   ) ;
   
   
-- coswin.po_cc_int definition
IF OBJECT_ID(N'dbo.cswn_po_cc_int', N'U') IS NULL
create table cswn_po_cc_int 
   (	pk_po_cc_int numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	s_cc_po_int numeric(8,0) not null , 
	s_poi_cc_int numeric(8,0), 
	s_po_cc_int numeric(8,0), 
	po_cc_ref varchar(2), 
	po_cc_p float, 
	po_cc_val float, 
	po_cc_inv float, 
	po_cc_rct float
	) ;

-- coswin.preq_cc_int definition
IF OBJECT_ID(N'dbo.cswn_preq_cc_int', N'U') IS NULL
create table cswn_preq_cc_int 
   (	pk_preq_cc_int numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	s_pri_cc_int numeric(8,0) not null , 
	s_cc_pri_int numeric(8,0) not null , 
	preq_cc_ref varchar(2), 
	preq_cc_p float
   ) ;

-- coswin.pr_po_int definition
IF OBJECT_ID(N'dbo.cswn_pr_po_int', N'U') IS NULL
create table cswn_pr_po_int 
   (	pk_pr_po_int numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	s_pr_po_int numeric(8,0) not null , 
	s_po_pr_int numeric(8,0) not null , 
	pr_po_qty float
   );
   

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0806_Others_MasterTables6_pre;
drop procedure if exists ste_0711_Others_TransactionTables6_pre;
GO

CREATE PROCEDURE ste_0711_Others_TransactionTables6_pre
	@PackageLogID INT
AS
BEGIN
	-- truncate existing data
	truncate table cswn_item_ptd;
	truncate table cswn_item_srl;
	truncate table cswn_i_consp_qty;
	truncate table cswn_inv_rct;
	truncate table cswn_m_washhist;
	truncate table cswn_neg_inv;
	truncate table cswn_neg_inv_cc;
	truncate table cswn_po_cc_int;
	truncate table cswn_preq_cc_int;
	truncate table cswn_pr_po_int;


END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0806_Others_MasterTables6_post;
drop procedure if exists ste_0711_Others_TransactionTables6_post;
GO

CREATE PROCEDURE ste_0711_Others_TransactionTables6_post
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
	select @v_start_id=min(pk_m_washhist), @v_end_id=max(pk_m_washhist), @v_cnt=count(pk_m_washhist) from cswn_m_washhist;

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
		, 'm_washhist'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_inv_rct), @v_end_id=max(pk_inv_rct), @v_cnt=count(pk_inv_rct) from cswn_inv_rct;

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
		, 'inv_rct'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_item_ptd), @v_end_id=max(pk_item_ptd), @v_cnt=count(pk_item_ptd) from cswn_item_ptd;

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

	select @v_start_id=min(pk_item_srl), @v_end_id=max(pk_item_srl), @v_cnt=count(pk_item_srl) from cswn_item_srl;

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
		, 'item_srl'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(commonkey), @v_end_id=max(commonkey), @v_cnt=count(commonkey) from cswn_i_consp_qty;

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
		, 'i_consp_qty'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_neg_inv), @v_end_id=max(pk_neg_inv), @v_cnt=count(pk_neg_inv) from cswn_neg_inv;

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
		, 'neg_inv'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_neg_inv_cc), @v_end_id=max(pk_neg_inv_cc), @v_cnt=count(pk_neg_inv_cc) from cswn_neg_inv_cc;

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
		, 'neg_inv_cc'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_po_cc_int), @v_end_id=max(pk_po_cc_int), @v_cnt=count(pk_po_cc_int) from cswn_po_cc_int;

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
		, 'po_cc_int'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_preq_cc_int), @v_end_id=max(pk_preq_cc_int), @v_cnt=count(pk_preq_cc_int) from cswn_preq_cc_int;

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
		, 'preq_cc_int'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_pr_po_int), @v_end_id=max(pk_pr_po_int), @v_cnt=count(pk_pr_po_int) from cswn_pr_po_int;

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
		, 'pr_po_int'
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
           ('0711_Others_TransactionTables6'
           ,'version'
           ,'1'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO