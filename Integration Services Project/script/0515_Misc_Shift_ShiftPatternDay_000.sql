/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- ------------
-- SHIFT
-- ------------

-- Add custom columns
-- ------------------
IF COLUMNPROPERTY(OBJECT_ID('dbo.shift'), 'STE_MIGRATIONID', 'ColumnId') is null
ALTER TABLE [shift]
ADD STE_MIGRATIONID bigint default null,
    STE_MIGRATIONDATE datetime NOT NULL DEFAULT (GETDATE());

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0515_Misc_Shift_pre
GO

CREATE PROCEDURE ste_0515_Misc_Shift_pre 
	@PackageLogID INT
AS
BEGIN
	-- truncate existing data
	delete from [shift] where STE_MIGRATIONID is not null;

END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0515_Misc_Shift_post
GO

CREATE PROCEDURE ste_0515_Misc_Shift_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_cnt int;
	declare @v_max_id bigint;
	declare @PackageName varchar(250);

	-- update identity column
	select @v_max_id=max(shiftid) from [shift];
	update maxsequence set maxreserved=coalesce(@v_max_id,0)+1 where tbname='SHIFT' and name='SHIFTID';

	-- get package name
	select @PackageName = package_name from [dbo].[ste_migration_logs] where id = @PackageLogID;
	if (@PackageName is null) return;

	-- update start_id and end_id for ITEM_
	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from [shift]
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
		, 'SHIFT'
		, 'COMPLETED'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	UPDATE [dbo].[ste_migration_logs] SET
	  [start_id] = @v_start_id
	, [end_id] = @v_end_id
	WHERE [id] = @PackageLogID

END
GO

-- ----------------
-- SHIFTPATTERNDAY
-- ----------------

-- Add custom columns
-- ------------------
IF COLUMNPROPERTY(OBJECT_ID('dbo.shiftpatternday'), 'STE_MIGRATIONID', 'ColumnId') is null
ALTER TABLE [shiftpatternday]
ADD STE_MIGRATIONID bigint default null,
    STE_MIGRATIONDATE datetime NOT NULL DEFAULT (GETDATE());

IF COLUMNPROPERTY(OBJECT_ID('dbo.shiftpatternday'), 'STE_CSWNASSISTANTS', 'ColumnId') is null
ALTER TABLE [shiftpatternday]
ADD STE_CSWNASSISTANTS	SMALLINT default null,
	STE_CSWNLEADERS	SMALLINT default null,
	STE_CSWNREQUIRED	SMALLINT default null,
	STE_CSWNSTAFF	SMALLINT default null,
	STE_CSWNTDCD	varchar(10) default null;

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0515_Misc_ShiftPatternDay_pre
GO

CREATE PROCEDURE ste_0515_Misc_ShiftPatternDay_pre 
	@PackageLogID INT
AS
BEGIN
	-- truncate existing data
	delete from [shiftpatternday] where STE_MIGRATIONID is not null;

END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0515_Misc_ShiftPatternDay_post
GO

CREATE PROCEDURE ste_0515_Misc_ShiftPatternDay_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_cnt int;
	declare @v_max_id bigint;
	declare @PackageName varchar(250);

	-- update identity column
	select @v_max_id=max(shiftpatterndayid) from [shiftpatternday];
	update maxsequence set maxreserved=coalesce(@v_max_id,0)+1 where tbname='SHIFTPATTERNDAY' and name='SHIFTPATTERNDAYID';

	-- get package name
	select @PackageName = package_name from [dbo].[ste_migration_logs] where id = @PackageLogID;
	if (@PackageName is null) return;

	-- update start_id and end_id for ITEM_
	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from [shiftpatternday]
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
		, 'SHIFTPATTERNDAY'
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
           ('0515_Misc_Shift_ShiftPatternDay'
           ,'version'
           ,'1'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO