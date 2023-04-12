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


---- coswin.audit_dv_rmk definition
--IF OBJECT_ID(N'dbo.cswn_audit_dv_rmk', N'U') IS NULL
--create table cswn_audit_dv_rmk 
--   (	pk_value bigint, 
--	username varchar(30), 
--	modificationdate date, 
--	operation numeric(5,0), 
--	status varchar(6), 
--	details varchar(4000)
--   ) ;


---- coswin.audit_eqp_act definition
--IF OBJECT_ID(N'dbo.cswn_audit_eqp_act', N'U') IS NULL
--create table cswn_audit_eqp_act 
--   (	pk_value bigint, 
--	username varchar(30), 
--	modificationdate date, 
--	operation numeric(5,0), 
--	status varchar(6), 
--	details varchar(4000)
--   ) ;


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


---- coswin.audit_eqp_res definition
--IF OBJECT_ID(N'dbo.cswn_audit_eqp_res', N'U') IS NULL
--create table cswn_audit_eqp_res 
--   (	pk_value bigint, 
--	username varchar(30), 
--	modificationdate date, 
--	operation numeric(5,0), 
--	status varchar(6), 
--	details varchar(4000)
--   ) ;


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
   
---- coswin.audit_eqp_stock definition
--IF OBJECT_ID(N'dbo.cswn_audit_eqp_stock', N'U') IS NULL
--create table cswn_audit_eqp_stock 
--   (	pk_value bigint, 
--	username varchar(30), 
--	modificationdate date, 
--	operation numeric(5,0), 
--	status varchar(6), 
--	details varchar(4000)
--   ) ;


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


---- coswin.audit_inv_rmk definition
--IF OBJECT_ID(N'dbo.cswn_audit_inv_rmk', N'U') IS NULL
--create table cswn_audit_inv_rmk 
--   (	pk_value bigint, 
--	username varchar(30), 
--	modificationdate date, 
--	operation numeric(5,0), 
--	status varchar(6), 
--	details varchar(4000)
--   ) ;


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


---- coswin.audit_item_rmk definition
--IF OBJECT_ID(N'dbo.cswn_audit_item_rmk', N'U') IS NULL
--create table cswn_audit_item_rmk 
--   (	pk_value bigint, 
--	username varchar(30), 
--	modificationdate date, 
--	operation numeric(5,0), 
--	status varchar(6), 
--	details varchar(4000)
--   ) ;


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
   
  
---- coswin.audit_job_actv definition
--IF OBJECT_ID(N'dbo.cswn_audit_job_actv', N'U') IS NULL
--create table cswn_audit_job_actv 
--   (	pk_value bigint, 
--	username varchar(30), 
--	modificationdate date, 
--	operation numeric(5,0), 
--	status varchar(6), 
--	details varchar(4000)
--   ) ;


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


---- coswin.audit_linked_jobs definition
--IF OBJECT_ID(N'dbo.cswn_audit_linked_jobs', N'U') IS NULL
--create table cswn_audit_linked_jobs 
--   (	pk_value bigint, 
--	username varchar(30), 
--	modificationdate date, 
--	operation numeric(5,0), 
--	status varchar(6), 
--	details varchar(4000)
--   ) ;


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


---- coswin.audit_parent_eqp definition
--IF OBJECT_ID(N'dbo.cswn_audit_parent_eqp', N'U') IS NULL
--create table cswn_audit_parent_eqp 
--   (	pk_value bigint, 
--	username varchar(30), 
--	modificationdate date, 
--	operation numeric(5,0), 
--	status varchar(6), 
--	details varchar(4000)
--   ) ;


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


---- coswin.audit_po_rmk definition
--IF OBJECT_ID(N'dbo.cswn_audit_po_rmk', N'U') IS NULL
--create table cswn_audit_po_rmk 
--   (	pk_value bigint, 
--	username varchar(30), 
--	modificationdate date, 
--	operation numeric(5,0), 
--	status varchar(6), 
--	details varchar(4000)
--   ) ;


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


---- coswin.audit_pr_rmk definition
--IF OBJECT_ID(N'dbo.cswn_audit_pr_rmk', N'U') IS NULL
--create table cswn_audit_pr_rmk 
--   (	pk_value bigint, 
--	username varchar(30), 
--	modificationdate date, 
--	operation numeric(5,0), 
--	status varchar(6), 
--	details varchar(4000)
--   ) ;


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


---- coswin.audit_rct_rmk definition
--IF OBJECT_ID(N'dbo.cswn_audit_rct_rmk', N'U') IS NULL
--create table cswn_audit_rct_rmk 
--   (	pk_value bigint, 
--	username varchar(30), 
--	modificationdate date, 
--	operation numeric(5,0), 
--	status varchar(6), 
--	details varchar(4000)
--   ) ;


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
  
 
---- coswin.audit_reconcile_inv definition
--IF OBJECT_ID(N'dbo.cswn_audit_reconcile_inv', N'U') IS NULL
--create table cswn_audit_reconcile_inv 
--   (	pk_value bigint, 
--	username varchar(30), 
--	modificationdate date, 
--	operation numeric(5,0), 
--	status varchar(6), 
--	details varchar(4000)
--   ) ;


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


---- coswin.audit_supl_rmk definition
--IF OBJECT_ID(N'dbo.cswn_audit_supl_rmk', N'U') IS NULL
--create table cswn_audit_supl_rmk 
--   (	pk_value bigint, 
--	username varchar(30), 
--	modificationdate date, 
--	operation numeric(5,0), 
--	status varchar(6), 
--	details varchar(4000)
--   ) ;


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
  
 
---- coswin.audit_wip_wn definition
--IF OBJECT_ID(N'dbo.cswn_audit_wip_wn', N'U') IS NULL
--create table cswn_audit_wip_wn 
--   (	pk_value bigint, 
--	username varchar(30), 
--	modificationdate date, 
--	operation numeric(5,0), 
--	status varchar(6), 
--	details varchar(4000)
--   ) ;


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