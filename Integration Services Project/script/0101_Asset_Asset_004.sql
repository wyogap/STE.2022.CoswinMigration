/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/

--IF COLUMNPROPERTY(OBJECT_ID('dbo.asset'), 'ste_inchrgref', 'ColumnId') is null
--ALTER TABLE asset
--ADD ste_inchrgref varchar(20) default null;

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
           ,'5'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO