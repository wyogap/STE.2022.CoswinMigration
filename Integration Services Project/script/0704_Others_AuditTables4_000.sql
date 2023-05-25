/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
   
-- coswin.audit_prequest definition
IF OBJECT_ID(N'dbo.cswn_audit_prequest', N'U') IS NULL
create table cswn_audit_prequest 
   (	pk_value bigint, 
	username varchar(30), 
	modificationdate date, 
	operation numeric(5,0), 
	status varchar(6), 
	details varchar(4000)
   ) ;

-- coswin.audit_pr_items definition
IF OBJECT_ID(N'dbo.cswn_audit_pr_items', N'U') IS NULL
create table cswn_audit_pr_items 
   (	pk_value bigint, 
	username varchar(30), 
	modificationdate date, 
	operation numeric(5,0), 
	status varchar(6), 
	details varchar(4000)
   ) ;

-- coswin.audit_rct_items definition
IF OBJECT_ID(N'dbo.cswn_audit_rct_items', N'U') IS NULL
create table cswn_audit_rct_items 
   (	pk_value bigint, 
	username varchar(30), 
	modificationdate date, 
	operation numeric(5,0), 
	status varchar(6), 
	details varchar(4000)
   ) ;

-- coswin.audit_receipt_ definition
IF OBJECT_ID(N'dbo.cswn_audit_receipt_', N'U') IS NULL
create table cswn_audit_receipt_ 
   (	pk_value bigint, 
	username varchar(30), 
	modificationdate date, 
	operation numeric(5,0), 
	status varchar(6), 
	details varchar(4000)
   ) ;  

-- coswin.audit_stk_adj definition
IF OBJECT_ID(N'dbo.cswn_audit_stk_adj', N'U') IS NULL
create table cswn_audit_stk_adj 
   (	pk_value bigint, 
	username varchar(30), 
	modificationdate date, 
	operation numeric(5,0), 
	status varchar(6), 
	details varchar(4000)
   ) ;

-- coswin.audit_stores_items definition
IF OBJECT_ID(N'dbo.cswn_audit_stores_items', N'U') IS NULL
create table cswn_audit_stores_items 
   (	pk_value bigint, 
	username varchar(30), 
	modificationdate date, 
	operation numeric(5,0), 
	status varchar(6), 
	details varchar(4000)
   ) ;

-- coswin.audit_supl_items definition
IF OBJECT_ID(N'dbo.cswn_audit_supl_items', N'U') IS NULL
create table cswn_audit_supl_items 
   (	pk_value bigint, 
	username varchar(30), 
	modificationdate date, 
	operation numeric(5,0), 
	status varchar(6), 
	details varchar(4000)
   ) ;

-- coswin.audit_supplier_ definition
IF OBJECT_ID(N'dbo.cswn_audit_supplier_', N'U') IS NULL
create table cswn_audit_supplier_ 
   (	pk_value bigint, 
	username varchar(30), 
	modificationdate date, 
	operation numeric(5,0), 
	status varchar(6), 
	details varchar(4000)
   ) ;

-- coswin.audit_transfer_ definition
IF OBJECT_ID(N'dbo.cswn_audit_transfer_', N'U') IS NULL
create table cswn_audit_transfer_ 
   (	pk_value bigint, 
	username varchar(30), 
	modificationdate date, 
	operation numeric(5,0), 
	status varchar(6), 
	details varchar(4000)
   ) ;

-- coswin.audit_tr_items definition
IF OBJECT_ID(N'dbo.cswn_audit_tr_items', N'U') IS NULL
create table cswn_audit_tr_items 
   (	pk_value bigint, 
	username varchar(30), 
	modificationdate date, 
	operation numeric(5,0), 
	status varchar(6), 
	details varchar(4000)
   ) ;

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0704_Audit_AuditTables4_pre;
drop procedure if exists ste_0704_Others_AuditTables4_pre;
GO

CREATE PROCEDURE ste_0704_Others_AuditTables4_pre 
	@PackageLogID INT
AS
BEGIN
	-- truncate existing data
	truncate table cswn_audit_prequest;
	truncate table cswn_audit_pr_items;
	truncate table cswn_audit_rct_items;
	truncate table cswn_audit_receipt_;
	truncate table cswn_audit_stk_adj;
	truncate table cswn_audit_stores_items;
	truncate table cswn_audit_supl_items;
	truncate table cswn_audit_supplier_;
	truncate table cswn_audit_transfer_;
	truncate table cswn_audit_tr_items;

END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0704_Audit_AuditTables4_post;
drop procedure if exists ste_0704_Others_AuditTables4_post;
GO

CREATE PROCEDURE ste_0704_Others_AuditTables4_post
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
	select @v_start_id=min(pk_value), @v_end_id=max(pk_value), @v_cnt=count(pk_value) from cswn_audit_prequest;

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
		, 'audit_prequest'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_value), @v_end_id=max(pk_value), @v_cnt=count(pk_value) from cswn_audit_pr_items;

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
		, 'audit_pr_items'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_value), @v_end_id=max(pk_value), @v_cnt=count(pk_value) from cswn_audit_rct_items;

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
		, 'audit_rct_items'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_value), @v_end_id=max(pk_value), @v_cnt=count(pk_value) from cswn_audit_receipt_;

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
		, 'audit_receipt_'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_value), @v_end_id=max(pk_value), @v_cnt=count(pk_value) from cswn_audit_stk_adj;

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
		, 'audit_stk_adj'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_value), @v_end_id=max(pk_value), @v_cnt=count(pk_value) from cswn_audit_stores_items;

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
		, 'audit_stores_items'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_value), @v_end_id=max(pk_value), @v_cnt=count(pk_value) from cswn_audit_supl_items;

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
		, 'audit_supl_items'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_value), @v_end_id=max(pk_value), @v_cnt=count(pk_value) from cswn_audit_supplier_;

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
		, 'audit_supplier_'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_value), @v_end_id=max(pk_value), @v_cnt=count(pk_value) from cswn_audit_transfer_;

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
		, 'audit_transfer_'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_value), @v_end_id=max(pk_value), @v_cnt=count(pk_value) from cswn_audit_tr_items;

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
		, 'audit_tr_items'
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
           ('0704_Others_AuditTables4'
           ,'version'
           ,'1'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO