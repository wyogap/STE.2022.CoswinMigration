/****** Object:  Table [dbo].[ste_migration_params]    Script Date: 25/01/2023 17:46:34 ******/
-- Add custom columns
-- ------------------
ALTER TABLE AssetAttribute
ADD STE_MIGRATIONID bigint default null,
    STE_MIGRATIONDATE datetime NOT NULL DEFAULT (GETDATE());

-- Create pre-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_007_master_AssetAttribute_pre
GO

CREATE PROCEDURE ste_007_master_AssetAttribute_pre 
	@PackageLogID INT
AS
BEGIN
	declare @v_max_id bigint;

	-- truncate existing data
	truncate table AssetAttribute;

	---- enable identity column LOCATIONS.LOCATIONSID (by using temporary column for identity)
	--ALTER TABLE AssetAttribute
	--ADD _AssetAttributeID bigint IDENTITY;

END

GO

-- Create insert
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_007_master_AssetAttribute_insert
GO

CREATE PROCEDURE ste_007_master_AssetAttribute_insert
  @PackageLogID INT
AS
BEGIN

	INSERT [dbo].[AssetAttribute] ([ASSETATTRID], [DESCRIPTION], [DATATYPE], [MEASUREUNITID], [DOMAINID], [SITEID], [ORGID], [ASSETATTRIBUTEID], [STE_MIGRATIONID]) VALUES (N'MODEL', N'Equipment''s model number', N'ALN', N'', NULL, N'NEL', N'SBST', CAST(1 AS Numeric(38, 0)), CAST(1 AS Numeric(38, 0)));
	INSERT [dbo].[AssetAttribute] ([ASSETATTRID], [DESCRIPTION], [DATATYPE], [MEASUREUNITID], [DOMAINID], [SITEID], [ORGID], [ASSETATTRIBUTEID], [STE_MIGRATIONID]) VALUES (N'CAPACITY', N'Equipment Capacity', N'ALN', N'', NULL, N'NEL', N'SBST', CAST(2 AS Numeric(38, 0)), CAST(2 AS Numeric(38, 0)));
	INSERT [dbo].[AssetAttribute] ([ASSETATTRID], [DESCRIPTION], [DATATYPE], [MEASUREUNITID], [DOMAINID], [SITEID], [ORGID], [ASSETATTRIBUTEID], [STE_MIGRATIONID]) VALUES (N'RATING', N'Equipment Rating', N'ALN', N'', NULL, N'NEL', N'SBST', CAST(3 AS Numeric(38, 0)), CAST(3 AS Numeric(38, 0)));
	INSERT [dbo].[AssetAttribute] ([ASSETATTRID], [DESCRIPTION], [DATATYPE], [MEASUREUNITID], [DOMAINID], [SITEID], [ORGID], [ASSETATTRIBUTEID], [STE_MIGRATIONID]) VALUES (N'METER-ID', N'Equipment''s Meter identifier', N'ALN', N'', NULL, N'NEL', N'SBST', CAST(4 AS Numeric(38, 0)), CAST(4 AS Numeric(38, 0)));
	INSERT [dbo].[AssetAttribute] ([ASSETATTRID], [DESCRIPTION], [DATATYPE], [MEASUREUNITID], [DOMAINID], [SITEID], [ORGID], [ASSETATTRIBUTEID], [STE_MIGRATIONID]) VALUES (N'MTBF', N'Equipment''s Medium Time Before Failure', N'NUMBER', N'', NULL, N'NEL', N'SBST', CAST(5 AS Numeric(38, 0)), CAST(5 AS Numeric(38, 0)));
	INSERT [dbo].[AssetAttribute] ([ASSETATTRID], [DESCRIPTION], [DATATYPE], [MEASUREUNITID], [DOMAINID], [SITEID], [ORGID], [ASSETATTRIBUTEID], [STE_MIGRATIONID]) VALUES (N'MTBF-UNIT', N'MTBF measurement unit', N'ALN', N'', NULL, N'NEL', N'SBST', CAST(6 AS Numeric(38, 0)), CAST(6 AS Numeric(38, 0)));
	INSERT [dbo].[AssetAttribute] ([ASSETATTRID], [DESCRIPTION], [DATATYPE], [MEASUREUNITID], [DOMAINID], [SITEID], [ORGID], [ASSETATTRIBUTEID], [STE_MIGRATIONID]) VALUES (N'MTTR', N'Equipment''s Mean Time To Repair', N'NUMBER', N'', NULL, N'NEL', N'SBST', CAST(7 AS Numeric(38, 0)), CAST(7 AS Numeric(38, 0)));
	INSERT [dbo].[AssetAttribute] ([ASSETATTRID], [DESCRIPTION], [DATATYPE], [MEASUREUNITID], [DOMAINID], [SITEID], [ORGID], [ASSETATTRIBUTEID], [STE_MIGRATIONID]) VALUES (N'MTTR-UNIT', N'MTTR measurement unit', N'ALN', N'', NULL, N'NEL', N'SBST', CAST(8 AS Numeric(38, 0)), CAST(8 AS Numeric(38, 0)));
	INSERT [dbo].[AssetAttribute] ([ASSETATTRID], [DESCRIPTION], [DATATYPE], [MEASUREUNITID], [DOMAINID], [SITEID], [ORGID], [ASSETATTRIBUTEID], [STE_MIGRATIONID]) VALUES (N'REG-NO', N'The registration number of the equipment', N'ALN', N'', NULL, N'NEL', N'SBST', CAST(9 AS Numeric(38, 0)), CAST(9 AS Numeric(38, 0)));
	INSERT [dbo].[AssetAttribute] ([ASSETATTRID], [DESCRIPTION], [DATATYPE], [MEASUREUNITID], [DOMAINID], [SITEID], [ORGID], [ASSETATTRIBUTEID], [STE_MIGRATIONID]) VALUES (N'COUNTRY', N'The country of origin of this equipment', N'ALN', N'', NULL, N'NEL', N'SBST', CAST(10 AS Numeric(38, 0)), CAST(10 AS Numeric(38, 0)));
	INSERT [dbo].[AssetAttribute] ([ASSETATTRID], [DESCRIPTION], [DATATYPE], [MEASUREUNITID], [DOMAINID], [SITEID], [ORGID], [ASSETATTRIBUTEID], [STE_MIGRATIONID]) VALUES (N'MANF-YY', N'Equipment''s manufacturing YEAR', N'NUMBER', N'', NULL, N'NEL', N'SBST', CAST(11 AS Numeric(38, 0)), CAST(11 AS Numeric(38, 0)));
	INSERT [dbo].[AssetAttribute] ([ASSETATTRID], [DESCRIPTION], [DATATYPE], [MEASUREUNITID], [DOMAINID], [SITEID], [ORGID], [ASSETATTRIBUTEID], [STE_MIGRATIONID]) VALUES (N'MANF-MM', N'Equipment''s manufacturing month', N'NUMBER', N'', NULL, N'NEL', N'SBST', CAST(12 AS Numeric(38, 0)), CAST(12 AS Numeric(38, 0)));
	INSERT [dbo].[AssetAttribute] ([ASSETATTRID], [DESCRIPTION], [DATATYPE], [MEASUREUNITID], [DOMAINID], [SITEID], [ORGID], [ASSETATTRIBUTEID], [STE_MIGRATIONID]) VALUES (N'ARRV-YY', N'Equipment''s arrival YEAR', N'NUMBER', N'', NULL, N'NEL', N'SBST', CAST(13 AS Numeric(38, 0)), CAST(13 AS Numeric(38, 0)));
	INSERT [dbo].[AssetAttribute] ([ASSETATTRID], [DESCRIPTION], [DATATYPE], [MEASUREUNITID], [DOMAINID], [SITEID], [ORGID], [ASSETATTRIBUTEID], [STE_MIGRATIONID]) VALUES (N'ARRV-MM', N'Equipment''s arrival month', N'NUMBER', N'', NULL, N'NEL', N'SBST', CAST(14 AS Numeric(38, 0)), CAST(14 AS Numeric(38, 0)));
	INSERT [dbo].[AssetAttribute] ([ASSETATTRID], [DESCRIPTION], [DATATYPE], [MEASUREUNITID], [DOMAINID], [SITEID], [ORGID], [ASSETATTRIBUTEID], [STE_MIGRATIONID]) VALUES (N'MAXLIFE-YY', N'Equipment''s maximum expected life, specified in terms of years', N'NUMBER', N'', NULL, N'NEL', N'SBST', CAST(15 AS Numeric(38, 0)), CAST(15 AS Numeric(38, 0)));
	INSERT [dbo].[AssetAttribute] ([ASSETATTRID], [DESCRIPTION], [DATATYPE], [MEASUREUNITID], [DOMAINID], [SITEID], [ORGID], [ASSETATTRIBUTEID], [STE_MIGRATIONID]) VALUES (N'MAXLIFE-MM', N'Equipment''s maximum expected life, specified in terms of MONTH', N'NUMBER', N'', NULL, N'NEL', N'SBST', CAST(16 AS Numeric(38, 0)), CAST(16 AS Numeric(38, 0)));
	INSERT [dbo].[AssetAttribute] ([ASSETATTRID], [DESCRIPTION], [DATATYPE], [MEASUREUNITID], [DOMAINID], [SITEID], [ORGID], [ASSETATTRIBUTEID], [STE_MIGRATIONID]) VALUES (N'MAXLIFE-METER', N'Equipment''s maximum expected life, specified in terms of meter units', N'NUMBER', N'', NULL, N'NEL', N'SBST', CAST(17 AS Numeric(38, 0)), CAST(17 AS Numeric(38, 0)));
	INSERT [dbo].[AssetAttribute] ([ASSETATTRID], [DESCRIPTION], [DATATYPE], [MEASUREUNITID], [DOMAINID], [SITEID], [ORGID], [ASSETATTRIBUTEID], [STE_MIGRATIONID]) VALUES (N'MINLIFE-YY', N'Equipment''s minimum expected life, specified in terms of years', N'NUMBER', N'', NULL, N'NEL', N'SBST', CAST(18 AS Numeric(38, 0)), CAST(18 AS Numeric(38, 0)));
	INSERT [dbo].[AssetAttribute] ([ASSETATTRID], [DESCRIPTION], [DATATYPE], [MEASUREUNITID], [DOMAINID], [SITEID], [ORGID], [ASSETATTRIBUTEID], [STE_MIGRATIONID]) VALUES (N'MINLIFE-MM', N'Equipment''s minimum expected life, specified in terms of MONTH', N'NUMBER', N'', NULL, N'NEL', N'SBST', CAST(19 AS Numeric(38, 0)), CAST(19 AS Numeric(38, 0)));
	INSERT [dbo].[AssetAttribute] ([ASSETATTRID], [DESCRIPTION], [DATATYPE], [MEASUREUNITID], [DOMAINID], [SITEID], [ORGID], [ASSETATTRIBUTEID], [STE_MIGRATIONID]) VALUES (N'MINLIFE-METER', N'Equipment''s minimum expected life, specified in terms of meter units', N'NUMBER', N'', NULL, N'NEL', N'SBST', CAST(20 AS Numeric(38, 0)), CAST(20 AS Numeric(38, 0)));

END
GO

-- Create post-task
-- ---------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure if exists ste_007_master_AssetAttribute_post
GO

CREATE PROCEDURE ste_007_master_AssetAttribute_post
  @PackageLogID INT
AS
BEGIN
	declare @v_start_id int;
	declare @v_end_id int;
	declare @v_max_id bigint;

	-- update identity column
	select @v_max_id=max(AssetAttributeID) from AssetAttribute;

	--update AssetAttribute set AssetAttributeID = _AssetAttributeID;

	--alter table AssetAttribute drop column _AssetAttributeID;

	-- update maximo seq
	update maxsequence set maxreserved=@v_max_id+1 where tbname='AssetAttribute' and name='AssetAttributeID';

	-- update start_id and end_id
	select @v_start_id=min(STE_MIGRATIONID), @v_end_id=max(STE_MIGRATIONID) from AssetAttribute;

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
           ('0007_Master_AssetAttribute'
           ,'version'
           ,'1'
           ,getdate()
           ,'ssis'
           ,NULL
           ,NULL)
GO