--asset
IF COLUMNPROPERTY(OBJECT_ID('dbo.asset'), 'ste_cswnwptype', 'ColumnId') IS NULL ALTER TABLE asset ADD ste_cswnwptype VARCHAR(10) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.asset'), 'ste_cweqcode', 'ColumnId') IS NULL ALTER TABLE asset ADD ste_cweqcode VARCHAR(100) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.asset'), 'ste_cswnwponcmwo', 'ColumnId') IS NULL ALTER TABLE asset ADD ste_cswnwponcmwo CHAR(1) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.asset'), 'ste_cswnauthority', 'ColumnId') IS NULL ALTER TABLE asset ADD ste_cswnauthority VARCHAR(16) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.asset'), 'ste_cswneqpfunctn', 'ColumnId') IS NULL ALTER TABLE asset ADD ste_cswneqpfunctn VARCHAR(10) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.asset'), 'ste_system', 'ColumnId') IS NULL ALTER TABLE asset ADD ste_system VARCHAR(4) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.asset'), 'ste_subsystem', 'ColumnId') IS NULL ALTER TABLE asset ADD ste_subsystem VARCHAR(6) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.asset'), 'ste_aisassetcode', 'ColumnId') IS NULL ALTER TABLE asset ADD ste_aisassetcode VARCHAR(38) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.asset'), 'ste_aisassetid', 'ColumnId') IS NULL ALTER TABLE asset ADD ste_aisassetid VARCHAR(18) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.asset'), 'ste_aislocationcode', 'ColumnId') IS NULL ALTER TABLE asset ADD ste_aislocationcode VARCHAR(50) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.asset'), 'ste_cswnassetid', 'ColumnId') IS NULL ALTER TABLE asset ADD ste_cswnassetid VARCHAR(40) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.asset'), 'ste_cswnbarcode', 'ColumnId') IS NULL ALTER TABLE asset ADD ste_cswnbarcode VARCHAR(20) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.asset'), 'ste_cswnsystemequip', 'ColumnId') IS NULL ALTER TABLE asset ADD ste_cswnsystemequip VARCHAR(20) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.asset'), 'ste_cswngt', 'ColumnId') IS NULL ALTER TABLE asset ADD ste_cswngt VARCHAR(12) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.asset'), 'ste_cswnsnodate', 'ColumnId') IS NULL ALTER TABLE asset ADD ste_cswnsnodate DATETIME default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.asset'), 'ste_manufactmtbf', 'ColumnId') IS NULL ALTER TABLE asset ADD ste_manufactmtbf varchar(50) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.asset'), 'ste_loccode', 'ColumnId') IS NULL ALTER TABLE asset ADD ste_loccode VARCHAR(50) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.asset'), 'ste_cswnmodelnum', 'ColumnId') IS NULL ALTER TABLE asset ADD ste_cswnmodelnum VARCHAR(24) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.asset'), 'ste_inchrgref', 'ColumnId') is null ALTER TABLE asset ADD ste_inchrgref varchar(20) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.asset'), 'ste_cswncapacity', 'ColumnId') IS NULL ALTER TABLE asset ADD ste_cswncapacity varchar(50) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.asset'), 'ste_cswnrating', 'ColumnId') IS NULL ALTER TABLE asset ADD ste_cswnrating varchar(50) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.asset'), 'ste_cswnmtbfunit', 'ColumnId') IS NULL ALTER TABLE asset ADD ste_cswnmtbfunit varchar(50) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.asset'), 'ste_manufactmttr', 'ColumnId') IS NULL ALTER TABLE asset ADD ste_manufactmttr varchar(50) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.asset'), 'ste_cswnmttrunit', 'ColumnId') IS NULL ALTER TABLE asset ADD ste_cswnmttrunit varchar(50) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.asset'), 'ste_cswnmeterid',  'ColumnId') IS NULL ALTER TABLE asset ADD ste_cswnmeterid varchar(50) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.asset'), 'ste_cswnregno', 'ColumnId') IS NULL ALTER TABLE asset ADD ste_cswnregno varchar(50) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.asset'), 'ste_cswncountry', 'ColumnId') IS NULL ALTER TABLE asset ADD ste_cswncountry varchar(50) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.asset'), 'ste_cswnmanfyy', 'ColumnId') IS NULL ALTER TABLE asset ADD ste_cswnmanfyy int default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.asset'), 'ste_cswnmanfmm', 'ColumnId') IS NULL ALTER TABLE asset ADD ste_cswnmanfmm int default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.asset'), 'ste_cswnarrvyy', 'ColumnId') IS NULL ALTER TABLE asset ADD ste_cswnarrvyy int default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.asset'), 'ste_cswnarrvmm', 'ColumnId') IS NULL ALTER TABLE asset ADD ste_cswnarrvmm int default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.asset'), 'ste_cswnminlifeyy', 'ColumnId') IS NULL ALTER TABLE asset ADD ste_cswnminlifeyy int default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.asset'), 'ste_cswnminlifemm', 'ColumnId') IS NULL ALTER TABLE asset ADD ste_cswnminlifemm int default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.asset'), 'ste_cswnminlifemeter', 'ColumnId') IS NULL ALTER TABLE asset ADD ste_cswnminlifemeter int default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.asset'), 'ste_cswnmaxlifeyy', 'ColumnId') IS NULL ALTER TABLE asset ADD ste_cswnmaxlifeyy int default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.asset'), 'ste_cswnmaxlifemm', 'ColumnId') IS NULL ALTER TABLE asset ADD ste_cswnmaxlifemm int default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.asset'), 'ste_cswnmaxlifemeter', 'ColumnId') IS NULL ALTER TABLE asset ADD ste_cswnmaxlifemeter int default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.asset'), 'ste_cswnserialno', 'ColumnId') IS NULL ALTER TABLE asset ADD ste_cswnserialno varchar(50) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.asset'), 'ste_cswneqpcatg', 'ColumnId') is null ALTER TABLE asset ADD ste_cswneqpcatg varchar(10) default null;
--prline
IF COLUMNPROPERTY(OBJECT_ID('dbo.prline'), 'ste_cswnsapgl', 'ColumnId') IS NULL ALTER TABLE prline ADD ste_cswnsapgl varchar(20) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.prline'), 'ste_cswnwbsnum', 'ColumnId') IS NULL ALTER TABLE prline ADD ste_cswnwbsnum varchar(20) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.prline'), 'ste_cswnprefsupl', 'ColumnId') is null ALTER TABLE prline ADD ste_cswnprefsupl varchar(20) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.prline'), 'ste_cswncurrencycode', 'ColumnId') is null ALTER TABLE prline ADD ste_cswncurrencycode varchar(8) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.prline'), 'ste_cswnprstatus', 'ColumnId') is null ALTER TABLE prline ADD ste_cswnprstatus smallint default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.prline'), 'ste_cswncostcenter', 'ColumnId') is null ALTER TABLE prline ADD ste_cswncostcenter varchar(16) default null;
--po
IF COLUMNPROPERTY(OBJECT_ID('dbo.po'), 'ste_cswnpotype', 'ColumnId') IS NULL ALTER TABLE po ADD ste_cswnpotype smallint default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.po'), 'ste_cswnsapgl', 'ColumnId') IS NULL ALTER TABLE po ADD ste_cswnsapgl varchar(20) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.po'), 'ste_cswnreceiptremark', 'ColumnId') is null ALTER TABLE po ADD ste_cswnreceiptremark text;
--poline	
IF COLUMNPROPERTY(OBJECT_ID('dbo.poline'), 'ste_cswnpendingqty', 'ColumnId') IS NULL ALTER TABLE poline ADD ste_cswnpendingqty decimal(15,2) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.poline'), 'ste_cswninvqty', 'ColumnId') IS NULL ALTER TABLE poline ADD ste_cswninvqty decimal(15,2) default null;
--rfqvendor	
IF COLUMNPROPERTY(OBJECT_ID('dbo.rfqvendor'), 'ste_cswnnotes', 'ColumnId') IS NULL ALTER TABLE rfqvendor ADD ste_cswnnotes varchar(100) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.rfqvendor'), 'ste_cswnwbsnum', 'ColumnId') IS NULL ALTER TABLE rfqvendor ADD ste_cswnwbsnum varchar(20) default null;
--companies	
IF COLUMNPROPERTY(OBJECT_ID('dbo.companies'), 'ste_cswncountry', 'ColumnId') IS NULL ALTER TABLE companies ADD ste_cswncountry varchar(50) default null;
--compcontact 
IF COLUMNPROPERTY(OBJECT_ID('dbo.compcontact'), 'ste_cswnvoicephone2', 'ColumnId') IS NULL ALTER TABLE compcontact ADD ste_cswnvoicephone2 varchar(50) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.compcontact'), 'ste_contacttype', 'ColumnId') IS NULL ALTER TABLE compcontact ADD ste_contacttype varchar(50) default null;
--compmaster	
IF COLUMNPROPERTY(OBJECT_ID('dbo.compmaster'), 'ste_cswncountry', 'ColumnId') IS NULL ALTER TABLE compmaster ADD ste_cswncountry varchar(50) default null;
--compcontactmaster
IF COLUMNPROPERTY(OBJECT_ID('dbo.compcontractmstr'), 'ste_cswnvoicephone2', 'ColumnId') IS NULL ALTER TABLE compcontractmstr ADD ste_cswnvoicephone2 varchar(50) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.compcontractmstr'), 'ste_contacttype', 'ColumnId') IS NULL ALTER TABLE compcontractmstr ADD ste_contacttype VARCHAR(20) default null;
--workorder
IF COLUMNPROPERTY(OBJECT_ID('dbo.workorder'), 'ste_cswnactionauth', 'ColumnId') IS NULL ALTER TABLE workorder ADD ste_cswnactionauth varchar(16) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.workorder'), 'ste_cswnactiondesc', 'ColumnId') IS NULL ALTER TABLE workorder ADD ste_cswnactiondesc varchar(100) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.workorder'), 'ste_cswncc', 'ColumnId') IS NULL ALTER TABLE workorder ADD ste_cswncc varchar(16) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.workorder'), 'ste_cswniexfl', 'ColumnId') IS NULL ALTER TABLE workorder ADD ste_cswniexfl varchar(3) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.workorder'), 'ste_cswnprjref', 'ColumnId') IS NULL ALTER TABLE workorder ADD ste_cswnprjref varchar(10) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.workorder'), 'ste_cswneqpcode', 'ColumnId') IS NULL ALTER TABLE workorder ADD ste_cswneqpcode varchar(20) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.workorder'), 'ste_cswnjbclu', 'ColumnId') IS NULL ALTER TABLE workorder ADD ste_cswnjbclu varchar(6) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.workorder'), 'ste_cswnjbcludesc', 'ColumnId') IS NULL ALTER TABLE workorder ADD ste_cswnjbcludesc varchar(100) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.workorder'), 'ste_cswnjobid', 'ColumnId') IS NULL ALTER TABLE workorder ADD ste_cswnjobid varchar(16) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.workorder'), 'ste_cswnnewserialnum', 'ColumnId') IS NULL ALTER TABLE workorder ADD ste_cswnnewserialnum varchar(24) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.workorder'), 'ste_cswnreqdesc', 'ColumnId') IS NULL ALTER TABLE workorder ADD ste_cswnreqdesc varchar(100) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.workorder'), 'ste_cswnrequestauth', 'ColumnId') IS NULL ALTER TABLE workorder ADD ste_cswnrequestauth varchar(16) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.workorder'), 'ste_cswntotcumunits', 'ColumnId') IS NULL ALTER TABLE workorder ADD ste_cswntotcumunits varchar(38) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.workorder'), 'ste_cswnwofnctn', 'ColumnId') IS NULL ALTER TABLE workorder ADD ste_cswnwofnctn varchar(10) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.workorder'), 'ste_cswnwotype', 'ColumnId') IS NULL ALTER TABLE workorder ADD ste_cswnwotype varchar(3) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.workorder'), 'ste_cswnwozone', 'ColumnId') IS NULL ALTER TABLE workorder ADD ste_cswnwozone varchar(10) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.workorder'), 'ste_eqpphone', 'ColumnId') IS NULL ALTER TABLE workorder ADD ste_eqpphone varchar(13) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.workorder'), 'ste_cswnwoid', 'ColumnId') IS NULL ALTER TABLE workorder ADD ste_cswnwoid varchar(10) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.workorder'), 'ste_cswnafcjrnum', 'ColumnId') IS NULL ALTER TABLE workorder ADD ste_cswnafcjrnum varchar(20) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.workorder'), 'ste_cswnoldsernum', 'ColumnId') IS NULL ALTER TABLE workorder ADD ste_cswnoldsernum varchar(20) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.workorder'), 'ste_cswnnewsernum', 'ColumnId') IS NULL ALTER TABLE workorder ADD ste_cswnnewsernum varchar(20) default null;
--ticket
IF COLUMNPROPERTY(OBJECT_ID('dbo.ticket'), 'ste_cswneqpcode', 'ColumnId') is null ALTER TABLE ticket ADD ste_cswneqpcode varchar(25) default null;
--item
IF COLUMNPROPERTY(OBJECT_ID('dbo.ITEM'), 'ste_cswnbarcode', 'ColumnId') IS NULL ALTER TABLE ITEM ADD ste_cswnbarcode VARCHAR(20) default null;
--person
IF COLUMNPROPERTY(OBJECT_ID('dbo.person'), 'ste_cswnemercontact', 'ColumnId') IS NULL ALTER TABLE person ADD ste_cswnemercontact	varchar(25)	 default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.person'), 'ste_cswnidcard', 'ColumnId') IS NULL ALTER TABLE person ADD ste_cswnidcard	varchar(16)	 default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.person'), 'ste_cswnpassport', 'ColumnId') IS NULL ALTER TABLE person ADD ste_cswnpassport	varchar(16)	 default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.person'), 'ste_cswnworkerid', 'ColumnId') IS NULL ALTER TABLE person ADD ste_cswnworkerid	varchar(16)	 default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.person'), 'ste_cswnsex', 'ColumnId') IS NULL ALTER TABLE person ADD ste_cswnsex	varchar(3)	 default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.person'), 'ste_cswncompanyentity', 'ColumnId') IS NULL ALTER TABLE person ADD ste_cswncompanyentity	varchar(16)	 default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.person'), 'ste_cswnbarcode', 'ColumnId') IS NULL ALTER TABLE person ADD ste_cswnbarcode	varchar(16)	 default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.person'), 'ste_cswncc', 'ColumnId') IS NULL ALTER TABLE person ADD ste_cswncc	varchar(16)	 default null;
--qualification	
IF COLUMNPROPERTY(OBJECT_ID('dbo.qualification'), 'ste_cswnskillskill', 'ColumnId') is null ALTER TABLE qualification ADD ste_cswnskillskill varchar(10) default null;
--jobtask
IF COLUMNPROPERTY(OBJECT_ID('dbo.jobtask'), 'ste_cswnactcode', 'ColumnId') is null ALTER TABLE jobtask ADD ste_cswnactcode varchar(10) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.jobtask'), 'ste_cweqcode', 'ColumnId') is null ALTER TABLE jobtask ADD ste_cweqcode	varchar(25) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.jobtask'), 'ste_cswninterval', 'ColumnId') is null ALTER TABLE jobtask ADD ste_cswninterval	numeric(12) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.jobtask'), 'ste_cswnintervalunit', 'ColumnId') is null ALTER TABLE jobtask ADD ste_cswnintervalunit	varchar(8) default null;
--pm
IF COLUMNPROPERTY(OBJECT_ID('dbo.pm'), 'ste_cswnjobid', 'ColumnId') is null ALTER TABLE pm ADD ste_cswnjobid varchar(16) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.pm'), 'ste_cswncc', 'ColumnId') is null ALTER TABLE pm ADD ste_cswncc	varchar(16) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.pm'), 'ste_cswncostype', 'ColumnId') is null ALTER TABLE pm ADD ste_cswncostype	varchar(10) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.pm'), 'ste_cswnintervalunit', 'ColumnId') is null ALTER TABLE pm ADD ste_cswnintervalunit	varchar(8) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.pm'), 'ste_cswnjobbehaviour', 'ColumnId') is null ALTER TABLE pm ADD ste_cswnjobbehaviour	smallint default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.pm'), 'ste_cswnjoblevel', 'ColumnId') is null ALTER TABLE pm ADD ste_cswnjoblevel	smallint default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.pm'), 'ste_cswnlastwonum', 'ColumnId') is null ALTER TABLE pm ADD ste_cswnlastwonum	varchar(10) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.pm'), 'ste_cswnmaxinterval', 'ColumnId') is null ALTER TABLE pm ADD ste_cswnmaxinterval	numeric(12) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.pm'), 'ste_cswnmininterval', 'ColumnId') is null ALTER TABLE pm ADD ste_cswnmininterval	numeric(12) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.pm'), 'ste_cswnmult', 'ColumnId') is null ALTER TABLE pm ADD ste_cswnmult	smallint default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.pm'), 'ste_cswnshift', 'ColumnId') is null ALTER TABLE pm ADD ste_cswnshift	smallint default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.pm'), 'ste_cswnworkday', 'ColumnId') is null ALTER TABLE pm ADD ste_cswnworkday	smallint default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.pm'), 'ste_cweqcode', 'ColumnId') is null ALTER TABLE pm ADD ste_cweqcode	varchar(25) default null;
--pmeseasons
IF COLUMNPROPERTY(OBJECT_ID('dbo.pmseasons'), 'ste_cswnstartwk', 'ColumnId') is null ALTER TABLE pmseasons ADD ste_cswnstartwk smallint default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.pmseasons'), 'ste_cswnendwk', 'ColumnId') is null ALTER TABLE pmseasons ADD ste_cswnendwk smallint default null;
--currency
IF COLUMNPROPERTY(OBJECT_ID('dbo.currency'), 'ste_cswnctrycd', 'ColumnId') is null ALTER TABLE currency ADD ste_cswnctrycd varchar(4) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.currency'), 'ste_cswnctryname', 'ColumnId') is null ALTER TABLE currency ADD ste_cswnctryname varchar(16) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.currency'), 'ste_cswndpt', 'ColumnId') is null ALTER TABLE currency ADD ste_cswndpt smallint default null;
--matrectrans
IF COLUMNPROPERTY(OBJECT_ID('dbo.matrectrans'), 'ste_cswninspdate', 'ColumnId') is null ALTER TABLE matrectrans ADD ste_cswninspdate datetime,
IF COLUMNPROPERTY(OBJECT_ID('dbo.matrectrans'), 'ste_cswninspstat', 'ColumnId') is null ALTER TABLE matrectrans ADD ste_cswninspstat int,
IF COLUMNPROPERTY(OBJECT_ID('dbo.matrectrans'), 'ste_cswngrnref', 'ColumnId') is null ALTER TABLE matrectrans ADD ste_cswngrnref varchar(10);
IF COLUMNPROPERTY(OBJECT_ID('dbo.matrectrans'), 'ste_cswndndate', 'ColumnId') is null ALTER TABLE matrectrans ADD ste_cswndndate datetime default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.matrectrans'), 'ste_cswnrctstatus', 'ColumnId') is null ALTER TABLE matrectrans ADD ste_cswnrctstatus smallint,
IF COLUMNPROPERTY(OBJECT_ID('dbo.matrectrans'), 'ste_cswngrnnum', 'ColumnId') is null ALTER TABLE matrectrans ADD ste_cswngrnnum varchar(10) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.matrectrans'), 'ste_cswngrndate', 'ColumnId') is null ALTER TABLE matrectrans ADD ste_cswngrndate datetime default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.matrectrans'), 'ste_cswnreceipttype', 'ColumnId') is null ALTER TABLE matrectrans ADD ste_cswnreceipttype smallint default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.matrectrans'), 'ste_cswncc', 'ColumnId') is null ALTER TABLE matrectrans ADD ste_cswncc varchar(16) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.matrectrans'), 'ste_cswninspref', 'ColumnId') is null ALTER TABLE matrectrans ADD ste_cswninspref varchar(10) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.matrectrans'), 'remark_longdescription', 'ColumnId') is null ALTER TABLE matrectrans ADD remark_longdescription text;
IF COLUMNPROPERTY(OBJECT_ID('dbo.matrectrans'), 'ste_cswnsapgl', 'ColumnId') is null ALTER TABLE matrectrans ADD ste_cswnsapgl varchar(20) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.matrectrans'), 'ste_cswnfwdr', 'ColumnId') IS NULL ALTER TABLE matrectrans ADD ste_cswnfwdr varchar(15) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.matrectrans'), 'ste_cswnreceiptchangedate', 'ColumnId') IS NULL ALTER TABLE matrectrans ADD ste_cswnreceiptchangedate datetime default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.matrectrans'), 'ste_cswnreceiptforwarder', 'ColumnId') IS NULL ALTER TABLE matrectrans ADD ste_cswnreceiptforwarder varchar(20) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.matrectrans'), 'ste_cswnrecwo', 'ColumnId') IS NULL ALTER TABLE matrectrans ADD ste_cswnrecwo varchar(20) default null;
--jobplan
IF COLUMNPROPERTY(OBJECT_ID('dbo.jobplan'), 'ste_cswnjobid', 'ColumnId') is null ALTER TABLE jobplan ADD ste_cswnjobid varchar(16) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.jobplan'), 'ste_cswnavprtm', 'ColumnId') is null ALTER TABLE jobplan ADD ste_cswnavprtm	smallint default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.jobplan'), 'ste_cswncc', 'ColumnId') is null ALTER TABLE jobplan ADD ste_cswncc	varchar(16) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.jobplan'), 'ste_cswnday', 'ColumnId') is null ALTER TABLE jobplan ADD ste_cswnday	smallint default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.jobplan'), 'ste_cswndurationunit', 'ColumnId') is null ALTER TABLE jobplan ADD ste_cswndurationunit	varchar(5) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.jobplan'), 'ste_cswnenwk', 'ColumnId') is null ALTER TABLE jobplan ADD ste_cswnenwk	smallint default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.jobplan'), 'ste_cswnhazard', 'ColumnId') is null ALTER TABLE jobplan ADD ste_cswnhazard	smallint default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.jobplan'), 'ste_cswnjbbhu', 'ColumnId') is null ALTER TABLE jobplan ADD ste_cswnjbbhu	smallint default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.jobplan'), 'ste_cswnjobclass', 'ColumnId') is null ALTER TABLE jobplan ADD ste_cswnjobclass	varchar(6) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.jobplan'), 'ste_cswnjobtype', 'ColumnId') is null ALTER TABLE jobplan ADD ste_cswnjobtype	varchar(6) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.jobplan'), 'ste_cswnlaborcost', 'ColumnId') is null ALTER TABLE jobplan ADD ste_cswnlaborcost	numeric(10) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.jobplan'), 'ste_cswnljml', 'ColumnId') is null ALTER TABLE jobplan ADD ste_cswnljml	float default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.jobplan'), 'ste_cswnmaterialcost', 'ColumnId') is null ALTER TABLE jobplan ADD ste_cswnmaterialcost	numeric(10) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.jobplan'), 'ste_cswnmiprtm', 'ColumnId') is null ALTER TABLE jobplan ADD ste_cswnmiprtm	smallint default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.jobplan'), 'ste_cswnmtid', 'ColumnId') is null ALTER TABLE jobplan ADD ste_cswnmtid	varchar(16) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.jobplan'), 'ste_cswnmtprml', 'ColumnId') is null ALTER TABLE jobplan ADD ste_cswnmtprml	decimal(15) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.jobplan'), 'ste_cswnmxprtm', 'ColumnId') is null ALTER TABLE jobplan ADD ste_cswnmxprtm	smallint default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.jobplan'), 'ste_cswnnowo', 'ColumnId') is null ALTER TABLE jobplan ADD ste_cswnnowo	smallint default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.jobplan'), 'ste_cswnpr_unit', 'ColumnId') is null ALTER TABLE jobplan ADD ste_cswnpr_unit	smallint default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.jobplan'), 'ste_cswnprjref', 'ColumnId') is null ALTER TABLE jobplan ADD ste_cswnprjref	varchar(10) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.jobplan'), 'ste_cswnservicecost', 'ColumnId') is null ALTER TABLE jobplan ADD ste_cswnservicecost	numeric(10) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.jobplan'), 'ste_cswnstwk', 'ColumnId') is null ALTER TABLE jobplan ADD ste_cswnstwk	smallint default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.jobplan'), 'ste_cswnwoid', 'ColumnId') is null ALTER TABLE jobplan ADD ste_cswnwoid	varchar(10) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.jobplan'), 'ste_cswnworkday', 'ColumnId') is null ALTER TABLE jobplan ADD ste_cswnworkday	smallint default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.jobplan'), 'ste_cswnwptype', 'ColumnId') is null ALTER TABLE jobplan ADD ste_cswnwptype	varchar(10) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.jobplan'), 'ste_cweqcode', 'ColumnId') is null ALTER TABLE jobplan ADD ste_cweqcode	varchar(25) default null;
--jpassetsplink	
IF COLUMNPROPERTY(OBJECT_ID('dbo.jpassetsplink'), 'ste_cweqcode', 'ColumnId') is null ALTER TABLE jpassetsplink ADD ste_cweqcode	varchar(25) default null;
--pmmeter	
IF COLUMNPROPERTY(OBJECT_ID('dbo.pmmeter'), 'ste_cswnfrequnit', 'ColumnId') is null ALTER TABLE pmmeter ADD ste_cswnfrequnit	smallint default null;
--assetmeter
IF COLUMNPROPERTY(OBJECT_ID('dbo.assetmeter'), 'ste_cswnconstant', 'ColumnId') is null ALTER TABLE assetmeter ADD ste_cswnconstant decimal(15,5) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.assetmeter'), 'ste_cswnforecast', 'ColumnId') is null ALTER TABLE assetmeter ADD ste_cswnforecast float default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.assetmeter'), 'ste_cswnfrequency', 'ColumnId') IS NULL ALTER TABLE assetmeter add ste_cswnfrequency INTEGER	
IF COLUMNPROPERTY(OBJECT_ID('dbo.assetmeter'), 'ste_cswnfrequencyunit', 'ColumnId') IS NULL ALTER TABLE assetmeter add ste_cswnfrequencyunit	varchar(50)
IF COLUMNPROPERTY(OBJECT_ID('dbo.assetmeter'), 'ste_cswnassetid', 'ColumnId') IS NULL ALTER TABLE assetmeter add ste_cswnassetid	nvarchar(50)
IF COLUMNPROPERTY(OBJECT_ID('dbo.assetmeter'), 'ste_cswntotalcumrununit', 'ColumnId') IS NULL ALTER TABLE assetmeter add ste_cswntotalcumrununit float
IF COLUMNPROPERTY(OBJECT_ID('dbo.assetmeter'), 'ste_cswnstartdate', 'ColumnId') IS NULL ALTER TABLE assetmeter add ste_cswnstartdate datetime;
IF COLUMNPROPERTY(OBJECT_ID('dbo.assetmeter'), 'ste_mtlastread', 'ColumnId') IS NULL ALTER TABLE assetmeter add	ste_mtlastread varchar(50);
--meter
IF COLUMNPROPERTY(OBJECT_ID('dbo.meter'), 'ste_cswndefaultvalue', 'ColumnId') is null ALTER TABLE meter ADD ste_cswndefaultvalue decimal(15,5) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.meter'), 'ste_cswnmetertype', 'ColumnId') is null ALTER TABLE meter ADD ste_cswnmetertype varchar(25) default null;
--matusetrans
IF COLUMNPROPERTY(OBJECT_ID('dbo.matusetrans'), 'ste_replflag', 'ColumnId') is null ALTER TABLE matusetrans ADD ste_replflag varchar(3) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.matusetrans'), 'ste_plnflag', 'ColumnId') is null ALTER TABLE matusetrans ADD ste_plnflag varchar(3) default null;
--rfqvendor
IF COLUMNPROPERTY(OBJECT_ID('dbo.rfqvendor'), 'ste_cswnsapgl', 'ColumnId') IS NULL ALTER TABLE rfqvendor ADD ste_cswnsapgl varchar(20) default null;
--invoiceline
IF COLUMNPROPERTY(OBJECT_ID('dbo.invoiceline'), 'ste_cswndiscount', 'ColumnId') IS NULL ALTER TABLE invoiceline add	ste_cswndiscount decimal (10, 2) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.invoiceline'), 'ste_cswnlocalhandlingcharge', 'ColumnId') IS NULL ALTER TABLE invoiceline add	ste_cswnlocalhandlingcharge decimal (10, 2)default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.invoiceline'), 'ste_cswnothercharges', 'ColumnId') IS NULL ALTER TABLE invoiceline add	ste_cswnothercharges decimal(10, 2)default null;	
--labor
IF COLUMNPROPERTY(OBJECT_ID('dbo.labor'), 'ste_cswnpaidhrs', 'ColumnId') IS NULL ALTER TABLE labor ADD ste_cswnpaidhrs int default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.labor'), 'ste_cswnwrenchhrs', 'ColumnId') IS NULL ALTER TABLE labor ADD ste_cswnwrenchhrs int default null;
--invoice
IF COLUMNPROPERTY(OBJECT_ID('dbo.invoice'), 'ste_cswndnref', 'ColumnId') IS NULL ALTER TABLE invoice ADD ste_cswndnref varchar(10) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.invoice'), 'ste_cswndonum', 'ColumnId') IS NULL ALTER TABLE invoice ADD ste_cswndonum varchar(10) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.invoice'), 'ste_cswndodate', 'ColumnId') IS NULL ALTER TABLE invoice ADD ste_cswndodate datetime default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.invoice'), 'ste_cswnwbsnum', 'ColumnId') IS NULL ALTER TABLE invoice ADD ste_cswnwbsnum varchar(20) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.invoice'), 'ste_cswnaltprice1', 'ColumnId') IS NULL ALTER TABLE quotationline ADD ste_cswnaltprice1 decimal(10,2) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.invoice'), 'ste_cswnaltprice2', 'ColumnId') IS NULL ALTER TABLE quotationline ADD ste_cswnaltprice2 decimal(10,2) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.invoice'), 'ste_cswnbaseval', 'ColumnId') is null ALTER TABLE invoice ADD ste_cswnbaseval decimal(18,2) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.invoice'), 'ste_cswnlocalhandlingcharge', 'ColumnId') is null ALTER TABLE invoice ADD ste_cswnlocalhandlingcharge decimal(18,2) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.invoice'), 'ste_cswnothercharges', 'ColumnId') is null ALTER TABLE invoice ADD ste_cswnothercharges decimal(18,2) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.invoice'), 'ste_cswninvadj', 'ColumnId') is null ALTER TABLE invoice ADD ste_cswninvadj decimal(18,2) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.invoice'), 'ste_cswncnstatus', 'ColumnId') IS NULL ALTER TABLE invoice ADD ste_cswncnstatus smallint default null;
--invoicecost
IF COLUMNPROPERTY(OBJECT_ID('dbo.invoicecost'), 'ste_cswncnstatus', 'ColumnId') IS NULL ALTER TABLE invoicecost ADD ste_cswnsapgl varchar(20) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.invoicecost'), 'ste_cswncc', 'ColumnId') IS NULL ALTER TABLE invoicecost ADD ste_cswncc varchar(16) default null;
--labtrans	
IF COLUMNPROPERTY(OBJECT_ID('dbo.labtrans'), 'ste_cswnemplyestatus', 'ColumnId') IS NULL ALTER TABLE labtrans ADD ste_cswnemplyestatus int default null;

--add custom column based on chue's email 20230724

IF COLUMNPROPERTY(OBJECT_ID('dbo.prline'), 'ste_cswncc', 'ColumnId') IS NULL ALTER TABLE prline ADD ste_cswncc varchar(16) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.poline'), 'ste_cswncc', 'ColumnId') IS NULL ALTER TABLE poline ADD ste_cswncc varchar(16) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.rfqline'), 'ste_cswncc', 'ColumnId') IS NULL ALTER TABLE rfqline ADD ste_cswncc varchar(16) default null;

IF COLUMNPROPERTY(OBJECT_ID('dbo.shiftpatternday'), 'ste_cswnassistants', 'ColumnId') IS NULL ALTER TABLE shiftpatternday ADD ste_cswnassistants smallint default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.shiftpatternday'), 'ste_cswnleaders', 'ColumnId') IS NULL ALTER TABLE shiftpatternday ADD ste_cswnleaders smallint default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.shiftpatternday'), 'ste_cswnrequired', 'ColumnId') IS NULL ALTER TABLE shiftpatternday ADD ste_cswnrequired smallint default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.shiftpatternday'), 'ste_cswnstaff', 'ColumnId') IS NULL ALTER TABLE shiftpatternday ADD ste_cswnstaff smallint default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.shiftpatternday'), 'ste_cswntdcd', 'ColumnId') IS NULL ALTER TABLE shiftpatternday ADD ste_cswntdcd varchar(10) default null;

IF COLUMNPROPERTY(OBJECT_ID('dbo.compmaster'), 'ste_cswnsapvndcode', 'ColumnId') IS NULL ALTER TABLE compmaster ADD ste_cswnsapvndcode varchar(50) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.compmaster'), 'ste_ho_addr', 'ColumnId') IS NULL ALTER TABLE compmaster ADD ste_ho_addr varchar(50) default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.compmaster'), 'ste_mail_addr', 'ColumnId') IS NULL ALTER TABLE compmaster ADD ste_mail_addr varchar(50) default null;

IF COLUMNPROPERTY(OBJECT_ID('dbo.exchange'), 'ste_cswnavgrate', 'ColumnId') IS NULL ALTER TABLE exchange ADD ste_cswnavgrate varchar(50) default null;

IF COLUMNPROPERTY(OBJECT_ID('dbo.invoice'), 'ste_cswndndate', 'ColumnId') IS NULL ALTER TABLE invoice ADD ste_cswndndate datetime default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.invoice'), 'ste_cswninvadjstatus', 'ColumnId') IS NULL ALTER TABLE invoice ADD ste_cswninvadjstatus smallint default null;
IF COLUMNPROPERTY(OBJECT_ID('dbo.invoice'), 'ste_gstcode', 'ColumnId') IS NULL ALTER TABLE invoice ADD ste_gstcode varchar(20) default null;

IF COLUMNPROPERTY(OBJECT_ID('dbo.matrectrans'), 'ste_cswninspstatus', 'ColumnId') IS NULL ALTER TABLE matrectrans ADD ste_cswninspstatus varchar(20) default null;



	
-- use workordernum as autokey
update autokey 
set
	autokeyname='WORKORDERNUM'
	, orgid='SBST'
where autokeyname='WONUM';


--alter table dbo.pm
--alter column pmnum varchar(16);

	
--ALTER TABLE routes
--ALTER COLUMN route varchar(20) NOT NULL;

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

--ALTER TABLE workorder
--ALTER COLUMN route varchar(20);

---- delete index dependent to problemcode
--drop index workorder_ndx7 ON dbo.workorder;
--drop index workorder_ndx9 ON dbo.workorder;

--ALTER TABLE workorder
--ALTER COLUMN problemcode varchar(10) NOT NULL;

---- recreate index
--SET ANSI_PADDING ON
--GO
--/****** Object:  Index workorder_ndx7    Script Date: 04/04/2023 15:14:53 ******/
--CREATE NONCLUSTERED INDEX workorder_ndx7 ON dbo.workorder
--(
--	siteid ASC,
--	assetnum ASC,
--	problemcode ASC,
--	status ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON PRIMARY
--GO
--SET ANSI_PADDING ON
--GO
--/****** Object:  Index workorder_ndx9    Script Date: 04/04/2023 15:14:53 ******/
--CREATE NONCLUSTERED INDEX workorder_ndx9 ON dbo.workorder
--(
--	siteid ASC,
--	location ASC,
--	problemcode ASC,
--	status ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON PRIMARY
--GO

--ALTER TABLE workorder
--ALTER COLUMN justifypriority varchar(100) NOT NULL;

--ALTER TABLE workorder
--ALTER COLUMN contract varchar(10) NOT NULL;

--ALTER TABLE workorder
--ALTER COLUMN wonum varchar(20) NOT NULL;

--ALTER TABLE workorder
--ALTER COLUMN parent varchar(20) NOT NULL;

--ALTER TABLE ASSET
--ALTER COLUMN pluscmodelnum varchar(24) NOT NULL;


--ALTER TABLE prline
--ALTER COLUMN CONTRACTREFNUM varchar(10) NOT NULL;

---- need to disable index first
----ALTER TABLE rfqline
----ALTER COLUMN PONUM varchar(10) NOT NULL;

---- force make sure eqcode from coswin is not truncated
--ALTER TABLE ROUTES
--ALTER COLUMN route varchar(20) NOT NULL;

--ALTER TABLE ROUTES
--ALTER COLUMN routestopsbecome varchar(20) NOT NULL;

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
