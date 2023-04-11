/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/

IF COLUMNPROPERTY(OBJECT_ID('dbo.po'), 'STE_MIGRATIONREQBY', 'ColumnId') is null
ALTER TABLE [po]
ADD STE_MIGRATIONREQBY varchar(16) default null;

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
           ('0306_PO_PO_POLine'
           ,'version'
           ,'3'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO