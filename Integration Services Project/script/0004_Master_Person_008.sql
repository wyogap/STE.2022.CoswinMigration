-- -------
-- PERSON
-- -------

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_004_master_person_pre;
drop procedure if exists ste_0004_master_person_pre;
GO

CREATE PROCEDURE ste_0004_master_person_pre 
	@PackageLogID INT
AS
BEGIN
	-- truncate existing data
	delete from person where STE_MIGRATIONID is not null;

	-- truncate lookup table
	truncate table ste_migration_user_lookup;

END

GO

-- -------
-- PHONE
-- -------

-- Add custom columns
-- ------------------
IF COLUMNPROPERTY(OBJECT_ID('dbo.PHONE'), 'STE_MIGRATIONID', 'ColumnId') IS NULL
ALTER TABLE PHONE
ADD STE_MIGRATIONID bigint default null,
    STE_MIGRATIONDATE datetime NOT NULL DEFAULT (GETDATE());

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0004_master_phone_pre;
GO

CREATE PROCEDURE ste_0004_master_phone_pre 
	@PackageLogID INT
AS
BEGIN
	-- truncate existing data
	delete from phone where STE_MIGRATIONID is not null;

END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0004_master_phone_post;
GO

CREATE PROCEDURE ste_0004_master_phone_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_cnt int;
	declare @v_max_id bigint;
	declare @PackageName varchar(250);

	-- update maximo seq
	select @v_max_id=max(PHONEID) from PHONE;
	update maxsequence set maxreserved=@v_max_id+1 where tbname='PHONE' and name='PHONEID';

	-- get package name
	select @PackageName = package_name from [dbo].[ste_migration_logs] where id = @PackageLogID;
	if (@PackageName is null) return;

	-- update start_id and end_id
	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from phone
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
		, 'PHONE'
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
           ('0004_Master_Person'
           ,'version'
           ,'9'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO