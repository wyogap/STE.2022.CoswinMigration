
-- Add custom columns
-- ------------------
IF COLUMNPROPERTY(OBJECT_ID('dbo.ASSETTRANS'), 'STE_MIGRATIONEQCD', 'ColumnId') is null
ALTER TABLE ASSETTRANS
ADD STE_MIGRATIONEQCD varchar(20) NULL;

-- column assetnum is already varchar(24)

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
           ('0105_Asset_AssetTrans'
           ,'version'
           ,'2'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO