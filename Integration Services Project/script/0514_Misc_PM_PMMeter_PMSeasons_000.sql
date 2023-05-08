/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- --------
-- PM
-- --------

-- Add custom columns
-- ------------------
IF COLUMNPROPERTY(OBJECT_ID('dbo.pm'), 'STE_MIGRATIONID', 'ColumnId') is null
ALTER TABLE pm
ADD STE_MIGRATIONID bigint default null,
    STE_MIGRATIONDATE datetime NOT NULL DEFAULT (GETDATE());

--IF COLUMNPROPERTY(OBJECT_ID('dbo.pm'), 'STE_CSWNCC', 'ColumnId') is null
--ALTER TABLE pm
--ADD STE_CSWNCC	varchar(16) default null,
--	STE_CSWNCOSTYPE	varchar(10) default null,
--	STE_CSWNINTERVALUNIT	varchar(8) default null,
--	STE_CSWNJOBBEHAVIOUR	SMALLINT default null,
--	STE_CSWNJOBLEVEL	SMALLINT default null,
--	STE_CSWNLASTWONUM	varchar(10) default null,
--	STE_CSWNMAXINTERVAL	numeric(12) default null,
--	STE_CSWNMININTERVAL	numeric(12) default null,
--	STE_CSWNMULT	SMALLINT default null,
--	STE_CSWNSHIFT	SMALLINT default null,
--	STE_CSWNWORKDAY	SMALLINT default null,
--	STE_CWEQCODE	varchar(25) default null;

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0514_Misc_PM_pre
GO

CREATE PROCEDURE ste_0514_Misc_PM_pre 
	@PackageLogID INT
AS
BEGIN
	-- truncate existing data
	delete from pm where STE_MIGRATIONID is not null;

END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0514_Misc_PM_post
GO

CREATE PROCEDURE ste_0514_Misc_PM_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_cnt int;
	declare @v_max_id bigint;
	declare @PackageName varchar(250);

	-- update identity column
	select @v_max_id=max(pmuid) from pm;
	update maxsequence set maxreserved=coalesce(@v_max_id,0)+1 where tbname='PM' and name='PMUID';

	-- get package name
	select @PackageName = package_name from [dbo].[ste_migration_logs] where id = @PackageLogID;
	if (@PackageName is null) return;

	-- update start_id and end_id for ITEM_
	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from pm
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
		, 'PM'
		, 'COMPLETED'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	UPDATE [dbo].[ste_migration_logs] SET
	  [start_id] = @v_start_id
	, [end_id] = @v_end_id
	WHERE [id] = @PackageLogID

END
GO

-- --------
-- PMMeter
-- --------

-- Add custom columns
-- ------------------
IF COLUMNPROPERTY(OBJECT_ID('dbo.pmmeter'), 'STE_MIGRATIONID', 'ColumnId') is null
ALTER TABLE pmmeter
ADD STE_MIGRATIONID bigint default null,
    STE_MIGRATIONDATE datetime NOT NULL DEFAULT (GETDATE());

IF COLUMNPROPERTY(OBJECT_ID('dbo.pmmeter'), 'STE_CSWNFREQUNIT', 'ColumnId') is null
ALTER TABLE pmmeter
ADD STE_CSWNFREQUNIT	smallint default null;

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0514_Misc_PMMeter_pre
GO

CREATE PROCEDURE ste_0514_Misc_PMMeter_pre 
	@PackageLogID INT
AS
BEGIN
	-- truncate existing data
	delete from pmmeter where STE_MIGRATIONID is not null;

END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0514_Misc_PMMeter_post
GO

CREATE PROCEDURE ste_0514_Misc_PMMeter_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_cnt int;
	declare @v_max_id bigint;
	declare @PackageName varchar(250);

	-- update identity column
	select @v_max_id=max(pmmeterid) from pmmeter;
	update maxsequence set maxreserved=coalesce(@v_max_id,0)+1 where tbname='PMMETER' and name='PMMETERID';

	-- get package name
	select @PackageName = package_name from [dbo].[ste_migration_logs] where id = @PackageLogID;
	if (@PackageName is null) return;

	-- update start_id and end_id for ITEM_
	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from pmmeter
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
		, 'PMMETER'
		, 'COMPLETED'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

END
GO

-- ----------
-- PMSeasons
-- ----------

-- Add custom columns
-- ------------------
IF COLUMNPROPERTY(OBJECT_ID('dbo.pmseasons'), 'STE_MIGRATIONID', 'ColumnId') is null
ALTER TABLE pmseasons
ADD STE_MIGRATIONID bigint default null,
    STE_MIGRATIONDATE datetime NOT NULL DEFAULT (GETDATE());

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0514_Misc_PMSeasons_pre
GO

CREATE PROCEDURE ste_0514_Misc_PMSeasons_pre 
	@PackageLogID INT
AS
BEGIN
	-- truncate existing data
	delete from pmseasons where STE_MIGRATIONID is not null;

END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0514_Misc_PMSeasons_post
GO

CREATE PROCEDURE ste_0514_Misc_PMSeasons_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_cnt int;
	declare @v_max_id bigint;
	declare @PackageName varchar(250);

	-- update identity column
	select @v_max_id=max(pmseasonsid) from pmseasons;
	update maxsequence set maxreserved=coalesce(@v_max_id,0)+1 where tbname='PMSEASONS' and name='PMSEASONSID';

	-- get package name
	select @PackageName = package_name from [dbo].[ste_migration_logs] where id = @PackageLogID;
	if (@PackageName is null) return;

	-- update start_id and end_id for ITEM_
	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from pmseasons
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
		, 'PMSEASONS'
		, 'COMPLETED'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

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
           ('0514_Misc_PM_PMMeter_PMSeason'
           ,'version'
           ,'1'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO