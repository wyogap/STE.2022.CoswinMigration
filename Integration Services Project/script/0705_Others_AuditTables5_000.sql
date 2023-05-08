/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/

-- coswin.audit_wip_wa definition
IF OBJECT_ID(N'dbo.cswn_audit_wip_wa', N'U') IS NULL
create table cswn_audit_wip_wa 
   (	pk_value bigint, 
	username varchar(30), 
	modificationdate date, 
	operation numeric(5,0), 
	status varchar(20), 
	details varchar(4000)
   ) ;

-- coswin.audit_wip_we definition
IF OBJECT_ID(N'dbo.cswn_audit_wip_we', N'U') IS NULL
create table cswn_audit_wip_we 
   (	pk_value bigint, 
	username varchar(30), 
	modificationdate date, 
	operation numeric(5,0), 
	status varchar(6), 
	details varchar(4000)
   ) ; 

-- coswin.audit_wip_wo definition
IF OBJECT_ID(N'dbo.cswn_audit_wip_wo', N'U') IS NULL
create table cswn_audit_wip_wo 
   (	pk_value bigint, 
	username varchar(30), 
	modificationdate date, 
	operation numeric(5,0), 
	status varchar(6), 
	details varchar(4000)
   )  ;

-- coswin.audit_wip_ws definition
IF OBJECT_ID(N'dbo.cswn_audit_wip_ws', N'U') IS NULL
create table cswn_audit_wip_ws 
   (	pk_value bigint, 
	username varchar(30), 
	modificationdate date, 
	operation numeric(5,0), 
	status varchar(6), 
	details varchar(4000)
   ) ;

-- coswin.audit_wip_wt definition
IF OBJECT_ID(N'dbo.cswn_audit_wip_wt', N'U') IS NULL
create table cswn_audit_wip_wt 
   (	pk_value bigint, 
	username varchar(30), 
	modificationdate date, 
	operation numeric(5,0), 
	status varchar(6), 
	details varchar(4000)
   ) ;
  
-- coswin.t_audit_t_lcc_cf_t definition
IF OBJECT_ID(N'dbo.cswn_t_audit_t_lcc_cf_t', N'U') IS NULL
create table cswn_t_audit_t_lcc_cf_t 
   (	pk_value bigint, 
	username varchar(30), 
	modificationdate date, 
	operation numeric(5,0), 
	status varchar(6), 
	details varchar(2000)
   ) ;

-- coswin.t_audit_t_lcc_mean_t definition
IF OBJECT_ID(N'dbo.cswn_t_audit_t_lcc_mean_t', N'U') IS NULL
create table cswn_t_audit_t_lcc_mean_t 
   (	pk_value bigint, 
	username varchar(30), 
	modificationdate date, 
	operation numeric(5,0), 
	status varchar(6), 
	details varchar(2000)
   ) ;

-- coswin.t_audit_t_lcc_mthly_t definition
IF OBJECT_ID(N'dbo.cswn_t_audit_t_lcc_mthly_t', N'U') IS NULL
create table cswn_t_audit_t_lcc_mthly_t 
   (	pk_value bigint, 
	username varchar(30), 
	modificationdate date, 
	operation numeric(5,0), 
	status varchar(6), 
	details varchar(2000)
   ) ;

-- coswin.t_audit_t_lcc_t definition
IF OBJECT_ID(N'dbo.cswn_t_audit_t_lcc_t', N'U') IS NULL
create table cswn_t_audit_t_lcc_t 
   (	pk_value bigint, 
	username varchar(30), 
	modificationdate date, 
	operation numeric(5,0), 
	status varchar(6), 
	details varchar(2000)
   ) ;


-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0705_Audit_AuditTables5_pre;
drop procedure if exists ste_0705_Others_AuditTables5_pre;
GO

CREATE PROCEDURE ste_0705_Others_AuditTables5_pre 
	@PackageLogID INT
AS
BEGIN
	-- truncate existing data
	truncate table cswn_audit_wip_wa;
	truncate table cswn_audit_wip_we;
	truncate table cswn_audit_wip_wo;
	truncate table cswn_audit_wip_ws;
	truncate table cswn_audit_wip_wt;
	truncate table cswn_t_audit_t_lcc_cf_t;
	truncate table cswn_t_audit_t_lcc_mean_t;
	truncate table cswn_t_audit_t_lcc_mthly_t;
	truncate table cswn_t_audit_t_lcc_t;
	--truncate table cswn_audit_tr_items;

END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0705_Audit_AuditTables5_post;
drop procedure if exists ste_0705_Others_AuditTables5_post;
GO

CREATE PROCEDURE ste_0705_Others_AuditTables5_post
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
	select @v_start_id=min(pk_value), @v_end_id=max(pk_value), @v_cnt=count(pk_value) from cswn_audit_wip_wa;

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
		, 'audit_wip_wa'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_value), @v_end_id=max(pk_value), @v_cnt=count(pk_value) from cswn_audit_wip_we;

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
		, 'audit_wip_we'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_value), @v_end_id=max(pk_value), @v_cnt=count(pk_value) from cswn_audit_wip_wo;

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
		, 'audit_wip_wo'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_value), @v_end_id=max(pk_value), @v_cnt=count(pk_value) from cswn_audit_wip_ws;

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
		, 'audit_wip_ws'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_value), @v_end_id=max(pk_value), @v_cnt=count(pk_value) from cswn_audit_wip_wt;

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
		, 'audit_wip_wt'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_value), @v_end_id=max(pk_value), @v_cnt=count(pk_value) from cswn_t_audit_t_lcc_cf_t;

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
		, 't_audit_t_lcc_cf_t'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_value), @v_end_id=max(pk_value), @v_cnt=count(pk_value) from cswn_t_audit_t_lcc_mean_t;

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
		, 't_audit_t_lcc_mean_t'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_value), @v_end_id=max(pk_value), @v_cnt=count(pk_value) from cswn_t_audit_t_lcc_mthly_t;

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
		, 't_audit_t_lcc_mthly_t'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_value), @v_end_id=max(pk_value), @v_cnt=count(pk_value) from cswn_t_audit_t_lcc_t;

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
		, 't_audit_t_lcc_t'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	--select @v_start_id=min(pk_value), @v_end_id=max(pk_value), @v_cnt=count(pk_value) from cswn_audit_tr_items;

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
	--	, 'audit_tr_items'
	--	, 'COMPLETED'
	--	, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	--);

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
           ('0705_Others_AuditTables5'
           ,'version'
           ,'1'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO