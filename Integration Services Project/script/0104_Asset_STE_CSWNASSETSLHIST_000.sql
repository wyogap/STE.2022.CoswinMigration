---- Create custom table. This will be created through MAXIMO
IF OBJECT_ID(N'dbo.ste_cswnassetslhist', N'U') IS NULL
CREATE TABLE [dbo].ste_cswnassetslhist (
	ste_cweqcode [varchar](25) NOT NULL,
	ste_cswnsno [varchar](24) NOT NULL,
	ste_cswnsnodate datetime NOT NULL,
	ste_siteid [varchar](8) NULL,
	hasld smallint NOT NULL,
	[description] varchar(50) NULL,
	description_longdescription text NULL,
	ste_cswnassetslhistid [bigint] NOT NULL
) ON [PRIMARY]
GO

IF COLUMNPROPERTY(OBJECT_ID('dbo.ste_cswnassetslhist'), 'STE_MIGRATIONID', 'ColumnId') is null
ALTER TABLE [dbo].ste_cswnassetslhist
ADD [STE_MIGRATIONID] [bigint] NULL,
	[STE_MIGRATIONDATE] [datetime] NOT NULL;
GO


-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0104_Asset_STE_CSWNASSETSLHIST_pre
GO

CREATE PROCEDURE ste_0104_Asset_STE_CSWNASSETSLHIST_pre 
	@PackageLogID INT
AS
BEGIN
	declare @v_seed bigint;
	declare @v_max_id bigint;

	-- truncate existing data
	delete from dbo.ste_cswnassetslhist where STE_MIGRATIONID is not null;

	-- TODO: create sequence key
	select @v_seed=seed from [dbo].[autokey] where [autokeyname]='WONUM';
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
			,'WONUM'
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

drop procedure if exists ste_0104_Asset_STE_CSWNASSETSLHIST_post
GO

CREATE PROCEDURE ste_0104_Asset_STE_CSWNASSETSLHIST_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_cnt int;
	declare @v_max_id bigint;
	declare @PackageName varchar(250);

	-- update identity column
	select @v_max_id=max(ste_cswnassetslhistid) from ste_cswnassetslhist;
	update maxsequence set maxreserved=@v_max_id+1 where tbname='STE_CSWNASSETSLHIST' and name='STE_CSWNASSETSLHISTID';

	-- get package name
	select @PackageName = package_name from [dbo].[ste_migration_logs] where id = @PackageLogID;
	if (@PackageName is null) return;

	-- update start_id and end_id for ITEM_
	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID), @v_cnt=count(STE_MIGRATIONID) from ste_cswnassetslhist
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
		, 'STE_CSWNASSETSLHIST'
		, 'COMPLETED'
		, CONCAT('COUNT: ', @v_cnt, ', START_ID: ', @v_start_id, ', END_ID: ', @v_end_id)
	);

	-- update start_id and end_id
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
           ('0104_Asset_STE_CSWNASSETSLHIST'
           ,'version'
           ,'1'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO