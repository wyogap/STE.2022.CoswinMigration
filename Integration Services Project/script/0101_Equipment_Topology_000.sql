/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- Add custom columns
-- ------------------
ALTER TABLE LOCATIONS
ADD STE_MIGRATIONID bigint default null,
    STE_MIGRATIONDATE datetime NOT NULL DEFAULT (GETDATE());

-- create dummy column so that sp creation is successful
ALTER TABLE LOCATIONS ADD _LOCATIONSID bigint;

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_003_master_locations_pre
GO

CREATE PROCEDURE ste_003_master_locations_pre 
	@PackageLogID INT
AS
BEGIN
	declare @v_max_id bigint;

	-- truncate existing data
	truncate table locations;

	-- enable identity column LOCATIONS.LOCATIONSID (by using temporary column for identity)
	ALTER TABLE LOCATIONS
	ADD _LOCATIONSID bigint IDENTITY;

END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_003_master_locations_post
GO

CREATE PROCEDURE ste_003_master_locations_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_max_id bigint;

	-- update identity column
	select @v_max_id=max(_LOCATIONSID) from LOCATIONS;

	update LOCATIONS set LOCATIONSID = _LOCATIONSID;

	alter table LOCATIONS drop column _LOCATIONSID;

	-- update maximo seq
	update maxsequence set maxreserved=@v_max_id+1 where tbname='LOCATIONS' and name='LOCATIONSID';

	-- update start_id and end_id
	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID) from LOCATIONS;

	UPDATE [dbo].[ste_migration_logs] SET
	  [start_id] = @v_start_id
	, [end_id] = @v_end_id
	WHERE [id] = @PackageLogID

END
GO

-- drop dummy column
alter table LOCATIONS drop column _LOCATIONSID;

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
           ('0003_Master_Locations'
           ,'version'
           ,'1'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO