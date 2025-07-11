CALL MIGRATION.STE_START_PATCH('20250710-01-REPORT');

CREATE OR REPLACE VIEW MAXIMO.STE_RPT_PO_LIST AS
SELECT 
   '1.0' AS VERSION,
	A.POID, B.POLINEID,
	A.PONUM,
	A.REVISIONNUM,
	A.ORDERDATE,
	a.purchaseagent, a.vendor,
	A.STATUS,
	a.statusdate,
	a.currencycode, a.exchangerate, a.exchangedate,
	B.POLINENUM,
	C.ITEMNUM,
	C.DESCRIPTION,
	B.ORDERQTY,
	B.RECEIVEDQTY AS PO_RECEIVEDQTY,
	B.REJECTEDQTY AS PO_REJECTEDQTY,
	b.orderunit, b.gldebitacct, b.glcreditacct, b.unitcost, b.linecost,
	b.receiptscomplete, b.reqdeliverydate, b.vendeliverydate,
	COALESCE(D.QUANTITY,0) AS RECEIVEDQTY,
	COALESCE(D.ACCEPTEDQTY,0) AS ACCEPTEDQTY,
	COALESCE(D.REJECTQTY,0) AS REJECTQTY,
	COALESCE(D.RETURNEDQTY,0) AS RETURNEDQTY,
	COALESCE(G.QUANTITY,0) AS DIRECT_RECEIVEDQTY,
	COALESCE(G.RETURNEDQTY,0) AS DIRECT_RETURNEDQTY,
	COALESCE(G.ACCEPTEDQTY,0) AS DIRECT_ACCEPTEDQTY,
	COALESCE(D.QUANTITY,0)+COALESCE(G.QUANTITY,0) AS TOTAL_RECEIVEDQTY,
	COALESCE(D.ACCEPTEDQTY,0)+COALESCE(G.ACCEPTEDQTY,0) AS TOTAL_ACCEPTEDQTY,
	COALESCE(D.RETURNEDQTY,0)+COALESCE(G.RETURNEDQTY,0) AS TOTAL_RETURNEDQTY,
	COALESCE(D.QUANTITY,0)-COALESCE(D.TRANSFERREDQTY,0)-COALESCE(D.REJECTQTY,0) AS WINSPQTY,
	-- some old data in coswin is inconsistent >> receivedqty more than orderqty
	CASE WHEN (B.ORDERQTY - COALESCE(D.QUANTITY,0) + COALESCE(D.RETURNEDQTY,0) - COALESCE(G.ACCEPTEDQTY,0)) < 0 THEN 0
	     ELSE (B.ORDERQTY - COALESCE(D.QUANTITY,0) + COALESCE(D.RETURNEDQTY,0) - COALESCE(G.ACCEPTEDQTY,0))
	END AS PENDINGQTY,
	C.STE_CSWNITEMNO,
	C.STE_CSWNITEMCAT,
	C.STE_CSWNAUTHORITY,
	C.STE_OWNERDEPARTMENT,
	C.STE_SYSTEM,
	C.STE_ITEMGROUP,
	C.STE_CSWNITEMCC
FROM MAXIMO.PO A
JOIN MAXIMO.POLINE B ON B.PONUM=A.PONUM AND B.REVISIONNUM=A.REVISIONNUM 
JOIN MAXIMO.ITEM C ON C.ITEMNUM=B.ITEMNUM
LEFT JOIN (
	-- receive with inspection
	SELECT
		m.PONUM,
		m.ITEMNUM,
		-- received: actual delivered qty 
		sum(m.quantity) AS quantity,
		-- reject: reject during inspection - before being accepted >> received = transfered + rejected
		sum(m.rejectqty) AS REJECTQTY,
		-- return: return after inspection + rejected >> total returned
		sum(COALESCE(y.quantity,0)) AS returnedqty,
		-- transferred: pass inspection
		sum(COALESCE(x.quantity,0)) AS transferredqty,
		-- accepted: tranferred - (returned - rejected)
		sum(COALESCE(x.quantity,0) - COALESCE(y.quantity,0) + m.rejectqty) AS acceptedqty
    FROM maximo.MATRECTRANS m
	LEFT JOIN (
	    -- transferred >> passed inspection >> received - rejected
	    SELECT
	        m.receiptref,
	        SUM(m.quantity) AS quantity
	    FROM
	        maximo.MATRECTRANS m
	    WHERE
	    	-- transfer from HOLDING to STORE
	        m.ISSUETYPE = 'TRANSFER'
	        AND m.STATUS = 'COMP'
	        AND m.FROMSTORELOC = 'L100000019292'
	        AND m.TOSTORELOC IS NOT NULL
	        AND m.TOSTORELOC != 'L100000019292'
	        --AND m.ponum='AA10016094'
	        --and r.STE_CSWNGRNNUM='GRN25/0307'
		GROUP BY m.receiptref
	) x ON x.receiptref=m.matrectransid
	LEFT JOIN (
	    -- return
	    SELECT
	        m.receiptref,
	        -- return qty is negative
	        -1 * SUM(m.quantity) AS quantity
	    FROM
	        maximo.MATRECTRANS m
	    WHERE
	        m.ISSUETYPE = 'RETURN'
	        AND m.STATUS = 'COMP'
		GROUP BY m.receiptref
	) y ON y.receiptref=m.matrectransid
    WHERE
        m.ISSUETYPE = 'RECEIPT'
        AND m.STATUS in ('COMP','WINSP')
        AND m.FROMSTORELOC IS NULL
        AND m.TOSTORELOC = 'L100000019292'
	GROUP BY m.PONUM, m.ITEMNUM
) D ON D.PONUM=A.PONUM AND D.ITEMNUM=B.ITEMNUM
LEFT JOIN (
    -- direct receive with no inspection
    SELECT
        m.ponum,
        m.itemnum,
		sum(m.quantity) AS quantity,
		sum(m.rejectqty) AS returnedqty,
		sum(m.quantity-m.rejectqty) AS acceptedqty
    FROM maximo.MATRECTRANS m
    WHERE
    	-- receive directly to STORE (not via HOLDING)
        m.ISSUETYPE = 'RECEIPT'
        AND m.STATUS = 'COMP'
        AND m.FROMSTORELOC IS NULL
        AND m.TOSTORELOC != 'L100000019292'
	GROUP BY m.ponum, m.itemnum
) G ON G.PONUM=A.PONUM AND G.ITEMNUM=B.ITEMNUM
WHERE 1=1
	AND a.status IN (SELECT VALUE FROM MAXIMO.SYNONYMDOMAIN WHERE DOMAINID = 'POSTATUS' AND MAXVALUE IN ('APPR', 'INPRG', 'CLOSE'))
;

CREATE OR REPLACE VIEW MAXIMO.STE_RPT_PR_LIST AS
SELECT 
   '1.0' AS VERSION
	, a.prid, b.prlineid, e.rfqid, f.rfqlineid, g.rfqvendorid, h.quotationlineid, c.poid, c.polineid 
	, a.prnum, a.requestedby, a.issuedate AS pr_date, a.status AS pr_status, a.statusdate AS pr_statusdate 
	, b.itemnum, b.orderqty AS pr_orderqty, b.orderunit AS pr_orderunit, b.gldebitacct AS pr_gldebitacct, b.glcreditacct AS pr_glcreditacct
	, b.unitcost AS pr_unitcost, b.linecost AS pr_linecost, coalesce(b.ste_cswnwbsnum, b.ste_wbsno) AS pr_wbsnum
	, b.ste_cswnprefsupl AS preferred_supplier, b.reqdeliverydate AS pr_reqdeliverydate, b.vendeliverydate AS pr_vendeliverydate
	, e.rfqnum, e.purchaseagent AS rfq_purchaseagent, e.enterdate AS rfq_date, e.status AS rfq_status, e.statusdate AS rfq_statusdate
	, e.replydate AS rfq_replydate, e.closeondate AS rfq_closeondate
	, g.vendor AS quotation_vendor, g.replieddate AS quotation_replieddate, g.currencycode AS quotation_currencycode, g.exchangerate AS quotation_exchangerate
	, h.manufacturer AS quotation_manufacturer, h.orderqty AS quotation_orderqty, h.orderunit AS quotation_orderunit
	, h.unitcost AS quotation_unitcost, h.linecost AS quotation_linecost
	, c.ponum, c.purchaseagent, c.vendor, c.orderdate, c.status AS po_status, c.statusdate AS po_statusdate
	, c.currencycode AS po_currencydate, c.exchangerate AS po_exchangerate, c.exchangedate AS po_exchangedate
	, c.orderqty AS po_orderqty, c.orderunit AS po_orderunit, c.gldebitacct AS po_gldebitacct, c.glcreditacct AS po_glcreditacct
	, c.unitcost AS po_unitcost, c.linecost AS po_linecost
	, c.PO_RECEIVEDQTY, c.PO_REJECTEDQTY
	, c.TOTAL_RECEIVEDQTY AS RECEIVEDQTY, c.TOTAL_ACCEPTEDQTY AS ACCEPTEDQTY, c.TOTAL_RETURNEDQTY AS RETURNEDQTY, c.WINSPQTY, c.PENDINGQTY
	, c.receiptscomplete
	, c.reqdeliverydate AS po_reqdeliverydate, c.vendeliverydate AS po_vendeliverydate
	, b.orderqty - c.orderqty AS pendingorderqty
	, j.contractnum, j.startdate AS contract_startdate, j.enddate AS contract_enddate, j.status AS contract_status, j.statusdate AS contract_statusdate
	, j.vendor AS contract_vendor
	, j.currencycode AS contract_currencydate, j.exchangerate AS contract_exchangerate, j.exchangedate AS contract_exchangedate
	, k.unitcost AS contract_unitcost, k.linecost AS contract_linecost
	, X.DESCRIPTION
	, X.STE_CSWNITEMNO
	, X.STE_CSWNITEMCAT
	, X.STE_CSWNAUTHORITY
	, X.STE_OWNERDEPARTMENT
	, X.STE_SYSTEM
	, X.STE_ITEMGROUP
	, X.STE_CSWNITEMCC
FROM maximo.pr a 
JOIN MAXIMO.PRLINE b ON a.prnum=b.prnum
JOIN MAXIMO.ITEM X ON X.ITEMNUM=B.ITEMNUM
LEFT JOIN maximo.STE_RPT_PO_LIST c ON c.ponum=b.ponum AND c.revisionnum=b.porevisionnum AND c.itemnum=b.itemnum
LEFT JOIN maximo.rfq e ON e.rfqnum=b.rfqnum
LEFT JOIN maximo.rfqline f ON f.itemnum=b.itemnum AND f.rfqnum=e.rfqnum
LEFT JOIN maximo.quotationline h ON h.itemnum=b.itemnum AND h.rfqnum=e.rfqnum AND h.isawarded=1
LEFT JOIN maximo.rfqvendor g ON g.rfqnum=e.rfqnum AND g.vendor=h.vendor
LEFT JOIN maximo.contract j ON j.contractnum=a.contractrefnum AND j.revisionnum=a.contractrefrev
LEFT JOIN maximo.contractline k ON k.itemnum=b.itemnum and k.contractnum=j.contractnum AND k.revisionnum=j.revisionnum
WHERE 1=1
	AND a.status IN (SELECT VALUE FROM MAXIMO.SYNONYMDOMAIN WHERE DOMAINID = 'PRSTATUS' AND MAXVALUE IN ('APPR', 'COMP'))
;

-- MAXIMO.STE_RPT_TRANSACTION_LIST source

CREATE OR REPLACE VIEW MAXIMO.STE_RPT_TRANSACTION_LIST AS
SELECT 
    '1.0' AS VERSION
	, a.itemnum, a.description, a.ste_cswnitemno, a.ste_cswnitemcat, a.ste_cswnauthority, a.ste_ownerdepartment
	, a.ste_system, a.ste_itemgroup, a.ste_cswnitemcc
	, COALESCE(b.curbal,0) AS curbal, COALESCE(b.physcnt,0) AS physcnt, COALESCE(b.reorderlevel,0) AS reorderlevel, b.glaccount
	, COALESCE(b.minqty,0) AS minqty
	, c.prnum, c.requestedby, c.pr_date, c.pr_status, c.pr_statusdate 
	, c.pr_orderqty, c.pr_orderunit, c.pr_gldebitacct, c.pr_glcreditacct
	, c.pr_unitcost, c.pr_linecost, c.pr_wbsnum
	, c.preferred_supplier, c.pr_reqdeliverydate, c.pr_vendeliverydate
	, c.rfqnum, c.rfq_purchaseagent, c.rfq_date, c.rfq_status, c.rfq_statusdate
	, c.rfq_replydate, c.rfq_closeondate
	, c.quotation_vendor, c.quotation_replieddate, c.quotation_currencycode, c.quotation_exchangerate
	, c.quotation_manufacturer, c.quotation_orderqty, c.quotation_orderunit
	, c.quotation_unitcost, c.quotation_linecost
	, c.ponum, c.purchaseagent, c.vendor, c.orderdate, c.po_status, c.po_statusdate
	, c.po_currencydate, c.po_exchangerate, c.po_exchangedate
	, c.po_orderqty, c.po_orderunit, c.po_gldebitacct, c.po_glcreditacct
	, c.po_unitcost, c.po_linecost
	, c.po_receivedqty, c.po_rejectedqty
	, c.receivedqty, c.acceptedqty, c.returnedqty, c.winspqty, c.pendingqty
	, c.receiptscomplete, c.po_reqdeliverydate, c.po_vendeliverydate
	, c.contractnum, c.contract_startdate, c.contract_enddate, c.contract_status, c.contract_statusdate
	, c.contract_vendor
	, c.contract_currencydate, c.contract_exchangerate, c.contract_exchangedate
	, c.contract_unitcost, c.contract_linecost
FROM maximo.item a
LEFT JOIN (
	SELECT a.itemnum, sum(b.curbal) AS curbal, sum(b.physcnt) AS physcnt
		, max(CASE WHEN a.location='TRANSIT' THEN NULL ELSE a.minlevel end) AS reorderlevel
		, max(CASE WHEN a.location='TRANSIT' THEN NULL ELSE a.glaccount end) AS glaccount
		, max(CASE WHEN a.location='TRANSIT' THEN NULL ELSE a.ste_minqty end) AS minqty
	FROM maximo.inventory a
	JOIN maximo.invbalances b ON b.itemnum=a.itemnum AND b.location=a.location
	GROUP BY a.itemnum
) b ON b.itemnum=a.itemnum
LEFT JOIN maximo.STE_RPT_PR_LIST c ON c.itemnum=a.itemnum
WHERE 1=1
	AND a.ste_cswnitemcat!='NEL'
	AND a.ste_cswnauthority!='TEMP'
;

CALL MIGRATION.STE_FINISH_PATCH('20250710-01-REPORT');