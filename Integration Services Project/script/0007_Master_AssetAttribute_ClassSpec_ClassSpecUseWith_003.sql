/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_007_master_assetattribute_pre;
drop procedure if exists ste_0007_master_assetattribute_pre;
GO

CREATE PROCEDURE ste_0007_master_assetattribute_pre 
	@PackageLogID INT
AS
BEGIN
	declare @v_seed int;
	declare @v_max_id bigint;

	-- truncate existing data
	delete from assetattribute where STE_MIGRATIONID is not null;

	-- create autokey if not exist
	select @v_seed=seed from [dbo].[autokey] where [autokeyname]='ASSETATTRID';
	if (@v_seed is null)
	begin
		select @v_max_id=maxreserved from [dbo].[maxsequence] where [tbname]='AUTOKEY' and [name]='AUTOKEYID';
		
		insert into [dbo].[autokey] (
			[seed]
			,[autokeyname]
			,[langcode]
			,[autokeyid]
		)
		values (
			1000
			,'ASSETATTRID'
			,'EN'
			,@v_max_id + 1
		);

		update maxsequence set maxreserved=@v_max_id+1 where tbname='AUTOKEY' and name='AUTOKEYID';
	end;

END

GO

-- Delete legacy insert
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_007_master_assetattribute_insert;
drop procedure if exists ste_0007_master_assetattribute_insert;
GO

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
	declare @v_max_id bigint;

	-- update ClassStructureID autokey
	select @v_max_id=max(assetattrid) from assetattribute;
	update autokey set seed=@v_max_id+1 where autokeyname='ASSETATTRID';

	-- update identity column
	select @v_max_id=max(assetattributeId) from assetattribute;
	update maxsequence set maxreserved=@v_max_id+1 where tbname='assetattribute' and name='assetattributeID';

	-- update start_id and end_id
	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID) from assetattribute
	where STE_MIGRATIONID is not null;

	UPDATE [dbo].[ste_migration_logs] SET
	  [start_id] = @v_start_id
	, [end_id] = @v_end_id
	WHERE [id] = @PackageLogID

END
GO

-- -----------
-- classspec
-- -----------

-- Add custom columns
-- ------------------
IF COLUMNPROPERTY(OBJECT_ID('dbo.classspec'), 'STE_MIGRATIONID', 'ColumnId') IS NULL
ALTER TABLE classspec
ADD STE_MIGRATIONID bigint default null,
    STE_MIGRATIONDATE datetime NOT NULL DEFAULT (GETDATE());

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0007_master_classspec_pre;
GO

CREATE PROCEDURE ste_0007_master_classspec_pre 
	@PackageLogID INT
AS
BEGIN
	-- truncate existing data
	delete from classspec where STE_MIGRATIONID is not null;

END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_007_master_classspec_post
drop procedure if exists ste_0007_master_classspec_post
GO

CREATE PROCEDURE ste_0007_master_classspec_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_max_id bigint;

	-- update identity column
	select @v_max_id=max(classspecid) from classspec;
	update maxsequence set maxreserved=@v_max_id+1 where tbname='CLASSSPEC' and name='CLASSSPECID';

	-- update start_id and end_id
	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID) from classspec;

	UPDATE [dbo].[ste_migration_logs] SET
	  [start_id] = @v_start_id
	, [end_id] = @v_end_id
	WHERE [id] = @PackageLogID

END
GO

-- -----------------
-- classspecusewith
-- -----------------

-- Add custom columns
-- ------------------
IF COLUMNPROPERTY(OBJECT_ID('dbo.classspecusewith'), 'STE_MIGRATIONID', 'ColumnId') IS NULL
ALTER TABLE classspecusewith
ADD STE_MIGRATIONID bigint default null,
    STE_MIGRATIONDATE datetime NOT NULL DEFAULT (GETDATE());

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0007_master_classspecusewith_pre;
GO

CREATE PROCEDURE ste_0007_master_classspecusewith_pre 
	@PackageLogID INT
AS
BEGIN
	-- truncate existing data
	delete from classspecusewith where STE_MIGRATIONID is not null;

END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_007_master_classspecusewith_post;
drop procedure if exists ste_0007_master_classspecusewith_post;
GO

CREATE PROCEDURE ste_0007_master_classspecusewith_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_max_id bigint;

	-- update identity column
	select @v_max_id=max(classspecusewithid) from classspecusewith;
	update maxsequence set maxreserved=@v_max_id+1 where tbname='CLASSSPECUSEWITH' and name='CLASSSPECUSEWITHID';

	-- update start_id and end_id
	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID) from classspecusewith;

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
           ,'4'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO