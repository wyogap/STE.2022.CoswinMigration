/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- Add custom columns
-- ------------------
IF COLUMNPROPERTY(OBJECT_ID('dbo.invoice'), 'STE_MIGRATIONSOURCE', 'ColumnId') is null
ALTER TABLE invoice
ADD STE_MIGRATIONSOURCE varchar(20) default null;

IF COLUMNPROPERTY(OBJECT_ID('dbo.invoiceline'), 'STE_MIGRATIONSOURCE', 'ColumnId') is null
ALTER TABLE invoiceline
ADD STE_MIGRATIONSOURCE varchar(20) default null;

IF COLUMNPROPERTY(OBJECT_ID('dbo.invoicecost'), 'STE_MIGRATIONSOURCE', 'ColumnId') is null
ALTER TABLE invoicecost
ADD STE_MIGRATIONSOURCE varchar(20) default null;

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
           ('0307_PO_Invoice_InvoiceLine_InvoiceCost'
           ,'version'
           ,'4'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO