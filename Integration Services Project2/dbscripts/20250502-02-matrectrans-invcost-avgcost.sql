CALL MIGRATION.STE_START_PATCH('20250502-02-MATRECTRANS-INVCOST-AVGCOST');

--SELECT a.itemnum, b.ste_cswnitemno, b.ste_cswnitemcat, b.ste_ownerdepartment
--	, a.tostoreloc, a.tobin, a.transdate, a.quantity, a.unitcost, COALESCE(g.currencycode,'SGD') AS currencycode, a.exchangerate, a.currencyunitcost
--	, a.status, a.fromstoreloc, a.frombin
--	, e.curbal AS maximo_curbal, d.avgcost AS maximo_avgcost, c.totalqty AS coswin_lastbal, c.MAP AS coswin_map
--	--, a.ponum, g.currencycode, f.unitcost AS po_unitcost
--FROM maximo.matrectrans a
--JOIN maximo.item b ON b.itemnum=a.itemnum
--JOIN migration.sbst_inventory_master c ON c.item_code=b.ste_cswnitemno
--LEFT JOIN maximo.invcost d ON d.itemnum=a.itemnum AND d.location=a.tostoreloc
--LEFT JOIN maximo.invbalances e ON e.itemnum=a.itemnum AND e.location=a.tostoreloc AND coalesce(e.binnum, '')=coalesce(a.tobin, '')
--LEFT JOIN maximo.poline f ON f.ponum=a.ponum AND f.itemnum=a.itemnum
--LEFT JOIN maximo.po g ON g.ponum=a.ponum
--WHERE a.issuetype='TRANSFER' AND a.transdate>'2025-03-30'
--ORDER BY a.itemnum, a.tostoreloc, a.tobin, a.transdate
--;

-- backup invcost 
--DROP TABLE "MIGRATION"."BAK_20250502_INVCOST";
CREATE TABLE "MIGRATION"."BAK_20250502_INVCOST" 
   (	
   	"INVCOSTID" BIGINT, 
	"ITEMNUM" VARCHAR(30), 
	"LOCATION" VARCHAR(16), 
	"AVGCOST" DECIMAL(13,5), 
	"UNITCOST" DECIMAL(13,5), 
	"EXCHANGERATE" DECIMAL(14,7), 
	"CURRENCYUNITCOST" DECIMAL(10,2)
)
;

INSERT INTO "MIGRATION"."BAK_20250502_INVCOST" (
	INVCOSTID, ITEMNUM, LOCATION, AVGCOST, UNITCOST, EXCHANGERATE, CURRENCYUNITCOST
)
SELECT 
	A.INVCOSTID, A.ITEMNUM, A.LOCATION, A.AVGCOST, A.UNITCOST, A.EXCHANGERATE, A.CURRENCYUNITCOST
	--, A.EXCHANGERATE * A.CURRENCYUNITCOST AS NEW_UNITCOST
FROM (
	SELECT d.invcostid, d.itemnum, d.location, d.avgcost
		, a.unitcost, a.exchangerate, a.currencyunitcost
		, row_number() OVER (PARTITION BY d.invcostid ORDER BY a.matrectransid) rn
	FROM MAXIMO.INVCOST d
	JOIN maximo.matrectrans a ON d.itemnum=a.itemnum AND d.location=a.tostoreloc
		AND a.issuetype='TRANSFER' AND a.transdate>'2025-03-30'
	JOIN maximo.item b ON b.itemnum=a.itemnum
	JOIN migration.sbst_inventory_master c ON c.item_code=b.ste_cswnitemno
) A
WHERE A.RN=1
;

--MERGE INTO MAXIMO.INVCOST A
--USING (
--	SELECT a.invcostid, b.avgcost 
--	FROM maximo.invcost a
--	JOIN "MIGRATION"."BAK_20250502_INVCOST" b ON b.invcostid=a.invcostid
--) B ON B.INVCOSTID=A.INVCOSTID
--WHEN MATCHED THEN
--UPDATE SET
--	AVGCOST=B.avgcost
--;

--DELETE FROM "MIGRATION"."BAK_20250502_INVCOST";

-- update empty unitcost
MERGE INTO maximo.matrectrans A
USING (
	SELECT a.matrectransid, a.unitcost, a.exchangerate, a.currencyunitcost
	FROM maximo.matrectrans a
	WHERE COALESCE(a.currencyunitcost,0)>0 AND COALESCE(a.exchangerate,0)>0
		AND a.unitcost=0
) B ON B.MATRECTRANSID=A.MATRECTRANSID
WHEN MATCHED THEN
UPDATE SET
	UNITCOST = B.EXCHANGERATE * B.CURRENCYUNITCOST
;

-- UPDATE EMPTY UNITCOST WHEN TRANSFERING BETWEEN STORE
MERGE INTO maximo.matrectrans A
USING (
	SELECT a.matrectransid, a.unitcost, a.exchangerate, a.currencyunitcost, A.TRANSDATE, B.UNITCOST AS NEW_UNITCOST
		, ROW_NUMBER() OVER (PARTITION BY a.matrectransid ORDER BY B.matrectransid) RN
	FROM maximo.matrectrans a
	LEFT JOIN MAXIMO.MATRECTRANS B ON B.ITEMNUM=A.ITEMNUM AND B.TRANSDATE>'2025-03-30' AND B.UNITCOST>0
	WHERE COALESCE(a.currencyunitcost,0)=0 AND A.EXCHANGERATE=1
		AND a.unitcost=0
		-- AND A.PONUM IS NULL
		AND A.ISSUETYPE='TRANSFER'
		AND A.TRANSDATE>'2025-03-30'
) B ON B.RN=1 AND B.MATRECTRANSID=A.MATRECTRANSID
WHEN MATCHED THEN
UPDATE SET
	UNITCOST = B.NEW_UNITCOST,
	CURRENCYUNITCOST = B.NEW_UNITCOST
;

-- UPDATE INVCOST.AVGCOST WHEN COSWIN LASTBAL=0 AND COSWIN MAP=0
MERGE INTO MAXIMO.INVCOST A
USING (
	SELECT d.invcostid, d.itemnum, d.location, d.avgcost
		, a.unitcost, a.exchangerate, a.currencyunitcost
		, row_number() OVER (PARTITION BY d.invcostid ORDER BY a.matrectransid) rn
	FROM MAXIMO.INVCOST d
	JOIN maximo.matrectrans a ON d.itemnum=a.itemnum AND d.location=a.tostoreloc
		AND a.issuetype='TRANSFER' AND a.transdate>'2025-03-30'
	JOIN maximo.item b ON b.itemnum=a.itemnum
	JOIN migration.sbst_inventory_master c ON c.item_code=b.ste_cswnitemno
	WHERE 
		c.totalqty=0 AND c.MAP=0 AND d.avgcost=0
) B ON B.RN=1 AND B.INVCOSTID=A.INVCOSTID
WHEN MATCHED THEN
UPDATE SET
	AVGCOST=B.UNITCOST
;

-- RECALCULATE AVGCOST 
MERGE INTO MAXIMO.INVCOST A
USING (
	SELECT 
		a.invcostid, a.itemnum, a.ste_cswnitemno, a.location
		, e.curbal, a.avgcost, coalesce(b.totalqty,0) AS coswin_lastbal, a.MAP AS coswin_map
		, a.quantity, a.unitcost
		, ((coalesce(b.totalqty,0) * a.MAP) + (a.quantity*a.unitcost)) / (coalesce(b.totalqty,0)+a.quantity) AS new_avgcost
	FROM (
		SELECT d.invcostid, d.itemnum, b.ste_cswnitemno, d.location, d.avgcost, c.totalqty, c.map
			, SUM(a.quantity) AS quantity, sum(a.quantity*a.unitcost)/sum(a.quantity) AS unitcost
		FROM MAXIMO.INVCOST d
		JOIN maximo.matrectrans a ON d.itemnum=a.itemnum AND d.location=a.tostoreloc
			AND a.issuetype='TRANSFER' AND a.transdate>'2025-03-30'
			AND A.STATUS='COMP'
		JOIN maximo.item b ON b.itemnum=a.itemnum
		JOIN migration.sbst_inventory_master c ON c.item_code=b.ste_cswnitemno
		WHERE 
			c.totalqty>0 AND c.MAP>0 
		GROUP BY d.invcostid, d.itemnum, b.ste_cswnitemno, d.location, d.avgcost, c.totalqty, c.map
	) a
	LEFT JOIN (
		SELECT b.is_stor_cd, b.item_cd, sum(b.loc_free_qty) AS loc_free_qty, sum(b.loc_res_qty) AS loc_res_qty
			, sum(b.loc_free_qty)+sum(b.loc_res_qty) AS totalqty
		FROM maximo.cswn_invbalances b
		GROUP BY b.is_stor_cd, b.item_cd
	) b ON b.is_stor_cd=a.location AND b.item_cd=a.ste_cswnitemno
	LEFT JOIN (
		SELECT e.itemnum, e.location, sum(e.curbal) AS curbal FROM maximo.invbalances e
		GROUP BY e.itemnum, e.location
	) e ON e.itemnum=a.itemnum AND e.location=a.location
	--ORDER BY a.itemnum
) B ON B.INVCOSTID=A.INVCOSTID
WHEN MATCHED THEN
UPDATE SET
	AVGCOST=B.NEW_AVGCOST
;

--	SELECT 
--		a.invcostid, a.itemnum, a.ste_cswnitemno, a.location
--		, coalesce(b.totalqty,0) AS coswin_lastbal, a.MAP AS coswin_map
--		, a.quantity, a.unitcost
--		, ((coalesce(b.totalqty,0) * a.MAP) + (a.quantity*a.unitcost)) / (coalesce(b.totalqty,0)+a.quantity) AS calc_avgcost
--		, a.avgcost, f.avgcost AS old_avgcost
--	FROM (
--		SELECT d.invcostid, d.itemnum, b.ste_cswnitemno, d.location, d.avgcost, c.totalqty, c.map
--			, SUM(a.quantity) AS quantity, sum(a.quantity*a.unitcost)/sum(a.quantity) AS unitcost
--		FROM MAXIMO.INVCOST d
--		JOIN maximo.matrectrans a ON d.itemnum=a.itemnum AND d.location=a.tostoreloc
--			AND a.issuetype='TRANSFER' AND a.transdate>'2025-03-30'
--			AND A.STATUS='COMP'
--		JOIN maximo.item b ON b.itemnum=a.itemnum
--		JOIN migration.sbst_inventory_master c ON c.item_code=b.ste_cswnitemno
--		GROUP BY d.invcostid, d.itemnum, b.ste_cswnitemno, d.location, d.avgcost, c.totalqty, c.map
--	) a
--	LEFT JOIN (
--		SELECT b.is_stor_cd, b.item_cd, sum(b.loc_free_qty) AS loc_free_qty, sum(b.loc_res_qty) AS loc_res_qty
--			, sum(b.loc_free_qty)+sum(b.loc_res_qty) AS totalqty
--		FROM maximo.cswn_invbalances b
--		GROUP BY b.is_stor_cd, b.item_cd
--	) b ON b.is_stor_cd=a.location AND b.item_cd=a.ste_cswnitemno
--	LEFT JOIN (
--		SELECT e.itemnum, e.location, sum(e.curbal) AS curbal FROM maximo.invbalances e
--		GROUP BY e.itemnum, e.location
--	) e ON e.itemnum=a.itemnum AND e.location=a.location
--	LEFT JOIN "MIGRATION"."BAK_20250502_INVCOST" f ON f.invcostid=a.invcostid
--	ORDER BY a.itemnum
--	;

-- BACKUP MATUSETRANS
CREATE TABLE "MIGRATION"."BAK_20250502_MATUSETRANS" 
   (	
   	"MATUSETRANSID" BIGINT, 
	"ITEMNUM" VARCHAR(30), 
	"STORELOC" VARCHAR(16), 
	"QUANTITY" DECIMAL(15,2), 
	"UNITCOST" DECIMAL(13,5), 
	"LINECOST" DECIMAL(13,5)
)
;

INSERT INTO "MIGRATION"."BAK_20250502_MATUSETRANS" (
	MATUSETRANSID, ITEMNUM, STORELOC, QUANTITY, UNITCOST, LINECOST
)
SELECT A.MATUSETRANSID, A.ITEMNUM, A.STORELOC, A.QUANTITY, A.UNITCOST, A.LINECOST
FROM maximo.matusetrans A
JOIN MAXIMO.INVCOST B ON B.ITEMNUM=A.ITEMNUM AND B.LOCATION=A.STORELOC
WHERE A.TRANSDATE>'2025-03-30'
	AND (A.UNITCOST=0 OR A.UNITCOST!=B.AVGCOST)
;

-- UPDATE MATUSETRANS
MERGE INTO MAXIMO.MATUSETRANS A
USING (
	SELECT A.MATUSETRANSID, A.ITEMNUM, A.STORELOC, A.QUANTITY, A.UNITCOST, A.LINECOST, B.AVGCOST
		, A.QUANTITY * -1 * B.AVGCOST AS CALC_LINECOST
		, A.ACTUALCOST, A.CURRENCYUNITCOST, A.CURRENCYLINECOST, A.EXCHANGERATE
	FROM maximo.matusetrans A
	JOIN MAXIMO.INVCOST B ON B.ITEMNUM=A.ITEMNUM AND B.LOCATION=A.STORELOC
	WHERE A.TRANSDATE>'2025-03-30'
		AND (A.UNITCOST=0 OR A.UNITCOST!=B.AVGCOST)
) B ON B.MATUSETRANSID=A.MATUSETRANSID
WHEN MATCHED THEN
UPDATE SET
	UNITCOST=B.AVGCOST,
	ACTUALCOST=B.AVGCOST,
	LINECOST=B.CALC_LINECOST,
	CURRENCYUNITCOST=B.AVGCOST,
	CURRENCYLINECOST=B.CALC_LINECOST,
	EXCHANGERATE=1
;

-- TRAINE/ELC/ER/01, TRAINE/ELC/ER/01
-- A44-AUX1-ASU1-0271XX, TRAIN /ELE/GV/05
--
--SELECT * FROM MAXIMO.ITEM WHERE ITEMNUM='A44-AUX1-ASU1-0271XX';
--SELECT * FROM MIGRATION.SBST_INVENTORY_MASTER WHERE ITEM_CODE IN ('TRAINE/ELC/ER/01', 'TRAIN /ELE/GV/05');

CALL MIGRATION.STE_FINISH_PATCH('20250502-02-MATRECTRANS-INVCOST-AVGCOST');