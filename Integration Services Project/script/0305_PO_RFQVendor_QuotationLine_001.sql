/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/

-- Add custom columns
-- ------------------
IF COLUMNPROPERTY(OBJECT_ID('dbo.quotationline'), 'STE_MIGRATIONITEMPK', 'ColumnId') is null
ALTER TABLE quotationline
ADD STE_MIGRATIONITEMPK bigint default null,
    STE_MIGRATIONNSITEMPK bigint default null;

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
	select @v_cnt=count(STE_MIGRATIONID) from quotationline
	where STE_MIGRATIONID is not null and itemnum is null and STE_MIGRATIONITEMPK is not null;

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
		, 'QUOTATIONLINE-NOMATCH-ITEM'
		, 'LOG'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0))
	);

	select @v_cnt=count(STE_MIGRATIONID) from quotationline
	where STE_MIGRATIONID is not null and itemnum is null and STE_MIGRATIONNSITEMPK is not null;

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
		, 'QUOTATIONLINE-NOMATCH-NSITEM'
		, 'LOG'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0))
	);

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
           ,'2'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO