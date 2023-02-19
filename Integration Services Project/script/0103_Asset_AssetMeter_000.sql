/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- Add custom columns
-- ------------------
ALTER TABLE ASSETMETER
ADD STE_CSWNASSETID varchar(40) NULL,
	STE_MIGRATIONID bigint default null,
    STE_MIGRATIONDATE datetime NOT NULL DEFAULT (GETDATE())
	;

-- make sure metername from coswin is not truncated (the same column in master METER table is already 24 char)
-- originally it is varchar(12)
ALTER TABLE ASSETMETER
ALTER COLUMN metername varchar(20) NOT NULL;

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0103_Asset_AssetMeter_pre
GO

CREATE PROCEDURE ste_0103_Asset_AssetMeter_pre 
	@PackageLogID INT
AS
BEGIN
	declare @v_max_id bigint;

	-- truncate existing data
	truncate table ASSETMETER;

	---- enable identity column LOCATIONS.ASSETMETERID (by using temporary column for identity)
	--ALTER TABLE ASSETMETER
	--ADD _ASSETMETERID bigint IDENTITY;

END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0103_Asset_AssetMeter_post
GO

CREATE PROCEDURE ste_0103_Asset_AssetMeter_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_max_id bigint;

	-- update identity column
	select @v_max_id=max(ASSETMETERID) from ASSETMETER;

	-- update maximo seq
	update maxsequence set maxreserved=@v_max_id+1 where tbname='ASSETMETER' and name='ASSETMETERID';

	-- update start_id and end_id
	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID) from ASSETMETER;

	UPDATE [dbo].[ste_migration_logs] SET
	  [start_id] = @v_start_id
	, [end_id] = @v_end_id
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
           ('0103_Asset_AssetMeter'
           ,'version'
           ,'1'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO