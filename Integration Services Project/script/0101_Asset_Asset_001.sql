/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- Add custom columns
-- ------------------
--ALTER TABLE ASSET
--ADD STE_CSWNPRCD VARCHAR(20) default null,
--	STE_CSWNLEVEL int default null
--	;

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
           ,'2'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO