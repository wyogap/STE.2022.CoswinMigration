/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- Add custom columns
-- ------------------
--IF COLUMNPROPERTY(OBJECT_ID('dbo.workorder'), 'ste_cswnwoid', 'ColumnId') IS NULL
--ALTER TABLE [workorder]
--ADD ste_cswnwoid varchar(16) default null;

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
           ('0401_WO_Workorder'
           ,'version'
           ,'2'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO