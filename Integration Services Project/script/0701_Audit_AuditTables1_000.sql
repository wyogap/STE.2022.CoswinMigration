/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- coswin.audit_alt_items definition
IF OBJECT_ID(N'dbo.cswn_audit_alt_items', N'U') IS NULL
create table cswn_audit_alt_items 
   (	pk_value bigint, 
	username varchar(30), 
	modificationdate date, 
	operation numeric(5,0), 
	status varchar(6), 
	details varchar(4000)
   ) ;
  
-- coswin.audit_batch_ definition
IF OBJECT_ID(N'dbo.cswn_audit_batch_', N'U') IS NULL
create table cswn_audit_batch_ 
   (	pk_value bigint, 
	username varchar(30), 
	modificationdate date, 
	operation numeric(5,0), 
	status varchar(6), 
	details varchar(4000)
   );

-- coswin.audit_count_ definition
IF OBJECT_ID(N'dbo.cswn_audit_count_', N'U') IS NULL
create table cswn_audit_count_ 
   (	pk_value bigint, 
	username varchar(30), 
	modificationdate date, 
	operation numeric(5,0), 
	status varchar(6), 
	details varchar(4000)
   ) ;

-- coswin.audit_dem_iss definition
IF OBJECT_ID(N'dbo.cswn_audit_dem_iss', N'U') IS NULL
create table cswn_audit_dem_iss 
   (	pk_value bigint, 
	username varchar(30), 
	modificationdate date, 
	operation numeric(5,0), 
	status varchar(6), 
	details varchar(4000)
   ) ;

-- coswin.audit_dem_items definition
IF OBJECT_ID(N'dbo.cswn_audit_dem_items', N'U') IS NULL
create table cswn_audit_dem_items 
   (	pk_value bigint, 
	username varchar(30), 
	modificationdate date, 
	operation numeric(5,0), 
	status varchar(6), 
	details varchar(4000)
   ) ;

-- coswin.audit_devis definition
IF OBJECT_ID(N'dbo.cswn_audit_devis', N'U') IS NULL
create table cswn_audit_devis 
   (	pk_value bigint, 
	username varchar(30), 
	modificationdate date, 
	operation numeric(5,0), 
	status varchar(6), 
	details varchar(4000)
   ) ;
   
-- coswin.audit_dv_items definition
IF OBJECT_ID(N'dbo.cswn_audit_dv_items', N'U') IS NULL
create table cswn_audit_dv_items 
   (	pk_value bigint, 
	username varchar(30), 
	modificationdate date, 
	operation numeric(5,0), 
	status varchar(6), 
	details varchar(4000)
   ) ;

-- coswin.audit_eqp_defr definition
IF OBJECT_ID(N'dbo.cswn_audit_eqp_defr', N'U') IS NULL
create table cswn_audit_eqp_defr 
   (	pk_value bigint, 
	username varchar(30), 
	modificationdate date, 
	operation numeric(5,0), 
	status varchar(6), 
	details varchar(4000)
   ) ;

-- coswin.audit_eqp_group definition
IF OBJECT_ID(N'dbo.cswn_audit_eqp_group', N'U') IS NULL
create table cswn_audit_eqp_group 
   (	pk_value bigint, 
	username varchar(30), 
	modificationdate date, 
	operation numeric(5,0), 
	status varchar(6), 
	details varchar(4000)
   ) ;
   
-- coswin.audit_eqp_jobr definition
IF OBJECT_ID(N'dbo.cswn_audit_eqp_jobr', N'U') IS NULL
create table cswn_audit_eqp_jobr 
   (	pk_value bigint, 
	username varchar(30), 
	modificationdate date, 
	operation numeric(5,0), 
	status varchar(6), 
	details varchar(4000)
   );


-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0701_Audit_AuditTables1_pre
GO

CREATE PROCEDURE ste_0701_Audit_AuditTables1_pre 
	@PackageLogID INT
AS
BEGIN
	-- truncate existing data
	truncate table cswn_audit_alt_items;
	truncate table cswn_audit_batch_;
	truncate table cswn_audit_count_;
	truncate table cswn_audit_dem_iss;
	truncate table cswn_audit_dem_items;
	truncate table cswn_audit_devis;
	truncate table cswn_audit_dv_items;
	truncate table cswn_audit_eqp_defr;
	truncate table cswn_audit_eqp_group;
	truncate table cswn_audit_eqp_jobr;

END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0701_Audit_AuditTables1_post
GO

CREATE PROCEDURE ste_0701_Audit_AuditTables1_post
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
	select @v_start_id=min(pk_value), @v_end_id=max(pk_value), @v_cnt=count(pk_value) from cswn_audit_alt_items;

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
		, 'audit_alt_items'
		, 'LOG'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_value), @v_end_id=max(pk_value), @v_cnt=count(pk_value) from cswn_audit_batch_;

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
		, 'audit_batch_'
		, 'LOG'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_value), @v_end_id=max(pk_value), @v_cnt=count(pk_value) from cswn_audit_count_;

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
		, 'audit_count_'
		, 'LOG'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_value), @v_end_id=max(pk_value), @v_cnt=count(pk_value) from cswn_audit_dem_iss;

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
		, 'audit_dem_iss'
		, 'LOG'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_value), @v_end_id=max(pk_value), @v_cnt=count(pk_value) from cswn_audit_dem_items;

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
		, 'audit_dem_items'
		, 'LOG'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_value), @v_end_id=max(pk_value), @v_cnt=count(pk_value) from cswn_audit_devis;

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
		, 'audit_devis'
		, 'LOG'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_value), @v_end_id=max(pk_value), @v_cnt=count(pk_value) from cswn_audit_dv_items;

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
		, 'audit_dv_items'
		, 'LOG'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_value), @v_end_id=max(pk_value), @v_cnt=count(pk_value) from cswn_audit_eqp_defr;

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
		, 'audit_eqp_defr'
		, 'LOG'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_value), @v_end_id=max(pk_value), @v_cnt=count(pk_value) from cswn_audit_eqp_group;

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
		, 'audit_eqp_group'
		, 'LOG'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_value), @v_end_id=max(pk_value), @v_cnt=count(pk_value) from cswn_audit_eqp_jobr;

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
		, 'audit_eqp_jobr'
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
           ('0701_Audit_AuditTables1'
           ,'version'
           ,'1'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO