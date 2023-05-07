/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- Add custom columns
-- ------------------
--IF COLUMNPROPERTY(OBJECT_ID('dbo.jobplan'), 'STE_CSWNAVPRTM', 'ColumnId') is null
--ALTER TABLE jobplan
--ADD STE_CSWNAVPRTM	SMALLINT default null,
--	STE_CSWNCC	varchar(16) default null,
--	STE_CSWNDAY	SMALLINT default null,
--	STE_CSWNDURATIONUNIT	varchar(5) default null,
--	STE_CSWNENWK	SMALLINT default null,
--	STE_CSWNHAZARD	SMALLINT default null,
--	STE_CSWNJBBHU	SMALLINT default null,
--	STE_CSWNJOBCLASS	varchar(6) default null,
--	STE_CSWNJOBTYPE	varchar(6) default null,
--	STE_CSWNLABORCOST	numeric(10) default null,
--	STE_CSWNLJML	FLOAT default null,
--	STE_CSWNMATERIALCOST	NUMERIC(10) default null,
--	STE_CSWNMIPRTM	SMALLINT default null,
--	STE_CSWNMTID	varchar(16) default null,
--	STE_CSWNMTPRML	DECIMAL(15) default null,
--	STE_CSWNMXPRTM	SMALLINT default null,
--	STE_CSWNNOWO	SMALLINT default null,
--	STE_CSWNPR_UNIT	SMALLINT default null,
--	STE_CSWNPRJREF	varchar(10) default null,
--	STE_CSWNSERVICECOST	numeric(10) default null,
--	STE_CSWNSTWK	SMALLINT default null,
--	STE_CSWNWOID	varchar(10) default null;

--IF COLUMNPROPERTY(OBJECT_ID('dbo.jobplan'), 'STE_CSWNWORKDAY', 'ColumnId') is null
--ALTER TABLE jobplan
--ADD STE_CSWNWORKDAY	SMALLINT default null,
--	STE_CSWNWPTYPE	varchar(10) default null,
--	STE_CWEQCODE	varchar(25) default null;

-- --------------
-- JPASSETSPLINK
-- --------------

-- Add custom columns
-- ------------------
IF COLUMNPROPERTY(OBJECT_ID('dbo.jpassetsplink'), 'STE_MIGRATIONID', 'ColumnId') is null
ALTER TABLE jpassetsplink
ADD STE_MIGRATIONID bigint default null,
    STE_MIGRATIONDATE datetime NOT NULL DEFAULT (GETDATE());

--IF COLUMNPROPERTY(OBJECT_ID('dbo.jpassetsplink'), 'STE_CWEQCODE', 'ColumnId') is null
--ALTER TABLE jpassetsplink
--ADD STE_CWEQCODE	varchar(25) default null;

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0511_Misc_JPAssetsPLink_pre;
GO

CREATE PROCEDURE ste_0511_Misc_JPAssetsPLink_pre 
	@PackageLogID INT
AS
BEGIN
	-- truncate existing data
	delete from jpassetsplink where STE_MIGRATIONID is not null;

END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0511_Misc_JPAssetsPLink_post
GO

CREATE PROCEDURE ste_0511_Misc_JPAssetsPLink_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_cnt int;
	declare @v_max_id bigint;
	declare @PackageName varchar(250);

	-- update identity column
	select @v_max_id=max(jpassetsplinkid) from jpassetsplink;
	update maxsequence set maxreserved=coalesce(@v_max_id,0)+1 where tbname='JPASSETSPLINK' and name='JPASSETSPLINKID';

	-- get package name
	select @PackageName = package_name from [dbo].[ste_migration_logs] where id = @PackageLogID;
	if (@PackageName is null) return;

	-- update start_id and end_id for ITEM_
	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from jpassetsplink
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
		, 'JPASSETSPLINK'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

END
GO


-- --------------
-- JOBTASK
-- --------------

-- Add custom columns
-- ------------------
IF COLUMNPROPERTY(OBJECT_ID('dbo.jobtask'), 'STE_MIGRATIONID', 'ColumnId') is null
ALTER TABLE jobtask
ADD STE_MIGRATIONID bigint default null,
    STE_MIGRATIONDATE datetime NOT NULL DEFAULT (GETDATE());

--IF COLUMNPROPERTY(OBJECT_ID('dbo.jobtask'), 'STE_CWEQCODE', 'ColumnId') is null
--ALTER TABLE jobtask
--ADD STE_CWEQCODE	varchar(25) default null,
--	STE_CSWNINTERVAL	numeric(12) default null,
--	STE_CSWNINTERVALUNIT	varchar(8) default null;

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0511_Misc_JobTask_pre;
GO

CREATE PROCEDURE ste_0511_Misc_JobTask_pre 
	@PackageLogID INT
AS
BEGIN
	-- truncate existing data
	delete from jobtask where STE_MIGRATIONID is not null;

END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0511_Misc_JobTask_post
GO

CREATE PROCEDURE ste_0511_Misc_JobTask_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_cnt int;
	declare @v_max_id bigint;
	declare @PackageName varchar(250);

	-- update identity column
	select @v_max_id=max(jobtaskid) from jobtask;
	update maxsequence set maxreserved=coalesce(@v_max_id,0)+1 where tbname='JOBTASK' and name='JOBTASKID';

	-- get package name
	select @PackageName = package_name from [dbo].[ste_migration_logs] where id = @PackageLogID;
	if (@PackageName is null) return;

	-- update start_id and end_id for ITEM_
	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from jobtask
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
		, 'JOBTASK'
		, 'COMPLETED'
		, CONCAT('COUNT: ', coalesce(@v_cnt,0), ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
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
           ('0511_Misc_JobPlan_JPAssetsPLink_JobTask'
           ,'version'
           ,'2'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO