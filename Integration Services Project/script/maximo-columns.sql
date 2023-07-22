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

IF COLUMNPROPERTY(OBJECT_ID('dbo.asset'), 'ste_inchrgref', 'ColumnId') is null
ALTER TABLE asset
ADD ste_inchrgref varchar(20) default null;

IF COLUMNPROPERTY(OBJECT_ID('dbo.ASSET'), 'ste_cswncapacity', 'ColumnId') IS NULL
ALTER TABLE ASSET
ADD ste_cswncapacity varchar(50) default null,
	ste_cswnrating varchar(50) default null,
	ste_cswnmtbfunit varchar(50) default null,
	ste_manufactmttr varchar(50) default null,
	ste_cswnmttrunit varchar(50) default null;

IF COLUMNPROPERTY(OBJECT_ID('dbo.ASSET'), 'ste_cswnmeterid', 'ColumnId') IS NULL
ALTER TABLE ASSET
ADD ste_cswnmeterid varchar(50) default null,
	ste_cswnregno varchar(50) default null,
	ste_cswncountry varchar(50) default null,
	ste_cswnmanfyy int default null,
	ste_cswnmanfmm int default null,
	ste_cswnarrvyy int default null,
	ste_cswnarrvmm int default null,
	ste_cswnminlifeyy int default null,
	ste_cswnminlifemm int default null,
	ste_cswnminlifemeter int default null,
	ste_cswnmaxlifeyy int default null,
	ste_cswnmaxlifemm int default null,
	ste_cswnmaxlifemeter int default null,
	ste_cswnserialno varchar(50) default null;
;

IF COLUMNPROPERTY(OBJECT_ID('dbo.asset'), 'ste_cswneqpcatg', 'ColumnId') is null
ALTER TABLE asset
ADD ste_cswneqpcatg varchar(10) default null;

--ALTER TABLE ASSET
--ALTER COLUMN pluscmodelnum varchar(24) NOT NULL;

IF COLUMNPROPERTY(OBJECT_ID('dbo.prline'), 'ste_cswnwbsnum', 'ColumnId') IS NULL
ALTER TABLE prline
ADD ste_cswnwbsnum varchar(20) default null,
	ste_cswnprefsupl varchar(20) default null,
	ste_cswncurrencycode varchar(8) default null,
	ste_cswnprstatus smallint default null,
	ste_cswncostcenter varchar(16) default null
;

IF COLUMNPROPERTY(OBJECT_ID('dbo.po'), 'ste_cswnpotype', 'ColumnId') IS NULL
ALTER TABLE [po]
ADD ste_cswnpotype smallint default null;
	
IF COLUMNPROPERTY(OBJECT_ID('dbo.poline'), 'ste_cswnpendingqty', 'ColumnId') IS NULL
ALTER TABLE poline
ADD ste_cswnpendingqty decimal(15,2) default null,
    ste_cswninvqty decimal(15,2) default null;
	
IF COLUMNPROPERTY(OBJECT_ID('dbo.rfqvendor'), 'ste_cswnnotes', 'ColumnId') IS NULL
ALTER TABLE [rfqvendor]
ADD ste_cswnnotes varchar(100) default null,
	ste_cswnwbsnum varchar(20) default null
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

IF COLUMNPROPERTY(OBJECT_ID('dbo.COMPCONTACTMSTR'), 'ste_contacttype', 'ColumnId') IS NULL
ALTER TABLE COMPCONTACTMSTR
ADD ste_contacttype VARCHAR(20) default null;

-- to fix
IF COLUMNPROPERTY(OBJECT_ID('dbo.jobtask'), 'ste_cswnactcode', 'ColumnId') is null
ALTER TABLE jobtask
ADD ste_cswnactcode varchar(10) default null;

IF COLUMNPROPERTY(OBJECT_ID('dbo.pm'), 'ste_cswnjobid', 'ColumnId') is null
ALTER TABLE pm
ADD ste_cswnjobid varchar(16) default null;

--alter table dbo.pm
--alter column pmnum varchar(16);

IF COLUMNPROPERTY(OBJECT_ID('dbo.pmseasons'), 'ste_cswnstartwk', 'ColumnId') is null
ALTER TABLE pmseasons
ADD ste_cswnstartwk smallint default null,
    ste_cswnendwk smallint default null;
	
--alter table dbo.prline
--alter column prnum varchar(16);

--alter table dbo.rfqline
--alter column rfqnum varchar(16);

--alter table dbo.pm
--alter column pmnum varchar(16);

--alter table dbo.prline
--alter column prnum varchar(16);

--alter table dbo.rfqline
--alter column rfqnum varchar(16);

IF COLUMNPROPERTY(OBJECT_ID('dbo.CURRENCY'), 'ste_cswnctrycd', 'ColumnId') is null
ALTER TABLE CURRENCY
ADD ste_cswnctrycd varchar(4) default null,
	ste_cswnctryname varchar(16) default null,
	ste_cswndpt smallint default null;

IF COLUMNPROPERTY(OBJECT_ID('dbo.matrectrans'), 'ste_cswninspdate', 'ColumnId') is null
ALTER TABLE matrectrans
ADD ste_cswninspdate datetime,
	ste_cswninspstat int,
	ste_cswngrnref varchar(10);

IF COLUMNPROPERTY(OBJECT_ID('dbo.matrectrans'), 'ste_cswndndate', 'ColumnId') is null
ALTER TABLE matrectrans
ADD ste_cswndndate datetime default null,
	ste_cswnrctstatus smallint,
	ste_cswngrnnum varchar(10) default null,
	ste_cswngrndate datetime default null,
	ste_cswnreceipttype smallint default null,
	ste_cswncc varchar(16) default null,
	ste_cswninspref varchar(10) default null;

IF COLUMNPROPERTY(OBJECT_ID('dbo.matrectrans'), 'remark_longdescription', 'ColumnId') is null
ALTER TABLE matrectrans
ADD remark_longdescription text;

IF COLUMNPROPERTY(OBJECT_ID('dbo.po'), 'ste_cswnreceiptremark', 'ColumnId') is null
ALTER TABLE po
ADD ste_cswnreceiptremark text;

-- to change to lower case!!!
IF COLUMNPROPERTY(OBJECT_ID('dbo.jobplan'), 'ste_cswnjobid', 'ColumnId') is null
ALTER TABLE jobplan
ADD ste_cswnjobid varchar(16) default null;

IF COLUMNPROPERTY(OBJECT_ID('dbo.jobtask'), 'ste_cswnactcode', 'ColumnId') is null
ALTER TABLE jobtask
ADD ste_cswnactcode varchar(10) default null;

IF COLUMNPROPERTY(OBJECT_ID('dbo.jobplan'), 'ste_cswnavprtm', 'ColumnId') is null
ALTER TABLE jobplan
ADD ste_cswnavprtm	smallint default null,
	ste_cswncc	varchar(16) default null,
	ste_cswnday	smallint default null,
	ste_cswndurationunit	varchar(5) default null,
	ste_cswnenwk	smallint default null,
	ste_cswnhazard	smallint default null,
	ste_cswnjbbhu	smallint default null,
	ste_cswnjobclass	varchar(6) default null,
	ste_cswnjobtype	varchar(6) default null,
	ste_cswnlaborcost	numeric(10) default null,
	ste_cswnljml	float default null,
	ste_cswnmaterialcost	numeric(10) default null,
	ste_cswnmiprtm	smallint default null,
	ste_cswnmtid	varchar(16) default null,
	ste_cswnmtprml	decimal(15) default null,
	ste_cswnmxprtm	smallint default null,
	ste_cswnnowo	smallint default null,
	ste_cswnpr_unit	smallint default null,
	ste_cswnprjref	varchar(10) default null,
	ste_cswnservicecost	numeric(10) default null,
	ste_cswnstwk	smallint default null,
	ste_cswnwoid	varchar(10) default null;
	
IF COLUMNPROPERTY(OBJECT_ID('dbo.jobplan'), 'ste_cswnworkday', 'ColumnId') is null
ALTER TABLE jobplan
ADD ste_cswnworkday	smallint default null,
	ste_cswnwptype	varchar(10) default null,
	ste_cweqcode	varchar(25) default null;
	
IF COLUMNPROPERTY(OBJECT_ID('dbo.jpassetsplink'), 'ste_cweqcode', 'ColumnId') is null
ALTER TABLE jpassetsplink
ADD ste_cweqcode	varchar(25) default null;

IF COLUMNPROPERTY(OBJECT_ID('dbo.jobtask'), 'ste_cweqcode', 'ColumnId') is null
ALTER TABLE jobtask
ADD ste_cweqcode	varchar(25) default null,
	ste_cswninterval	numeric(12) default null,
	ste_cswnintervalunit	varchar(8) default null;

IF COLUMNPROPERTY(OBJECT_ID('dbo.pm'), 'ste_cswncc', 'ColumnId') is null
ALTER TABLE pm
ADD ste_cswncc	varchar(16) default null,
	ste_cswncostype	varchar(10) default null,
	ste_cswnintervalunit	varchar(8) default null,
	ste_cswnjobbehaviour	smallint default null,
	ste_cswnjoblevel	smallint default null,
	ste_cswnlastwonum	varchar(10) default null,
	ste_cswnmaxinterval	numeric(12) default null,
	ste_cswnmininterval	numeric(12) default null,
	ste_cswnmult	smallint default null,
	ste_cswnshift	smallint default null,
	ste_cswnworkday	smallint default null,
	ste_cweqcode	varchar(25) default null;

IF COLUMNPROPERTY(OBJECT_ID('dbo.pm'), 'ste_cswnjobid', 'ColumnId') is null
ALTER TABLE pm
ADD ste_cswnjobid varchar(16) default null;

IF COLUMNPROPERTY(OBJECT_ID('dbo.pmseasons'), 'ste_cswnstartwk', 'ColumnId') is null
ALTER TABLE pmseasons
ADD ste_cswnstartwk smallint default null,
    ste_cswnendwk smallint default null;
	
IF COLUMNPROPERTY(OBJECT_ID('dbo.pmmeter'), 'ste_cswnfrequnit', 'ColumnId') is null
ALTER TABLE pmmeter
ADD ste_cswnfrequnit	smallint default null;

IF COLUMNPROPERTY(OBJECT_ID('dbo.assetmeter'), 'ste_cswnconstant', 'ColumnId') is null
ALTER TABLE assetmeter
ADD ste_cswnconstant decimal(15,5) default null,
	ste_cswnforecast float default null;

IF COLUMNPROPERTY(OBJECT_ID('dbo.meter'), 'ste_cswndefaultvalue', 'ColumnId') is null
ALTER TABLE meter
ADD ste_cswndefaultvalue decimal(15,5) default null,
    ste_cswnmetertype varchar(25) default null;

IF COLUMNPROPERTY(OBJECT_ID('dbo.matusetrans'), 'ste_replflag', 'ColumnId') is null
ALTER TABLE matusetrans
ADD ste_replflag varchar(3) default null,
	ste_plnflag varchar(3) default null;


IF COLUMNPROPERTY(OBJECT_ID('dbo.invoiceline'), 'STE_CSWNDISCOUNT', 'ColumnId') is null
ALTER TABLE invoiceline
ADD
STE_CSWNDISCOUNT	DECIMAL	(10,2) default null,
STE_CSWNLOCALHANDLINGCHARGE	DECIMAL	(10,2) default null,
STE_CSWNOTHERCHARGES	DECIMAL	(10,2) default null;


-- use workordernum as autokey
update autokey 
set
	autokeyname='WORKORDERNUM'
	, orgid='SBST'
where autokeyname='WONUM';

IF COLUMNPROPERTY(OBJECT_ID('dbo.matrectrans'), 'ste_cswnsapgl', 'ColumnId') is null
ALTER TABLE matrectrans
ADD ste_cswnsapgl varchar(20) default null;

IF COLUMNPROPERTY(OBJECT_ID('dbo.prline'), 'ste_cswnsapgl', 'ColumnId') IS NULL
ALTER TABLE prline
ADD ste_cswnsapgl varchar(20) default null;

IF COLUMNPROPERTY(OBJECT_ID('dbo.po'), 'ste_cswnsapgl', 'ColumnId') IS NULL
ALTER TABLE [po]
ADD ste_cswnsapgl varchar(20) default null;

IF COLUMNPROPERTY(OBJECT_ID('dbo.rfqvendor'), 'ste_cswnsapgl', 'ColumnId') IS NULL
ALTER TABLE [rfqvendor]
ADD ste_cswnsapgl varchar(20) default null;

IF COLUMNPROPERTY(OBJECT_ID('dbo.assetmeter'), 'ste_cswnfrequency', 'ColumnId') IS NULL
ALTER TABLE assetmeter add	
	ste_cswnfrequency	INTEGER	
	,ste_cswnfrequencyunit	varchar(50)
	,ste_cswnassetid	nvarchar(50)
	,ste_cswntotalcumrununit float
	,ste_cswnstartdate datetime;
 
IF COLUMNPROPERTY(OBJECT_ID('dbo.assetmeter'), 'ste_mtlastread', 'ColumnId') IS NULL
ALTER TABLE assetmeter add	
	ste_mtlastread varchar(50);	

IF COLUMNPROPERTY(OBJECT_ID('dbo.invoiceline'), 'ste_cswndiscount', 'ColumnId') IS NULL
ALTER TABLE invoiceline add	
ste_cswndiscount decimal (10, 2) default null,
ste_cswnlocalhandlingcharge decimal (10, 2)default null,
ste_cswnothercharges decimal(10, 2)default null
;	

IF COLUMNPROPERTY(OBJECT_ID('dbo.[matrectrans]'), 'ste_cswnfwdr', 'ColumnId') IS NULL
ALTER TABLE [matrectrans]
ADD ste_cswnfwdr varchar(15) default null,
	ste_cswnreceiptchangedate datetime default null,
	ste_cswnreceiptforwarder varchar(20) default null,
	ste_cswnrecwo varchar(20) default null
	;

IF COLUMNPROPERTY(OBJECT_ID('dbo.[labor]'), 'ste_cswnpaidhrs', 'ColumnId') IS NULL
ALTER TABLE labor
ADD ste_cswnpaidhrs int default null,
	ste_cswnwrenchhrs int default null;

--ALTER TABLE routes
--ALTER COLUMN [route] varchar(20) NOT NULL;

IF COLUMNPROPERTY(OBJECT_ID('dbo.invoice'), 'ste_cswndnref', 'ColumnId') IS NULL
ALTER TABLE [invoice]
ADD ste_cswndnref varchar(10) default null,
	ste_cswndonum varchar(10) default null,
	ste_cswndodate datetime default null,
	ste_cswnwbsnum varchar(20) default null
;

IF COLUMNPROPERTY(OBJECT_ID('dbo.invoice'), 'ste_cswndnref', 'ColumnId') IS NULL
ALTER TABLE quotationline
ADD ste_cswnaltprice1 decimal(10,2) default null,
	ste_cswnaltprice2 decimal(10,2) default null
;

IF COLUMNPROPERTY(OBJECT_ID('dbo.INVOICE'), 'ste_cswnbaseval', 'ColumnId') is null
ALTER TABLE INVOICE
ADD ste_cswnbaseval decimal(18,2) default null,
	ste_cswnlocalhandlingcharge decimal(18,2) default null,
	ste_cswnothercharges decimal(18,2) default null,
	ste_cswninvadj decimal(18,2) default null;

IF COLUMNPROPERTY(OBJECT_ID('dbo.invoice'), 'ste_cswncnstatus', 'ColumnId') IS NULL
ALTER TABLE invoice
ADD ste_cswncnstatus smallint default null,
	ste_cswninvadjstatus smallint default null, 
	ste_gstcode varchar(20) default null;	

IF COLUMNPROPERTY(OBJECT_ID('dbo.invoicecost'), 'ste_cswncnstatus', 'ColumnId') IS NULL
ALTER TABLE invoicecost
ADD ste_cswnsapgl varchar(20) default null;
	
IF COLUMNPROPERTY(OBJECT_ID('dbo.invoicecost'), 'ste_cswncc', 'ColumnId') IS NULL
ALTER TABLE invoicecost
ADD ste_cswncc varchar(16) default null;

