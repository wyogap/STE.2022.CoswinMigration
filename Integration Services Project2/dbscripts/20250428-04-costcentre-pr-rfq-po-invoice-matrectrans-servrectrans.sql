CALL MIGRATION.STE_START_PATCH('20250428-04-COSTCENTRE-PR-RFQ-PO-INVOICE');

-- BACKUP PRLINE, RFQLINE, POLINE, INVOICECOST
--DROP TABLE "MIGRATION"."BAK_20250428_PRLINE_GLDEBITACCT" IF EXISTS;
CREATE TABLE "MIGRATION"."BAK_20250428_PRLINE_GLDEBITACCT"  (
		  "PRLINEID" BIGINT,	
		  "PRNUM" VARCHAR(10 OCTETS),
		  "ITEMNUM" VARCHAR(30 OCTETS),
		  "STE_CSWNCC" VARCHAR(16 OCTETS),	
		  "STE_CSWNSAPGL" VARCHAR(20 OCTETS),	
		  "GLDEBITACCT" VARCHAR(110 OCTETS)
	)   
;

INSERT INTO "MIGRATION"."BAK_20250428_PRLINE_GLDEBITACCT" (
	PRLINEID, PRNUM, ITEMNUM, STE_CSWNCC, STE_CSWNSAPGL, GLDEBITACCT
)
SELECT A.PRLINEID, A.PRNUM, A.ITEMNUM, A.STE_CSWNCC, A.STE_CSWNSAPGL, A.GLDEBITACCT
FROM (
	SELECT A.PRLINEID, A.PRNUM, A.ITEMNUM
		, A.STE_CSWNCC AS STE_CSWNCC
		, COALESCE(X.MAXIMO_CC, A.STE_CSWNCC) AS COSTCENTRE
		, A.STE_CSWNSAPGL AS STE_CSWNSAPGL
		, CASE WHEN (UCASE(A.STE_CSWNSAPGL)=LCASE(A.STE_CSWNSAPGL) AND LENGTH(A.STE_CSWNSAPGL)=6) 
			OR UCASE(A.STE_CSWNSAPGL) IN ('CAPEX') THEN A.STE_CSWNSAPGL ELSE NULL END AS SAPGL
		, A.GLDEBITACCT
	FROM MAXIMO.PRLINE A
	LEFT JOIN MIGRATION.SBST_COSTCENTER_INVALID_MAPPING X ON X.COSWIN_CC=A.STE_CSWNCC
	WHERE A.STE_MIGRATIONID IS NOT NULL
) A
JOIN MAXIMO.GLCOMPONENTS Y ON Y.GLORDER=1 AND Y.COMPVALUE=A.COSTCENTRE
WHERE A.STE_CSWNCC!=A.COSTCENTRE OR COALESCE(A.STE_CSWNSAPGL,'')!=COALESCE(A.SAPGL,'')
;

--DROP TABLE "MIGRATION"."BAK_20250428_RFQLINE_GLDEBITACCT" IF EXISTS;
CREATE TABLE "MIGRATION"."BAK_20250428_RFQLINE_GLDEBITACCT"  (
		  "RFQLINEID" BIGINT,	
		  "RFQNUM" VARCHAR(15 OCTETS),
		  "ITEMNUM" VARCHAR(30 OCTETS),
		  "STE_CSWNCC" VARCHAR(16 OCTETS),	
		  "STE_CSWNSAPGL" VARCHAR(20 OCTETS),	
		  "GLDEBITACCT" VARCHAR(110 OCTETS)
	)   
;

INSERT INTO "MIGRATION"."BAK_20250428_RFQLINE_GLDEBITACCT" (
	RFQLINEID, RFQNUM, ITEMNUM, STE_CSWNCC, STE_CSWNSAPGL, GLDEBITACCT
)
SELECT A.RFQLINEID, A.RFQNUM, A.ITEMNUM, A.STE_CSWNCC, A.STE_CSWNSAPGL, A.GLDEBITACCT
FROM (
	SELECT A.RFQLINEID, A.RFQNUM, A.ITEMNUM
		, A.STE_CSWNCC AS STE_CSWNCC
		, COALESCE(X.MAXIMO_CC, A.STE_CSWNCC) AS COSTCENTRE
		, A.STE_CSWNSAPGL AS STE_CSWNSAPGL
		, CASE WHEN (UCASE(A.STE_CSWNSAPGL)=LCASE(A.STE_CSWNSAPGL) AND LENGTH(A.STE_CSWNSAPGL)=6) 
			OR UCASE(A.STE_CSWNSAPGL) IN ('CAPEX') THEN A.STE_CSWNSAPGL ELSE NULL END AS SAPGL
		, A.GLDEBITACCT
	FROM MAXIMO.RFQLINE A
	LEFT JOIN MIGRATION.SBST_COSTCENTER_INVALID_MAPPING X ON X.COSWIN_CC=A.STE_CSWNCC
	WHERE A.STE_MIGRATIONID IS NOT NULL
) A
JOIN MAXIMO.GLCOMPONENTS Y ON Y.GLORDER=1 AND Y.COMPVALUE=A.COSTCENTRE
WHERE A.STE_CSWNCC!=A.COSTCENTRE OR COALESCE(A.STE_CSWNSAPGL,'')!=COALESCE(A.SAPGL,'')
;

--DROP TABLE "MIGRATION"."BAK_20250428_POLINE_GLDEBITACCT" IF EXISTS;
CREATE TABLE "MIGRATION"."BAK_20250428_POLINE_GLDEBITACCT"  (
		  "POLINEID" BIGINT,	
		  "PONUM" VARCHAR(10 OCTETS),
		  "ITEMNUM" VARCHAR(30 OCTETS),
		  "STE_CSWNCC" VARCHAR(16 OCTETS),	
		  "STE_CSWNSAPGL" VARCHAR(20 OCTETS),	
		  "GLDEBITACCT" VARCHAR(110 OCTETS)
	)
;

INSERT INTO "MIGRATION"."BAK_20250428_POLINE_GLDEBITACCT" (
	POLINEID, PONUM, ITEMNUM, STE_CSWNCC, STE_CSWNSAPGL, GLDEBITACCT
)
SELECT A.POLINEID, A.PONUM, A.ITEMNUM, A.STE_CSWNCC, A.STE_CSWNSAPGL, A.GLDEBITACCT
FROM (
	SELECT A.POLINEID, A.PONUM, A.ITEMNUM
		, A.STE_CSWNCC AS STE_CSWNCC
		, COALESCE(X.MAXIMO_CC, A.STE_CSWNCC) AS COSTCENTRE
		, A.STE_CSWNSAPGL AS STE_CSWNSAPGL
		, CASE WHEN (UCASE(A.STE_CSWNSAPGL)=LCASE(A.STE_CSWNSAPGL) AND LENGTH(A.STE_CSWNSAPGL)=6) 
			OR UCASE(A.STE_CSWNSAPGL) IN ('CAPEX') THEN A.STE_CSWNSAPGL ELSE NULL END AS SAPGL
		, A.GLDEBITACCT
	FROM MAXIMO.POLINE A
	LEFT JOIN MIGRATION.SBST_COSTCENTER_INVALID_MAPPING X ON X.COSWIN_CC=A.STE_CSWNCC
	WHERE A.STE_MIGRATIONID IS NOT NULL
) A
JOIN MAXIMO.GLCOMPONENTS Y ON Y.GLORDER=1 AND Y.COMPVALUE=A.COSTCENTRE
WHERE A.STE_CSWNCC!=A.COSTCENTRE OR COALESCE(A.STE_CSWNSAPGL,'')!=COALESCE(A.SAPGL,'')
;

--DROP TABLE "MIGRATION"."BAK_20250428_INVOICECOST_GLDEBITACCT" IF EXISTS;
CREATE TABLE "MIGRATION"."BAK_20250428_INVOICECOST_GLDEBITACCT"  (
		  "INVOICECOSTID" BIGINT,	
		  "INVOICENUM" VARCHAR(15 OCTETS),
		  "INVOICELINENUM" INTEGER,
		  "STE_CSWNCC" VARCHAR(16 OCTETS),	
		  "STE_CSWNSAPGL" VARCHAR(20 OCTETS),	
		  "GLDEBITACCT" VARCHAR(110 OCTETS)
	)
;

INSERT INTO "MIGRATION"."BAK_20250428_INVOICECOST_GLDEBITACCT" (
	INVOICECOSTID, INVOICENUM, INVOICELINENUM, STE_CSWNCC, STE_CSWNSAPGL, GLDEBITACCT
)
SELECT A.INVOICECOSTID, A.INVOICENUM, A.INVOICELINENUM, A.STE_CSWNCC, A.STE_CSWNSAPGL, A.GLDEBITACCT
FROM (
	SELECT A.INVOICECOSTID, A.INVOICENUM, A.INVOICELINENUM
		, A.STE_CSWNCC AS STE_CSWNCC
		, COALESCE(X.MAXIMO_CC, A.STE_CSWNCC) AS COSTCENTRE
		, A.STE_CSWNSAPGL AS STE_CSWNSAPGL
		, CASE WHEN (UCASE(A.STE_CSWNSAPGL)=LCASE(A.STE_CSWNSAPGL) AND LENGTH(A.STE_CSWNSAPGL)=6) 
			OR UCASE(A.STE_CSWNSAPGL) IN ('CAPEX') THEN A.STE_CSWNSAPGL ELSE NULL END AS SAPGL
		, A.GLDEBITACCT
	FROM MAXIMO.INVOICECOST A
	LEFT JOIN MIGRATION.SBST_COSTCENTER_INVALID_MAPPING X ON X.COSWIN_CC=A.STE_CSWNCC
	WHERE A.STE_MIGRATIONID IS NOT NULL
) A
JOIN MAXIMO.GLCOMPONENTS Y ON Y.GLORDER=1 AND Y.COMPVALUE=A.COSTCENTRE
WHERE A.STE_CSWNCC!=A.COSTCENTRE OR COALESCE(A.STE_CSWNSAPGL,'')!=COALESCE(A.SAPGL,'')
;

-- PRLINE (85.379)
MERGE INTO MAXIMO.PRLINE A
USING (
	SELECT A.PRLINEID, A.PRNUM, A.ITEMNUM, A.STE_CSWNCC, A.STE_CSWNSAPGL, A.GLDEBITACCT
		, Y.STE_COSTCENTREDEPT
		, A.COSTCENTRE, A.SAPGL
		, CASE WHEN A.SAPGL IS NULL THEN CONCAT(Y.STE_COSTCENTREDEPT, CONCAT('-', A.COSTCENTRE))
			ELSE CONCAT(Y.STE_COSTCENTREDEPT, CONCAT('-', CONCAT(A.COSTCENTRE, CONCAT('-', A.SAPGL))))
		  END AS NEW_GLACCOUNT
	FROM (
		SELECT A.PRLINEID, A.PRNUM, A.ITEMNUM
			, A.STE_CSWNCC AS STE_CSWNCC
			, COALESCE(X.MAXIMO_CC, A.STE_CSWNCC) AS COSTCENTRE
			, A.STE_CSWNSAPGL AS STE_CSWNSAPGL
			, CASE WHEN (UCASE(A.STE_CSWNSAPGL)=LCASE(A.STE_CSWNSAPGL) AND LENGTH(A.STE_CSWNSAPGL)=6) 
				OR UCASE(A.STE_CSWNSAPGL) IN ('CAPEX') THEN A.STE_CSWNSAPGL ELSE NULL END AS SAPGL
			, A.GLDEBITACCT
		FROM MAXIMO.PRLINE A
		LEFT JOIN MIGRATION.SBST_COSTCENTER_INVALID_MAPPING X ON X.COSWIN_CC=A.STE_CSWNCC
		WHERE A.STE_MIGRATIONID IS NOT NULL
	) A
	JOIN MAXIMO.GLCOMPONENTS Y ON Y.GLORDER=1 AND Y.COMPVALUE=A.COSTCENTRE
	WHERE A.STE_CSWNCC!=A.COSTCENTRE OR COALESCE(A.STE_CSWNSAPGL,'')!=COALESCE(A.SAPGL,'')
) B ON B.PRLINEID=A.PRLINEID
WHEN MATCHED THEN
UPDATE SET
	GLDEBITACCT=B.NEW_GLACCOUNT
;

-- NEW DATA: 1227
INSERT INTO MAXIMO.CHARTOFACCOUNTS (
	GLACCOUNT, GLCOMP01, GLCOMP02, GLCOMP03, ACCOUNTNAME, ORGID, ACTIVE
	, LANGCODE, HASLD, ACTIVEDATE
	, STE_MIGRATIONID, STE_MIGRATIONDATE, STE_MIGRATIONSOURCE
	, CHARTOFACCOUNTSID
)
SELECT A.GLDEBITACCT AS GLACCOUNT
	, CASE WHEN A.GLDEBITACCT IS NULL THEN NULL
		   ELSE SUBSTR(A.GLDEBITACCT, 1, LOCATE('-', A.GLDEBITACCT)-1)
	  END AS Department
	, CASE WHEN A.GLDEBITACCT IS NULL THEN NULL
	       WHEN length(A.GLDEBITACCT) - length(replace(A.GLDEBITACCT,'-','')) >= 2 THEN
				SUBSTR(A.GLDEBITACCT, LOCATE('-', A.GLDEBITACCT)+1, LOCATE('-', A.GLDEBITACCT, LOCATE('-', A.GLDEBITACCT)+1)-LOCATE('-', A.GLDEBITACCT)-1)
		   ELSE SUBSTR(A.GLDEBITACCT, LOCATE('-', A.GLDEBITACCT)+1)
	  END AS Costcentre
	, CASE WHEN A.GLDEBITACCT IS NULL THEN NULL
	       WHEN length(A.GLDEBITACCT) - length(replace(A.GLDEBITACCT,'-','')) < 2 THEN NULL
		   ELSE SUBSTR(A.GLDEBITACCT, LOCATE('-', A.GLDEBITACCT, LOCATE('-', A.GLDEBITACCT)+1)+1)
	  END AS SAPGL
	, 'CostCenter' AS ACCOUNTNAME
	, 'SBST' AS ORGID
	, 1 AS ACTIVE
	, 'EN' AS LANGCODE
	, 0 AS HASLD
	, '2000-01-01' AS ACTIVEDATE
	, A.STE_MIGRATIONID
	, ADD_HOURS(CURRENT_TIMESTAMP, 8) AS STE_MIGRATIONDATE
	, 'PRLINE' AS STE_MIGRATIONSOURCE
	, X.MAXID + ROW_NUMBER() OVER (ORDER BY A.STE_MIGRATIONID) AS CHARTOFACCOUNTSID
FROM (
	SELECT GLDEBITACCT, MIN(STE_MIGRATIONID) AS STE_MIGRATIONID FROM MAXIMO.PRLINE 
	GROUP BY GLDEBITACCT
) A
LEFT JOIN MAXIMO.CHARTOFACCOUNTS B ON B.GLACCOUNT=A.GLDEBITACCT
JOIN (
	SELECT MAX(CHARTOFACCOUNTSID) AS MAXID FROM MAXIMO.CHARTOFACCOUNTS
) X ON 1=1
WHERE A.GLDEBITACCT IS NOT NULL AND B.CHARTOFACCOUNTSID IS NULL
;

-- PRCOST (85.306)
MERGE INTO MAXIMO.PRCOST A
USING (
	SELECT A.PRCOSTID, A.PRNUM, A.PRLINEID, A.GLDEBITACCT, B.GLDEBITACCT AS NEW_GLACCOUNT
	FROM MAXIMO.PRCOST A
	JOIN MAXIMO.PRLINE B ON B.PRNUM=A.PRNUM AND B.PRLINEID=A.PRLINEID
	WHERE COALESCE(A.GLDEBITACCT,'')!=COALESCE(B.GLDEBITACCT,'')
		AND B.STE_MIGRATIONID IS NOT NULL
) B ON B.PRCOSTID=A.PRCOSTID
WHEN MATCHED THEN
UPDATE SET
	GLDEBITACCT=B.NEW_GLACCOUNT
;

-- RFQLINE (69.964)
MERGE INTO MAXIMO.RFQLINE A
USING (
	SELECT A.RFQLINEID, A.RFQNUM, A.ITEMNUM, A.STE_CSWNCC, A.STE_CSWNSAPGL, A.GLDEBITACCT
		, Y.STE_COSTCENTREDEPT
		, A.COSTCENTRE, A.SAPGL
		, CASE WHEN A.SAPGL IS NULL THEN CONCAT(Y.STE_COSTCENTREDEPT, CONCAT('-', A.COSTCENTRE))
			ELSE CONCAT(Y.STE_COSTCENTREDEPT, CONCAT('-', CONCAT(A.COSTCENTRE, CONCAT('-', A.SAPGL))))
		  END AS NEW_GLACCOUNT
	FROM (
		SELECT A.RFQLINEID, A.RFQNUM, A.ITEMNUM
			, A.STE_CSWNCC AS STE_CSWNCC
			, COALESCE(X.MAXIMO_CC, A.STE_CSWNCC) AS COSTCENTRE
			, A.STE_CSWNSAPGL AS STE_CSWNSAPGL
			, CASE WHEN (UCASE(A.STE_CSWNSAPGL)=LCASE(A.STE_CSWNSAPGL) AND LENGTH(A.STE_CSWNSAPGL)=6) 
				OR UCASE(A.STE_CSWNSAPGL) IN ('CAPEX') THEN A.STE_CSWNSAPGL ELSE NULL END AS SAPGL
			, A.GLDEBITACCT
		FROM MAXIMO.RFQLINE A
		LEFT JOIN MIGRATION.SBST_COSTCENTER_INVALID_MAPPING X ON X.COSWIN_CC=A.STE_CSWNCC
		WHERE A.STE_MIGRATIONID IS NOT NULL
	) A
	JOIN MAXIMO.GLCOMPONENTS Y ON Y.GLORDER=1 AND Y.COMPVALUE=A.COSTCENTRE
	WHERE A.STE_CSWNCC!=A.COSTCENTRE OR COALESCE(A.STE_CSWNSAPGL,'')!=COALESCE(A.SAPGL,'')
) B ON B.RFQLINEID=A.RFQLINEID
WHEN MATCHED THEN
UPDATE SET
	GLDEBITACCT=B.NEW_GLACCOUNT,
	STE_COSC=B.COSTCENTRE
;

-- NEW DATA: 13
INSERT INTO MAXIMO.CHARTOFACCOUNTS (
	GLACCOUNT, GLCOMP01, GLCOMP02, GLCOMP03, ACCOUNTNAME, ORGID, ACTIVE
	, LANGCODE, HASLD, ACTIVEDATE
	, STE_MIGRATIONID, STE_MIGRATIONDATE, STE_MIGRATIONSOURCE
	, CHARTOFACCOUNTSID
)
SELECT A.GLDEBITACCT AS GLACCOUNT
	, CASE WHEN A.GLDEBITACCT IS NULL THEN NULL
		   ELSE SUBSTR(A.GLDEBITACCT, 1, LOCATE('-', A.GLDEBITACCT)-1)
	  END AS Department
	, CASE WHEN A.GLDEBITACCT IS NULL THEN NULL
	       WHEN length(A.GLDEBITACCT) - length(replace(A.GLDEBITACCT,'-','')) >= 2 THEN
				SUBSTR(A.GLDEBITACCT, LOCATE('-', A.GLDEBITACCT)+1, LOCATE('-', A.GLDEBITACCT, LOCATE('-', A.GLDEBITACCT)+1)-LOCATE('-', A.GLDEBITACCT)-1)
		   ELSE SUBSTR(A.GLDEBITACCT, LOCATE('-', A.GLDEBITACCT)+1)
	  END AS Costcentre
	, CASE WHEN A.GLDEBITACCT IS NULL THEN NULL
	       WHEN length(A.GLDEBITACCT) - length(replace(A.GLDEBITACCT,'-','')) < 2 THEN NULL
		   ELSE SUBSTR(A.GLDEBITACCT, LOCATE('-', A.GLDEBITACCT, LOCATE('-', A.GLDEBITACCT)+1)+1)
	  END AS SAPGL
	, 'CostCenter' AS ACCOUNTNAME
	, 'SBST' AS ORGID
	, 1 AS ACTIVE
	, 'EN' AS LANGCODE
	, 0 AS HASLD
	, '2000-01-01' AS ACTIVEDATE
	, A.STE_MIGRATIONID
	, ADD_HOURS(CURRENT_TIMESTAMP, 8) AS STE_MIGRATIONDATE
	, 'RFQLINE' AS STE_MIGRATIONSOURCE
	, X.MAXID + ROW_NUMBER() OVER (ORDER BY A.STE_MIGRATIONID) AS CHARTOFACCOUNTSID
FROM (
	SELECT GLDEBITACCT, MIN(STE_MIGRATIONID) AS STE_MIGRATIONID FROM MAXIMO.RFQLINE 
	GROUP BY GLDEBITACCT
) A
LEFT JOIN MAXIMO.CHARTOFACCOUNTS B ON B.GLACCOUNT=A.GLDEBITACCT
JOIN (
	SELECT MAX(CHARTOFACCOUNTSID) AS MAXID FROM MAXIMO.CHARTOFACCOUNTS
) X ON 1=1
WHERE A.GLDEBITACCT IS NOT NULL AND B.CHARTOFACCOUNTSID IS NULL
;

-- POLINE (75.296)
MERGE INTO MAXIMO.POLINE A
USING (
	SELECT A.POLINEID, A.PONUM, A.ITEMNUM, A.STE_CSWNCC, A.STE_CSWNSAPGL, A.GLDEBITACCT
		, Y.STE_COSTCENTREDEPT
		, A.COSTCENTRE, A.SAPGL
		, CASE WHEN A.SAPGL IS NULL THEN CONCAT(Y.STE_COSTCENTREDEPT, CONCAT('-', A.COSTCENTRE))
			ELSE CONCAT(Y.STE_COSTCENTREDEPT, CONCAT('-', CONCAT(A.COSTCENTRE, CONCAT('-', A.SAPGL))))
		  END AS NEW_GLACCOUNT
	FROM (
		SELECT A.POLINEID, A.PONUM, A.ITEMNUM
			, A.STE_CSWNCC AS STE_CSWNCC
			, COALESCE(X.MAXIMO_CC, A.STE_CSWNCC) AS COSTCENTRE
			, A.STE_CSWNSAPGL AS STE_CSWNSAPGL
			, CASE WHEN (UCASE(A.STE_CSWNSAPGL)=LCASE(A.STE_CSWNSAPGL) AND LENGTH(A.STE_CSWNSAPGL)=6) 
				OR UCASE(A.STE_CSWNSAPGL) IN ('CAPEX') THEN A.STE_CSWNSAPGL ELSE NULL END AS SAPGL
			, A.GLDEBITACCT
		FROM MAXIMO.POLINE A
		LEFT JOIN MIGRATION.SBST_COSTCENTER_INVALID_MAPPING X ON X.COSWIN_CC=A.STE_CSWNCC
		WHERE A.STE_MIGRATIONID IS NOT NULL
	) A
	JOIN MAXIMO.GLCOMPONENTS Y ON Y.GLORDER=1 AND Y.COMPVALUE=A.COSTCENTRE
	WHERE A.STE_CSWNCC!=A.COSTCENTRE OR COALESCE(A.STE_CSWNSAPGL,'')!=COALESCE(A.SAPGL,'')
) B ON B.POLINEID=A.POLINEID
WHEN MATCHED THEN
UPDATE SET
	GLDEBITACCT=B.NEW_GLACCOUNT
;

-- NEW DATA: 36
INSERT INTO MAXIMO.CHARTOFACCOUNTS (
	GLACCOUNT, GLCOMP01, GLCOMP02, GLCOMP03, ACCOUNTNAME, ORGID, ACTIVE
	, LANGCODE, HASLD, ACTIVEDATE
	, STE_MIGRATIONID, STE_MIGRATIONDATE, STE_MIGRATIONSOURCE
	, CHARTOFACCOUNTSID
)
SELECT A.GLDEBITACCT AS GLACCOUNT
	, CASE WHEN A.GLDEBITACCT IS NULL THEN NULL
		   ELSE SUBSTR(A.GLDEBITACCT, 1, LOCATE('-', A.GLDEBITACCT)-1)
	  END AS Department
	, CASE WHEN A.GLDEBITACCT IS NULL THEN NULL
	       WHEN length(A.GLDEBITACCT) - length(replace(A.GLDEBITACCT,'-','')) >= 2 THEN
				SUBSTR(A.GLDEBITACCT, LOCATE('-', A.GLDEBITACCT)+1, LOCATE('-', A.GLDEBITACCT, LOCATE('-', A.GLDEBITACCT)+1)-LOCATE('-', A.GLDEBITACCT)-1)
		   ELSE SUBSTR(A.GLDEBITACCT, LOCATE('-', A.GLDEBITACCT)+1)
	  END AS Costcentre
	, CASE WHEN A.GLDEBITACCT IS NULL THEN NULL
	       WHEN length(A.GLDEBITACCT) - length(replace(A.GLDEBITACCT,'-','')) < 2 THEN NULL
		   ELSE SUBSTR(A.GLDEBITACCT, LOCATE('-', A.GLDEBITACCT, LOCATE('-', A.GLDEBITACCT)+1)+1)
	  END AS SAPGL
	, 'CostCenter' AS ACCOUNTNAME
	, 'SBST' AS ORGID
	, 1 AS ACTIVE
	, 'EN' AS LANGCODE
	, 0 AS HASLD
	, '2000-01-01' AS ACTIVEDATE
	, A.STE_MIGRATIONID
	, ADD_HOURS(CURRENT_TIMESTAMP, 8) AS STE_MIGRATIONDATE
	, 'POLINE' AS STE_MIGRATIONSOURCE
	, X.MAXID + ROW_NUMBER() OVER (ORDER BY A.STE_MIGRATIONID) AS CHARTOFACCOUNTSID
FROM (
	SELECT GLDEBITACCT, MIN(STE_MIGRATIONID) AS STE_MIGRATIONID FROM MAXIMO.POLINE
	GROUP BY GLDEBITACCT
) A
LEFT JOIN MAXIMO.CHARTOFACCOUNTS B ON B.GLACCOUNT=A.GLDEBITACCT
JOIN (
	SELECT MAX(CHARTOFACCOUNTSID) AS MAXID FROM MAXIMO.CHARTOFACCOUNTS
) X ON 1=1
WHERE A.GLDEBITACCT IS NOT NULL AND B.CHARTOFACCOUNTSID IS NULL
;

-- POCOST (75.257)
MERGE INTO MAXIMO.POCOST A
USING (
	SELECT A.POCOSTID, A.PONUM, A.POLINEID, A.GLDEBITACCT, B.GLDEBITACCT AS NEW_GLACCOUNT
	FROM MAXIMO.POCOST A
	JOIN MAXIMO.POLINE B ON B.PONUM=A.PONUM AND B.POLINEID=A.POLINEID
	WHERE COALESCE(A.GLDEBITACCT,'')!=COALESCE(B.GLDEBITACCT,'')
		AND B.STE_MIGRATIONID IS NOT NULL
) B ON B.POCOSTID=A.POCOSTID
WHEN MATCHED THEN
UPDATE SET
	GLDEBITACCT=B.NEW_GLACCOUNT
;

-- MATRECTRANS (71.239)
MERGE INTO MAXIMO.MATRECTRANS A
USING (
	SELECT A.MATRECTRANSID, A.PONUM, A.POLINENUM, A.GLDEBITACCT, B.GLDEBITACCT AS NEW_GLACCOUNT
	FROM MAXIMO.MATRECTRANS A
	JOIN MAXIMO.POLINE B ON B.PONUM=A.PONUM AND B.POLINENUM=A.POLINENUM
	WHERE A.STE_MIGRATIONSOURCE='RCT_ITEMS'
		AND COALESCE(A.GLDEBITACCT,'')!=COALESCE(B.GLDEBITACCT,'')
) B ON B.MATRECTRANSID=A.MATRECTRANSID
WHEN MATCHED THEN
UPDATE SET
	GLDEBITACCT=B.NEW_GLACCOUNT
;

-- SERVRECTRANS (26.823)
MERGE INTO MAXIMO.SERVRECTRANS A
USING (
	SELECT A.SERVRECTRANSID, A.PONUM, A.POLINENUM, A.GLDEBITACCT, B.GLDEBITACCT AS NEW_GLACCOUNT
	FROM MAXIMO.SERVRECTRANS A
	JOIN MAXIMO.POLINE B ON B.PONUM=A.PONUM AND B.POLINENUM=A.POLINENUM
	WHERE COALESCE(A.GLDEBITACCT,'')!=COALESCE(B.GLDEBITACCT,'')
		AND A.STE_MIGRATIONID IS NOT NULL
) B ON B.SERVRECTRANSID=A.SERVRECTRANSID
WHEN MATCHED THEN
UPDATE SET
	GLDEBITACCT=B.NEW_GLACCOUNT
;

-- INVOICECOST (93.415)
MERGE INTO MAXIMO.INVOICECOST A
USING (
	SELECT A.INVOICECOSTID, A.INVOICENUM, A.INVOICELINENUM, A.STE_CSWNCC, A.STE_CSWNSAPGL, A.GLDEBITACCT
		, Y.STE_COSTCENTREDEPT
		, A.COSTCENTRE, A.SAPGL
		, CASE WHEN A.SAPGL IS NULL THEN CONCAT(Y.STE_COSTCENTREDEPT, CONCAT('-', A.COSTCENTRE))
			ELSE CONCAT(Y.STE_COSTCENTREDEPT, CONCAT('-', CONCAT(A.COSTCENTRE, CONCAT('-', A.SAPGL))))
		  END AS NEW_GLACCOUNT
	FROM (
		SELECT A.INVOICECOSTID, A.INVOICENUM, A.INVOICELINENUM
			, A.STE_CSWNCC AS STE_CSWNCC
			, COALESCE(X.MAXIMO_CC, A.STE_CSWNCC) AS COSTCENTRE
			, A.STE_CSWNSAPGL AS STE_CSWNSAPGL
			, CASE WHEN (UCASE(A.STE_CSWNSAPGL)=LCASE(A.STE_CSWNSAPGL) AND LENGTH(A.STE_CSWNSAPGL)=6) 
				OR UCASE(A.STE_CSWNSAPGL) IN ('CAPEX') THEN A.STE_CSWNSAPGL ELSE NULL END AS SAPGL
			, A.GLDEBITACCT
		FROM MAXIMO.INVOICECOST A
		LEFT JOIN MIGRATION.SBST_COSTCENTER_INVALID_MAPPING X ON X.COSWIN_CC=A.STE_CSWNCC
		WHERE A.STE_MIGRATIONID IS NOT NULL
	) A
	JOIN MAXIMO.GLCOMPONENTS Y ON Y.GLORDER=1 AND Y.COMPVALUE=A.COSTCENTRE
	WHERE A.STE_CSWNCC!=A.COSTCENTRE OR COALESCE(A.STE_CSWNSAPGL,'')!=COALESCE(A.SAPGL,'')
) B ON B.INVOICECOSTID=A.INVOICECOSTID
WHEN MATCHED THEN
UPDATE SET
	GLDEBITACCT=B.NEW_GLACCOUNT
;

-- NEW DATA: 42
INSERT INTO MAXIMO.CHARTOFACCOUNTS (
	GLACCOUNT, GLCOMP01, GLCOMP02, GLCOMP03, ACCOUNTNAME, ORGID, ACTIVE
	, LANGCODE, HASLD, ACTIVEDATE
	, STE_MIGRATIONID, STE_MIGRATIONDATE, STE_MIGRATIONSOURCE
	, CHARTOFACCOUNTSID
)
SELECT A.GLDEBITACCT AS GLACCOUNT
	, CASE WHEN A.GLDEBITACCT IS NULL THEN NULL
		   ELSE SUBSTR(A.GLDEBITACCT, 1, LOCATE('-', A.GLDEBITACCT)-1)
	  END AS Department
	, CASE WHEN A.GLDEBITACCT IS NULL THEN NULL
	       WHEN length(A.GLDEBITACCT) - length(replace(A.GLDEBITACCT,'-','')) >= 2 THEN
				SUBSTR(A.GLDEBITACCT, LOCATE('-', A.GLDEBITACCT)+1, LOCATE('-', A.GLDEBITACCT, LOCATE('-', A.GLDEBITACCT)+1)-LOCATE('-', A.GLDEBITACCT)-1)
		   ELSE SUBSTR(A.GLDEBITACCT, LOCATE('-', A.GLDEBITACCT)+1)
	  END AS Costcentre
	, CASE WHEN A.GLDEBITACCT IS NULL THEN NULL
	       WHEN length(A.GLDEBITACCT) - length(replace(A.GLDEBITACCT,'-','')) < 2 THEN NULL
		   ELSE SUBSTR(A.GLDEBITACCT, LOCATE('-', A.GLDEBITACCT, LOCATE('-', A.GLDEBITACCT)+1)+1)
	  END AS SAPGL
	, 'CostCenter' AS ACCOUNTNAME
	, 'SBST' AS ORGID
	, 1 AS ACTIVE
	, 'EN' AS LANGCODE
	, 0 AS HASLD
	, '2000-01-01' AS ACTIVEDATE
	, A.STE_MIGRATIONID
	, ADD_HOURS(CURRENT_TIMESTAMP, 8) AS STE_MIGRATIONDATE
	, 'INVOICECOST' AS STE_MIGRATIONSOURCE
	, X.MAXID + ROW_NUMBER() OVER (ORDER BY A.STE_MIGRATIONID) AS CHARTOFACCOUNTSID
FROM (
	SELECT GLDEBITACCT, MIN(STE_MIGRATIONID) AS STE_MIGRATIONID FROM MAXIMO.INVOICECOST 
	GROUP BY GLDEBITACCT
) A
LEFT JOIN MAXIMO.CHARTOFACCOUNTS B ON B.GLACCOUNT=A.GLDEBITACCT
JOIN (
	SELECT MAX(CHARTOFACCOUNTSID) AS MAXID FROM MAXIMO.CHARTOFACCOUNTS
) X ON 1=1
WHERE A.GLDEBITACCT IS NOT NULL AND B.CHARTOFACCOUNTSID IS NULL
;

-- UPDATE COA MAXID
CALL MIGRATION.STE_UPDATE_SEQ('CHARTOFACCOUNTSSEQ', 'CHARTOFACCOUNTS', 'CHARTOFACCOUNTSID');

CALL MIGRATION.STE_FINISH_PATCH('20250428-04-COSTCENTRE-PR-RFQ-PO-INVOICE');