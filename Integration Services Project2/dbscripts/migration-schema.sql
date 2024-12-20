-- MIGRATION.STE_MIGRATION_LOGS definition

CREATE TABLE "MIGRATION"."STE_MIGRATION_LOGS"  (
		  "ID" BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY (  
		    START WITH +1  
		    INCREMENT BY +1  
		    MINVALUE +1  
		    MAXVALUE +9223372036854775807  
		    NO CYCLE  
		    CACHE 20  
		    NO ORDER ) , 
		  "PACKAGE_NAME" VARCHAR(250 OCTETS) NOT NULL , 
		  "VERSION" VARCHAR(10 OCTETS) , 
		  "START_DATE" TIMESTAMP NOT NULL WITH DEFAULT CURRENT TIMESTAMP , 
		  "END_DATE" TIMESTAMP , 
		  "START_ID" VARCHAR(250 OCTETS) , 
		  "END_ID" VARCHAR(250 OCTETS) , 
		  "SUCCESS" INTEGER NOT NULL WITH DEFAULT 0 )   
		 IN "USERSPACE1"  
		 ORGANIZE BY ROW;

ALTER TABLE "MIGRATION"."STE_MIGRATION_LOGS" ALTER COLUMN "ID" RESTART WITH 21;

CREATE TABLE "MIGRATION"."STE_MIGRATION_LOG_DETAILS"  (
		  "ID" BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY (  
		    START WITH +1  
		    INCREMENT BY +1  
		    MINVALUE +1  
		    MAXVALUE +9223372036854775807  
		    NO CYCLE  
		    CACHE 20  
		    NO ORDER ) , 
		  "PACKAGE_NAME" VARCHAR(250 OCTETS) NOT NULL , 
		  "LOG_ID" BIGINT NOT NULL , 
		  "EVENT" VARCHAR(250 OCTETS) NOT NULL , 
		  "EVENT_TYPE" VARCHAR(250 OCTETS) , 
		  "EVENT_DESCRIPTION" VARCHAR(2000 OCTETS) , 
		  "TIMESTAMP" TIMESTAMP NOT NULL WITH DEFAULT CURRENT TIMESTAMP )   
		 IN "USERSPACE1"  
		 ORGANIZE BY ROW;

ALTER TABLE "MIGRATION"."STE_MIGRATION_LOG_DETAILS" ALTER COLUMN "ID" RESTART WITH 61;

CREATE TABLE "MIGRATION"."STE_MIGRATION_PARAMS"  (
		  "ID" BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY (  
		    START WITH +1  
		    INCREMENT BY +1  
		    MINVALUE +1  
		    MAXVALUE +9223372036854775807  
		    NO CYCLE  
		    CACHE 20  
		    NO ORDER ) , 
		  "PACKAGE_NAME" VARCHAR(250 OCTETS) NOT NULL , 
		  "PARAMETER_NAME" VARCHAR(250 OCTETS) NOT NULL , 
		  "PARAMETER_VALUE" VARCHAR(250 OCTETS) NOT NULL , 
		  "CREATED_ON" TIMESTAMP NOT NULL WITH DEFAULT CURRENT TIMESTAMP , 
		  "CREATED_BY" VARCHAR(250 OCTETS) , 
		  "MODIFIED_ON" TIMESTAMP , 
		  "MODIFIED_BY" VARCHAR(250 OCTETS) )   
		 IN "USERSPACE1"  
		 ORGANIZE BY ROW;

ALTER TABLE "MIGRATION"."STE_MIGRATION_PARAMS" ALTER COLUMN "ID" RESTART WITH 21;

-- MIGRATION.STE_MIGRATION_USER_LOOKUP definition

CREATE SEQUENCE MIGRATION.MAXSEQ START WITH 1 INCREMENT BY 1;

CREATE TABLE "MIGRATION"."STE_MIGRATION_USER_LOOKUP"  (
		  "PKEY" BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY (  
		    START WITH +1  
		    INCREMENT BY +1  
		    MINVALUE +1  
		    MAXVALUE +9223372036854775807  
		    NO CYCLE  
		    CACHE 20  
		    NO ORDER ) , 
		  "DISPLAY_NAME" VARCHAR(250 OCTETS) NOT NULL , 
		  "PERSONID" VARCHAR(50 OCTETS) NOT NULL , 
		  "PERSISTENT" INTEGER NOT NULL , 
		  "STATUS" INTEGER NOT NULL , 
		  "ROWSTAMP" BIGINT NOT NULL , 
		  "STE_MIGRATIONID" BIGINT , 
		  "DM_TEST" VARCHAR(10 OCTETS) , 
		  "ID" BIGINT )   
		 IN "MAXDATA"  
		 ORGANIZE BY ROW;

ALTER TABLE "MIGRATION"."STE_MIGRATION_USER_LOOKUP" ALTER COLUMN "PKEY" RESTART WITH 30121;

CREATE TRIGGER MIGRATION.STE_MIGRATION_US_T NO CASCADE BEFORE INSERT ON
MIGRATION.STE_MIGRATION_USER_LOOKUP
REFERENCING NEW AS N FOR EACH ROW MODE DB2SQL SET N.ROWSTAMP = NEXTVAL
FOR MIGRATION.MAXSEQ;

CREATE TRIGGER MIGRATION.STE_MIGRATION_US_U NO CASCADE BEFORE UPDATE ON
MIGRATION.STE_MIGRATION_USER_LOOKUP
REFERENCING NEW AS N FOR EACH ROW MODE DB2SQL SET N.ROWSTAMP = NEXTVAL
FOR MIGRATION.MAXSEQ;

-- MIGRATION.STE_MIGRATION_DELTA_LOGS definition

CREATE TABLE "MIGRATION"."STE_MIGRATION_DELTA_LOGS"  (
		  "ID" BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY (  
		    START WITH +1  
		    INCREMENT BY +1  
		    MINVALUE +1  
		    MAXVALUE +9223372036854775807  
		    NO CYCLE  
		    CACHE 20  
		    NO ORDER ) , 
		  "TABLE_NAME" VARCHAR(250 OCTETS) NOT NULL , 
		  "COSWIN_KEY" BIGINT NOT NULL , 
		  "MAXIMO_KEY" BIGINT NOT NULL , 
		  "REF_NAME" VARCHAR(50 OCTETS) , 
		  "ACTION" VARCHAR(10 OCTETS) , 
		  "TIMESTAMP" TIMESTAMP NOT NULL WITH DEFAULT CURRENT TIMESTAMP
 			)   
		 IN "USERSPACE1"  
		 ORGANIZE BY ROW;

ALTER TABLE "MIGRATION"."STE_MIGRATION_DELTA_LOGS" ALTER COLUMN "ID" RESTART WITH 21;

-- SBST ITEM MASTER
CREATE TABLE "MIGRATION"."SBST_ITEM_MASTER"  (
		  "ID" BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY (  
		    START WITH +1  
		    INCREMENT BY +1  
		    MINVALUE +1  
		    MAXVALUE +9223372036854775807  
		    NO CYCLE  
		    CACHE 20  
		    NO ORDER ) , 
		  CoswinItemNo VARCHAR(30 OCTETS),	
		  MaximoItemNum VARCHAR(30 OCTETS),	
		  Description VARCHAR(110 OCTETS),	
		  "System" VARCHAR(16 OCTETS),
		  "Subsystem" VARCHAR(16 OCTETS),
		  "STE_ITEMPARTNO" VARCHAR(60 OCTETS),
		  "ItemType" VARCHAR(30 OCTETS),
		  "Rotating" INTEGER,
		  "LotType" VARCHAR(16 OCTETS),
		  "STE_OWNERDEPARTMENT" VARCHAR(30 OCTETS),
		  "STE_SEVERITY" INTEGER,
		  "STE_IS_CRITICAL" INTEGER,
		  "STE_SPARECRITICAL" VARCHAR(1 OCTETS),
		  "STE_IS_SAFETY_RELATED" INTEGER,
		  "ORDERUNIT" VARCHAR(16 OCTETS),
		  "STE_MAINTTYPE" VARCHAR(16 OCTETS)
 			)   
		 IN "USERSPACE1"  
		 ORGANIZE BY ROW;

ALTER TABLE "MIGRATION"."SBST_ITEM_MASTER" ALTER COLUMN "ID" RESTART WITH 21;


-- SBST DEBUGGING
CREATE TABLE "MIGRATION"."STE_MIGRATION_DEBUG_LOG"  (
		  "ID" BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY (  
		    START WITH +1  
		    INCREMENT BY +1  
		    MINVALUE +1  
		    MAXVALUE +9223372036854775807  
		    NO CYCLE  
		    CACHE 20  
		    NO ORDER ) , 
		  "PACKAGE_NAME" VARCHAR(250 OCTETS) NOT NULL , 
		  "LOG_ID" BIGINT NOT NULL , 
		  "LOG_TYPE" VARCHAR(250 OCTETS) , 
		  col1 VARCHAR(110 OCTETS),	
		  COL2 VARCHAR(110 OCTETS),	
		  COL3 VARCHAR(110 OCTETS),	
		  COL4 VARCHAR(110 OCTETS),	
		  COL5 VARCHAR(110 OCTETS),
		  "TIMESTAMP" TIMESTAMP NOT NULL WITH DEFAULT CURRENT TIMESTAMP
 			)   
		 IN "USERSPACE1"  
		 ORGANIZE BY ROW;
		 
CREATE OR REPLACE PROCEDURE MIGRATION.STE_UPDATE_SEQ(
	IN P_SEQNAME VARCHAR(50), IN P_TABLENAME VARCHAR(50),
	IN P_COLNAME VARCHAR(50)
)
LANGUAGE SQL
SPECIFIC STE_UPDATE_SEQ
BEGIN
	
	DECLARE V_MAXID BIGINT DEFAULT 1198;
	DECLARE V_SQL VARCHAR(8000);

	DECLARE cursor1 CURSOR WITH RETURN FOR SQL_SELECT;

	SET V_SQL = 'SELECT ISNULL(MAX(' ||P_COLNAME|| '),0)+1 AS MAXID FROM MAXIMO.' ||P_TABLENAME;

	PREPARE SQL_SELECT FROM V_SQL;

	OPEN cursor1;
	FETCH cursor1 INTO V_MAXID;
	CLOSE cursor1;

	SET V_SQL = 'ALTER SEQUENCE MAXIMO.' ||P_SEQNAME|| ' RESTART WITH ' ||V_MAXID;

	PREPARE SQL_UPDATE FROM V_SQL;
	EXECUTE SQL_UPDATE;

	SET V_SQL = 'update maximo.maxsequence set maxreserved=' ||V_MAXID|| ' where tbname=''' ||P_TABLENAME|| ''' and name=''' ||P_COLNAME|| '''';

	PREPARE SQL_UPDATE FROM V_SQL;
	EXECUTE SQL_UPDATE;

END;

-- SELECT MAX(LOCATIONSID)+1 AS MAXID FROM MAXIMO.LOCATIONS;
-- select next value for MAXIMO.LOCATIONSSEQ from SYSIBM.SYSDUMMY1;
-- ALTER SEQUENCE MAXIMO.LOCATIONSSEQ RESTART WITH 5000;
-- CALL MIGRATION.STE_UPDATE_SEQ('MAXIMO.LOCATIONSSEQ', 'MAXIMO.LOCATIONS', 'LOCATIONSID');

-- COST CENTER INVALID MAPPING
CREATE TABLE "MIGRATION"."SBST_COSTCENTER_INVALID_MAPPING"  (
		  "ID" BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY (  
		    START WITH +1  
		    INCREMENT BY +1  
		    MINVALUE +1  
		    MAXVALUE +9223372036854775807  
		    NO CYCLE  
		    CACHE 20  
		    NO ORDER ) , 
		  "COSWIN_CC" VARCHAR(250 OCTETS) NOT NULL , 
		  "MAXIMO_CC" VARCHAR(10 OCTETS) NOT NULL
 			)   
		 IN "USERSPACE1"  
		 ORGANIZE BY ROW;
		 
CREATE TABLE "MIGRATION"."SBST_USER_DISPLAYNAME_MAPPING"  (
		  "ID" BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY (  
		    START WITH +1  
		    INCREMENT BY +1  
		    MINVALUE +1  
		    MAXVALUE +9223372036854775807  
		    NO CYCLE  
		    CACHE 20  
		    NO ORDER ) , 
		  "DISPLAYNAME" VARCHAR(250 OCTETS) NOT NULL , 
		  "USERID" VARCHAR(50 OCTETS) NOT NULL
 			)   
		 IN "USERSPACE1"  
		 ORGANIZE BY ROW;		
		 
CREATE TABLE "MIGRATION"."SBST_SYSTEM_DEPT_MAPPING"  (
		  "ID" BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY (  
		    START WITH +1  
		    INCREMENT BY +1  
		    MINVALUE +1  
		    MAXVALUE +9223372036854775807  
		    NO CYCLE  
		    CACHE 20  
		    NO ORDER ) , 
		  "SYSTEM" VARCHAR(50 OCTETS) NOT NULL , 
		  "DEPT" VARCHAR(50 OCTETS) NOT NULL
 			)   
		 IN "USERSPACE1"  
		 ORGANIZE BY ROW;		
		 	
CREATE TABLE "MIGRATION"."SBST_ASSET_MASTER"  (
		  "ID" BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY (  
		    START WITH +1  
		    INCREMENT BY +1  
		    MINVALUE +1  
		    MAXVALUE +9223372036854775807  
		    NO CYCLE  
		    CACHE 20  
		    NO ORDER ) , 
		  "COSWINASSETID" VARCHAR(40 OCTETS) NOT NULL , 
		  "COSWINEQPTCODE" VARCHAR(25 OCTETS),
		  "LINE" VARCHAR(4 OCTETS),
		  "DEPOT" VARCHAR(10 OCTETS),
		  "DEPOTBUILDING" VARCHAR(10 OCTETS),
		  "STATION" VARCHAR(10 OCTETS),
		  "LEVEL" VARCHAR(10 OCTETS),
		  "AREA" VARCHAR(30 OCTETS),
		  "SYSTEM" VARCHAR(10 OCTETS),
		  "SUBSYSTEM" VARCHAR(10 OCTETS),
		  "DETAILCODE" VARCHAR(25 OCTETS),
		  "SHEET" VARCHAR(20 OCTETS)
 			)   
 		 IN "USERSPACE1"  
		 ORGANIZE BY ROW;
		 
ALTER TABLE MIGRATION.SBST_ASSET_MASTER ADD LOCATION VARCHAR(16);
ALTER TABLE MIGRATION.SBST_ASSET_MASTER ADD LOCATIONID BIGINT;

CREATE UNIQUE INDEX SBST_ASSET_MASTER_ID_IDX ON MIGRATION.SBST_ASSET_MASTER (ID);
ALTER TABLE MIGRATION.SBST_ASSET_MASTER ADD CONSTRAINT SBST_ASSET_MASTER_UQ UNIQUE (ID);
CREATE INDEX SBST_ASSET_MASTER_COSWINASSETID_IDX ON MIGRATION.SBST_ASSET_MASTER (COSWINASSETID);

CREATE TABLE "MIGRATION"."SBST_LOCATION_MASTER"  (
		  "ID" BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY (  
		    START WITH +1  
		    INCREMENT BY +1  
		    MINVALUE +1  
		    MAXVALUE +9223372036854775807  
		    NO CYCLE  
		    CACHE 20  
		    NO ORDER ) , 
		  "LOCATIONCODE" VARCHAR(50 OCTETS) NOT NULL , 
		  "TYPE" VARCHAR(25 OCTETS),
		  "LINE" VARCHAR(25 OCTETS),
		  "DESCRIPTION" VARCHAR(100 OCTETS),
		  "BUILDING" VARCHAR(50 OCTETS),
		  "LEVEL" VARCHAR(10 OCTETS),
		  "AREA" VARCHAR(30 OCTETS),
		  "STATION" VARCHAR(10 OCTETS),
		  "DEPOT" VARCHAR(10 OCTETS)
 			)   
 		 IN "USERSPACE1"  
		 ORGANIZE BY ROW;

ALTER TABLE MIGRATION.SBST_LOCATION_MASTER ADD CONSTRAINT SBST_LOCATION_MASTER_UNIQUE UNIQUE (ID);
CREATE UNIQUE INDEX SBST_LOCATION_MASTER_ID_IDX ON MIGRATION.SBST_LOCATION_MASTER (ID);
CREATE UNIQUE INDEX SBST_LOCATION_MASTER_LOCATIONCODE_IDX ON MIGRATION.SBST_LOCATION_MASTER (LOCATIONCODE);

CREATE TABLE "MIGRATION"."STE_MAXDOMAIN_VALIDATION"  (
		  "ID" BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY (  
		    START WITH +1  
		    INCREMENT BY +1  
		    MINVALUE +1  
		    MAXVALUE +9223372036854775807  
		    NO CYCLE  
		    CACHE 20  
		    NO ORDER ) , 
		  "DOMAINID" VARCHAR(50 OCTETS) NOT NULL , 
		  "DESCRIPTION" VARCHAR(100 OCTETS),
		  "DOMAINTYPE" VARCHAR(50 OCTETS),
		  "MAXTYPE" VARCHAR(10 OCTETS),
		  "TABLE" VARCHAR(250 OCTETS),
		  "COLUMN" VARCHAR(50 OCTETS)
 			)   
 		 IN "USERSPACE1"  
		 ORGANIZE BY ROW;

ALTER TABLE MIGRATION.STE_MAXDOMAIN_VALIDATION ADD CONSTRAINT STE_MAXDOMAIN_VALIDATION_UNIQUE UNIQUE (ID);
CREATE UNIQUE INDEX STE_MAXDOMAIN_VALIDATION_ID_IDX ON MIGRATION.STE_MAXDOMAIN_VALIDATION (ID);
CREATE INDEX STE_MAXDOMAIN_VALIDATION_DOMAINID_IDX ON MIGRATION.STE_MAXDOMAIN_VALIDATION (DOMAINID);

CREATE TABLE "MIGRATION"."STE_MAXDOMAIN_VALIDATION_LOG"  (
		  "ID" BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY (  
		    START WITH +1  
		    INCREMENT BY +1  
		    MINVALUE +1  
		    MAXVALUE +9223372036854775807  
		    NO CYCLE  
		    CACHE 20  
		    NO ORDER ) , 
		  "DOMAINID" VARCHAR(50 OCTETS) NOT NULL , 
		  "VALUE" VARCHAR(50 OCTETS),
		  "TABLE" VARCHAR(50 OCTETS),
		  "COLUMN" VARCHAR(50 OCTETS),
		  "TIMESTAMP" TIMESTAMP NOT NULL WITH DEFAULT CURRENT TIMESTAMP
 			)   
 		 IN "USERSPACE1"  
		 ORGANIZE BY ROW;

ALTER TABLE MIGRATION.STE_MIGRATION_LOGS ADD HOSTNAME VARCHAR(100);
