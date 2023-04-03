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