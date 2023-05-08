/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- coswin.cc_lymon_val definition
IF OBJECT_ID(N'dbo.cswn_cc_lymon_val', N'U') IS NULL
create table cswn_cc_lymon_val 
	( commonkey numeric(8,0) not null, 
	indx numeric(3,0) not null, 
	cc_lymon_val float
	);

-- coswin.cswn_an_time definition
IF OBJECT_ID(N'dbo.cswn_an_time', N'U') IS NULL
create table cswn_an_time 
   (	commonkey numeric(8,0) not null , 
	indx numeric(3,0) not null , 
	an_lab_acost float, 
	an_mat_acost float, 
	an_msc_acost float, 
	an_nowo numeric(5,0), 
	an_dn_time float, 
	an_pr_loss float, 
	an_pln_hrs float, 
	an_act_hrs float, 
	an_ljobdt numeric(10,0), 
	an_fm_acost float
   );

-- coswin.cswn_cc_per definition
IF OBJECT_ID(N'dbo.cswn_cc_per', N'U') IS NULL
create table cswn_cc_per 
   (	commonkey numeric(8,0) not null , 
	indx numeric(3,0) not null , 
	cc_ptd_cd varchar(1), 
	cc_con_val float, 
	cc_inv_val float, 
	cc_bud_val float, 
	cc_rec_val float
   );


-- coswin.cswn_cc_per_val definition
IF OBJECT_ID(N'dbo.cswn_cc_per_val', N'U') IS NULL
create table cswn_cc_per_val 
   (	commonkey numeric(8,0) not null , 
	indx numeric(3,0) not null , 
	cc_ord_month float, 
	cc_inv_month float, 
	cc_cn_month float
   ) ;


-- coswin.cswn_cc_tymon_val definition
IF OBJECT_ID(N'dbo.cswn_cc_tymon_val', N'U') IS NULL
create table cswn_cc_tymon_val 
   (	commonkey numeric(8,0) not null , 
	indx numeric(3,0) not null , 
	cc_tymon_val float
   ) ;


-- coswin.cswn_dv_item_other definition
IF OBJECT_ID(N'dbo.cswn_dv_item_other', N'U') IS NULL
create table cswn_dv_item_other 
   (	commonkey numeric(8,0) not null , 
	indx numeric(3,0) not null , 
	dv_item_pcnt float, 
	dv_item_oth_chr float, 
	dv_item_parm_cd varchar(2), 
	dv_item_on numeric(3,0)
   ) ;


-- coswin.cswn_dv_other definition
IF OBJECT_ID(N'dbo.cswn_dv_other', N'U') IS NULL
create table cswn_dv_other 
   (	commonkey numeric(8,0) not null , 
	indx numeric(3,0) not null , 
	dv_pcnt float, 
	dv_oth_chr float, 
	dv_parm_cd varchar(2), 
	dv_on numeric(3,0)
   ) ;


-- coswin.cswn_eqp_anal definition
IF OBJECT_ID(N'dbo.cswn_eqp_anal', N'U') IS NULL
create table cswn_eqp_anal 
   (	pk_eqp_anal numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	zn_an_61 numeric(8,0), 
	un_an_62 numeric(8,0), 
	cc_an_63 numeric(8,0), 
	bc_an_64 numeric(8,0), 
	sc_an_65 numeric(8,0), 
	eq_an_66 numeric(8,0), 
	an_code numeric(3,0), 
	an_year numeric(5,0), 
	an_month numeric(5,0), 
	an_ludt numeric(10,0), 
	an_lutm numeric(10,0), 
	an_tresp_tm float, 
	an_ljdt numeric(10,0) not null
   ) ;


-- coswin.cswn_inv_item_other definition
IF OBJECT_ID(N'dbo.cswn_inv_item_other', N'U') IS NULL
create table cswn_inv_item_other 
   (	commonkey numeric(8,0) not null , 
	indx numeric(3,0) not null , 
	inv_item_pcnt float, 
	inv_item_oth_chr float, 
	inv_item_parm_cd varchar(2), 
	inv_item_on numeric(3,0)
   ) ;


-- coswin.cswn_inv_other definition
IF OBJECT_ID(N'dbo.cswn_inv_other', N'U') IS NULL
create table cswn_inv_other 
   (	commonkey numeric(8,0) not null , 
	indx numeric(3,0) not null , 
	inv_pcnt float, 
	inv_oth_chr float, 
	inv_parm_cd varchar(2), 
	inv_on numeric(3,0)
   ) ;

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0801_Others_MasterTables1_pre;
drop procedure if exists ste_0706_Others_TransactionTables1_pre;
GO

CREATE PROCEDURE ste_0706_Others_TransactionTables1_pre
	@PackageLogID INT
AS
BEGIN
	-- truncate existing data
	truncate table cswn_cc_lymon_val;
	truncate table cswn_an_time;
	truncate table cswn_cc_per;
	truncate table cswn_cc_per_val;
	truncate table cswn_cc_tymon_val;
	truncate table cswn_dv_item_other;
	truncate table cswn_dv_other;
	truncate table cswn_eqp_anal;
	truncate table cswn_inv_item_other;
	truncate table cswn_inv_other;

END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0801_Others_MasterTables1_post;
drop procedure if exists ste_0706_Others_TransactionTables1_post;
GO

CREATE PROCEDURE ste_0706_Others_TransactionTables1_post
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
	select @v_start_id=min(commonkey), @v_end_id=max(commonkey), @v_cnt=count(commonkey) from cswn_cc_lymon_val;

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
		, 'cc_lymon_val'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(commonkey), @v_end_id=max(commonkey), @v_cnt=count(commonkey) from cswn_an_time;

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
		, 'an_time'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(commonkey), @v_end_id=max(commonkey), @v_cnt=count(commonkey) from cswn_cc_per;

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
		, 'cc_per'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(commonkey), @v_end_id=max(commonkey), @v_cnt=count(commonkey) from cswn_cc_per_val;

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
		, 'cc_per_val'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(commonkey), @v_end_id=max(commonkey), @v_cnt=count(commonkey) from cswn_cc_tymon_val;

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
		, 'cc_tymon_val'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(commonkey), @v_end_id=max(commonkey), @v_cnt=count(commonkey) from cswn_dv_item_other;

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
		, 'dv_item_other'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(commonkey), @v_end_id=max(commonkey), @v_cnt=count(commonkey) from cswn_dv_other;

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
		, 'dv_other'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_eqp_anal), @v_end_id=max(pk_eqp_anal), @v_cnt=count(pk_eqp_anal) from cswn_eqp_anal;

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
		, 'eqp_anal'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(commonkey), @v_end_id=max(commonkey), @v_cnt=count(commonkey) from cswn_inv_item_other;

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
		, 'inv_item_other'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(commonkey), @v_end_id=max(commonkey), @v_cnt=count(commonkey) from cswn_inv_other;

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
		, 'inv_other'
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
           ('0706_Others_TransactionTables1'
           ,'version'
           ,'1'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO