CALL MIGRATION.STE_START_PATCH('20250527-01-INVENTORY');

CREATE TABLE "MIGRATION"."BAK_20250527_MATRECTRANS"  (
	  "MATRECTRANSID" BIGINT NOT NULL , 
	  "ITEMNUM" VARCHAR(30 OCTETS) , 
	  "TRANSDATE" DATE , 
	  "ACTUALDATE" DATE , 
	  "QUANTITY" DECIMAL(15,2) , 
	  "TOSTORELOC" VARCHAR(16) , 
	  "TOBIN" VARCHAR(16) , 
	  "FROMSTORELOC" VARCHAR(16) , 
	  "FROMBIN" VARCHAR(16)
)   
ORGANIZE BY ROW;

INSERT INTO "MIGRATION"."BAK_20250527_MATRECTRANS"(
	MATRECTRANSID, ITEMNUM, TRANSDATE, ACTUALDATE, QUANTITY, TOSTORELOC, TOBIN, FROMSTORELOC, FROMBIN
)
SELECT 
	MATRECTRANSID, ITEMNUM, TRANSDATE, ACTUALDATE, QUANTITY, TOSTORELOC, TOBIN, FROMSTORELOC, FROMBIN
FROM MAXIMO.MATRECTRANS
WHERE MATRECTRANSID IN (1731906, 1731901, 1731904, 1731877, 1731875);

UPDATE MAXIMO.MATRECTRANS
SET
	TOSTORELOC='L100000019292',
	FROMSTORELOC='L100000019292'
WHERE MATRECTRANSID IN (1731906, 1731901, 1731904, 1731877, 1731875)
;

-- MOVEMENT/ALL INVENTORY PER ITEM PER LOCATION
CREATE OR REPLACE VIEW MIGRATION.DBG_INVENTORY_PER_STORE_ITEM
AS
SELECT a.*
	, CASE WHEN (a.calc_qty!=a.quantity AND curbaladj=0) 
					OR (abs(a.calc_avgcost-a.avgcost)>0.01 AND a.costadj=0 AND a.calc_qty!=0 AND a.quantity!=0) 
				THEN 1 
	  ELSE 0 
	  END AS mismatched
FROM (
	SELECT 
		a.itemnum, a.ste_cswnitemno, a.description
		, a.item_cat, a.item_group, a.item_authority, a.location
		, COALESCE(b.totalqty,0) AS last_qty, CAST(COALESCE(c.MAP,0) AS decimal(13,5)) AS last_avgcost
		, COALESCE(b.totalqty,0)*CAST(COALESCE(c.MAP,0) AS decimal(13,5)) AS last_value
		, COALESCE(d.quantity,0) AS receipt_qty, COALESCE(d.avgcost,0) AS receipt_avgcost
		, COALESCE(d.MINDATE,CAST('2025-03-30' AS DATE)) AS receipt_mindate
		, COALESCE(d.MAXDATE,CAST('2025-03-30' AS DATE)) AS receipt_maxdate
		, COALESCE(e.quantity,0) AS transfer_in_qty, COALESCE(e.avgcost,0) AS transfer_in_avgcost
		, COALESCE(f.quantity,0) AS issue_qty, COALESCE(f.avgcost,0) AS issue_avgcost
		, COALESCE(f.MINDATE,CAST('2025-03-30' AS DATE)) AS issue_mindate
		, COALESCE(f.MAXDATE,CAST('2025-03-30' AS DATE)) AS issue_maxdate
		, COALESCE(g.quantity,0) AS transfer_out_qty, COALESCE(g.avgcost,0) AS transfer_out_avgcost
		, COALESCE(b.totalqty,0) + COALESCE(d.quantity,0) + COALESCE(e.quantity,0) - COALESCE(f.quantity,0) - COALESCE(g.quantity,0) AS calc_qty
		, a.curbal AS quantity
		, CASE WHEN (COALESCE(b.totalqty,0) + COALESCE(d.quantity,0) + COALESCE(e.quantity,0) - COALESCE(f.quantity,0) - COALESCE(g.quantity,0))=0 
					THEN 
						CASE WHEN (COALESCE(b.totalqty,0) + COALESCE(d.quantity,0))=0 THEN 0
							 ELSE ((COALESCE(b.totalqty,0)*CAST(COALESCE(c.MAP,0) AS decimal(13,5))) + (COALESCE(d.quantity,0)*COALESCE(d.avgcost,0)))
									/ (COALESCE(b.totalqty,0) + COALESCE(d.quantity,0))
						END 
		       ELSE ((COALESCE(b.totalqty,0)*CAST(COALESCE(c.MAP,0) AS decimal(13,5))) 
		       		  + (COALESCE(d.quantity,0)*COALESCE(d.avgcost,0)) + (COALESCE(e.quantity,0)*COALESCE(e.avgcost,0))
		       		  - (COALESCE(f.quantity,0)*COALESCE(f.avgcost,0)) - (COALESCE(g.quantity,0)*COALESCE(g.avgcost,0))
		       		) /
		       		(COALESCE(b.totalqty,0) + COALESCE(d.quantity,0) + COALESCE(e.quantity,0) - COALESCE(f.quantity,0) - COALESCE(g.quantity,0))
		  END AS calc_avgcost
		, a.avgcost
		, (COALESCE(b.totalqty,0)*CAST(COALESCE(c.MAP,0) AS decimal(13,5))) + COALESCE(d.invvalue,0) - COALESCE(f.invvalue,0) AS calc_value
		, a.invvalue
		, GREATEST(CAST('2025-03-30' AS DATE), COALESCE(d.MAXDATE,CAST('2025-03-30' AS DATE)), COALESCE(e.MAXDATE,CAST('2025-03-30' AS DATE))
					, COALESCE(f.MAXDATE,CAST('2025-03-30' AS DATE)), COALESCE(g.MAXDATE,CAST('2025-03-30' AS DATE))) AS maxdate
		, CASE WHEN coalesce(h.cnt, 0)>0 THEN 1 ELSE 0 END AS COSTADJ
		, CASE WHEN coalesce(j.cnt, 0)>0 THEN 1 ELSE 0 END AS CURBALADJ
	FROM (
		SELECT a.itemnum, b.ste_cswnitemno, b.description
			, b.ste_cswnitemcat AS item_cat, b.ste_itemgroup AS item_group, b.ste_cswnauthority AS item_authority
			, a.location, a.curbal, a.avgcost, a.invvalue
		FROM (
			SELECT x.ITEMNUM, x.LOCATION, sum(x.CURBAL) AS CURBAL, sum(x.CURBAL*y.AVGCOST) AS INVVALUE
				, MAX(y.AVGCOST) AS AVGCOST
			FROM MAXIMO.INVBALANCES x
			LEFT JOIN MAXIMO.INVCOST y ON y.itemnum=x.itemnum AND y.location=x.location
				AND (COALESCE(Y.CONDITIONCODE,'')=COALESCE(X.CONDITIONCODE,''))
			GROUP BY x.ITEMNUM, x.LOCATION
		) a
		JOIN maximo.item b ON b.itemnum=a.itemnum
		--LEFT JOIN MAXIMO.INVCOST c ON c.itemnum=a.itemnum AND c.location=a.location
	) a
	LEFT JOIN (
		SELECT b.is_stor_cd, b.item_cd, sum(b.loc_free_qty) AS loc_free_qty, sum(b.loc_res_qty) AS loc_res_qty
			, sum(b.loc_free_qty)+sum(b.loc_res_qty) AS totalqty
		FROM maximo.cswn_invbalances b
		GROUP BY b.is_stor_cd, b.item_cd
	) b ON b.is_stor_cd=a.location AND b.item_cd=a.ste_cswnitemno
	LEFT JOIN migration.sbst_inventory_master c ON c.item_code=a.ste_cswnitemno
	LEFT JOIN (
		SELECT a.itemnum, a.tostoreloc, sum(a.quantity) AS quantity
			, CASE WHEN sum(a.quantity)=0 THEN 0 ELSE sum((a.quantity)*a.unitcost)/sum(a.quantity) END AS avgcost
			, sum((a.quantity)*a.unitcost) AS invvalue
			, MAX(A.TRANSDATE) AS MAXDATE
			, MIN(A.TRANSDATE) AS MINDATE
		FROM (
			-- no inspection
			SELECT m.itemnum, m.tostoreloc, (m.quantity-m.rejectqty) AS quantity, m.unitcost, m.statusdate AS transdate
			FROM maximo.MATRECTRANS m
			WHERE m.ISSUETYPE='RECEIPT' AND m.STATUS='COMP' 
				AND m.FROMSTORELOC IS NULL 
				AND m.TOSTORELOC IS NOT NULL AND m.TOSTORELOC!='L100000019292'	
				AND m.transdate>'2025-03-30' --AND m.transdate <'2025-05-01'
			
			UNION
			
			-- inspection
			SELECT m.itemnum, m.tostoreloc, (m.quantity+COALESCE(r1.quantity,0)) AS quantity, m.unitcost, m.transdate
				--, m.quantity, COALESCE(r1.quantity,0) AS returnqty1, COALESCE(r2.quantity,0) AS returnqty2
			FROM maximo.MATRECTRANS m
			LEFT JOIN maximo.matrectrans r1 ON r1.issuetype='RETURN' AND r1.receiptref=m.receiptref AND r1.tostoreloc!='L100000019292' 
			--LEFT JOIN maximo.matrectrans r2 ON r2.issuetype='RETURN' AND r2.receiptref=m.receiptref AND r2.tostoreloc='L100000019292' 
			WHERE m.ISSUETYPE='TRANSFER' AND m.STATUS='COMP' 
				AND m.FROMSTORELOC='L100000019292' -- holding
				AND m.TOSTORELOC IS NOT NULL AND m.TOSTORELOC!='L100000019292'
				AND m.transdate>'2025-03-30' --AND m.transdate <'2025-05-01'
				--AND m.ponum='AA10016094'
		) a
		GROUP BY a.itemnum, a.tostoreloc
	) d ON d.itemnum=a.itemnum AND d.tostoreloc=a.location
	LEFT JOIN (
		SELECT a.itemnum, a.tostoreloc, sum(a.quantity) AS quantity
			, CASE WHEN sum(a.quantity)=0 THEN 0 ELSE sum(a.quantity*a.unitcost)/sum(a.quantity) END AS avgcost
			--, sum(a.quantity*a.unitcost) AS invvalue
			, MAX(A.TRANSDATE) AS MAXDATE
		FROM maximo.matrectrans a 
		WHERE 1=1
			AND a.issuetype='TRANSFER' 
			AND a.transdate>'2025-03-30' --AND a.transdate <'2025-05-01'
			-- transfer between store
			AND a.fromstoreloc!='L100000019292' AND a.fromstoreloc!=a.tostoreloc
		GROUP BY a.itemnum, a.tostoreloc
	) e ON e.itemnum=a.itemnum AND e.tostoreloc=a.location
	LEFT JOIN (
		SELECT a.itemnum, a.storeloc, -1*sum(a.quantity) AS quantity
			, CASE WHEN sum(a.quantity)=0 THEN 0 ELSE sum(a.quantity*a.unitcost)/sum(a.quantity) END AS avgcost
			, -1*sum(a.quantity*a.unitcost) AS invvalue
			, MAX(A.TRANSDATE) AS MAXDATE
			, MIN(A.TRANSDATE) AS MINDATE
		FROM maximo.matusetrans a 
		WHERE 1=1
			AND (a.issuetype='RETURN' OR a.issuetype='ISSUE')
			AND a.transdate>'2025-03-30' --AND a.transdate <'2025-05-01'
		GROUP BY a.itemnum, a.storeloc
	) f ON f.itemnum=a.itemnum AND f.storeloc=a.location
	LEFT JOIN (
		SELECT a.itemnum, a.fromstoreloc, sum(a.quantity) AS quantity
			, CASE WHEN sum(a.quantity)=0 THEN 0 ELSE sum(a.quantity*a.unitcost)/sum(a.quantity) END AS avgcost
			--, sum(a.quantity*a.unitcost) AS invvalue
			, MAX(A.TRANSDATE) AS MAXDATE
		FROM maximo.matrectrans a 
		WHERE 1=1
			AND a.issuetype='TRANSFER' 
			AND a.transdate>'2025-03-30' --AND a.transdate <'2025-05-01'
			-- transfer between store
			AND a.fromstoreloc!='L100000019292' AND a.fromstoreloc!=a.tostoreloc
		GROUP BY a.itemnum, a.fromstoreloc
	) g ON g.itemnum=a.itemnum AND g.fromstoreloc=a.location
	LEFT JOIN (
		SELECT a.itemnum, a.storeloc, count(*) AS cnt
		FROM maximo.invtrans a
		WHERE a.transtype='CAPCSTADJ' AND a.transdate>'2025-03-30' AND a.oldcost!=a.newcost
		GROUP BY a.itemnum, a.storeloc
	) h ON h.itemnum=a.itemnum AND h.storeloc=a.location
	LEFT JOIN (
		SELECT a.itemnum, a.storeloc, count(*) AS cnt
		FROM maximo.invtrans a
		WHERE a.transtype='CURBALADJ' AND a.transdate>'2025-03-30'
		GROUP BY a.itemnum, a.storeloc
	) j ON j.itemnum=a.itemnum AND j.storeloc=a.location
	WHERE 1=1
		AND (COALESCE(b.totalqty,0)>0 OR COALESCE(d.quantity,0)>0 OR COALESCE(e.quantity,0)>0 OR COALESCE(f.quantity,0)>0 OR COALESCE(g.quantity,0)>0
			OR a.curbal>0)
	ORDER BY a.itemnum, a.location
) a
--WHERE (a.calc_qty!=a.quantity OR a.calc_avgcost!=a.avgcost)
-- WHERE A.ITEMNUM='A44-GEN1-0001-0460XX'
;

-- MIGRATION.BAK_20250520_INVENTORY_MISMATCHED definition

CREATE TABLE "MIGRATION"."BAK_20250527_INVENTORY_MISMATCHED"  (
	  "ITEMNUM" VARCHAR(30 OCTETS) , 
	  "STE_CSWNITEMNO" VARCHAR(30 OCTETS) , 
	  "DESCRIPTION" VARCHAR(104 OCTETS) , 
	  "ITEM_CAT" VARCHAR(16 OCTETS) , 
	  "ITEM_GROUP" VARCHAR(16 OCTETS) , 
	  "ITEM_AUTHORITY" VARCHAR(16 OCTETS) , 
	  "LOCATION" VARCHAR(16 OCTETS) , 
	  "LAST_QTY" DECIMAL(15,2) , 
	  "LAST_AVGCOST" DECIMAL(13,5) , 
	  "LAST_VALUE" DECIMAL(13,5) , 
	  "RECEIPT_QTY" DECIMAL(15,2) , 
	  "RECEIPT_AVGCOST" DECIMAL(13,5) , 
	  "RECEIPT_MAXDATE" TIMESTAMP , 
	  "TRANSFER_IN_QTY" DECIMAL(15,2) , 
	  "TRANSFER_IN_AVGCOST" DECIMAL(13,5) , 
	  "ISSUE_QTY" DECIMAL(15,2) , 
	  "ISSUE_AVGCOST" DECIMAL(13,5) , 
	  "ISSUE_MINDATE" TIMESTAMP , 
	  "TRANSFER_OUT_QTY" DECIMAL(15,2) , 
	  "TRANSFER_OUT_AVGCOST" DECIMAL(13,5) , 
	  "CALC_QTY" DECIMAL(15,2) , 
	  "QUANTITY" DECIMAL(15,2) , 
	  "CALC_AVGCOST" DECIMAL(13,5) , 
	  "AVGCOST" DECIMAL(13,5) , 
	  "CALC_VALUE" DECIMAL(13,5) , 
	  "INVVALUE" DECIMAL(13,5) , 
	  "MAXDATE" TIMESTAMP , 
	  "COSTADJ" INTEGER , 
	  "CURBALADJ" INTEGER , 
	  "MISMATCHED" INTEGER )   
	 ORGANIZE BY ROW;

INSERT INTO "MIGRATION"."BAK_20250527_INVENTORY_MISMATCHED" (
	ITEMNUM, STE_CSWNITEMNO, DESCRIPTION, ITEM_CAT, ITEM_GROUP, ITEM_AUTHORITY, LOCATION, 
	LAST_QTY, LAST_AVGCOST, LAST_VALUE, RECEIPT_QTY, RECEIPT_AVGCOST, RECEIPT_MAXDATE, 
	TRANSFER_IN_QTY, TRANSFER_IN_AVGCOST, ISSUE_QTY, ISSUE_AVGCOST, ISSUE_MINDATE, TRANSFER_OUT_QTY, TRANSFER_OUT_AVGCOST, 
	CALC_QTY, QUANTITY, CALC_AVGCOST, AVGCOST, CALC_VALUE, INVVALUE, MAXDATE, COSTADJ, CURBALADJ, MISMATCHED
)
SELECT 
	ITEMNUM, STE_CSWNITEMNO, DESCRIPTION, ITEM_CAT, ITEM_GROUP, ITEM_AUTHORITY, LOCATION, 
	LAST_QTY, LAST_AVGCOST, LAST_VALUE, RECEIPT_QTY, RECEIPT_AVGCOST, RECEIPT_MAXDATE, 
	TRANSFER_IN_QTY, TRANSFER_IN_AVGCOST, ISSUE_QTY, ISSUE_AVGCOST, ISSUE_MINDATE, TRANSFER_OUT_QTY, TRANSFER_OUT_AVGCOST, 
	CALC_QTY, QUANTITY, CALC_AVGCOST, AVGCOST, CALC_VALUE, INVVALUE, MAXDATE, COSTADJ, CURBALADJ, MISMATCHED
FROM MIGRATION.DBG_INVENTORY_PER_STORE_ITEM
WHERE 
	(calc_qty!=quantity) OR (calc_avgcost!=avgcost)
;

CREATE TABLE "MIGRATION"."BAK_20250527_INVBALANCES"  (
	  "INVBALANCESID" BIGINT NOT NULL , 
	  "ITEMNUM" VARCHAR(30 OCTETS) , 
	  "LOCATION" VARCHAR(16 OCTETS) , 
	  "CURBAL" DECIMAL(15,2) NOT NULL , 
	  "NEW_CURBAL" DECIMAL(15,2) NOT NULL 
)   
ORGANIZE BY ROW;

-- to update invbalance.curbal
INSERT INTO "MIGRATION"."BAK_20250527_INVBALANCES"(
	INVBALANCESID, ITEMNUM, LOCATION, CURBAL, NEW_CURBAL
)
SELECT B.INVBALANCESID, B.ITEMNUM, B.LOCATION, B.CURBAL
	, A.CALC_QTY AS NEW_CURBAL
FROM (
	SELECT * FROM MIGRATION.DBG_INVENTORY_PER_STORE_ITEM 
	WHERE MISMATCHED=1
		AND calc_qty!=quantity
) A
JOIN MAXIMO.INVBALANCES B ON B.ITEMNUM=A.ITEMNUM AND B.LOCATION=A.LOCATION 
;

MERGE INTO MAXIMO.INVBALANCES A
USING (
	SELECT A.ITEMNUM, A.LOCATION, A.CALC_QTY, A.QUANTITY
	FROM MIGRATION.DBG_INVENTORY_PER_STORE_ITEM A
	WHERE (a.calc_qty!=a.quantity) AND A.MISMATCHED=1
) B ON B.ITEMNUM=A.ITEMNUM AND B.LOCATION=A.LOCATION
WHEN MATCHED THEN
UPDATE SET
	CURBAL=B.CALC_QTY
;

CREATE TABLE "MIGRATION"."BAK_20250527_INVCOST"  (
	  "INVCOSTID" BIGINT NOT NULL , 
	  "ITEMNUM" VARCHAR(30 OCTETS) , 
	  "LOCATION" VARCHAR(16 OCTETS) , 
	  "AVGCOST" DECIMAL(13,5) NOT NULL , 
	  "NEW_AVGCOST" DECIMAL(13,5) NOT NULL 
)   
ORGANIZE BY ROW;

-- TO UPDATE AVGCOST
INSERT INTO "MIGRATION"."BAK_20250527_INVCOST"(
	INVCOSTID, ITEMNUM, LOCATION, AVGCOST, NEW_AVGCOST
)
SELECT B.INVCOSTID, B.ITEMNUM, B.LOCATION, B.AVGCOST
	, A.CALC_AVGCOST AS NEW_AVGCOST
FROM (
	SELECT * FROM MIGRATION.DBG_INVENTORY_PER_STORE_ITEM 
	WHERE MISMATCHED=1 
		AND ABS(CALC_AVGCOST-AVGCOST)>0.01
) A
JOIN MAXIMO.INVCOST B ON B.ITEMNUM=A.ITEMNUM AND B.LOCATION=A.LOCATION 
;

MERGE INTO MAXIMO.INVCOST A
USING (
	SELECT ITEMNUM, LOCATION, CALC_AVGCOST, AVGCOST 
	FROM MIGRATION.DBG_INVENTORY_PER_STORE_ITEM 
	WHERE MISMATCHED=1 
		AND ABS(CALC_AVGCOST-AVGCOST)>0.01
) B ON B.ITEMNUM=A.ITEMNUM AND B.LOCATION=A.LOCATION
WHEN MATCHED THEN
UPDATE SET
	AVGCOST=CALC_AVGCOST
;

-- RESET BACK COSTADJ
INSERT INTO "MIGRATION"."BAK_20250527_INVCOST"(
	INVCOSTID, ITEMNUM, LOCATION, AVGCOST, NEW_AVGCOST
)
SELECT A.INVCOSTID, A.ITEMNUM, A.LOCATION, A.AVGCOST
	, 1257.2 AS NEW_AVGCOST
FROM MAXIMO.INVCOST A
WHERE A.ITEMNUM='A44-GEN1-0001-0460XX' AND A.LOCATION='CW'
;

UPDATE MAXIMO.INVCOST
SET
	AVGCOST=1257.2
WHERE ITEMNUM='A44-GEN1-0001-0460XX' AND LOCATION='CW'
;

-- UPDATE ISSUE UNITCOST
CREATE TABLE "MIGRATION"."BAK_20250527_MATUSETRANS"  (
	  "MATUSETRANSID" BIGINT NOT NULL , 
	  "ITEMNUM" VARCHAR(30 OCTETS) , 
	  "STORELOC" VARCHAR(16 OCTETS) , 
	  "TRANSDATE" TIMESTAMP NOT NULL , 
	  "UNITCOST" DECIMAL(13,5) NOT NULL , 
	  "ACTUALCOST" DECIMAL(13,5) NOT NULL , 
	  "LINECOST" DECIMAL(13,5) NOT NULL , 
	  "CURRENCYCODE" VARCHAR(8 OCTETS) NOT NULL , 
	  "CURRENCYUNITCOST" DECIMAL(10,2) , 
	  "CURRENCYLINECOST" DECIMAL(10,2) , 
	  "NEW_UNITCOST" DECIMAL(13,5) NOT NULL , 
	  "NEW_LINECOST" DECIMAL(13,5) NOT NULL 
)   
ORGANIZE BY ROW;

-- to update matusetrans's unitcost
INSERT INTO "MIGRATION"."BAK_20250527_MATUSETRANS"(
	MATUSETRANSID, ITEMNUM, STORELOC, TRANSDATE, UNITCOST, ACTUALCOST, LINECOST, CURRENCYCODE, CURRENCYUNITCOST, CURRENCYLINECOST,
	NEW_UNITCOST, NEW_LINECOST
)
SELECT 
	MATUSETRANSID, ITEMNUM, STORELOC, TRANSDATE, UNITCOST, ACTUALCOST, LINECOST, CURRENCYCODE, CURRENCYUNITCOST, CURRENCYLINECOST,
	1257.2 AS NEW_UNITCOST, -1*1257.2*QUANTITY AS NEW_LINECOST
FROM maximo.matusetrans
WHERE issuetype='ISSUE' AND itemnum='A44-GEN1-0001-0460XX' AND storeloc='CW'
	AND CAST(transdate AS date)='2025-05-20';

UPDATE maximo.matusetrans
SET
	UNITCOST=1257.2,
	ACTUALCOST=1257.2,
	LINECOST=-1*1257.2*QUANTITY,
	CURRENCYUNITCOST=1257.2,
	CURRENCYLINECOST=-1*1257.2*QUANTITY,
	EXCHANGERATE=1
WHERE issuetype='ISSUE' AND itemnum='A44-GEN1-0001-0460XX' AND storeloc='CW'
	AND CAST(transdate AS date)='2025-05-20'
;

-- UPDATE ITEMCAT
CREATE TABLE "MIGRATION"."BAK_20250527_ITEM"  (
	  "ITEMID" BIGINT NOT NULL , 
	  "ITEMNUM" VARCHAR(30 OCTETS) , 
	  "ITEMCAT" VARCHAR(10 OCTETS) , 
	  "NEW_ITEMCAT" VARCHAR(10 OCTETS)
)   
ORGANIZE BY ROW;

INSERT INTO "MIGRATION"."BAK_20250527_ITEM" (
	ITEMID, ITEMNUM, ITEMCAT, NEW_ITEMCAT
)
SELECT ITEMID, ITEMNUM, STE_CSWNITEMCAT AS ITEMCAT, 'SG_OEM_PWR' AS NEW_ITEMCAT
FROM MAXIMO.ITEM
WHERE ITEMNUM IN (
	'A31-LVG1-0001-0039XX',
	'A31-LVG1-0001-0040XX',
	'A31-LVG1-0001-0041XX',
	'A31-LVG1-0001-0042XX',
	'A31-LVG1-0001-0043XX',
	'A31-LVG1-0001-0044XX',
	'A31-LVG1-0001-0045XX',
	'A31-LVG1-0001-0046XX',
	'A31-LVG1-0001-0047XX',
	'A31-LVG1-0001-0048XX',
	'A31-LVG1-0001-0049XX',
	'A31-LVG1-0001-0050XX',
	'A31-LVG1-0001-0051XX',
	'A31-LVG1-0001-0052XX',
	'A31-LVG1-0001-0053XX',
	'A31-LVG1-0001-0054XX'
)
;

UPDATE MAXIMO.ITEM
SET
	STE_CSWNITEMCAT='SG_OEM_PWR'
WHERE ITEMNUM IN (
	'A31-LVG1-0001-0039XX',
	'A31-LVG1-0001-0040XX',
	'A31-LVG1-0001-0041XX',
	'A31-LVG1-0001-0042XX',
	'A31-LVG1-0001-0043XX',
	'A31-LVG1-0001-0044XX',
	'A31-LVG1-0001-0045XX',
	'A31-LVG1-0001-0046XX',
	'A31-LVG1-0001-0047XX',
	'A31-LVG1-0001-0048XX',
	'A31-LVG1-0001-0049XX',
	'A31-LVG1-0001-0050XX',
	'A31-LVG1-0001-0051XX',
	'A31-LVG1-0001-0052XX',
	'A31-LVG1-0001-0053XX',
	'A31-LVG1-0001-0054XX'
);

--SELECT ITEMNUM, LOCATION, CALC_QTY, QUANTITY, CALC_AVGCOST, AVGCOST, CALC_VALUE, INVVALUE
--FROM MIGRATION.DBG_INVENTORY_PER_STORE_ITEM 
--	WHERE MISMATCHED=1;

CALL MIGRATION.STE_FINISH_PATCH('20250527-01-INVENTORY');