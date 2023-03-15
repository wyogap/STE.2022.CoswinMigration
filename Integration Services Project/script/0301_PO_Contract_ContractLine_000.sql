/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- -----
-- MR
-- -----

-- Add custom columns
-- ------------------
ALTER TABLE [contract]
ADD STE_MIGRATIONID bigint default null,
    STE_MIGRATIONDATE datetime NOT NULL DEFAULT (GETDATE());

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0301_po_contract_pre
GO

CREATE PROCEDURE ste_0301_po_contract_pre 
	@PackageLogID INT
AS
BEGIN
	-- truncate existing data
	delete from dbo.[contract] where STE_MIGRATIONID is not null and contracttype = 'PRICE';

END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0301_po_contract_post
GO

CREATE PROCEDURE ste_0301_po_contract_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_cnt int;
	declare @v_max_id bigint;
	declare @PackageName varchar(250);

	-- update identity column
	select @v_max_id=max(contractid) from [contract];
	update maxsequence set maxreserved=@v_max_id+1 where tbname='CONTRACT' and name='CONTRACTID';

	-- get package name
	select @PackageName = package_name from [dbo].[ste_migration_logs] where id = @PackageLogID;
	if (@PackageName is null) return;

	-- update start_id and end_id for ITEM_
	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from [contract]
	where STE_MIGRATIONID is not null and contracttype = 'PRICE';

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
		, 'CONTRACT'
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
ALTER TABLE contractline
ADD STE_MIGRATIONID bigint default null,
    STE_MIGRATIONDATE datetime NOT NULL DEFAULT (GETDATE());

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0301_po_contractline_pre
GO

CREATE PROCEDURE ste_0301_po_contractline_pre 
	@PackageLogID INT
AS
BEGIN
	-- truncate existing data
	delete from dbo.contractline where STE_MIGRATIONID is not null and contracttype = 'PRICE';

END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0301_po_contractline_post
GO

CREATE PROCEDURE ste_0301_po_contractline_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_cnt int;
	declare @v_max_id bigint;
	declare @PackageName varchar(250);

	-- update identity column
	select @v_max_id=max(contractlineid) from contractline;
	update maxsequence set maxreserved=@v_max_id+1 where tbname='CONTRACTLINE' and name='CONTRACTLINEID';

	-- get package name
	select @PackageName = package_name from [dbo].[ste_migration_logs] where id = @PackageLogID;
	if (@PackageName is null) return;

	-- update start_id and end_id for ITEM_
	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from contractline
	where STE_MIGRATIONID is not null and contracttype = 'PRICE';

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
		, 'CONTRACTLINE'
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
           ('0301_PO_Contract_ContractLine'
           ,'version'
           ,'1'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO