CALL MIGRATION.STE_START_PATCH('20260428_REPORTS');

-- MAXIMO.STE_RPT_PO_LIST
CREATE OR REPLACE VIEW MAXIMO.STE_RPT_PO_LIST AS
SELECT 
   '1.6' AS VERSION,
	A.POID, B.POLINEID,
	A.PONUM,
	A.REVISIONNUM,
	A.ORDERDATE,
	COALESCE(h.displayname,a.purchaseagent) AS purchaseagent, 
	a.vendor,
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
	b.receiptscomplete, b.reqdeliverydate, 
	-- v1.6: get from PO.VENDELIVERYDATE instead of from POLINE.VENDELIVERYDATE
	A.VENDELIVERYDATE AS VENDELIVERYDATE,
	COALESCE(D.QUANTITY,0) AS RECEIVEDQTY,
	COALESCE(D.ACCEPTEDQTY,0) AS ACCEPTEDQTY,
	COALESCE(D.REJECTQTY,0) AS REJECTQTY,
	COALESCE(D.RETURNEDQTY,0) AS RETURNEDQTY,
	COALESCE(G.QUANTITY,0) AS DIRECT_RECEIVEDQTY,
	COALESCE(G.RETURNEDQTY,0) AS DIRECT_RETURNEDQTY,
	COALESCE(G.ACCEPTEDQTY,0) AS DIRECT_ACCEPTEDQTY,
	COALESCE(K.QUANTITY,0) AS SERVICE_RECEIVEDQTY,
	COALESCE(K.RETURNEDQTY,0) AS SERVICE_RETURNEDQTY,
	COALESCE(K.ACCEPTEDQTY,0) AS SERVICE_ACCEPTEDQTY,
	COALESCE(D.QUANTITY,0)+COALESCE(G.QUANTITY,0)+COALESCE(K.QUANTITY,0) AS TOTAL_RECEIVEDQTY,
	COALESCE(D.ACCEPTEDQTY,0)+COALESCE(G.ACCEPTEDQTY,0)+COALESCE(K.ACCEPTEDQTY,0) AS TOTAL_ACCEPTEDQTY,
	COALESCE(D.RETURNEDQTY,0)+COALESCE(G.RETURNEDQTY,0)+COALESCE(K.RETURNEDQTY,0) AS TOTAL_RETURNEDQTY,
	COALESCE(D.QUANTITY,0)-COALESCE(D.TRANSFERREDQTY,0)-COALESCE(D.REJECTQTY,0) AS WINSPQTY,
	-- some old data in coswin is inconsistent >> receivedqty more than orderqty
	CASE WHEN (B.ORDERQTY - COALESCE(D.QUANTITY,0) + COALESCE(D.RETURNEDQTY,0) - COALESCE(G.ACCEPTEDQTY,0) - COALESCE(K.ACCEPTEDQTY,0)) < 0 THEN 0
	     ELSE (B.ORDERQTY - COALESCE(D.QUANTITY,0) + COALESCE(D.RETURNEDQTY,0) - COALESCE(G.ACCEPTEDQTY,0) - COALESCE(K.ACCEPTEDQTY,0))
	END AS PENDINGQTY,
	COALESCE(D.INVOICEQTY,0) AS INVOICEQTY,
	COALESCE(G.INVOICEQTY,0) AS DIRECT_INVOICEQTY,
	COALESCE(K.INVOICEQTY,0) AS SERVICE_INVOICEQTY,
	COALESCE(D.INVOICEQTY,0)+COALESCE(G.INVOICEQTY,0)+COALESCE(K.INVOICEQTY,0) AS TOTAL_INVOICEQTY,
	C.STE_CSWNITEMNO,
	C.STE_CSWNITEMCAT,
	C.STE_CSWNAUTHORITY,
	C.STE_OWNERDEPARTMENT,
	C.STE_SYSTEM,
	C.STE_SUBSYSTEM,
	C.STE_ITEMGROUP,
	C.STE_CSWNITEMCC,
	C.itemtype, C.ste_mainttype,
	A.STE_CSWNPOTYPE,
	A.CONTRACTREFID, A.CONTRACTREFNUM, A.CONTRACTREFREV
FROM MAXIMO.PO A
JOIN MAXIMO.POLINE B ON B.PONUM=A.PONUM AND B.REVISIONNUM=A.REVISIONNUM 
JOIN MAXIMO.ITEM C ON C.ITEMNUM=B.ITEMNUM
LEFT JOIN (
	-- receive with inspection
	SELECT
		m.PONUM, m.porevisionnum,
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
		sum(COALESCE(x.quantity,0) - COALESCE(y.quantity,0) + m.rejectqty) AS acceptedqty,
		-- invoiced
	    SUM(im.quantity) AS invoiceqty
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
    LEFT JOIN maximo.INVOICEMATCH im ON im.matrectransid=m.matrectransid 
    -- TODO: patch the data to insert to maximo.INVOICEMATCH for migrated data
    LEFT JOIN (
		-- total invoiced
	    SELECT m.matrectransid
	    	, m.quantity, m.rejectqty
	    	, CASE WHEN l.invoiceqty > m.quantity-m.rejectqty THEN m.quantity-m.rejectqty ELSE l.invoiceqty END AS invoiceqty
	    	, l.invoicelineid
	    FROM maximo.MATRECTRANS m
		LEFT JOIN (
			SELECT l.PONUM, l.POLINENUM, l.POREVISIONNUM, SUM(INVOICEQTY) AS INVOICEQTY, MAX(INVOICELINEID) AS INVOICELINEID
			FROM maximo.INVOICELINE l
			GROUP BY l.PONUM, l.POLINENUM, l.POREVISIONNUM
		) l ON l.PONUM=m.PONUM AND l.POLINENUM=m.POLINENUM AND l.POREVISIONNUM=m.POREVISIONNUM
		WHERE 1=1
			AND m.STATUSDATE<='2025-03-30'
			AND m.ISSUETYPE='RECEIPT' AND m.STATUS='COMP' AND m.FROMSTORELOC IS NULL AND m.TOSTORELOC!='L100000019292'
	) im2 ON im2.matrectransid=m.matrectransid
    WHERE
        m.ISSUETYPE = 'RECEIPT'
        AND m.STATUS in ('COMP','WINSP')
        AND m.FROMSTORELOC IS NULL
        AND m.TOSTORELOC = 'L100000019292'
	GROUP BY m.PONUM, m.porevisionnum, m.ITEMNUM
) D ON D.PONUM=A.PONUM AND D.POREVISIONNUM=A.REVISIONNUM AND D.ITEMNUM=B.ITEMNUM
LEFT JOIN (
    -- direct receive with no inspection
    SELECT
        m.ponum, m.porevisionnum,
        m.itemnum,
		sum(m.quantity) AS quantity,
		sum(m.rejectqty) AS returnedqty,
		sum(m.quantity-m.rejectqty) AS acceptedqty,
		-- invoiced
	    SUM(COALESCE(im.quantity, COALESCE(im2.invoiceqty,0))) AS invoiceqty
    FROM maximo.MATRECTRANS m
    LEFT JOIN maximo.INVOICEMATCH im ON im.matrectransid=m.matrectransid 
    -- TODO: patch the data to insert to maximo.INVOICEMATCH for migrated data
    -- TODO: need to patch data invoicelineid=5852 and matrectransid=1620074
    LEFT JOIN (
		-- total invoiced
	    SELECT m.matrectransid
	    	, m.quantity, m.rejectqty
	    	, CASE WHEN l.invoiceqty > m.quantity-m.rejectqty THEN m.quantity-m.rejectqty ELSE l.invoiceqty END AS invoiceqty
	    	, l.invoicelineid
	    FROM maximo.MATRECTRANS m
		LEFT JOIN (
			SELECT l.PONUM, l.POLINENUM, l.POREVISIONNUM, SUM(INVOICEQTY) AS INVOICEQTY, MAX(INVOICELINEID) AS INVOICELINEID
			FROM maximo.INVOICELINE l
			GROUP BY l.PONUM, l.POLINENUM, l.POREVISIONNUM
		) l ON l.PONUM=m.PONUM AND l.POLINENUM=m.POLINENUM AND l.POREVISIONNUM=m.POREVISIONNUM
		WHERE 1=1
			AND m.STATUSDATE<='2025-03-30'
			AND m.ISSUETYPE='RECEIPT' AND m.STATUS='COMP' AND m.FROMSTORELOC IS NULL AND m.TOSTORELOC!='L100000019292'
	) im2 ON im2.matrectransid=m.matrectransid
    WHERE
    	-- receive directly to STORE (not via HOLDING)
        m.ISSUETYPE = 'RECEIPT'
        AND m.STATUS = 'COMP'
        AND m.FROMSTORELOC IS NULL
        AND m.TOSTORELOC != 'L100000019292'
	GROUP BY m.ponum, m.porevisionnum, m.itemnum
) G ON G.PONUM=A.PONUM AND G.POREVISIONNUM=A.REVISIONNUM AND G.ITEMNUM=B.ITEMNUM
LEFT JOIN (
    -- service receipts
    SELECT
        m.ponum, m.porevisionnum,
        m.itemnum,
		sum(m.quantity) AS quantity,
		sum(m.rejectqty) AS returnedqty,
		sum(m.quantity-m.rejectqty) AS acceptedqty,
		-- invoiced
		sum(im.quantity) AS invoicematchqty,
		sum(im2.invoiceqty) AS calcinvoiceqty,
	    SUM(COALESCE(im.quantity, COALESCE(im2.invoiceqty,0))) AS invoiceqty
    FROM maximo.SERVRECTRANS m
    LEFT JOIN maximo.INVOICEMATCH im ON im.SERVRECTRANSID=m.SERVRECTRANSID 
    -- TODO: patch the data to insert to maximo.INVOICEMATCH for migrated data
    LEFT JOIN (
		-- total invoiced
	    SELECT m.SERVRECTRANSID
	    	, m.quantity, m.rejectqty
	    	, CASE WHEN l.invoiceqty > m.quantity-m.rejectqty THEN m.quantity-m.rejectqty ELSE l.invoiceqty END AS invoiceqty
	    	, l.invoicelineid
	    FROM maximo.SERVRECTRANS m
		LEFT JOIN (
			SELECT l.PONUM, l.POLINENUM, l.POREVISIONNUM, SUM(INVOICEQTY) AS INVOICEQTY, MAX(INVOICELINEID) AS INVOICELINEID
			FROM maximo.INVOICELINE l
			GROUP BY l.PONUM, l.POLINENUM, l.POREVISIONNUM
		) l ON l.PONUM=m.PONUM AND l.POLINENUM=m.POLINENUM AND l.POREVISIONNUM=m.POREVISIONNUM
		WHERE 1=1
			--AND m.TRANSDATE>'2025-03-30'
			AND m.ISSUETYPE='RECEIPT' AND m.STATUS='COMP'
	) im2 ON im2.SERVRECTRANSID=m.SERVRECTRANSID
    WHERE
        m.ISSUETYPE = 'RECEIPT'
        AND m.STATUS = 'COMP'
	GROUP BY m.ponum, m.porevisionnum, m.itemnum
) K ON K.PONUM=A.PONUM AND K.POREVISIONNUM=A.REVISIONNUM AND K.ITEMNUM=B.ITEMNUM
LEFT JOIN maximo.person h ON h.personid=a.purchaseagent
WHERE 1=1
	AND a.status IN (SELECT VALUE FROM MAXIMO.SYNONYMDOMAIN WHERE DOMAINID = 'POSTATUS' AND MAXVALUE IN ('APPR', 'INPRG', 'CLOSE'))
;

-- MAXIMO.STE_RPT_PR_LIST
CREATE OR REPLACE VIEW MAXIMO.STE_RPT_PR_LIST AS
SELECT 
   '1.5' AS VERSION
	, a.prid
	, b.prlineid, e.rfqid, f.rfqlineid, g.rfqvendorid, h.quotationlineid, c.poid, c.polineid 
	, a.prnum, COALESCE(l.displayname, a.requestedby) AS requestedby, a.issuedate AS pr_date, a.status AS pr_status, a.statusdate AS pr_statusdate 
	, b.prlinenum, b.itemnum, b.orderqty AS pr_orderqty, b.orderunit AS pr_orderunit, b.gldebitacct AS pr_gldebitacct, b.glcreditacct AS pr_glcreditacct
	, b.unitcost AS pr_unitcost, b.linecost AS pr_linecost, coalesce(b.ste_cswnwbsnum, b.ste_wbsno) AS pr_wbsnum
	, b.ste_cswnprefsupl AS preferred_supplier, b.reqdeliverydate AS pr_reqdeliverydate, b.vendeliverydate AS pr_vendeliverydate
	, e.rfqnum, f.rfqlinenum
	, e.purchaseagent AS rfq_purchaseagent, e.enterdate AS rfq_date, e.status AS rfq_status, e.statusdate AS rfq_statusdate
	, e.replydate AS rfq_replydate, e.closeondate AS rfq_closeondate
	, CASE WHEN h.orderqty=0 THEN NULL ELSE COALESCE(g.STE_CSWNDEVISCD, e.rfqnum) END AS quotationnum
	, CASE WHEN h.orderqty=0 THEN NULL ELSE g.vendor END AS quotation_vendor
	, CASE WHEN h.orderqty=0 OR g.replieddate<'1900-01-01' THEN NULL ELSE g.replieddate END AS quotation_replieddate
	, CASE WHEN h.orderqty=0 THEN NULL ELSE g.currencycode END AS quotation_currencycode
	, CASE WHEN h.orderqty=0 THEN NULL ELSE g.exchangerate END AS quotation_exchangerate
	, CASE WHEN h.orderqty=0 THEN NULL ELSE h.manufacturer END AS quotation_manufacturer
	, CASE WHEN h.orderqty=0 THEN NULL ELSE h.orderqty END AS quotation_orderqty
	, CASE WHEN h.orderqty=0 THEN NULL ELSE h.orderunit END AS quotation_orderunit
	, CASE WHEN h.orderqty=0 THEN NULL ELSE h.unitcost END AS quotation_unitcost
	, CASE WHEN h.orderqty=0 THEN NULL ELSE h.linecost END AS quotation_linecost
	, c.ponum, c.revisionnum AS porevisionnum, c.polinenum, c.purchaseagent, c.vendor, c.orderdate, c.status AS po_status, c.statusdate AS po_statusdate
	, c.currencycode AS po_currencydate, c.exchangerate AS po_exchangerate, c.exchangedate AS po_exchangedate
	, c.orderqty AS po_orderqty, c.orderunit AS po_orderunit, c.gldebitacct AS po_gldebitacct, c.glcreditacct AS po_glcreditacct
	, c.unitcost AS po_unitcost, c.linecost AS po_linecost
	, c.PO_RECEIVEDQTY, c.PO_REJECTEDQTY
	, c.TOTAL_RECEIVEDQTY AS RECEIVEDQTY, c.TOTAL_ACCEPTEDQTY AS ACCEPTEDQTY, c.TOTAL_RETURNEDQTY AS RETURNEDQTY, c.WINSPQTY, c.PENDINGQTY
	, c.TOTAL_INVOICEQTY AS INVOICEQTY
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
	, C.STE_CSWNPOTYPE
	, b.gldebitacct
	, CASE
        WHEN b.GLDEBITACCT IS NULL THEN NULL
        WHEN LENGTH(b.GLDEBITACCT) - LENGTH(replace(b.GLDEBITACCT, '-', '')) >= 2 THEN
			SUBSTR(b.GLDEBITACCT, LOCATE('-', b.GLDEBITACCT)+ 1, LOCATE('-', b.GLDEBITACCT, LOCATE('-', b.GLDEBITACCT)+ 1)-LOCATE('-', b.GLDEBITACCT)-1)
        ELSE SUBSTR(b.GLDEBITACCT, LOCATE('-', b.GLDEBITACCT)+ 1)
      END AS COSTCENTER
	, CASE
        WHEN b.GLDEBITACCT IS NULL THEN NULL
        WHEN LENGTH(b.GLDEBITACCT) - LENGTH(replace(b.GLDEBITACCT, '-', '')) < 2 THEN NULL
        ELSE SUBSTR(b.GLDEBITACCT, LOCATE('-', b.GLDEBITACCT, LOCATE('-', b.GLDEBITACCT)+ 1)+ 1)
      END AS SAP_GL_CODE
    , m.name AS company_name
FROM maximo.pr a 
JOIN MAXIMO.PRLINE b ON a.prnum=b.prnum
JOIN MAXIMO.ITEM X ON X.ITEMNUM=B.ITEMNUM
LEFT JOIN maximo.STE_RPT_PO_LIST c ON c.ponum=b.ponum AND c.revisionnum=b.porevisionnum AND c.itemnum=b.itemnum
LEFT JOIN maximo.rfq e ON e.rfqnum=b.rfqnum
LEFT JOIN maximo.rfqline f ON f.itemnum=b.itemnum AND f.rfqnum=b.rfqnum AND f.rfqlinenum=b.rfqlinenum
LEFT JOIN maximo.quotationline h ON h.itemnum=b.itemnum AND h.rfqnum=e.rfqnum AND h.isawarded=1 AND h.rfqlinenum=f.rfqlinenum
LEFT JOIN maximo.rfqvendor g ON g.rfqnum=e.rfqnum AND g.vendor=h.vendor
LEFT JOIN maximo.contract j ON j.contractnum=a.contractrefnum AND j.revisionnum=a.contractrefrev
LEFT JOIN maximo.contractline k ON k.itemnum=b.itemnum and k.contractnum=j.contractnum AND k.revisionnum=j.revisionnum
LEFT JOIN maximo.person l ON l.personid=a.requestedby
LEFT JOIN maximo.companies m ON m.company=c.vendor
WHERE 1=1
	AND a.status IN (SELECT VALUE FROM MAXIMO.SYNONYMDOMAIN WHERE DOMAINID = 'PRSTATUS' AND MAXVALUE IN ('APPR', 'COMP'))
;

-- MAXIMO.STE_RPT_TRANSACTION_LIST
CREATE OR REPLACE VIEW MAXIMO.STE_RPT_TRANSACTION_LIST AS
SELECT 
    '1.5' AS VERSION
	, a.itemnum, a.description, a.ste_cswnitemno, a.ste_cswnitemcat, a.ste_cswnauthority, a.ste_ownerdepartment
	, a.ste_system, a.ste_subsystem, a.ste_itemgroup, a.ste_cswnitemcc, a.itemtype, a.ste_mainttype
	, COALESCE(b.curbal,0) AS curbal, COALESCE(b.physcnt,0) AS physcnt, COALESCE(b.reorderlevel,0) AS reorderlevel, b.glaccount
	, COALESCE(b.minqty,0) AS minqty
	, c.prnum, c.requestedby, c.pr_date, c.pr_status, c.pr_statusdate 
	, c.prlinenum, c.pr_orderqty, c.pr_orderunit, c.pr_gldebitacct, c.pr_glcreditacct
	, c.pr_unitcost, c.pr_linecost, c.pr_wbsnum
	, c.preferred_supplier, c.pr_reqdeliverydate, c.pr_vendeliverydate
	, c.rfqnum, c.rfqlinenum, c.rfq_purchaseagent, c.rfq_date, c.rfq_status, c.rfq_statusdate
	, c.rfq_replydate, c.rfq_closeondate
	, c.quotationnum, c.quotation_vendor, c.quotation_replieddate, c.quotation_currencycode, c.quotation_exchangerate
	, c.quotation_manufacturer, c.quotation_orderqty, c.quotation_orderunit
	, c.quotation_unitcost, c.quotation_linecost
	, c.ponum, c.porevisionnum, c.polinenum, c.purchaseagent, c.vendor, c.orderdate, c.po_status, c.po_statusdate
	, c.po_currencydate, c.po_exchangerate, c.po_exchangedate
	, c.po_orderqty, c.po_orderunit, c.po_gldebitacct, c.po_glcreditacct
	, c.po_unitcost, c.po_linecost
	, c.po_receivedqty, c.po_rejectedqty
	, c.receivedqty, c.acceptedqty, c.returnedqty, c.winspqty, c.pendingqty, c.invoiceqty
	, c.receiptscomplete, c.po_reqdeliverydate, c.po_vendeliverydate
	, c.contractnum, c.contract_startdate, c.contract_enddate, c.contract_status, c.contract_statusdate
	, c.contract_vendor
	, c.contract_currencydate, c.contract_exchangerate, c.contract_exchangedate
	, c.contract_unitcost, c.contract_linecost
	, c.gldebitacct, c.COSTCENTER, c.SAP_GL_CODE, c.company_name
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

-- MAXIMO.STE_RPT_DIRECT_PO
CREATE OR REPLACE VIEW MAXIMO.STE_RPT_DIRECT_PO AS
SELECT 
   '1.0' AS VERSION,
	X.POID, X.POLINEID, X.PONUM, X.REVISIONNUM, X.POLINENUM, 
	X.ORDERDATE, X.purchaseagent, X.vendor, X.STATUS, X.statusdate, X.currencycode, X.exchangerate, X.exchangedate,
	X.ITEMNUM, X.DESCRIPTION, X.ORDERQTY, X.PO_RECEIVEDQTY, X.PO_REJECTEDQTY,
	X.orderunit, X.gldebitacct, X.glcreditacct, X.unitcost, X.linecost,
	X.receiptscomplete, X.reqdeliverydate, 
	X.VENDELIVERYDATE, X.RECEIVEDQTY, X.ACCEPTEDQTY, X.REJECTQTY, X.RETURNEDQTY,
	X.DIRECT_RECEIVEDQTY, X.DIRECT_RETURNEDQTY, X.DIRECT_ACCEPTEDQTY, 
	X.SERVICE_RECEIVEDQTY, X.SERVICE_RETURNEDQTY, X.SERVICE_ACCEPTEDQTY,
	X.TOTAL_RECEIVEDQTY, X.TOTAL_ACCEPTEDQTY, X.TOTAL_RETURNEDQTY, X.WINSPQTY,
	-- some old data in coswin is inconsistent >> receivedqty more than orderqty
	X.PENDINGQTY, X.INVOICEQTY, X.DIRECT_INVOICEQTY, X.SERVICE_INVOICEQTY, X.TOTAL_INVOICEQTY,
	X.STE_CSWNITEMNO, X.STE_CSWNITEMCAT, X.STE_CSWNAUTHORITY, X.STE_OWNERDEPARTMENT,
	X.STE_SYSTEM, X.STE_SUBSYSTEM, X.STE_ITEMGROUP, X.STE_CSWNITEMCC, X.itemtype, X.ste_mainttype, X.STE_CSWNPOTYPE,
	X.CONTRACTREFID AS contractid, X.CONTRACTREFNUM AS contractnum, X.CONTRACTREFREV AS contractrevisionnum
	, a.prid
	, b.prlineid, e.rfqid, f.rfqlineid, g.rfqvendorid, h.quotationlineid 
	, a.prnum, b.prlinenum, COALESCE(l.displayname, a.requestedby) AS requestedby, a.issuedate AS pr_date, a.status AS pr_status, a.statusdate AS pr_statusdate 
	, b.orderqty AS pr_orderqty, b.orderunit AS pr_orderunit, b.gldebitacct AS pr_gldebitacct, b.glcreditacct AS pr_glcreditacct
	, b.unitcost AS pr_unitcost, b.linecost AS pr_linecost, coalesce(b.ste_cswnwbsnum, b.ste_wbsno) AS pr_wbsnum
	, b.ste_cswnprefsupl AS preferred_supplier, b.reqdeliverydate AS pr_reqdeliverydate, b.vendeliverydate AS pr_vendeliverydate
	, e.rfqnum, f.rfqlinenum
	, e.purchaseagent AS rfq_purchaseagent, e.enterdate AS rfq_date, e.status AS rfq_status, e.statusdate AS rfq_statusdate
	, e.replydate AS rfq_replydate, e.closeondate AS rfq_closeondate
	, CASE WHEN h.orderqty=0 THEN NULL ELSE COALESCE(g.STE_CSWNDEVISCD, e.rfqnum) END AS quotationnum
	, CASE WHEN h.orderqty=0 THEN NULL ELSE g.vendor END AS quotation_vendor
	, CASE WHEN h.orderqty=0 OR g.replieddate<'1900-01-01' THEN NULL ELSE g.replieddate END AS quotation_replieddate
	, CASE WHEN h.orderqty=0 THEN NULL ELSE g.currencycode END AS quotation_currencycode
	, CASE WHEN h.orderqty=0 THEN NULL ELSE g.exchangerate END AS quotation_exchangerate
	, CASE WHEN h.orderqty=0 THEN NULL ELSE h.manufacturer END AS quotation_manufacturer
	, CASE WHEN h.orderqty=0 THEN NULL ELSE h.orderqty END AS quotation_orderqty
	, CASE WHEN h.orderqty=0 THEN NULL ELSE h.orderunit END AS quotation_orderunit
	, CASE WHEN h.orderqty=0 THEN NULL ELSE h.unitcost END AS quotation_unitcost
	, CASE WHEN h.orderqty=0 THEN NULL ELSE h.linecost END AS quotation_linecost
	, COALESCE(Y.curbal,0) AS curbal, COALESCE(Y.physcnt,0) AS physcnt, COALESCE(Y.reorderlevel,0) AS reorderlevel, Y.glaccount
	, COALESCE(Y.minqty,0) AS minqty
	--, X.ste_system, X.ste_subsystem, X.ste_itemgroup, X.ste_cswnitemcc
	, CASE
        WHEN b.GLDEBITACCT IS NULL THEN NULL
        WHEN LENGTH(b.GLDEBITACCT) - LENGTH(replace(b.GLDEBITACCT, '-', '')) >= 2 THEN
			SUBSTR(b.GLDEBITACCT, LOCATE('-', b.GLDEBITACCT)+ 1, LOCATE('-', b.GLDEBITACCT, LOCATE('-', b.GLDEBITACCT)+ 1)-LOCATE('-', b.GLDEBITACCT)-1)
        ELSE SUBSTR(b.GLDEBITACCT, LOCATE('-', b.GLDEBITACCT)+ 1)
      END AS COSTCENTER
	, CASE
        WHEN b.GLDEBITACCT IS NULL THEN NULL
        WHEN LENGTH(b.GLDEBITACCT) - LENGTH(replace(b.GLDEBITACCT, '-', '')) < 2 THEN NULL
        ELSE SUBSTR(b.GLDEBITACCT, LOCATE('-', b.GLDEBITACCT, LOCATE('-', b.GLDEBITACCT)+ 1)+ 1)
      END AS SAP_GL_CODE
    , m.name AS company_name
    , X.status AS po_status, X.orderqty AS po_orderqty, X.vendeliverydate AS po_vendeliverydate
	, j.startdate AS contract_startdate, j.enddate AS contract_enddate, j.status AS contract_status, j.statusdate AS contract_statusdate
	, j.vendor AS contract_vendor
	, j.currencycode AS contract_currencydate, j.exchangerate AS contract_exchangerate, j.exchangedate AS contract_exchangedate
	, k.unitcost AS contract_unitcost, k.linecost AS contract_linecost
FROM maximo.STE_RPT_PO_LIST X
LEFT JOIN MAXIMO.PRLINE b ON X.ponum=b.ponum AND X.revisionnum=b.porevisionnum AND X.itemnum=b.itemnum AND X.POLINENUM=b.POLINENUM
LEFT JOIN maximo.pr A ON  a.prnum=b.prnum
LEFT JOIN maximo.rfq e ON e.rfqnum=b.rfqnum
LEFT JOIN maximo.rfqline f ON f.itemnum=b.itemnum AND f.rfqnum=b.rfqnum AND f.rfqlinenum=b.rfqlinenum
LEFT JOIN maximo.quotationline h ON h.itemnum=b.itemnum AND h.rfqnum=e.rfqnum AND h.isawarded=1 AND h.rfqlinenum=f.rfqlinenum
LEFT JOIN maximo.rfqvendor g ON g.rfqnum=e.rfqnum AND g.vendor=h.vendor
LEFT JOIN maximo.contract j ON j.contractnum=X.CONTRACTREFNUM AND j.revisionnum=X.CONTRACTREFREV
LEFT JOIN maximo.contractline k ON k.itemnum=X.itemnum and k.contractnum=j.contractnum AND k.revisionnum=j.revisionnum
LEFT JOIN maximo.person l ON l.personid=a.requestedby
LEFT JOIN maximo.companies m ON m.company=X.vendor
LEFT JOIN (
	SELECT a.itemnum, sum(b.curbal) AS curbal, sum(b.physcnt) AS physcnt
		, max(CASE WHEN a.location='TRANSIT' THEN NULL ELSE a.minlevel end) AS reorderlevel
		, max(CASE WHEN a.location='TRANSIT' THEN NULL ELSE a.glaccount end) AS glaccount
		, max(CASE WHEN a.location='TRANSIT' THEN NULL ELSE a.ste_minqty end) AS minqty
	FROM maximo.inventory a
	JOIN maximo.invbalances b ON b.itemnum=a.itemnum AND b.location=a.location
	GROUP BY a.itemnum
) Y ON Y.itemnum=X.itemnum
WHERE 1=1
	AND A.CONTRACTREFNUM IS NOT NULL
;

-- MAXIMO.PRC_RPT_INSPRESULT_DEFECTLIST
--#SET TERMINATOR /

CREATE OR REPLACE PROCEDURE MAXIMO.PRC_RPT_INSPRESULT_DEFECTLIST(
	IN P_WONUM VARCHAR(16) 
)
LANGUAGE SQL
SPECIFIC PRC_RPT_INSPRESULT_DEFECTLIST
DYNAMIC RESULT SETS 2
READS SQL DATA
BEGIN
   DECLARE V_VERSION VARCHAR(10) DEFAULT 'v3.2';
   DECLARE V_CURRENT_TS TIMESTAMP DEFAULT NULL;
  
   DECLARE C1 CURSOR WITH RETURN TO CLIENT FOR
	WITH ASSESSMENTRESULT AS (
		SELECT 
			B.RESULTNUM, B.INSPFORMNUM, B.REVISION, C.GROUPID, C.INSPQUESTIONNUM, D.INSPFIELDNUM
			, X.INSPFIELDRESULTID, X.INSPFIELDRESULTNUM, X.TXTRESPONSE, X.NUMRESPONSE, X.DATERESPONSE, X.TIMERESPONSE
			, C."SEQUENCE", C.DESCRIPTION AS QUESTION, D.DESCRIPTION AS FIELD
			, E.STE_TEMPLATE AS TEMPLATE
		FROM MAXIMO.INSPECTIONRESULT B
		JOIN MAXIMO.INSPECTIONFORM E ON E.INSPFORMNUM=B.INSPFORMNUM AND E.REVISION=B.REVISION
		JOIN MAXIMO.INSPQUESTION C ON C.INSPFORMNUM=B.INSPFORMNUM AND C.REVISION=B.REVISION
		JOIN MAXIMO.INSPFIELD D ON D.INSPFORMNUM=B.INSPFORMNUM AND D.REVISION=B.REVISION
			AND D.INSPQUESTIONNUM=C.INSPQUESTIONNUM
		LEFT JOIN MAXIMO.INSPQUESTION F ON 1=1
			AND F.INSPFORMNUM=B.INSPFORMNUM AND F.REVISION=B.REVISION
			AND F.GROUPID=C.GROUPID AND COALESCE(F.SEQUENCE,0)=0
		LEFT JOIN MAXIMO.INSPFIELDRESULT X ON X.RESULTNUM=B.RESULTNUM
			AND X.INSPQUESTIONNUM=C.INSPQUESTIONNUM
			AND X.INSPFIELDNUM=D.INSPFIELDNUM
		WHERE 1=1
			--AND B.ASSET='A100000034779' AND B.REFERENCEOBJECTID='WO10486634'
			--AND B.ASSET='A100000338335' AND B.REFERENCEOBJECTID='WO10486635'
			AND B.REFERENCEOBJECTID=P_WONUM
			AND (
				(E.STE_TEMPLATE IN ('ACA1','ACA2') AND (C.GROUPID=5))
				--OR (E.STE_TEMPLATE IN ('ACA3') AND (C.GROUPID=98))
				OR C.GROUPID=98
			)
		ORDER BY B.RESULTNUM, C.INSPQUESTIONNUM, D.INSPFIELDNUM
	),
	DEFECTLIST AS (
		SELECT A.RESULTNUM, A.INSPFORMNUM, A.REVISION, A.QUESTION
			, A."SEQUENCE", A.TEMPLATE
			, (SELECT TXTRESPONSE FROM ASSESSMENTRESULT WHERE RESULTNUM=A.RESULTNUM AND "SEQUENCE"=A."SEQUENCE" AND UPPER(FIELD)=UPPER('Item')) AS ITEM
			, (SELECT TXTRESPONSE FROM ASSESSMENTRESULT WHERE RESULTNUM=A.RESULTNUM AND "SEQUENCE"=A."SEQUENCE" AND UPPER(FIELD)=UPPER('Subitem')) AS SUBITEM
			, (SELECT TXTRESPONSE FROM ASSESSMENTRESULT WHERE RESULTNUM=A.RESULTNUM AND "SEQUENCE"=A."SEQUENCE" AND UPPER(FIELD)=UPPER('System')) AS "SYSTEM"
			, (SELECT TXTRESPONSE FROM ASSESSMENTRESULT WHERE RESULTNUM=A.RESULTNUM AND "SEQUENCE"=A."SEQUENCE" AND UPPER(FIELD)=UPPER('Component')) AS COMPONENT
			, (SELECT TXTRESPONSE FROM ASSESSMENTRESULT WHERE RESULTNUM=A.RESULTNUM AND "SEQUENCE"=A."SEQUENCE" AND UPPER(FIELD)=UPPER('Checklist Item')) AS CHECKLIST
			, (SELECT TXTRESPONSE FROM ASSESSMENTRESULT WHERE RESULTNUM=A.RESULTNUM AND "SEQUENCE"=A."SEQUENCE" AND UPPER(FIELD)=UPPER('Actual Description of Defects')) AS DEFECT
			, (SELECT TXTRESPONSE FROM ASSESSMENTRESULT WHERE RESULTNUM=A.RESULTNUM AND "SEQUENCE"=A."SEQUENCE" AND UPPER(FIELD)=UPPER('Defect Caused By')) AS CAUSEDBY
			, (SELECT TXTRESPONSE FROM ASSESSMENTRESULT WHERE RESULTNUM=A.RESULTNUM AND "SEQUENCE"=A."SEQUENCE" AND UPPER(FIELD)=UPPER('Potential Impact')) AS IMPACT
			, (SELECT TXTRESPONSE FROM ASSESSMENTRESULT WHERE RESULTNUM=A.RESULTNUM AND "SEQUENCE"=A."SEQUENCE" AND UPPER(FIELD)=UPPER('Recommended Rectification Work')) AS RECOMMENDEDRECTIFICATION
			, (SELECT TXTRESPONSE FROM ASSESSMENTRESULT WHERE RESULTNUM=A.RESULTNUM AND "SEQUENCE"=A."SEQUENCE" AND UPPER(FIELD)=UPPER('Recommended Rectification Duration')) AS RECTIFICATIONDURATION
			, (SELECT INSPFIELDRESULTID FROM ASSESSMENTRESULT WHERE RESULTNUM=A.RESULTNUM AND "SEQUENCE"=A."SEQUENCE" AND UPPER(FIELD)=UPPER('Defect Photo')) AS DEFECTPHOTO
			, (SELECT DATERESPONSE FROM ASSESSMENTRESULT WHERE RESULTNUM=A.RESULTNUM AND "SEQUENCE"=A."SEQUENCE" AND UPPER(FIELD)=UPPER('Date of Defect Notice to SBST')) AS NOTICEDATE
			, (SELECT TXTRESPONSE FROM ASSESSMENTRESULT WHERE RESULTNUM=A.RESULTNUM AND "SEQUENCE"=A."SEQUENCE" AND UPPER(FIELD)=UPPER('Analysis by SBST')) AS SBSTANALYSIS
			, (SELECT TXTRESPONSE FROM ASSESSMENTRESULT WHERE RESULTNUM=A.RESULTNUM AND "SEQUENCE"=A."SEQUENCE" AND UPPER(FIELD)=UPPER('Proposed Rectification by SBST')) AS SBSTRECTIFICATION
			, (SELECT TXTRESPONSE FROM ASSESSMENTRESULT WHERE RESULTNUM=A.RESULTNUM AND "SEQUENCE"=A."SEQUENCE" AND UPPER(FIELD)=UPPER('LTA Comments')) AS LTACOMMENTS
			, (SELECT TXTRESPONSE FROM ASSESSMENTRESULT WHERE RESULTNUM=A.RESULTNUM AND "SEQUENCE"=A."SEQUENCE" AND UPPER(FIELD)=UPPER('SBST Comments')) AS SBSTCOMMENTS
			, (SELECT TXTRESPONSE FROM ASSESSMENTRESULT WHERE RESULTNUM=A.RESULTNUM AND "SEQUENCE"=A."SEQUENCE" AND UPPER(FIELD)=UPPER('Contractor Comments')) AS CONTRACTORCOMMENTS
			, (SELECT TXTRESPONSE FROM ASSESSMENTRESULT WHERE RESULTNUM=A.RESULTNUM AND "SEQUENCE"=A."SEQUENCE" AND UPPER(FIELD)=UPPER('Rectified by')) AS RECTIFIEDBY
			, (SELECT DATERESPONSE FROM ASSESSMENTRESULT WHERE RESULTNUM=A.RESULTNUM AND "SEQUENCE"=A."SEQUENCE" AND UPPER(FIELD)=UPPER('Rectification Date')) AS RECTIFICATIONDATE
			, (SELECT TXTRESPONSE FROM ASSESSMENTRESULT WHERE RESULTNUM=A.RESULTNUM AND "SEQUENCE"=A."SEQUENCE" AND UPPER(FIELD)=UPPER('Rectification Verified by')) AS VERIFIEDBY
			, (SELECT DATERESPONSE FROM ASSESSMENTRESULT WHERE RESULTNUM=A.RESULTNUM AND "SEQUENCE"=A."SEQUENCE" AND UPPER(FIELD)=UPPER('Rectification Inspection Date')) AS INSPECTIONDATE
			, (SELECT TXTRESPONSE FROM ASSESSMENTRESULT WHERE RESULTNUM=A.RESULTNUM AND "SEQUENCE"=A."SEQUENCE" AND UPPER(FIELD)=UPPER('Maintenance Order No.')) AS MAINTENANCEORDERNO
			, (SELECT TXTRESPONSE FROM ASSESSMENTRESULT WHERE RESULTNUM=A.RESULTNUM AND "SEQUENCE"=A."SEQUENCE" AND UPPER(FIELD)=UPPER('SBST Comments (If Any)')) AS SBSTRECTIFICATIONCOMMENTS
			, (SELECT TXTRESPONSE FROM ASSESSMENTRESULT WHERE RESULTNUM=A.RESULTNUM AND "SEQUENCE"=A."SEQUENCE" AND UPPER(FIELD)=UPPER('Reasons for Delay (If Any)')) AS REASONFORDELAY
			, (SELECT INSPFIELDRESULTID FROM ASSESSMENTRESULT WHERE RESULTNUM=A.RESULTNUM AND "SEQUENCE"=A."SEQUENCE" AND UPPER(FIELD)=UPPER('Rectified Photo')) AS RECTIFIEDPHOTO
			, (SELECT NUMRESPONSE FROM ASSESSMENTRESULT WHERE RESULTNUM=A.RESULTNUM AND "SEQUENCE"=A."SEQUENCE" AND UPPER(FIELD)=UPPER('Score after Rectification')) AS RECTIFIEDSCORE
		FROM (
			SELECT 
				B.RESULTNUM, B.INSPFORMNUM, B.REVISION, B.QUESTION
				, MAX(B."SEQUENCE") AS "SEQUENCE", MAX(B.TEMPLATE) AS TEMPLATE
			FROM ASSESSMENTRESULT B
			GROUP BY B.RESULTNUM, B.INSPFORMNUM, B.REVISION, B.QUESTION
		) A
	)
	SELECT
		V_CURRENT_TS AS "TIMESTAMP", V_VERSION AS VERSION, P_WONUM AS WONUM
		, A.RESULTNUM, A.INSPFORMNUM, A.REVISION, A."SEQUENCE", A.QUESTION AS "LABEL"
		, A."SYSTEM", COALESCE(A.ITEM, A.COMPONENT) AS ITEM, A.SUBITEM
		, A.CHECKLIST, A.DEFECT, A.CAUSEDBY, A.IMPACT
		, A.RECOMMENDEDRECTIFICATION, A.RECTIFICATIONDURATION, A.DEFECTPHOTO
		, A.NOTICEDATE, A.SBSTANALYSIS, A.SBSTRECTIFICATION, A.LTACOMMENTS, A.SBSTCOMMENTS, A.CONTRACTORCOMMENTS
		, A.RECTIFIEDBY, A.RECTIFICATIONDATE, A.VERIFIEDBY, A.INSPECTIONDATE, A.MAINTENANCEORDERNO 
		, A.SBSTRECTIFICATIONCOMMENTS, A.REASONFORDELAY, A.RECTIFIEDPHOTO, A.RECTIFIEDSCORE	
		, ROW_NUMBER() OVER (ORDER BY A."SEQUENCE") AS RN
		, A.TEMPLATE
		, (SELECT COUNT(*) FROM MAXIMO.DOCLINKS Y WHERE Y.OWNERTABLE='INSPFIELDRESULT' AND Y.OWNERID=A.DEFECTPHOTO) AS DEFECTPHOTOCNT
		, (SELECT COUNT(*) FROM MAXIMO.DOCLINKS Y WHERE Y.OWNERTABLE='INSPFIELDRESULT' AND Y.OWNERID=A.RECTIFIEDPHOTO) AS RECTIFIEDPHOTOCNT
	FROM DEFECTLIST A 
	WHERE A.DEFECT IS NOT NULL 
		OR (SELECT COUNT(*) FROM MAXIMO.DOCLINKS Y WHERE Y.OWNERTABLE='INSPFIELDRESULT' AND Y.OWNERID=A.DEFECTPHOTO)>0 
		OR (SELECT COUNT(*) FROM MAXIMO.DOCLINKS Y WHERE Y.OWNERTABLE='INSPFIELDRESULT' AND Y.OWNERID=A.RECTIFIEDPHOTO)>0
		OR A."SYSTEM" IS NOT NULL OR COALESCE(A.ITEM, A.COMPONENT) IS NOT NULL
		OR A.SUBITEM IS NOT NULL OR A.CHECKLIST IS NOT NULL OR A.CAUSEDBY IS NOT NULL OR A.IMPACT IS NOT NULL
		OR A.RECOMMENDEDRECTIFICATION IS NOT NULL OR A.RECTIFICATIONDURATION IS NOT NULL
		OR A.RECTIFIEDBY IS NOT NULL OR A.RECTIFICATIONDATE IS NOT NULL OR A.VERIFIEDBY IS NOT NULL
		OR A.INSPECTIONDATE IS NOT NULL OR A.MAINTENANCEORDERNO IS NOT NULL OR A.SBSTRECTIFICATIONCOMMENTS IS NOT NULL
		OR A.REASONFORDELAY IS NOT NULL
	;

   SET V_CURRENT_TS=CURRENT_TIMESTAMP;

   IF (UPPER(P_WONUM)='NULL' OR P_WONUM='') THEN SET P_WONUM=NULL; END IF;

   OPEN C1;

END;
/

-- MAXIMO.PRC_RPT_INSPRESULT_OBSERVATIONS
--#SET TERMINATOR /

CREATE OR REPLACE PROCEDURE MAXIMO.PRC_RPT_INSPRESULT_OBSERVATIONS(
	IN P_WONUM VARCHAR(16) 
)
LANGUAGE SQL
SPECIFIC PRC_RPT_INSPRESULT_OBSERVATIONS
DYNAMIC RESULT SETS 2
READS SQL DATA
BEGIN
   DECLARE V_VERSION VARCHAR(10) DEFAULT 'v3.2';
   DECLARE V_CURRENT_TS TIMESTAMP DEFAULT NULL;
  
   DECLARE C1 CURSOR WITH RETURN TO CLIENT FOR
	WITH ASSESSMENTRESULT AS (
		SELECT 
			B.RESULTNUM, B.INSPFORMNUM, B.REVISION, C.GROUPID, C.INSPQUESTIONNUM, D.INSPFIELDNUM
			, X.INSPFIELDRESULTID, X.INSPFIELDRESULTNUM, X.TXTRESPONSE, X.NUMRESPONSE, X.DATERESPONSE, X.TIMERESPONSE
			, C."SEQUENCE", C.DESCRIPTION AS QUESTION, D.DESCRIPTION AS FIELD
			, E.STE_TEMPLATE AS TEMPLATE
		FROM MAXIMO.INSPECTIONRESULT B
		JOIN MAXIMO.INSPECTIONFORM E ON E.INSPFORMNUM=B.INSPFORMNUM AND E.REVISION=B.REVISION
		JOIN MAXIMO.INSPQUESTION C ON C.INSPFORMNUM=B.INSPFORMNUM AND C.REVISION=B.REVISION
		JOIN MAXIMO.INSPFIELD D ON D.INSPFORMNUM=B.INSPFORMNUM AND D.REVISION=B.REVISION
			AND D.INSPQUESTIONNUM=C.INSPQUESTIONNUM
		LEFT JOIN MAXIMO.INSPQUESTION F ON 1=1
			AND F.INSPFORMNUM=B.INSPFORMNUM AND F.REVISION=B.REVISION
			AND F.GROUPID=C.GROUPID AND COALESCE(F.SEQUENCE,0)=0
		LEFT JOIN MAXIMO.INSPFIELDRESULT X ON X.RESULTNUM=B.RESULTNUM
			AND X.INSPQUESTIONNUM=C.INSPQUESTIONNUM
			AND X.INSPFIELDNUM=D.INSPFIELDNUM
		WHERE 1=1
			--AND B.ASSET='A100000034779' AND B.REFERENCEOBJECTID='WO10486634'
			--AND B.ASSET='A100000338335' AND B.REFERENCEOBJECTID='WO10486635'
			AND B.REFERENCEOBJECTID=P_WONUM
			AND (
				(E.STE_TEMPLATE IN ('ACA1','ACA2') AND (C.GROUPID=6))
				--OR (E.STE_TEMPLATE IN ('ACA3') AND (C.GROUPID=99))
				OR C.GROUPID=99
			)
		ORDER BY B.RESULTNUM, C.INSPQUESTIONNUM, D.INSPFIELDNUM
	),
	OBSERVATIONS AS (
		SELECT A.RESULTNUM, A.INSPFORMNUM, A.REVISION, A.QUESTION, A."SEQUENCE", A.TEMPLATE
			, (SELECT TXTRESPONSE FROM ASSESSMENTRESULT WHERE RESULTNUM=A.RESULTNUM AND "SEQUENCE"=A."SEQUENCE" AND UPPER(FIELD)=UPPER('Item')) AS ITEM
			, (SELECT TXTRESPONSE FROM ASSESSMENTRESULT WHERE RESULTNUM=A.RESULTNUM AND "SEQUENCE"=A."SEQUENCE" AND UPPER(FIELD)=UPPER('Subitem')) AS SUBITEM
			, (SELECT TXTRESPONSE FROM ASSESSMENTRESULT WHERE RESULTNUM=A.RESULTNUM AND "SEQUENCE"=A."SEQUENCE" AND UPPER(FIELD)=UPPER('System')) AS "SYSTEM"
			, (SELECT TXTRESPONSE FROM ASSESSMENTRESULT WHERE RESULTNUM=A.RESULTNUM AND "SEQUENCE"=A."SEQUENCE" AND UPPER(FIELD)=UPPER('Component')) AS COMPONENT
			, (SELECT TXTRESPONSE FROM ASSESSMENTRESULT WHERE RESULTNUM=A.RESULTNUM AND "SEQUENCE"=A."SEQUENCE" AND UPPER(FIELD)=UPPER('Checklist Item')) AS CHECKLIST
			, (SELECT TXTRESPONSE FROM ASSESSMENTRESULT WHERE RESULTNUM=A.RESULTNUM AND "SEQUENCE"=A."SEQUENCE" AND UPPER(FIELD)=UPPER('Observation')) AS OBSERVATION
			, (SELECT TXTRESPONSE FROM ASSESSMENTRESULT WHERE RESULTNUM=A.RESULTNUM AND "SEQUENCE"=A."SEQUENCE" AND UPPER(FIELD)=UPPER('Potential Impact')) AS IMPACT
			, (SELECT TXTRESPONSE FROM ASSESSMENTRESULT WHERE RESULTNUM=A.RESULTNUM AND "SEQUENCE"=A."SEQUENCE" AND UPPER(FIELD)=UPPER('Recommended Rectification Work')) AS RECOMMENDEDRECTIFICATION
			, (SELECT TXTRESPONSE FROM ASSESSMENTRESULT WHERE RESULTNUM=A.RESULTNUM AND "SEQUENCE"=A."SEQUENCE" AND UPPER(FIELD)=UPPER('Recommended Rectification Duration')) AS RECTIFICATIONDURATION
			, (SELECT INSPFIELDRESULTID FROM ASSESSMENTRESULT WHERE RESULTNUM=A.RESULTNUM AND "SEQUENCE"=A."SEQUENCE" AND UPPER(FIELD)=UPPER('Observation Photo')) AS OBSERVATIONPHOTO
			, (SELECT TXTRESPONSE FROM ASSESSMENTRESULT WHERE RESULTNUM=A.RESULTNUM AND "SEQUENCE"=A."SEQUENCE" AND UPPER(FIELD)=UPPER('Remark')) AS REMARK
		FROM (
			SELECT 
				B.RESULTNUM, B.INSPFORMNUM, B.REVISION, B.QUESTION
				, MAX(B."SEQUENCE") AS "SEQUENCE", MAX(B.TEMPLATE) AS TEMPLATE
			FROM ASSESSMENTRESULT B
			GROUP BY B.RESULTNUM, B.INSPFORMNUM, B.REVISION, B.QUESTION
		) A
	)
	SELECT
		V_CURRENT_TS AS "TIMESTAMP", V_VERSION AS VERSION, P_WONUM AS WONUM
		, A.RESULTNUM, A.INSPFORMNUM, A.REVISION, A."SEQUENCE", A.QUESTION AS "LABEL"
		, A."SYSTEM", COALESCE(A.ITEM, A.COMPONENT) AS ITEM, A.SUBITEM
		, A.CHECKLIST, A.OBSERVATION, A.IMPACT
		, A.RECOMMENDEDRECTIFICATION, A.RECTIFICATIONDURATION, A.OBSERVATIONPHOTO, A.REMARK
		, ROW_NUMBER() OVER (ORDER BY A."SEQUENCE") AS RN
		, A.TEMPLATE
	FROM OBSERVATIONS A
	WHERE A.OBSERVATION IS NOT NULL
		OR (SELECT COUNT(*) FROM MAXIMO.DOCLINKS Y WHERE Y.OWNERTABLE='INSPFIELDRESULT' AND Y.OWNERID=A.OBSERVATIONPHOTO)>0 
		OR A."SYSTEM" IS NOT NULL OR COALESCE(A.ITEM, A.COMPONENT) IS NOT NULL OR A.SUBITEM IS NOT NULL
		OR A.CHECKLIST IS NOT NULL OR A.IMPACT IS NOT NULL OR A.RECOMMENDEDRECTIFICATION IS NOT NULL
		OR A.RECTIFICATIONDURATION IS NOT NULL OR A.REMARK IS NOT NULL
	;

   SET V_CURRENT_TS=CURRENT_TIMESTAMP;

   IF (UPPER(P_WONUM)='NULL' OR P_WONUM='') THEN SET P_WONUM=NULL; END IF;

   OPEN C1;

END;
/


--#SET TERMINATOR ;

CALL MIGRATION.STE_FINISH_PATCH('20260428_REPORTS');