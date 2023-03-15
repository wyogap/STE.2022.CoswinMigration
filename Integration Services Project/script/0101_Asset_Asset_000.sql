/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- Add custom columns
-- ------------------
ALTER TABLE ASSET
ADD STE_MIGRATIONID bigint default null,
    STE_MIGRATIONDATE datetime NOT NULL DEFAULT (GETDATE())
	;

-- this will be created automatically by maximo
--ALTER TABLE ASSET
--ADD ste_cswneqpcode VARCHAR(100) default null,
--	ste_cswneqpfunctn VARCHAR(10) default null,
--	ste_cswnwptype VARCHAR(10) default null,
--	ste_cswnwponcmwo CHAR(1) default null,
--	ste_cswnauthority VARCHAR(16) default null,
--	ste_systemcode VARCHAR(4) default null,
--	ste_subsystemcode VARCHAR(6) default null,
--	ste_aisassetcode VARCHAR(38) default null,
--	ste_aisassetid VARCHAR(18) default null,
--	ste_aislocationcode VARCHAR(50) default null,
--	ste_cswnassetid VARCHAR(40) default null,
--	ste_cswnbarcode VARCHAR(20) default null,
--	ste_cswnsystemequip VARCHAR(20) default null,
--	ste_cswngt VARCHAR(12) default null,
--	ste_cswnsnodate DATETIME default null
--	;

---- force make sure modelnumber from coswin is not truncated
--ALTER TABLE ASSET
--ALTER COLUMN pluscmodelnum varchar(24) NOT NULL;

---- create dummy column so that sp creation is successful
--ALTER TABLE ASSET ADD _ASSETTUID bigint;

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0101_Asset_Asset_pre
GO

CREATE PROCEDURE ste_0101_Asset_Asset_pre 
	@PackageLogID INT
AS
BEGIN
	declare @v_max_id bigint;

	-- truncate existing data
	truncate table ASSET;

	---- enable identity column ASSET.ASSETID (by using temporary column for identity)
	--ALTER TABLE ASSET
	--ADD _ASSETTUID bigint IDENTITY;

END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0101_Asset_Asset_post
GO

CREATE PROCEDURE ste_0101_Asset_Asset_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_max_id bigint;

	-- update identity column
	select @v_max_id=max(ASSETUID) from ASSET;

	--update ASSET set ASSETTID = _ASSETTUID;

	--alter table ASSET drop column _ASSETTUID;

	-- update maximo seq
	update maxsequence set maxreserved=@v_max_id+1 where tbname='ASSET' and name='ASSETUID';

	-- update start_id and end_id
	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID) from ASSET;

	UPDATE [dbo].[ste_migration_logs] SET
	  [start_id] = @v_start_id
	, [end_id] = @v_end_id
	WHERE [id] = @PackageLogID

END
GO

---- drop dummy column
--alter table ASSET drop column _ASSETTUID;

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
           ('0101_Asset_Asset'
           ,'version'
           ,'1'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO