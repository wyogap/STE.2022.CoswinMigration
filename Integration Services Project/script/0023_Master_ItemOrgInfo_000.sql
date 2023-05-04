/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- Add custom columns
-- ------------------
IF COLUMNPROPERTY(OBJECT_ID('dbo.ITEMORGINFO'), 'STE_MIGRATIONID', 'ColumnId') IS NULL
ALTER TABLE ITEMORGINFO
ADD STE_MIGRATIONSOURCE VARCHAR(100) default null,
	STE_MIGRATIONID bigint default null,
    STE_MIGRATIONDATE datetime NOT NULL DEFAULT (GETDATE());

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0023_master_itemorginfo_pre;
GO

CREATE PROCEDURE ste_0023_master_itemorginfo_pre 
	@PackageLogID INT
AS
BEGIN
	-- truncate existing data
	DELETE FROM [itemorginfo] WHERE STE_MIGRATIONID IS NOT NULL;

END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0023_master_itemorginfo_post;
GO

CREATE PROCEDURE ste_0023_master_itemorginfo_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_max_id bigint;

	-- update identity column
	select @v_max_id=max(itemorginfoid) from [itemorginfo];

	-- update maximo seq
	update maxsequence set maxreserved=@v_max_id+1 where tbname='ITEMORGINFO' and name='ITEMORGINFOID';

	-- update start_id and end_id
	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID) from ITEM
	WHERE STE_MIGRATIONID IS NOT NULL;

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
           ('0023_Master_ItemOrgInfo'
           ,'version'
           ,'1'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO