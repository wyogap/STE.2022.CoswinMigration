/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- Add custom columns
-- ------------------
-- FAILURECODE
--

ALTER TABLE FailureCode
ADD STE_MIGRATIONID bigint default null,
    STE_MIGRATIONDATE datetime NOT NULL DEFAULT (GETDATE());

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
	declare @v_max_id bigint;

	-- truncate existing data
	truncate table FailureCode;

	---- enable identity column LOCATIONS.LOCATIONSID (by using temporary column for identity)
	--ALTER TABLE AssetAttribute
	--ADD _AssetAttributeID bigint IDENTITY;

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
	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID) from AssetAttribute;

	UPDATE [dbo].[ste_migration_logs] SET
	  [start_id] = @v_start_id
	, [end_id] = @v_end_id
	WHERE [id] = @PackageLogID

END
GO

-- FAILURECODE
--

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
	declare @v_max_id bigint;

	-- truncate existing data
	truncate table FailureList;

	---- enable identity column LOCATIONS.LOCATIONSID (by using temporary column for identity)
	--ALTER TABLE AssetAttribute
	--ADD _AssetAttributeID bigint IDENTITY;

END
GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_008_master_FailureList_post
GO

CREATE PROCEDURE ste_008_master_FailureList_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_max_id bigint;

	-- update identity column
	select @v_max_id=max(FailureList) from failurelist;

	-- update maximo seq
	update maxsequence set maxreserved=@v_max_id+1 where tbname='FAILURELIST' and name='FAILURELIST';

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
           ,'1'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO