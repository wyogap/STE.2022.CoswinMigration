-- Create custom table
ALTER TABLE [ste_assetsrno]
ADD STE_CSWNEQCD varchar(20) NULL
	;

-- make sure assetnum is not truncated (the same column in ASSET table is 24 char)
-- originally it is varchar(12)
ALTER TABLE [ste_assetsrno]
ALTER COLUMN assetnum varchar(20) NOT NULL;

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
           ,'2'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO