/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- -----
-- MR
-- -----

-- Add custom columns
-- ------------------
ALTER TABLE [rfqvendor]
ADD STE_MIGRATIONID bigint default null,
    STE_MIGRATIONDATE datetime NOT NULL DEFAULT (GETDATE());

-- it will be created in MAXIMO
--ALTER TABLE [rfqvendor]
--ADD ste_cswnnotes varchar(100) default null,
--	ste_cswnapglcode varchar(20) default null,
--	ste_cswnwbsnum varchar(20) default null
--	;

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0305_po_rfqvendor_pre
GO

CREATE PROCEDURE ste_0305_po_rfqvendor_pre 
	@PackageLogID INT
AS
BEGIN
	-- truncate existing data
	delete from dbo.[rfqvendor] where STE_MIGRATIONID is not null

END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0305_po_rfqvendor_post
GO

CREATE PROCEDURE ste_0305_po_rfqvendor_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_cnt int;
	declare @v_max_id bigint;
	declare @PackageName varchar(250);

	-- update identity column
	select @v_max_id=max(rfqvendorid) from [rfqvendor];
	update maxsequence set maxreserved=@v_max_id+1 where tbname='RFQVENDOR' and name='RFQVENDORID';

	-- get package name
	select @PackageName = package_name from [dbo].[ste_migration_logs] where id = @PackageLogID;
	if (@PackageName is null) return;

	-- update start_id and end_id for ITEM_
	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from [rfqvendor]
	where STE_MIGRATIONID is not null;

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
		, 'RFQVENDOR'
		, 'COMPLETED'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	-- update start_id and end_id
	UPDATE [dbo].[ste_migration_logs] SET
	  [start_id] = @v_start_id
	, [end_id] = @v_end_id
	WHERE [id] = @PackageLogID

END
GO

-- -------
-- MRLine
-- -------

-- Add custom columns
-- ------------------
ALTER TABLE quotationline
ADD STE_MIGRATIONID bigint default null,
    STE_MIGRATIONDATE datetime NOT NULL DEFAULT (GETDATE());

-- it will be created by MAXIMO
--ALTER TABLE quotationline
--ADD ste_cswnaltprice1 decimal(10,2) default null,
--	ste_cswnaltprice2 decimal(10,2) default null
--;

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0305_po_quotationline_pre
GO

CREATE PROCEDURE ste_0305_po_quotationline_pre 
	@PackageLogID INT
AS
BEGIN
	-- truncate existing data
	delete from dbo.quotationline where STE_MIGRATIONID is not null;

END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0305_po_quotationline_post
GO

CREATE PROCEDURE ste_0305_po_quotationline_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_cnt int;
	declare @v_max_id bigint;
	declare @PackageName varchar(250);

	-- update identity column
	select @v_max_id=max(quotationlineid) from quotationline;
	update maxsequence set maxreserved=@v_max_id+1 where tbname='QUOTATIONLINE' and name='QUOTATIONLINEID';

	-- get package name
	select @PackageName = package_name from [dbo].[ste_migration_logs] where id = @PackageLogID;
	if (@PackageName is null) return;

	-- update start_id and end_id for ITEM_
	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from quotationline
	where STE_MIGRATIONID is not null;

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
		, 'QUOTATIONLINE'
		, 'COMPLETED'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

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
           ('0305_PO_RFQVendor_QuotationLine'
           ,'version'
           ,'1'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO