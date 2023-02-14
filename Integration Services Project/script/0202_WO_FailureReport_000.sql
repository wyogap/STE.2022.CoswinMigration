/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- Add custom columns
-- ------------------
ALTER TABLE FAILUREREPORT
ADD STE_MIGRATIONID bigint default null,
    STE_MIGRATIONDATE datetime NOT NULL DEFAULT (GETDATE());

-- create dummy column so that sp creation is successful
ALTER TABLE FAILUREREPORT ADD _FAILUREREPORTID bigint;

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0202_WO_FailureReport_pre
GO

CREATE PROCEDURE ste_0202_WO_FailureReport_pre 
	@PackageLogID INT
AS
BEGIN
	declare @v_max_id bigint;

	-- truncate existing data
	truncate table FAILUREREPORT;

	-- enable identity column LOCATIONS.FAILUREREPORTID (by using temporary column for identity)
	ALTER TABLE FAILUREREPORT
	ADD _FAILUREREPORTID bigint IDENTITY;

END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0202_WO_FailureReport_post
GO

CREATE PROCEDURE ste_0202_WO_FailureReport_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_max_id bigint;

	-- update identity column
	select @v_max_id=max(_FAILUREREPORTID) from FAILUREREPORT;

	update FAILUREREPORT set FAILUREREPORTID = _FAILUREREPORTID;

	alter table FAILUREREPORT drop column _FAILUREREPORTID;

	-- update maximo seq
	update maxsequence set maxreserved=@v_max_id+1 where tbname='FAILUREREPORT' and name='FAILUREREPORTID';

	-- update start_id and end_id
	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID) from FAILUREREPORT;

	UPDATE [dbo].[ste_migration_logs] SET
	  [start_id] = @v_start_id
	, [end_id] = @v_end_id
	WHERE [id] = @PackageLogID

END
GO

-- drop dummy column
alter table FAILUREREPORT drop column _FAILUREREPORTID;

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
           ('0202_WO_FailureReport'
           ,'version'
           ,'1'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO