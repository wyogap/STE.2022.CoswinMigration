/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/

-- CLASSIFICATION
--

-- Add custom columns
-- ------------------
IF COLUMNPROPERTY(OBJECT_ID('dbo.CLASSIFICATION'), 'STE_MIGRATIONID', 'ColumnId') IS NULL
ALTER TABLE [CLASSIFICATION]
ADD STE_MIGRATIONID bigint default null,
    STE_MIGRATIONDATE datetime NOT NULL DEFAULT (GETDATE());

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_006_master_classification_pre
GO

CREATE PROCEDURE ste_006_master_classification_pre 
	@PackageLogID INT
AS
BEGIN
	-- truncate existing data
	delete from [Classification] where STE_MIGRATIONID is not null;

END

GO

-- CLASSSTRUCTURE
--

IF COLUMNPROPERTY(OBJECT_ID('dbo.ClassStructure'), 'STE_MIGRATIONID', 'ColumnId') IS NULL
ALTER TABLE ClassStructure
ADD STE_MIGRATIONID bigint default null,
    STE_MIGRATIONDATE datetime NOT NULL DEFAULT (GETDATE());

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_006_master_ClassStructure_pre
GO

CREATE PROCEDURE ste_006_master_ClassStructure_pre 
	@PackageLogID INT
AS
BEGIN
	-- truncate existing data
	DELETE FROM ClassStructure WHERE STE_MIGRATIONID IS NOT NULL;

END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_006_master_ClassStructure_post
GO

CREATE PROCEDURE ste_006_master_ClassStructure_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_max_id bigint;

	-- update ClassStructureID autokey
	--update ClassStructure set ClassStructureID = STE_CLASSSTRUCTUREID + 1000;

	select @v_max_id=max(ClassStructureID) from ClassStructure;
	update autokey set seed=@v_max_id+1 where autokeyname='CLASSSTRUCTUREID';

	-- update ClassStructureUID seq
	--update ClassStructure set ClassStructureUID = STE_CLASSSTRUCTUREID;

	select @v_max_id=max(ClassStructureUID) from ClassStructure;
	update maxsequence set maxreserved=@v_max_id+1 where tbname='ClassStructure' and name='ClassStructureUID';

	-- update start_id and end_id
	select @v_start_id=min(ClassStructureUID), @v_end_id=max(ClassStructureUID) from ClassStructure
	WHERE STE_MIGRATIONID IS NOT NULL;

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
           ('0006_Master_Classification_ClassStructure'
           ,'version'
           ,'2'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO