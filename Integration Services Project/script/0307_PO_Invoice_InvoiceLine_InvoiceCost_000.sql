/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- -----
-- MR
-- -----

-- Add custom columns
-- ------------------
ALTER TABLE [invoice]
ADD STE_MIGRATIONID bigint default null,
    STE_MIGRATIONDATE datetime NOT NULL DEFAULT (GETDATE());

-- will be created in MAXIMO
--ALTER TABLE [invoice]
--ADD ste_cswndnref varchar(10) default null,
--	ste_cswndonum varchar(10) default null,
--	ste_cswndodate datetime default null,
--	ste_cswnwbsnum varchar(20) default null
--;

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0307_po_invoice_pre
GO

CREATE PROCEDURE ste_0307_po_invoice_pre 
	@PackageLogID INT
AS
BEGIN
	-- truncate existing data
	delete from dbo.[invoice] where STE_MIGRATIONID is not null

END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0307_po_invoice_post
GO

CREATE PROCEDURE ste_0307_po_invoice_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_cnt int;
	declare @v_max_id bigint;
	declare @PackageName varchar(250);

	-- update identity column
	select @v_max_id=max(invoiceid) from [invoice];
	update maxsequence set maxreserved=@v_max_id+1 where tbname='INVOICE' and name='INVOICEID';

	-- get package name
	select @PackageName = package_name from [dbo].[ste_migration_logs] where id = @PackageLogID;
	if (@PackageName is null) return;

	-- update start_id and end_id for ITEM_
	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from [invoice]
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
		, 'INVOICE'
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
ALTER TABLE invoiceline
ADD STE_MIGRATIONID bigint default null,
    STE_MIGRATIONDATE datetime NOT NULL DEFAULT (GETDATE());

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0307_po_invoiceline_pre
GO

CREATE PROCEDURE ste_0307_po_invoiceline_pre 
	@PackageLogID INT
AS
BEGIN
	-- truncate existing data
	delete from dbo.invoiceline where STE_MIGRATIONID is not null;

END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0307_po_invoiceline_post
GO

CREATE PROCEDURE ste_0307_po_invoiceline_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_cnt int;
	declare @v_max_id bigint;
	declare @PackageName varchar(250);

	-- update identity column
	select @v_max_id=max(invoicelineid) from invoiceline;
	update maxsequence set maxreserved=@v_max_id+1 where tbname='INVOICELINE' and name='INVOICELINEID';

	-- get package name
	select @PackageName = package_name from [dbo].[ste_migration_logs] where id = @PackageLogID;
	if (@PackageName is null) return;

	-- update start_id and end_id for ITEM_
	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from invoiceline
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
		, 'INVOICELINE'
		, 'COMPLETED'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

END
GO

-- ------------
-- InvoiceCost
-- ------------

-- Add custom columns
-- ------------------
ALTER TABLE invoicecost
ADD STE_MIGRATIONID bigint default null,
    STE_MIGRATIONDATE datetime NOT NULL DEFAULT (GETDATE());

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0307_po_invoicecost_pre
GO

CREATE PROCEDURE ste_0307_po_invoicecost_pre 
	@PackageLogID INT
AS
BEGIN
	-- truncate existing data
	delete from dbo.invoicecost where STE_MIGRATIONID is not null;

END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0307_po_invoicecost_post
GO

CREATE PROCEDURE ste_0307_po_invoicecost_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_cnt int;
	declare @v_max_id bigint;
	declare @PackageName varchar(250);

	-- update identity column
	select @v_max_id=max(invoicecostid) from invoicecost;
	update maxsequence set maxreserved=@v_max_id+1 where tbname='INVOICECOST' and name='INVOICECOSTID';

	-- get package name
	select @PackageName = package_name from [dbo].[ste_migration_logs] where id = @PackageLogID;
	if (@PackageName is null) return;

	-- update start_id and end_id for ITEM_
	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from invoicecost
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
		, 'INVOICECOST'
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
           ('0307_PO_Invoice_InvoiceLine_InvoiceCost'
           ,'version'
           ,'1'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO