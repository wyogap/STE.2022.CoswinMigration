/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- Add custom columns
-- ------------------
ALTER TABLE [ROUTES]
ADD STE_MIGRATIONID bigint default null,
    STE_MIGRATIONDATE datetime NOT NULL DEFAULT (GETDATE());

-- force make sure eqcode from coswin is not truncated
ALTER TABLE [ROUTES]
ALTER COLUMN [route] varchar(20) NOT NULL;

ALTER TABLE [ROUTES]
ALTER COLUMN [routestopsbecome] varchar(20) NOT NULL;

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_009_master_routes_pre
GO

CREATE PROCEDURE ste_009_master_routes_pre 
	@PackageLogID INT
AS
BEGIN
	declare @v_max_id bigint;

	-- truncate existing data
	truncate table [routes];

	---- enable identity column LOCATIONS.LOCATIONSID (by using temporary column for identity)
	--ALTER TABLE meter
	--ADD _METERID bigint IDENTITY;

END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_009_master_routes_post
GO

CREATE PROCEDURE ste_009_master_routes_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_max_id bigint;

	-- update identity column
	select @v_max_id=max(routesid) from [ROUTES];

	-- update maximo seq
	update maxsequence set maxreserved=@v_max_id+1 where tbname='ROUTES' and name='ROUTESID';

	-- update start_id and end_id
	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID) from [ROUTES];

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
           ('0009_Master_Routes'
           ,'version'
           ,'1'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO