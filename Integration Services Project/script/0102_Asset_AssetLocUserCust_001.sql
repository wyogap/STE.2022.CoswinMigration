/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- Add custom columns
-- ------------------
ALTER TABLE ASSETLOCUSERCUST
ADD STE_MIGRATIONEQCD varchar(20) NULL
	;

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
           ('0102_Asset_AssetLocUserCust'
           ,'version'
           ,'2'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO