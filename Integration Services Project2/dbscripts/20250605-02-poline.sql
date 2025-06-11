CALL MIGRATION.STE_START_PATCH('20250605-02-POLINE');

--CREATE TABLE "MAXIMO"."CSWN_POLINE" 
--(	
--   "PK_PO_ITEMS" BIGINT, 
--	"TIMESTAMP" BIGINT, 
--	"S_NSITEM_PO" BIGINT, 
--	"S_ITEM_PO" BIGINT, 
--	"DT_PO_ITEMS" BIGINT, 
--	"TM_PO_ITEMS" BIGINT, 
--	"PO_NST_REF" VARCHAR(2), 
--	"PO_QTY" DECIMAL(28,12), 
--	"PO_PENDING_QTY" DECIMAL(28,12), 
--	"PO_INV_QTY" DECIMAL(28,12), 
--	"PO_UNIT" VARCHAR(6), 
--	"PO_UNIT_RATE" DECIMAL(28,12), 
--	"PO_RCT_QTY" DECIMAL(28,12), 
--	"PO_TP_FLG" INTEGER, 
--	"PO_ITEM_DEL_DT" BIGINT, 
--	"PO_ITEM_1EXTRA" DECIMAL(28,12), 
--	"PO_DISCNT" INTEGER, 
--	"PO_IT_NUMBER1" DECIMAL(28,12), 
--	"PO_IT_STRING1" VARCHAR(20), 
--	"PO_STOR_CD" VARCHAR(10),
--	"PK_PORDER_" BIGINT, 
--	"PO_REF" VARCHAR(10), 
--	"DR_TXT1" VARCHAR(13), 
--	"DR_TXT2" VARCHAR(10), 
--	"PO_AMD_WHO" VARCHAR(16), 
--	"PO_AMD_DT" BIGINT, 
--	"PO_AMD_NO" BIGINT, 
--	"PO_STRING1" VARCHAR(20), 
--	"PO_DEM_WO_REF" VARCHAR(10), 
--	PK_WIP_WO BIGINT, 
--	ITEM_CD VARCHAR(20), 
--	ITEM_DS VARCHAR(104), 
--	CATEGORY VARCHAR(10),
--	PK_SUPPLIER_ BIGINT,
--	SUPL_CD VARCHAR(20), 
--	SUPL_NAME VARCHAR(104), 
--	PK_SUPL_ITEMS BIGINT,
--	S_ITEM_REF VARCHAR(20), 
--	AMD_USER_ID VARCHAR(16),
--	CC_CD VARCHAR(16), 
--	LINENUM INTEGER
--)
-- IN "MAXDATA"  
-- ORGANIZE BY ROW;

-- BRING TABLE "MAXIMO"."CSWN_POLINE" FROM ON-PREM

-- BACKUP
-- DROP TABLE "MIGRATION"."BAK_20250605_POLINE";
CREATE TABLE "MIGRATION"."BAK_20250605_POLINE"(
	POLINEID BIGINT,
	PONUM VARCHAR(10),
	ITEMNUM VARCHAR(30),
	ORDERQTY DECIMAL(15,2),
	LINECOST DECIMAL(12,2),
	UNITCOST DECIMAL(12,2),
	NEW_LINECOST DECIMAL(12,2),
	NEW_UNITCOST DECIMAL(12,2),
	CONTRACT_UNITCOST DECIMAL(10,2)
);

INSERT INTO "MIGRATION"."BAK_20250605_POLINE"(
	POLINEID, PONUM, ITEMNUM, ORDERQTY, LINECOST, UNITCOST, NEW_LINECOST, NEW_UNITCOST, CONTRACT_UNITCOST
)
SELECT A.POLINEID, A.PONUM, A.ITEMNUM, A.ORDERQTY, A.UNITCOST, A.LINECOST
	, TRUNCATE(e.PO_UNIT_RATE,2) AS NEW_UNITCOST, TRUNCATE(e.PO_UNIT_RATE*A.ORDERQTY,2) AS NEW_LINECOST
	, c.unitcost AS contract_unitcost
FROM maximo.poline a
JOIN maximo.po b ON b.ponum=a.ponum
LEFT JOIN (
	SELECT c.contractnum, d.startdate, c.itemnum, c.unitcost
	FROM maximo.contractline c
	JOIN maximo.contract d ON d.contractnum=c.contractnum
	WHERE d.contracttype='PRICE'
) c ON c.contractnum=b.contractrefnum AND c.itemnum=a.itemnum
	AND CAST(b.orderdate AS date)>=CAST(c.startdate AS date)
	AND c.unitcost!=a.unitcost
	AND ABS(c.unitcost-a.unitcost)<0.02 
JOIN maximo.cswn_poline e ON e.PK_PO_ITEMS=a.ste_migrationid
WHERE 1=1
	AND (TRUNCATE(E.PO_UNIT_RATE,2)!=a.unitcost OR c.unitcost IS NOT NULL)
;

-- UPDATE
MERGE INTO MAXIMO.POLINE A
USING (
	SELECT A.POLINEID, A.PONUM, A.ITEMNUM, A.ORDERQTY, A.UNITCOST, A.LINECOST
		, TRUNCATE(e.PO_UNIT_RATE,2) AS NEW_UNITCOST, TRUNCATE(e.PO_UNIT_RATE*A.ORDERQTY,2) AS NEW_LINECOST
		, c.unitcost AS contract_unitcost
	FROM maximo.poline a
	JOIN maximo.po b ON b.ponum=a.ponum
	LEFT JOIN (
		SELECT c.contractnum, d.startdate, c.itemnum, c.unitcost
		FROM maximo.contractline c
		JOIN maximo.contract d ON d.contractnum=c.contractnum
		WHERE d.contracttype='PRICE'
	) c ON c.contractnum=b.contractrefnum AND c.itemnum=a.itemnum
		AND CAST(b.orderdate AS date)>=CAST(c.startdate AS date)
		AND c.unitcost!=a.unitcost
		AND ABS(c.unitcost-a.unitcost)<0.02 
	JOIN maximo.cswn_poline e ON e.PK_PO_ITEMS=a.ste_migrationid
	WHERE 1=1
		AND (TRUNCATE(E.PO_UNIT_RATE,2)!=a.unitcost OR c.unitcost IS NOT NULL)
) B ON B.POLINEID=A.POLINEID
WHEN MATCHED THEN
UPDATE SET
	LINECOST=B.NEW_LINECOST,
	UNITCOST=COALESCE(B.contract_unitcost, B.NEW_UNITCOST)
;

-- backup
INSERT INTO "MIGRATION"."BAK_20250605_POLINE"(
	POLINEID, PONUM, ITEMNUM, ORDERQTY, LINECOST, UNITCOST, NEW_LINECOST, NEW_UNITCOST, CONTRACT_UNITCOST
)
SELECT A.POLINEID, A.PONUM, A.ITEMNUM, A.ORDERQTY, A.UNITCOST, A.LINECOST
	, TRUNCATE(e.PO_UNIT_RATE,2) AS NEW_UNITCOST, TRUNCATE(e.PO_UNIT_RATE*A.ORDERQTY,2) AS NEW_LINECOST
	, c.unitcost AS contract_unitcost
FROM maximo.poline a
JOIN maximo.po b ON b.ponum=a.ponum
LEFT JOIN (
	SELECT c.contractnum, d.startdate, c.itemnum, c.unitcost
	FROM maximo.contractline c
	JOIN maximo.contract d ON d.contractnum=c.contractnum
	WHERE d.contracttype='PRICE'
) c ON c.contractnum=b.contractrefnum AND c.itemnum=a.itemnum
	AND CAST(b.orderdate AS date)>=CAST(c.startdate AS date)
	AND c.unitcost!=a.unitcost
	AND ABS(c.unitcost-a.unitcost)<0.02 
JOIN maximo.cswn_poline e ON e.PK_PO_ITEMS=a.ste_migrationid
WHERE 1=1
	AND a.linecost=99999999
;

-- UPDATE
MERGE INTO MAXIMO.POLINE A
USING (
	SELECT A.POLINEID, A.PONUM, A.ITEMNUM, A.ORDERQTY, A.UNITCOST, A.LINECOST
		, TRUNCATE(e.PO_UNIT_RATE,2) AS NEW_UNITCOST, TRUNCATE(e.PO_UNIT_RATE*A.ORDERQTY,2) AS NEW_LINECOST
		, c.unitcost AS contract_unitcost
	FROM maximo.poline a
	JOIN maximo.po b ON b.ponum=a.ponum
	LEFT JOIN (
		SELECT c.contractnum, d.startdate, c.itemnum, c.unitcost
		FROM maximo.contractline c
		JOIN maximo.contract d ON d.contractnum=c.contractnum
		WHERE d.contracttype='PRICE'
	) c ON c.contractnum=b.contractrefnum AND c.itemnum=a.itemnum
		AND CAST(b.orderdate AS date)>=CAST(c.startdate AS date)
		AND c.unitcost!=a.unitcost
		AND ABS(c.unitcost-a.unitcost)<0.02 
	JOIN maximo.cswn_poline e ON e.PK_PO_ITEMS=a.ste_migrationid
	WHERE 1=1
		AND a.linecost=99999999
) B ON B.POLINEID=A.POLINEID
WHEN MATCHED THEN
UPDATE SET
	LINECOST=B.NEW_LINECOST,
	UNITCOST=COALESCE(B.contract_unitcost, B.NEW_UNITCOST)
;

CALL MIGRATION.STE_FINISH_PATCH('20250605-02-POLINE');