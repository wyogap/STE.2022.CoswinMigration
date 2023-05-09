/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- coswin.ad_contact definition
IF OBJECT_ID(N'dbo.cswn_ad_contact', N'U') IS NULL
create table cswn_ad_contact 
   (	pk_ad_contact numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	uk_contact numeric(10,0) not null , 
	cnt_name varchar(40), 
	cnt_phone1 varchar(40), 
	cnt_phone2 varchar(40), 
	cnt_fax varchar(40), 
	cnt_email varchar(80), 
	cnt_telex varchar(40)
   ) ;


-- coswin.company definition
IF OBJECT_ID(N'dbo.cswn_company', N'U') IS NULL
create table cswn_company 
   (	pk_company numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	comp_code varchar(10), 
	comp_desc varchar(40)
   ) ;


-- coswin.costcentre_ definition
IF OBJECT_ID(N'dbo.cswn_costcentre_', N'U') IS NULL
create table cswn_costcentre_ 
   (	pk_costcentre_ numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	dt_costcentre numeric(10,0), 
	tm_costcentre numeric(10,0), 
	cc_cd varchar(16) not null , 
	cc_name varchar(100) 
   ) ;


-- coswin.adopted_pattern definition
IF OBJECT_ID(N'dbo.cswn_adopted_pattern', N'U') IS NULL
create table cswn_adopted_pattern 
   (	pk_adopted_pattern numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	s_compent_adp numeric(8,0) not null , 
	s_shp_adp numeric(8,0) not null , 
	adp_start numeric(10,0), 
	adp_end numeric(10,0), 
	adp_date numeric(10,0), 
	adp_inuse numeric(3,0)
   ) ;


-- coswin.alt_items definition
IF OBJECT_ID(N'dbo.cswn_alt_items', N'U') IS NULL
create table cswn_alt_items 
   (	pk_alt_items numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	s_item1_alt numeric(8,0) not null , 
	idx_s_item1_alt numeric(10,0) not null , 
	s_item2_alt numeric(8,0) not null
   ) ;


-- coswin.cl_data definition
IF OBJECT_ID(N'dbo.cswn_cl_data', N'U') IS NULL
create table cswn_cl_data 
   (	commonkey numeric(8,0) not null , 
	indx numeric(3,0) not null , 
	cl_wkhr numeric(5,0), 
	cl_sttm numeric(10,0)
   ) ;


-- coswin.dir_action definition
IF OBJECT_ID(N'dbo.cswn_dir_action', N'U') IS NULL
create table cswn_dir_action 
   (	pk_dir_action numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	act_code varchar(10) not null , 
	act_desc varchar(100), 
	act_ctg_cd varchar(6) not null , 
	act_elem varchar(40), 
	act_eqp_stat varchar(6), 
	act_device varchar(20), 
	act_op_type varchar(10), 
	act_pln_hrs float
   );


-- coswin.eqp_cldr definition
IF OBJECT_ID(N'dbo.cswn_eqp_cldr', N'U') IS NULL
create table cswn_eqp_cldr 
   (	pk_eqp_cldr numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	eq_cl_29 numeric(8,0), 
	sy_cl_91 numeric(8,0), 
	zn_cl_01 numeric(8,0), 
	un_cl_01 numeric(8,0), 
	cl_year numeric(5,0), 
	cl_wk1_no numeric(5,0), 
	cl_wk1_off numeric(5,0), 
	cl_dayi varchar(366)
   )  ;


-- coswin.eqp_note definition
IF OBJECT_ID(N'dbo.cswn_eqp_note', N'U') IS NULL
create table cswn_eqp_note 
   (	pk_eqp_note numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	ts_tn_03 numeric(8,0), 
	it_ts_01 numeric(8,0), 
	tn_code numeric(5,0) not null
	);


-- coswin.empl_shift definition
IF OBJECT_ID(N'dbo.cswn_empl_shift', N'U') IS NULL
	create table cswn_empl_shift 
   (	pk_empl_shift numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	s_empl_shift numeric(8,0) not null , 
	s_shift_empl numeric(8,0) not null , 
	es_index numeric(5,0)
   ); 


-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0714_Others_MasterTables1_pre
GO

CREATE PROCEDURE ste_0714_Others_MasterTables1_pre
	@PackageLogID INT
AS
BEGIN
	-- truncate existing data
	truncate table cswn_costcentre_;
	truncate table cswn_cl_data;
	truncate table cswn_eqp_cldr;
	truncate table cswn_eqp_note;
	truncate table cswn_adopted_pattern;
	truncate table cswn_ad_contact;
	truncate table cswn_alt_items;
	truncate table cswn_company;
	truncate table cswn_dir_action;
	truncate table cswn_empl_shift;


END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0714_Others_MasterTables1_post
GO

CREATE PROCEDURE ste_0714_Others_MasterTables1_post
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
	select @v_start_id=min(pk_ad_contact), @v_end_id=max(pk_ad_contact), @v_cnt=count(pk_ad_contact) from cswn_ad_contact;

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
		, 'ad_contact'
		, 'LOG'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_company), @v_end_id=max(pk_company), @v_cnt=count(pk_company) from cswn_company;

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
		, 'company'
		, 'LOG'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_costcentre_), @v_end_id=max(pk_costcentre_), @v_cnt=count(pk_costcentre_) from cswn_costcentre_;

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
		, 'costcentre_'
		, 'LOG'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_adopted_pattern), @v_end_id=max(pk_adopted_pattern), @v_cnt=count(pk_adopted_pattern) from cswn_adopted_pattern;

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
		, 'adopted_pattern'
		, 'LOG'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_alt_items), @v_end_id=max(pk_alt_items), @v_cnt=count(pk_alt_items) from cswn_alt_items;

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
		, 'alt_items'
		, 'LOG'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(commonkey), @v_end_id=max(commonkey), @v_cnt=count(commonkey) from cswn_cl_data;

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
		, 'cl_data'
		, 'LOG'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_dir_action), @v_end_id=max(pk_dir_action), @v_cnt=count(pk_dir_action) from cswn_dir_action;

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
		, 'dir_action'
		, 'LOG'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_eqp_cldr), @v_end_id=max(pk_eqp_cldr), @v_cnt=count(pk_eqp_cldr) from cswn_eqp_cldr;

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
		, 'eqp_cldr'
		, 'LOG'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_eqp_note), @v_end_id=max(pk_eqp_note), @v_cnt=count(pk_eqp_note) from cswn_eqp_note;

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
		, 'eqp_note'
		, 'LOG'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_empl_shift), @v_end_id=max(pk_empl_shift), @v_cnt=count(pk_empl_shift) from cswn_empl_shift;

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
		, 'empl_shift'
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
           ('0714_Others_MasterTables1'
           ,'version'
           ,'1'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO