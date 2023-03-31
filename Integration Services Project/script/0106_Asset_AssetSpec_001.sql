/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- Add custom columns
-- ------------------
IF COLUMNPROPERTY(OBJECT_ID('dbo.ASSETSPEC'), 'STE_MIGRATIONEQCD', 'ColumnId') is null
ALTER TABLE ASSETSPEC
ADD STE_MIGRATIONEQCD varchar(20) NULL;

-- THIS WILL BE DONE IN MAXIMO
---- make sure assetnum is not truncated (the same column in ASSET table is 24 char)
---- originally it is varchar(12)
--ALTER TABLE ASSETSPEC
--ALTER COLUMN assetnum varchar(20) NOT NULL;

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
           ('0106_Asset_AssetSpec'
           ,'version'
           ,'2'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO