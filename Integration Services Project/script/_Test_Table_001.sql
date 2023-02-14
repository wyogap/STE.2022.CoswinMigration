--update dbo.ste_migration_params
--set
--	parameter_value='1'
--where parameter_name='version' and package_name='_Test_Table'

update [dbo].[ste_migration_params]
set
	parameter_value='2'
	,[modified_on]=getdate()
	,[modified_by]='ssis'
where
	parameter_name='version' and package_name='_Test_Table'

GO

