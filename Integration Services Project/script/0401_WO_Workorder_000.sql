/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- Add custom columns
-- ------------------
IF COLUMNPROPERTY(OBJECT_ID('dbo.WORKORDER'), 'STE_MIGRATIONID', 'ColumnId') is null
ALTER TABLE WORKORDER
ADD STE_CSWNEQCD varchar(20) default null,
	STE_CSWNASSETID varchar(40) default null,
	STE_CSWNSYCD varchar(20) default null,
	STE_CSWNACTHRS float default null,
	STE_MIGRATIONID bigint default null,
    STE_MIGRATIONDATE datetime NOT NULL DEFAULT (GETDATE());

---- force make sure jobtype/worktype from coswin is not truncated (originally varchar(5))
--ALTER TABLE WORKORDER
--ALTER COLUMN WORKTYPE varchar(6);

---- force make sure failurecode from coswin is not truncated (originally varchar(8))
--ALTER TABLE WORKORDER
--ALTER COLUMN failurecode varchar(10);

---- force make sure equipmentcode from coswin is not truncated (originally varchar(12))
--ALTER TABLE WORKORDER
--ALTER COLUMN assetnum varchar(20);

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0201_WO_Workorder_pre
GO

CREATE PROCEDURE ste_0201_WO_Workorder_pre 
	@PackageLogID INT
AS
BEGIN
	-- truncate existing data
	truncate table WORKORDER;

END

GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_0201_WO_Workorder_post
GO

CREATE PROCEDURE ste_0201_WO_Workorder_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_max_id bigint;

	-- update identity column
	select @v_max_id=max(WORKORDERID) from WORKORDER;

	-- update maximo seq
	update maxsequence set maxreserved=@v_max_id+1 where tbname='WORKORDER' and name='WORKORDERID';

	-- update start_id and end_id
	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID) from WORKORDER;

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
           ('0201_WO_Workorder'
           ,'version'
           ,'1'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO