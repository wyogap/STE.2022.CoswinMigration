/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- Add custom columns
-- ------------------
ALTER TABLE ASSETLOCUSERCUST
ADD STE_MIGRATIONID bigint default null,
    STE_MIGRATIONDATE datetime NOT NULL DEFAULT (GETDATE());

-- create dummy column so that sp creation is successful
ALTER TABLE ASSETLOCUSERCUST ADD _ASSETLOCUSERCUSTID bigint;

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0102_Asset_LocUserCust_pre
GO

CREATE PROCEDURE ste_0102_Asset_LocUserCust_pre 
	@PackageLogID INT
AS
BEGIN
	declare @v_max_id bigint;

	-- truncate existing data
	truncate table ASSETLOCUSERCUST;

	-- enable identity column LOCATIONS.ASSETLOCUSERCUSTID (by using temporary column for identity)
	ALTER TABLE ASSETLOCUSERCUST
	ADD _ASSETLOCUSERCUSTID bigint IDENTITY;

END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0102_Asset_LocUserCust_post
GO

CREATE PROCEDURE ste_0102_Asset_LocUserCust_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_max_id bigint;

	-- update identity column
	select @v_max_id=max(_ASSETLOCUSERCUSTID) from ASSETLOCUSERCUST;

	update ASSETLOCUSERCUST set ASSETLOCUSERCUSTID = _ASSETLOCUSERCUSTID;

	alter table ASSETLOCUSERCUST drop column _ASSETLOCUSERCUSTID;

	-- update maximo seq
	update maxsequence set maxreserved=@v_max_id+1 where tbname='ASSETLOCUSERCUST' and name='ASSETLOCUSERCUSTID';

	-- update start_id and end_id
	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID) from ASSETLOCUSERCUST;

	UPDATE [dbo].[ste_migration_logs] SET
	  [start_id] = @v_start_id
	, [end_id] = @v_end_id
	WHERE [id] = @PackageLogID

END
GO

-- drop dummy column
alter table ASSETLOCUSERCUST drop column _ASSETLOCUSERCUSTID;

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
           ('0102_Asset_LocUserCust'
           ,'version'
           ,'1'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO