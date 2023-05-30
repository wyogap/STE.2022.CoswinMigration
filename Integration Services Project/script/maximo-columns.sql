IF COLUMNPROPERTY(OBJECT_ID('dbo.ASSET'), 'ste_cweqcode', 'ColumnId') IS NULL
ALTER TABLE ASSET
ADD ste_cweqcode VARCHAR(100) default null,
	ste_cswneqpfunctn VARCHAR(10) default null,
	ste_cswnwptype VARCHAR(10) default null,
	ste_cswnwponcmwo CHAR(1) default null,
	ste_cswnauthority VARCHAR(16) default null,
	ste_system VARCHAR(4) default null,
	ste_subsystem VARCHAR(6) default null,
	ste_aisassetcode VARCHAR(38) default null,
	ste_aisassetid VARCHAR(18) default null,
	ste_aislocationcode VARCHAR(50) default null,
	ste_cswnassetid VARCHAR(40) default null,
	ste_cswnbarcode VARCHAR(20) default null,
	ste_cswnsystemequip VARCHAR(20) default null,
	ste_cswngt VARCHAR(12) default null,
	ste_cswnsnodate DATETIME default null,
	ste_manufactmtbf varchar(50) default null,
	ste_loccode VARCHAR(50) default null
	;

IF COLUMNPROPERTY(OBJECT_ID('dbo.ASSET'), 'ste_cswnmodelnum', 'ColumnId') IS NULL
ALTER TABLE ASSET
ADD ste_cswnmodelnum VARCHAR(24) default null;
	
IF COLUMNPROPERTY(OBJECT_ID('dbo.prline'), 'ste_cswnapglcode', 'ColumnId') IS NULL
ALTER TABLE prline
ADD ste_cswnapglcode varchar(20) default null,
	ste_cswnwbsnum varchar(20) default null,
	ste_cswnprefsupl varchar(20) default null,
	ste_cswncurrencycode varchar(8) default null,
	ste_cswnprstatus smallint default null,
	ste_cswncostcenter varchar(16) default null
;

IF COLUMNPROPERTY(OBJECT_ID('dbo.invoice'), 'ste_cswndnref', 'ColumnId') IS NULL
ALTER TABLE [invoice]
ADD ste_cswndnref varchar(10) default null,
	ste_cswndonum varchar(10) default null,
	ste_cswndodate datetime default null,
	ste_cswnwbsnum varchar(20) default null
;

IF COLUMNPROPERTY(OBJECT_ID('dbo.po'), 'ste_cswnapglcode', 'ColumnId') IS NULL
ALTER TABLE [po]
ADD ste_cswnapglcode varchar(20) default null,
    ste_cswnpotype smallint default null;
	
IF COLUMNPROPERTY(OBJECT_ID('dbo.poline'), 'ste_cswnpendingqty', 'ColumnId') IS NULL
ALTER TABLE poline
ADD ste_cswnpendingqty decimal(15,2) default null,
    ste_cswninvqty decimal(15,2) default null;
	
IF COLUMNPROPERTY(OBJECT_ID('dbo.rfqvendor'), 'ste_cswnnotes', 'ColumnId') IS NULL
ALTER TABLE [rfqvendor]
ADD ste_cswnnotes varchar(100) default null,
	ste_cswnapglcode varchar(20) default null,
	ste_cswnwbsnum varchar(20) default null
	;
	
IF COLUMNPROPERTY(OBJECT_ID('dbo.invoice'), 'ste_cswndnref', 'ColumnId') IS NULL
ALTER TABLE quotationline
ADD ste_cswnaltprice1 decimal(10,2) default null,
	ste_cswnaltprice2 decimal(10,2) default null
;

IF COLUMNPROPERTY(OBJECT_ID('dbo.COMPANIES'), 'ste_cswncountry', 'ColumnId') IS NULL
ALTER TABLE COMPANIES
ADD ste_cswncountry varchar(50) default null;
 
IF COLUMNPROPERTY(OBJECT_ID('dbo.COMPCONTACT'), 'ste_cswnvoicephone2', 'ColumnId') IS NULL
ALTER TABLE COMPCONTACT
ADD ste_cswnvoicephone2 varchar(50) default null,
    ste_contacttype varchar(50) default null;
	
IF COLUMNPROPERTY(OBJECT_ID('dbo.COMPMASTER'), 'ste_cswncountry', 'ColumnId') IS NULL
ALTER TABLE COMPMASTER
ADD ste_cswncountry varchar(50) default null;

IF COLUMNPROPERTY(OBJECT_ID('dbo.COMPCONTACTMSTR'), 'ste_cswnvoicephone2', 'ColumnId') IS NULL
ALTER TABLE COMPCONTACTMSTR
ADD ste_cswnvoicephone2 varchar(50) default null,
    ste_contacttype varchar(50) default null;
	
--ALTER TABLE ASSET
--ALTER COLUMN pluscmodelnum varchar(24) NOT NULL;

--ALTER TABLE prline
--ALTER COLUMN CONTRACTREFNUM varchar(10) NOT NULL;

---- need to disable index first
----ALTER TABLE rfqline
----ALTER COLUMN PONUM varchar(10) NOT NULL;

---- force make sure eqcode from coswin is not truncated
--ALTER TABLE [ROUTES]
--ALTER COLUMN [route] varchar(20) NOT NULL;

--ALTER TABLE [ROUTES]
--ALTER COLUMN [routestopsbecome] varchar(20) NOT NULL;

---- force make sure jobtype/worktype from coswin is not truncated (originally varchar(5))
--ALTER TABLE WORKORDER
--ALTER COLUMN WORKTYPE varchar(6);

---- force make sure failurecode from coswin is not truncated (originally varchar(8))
--ALTER TABLE WORKORDER
--ALTER COLUMN failurecode varchar(10);

---- force make sure equipmentcode from coswin is not truncated (originally varchar(12))
--ALTER TABLE WORKORDER
--ALTER COLUMN assetnum varchar(20);

---- make sure assetnum is not truncated (the same column in ASSET table is 24 char)
---- originally it is varchar(12)
--ALTER TABLE ASSETMETER
--ALTER COLUMN assetnum varchar(20) NOT NULL;

IF COLUMNPROPERTY(OBJECT_ID('dbo.workorder'), 'ste_cswnactionauth', 'ColumnId') IS NULL
ALTER TABLE [workorder]
ADD ste_cswnactionauth varchar(16) default null,
	ste_cswnactiondesc varchar(100) default null,
	ste_cswncc varchar(16) default null,
	ste_cswniexfl varchar(3) default null,
	ste_cswnprjref varchar(10) default null,
	ste_cswneqpcode varchar(20) default null,
	ste_cswnjbclu varchar(6) default null,
	ste_cswnjbcludesc varchar(100) default null,
	ste_cswnjobid varchar(16) default null,
	ste_cswnnewserialnum varchar(24) default null,
	ste_cswnreqdesc varchar(100) default null,
	ste_cswnrequestauth varchar(16) default null,
	ste_cswntotcumunits varchar(38) default null,
	ste_cswnwofnctn varchar(10) default null,
	ste_cswnwotype varchar(3) default null,
	ste_cswnwozone varchar(10) default null,
	ste_eqpphone varchar(13) default null;

--ALTER TABLE workorder
--ALTER COLUMN [route] varchar(20);

---- delete index dependent to problemcode
--drop index [workorder_ndx7] ON [dbo].[workorder];
--drop index [workorder_ndx9] ON [dbo].[workorder];

--ALTER TABLE workorder
--ALTER COLUMN [problemcode] varchar(10) NOT NULL;

---- recreate index
--SET ANSI_PADDING ON
--GO
--/****** Object:  Index [workorder_ndx7]    Script Date: 04/04/2023 15:14:53 ******/
--CREATE NONCLUSTERED INDEX [workorder_ndx7] ON [dbo].[workorder]
--(
--	[siteid] ASC,
--	[assetnum] ASC,
--	[problemcode] ASC,
--	[status] ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
--GO
--SET ANSI_PADDING ON
--GO
--/****** Object:  Index [workorder_ndx9]    Script Date: 04/04/2023 15:14:53 ******/
--CREATE NONCLUSTERED INDEX [workorder_ndx9] ON [dbo].[workorder]
--(
--	[siteid] ASC,
--	[location] ASC,
--	[problemcode] ASC,
--	[status] ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
--GO

--ALTER TABLE workorder
--ALTER COLUMN [justifypriority] varchar(100) NOT NULL;

--ALTER TABLE workorder
--ALTER COLUMN [contract] varchar(10) NOT NULL;

--ALTER TABLE workorder
--ALTER COLUMN [wonum] varchar(20) NOT NULL;

--ALTER TABLE workorder
--ALTER COLUMN [parent] varchar(20) NOT NULL;

IF COLUMNPROPERTY(OBJECT_ID('dbo.ticket'), 'ste_cswneqpcode', 'ColumnId') is null
ALTER TABLE ticket
ADD ste_cswneqpcode varchar(25) default null;

IF COLUMNPROPERTY(OBJECT_ID('dbo.ITEM'), 'ste_cswnbarcode', 'ColumnId') IS NULL
ALTER TABLE ITEM
ADD ste_cswnbarcode VARCHAR(20) default null;

-- custom columns
IF COLUMNPROPERTY(OBJECT_ID('dbo.PERSON'), 'ste_cswnemercontact', 'ColumnId') IS NULL
ALTER TABLE PERSON
ADD 
	ste_cswnemercontact	varchar(25)	 default null,
	ste_cswnidcard	varchar(16)	 default null,
	ste_cswnpassport	varchar(16)	 default null,
	ste_cswnworkerid	varchar(16)	 default null,
	ste_cswnsex	varchar(3)	 default null,
	ste_cswncompanyentity	varchar(16)	 default null,
	ste_cswnbarcode	varchar(16)	 default null,
	ste_cswncc	varchar(16)	 default null;
	
IF COLUMNPROPERTY(OBJECT_ID('dbo.qualification'), 'ste_cswnskillskill', 'ColumnId') is null
ALTER TABLE qualification
ADD ste_cswnskillskill varchar(10) default null;

IF COLUMNPROPERTY(OBJECT_ID('dbo.asset'), 'ste_inchrgref', 'ColumnId') is null
ALTER TABLE asset
ADD ste_inchrgref varchar(20) default null;

IF COLUMNPROPERTY(OBJECT_ID('dbo.workorder'), 'ste_cswnwoid', 'ColumnId') IS NULL
ALTER TABLE [workorder]
ADD ste_cswnwoid varchar(10) default null;

--ALTER TABLE jobplan
--ALTER COLUMN jpnum varchar(16) NOT NULL;

--ALTER TABLE rfqline
--ALTER COLUMN rfqnum varchar(16) NOT NULL;

--ALTER TABLE rfqline
--ALTER COLUMN ponum varchar(10);

--ALTER TABLE amcrew
--ALTER COLUMN amcrew varchar(10);

--ALTER TABLE amcrewlabor
--ALTER COLUMN amcrew varchar(10);

--ALTER TABLE amcrewlabor
--ALTER COLUMN craft varchar(10);

IF COLUMNPROPERTY(OBJECT_ID('dbo.workorder'), 'ste_cswnafcjrnum', 'ColumnId') IS NULL
ALTER TABLE [workorder]
ADD ste_cswnafcjrnum varchar(20) default null,
	ste_cswnoldsernum varchar(20) default null,
	ste_cswnnewsernum varchar(20) default null;

IF COLUMNPROPERTY(OBJECT_ID('dbo.jobplan'), 'STE_CSWNAVPRTM', 'ColumnId') is null
ALTER TABLE jobplan
ADD STE_CSWNAVPRTM	SMALLINT default null,
	STE_CSWNCC	varchar(16) default null,
	STE_CSWNDAY	SMALLINT default null,
	STE_CSWNDURATIONUNIT	varchar(5) default null,
	STE_CSWNENWK	SMALLINT default null,
	STE_CSWNHAZARD	SMALLINT default null,
	STE_CSWNJBBHU	SMALLINT default null,
	STE_CSWNJOBCLASS	varchar(6) default null,
	STE_CSWNJOBTYPE	varchar(6) default null,
	STE_CSWNLABORCOST	numeric(10) default null,
	STE_CSWNLJML	FLOAT default null,
	STE_CSWNMATERIALCOST	NUMERIC(10) default null,
	STE_CSWNMIPRTM	SMALLINT default null,
	STE_CSWNMTID	varchar(16) default null,
	STE_CSWNMTPRML	DECIMAL(15) default null,
	STE_CSWNMXPRTM	SMALLINT default null,
	STE_CSWNNOWO	SMALLINT default null,
	STE_CSWNPR_UNIT	SMALLINT default null,
	STE_CSWNPRJREF	varchar(10) default null,
	STE_CSWNSERVICECOST	numeric(10) default null,
	STE_CSWNSTWK	SMALLINT default null,
	STE_CSWNWOID	varchar(10) default null;
	
IF COLUMNPROPERTY(OBJECT_ID('dbo.jobplan'), 'STE_CSWNWORKDAY', 'ColumnId') is null
ALTER TABLE jobplan
ADD STE_CSWNWORKDAY	SMALLINT default null,
	STE_CSWNWPTYPE	varchar(10) default null,
	STE_CWEQCODE	varchar(25) default null;
	
IF COLUMNPROPERTY(OBJECT_ID('dbo.jpassetsplink'), 'STE_CWEQCODE', 'ColumnId') is null
ALTER TABLE jpassetsplink
ADD STE_CWEQCODE	varchar(25) default null;

IF COLUMNPROPERTY(OBJECT_ID('dbo.jobtask'), 'STE_CWEQCODE', 'ColumnId') is null
ALTER TABLE jobtask
ADD STE_CWEQCODE	varchar(25) default null,
	STE_CSWNINTERVAL	numeric(12) default null,
	STE_CSWNINTERVALUNIT	varchar(8) default null;

IF COLUMNPROPERTY(OBJECT_ID('dbo.pm'), 'STE_CSWNCC', 'ColumnId') is null
ALTER TABLE pm
ADD STE_CSWNCC	varchar(16) default null,
	STE_CSWNCOSTYPE	varchar(10) default null,
	STE_CSWNINTERVALUNIT	varchar(8) default null,
	STE_CSWNJOBBEHAVIOUR	SMALLINT default null,
	STE_CSWNJOBLEVEL	SMALLINT default null,
	STE_CSWNLASTWONUM	varchar(10) default null,
	STE_CSWNMAXINTERVAL	numeric(12) default null,
	STE_CSWNMININTERVAL	numeric(12) default null,
	STE_CSWNMULT	SMALLINT default null,
	STE_CSWNSHIFT	SMALLINT default null,
	STE_CSWNWORKDAY	SMALLINT default null,
	STE_CWEQCODE	varchar(25) default null;

IF COLUMNPROPERTY(OBJECT_ID('dbo.pmmeter'), 'STE_CSWNFREQUNIT', 'ColumnId') is null
ALTER TABLE pmmeter
ADD STE_CSWNFREQUNIT	smallint default null;

IF COLUMNPROPERTY(OBJECT_ID('dbo.matusetrans'), 'STE_REPLFLAG', 'ColumnId') is null
ALTER TABLE matusetrans
ADD STE_REPLFLAG varchar(3) default null,
	STE_PLNFLAG varchar(3) default null;

IF COLUMNPROPERTY(OBJECT_ID('dbo.COMPCONTACTMSTR'), 'ste_contacttype', 'ColumnId') IS NULL
ALTER TABLE COMPCONTACTMSTR
ADD ste_contacttype VARCHAR(20) default null;

IF COLUMNPROPERTY(OBJECT_ID('dbo.jobplan'), 'STE_CSWNJOBID', 'ColumnId') is null
ALTER TABLE jobplan
ADD STE_CSWNJOBID	varchar(16) default null;

IF COLUMNPROPERTY(OBJECT_ID('dbo.jobtask'), 'STE_CSWNACTCODE', 'ColumnId') is null
ALTER TABLE jobtask
ADD STE_CSWNACTCODE varchar(10) default null;

IF COLUMNPROPERTY(OBJECT_ID('dbo.pm'), 'STE_CSWNJOBID', 'ColumnId') is null
ALTER TABLE pm
ADD STE_CSWNJOBID varchar(16) default null;

--alter table dbo.pm
--alter column pmnum varchar(16);

IF COLUMNPROPERTY(OBJECT_ID('dbo.pmseasons'), 'STE_CSWNSTARTWK', 'ColumnId') is null
ALTER TABLE pmseasons
ADD STE_CSWNSTARTWK smallint default null,
    STE_CSWNENDWK smallint default null;