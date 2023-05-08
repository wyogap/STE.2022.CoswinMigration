/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- coswin.audit_job_catg_int definition
IF OBJECT_ID(N'dbo.cswn_audit_job_catg_int', N'U') IS NULL
create table cswn_audit_job_catg_int 
   (	pk_value bigint, 
	username varchar(30), 
	modificationdate date, 
	operation numeric(5,0), 
	status varchar(6), 
	details varchar(4000)
   ) ;

-- coswin.audit_job_dir definition
IF OBJECT_ID(N'dbo.cswn_audit_job_dir', N'U') IS NULL
create table cswn_audit_job_dir 
   (	pk_value bigint, 
	username varchar(30), 
	modificationdate date, 
	operation numeric(5,0), 
	status varchar(6), 
	details varchar(4000)
   ) ;

-- coswin.audit_job_manr definition
IF OBJECT_ID(N'dbo.cswn_audit_job_manr', N'U') IS NULL
create table cswn_audit_job_manr 
   (	pk_value bigint, 
	username varchar(30), 
	modificationdate date, 
	operation numeric(5,0), 
	status varchar(6), 
	details varchar(4000)
   ) ;

-- coswin.audit_job_stokr definition
IF OBJECT_ID(N'dbo.cswn_audit_job_stokr', N'U') IS NULL
create table cswn_audit_job_stokr 
   (	pk_value bigint, 
	username varchar(30), 
	modificationdate date, 
	operation numeric(5,0), 
	status varchar(6), 
	details varchar(4000)
   ) ;

-- coswin.audit_neg_inv definition
IF OBJECT_ID(N'dbo.cswn_audit_neg_inv', N'U') IS NULL
create table cswn_audit_neg_inv 
   (	pk_value bigint, 
	username varchar(30), 
	modificationdate date, 
	operation numeric(5,0), 
	status varchar(6), 
	details varchar(4000)
   ) ;

-- coswin.audit_neg_inv_cc definition
IF OBJECT_ID(N'dbo.cswn_audit_neg_inv_cc', N'U') IS NULL
create table cswn_audit_neg_inv_cc 
   (	pk_value bigint, 
	username varchar(30), 
	modificationdate date, 
	operation numeric(5,0), 
	status varchar(6), 
	details varchar(4000)
   ) ;

-- coswin.audit_plan_id definition
IF OBJECT_ID(N'dbo.cswn_audit_plan_id', N'U') IS NULL
create table cswn_audit_plan_id 
   (	pk_value bigint, 
	username varchar(30), 
	modificationdate date, 
	operation numeric(5,0), 
	status varchar(6), 
	details varchar(4000)
   ) ;
   
-- coswin.audit_plan_jobs definition
IF OBJECT_ID(N'dbo.cswn_audit_plan_jobs', N'U') IS NULL
create table cswn_audit_plan_jobs 
   (	pk_value bigint, 
	username varchar(30), 
	modificationdate date, 
	operation numeric(5,0), 
	status varchar(6), 
	details varchar(4000)
   ) ;

-- coswin.audit_porder_ definition
IF OBJECT_ID(N'dbo.cswn_audit_porder_', N'U') IS NULL
create table cswn_audit_porder_ 
   (	pk_value bigint, 
	username varchar(30), 
	modificationdate date, 
	operation numeric(5,0), 
	status varchar(6), 
	details varchar(4000)
   ) ;

-- coswin.audit_po_items definition
IF OBJECT_ID(N'dbo.cswn_audit_po_items', N'U') IS NULL
create table cswn_audit_po_items 
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

drop procedure if exists ste_0703_Audit_AuditTables3_pre;
drop procedure if exists ste_0703_Others_AuditTables3_pre;
GO

CREATE PROCEDURE ste_0703_Others_AuditTables3_pre 
	@PackageLogID INT
AS
BEGIN
	-- truncate existing data
	truncate table cswn_audit_job_catg_int;
	truncate table cswn_audit_job_dir;
	truncate table cswn_audit_job_manr;
	truncate table cswn_audit_job_stokr;
	truncate table cswn_audit_neg_inv;
	truncate table cswn_audit_neg_inv_cc;
	truncate table cswn_audit_plan_id;
	truncate table cswn_audit_plan_jobs;
	truncate table cswn_audit_porder_;
	truncate table cswn_audit_po_items;

END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0703_Audit_AuditTables3_post;
drop procedure if exists ste_0703_Others_AuditTables3_post;
GO

CREATE PROCEDURE ste_0703_Others_AuditTables3_post
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
	select @v_start_id=min(pk_value), @v_end_id=max(pk_value), @v_cnt=count(pk_value) from cswn_audit_job_catg_int;

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
		, 'audit_job_catg_int'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_value), @v_end_id=max(pk_value), @v_cnt=count(pk_value) from cswn_audit_job_dir;

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
		, 'audit_job_dir'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_value), @v_end_id=max(pk_value), @v_cnt=count(pk_value) from cswn_audit_job_manr;

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
		, 'audit_job_manr'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_value), @v_end_id=max(pk_value), @v_cnt=count(pk_value) from cswn_audit_job_stokr;

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
		, 'audit_job_stokr'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_value), @v_end_id=max(pk_value), @v_cnt=count(pk_value) from cswn_audit_neg_inv;

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
		, 'audit_neg_inv'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_value), @v_end_id=max(pk_value), @v_cnt=count(pk_value) from cswn_audit_neg_inv_cc;

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
		, 'audit_neg_inv_cc'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_value), @v_end_id=max(pk_value), @v_cnt=count(pk_value) from cswn_audit_plan_id;

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
		, 'audit_plan_id'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_value), @v_end_id=max(pk_value), @v_cnt=count(pk_value) from cswn_audit_plan_jobs;

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
		, 'audit_plan_jobs'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_value), @v_end_id=max(pk_value), @v_cnt=count(pk_value) from cswn_audit_porder_;

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
		, 'audit_porder_'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_value), @v_end_id=max(pk_value), @v_cnt=count(pk_value) from cswn_audit_po_items;

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
		, 'audit_po_items'
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
           ('0703_Others_AuditTables3'
           ,'version'
           ,'1'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO