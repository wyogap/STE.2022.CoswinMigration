-- Create custom table
CREATE TABLE [dbo].[ste_assetsrno](
	[assetnum] [varchar](12) NOT NULL,
	[serialno] [varchar](30) NOT NULL,
	[siteid] [varchar](8) NOT NULL,
	[orgid] [varchar](8) NOT NULL,
	[ste_cswnsnodate] [datetime] NULL,
	[assetsrnoid] [bigint] NOT NULL,
	[STE_CSWNASSETID] [varchar](40) NULL,
	[STE_MIGRATIONID] [bigint] NULL,
	[STE_MIGRATIONDATE] [datetime] NOT NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ste_assetsrno] ADD  DEFAULT (NULL) FOR [STE_MIGRATIONID]
GO

ALTER TABLE [dbo].[ste_assetsrno] ADD  DEFAULT (getdate()) FOR [STE_MIGRATIONDATE]
GO

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0104_Asset_STEAssetSrNo_pre
GO

CREATE PROCEDURE ste_0104_Asset_STEAssetSrNo_pre 
	@PackageLogID INT
AS
BEGIN
	declare @v_max_id bigint;

	-- truncate existing data
	truncate table STE_AssetSrNo;

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

drop procedure if exists ste_0104_Asset_STEAssetSrNo_post
GO

CREATE PROCEDURE ste_0104_Asset_STEAssetSrNo_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	--declare @v_max_id bigint;

	---- update identity column
	--select @v_max_id=max(ASSETMETERID) from ASSETMETER;

	---- update maximo seq
	--update maxsequence set maxreserved=@v_max_id+1 where tbname='ASSETMETER' and name='ASSETMETERID';

	-- update start_id and end_id
	select @v_start_id=min(assetsrnoid), @v_end_id=max(assetsrnoid) from ste_assetsrno;

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
           ('0104_Asset_STE_AssetSrNo'
           ,'version'
           ,'1'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO