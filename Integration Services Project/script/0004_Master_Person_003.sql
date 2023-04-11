------ custom columns
--IF COLUMNPROPERTY(OBJECT_ID('dbo.PERSON'), 'STE_CSWNEMERCONTACT', 'ColumnId') IS NULL
--ALTER TABLE PERSON
--ADD 
--	ste_cswnemercontact	varchar(25)	 default null,
--	ste_cswnidcard	varchar(16)	 default null,
--	ste_cswnpassport	varchar(16)	 default null,
--	ste_cswnworkerid	varchar(16)	 default null,
--	ste_cswnsex	varchar(3)	 default null,
--	ste_cswncompanyentity	varchar(16)	 default null,
--	ste_cswnbarcode	varchar(16)	 default null,
--	ste_cswncc	varchar(16)	 default null;

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
           ('0004_Master_Person'
           ,'version'
           ,'4'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO