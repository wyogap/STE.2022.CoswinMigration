/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- --------
-- PM
-- --------

-- Add custom columns
-- ------------------
IF COLUMNPROPERTY(OBJECT_ID('dbo.pm'), 'STE_CSWNJOBID', 'ColumnId') is null
ALTER TABLE pm
ADD STE_CSWNJOBID varchar(16) default null;

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

	-- create autokey if not exist
	select @v_seed=seed from [dbo].[autokey] where [autokeyname]='PMNUM';
	if (@v_seed is null)
	begin
		select @v_max_id=maxreserved from [dbo].[maxsequence] where [tbname]='AUTOKEY' and [name]='AUTOKEYID';
		
		insert into [dbo].[autokey] (
			[seed]
			,[autokeyname]
			,[langcode]
			,[autokeyid]
		)
		values (
			1000
			,'PMNUM'
			,'EN'
			,@v_max_id + 1
		);

		update maxsequence set maxreserved=@v_max_id+1 where tbname='AUTOKEY' and name='AUTOKEYID';
	end;

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

	-- update autokey
	select @v_max_id=max(cast(pmnum as int)) from pm;
	update autokey set seed=@v_max_id+1 where autokeyname='PMNUM';

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

-- ----------
-- PMSeasons
-- ----------

-- Add custom columns
-- ------------------
IF COLUMNPROPERTY(OBJECT_ID('dbo.pmseasons'), 'STE_CSWNSTARTWK', 'ColumnId') is null
ALTER TABLE pmseasons
ADD STE_CSWNSTARTWK smallint default null,
    STE_CSWNENDWK smallint default null;

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
           ,'2'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO