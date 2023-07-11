/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- -----
-- MR
-- -----

-- Add custom columns
-- ------------------
IF COLUMNPROPERTY(OBJECT_ID('dbo.mr'), 'STE_MIGRATIONDEMANDER', 'ColumnId') is null
ALTER TABLE mr
ADD STE_MIGRATIONDEMANDER varchar(100) default null;

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
           ('0205_Inventory_MR_MRLine'
           ,'version'
           ,'2'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO