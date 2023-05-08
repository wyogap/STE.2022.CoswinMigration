/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/

-- coswin.audit_eqp_jobs definition
IF OBJECT_ID(N'dbo.cswn_audit_eqp_jobs', N'U') IS NULL
create table cswn_audit_eqp_jobs 
   (	pk_value bigint, 
	username varchar(30), 
	modificationdate date, 
	operation numeric(5,0), 
	status varchar(6), 
	details varchar(4000)
   ) ;


-- coswin.audit_eqp_move definition
IF OBJECT_ID(N'dbo.cswn_audit_eqp_move', N'U') IS NULL
create table cswn_audit_eqp_move 
   (	pk_value bigint, 
	username varchar(30), 
	modificationdate date, 
	operation numeric(5,0), 
	status varchar(6), 
	details varchar(4000)
   ) ;

-- coswin.audit_eqp_srl definition
IF OBJECT_ID(N'dbo.cswn_audit_eqp_srl', N'U') IS NULL
create table cswn_audit_eqp_srl 
   (	pk_value bigint, 
	username varchar(30), 
	modificationdate date, 
	operation numeric(5,0), 
	status varchar(6), 
	details varchar(4000)
   ) ;
   
-- coswin.audit_eqp_topo definition
IF OBJECT_ID(N'dbo.cswn_audit_eqp_topo', N'U') IS NULL
create table cswn_audit_eqp_topo 
   (	pk_value bigint, 
	username varchar(30), 
	modificationdate date, 
	operation numeric(5,0), 
	status varchar(6), 
	details varchar(4000)
   ) ;

-- coswin.audit_his_ho definition
IF OBJECT_ID(N'dbo.cswn_audit_his_ho', N'U') IS NULL
create table cswn_audit_his_ho 
   (	pk_value bigint, 
	username varchar(30), 
	modificationdate date, 
	operation numeric(5,0), 
	status varchar(6), 
	details varchar(4000)
   ) ;


-- coswin.audit_invoice_ definition
IF OBJECT_ID(N'dbo.cswn_audit_invoice_', N'U') IS NULL
create table cswn_audit_invoice_ 
   (	pk_value bigint, 
	username varchar(30), 
	modificationdate date, 
	operation numeric(5,0), 
	status varchar(6), 
	details varchar(4000)
   ) ;


-- coswin.audit_inv_items definition
IF OBJECT_ID(N'dbo.cswn_audit_inv_items', N'U') IS NULL
create table cswn_audit_inv_items 
   (	pk_value bigint, 
	username varchar(30), 
	modificationdate date, 
	operation numeric(5,0), 
	status varchar(6), 
	details varchar(4000)
   ) ;

-- coswin.audit_iss_items definition
IF OBJECT_ID(N'dbo.cswn_audit_iss_items', N'U') IS NULL
create table cswn_audit_iss_items 
   (	pk_value bigint, 
	username varchar(30), 
	modificationdate date, 
	operation numeric(5,0), 
	status varchar(6), 
	details varchar(4000)
   ) ;

-- coswin.audit_item_ definition
IF OBJECT_ID(N'dbo.cswn_audit_item_', N'U') IS NULL
create table cswn_audit_item_ 
   (	pk_value bigint, 
	username varchar(30), 
	modificationdate date, 
	operation numeric(5,0), 
	status varchar(6), 
	details varchar(4000)
   ) ;

-- coswin.audit_job_actn definition
IF OBJECT_ID(N'dbo.cswn_audit_job_actn', N'U') IS NULL
create table cswn_audit_job_actn 
   (	pk_value bigint, 
	username varchar(30), 
	modificationdate date, 
	operation numeric(5,0), 
	status varchar(20), 
	details varchar(4000)
   ) ;
   

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0702_Audit_AuditTables2_pre;
drop procedure if exists ste_0702_Others_AuditTables2_pre;
GO

CREATE PROCEDURE ste_0702_Others_AuditTables2_pre 
	@PackageLogID INT
AS
BEGIN
	-- truncate existing data
	truncate table cswn_audit_eqp_jobs;
	truncate table cswn_audit_eqp_move;
	truncate table cswn_audit_eqp_srl;
	truncate table cswn_audit_eqp_topo;
	truncate table cswn_audit_his_ho;
	truncate table cswn_audit_invoice_;
	truncate table cswn_audit_inv_items;
	truncate table cswn_audit_iss_items;
	truncate table cswn_audit_item_;
	truncate table cswn_audit_job_actn;

END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0702_Audit_AuditTables2_post;
drop procedure if exists ste_0702_Others_AuditTables2_post;
GO

CREATE PROCEDURE ste_0702_Others_AuditTables2_post
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
	select @v_start_id=min(pk_value), @v_end_id=max(pk_value), @v_cnt=count(pk_value) from cswn_audit_eqp_jobs;

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
		, 'audit_eqp_jobs'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_value), @v_end_id=max(pk_value), @v_cnt=count(pk_value) from cswn_audit_eqp_move;

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
		, 'audit_eqp_move'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_value), @v_end_id=max(pk_value), @v_cnt=count(pk_value) from cswn_audit_eqp_srl;

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
		, 'audit_eqp_srl'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_value), @v_end_id=max(pk_value), @v_cnt=count(pk_value) from cswn_audit_eqp_topo;

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
		, 'audit_eqp_topo'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_value), @v_end_id=max(pk_value), @v_cnt=count(pk_value) from cswn_audit_his_ho;

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
		, 'audit_his_ho'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_value), @v_end_id=max(pk_value), @v_cnt=count(pk_value) from cswn_audit_invoice_;

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
		, 'audit_invoice_'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_value), @v_end_id=max(pk_value), @v_cnt=count(pk_value) from cswn_audit_inv_items;

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
		, 'audit_inv_items'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_value), @v_end_id=max(pk_value), @v_cnt=count(pk_value) from cswn_audit_iss_items;

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
		, 'audit_iss_items'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_value), @v_end_id=max(pk_value), @v_cnt=count(pk_value) from cswn_audit_item_;

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
		, 'audit_item_'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_value), @v_end_id=max(pk_value), @v_cnt=count(pk_value) from cswn_audit_job_actn;

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
		, 'audit_job_actn'
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
           ('0702_Others_AuditTables2'
           ,'version'
           ,'1'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO