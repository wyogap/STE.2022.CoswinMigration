IF OBJECT_ID(N'dbo.cswn_supplier_', N'U') IS NULL
create table cswn_supplier_ 
(
	pk_supplier_ numeric(8,0) not null
	,timestamp	numeric(10,0) default 1 not null	
	,s_date1	numeric	
	,s_number2	numeric		
	,s_number1	numeric	
	,norm_pay_days	numeric	
	,s_l_po_dt	numeric	
	,s_lyr_del_no	numeric	
	,s_td_del_no	numeric	
	,s_ytd_del_no	numeric	
	,s_lyr_rej_no	numeric	
	,s_tod_rej_no	numeric	
	,s_ytd_rej_no	numeric	
	,s_lyr_val_po	numeric	
	,s_tod_val_po	numeric	
	,s_ytd_val_po	numeric	
	,s_lyr_no_po	numeric	
	,s_tod_po_no	numeric	
	,s_ytd_po_no	numeric	
	,s_suspend	numeric	
	,crd_lmt	numeric	
	,tm_supplier	numeric	
	,dt_supplier	numeric	
	,com_no_1	varchar(20)
	,s_string2	varchar(20)
	,tech_no_1	varchar(20)
	,s_string1	varchar(20)
	,s_curr_cd	varchar(6)
	,pay_dtl	varchar(40)
	,acct_num	varchar(16)
	,vat_regn	varchar(20)
	,pay_mode_cd	varchar(6)
	,supl_type	varchar(2)
	,tech_fax_no	varchar(20)
	,tech_no	varchar(20)
	,tech_contact	varchar(25)
	,com_fax_no	varchar(20)
	,com_no	varchar(20)
	,com_contact	varchar(25)
	,supl_name	varchar(100)
	,supl_cd	varchar(20)
	,com_tlx_no	varchar(20)
	,s_l_po_ref	varchar(10)
	,tech_tlx_no	varchar(20)
)

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0716_Others_Supplier_pre;
GO

CREATE PROCEDURE ste_0716_Others_Supplier_pre
	@PackageLogID INT
AS
BEGIN
	-- truncate existing data
	truncate table cswn_supplier_;
	
END

GO


-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0716_Others_Supplier_post;
GO

CREATE PROCEDURE ste_0716_Others_Supplier_post
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

	-- update start_id and end_id for SUPPLIER_
	select @v_start_id=min(pk_supplier_), @v_end_id=max(pk_supplier_), @v_cnt=count(pk_supplier_) from cswn_supplier_;

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
		, 'supplier_'
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
           ('0716_Others_Supplier'
           ,'version'
           ,'1'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO