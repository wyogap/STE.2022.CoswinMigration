/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- Add custom columns
-- ------------------
ALTER TABLE ASSETMETER
ADD STE_CSWNEQCD varchar(40) NULL
	;

-- make sure assetnum is not truncated (the same column in ASSET table is 24 char)
-- originally it is varchar(12)
ALTER TABLE ASSETMETER
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
           ('0103_Asset_AssetMeter'
           ,'version'
           ,'2'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO