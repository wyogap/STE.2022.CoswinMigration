/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- coswin.dv_cc_int definition
IF OBJECT_ID(N'dbo.cswn_dv_cc_int', N'U') IS NULL
create table cswn_dv_cc_int 
   (	pk_dv_cc_int numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	s_dvi_cc_int numeric(8,0) not null , 
	s_cc_dvi_int numeric(8,0) not null , 
	dv_cc_ref varchar(2), 
	dv_cc_p float
   ); 

-- NOTE: EQP_JOBS is migrated as JOBPLAN
---- coswin.eqp_jobs definition
--IF OBJECT_ID(N'dbo.cswn_eqp_jobs', N'U') IS NULL
--create table cswn_eqp_jobs 
--   (	pk_eqp_jobs numeric(8,0), 
--	timestamp numeric(10,0) not null , 
--	eq_ej_17 numeric(8,0) not null , 
--	jd_ej_18 numeric(8,0) not null , 
--	ej_ej_57 numeric(8,0), 
--	ej_job_id varchar(16) not null , 
--	ej_prty numeric(5,0), 
--	ej_durn numeric(5,0), 
--	ej_du_unit numeric(3,0), 
--	ej_jbtyu varchar(6) not null , 
--	ej_jbbhu numeric(3,0), 
--	ej_supv varchar(6), 
--	ej_cosc varchar(16) not null , 
--	ej_avprtm numeric(5,0), 
--	ej_miprtm numeric(5,0), 
--	ej_mxprtm numeric(5,0), 
--	ej_efprtm numeric(5,0), 
--	ej_pr_unit numeric(3,0), 
--	ej_mtid varchar(16), 
--	ej_mtprml float, 
--	ej_ljml float, 
--	ej_ljdts numeric(10,0), 
--	ej_ljdtf numeric(10,0), 
--	ej_woid numeric(10,0), 
--	ej_njdt numeric(10,0), 
--	ej_njdd numeric(5,0), 
--	ej_njwk numeric(5,0), 
--	ej_njyr numeric(5,0), 
--	ej_njml float, 
--	ej_defl numeric(3,0), 
--	ej_dn_time float, 
--	ej_dn_unit numeric(3,0), 
--	ej_con_ref varchar(10), 
--	ej_prj_ref varchar(10), 
--	ej_kit_ref varchar(10), 
--	ej_tot_labh float, 
--	ej_shid numeric(5,0), 
--	ej_day numeric(5,0), 
--	ej_nextjb numeric(3,0), 
--	ej_mis_count numeric(5,0), 
--	ej_stwk numeric(5,0), 
--	ej_enwk numeric(5,0), 
--	ej_vlww numeric(5,0), 
--	ej_vlyy numeric(5,0), 
--	ej_mask numeric(3,0), 
--	ej_ludt numeric(10,0), 
--	ej_nowo numeric(5,0), 
--	ej_mndurn numeric(5,0), 
--	ej_lab_scost float, 
--	ej_mat_scost float, 
--	ej_woiex_fl numeric(3,0), 
--	ej_jbclu varchar(6), 
--	ej_work_days numeric(3,0), 
--	ej_mult numeric(5,0), 
--	ej_numeber1 float, 
--	ej_numeber2 float, 
--	ej_date1 numeric(10,0), 
--	ej_string1 varchar(20), 
--	ej_string2 varchar(20), 
--	ej_hazard numeric(5,0) default 0, 
--	ej_priority varchar(10), 
--	ej_wp_type varchar(10), 
--	ej_lmadt numeric(10,0), 
--	ej_lma numeric(3,0), 
--	pref_shift varchar(10), 
--	ej_fm_cost float
--   ) ;
   

-- coswin.he_det definition
IF OBJECT_ID(N'dbo.cswn_he_det', N'U') IS NULL
create table cswn_he_det 
   (	pk_he_det numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	he_det_30 numeric(8,0)  not null , 
	idx_he_det_30 numeric(10,0)  not null , 
	he_det_date numeric(10,0), 
	he_det_hours float, 
	he_det_shid numeric(5,0), 
	he_det_ontime numeric(10,0), 
	he_det_oftime numeric(10,0), 
	he_det_rateid numeric(10,0)
   );

-- coswin.his_ae definition
IF OBJECT_ID(N'dbo.cswn_his_ae', N'U') IS NULL
create table cswn_his_ae 
   (	pk_his_ae numeric(8,0), 
	timestamp numeric(10,0) default 1  not null , 
	s_ha_he numeric(8,0)  not null , 
	idx_s_ha_he numeric(10,0) not null , 
	s_he_ha numeric(8,0)  not null , 
	idx_s_he_ha numeric(10,0)  not null , 
	hae_wkhr float 
   ) ;
   
   
-- coswin.his_ha definition
IF OBJECT_ID(N'dbo.cswn_his_ha', N'U') IS NULL
create table cswn_his_ha 
   (	pk_his_ha numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	s_ho_ha numeric(8,0) not null , 
	ha_no1 numeric(5,0) not null , 
	ha_act varchar(10), 
	ha_act_desc varchar(100), 
	ha_exec_status numeric(5,0), 
	ha_dt numeric(10,0), 
	ha_durn float, 
	ha_wo_gen numeric(10,0), 
	ha_multiple numeric(5,0), 
	ha_planned numeric(5,0), 
	ha_eqcd1 varchar(20), 
	ha_elem1 varchar(40), 
	ha_val1 float, 
	ha_val2 float, 
	ha_op_type1 varchar(20), 
	ha_device1 varchar(20), 
	ha_eqp_stat varchar(20), 
	ha_unit1 varchar(6), 
	ha_unit2 varchar(6)
   ) ;

-- coswin.his_hd definition
IF OBJECT_ID(N'dbo.cswn_his_hd', N'U') IS NULL
create table cswn_his_hd 
   (	pk_his_hd numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	ho_hd_79 numeric(8,0) not null , 
	idx_ho_hd_79 numeric(10,0) not null , 
	hd_sycd varchar(10), 
	hd_dfcd varchar(10), 
	hd_cacd varchar(10), 
	hd_accd varchar(10), 
	hd_rep_dt numeric(10,0), 
	hd_rep_tm numeric(10,0), 
	hd_repdd numeric(5,0), 
	hd_repwk numeric(5,0), 
	hd_repyr numeric(5,0), 
	hd_durt float, 
	hd_woid numeric(10,0), 
	hd_rep_ml float, 
	hd_tot_cost float
   );
   
   
-- coswin.his_he definition
IF OBJECT_ID(N'dbo.cswn_his_he', N'U') IS NULL
create table cswn_his_he 
   (	pk_his_he numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	ho_he_71 numeric(8,0) not null , 
	he_emno varchar(10) not null , 
	he_frdt numeric(10,0), 
	he_todt numeric(10,0), 
	he_tohr float, 
	he_shid numeric(5,0), 
	he_cc varchar(16), 
	he_numeric1 float, 
	he_string1 varchar(20)
   ) ;
   
-- coswin.his_ho definition
IF OBJECT_ID(N'dbo.cswn_his_ho', N'U') IS NULL
create table cswn_his_ho 
   (	pk_his_ho numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	ho_dummy numeric(3,0), 
	ho_woid numeric(10,0) not null , 
	ho_fnyy numeric(5,0), 
	ho_plid numeric(5,0), 
	ho_eqcd varchar(20), 
	ho_sycd varchar(20), 
	ho_zone varchar(10), 
	ho_unit varchar(10), 
	ho_cosc varchar(16), 
	ho_eqlevl numeric(5,0), 
	ho_eq_phon varchar(13), 
	ho_job_id varchar(16), 
	ho_jbtyu varchar(6), 
	ho_jbclu varchar(6), 
	ho_sup_cd varchar(6), 
	ho_rep_by varchar(20), 
	ho_rep_ph varchar(15), 
	ho_reqno varchar(10), 
	ho_con_ref varchar(10), 
	ho_prj_ref varchar(10), 
	ho_durn numeric(5,0), 
	ho_shid numeric(5,0), 
	ho_nextjb numeric(3,0), 
	ho_pr1_time numeric(3,0), 
	ho_pr2_time numeric(3,0), 
	ho_puo_fl numeric(3,0), 
	ho_onf_fl numeric(3,0), 
	ho_iex_fl numeric(3,0), 
	ho_tpty numeric(5,0), 
	ho_hist numeric(3,0), 
	ho_wostu numeric(3,0), 
	ho_wostx numeric(3,0), 
	ho_dlfl numeric(3,0), 
	ho_prfl numeric(3,0), 
	ho_prnt numeric(5,0), 
	ho_p1fl numeric(3,0), 
	ho_p2fl numeric(3,0), 
	ho_p3fl numeric(3,0), 
	ho_p4fl numeric(3,0), 
	ho_du1_dt numeric(10,0), 
	ho_sch_dt numeric(10,0), 
	ho_schdd numeric(5,0), 
	ho_schwk numeric(5,0), 
	ho_schyr numeric(5,0), 
	ho_iss_dt numeric(10,0), 
	ho_rep_dt numeric(10,0), 
	ho_rep_tm numeric(10,0), 
	ho_str_dt numeric(10,0), 
	ho_str_tm numeric(10,0), 
	ho_fin_dt numeric(10,0), 
	ho_fin_tm numeric(10,0), 
	ho_findd numeric(5,0), 
	ho_finwk numeric(5,0), 
	ho_finyr numeric(5,0), 
	ho_lup_dt numeric(10,0), 
	ho_lab_scost float, 
	ho_mat_scost float, 
	ho_lab_acost float, 
	ho_mat_acost float, 
	ho_msc_acost float, 
	ho_rec_acost float, 
	ho_pln_hrs float, 
	ho_act_hrs float, 
	ho_res_time float, 
	ho_dn_time float, 
	ho_pr_loss float, 
	ho_jbml float, 
	ho_tot_cum_unts float, 
	ho_job_ds varchar(105), 
	ho_loct varchar(16), 
	prev_ho_woid numeric(10,0), 
	ho_eqp_srl varchar(24), 
	ho_for_rep numeric(5,0), 
	ho_spec_value float, 
	ho_new_srl_no varchar(24), 
	ho_number1 float, 
	ho_number2 float, 
	ho_date1 numeric(10,0), 
	ho_date2 numeric(10,0), 
	ho_string1 varchar(20), 
	ho_string2 varchar(20), 
	ho_string3 varchar(20), 
	ho_priority varchar(10), 
	ho_target_dt numeric(10,0), 
	ho_work_permit varchar(10), 
	ho_safety_involved numeric(5,0) default 0, 
	ho_time1 numeric(10,0) default 0, 
	ho_time2 numeric(10,0) default 0, 
	ho_fm_acost float, 
	ho_fm_scost float, 
	ho_allocated_emp numeric(3,0) default 0, 
	ho_action_auth varchar(16), 
	ho_request_auth varchar(16), 
	ho_criticality numeric(5,0), 
	ho_allocationstatus numeric(5,0)
   ) ;
   
   
-- coswin.his_hs definition
IF OBJECT_ID(N'dbo.cswn_his_hs', N'U') IS NULL
create table cswn_his_hs 
   (	pk_his_hs numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	ho_hs_78 numeric(8,0) not null , 
	s_ha_hs1 numeric(8,0), 
	hs_itcd varchar(20) not null , 
	hs_req_qt float, 
	hs_use_qt float, 
	hs_mat_acost float, 
	hs_stfl numeric(3,0), 
	hs_seq_no numeric(5,0) not null , 
	hs_tot_req_qt float, 
	hs_tot_use_qty float, 
	hs_tot_mat_acost float, 
	hs_repl_flag numeric(3,0), 
	hs_date1 numeric(10,0) default 0, 
	hs_string1 varchar(20)
   ) ;



-- coswin.his_ht definition
IF OBJECT_ID(N'dbo.cswn_his_ht', N'U') IS NULL
create table cswn_his_ht 
   (	pk_his_ht numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	ho_ht_74 numeric(8,0) not null , 
	s_ha_ht numeric(8,0), 
	ht_tdcd varchar(10) not null , 
	ht_req_no numeric(5,0), 
	ht_str_day numeric(5,0), 
	ht_plhr float, 
	ht_wkhr float, 
	ht_rmhr float, 
	ht_lab_acost float, 
	ht_ludt numeric(10,0), 
	ht_res_type numeric(3,0), 
	ht_seq_no numeric(5,0) not null , 
	ht_glb_plhr float, 
	ht_tot_lab_acost float, 
	ht_tot_wkhr float 
	); 

-- Moved from 0713_Others_TransactionTables8
-- coswin.tr_items definition
IF OBJECT_ID(N'dbo.cswn_tr_items', N'U') IS NULL
create table cswn_tr_items 
   (	pk_tr_items numeric(8,0), 
	timestamp numeric(10,0) default 1 not null , 
	s_item_tr numeric(8,0) not null , 
	s_loc_src numeric(8,0), 
	s_loc_trg numeric(8,0), 
	s_tr_item numeric(8,0) not null , 
	tr_qty float, 
	tr_value float 
   ) ;

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0804_Others_MasterTables4_pre;
drop procedure if exists ste_0709_Others_TransactionTables4_pre;
GO

CREATE PROCEDURE ste_0709_Others_TransactionTables4_pre
	@PackageLogID INT
AS
BEGIN
	-- truncate existing data
	truncate table cswn_dv_cc_int;
	--truncate table cswn_eqp_jobs;
	truncate table cswn_he_det;
	truncate table cswn_his_ae;
	truncate table cswn_his_ha;
	truncate table cswn_his_hd;
	truncate table cswn_his_he;
	truncate table cswn_his_ht;
	truncate table cswn_his_ho;
	truncate table cswn_his_hs;
	truncate table cswn_tr_items;

END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0804_Others_MasterTables4_post;
drop procedure if exists ste_0709_Others_TransactionTables4_post;
GO

CREATE PROCEDURE ste_0709_Others_TransactionTables4_post
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
	select @v_start_id=min(pk_dv_cc_int), @v_end_id=max(pk_dv_cc_int), @v_cnt=count(pk_dv_cc_int) from cswn_dv_cc_int;

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
		, 'dv_cc_int'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	--select @v_start_id=min(pk_eqp_jobs), @v_end_id=max(pk_eqp_jobs), @v_cnt=count(pk_eqp_jobs) from cswn_eqp_jobs;

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
	--	, 'eqp_jobs'
	--	, 'COMPLETED'
	--	, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	--);

	select @v_start_id=min(pk_he_det), @v_end_id=max(pk_he_det), @v_cnt=count(pk_he_det) from cswn_he_det;

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
		, 'he_det'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_his_ae), @v_end_id=max(pk_his_ae), @v_cnt=count(pk_his_ae) from cswn_his_ae;

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
		, 'his_ae'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_his_ha), @v_end_id=max(pk_his_ha), @v_cnt=count(pk_his_ha) from cswn_his_ha;

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
		, 'his_ha'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_his_hd), @v_end_id=max(pk_his_hd), @v_cnt=count(pk_his_hd) from cswn_his_hd;

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
		, 'his_hd'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_his_he), @v_end_id=max(pk_his_he), @v_cnt=count(pk_his_he) from cswn_his_he;

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
		, 'his_he'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_his_ho), @v_end_id=max(pk_his_ho), @v_cnt=count(pk_his_ho) from cswn_his_ho;

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
		, 'his_ho'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_his_hs), @v_end_id=max(pk_his_hs), @v_cnt=count(pk_his_hs) from cswn_his_hs;

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
		, 'his_hs'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_his_ht), @v_end_id=max(pk_his_ht), @v_cnt=count(pk_his_ht) from cswn_his_ht;

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
		, 'his_ht'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	select @v_start_id=min(pk_tr_items), @v_end_id=max(pk_tr_items), @v_cnt=count(pk_tr_items) from cswn_tr_items;

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
		, 'tr_items'
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
           ('0709_Others_TransactionTables4'
           ,'version'
           ,'1'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO