/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_007_master_assetattribute_post;
drop procedure if exists ste_0007_master_assetattribute_post;
GO

CREATE PROCEDURE ste_0007_master_assetattribute_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_cnt int;
	declare @v_max_id bigint;
	declare @PackageName varchar(250);

	-- update ClassStructureID autokey
	select @v_max_id=max(try_cast(assetattrid as bigint)) from assetattribute;
	update autokey set seed=@v_max_id+1 where autokeyname='ASSETATTRID';

	-- update identity column
	select @v_max_id=max(try_cast(assetattributeId as bigint)) from assetattribute;
	update maxsequence set maxreserved=@v_max_id+1 where tbname='assetattribute' and name='assetattributeID';

	-- get package name
	select @PackageName = package_name from [dbo].[ste_migration_logs] where id = @PackageLogID;
	if (@PackageName is null) return;

	-- LOGGING
	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from assetattribute
	where STE_MIGRATIONID is not null;

	insert into [dbo].[ste_migration_log_details] (
		[package_name]
		,[log_id]
		,[event]
		,[event_type]
		,[event_description]
	)
	values (
		@PackageName
		, @PackageLogID
		, 'ASSETATTRIBUTE'
		, 'COMPLETED'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	-- update start_id and end_id
	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID) from assetattribute
	where STE_MIGRATIONID is not null;

	UPDATE [dbo].[ste_migration_logs] SET
	  [start_id] = @v_start_id
	, [end_id] = @v_end_id
	WHERE [id] = @PackageLogID

END
GO

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
           ('0007_Master_AssetAttribute_ClassSpec_ClassSpecUseWith'
           ,'version'
           ,'6'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO