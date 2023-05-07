/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- Add custom columns
-- ------------------
IF COLUMNPROPERTY(OBJECT_ID('dbo.ITEM'), 'STE_MIGRATIONID', 'ColumnId') IS NULL
ALTER TABLE ITEM
ADD STE_MIGRATIONID bigint default null,
    STE_MIGRATIONDATE datetime NOT NULL DEFAULT (GETDATE());

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_010_master_item_pre;
drop procedure if exists ste_0010_master_item_pre;
GO

CREATE PROCEDURE ste_0010_master_item_pre 
	@PackageLogID INT
AS
BEGIN
	-- truncate existing data
	DELETE FROM [item] WHERE STE_MIGRATIONID IS NOT NULL;

END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_010_master_item_post;
drop procedure if exists ste_0010_master_item_post;
GO

CREATE PROCEDURE ste_0010_master_item_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_max_id bigint;

	-- update identity column
	select @v_max_id=max(itemid) from [ITEM];

	-- update maximo seq
	update maxsequence set maxreserved=@v_max_id+1 where tbname='ITEM' and name='ITEMID';

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
           ('0010_Master_Item_ItemOrgInfo'
           ,'version'
           ,'1'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO