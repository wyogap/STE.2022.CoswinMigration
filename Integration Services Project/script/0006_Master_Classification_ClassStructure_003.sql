/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/

-- CLASSIFICATION
--

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_006_master_classification_pre;
drop procedure if exists ste_0006_master_classification_pre;
GO

CREATE PROCEDURE ste_0006_master_classification_pre 
	@PackageLogID INT
AS
BEGIN
	-- truncate existing data
	delete from [Classification] where STE_MIGRATIONID is not null;

END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_006_master_classification_post;
drop procedure if exists ste_0006_master_classification_post;
GO

CREATE PROCEDURE ste_0006_master_classification_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_max_id bigint;

	-- update identity column
	select @v_max_id=max(ClassificationUID) from Classification;
	update maxsequence set maxreserved=@v_max_id+1 where tbname='Classification' and name='ClassificationUID';

END
GO

-- CLASSSTRUCTURE
--

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_006_master_ClassStructure_pre;
drop procedure if exists ste_0006_master_ClassStructure_pre;
GO

CREATE PROCEDURE ste_0006_master_ClassStructure_pre 
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

drop procedure if exists ste_006_master_ClassStructure_post;
drop procedure if exists ste_0006_master_ClassStructure_post;
GO

CREATE PROCEDURE ste_0006_master_ClassStructure_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_max_id bigint;

	-- update ClassStructureID autokey
	-- select @v_max_id=max(ClassStructureID) from ClassStructure;
	-- update autokey set seed=@v_max_id+1 where autokeyname='CLASSSTRUCTUREID';

	-- no need to update autokey because we use string naming

	-- update ClassStructureUID seq
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
           ,'4'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO