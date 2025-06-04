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
			--WHERE X.ITEMNUM='A44-DRS1-DDR1-0016XX'
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
			LEFT JOIN maximo.matrectrans r1 ON r1.issuetype='RETURN' AND r1.receiptref=m.receiptref AND r1.tostoreloc=m.tostoreloc 
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
WHERE (a.calc_qty!=a.quantity OR a.calc_avgcost!=a.avgcost)
-- WHERE A.ITEMNUM='A44-GEN1-0001-0460XX'
;

-- ALL INVENTORY PER ITEM
CREATE OR REPLACE VIEW MIGRATION.DBG_INVENTORY_PER_ITEM
AS
SELECT a.*, 
	CASE WHEN (a.calc_qty!=a.quantity AND a.curbaladj=0) OR (a.calc_value!=a.invvalue AND a.costadj=0) THEN 1 ELSE 0 END AS mismatched
FROM (
	SELECT 
		a.itemnum, a.ste_cswnitemno, a.description
		, a.item_cat, a.item_group, a.item_authority
		, COALESCE(b.totalqty,0) AS last_qty, COALESCE(b.totalqty,0)*CAST(COALESCE(c.MAP,0) AS decimal(13,5)) AS last_value
		, COALESCE(d.quantity,0) AS receipt_qty, COALESCE(d.invvalue,0) AS receipt_value
		, COALESCE(f.quantity,0) AS issue_qty, COALESCE(f.invvalue,0) AS issue_value
		, COALESCE(b.totalqty,0) + COALESCE(d.quantity,0) - COALESCE(f.quantity,0) AS calc_qty
		, a.curbal AS quantity
		, (COALESCE(b.totalqty,0)*CAST(COALESCE(c.MAP,0) AS decimal(13,5))) + COALESCE(d.invvalue,0) - COALESCE(f.invvalue,0) AS calc_value
		, a.invvalue
		, CASE WHEN coalesce(h.cnt, 0)>0 THEN 1 ELSE 0 END AS COSTADJ
		, CASE WHEN coalesce(j.cnt, 0)>0 THEN 1 ELSE 0 END AS CURBALADJ
	FROM (
		SELECT a.itemnum, b.ste_cswnitemno, b.description
			, b.ste_cswnitemcat AS item_cat, b.ste_itemgroup AS item_group, b.ste_cswnauthority AS item_authority
			, a.curbal, a.invvalue
		FROM (
			SELECT x.ITEMNUM, sum(x.CURBAL) AS CURBAL, sum(x.CURBAL*y.AVGCOST) AS INVVALUE
			FROM MAXIMO.INVBALANCES x
			LEFT JOIN MAXIMO.INVCOST y ON y.itemnum=x.itemnum AND y.location=x.location
			GROUP BY x.ITEMNUM
		) a
		JOIN maximo.item b ON b.itemnum=a.itemnum
	) a
	LEFT JOIN (
		SELECT b.item_cd, sum(b.loc_free_qty) AS loc_free_qty, sum(b.loc_res_qty) AS loc_res_qty
			, sum(b.loc_free_qty)+sum(b.loc_res_qty) AS totalqty
		FROM maximo.cswn_invbalances b
		GROUP BY b.item_cd
	) b ON b.item_cd=a.ste_cswnitemno
	LEFT JOIN migration.sbst_inventory_master c ON c.item_code=a.ste_cswnitemno
	LEFT JOIN (
		SELECT a.itemnum, sum(a.quantity) AS quantity, sum(a.quantity*a.unitcost) AS invvalue
		FROM maximo.matrectrans a 
		WHERE 1=1
			AND a.issuetype='TRANSFER' 
			AND a.transdate>'2025-03-30' --AND a.transdate <'2025-05-01'
			-- holding
			AND a.fromstoreloc='L100000019292'
			AND A.STATUS='COMP'
		GROUP BY a.itemnum
	) d ON d.itemnum=a.itemnum
	LEFT JOIN (
		SELECT a.itemnum, -1*sum(a.quantity) AS quantity, -1*sum(a.quantity*a.unitcost) AS invvalue
		FROM maximo.matusetrans a 
		WHERE 1=1
			AND (a.issuetype='RETURN' OR a.issuetype='ISSUE')
			AND a.transdate>'2025-03-30' --AND a.transdate <'2025-05-01'
		GROUP BY a.itemnum
	) f ON f.itemnum=a.itemnum
	LEFT JOIN (
		SELECT a.itemnum, count(*) AS cnt
		FROM maximo.invtrans a
		WHERE a.transtype='CAPCSTADJ' AND a.transdate>'2025-03-30' AND a.oldcost!=a.newcost
		GROUP BY a.itemnum
	) h ON h.itemnum=a.itemnum
	LEFT JOIN (
		SELECT a.itemnum, count(*) AS cnt
		FROM maximo.invtrans a
		WHERE a.transtype='CURBALADJ' AND a.transdate>'2025-03-30'
		GROUP BY a.itemnum
	) j ON j.itemnum=a.itemnum
	WHERE 1=1
		AND (COALESCE(b.totalqty,0)>0 OR COALESCE(d.quantity,0)>0 OR COALESCE(f.quantity,0)>0 OR a.curbal>0)
		--AND (COALESCE(d.quantity,0)>0 OR COALESCE(f.quantity,0)>0)
	ORDER BY a.itemnum
) a
--WHERE (a.calc_qty!=a.quantity OR a.calc_value!=a.invvalue)
;

--SELECT * FROM MIGRATION.STE_MIGRATION_LOGS ORDER BY id desc

-- calculate unitcost of specific issueid
SELECT a.matusetransid, A.TRANSDATE
	, B.* 
	, COALESCE(d.quantity,0) AS receipt_qty, COALESCE(d.avgcost,0) AS receipt_avgcost, COALESCE(d.MAXDATE,CAST('2025-03-30' AS DATE)) AS receipt_maxdate
	, COALESCE(e.quantity,0) AS transfer_in_qty, COALESCE(e.avgcost,0) AS transfer_in_avgcost
	, COALESCE(f.quantity,0) AS issue_qty, COALESCE(f.avgcost,0) AS issue_avgcost, COALESCE(f.MINDATE,CAST('2025-03-30' AS DATE)) AS issue_mindate
	, COALESCE(g.quantity,0) AS transfer_out_qty, COALESCE(g.avgcost,0) AS transfer_out_avgcost
	, COALESCE(b.last_qty,0) + COALESCE(d.quantity,0) + COALESCE(e.quantity,0) - COALESCE(f.quantity,0) - COALESCE(g.quantity,0) AS calc_qty
	, a.curbal AS quantity
	, CASE WHEN (COALESCE(b.last_qty,0) + COALESCE(d.quantity,0) + COALESCE(e.quantity,0) - COALESCE(f.quantity,0) - COALESCE(g.quantity,0))=0 
				THEN 
					CASE WHEN (COALESCE(b.last_qty,0) + COALESCE(d.quantity,0))=0 THEN 0
						 ELSE ((COALESCE(b.last_qty,0)*COALESCE(b.last_avgcost,0)) + (COALESCE(d.quantity,0)*COALESCE(d.avgcost,0)))
								/ (COALESCE(b.last_qty,0) + COALESCE(d.quantity,0))
					END 
	       ELSE ((COALESCE(b.last_qty,0)*COALESCE(b.last_avgcost,0)) 
	       		  + (COALESCE(d.quantity,0)*COALESCE(d.avgcost,0)) + (COALESCE(e.quantity,0)*COALESCE(e.avgcost,0))
	       		  - (COALESCE(f.quantity,0)*COALESCE(f.avgcost,0)) - (COALESCE(g.quantity,0)*COALESCE(g.avgcost,0))
	       		) /
	       		(COALESCE(b.last_qty,0) + COALESCE(d.quantity,0) + COALESCE(e.quantity,0) - COALESCE(f.quantity,0) - COALESCE(g.quantity,0))
	  END AS calc_avgcost
	, a.unitcost AS unitcost
	, b.avgcost
	, COALESCE(b.last_value,0) + COALESCE(d.invvalue,0) - COALESCE(f.invvalue,0) AS calc_value
	, b.invvalue
FROM MAXIMO.MATUSETRANS A
JOIN (
	SELECT 
		a.itemnum, a.ste_cswnitemno, a.description
		, a.item_cat, a.item_group, a.item_authority, a.location
		, COALESCE(b.totalqty,0) AS last_qty, CAST(COALESCE(c.MAP,0) AS decimal(13,5)) AS last_avgcost
		, COALESCE(b.totalqty,0)*CAST(COALESCE(c.MAP,0) AS decimal(13,5)) AS last_value
		, a.curbal, a.avgcost, a.invvalue
	FROM (
		SELECT a.itemnum, b.ste_cswnitemno, b.description
			, b.ste_cswnitemcat AS item_cat, b.ste_itemgroup AS item_group, b.ste_cswnauthority AS item_authority
			, a.location, a.curbal, a.avgcost, a.invvalue
		FROM (
			SELECT x.ITEMNUM, x.LOCATION, sum(x.CURBAL) AS CURBAL, sum(x.CURBAL*y.AVGCOST) AS INVVALUE
				, MAX(y.AVGCOST) AS AVGCOST
			FROM MAXIMO.INVBALANCES x
			LEFT JOIN MAXIMO.INVCOST y ON y.itemnum=x.itemnum AND y.location=x.location
			WHERE x.itemnum=(SELECT itemnum FROM MAXIMO.MATUSETRANS WHERE MATUSETRANSID=140494)
				AND x.location=(SELECT storeloc FROM MAXIMO.MATUSETRANS WHERE MATUSETRANSID=140494)
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
) B ON B.ITEMNUM=A.ITEMNUM AND B.LOCATION=A.STORELOC
LEFT JOIN (
	SELECT a.itemnum, a.tostoreloc, sum(a.quantity+COALESCE(b.quantity,0)) AS quantity
		, CASE WHEN sum(a.quantity+COALESCE(b.quantity,0))=0 THEN 0 ELSE sum((a.quantity+COALESCE(b.quantity,0))*a.unitcost)/sum(a.quantity+COALESCE(b.quantity,0)) END AS avgcost
		, sum((a.quantity+COALESCE(b.quantity,0))*a.unitcost) AS invvalue
		, MAX(A.TRANSDATE) AS MAXDATE
	FROM maximo.matrectrans a 
	LEFT JOIN maximo.matrectrans b ON b.issuetype='RETURN' AND b.receiptref=a.receiptref AND b.tostoreloc!='L100000019292' 
	WHERE 1=1
		AND a.issuetype='TRANSFER' 
		AND a.transdate>'2025-03-30' 
		-- holding
		AND a.fromstoreloc='L100000019292'
		AND A.STATUS='COMP'
		-- specific issueid
		AND a.itemnum=(SELECT itemnum FROM MAXIMO.MATUSETRANS WHERE MATUSETRANSID=140494)
		AND a.tostoreloc=(SELECT storeloc FROM MAXIMO.MATUSETRANS WHERE MATUSETRANSID=140494)
		AND a.transdate<(SELECT TRANSDATE FROM MAXIMO.MATUSETRANS WHERE MATUSETRANSID=140494)
	GROUP BY a.itemnum, a.tostoreloc
) d ON d.itemnum=a.itemnum AND d.tostoreloc=a.storeloc
LEFT JOIN (
	SELECT a.itemnum, a.tostoreloc, sum(a.quantity) AS quantity
		, CASE WHEN sum(a.quantity)=0 THEN 0 ELSE sum(a.quantity*a.unitcost)/sum(a.quantity) END AS avgcost
		--, sum(a.quantity*a.unitcost) AS invvalue
		, MAX(A.TRANSDATE) AS MAXDATE
		, MIN(A.TRANSDATE) AS MINDATE
	FROM maximo.matrectrans a 
	WHERE 1=1
		AND a.issuetype='TRANSFER' 
		AND a.transdate>'2025-03-30'
		-- transfer between store
		AND a.fromstoreloc!='L100000019292' AND a.fromstoreloc!=a.tostoreloc
		-- specific issueid
		AND a.itemnum=(SELECT itemnum FROM MAXIMO.MATUSETRANS WHERE MATUSETRANSID=140494)
		AND a.tostoreloc=(SELECT storeloc FROM MAXIMO.MATUSETRANS WHERE MATUSETRANSID=140494)
		AND a.transdate<(SELECT TRANSDATE FROM MAXIMO.MATUSETRANS WHERE MATUSETRANSID=140494)
	GROUP BY a.itemnum, a.tostoreloc
) e ON e.itemnum=a.itemnum AND e.tostoreloc=a.storeloc
LEFT JOIN (
	SELECT a.itemnum, a.storeloc, -1*sum(a.quantity) AS quantity
		, CASE WHEN sum(a.quantity)=0 THEN 0 ELSE sum(a.quantity*a.unitcost)/sum(a.quantity) END AS avgcost
		, -1*sum(a.quantity*a.unitcost) AS invvalue
		, MAX(A.TRANSDATE) AS MAXDATE
		, MIN(A.TRANSDATE) AS MINDATE
	FROM maximo.matusetrans a 
	WHERE 1=1
		AND (a.issuetype='RETURN' OR a.issuetype='ISSUE')
		AND a.transdate>'2025-03-30' 
		-- specific issueid
		AND a.itemnum=(SELECT itemnum FROM MAXIMO.MATUSETRANS WHERE MATUSETRANSID=140494)
		AND a.storeloc=(SELECT storeloc FROM MAXIMO.MATUSETRANS WHERE MATUSETRANSID=140494)
		AND a.transdate<(SELECT TRANSDATE FROM MAXIMO.MATUSETRANS WHERE MATUSETRANSID=140494)
	GROUP BY a.itemnum, a.storeloc
) f ON f.itemnum=a.itemnum AND f.storeloc=a.storeloc
LEFT JOIN (
	SELECT a.itemnum, a.fromstoreloc, sum(a.quantity) AS quantity
		, CASE WHEN sum(a.quantity)=0 THEN 0 ELSE sum(a.quantity*a.unitcost)/sum(a.quantity) END AS avgcost
		--, sum(a.quantity*a.unitcost) AS invvalue
		, MAX(A.TRANSDATE) AS MAXDATE
	FROM maximo.matrectrans a 
	WHERE 1=1
		AND a.issuetype='TRANSFER' 
		AND a.transdate>'2025-03-30' AND a.transdate<(SELECT TRANSDATE FROM MAXIMO.MATUSETRANS WHERE MATUSETRANSID=140494)
		-- transfer between store
		AND a.fromstoreloc!='L100000019292' AND a.fromstoreloc!=a.tostoreloc
		-- specific issueid
		AND a.itemnum=(SELECT itemnum FROM MAXIMO.MATUSETRANS WHERE MATUSETRANSID=140494)
		AND a.fromstoreloc=(SELECT storeloc FROM MAXIMO.MATUSETRANS WHERE MATUSETRANSID=140494)
		AND a.transdate<(SELECT TRANSDATE FROM MAXIMO.MATUSETRANS WHERE MATUSETRANSID=140494)
	GROUP BY a.itemnum, a.fromstoreloc
) g ON g.itemnum=a.itemnum AND g.fromstoreloc=a.storeloc
WHERE MATUSETRANSID=140494;

-- GET RECEIPTS
SELECT a.ponum, a.polinenum, c.ste_cswngrnnum
	, a.itemnum, x.description
	, x.ste_cswnitemcat AS item_cat, x.ste_itemgroup AS item_group, x.ste_cswnauthority AS item_authority
	, a.tostoreloc, a.fromstoreloc, a.matrectransid, c.statusdate, c.statuschangeby
	, c.ste_cswngrnnum, c.ste_cswngrndate, c.ste_cswndndate
	, c.transdate AS receiptdate, c.quantity AS receiptqty, c.inspectedqty
	, a.transdate AS completeddate, a.quantity AS acceptedqty
	, b.transdate AS returndate, b.quantity AS returnqty
	, b.tostoreloc AS return_tostoreloc, b.tobin AS return_tobin, b.fromstoreloc AS return_fromstoreloc, b.frombin AS return_frombin
	, a.unitcost, a.linecost, a.currencycode, a.currencyunitcost, a.currencylinecost, a.exchangerate
	, b.matrectransid AS returnid
	, c.matrectransid AS receiptid
	, im.vendor, im.invoicenum, im.invoicelinenum
FROM maximo.matrectrans a 
JOIN maximo.item x ON x.itemnum=a.itemnum
LEFT JOIN maximo.matrectrans b ON b.issuetype='RETURN' AND b.receiptref=a.receiptref --AND b.ste_migrationid IS NOT null
LEFT JOIN maximo.matrectrans c ON c.matrectransid=a.receiptref
LEFT JOIN maximo.INVOICEMATCH im ON im.MATRECTRANSID=c.MATRECTRANSID
WHERE 1=1
	AND a.issuetype='TRANSFER' 
	AND a.transdate>'2025-03-30'
--	-- holding
	AND a.fromstoreloc='L100000019292'
	AND A.STATUS='COMP'
--	--AND a.itemnum='A44-AUX1-APS1-0003XX'
--	--AND a.itemnum='A44-BRK1-PNE1-0024XX'
--	AND im.INVOICEMATCHID IS NULL
--	AND a.transdate>='2025-05-01' AND a.transdate<='2025-05-31'
--	AND a.ponum='AA10016094'
	AND COALESCE(b.quantity,0)!=0
	--AND b.transdate>'2025-03-30'
	--AND c.ste_cswngrnnum IN ('GRN25/0307', 'GRN25/0266', '25/0307', 'GRN25/0277', 'GRN25\0304')
	AND a.itemnum='A44-AUX1-APS1-0079XX'
order by a.ponum, a.polinenum, c.ste_cswngrnnum
;

SELECT b.ponum, b.polinenum, b.transdate, b.itemnum, b.tostoreloc, b.tobin, b.fromstoreloc, b.frombin
	, c.ste_cswngrnnum, c.ste_cswngrndate, c.ste_cswndndate
	, b.matrectransid AS returnid, b.quantity AS returnqty
	, c.matrectransid AS receiptid, c.quantity AS receiptqty, c.inspectedqty
	, d.matrectransid AS acceptedid, d.quantity AS acceptedqty
FROM  maximo.matrectrans b 
JOIN maximo.matrectrans c ON c.matrectransid=b.receiptref
LEFT JOIN maximo.matrectrans d ON d.receiptref=b.receiptref AND d.issuetype='TRANSFER' AND d.fromstoreloc='L100000019292' AND d.STATUS='COMP'
where b.issuetype='RETURN'
	AND b.transdate>'2025-03-30'
	AND b.receiptref IN (1954966, 1731848)
;

SELECT itemnum, tostoreloc, tobin, fromstoreloc, frombin, quantity
FROM  maximo.matrectrans
WHERE matrectransid IN (1954966, 1731848)

SELECT * FROM MAXIMO.STE_RPT_ACCRUAL_STK
WHERE TRANSDATE BETWEEN '2025-05-01' AND '2025-05-31';

SELECT MATRECTRANSID, TRANSDATE, ISSUETYPE, ITEMNUM, TOSTORELOC, STATUS, QUANTITY, UNITCOST, ACTUALCOST, LINECOST
	, CURRENCYCODE, EXCHANGERATE, CURRENCYUNITCOST, CURRENCYLINECOST
	, STE_MIGRATIONID, STE_CSWNACPQTY, STE_CSWNRTNTOSUPL, STE_CSWNRCTQTY, STE_CSWNRCTVAL
FROM maximo.matrectrans WHERE unitcost=0 AND status NOT IN ('WINSP', 'WASSET') AND PONUM!='CSWN_NONPO'
;

SELECT A.INVTRANSID, A.ITEMNUM, B.DESCRIPTION, A.STORELOC, A.BINNUM, A.TRANSDATE, A.TRANSTYPE
	, A.CURBAL, A.PHYSCNT, A.QUANTITY, A.OLDCOST, A.NEWCOST, A.ENTERBY, A.MEMO
FROM MAXIMO.INVTRANS A
JOIN MAXIMO.ITEM B ON B.ITEMNUM=A.ITEMNUM
WHERE A.TRANSTYPE IN ('CURBALADJ', 'CAPCSTADJ')
ORDER BY A.ITEMNUM, A.STORELOC, A.BINNUM, A.TRANSDATE
;

SELECT A.INVTRANSID, A.ITEMNUM, B.DESCRIPTION, A.STORELOC, A.BINNUM, A.TRANSDATE, A.TRANSTYPE
, A.CURBAL, A.PHYSCNT, A.QUANTITY, A.OLDCOST, A.NEWCOST, A.ENTERBY, A.MEMO 
FROM MAXIMO.INVTRANS A JOIN MAXIMO.ITEM B ON B.ITEMNUM=A.ITEMNUM 
WHERE A.TRANSTYPE IN ('CURBALADJ', 'CAPCSTADJ')
AND CAST(A.TRANSDATE AS DATE) BETWEEN '2025-04-01' AND '2025-04-30' 
ORDER BY A.ITEMNUM, A.STORELOC, A.BINNUM, A.TRANSDATE;

			SELECT X.INVBALANCESID, x.ITEMNUM, x.LOCATION, X.CURBAL, Y.INVCOSTID, x.*
			FROM MAXIMO.INVBALANCES x
			LEFT JOIN MAXIMO.INVCOST y ON y.itemnum=x.itemnum AND y.location=x.location AND (COALESCE(Y.CONDITIONCODE,'')=COALESCE(X.CONDITIONCODE,''))
			WHERE X.ITEMNUM='A44-DRS1-DDR1-0016XX'
			
SELECT * FROM MAXIMO.INVBALANCES WHERE ITEMNUM='S/CH/CLEANERS/04' AND LOCATION='CW';

	SELECT * FROM MIGRATION.DBG_INVENTORY_PER_STORE_ITEM 
	WHERE ITEMNUM='A44-TRE1-0001-0002XX';
	
SELECT * FROM MAXIMO.STE_RPT_ACCRUAL_STK
WHERE 1=1
	--AND transdate BETWEEN '2025-05-01' AND '2025-05-31'
	--AND grnum IN ('GRN25/0307', 'GRN25/0266', '25/0307', 'GRN25/0277', 'GRN25\0304')
	--AND grnum IN ('25/0264', '25/0263')
ORDER BY transdate;

		SELECT r.matrectransid, r.ponum, r.polinenum, r.porevisionnum, r.transdate, m.transdate AS completeddate
			, r.itemnum, m.quantity, m.unitcost, m.linecost, r.STE_CSWNGRNNUM, r.STE_CSWNGRNDATE, r.PACKINGSLIPNUM
			, r.GLDEBITACCT, r.STE_MIGRATIONID, r.STE_CSWNACPQTY, r.STE_CSWNRCTQTY, r.STE_CSWNRTNTOSUPL, r.STE_CSWNRCTSTATUS
		FROM maximo.MATRECTRANS m
		JOIN maximo.MATRECTRANS r ON r.matrectransid=m.receiptref
		JOIN maximo.PO po ON po.PONUM=m.PONUM AND po.REVISIONNUM=m.POREVISIONNUM
		JOIN maximo.COMPANIES c ON c.COMPANY=po.VENDOR 
		JOIN maximo.ITEM i ON i.ITEMNUM=m.ITEMNUM
		LEFT JOIN maximo.INVOICEMATCH im ON im.MATRECTRANSID=m.MATRECTRANSID
		WHERE m.ISSUETYPE='TRANSFER' AND m.STATUS='COMP' AND m.FROMSTORELOC='L100000019292' AND m.TOSTORELOC IS NOT NULL AND m.TOSTORELOC!='L100000019292'
			AND r.STE_CSWNGRNNUM IN ('25/0264', '25/0263')
			--AND m.ISSUETYPE IN ('RECEIPT')	-- MOVED TO SUBQUERY
			AND po.STATUS IN (SELECT VALUE FROM MAXIMO.SYNONYMDOMAIN WHERE DOMAINID='POSTATUS' AND MAXVALUE IN ('APPR', 'INPRG', 'CLOSE'))
			AND im.INVOICEMATCHID IS NULL
			-- valid qty
			AND (
				-- before migration, use ACP_QTY
				(m.COMPLETEDDATE<='2025-03-30' AND COALESCE(m.STE_CSWNACPQTY, m.QUANTITY) > 0)
				-- after migration, use QUANTITY
				OR (m.COMPLETEDDATE>'2025-03-30' AND m.QUANTITY>0)
			)
			--AND m.INSPECTEDQTY <> m.REJECTQTY
			-- Valid SAPGL
			--AND ( coa.GLCOMP03 IS NOT NULL ) 
			--AND ( coa.GLCOMP03 BETWEEN '100000' AND '299999' ) 
			--AND ( coa.GLCOMP03 <> '113601' ) 
			-- Valid costcenter: not necessary since now costcenter is part of GLDEBITACCT
			--AND ( coa.GLCOMP02 IS NOT NULL ) 
			-- LEGACY FROM COSWIN: receiptval > 0
			AND m.LINECOST>0
			-- LEGACY FROM COSWIN: receiptstatus != fully invoiced
			AND ( CHR(COALESCE(m.STE_CSWNRCTSTATUS,50)) <> '3' )	-- 51
			-- LEGACY FROM COSWIN
			AND ( m.PONUM <> 'EE10005692' ) 
			AND ( m.PONUM <> 'EE10005693' )  
			AND ( coalesce(m.STE_CSWNRCTQTY,1) <> coalesce(m.STE_CSWNRTNTOSUPL,0) )  
;

SELECT itemnum, transdate, issuetype, quantity, unitcost, linecost, currencycode, currencyunitcost, currencylinecost 
FROM maximo.matrectrans WHERE linecost=0 AND unitcost>0 AND quantity>0;

		SELECT * FROM maximo.matrectrans WHERE ste_cswngrnnum IN ('25/0264', '25/0263')