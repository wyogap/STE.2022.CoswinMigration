/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- Add custom columns
-- ------------------
-- FAILURECODE
--

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_008_master_FailureCode_pre
GO

CREATE PROCEDURE ste_008_master_FailureCode_pre 
	@PackageLogID INT
AS
BEGIN
	-- truncate existing data
	delete from FailureCode where STE_MIGRATIONID is not null;

END
GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_008_master_FailureCode_post
GO

CREATE PROCEDURE ste_008_master_FailureCode_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_max_id bigint;

	-- update identity column
	select @v_max_id=max(FailureCodeID) from failurecode;

	-- update maximo seq
	update maxsequence set maxreserved=@v_max_id+1 where tbname='FailureCode' and name='FailureCodeID';

	-- update start_id and end_id
	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID) from AssetAttribute
	where STE_MIGRATIONID is not null;

	UPDATE [dbo].[ste_migration_logs] SET
	  [start_id] = @v_start_id
	, [end_id] = @v_end_id
	WHERE [id] = @PackageLogID

END
GO

-- FAILURELIST
--

ALTER TABLE FailureList
ADD STE_MIGRATIONID bigint default null,
    STE_MIGRATIONDATE datetime NOT NULL DEFAULT (GETDATE());

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_008_master_FailureList_pre
GO

CREATE PROCEDURE ste_008_master_FailureList_pre 
	@PackageLogID INT
AS
BEGIN
	-- truncate existing data
	delete from FailureList where STE_MIGRATIONID is not null;

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
           ('0008_Master_FailureCode_FailureList'
           ,'version'
           ,'2'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO