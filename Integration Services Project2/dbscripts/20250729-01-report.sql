CALL MIGRATION.STE_START_PATCH('20250729-01-REPORT');

CREATE OR REPLACE VIEW MAXIMO.STE_RPT_PO_LIST AS
SELECT 
   '1.2' AS VERSION,
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
	COALESCE(D.INVOICEQTY,0) AS INVOICEQTY,
	COALESCE(G.INVOICEQTY,0) AS DIRECT_INVOICEQTY,
	COALESCE(D.INVOICEQTY,0)+COALESCE(G.INVOICEQTY,0) AS TOTAL_INVOICEQTY,
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
	GROUP BY m.PONUM, m.ITEMNUM
) D ON D.PONUM=A.PONUM AND D.ITEMNUM=B.ITEMNUM
LEFT JOIN (
    -- direct receive with no inspection
    SELECT
        m.ponum,
        m.itemnum,
		sum(m.quantity) AS quantity,
		sum(m.rejectqty) AS returnedqty,
		sum(m.quantity-m.rejectqty) AS acceptedqty,
		-- invoiced
	    SUM(COALESCE(im.quantity, im2.invoiceqty)) AS invoiceqty
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
	GROUP BY m.ponum, m.itemnum
) G ON G.PONUM=A.PONUM AND G.ITEMNUM=B.ITEMNUM
LEFT JOIN maximo.person h ON h.personid=a.purchaseagent
WHERE 1=1
	AND a.status IN (SELECT VALUE FROM MAXIMO.SYNONYMDOMAIN WHERE DOMAINID = 'POSTATUS' AND MAXVALUE IN ('APPR', 'INPRG', 'CLOSE'))
;

CREATE OR REPLACE VIEW MAXIMO.STE_RPT_PR_LIST AS
SELECT 
   '1.2' AS VERSION
	, a.prid, b.prlineid, e.rfqid, f.rfqlineid, g.rfqvendorid, h.quotationlineid, c.poid, c.polineid 
	, a.prnum, COALESCE(l.displayname, a.requestedby) AS requestedby, a.issuedate AS pr_date, a.status AS pr_status, a.statusdate AS pr_statusdate 
	, b.prlinenum, b.itemnum, b.orderqty AS pr_orderqty, b.orderunit AS pr_orderunit, b.gldebitacct AS pr_gldebitacct, b.glcreditacct AS pr_glcreditacct
	, b.unitcost AS pr_unitcost, b.linecost AS pr_linecost, coalesce(b.ste_cswnwbsnum, b.ste_wbsno) AS pr_wbsnum
	, b.ste_cswnprefsupl AS preferred_supplier, b.reqdeliverydate AS pr_reqdeliverydate, b.vendeliverydate AS pr_vendeliverydate
	, e.rfqnum
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
	, c.ponum, c.purchaseagent, c.vendor, c.orderdate, c.status AS po_status, c.statusdate AS po_statusdate
	, c.currencycode AS po_currencydate, c.exchangerate AS po_exchangerate, c.exchangedate AS po_exchangedate
	, c.polinenum, c.orderqty AS po_orderqty, c.orderunit AS po_orderunit, c.gldebitacct AS po_gldebitacct, c.glcreditacct AS po_glcreditacct
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
LEFT JOIN maximo.person l ON l.personid=a.requestedby
WHERE 1=1
	AND a.status IN (SELECT VALUE FROM MAXIMO.SYNONYMDOMAIN WHERE DOMAINID = 'PRSTATUS' AND MAXVALUE IN ('APPR', 'COMP'))
;

CREATE OR REPLACE VIEW MAXIMO.STE_RPT_TRANSACTION_LIST AS
SELECT 
    '1.3' AS VERSION
	, a.itemnum, a.description, a.ste_cswnitemno, a.ste_cswnitemcat, a.ste_cswnauthority, a.ste_ownerdepartment
	, a.ste_system, a.ste_subsystem, a.ste_itemgroup, a.ste_cswnitemcc, a.itemtype, a.ste_mainttype
	, COALESCE(b.curbal,0) AS curbal, COALESCE(b.physcnt,0) AS physcnt, COALESCE(b.reorderlevel,0) AS reorderlevel, b.glaccount
	, COALESCE(b.minqty,0) AS minqty
	, c.prnum, c.requestedby, c.pr_date, c.pr_status, c.pr_statusdate 
	, c.prlinenum, c.pr_orderqty, c.pr_orderunit, c.pr_gldebitacct, c.pr_glcreditacct
	, c.pr_unitcost, c.pr_linecost, c.pr_wbsnum
	, c.preferred_supplier, c.pr_reqdeliverydate, c.pr_vendeliverydate
	, c.rfqnum, c.rfq_purchaseagent, c.rfq_date, c.rfq_status, c.rfq_statusdate
	, c.rfq_replydate, c.rfq_closeondate
	, c.quotationnum, c.quotation_vendor, c.quotation_replieddate, c.quotation_currencycode, c.quotation_exchangerate
	, c.quotation_manufacturer, c.quotation_orderqty, c.quotation_orderunit
	, c.quotation_unitcost, c.quotation_linecost
	, c.ponum, c.purchaseagent, c.vendor, c.orderdate, c.po_status, c.po_statusdate
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

CREATE OR REPLACE VIEW MAXIMO.STE_RPT_ACCRUAL_STK AS
SELECT
	'2.6' AS VERSION
	, m.MATRECTRANSID
	, m.STE_MIGRATIONID AS PK_RCT_ITEMS
	, m.PACKINGSLIPNUM AS PACKINGSLIPNUM
	, CAST(m.ACTUALDATE AS DATE) AS TRANSDATE
	, m.ACTUALDATE AS TRANSDATETIME
	, m.LINECOST AS LINECOST
	, 'STK' AS STK_NS
	, m.ITEMNUM
	, i.STE_CSWNITEMNO AS COSWIN_ITEM_CODE
	, i.DESCRIPTION AS ITEM_DESCRIPTION
	, m.STE_CSWNGRNNUM AS GRNUM
	, m.STE_CSWNGRNDATE AS GRDATE
	, c.STE_CSWNSAPVNDCODE AS SAP_VENDOR_CODE
	, c.NAME AS SUPPLIER_NAME
	, m.GLDEBITACCT
	, m.COSTCENTER
	, m.SAP_GL_CODE
	--, coa.GLCOMP02 AS COSTCENTER 
	--, coa.GLCOMP03 AS SAP_GL_CODE 
	--, coalesce(pc.QUANTITY, m.STE_CSWNACPQTY) AS QUANTITY_PER_CC
	, CASE WHEN m.COMPLETEDDATE<='2025-03-30' THEN COALESCE(m.STE_CSWNACPQTY, m.QUANTITY) 
		   ELSE m.QUANTITY
	  END AS QUANTITY
	, m.ORDERQTY
	, l.INVOICEQTY
	, COALESCE(t1.ACCEPTEDQTY,0) + COALESCE(t2.ACCEPTEDQTY,0) AS ACCEPTEDQTY
	--, m.STATUS
	, m.PL_GLDEBITACCT
	, m.PL_COSTCENTER
	, m.PL_SAP_GL_CODE
FROM (
	SELECT m.* 
	, CASE WHEN m.GLDEBITACCT IS NULL THEN NULL
	       WHEN length(m.GLDEBITACCT) - length(replace(m.GLDEBITACCT,'-','')) >= 2 THEN
				SUBSTR(m.GLDEBITACCT, LOCATE('-', m.GLDEBITACCT)+1, LOCATE('-', m.GLDEBITACCT, LOCATE('-', m.GLDEBITACCT)+1)-LOCATE('-', m.GLDEBITACCT)-1)
		   ELSE SUBSTR(m.GLDEBITACCT, LOCATE('-', m.GLDEBITACCT)+1)
	  END AS COSTCENTER
	, CASE WHEN m.GLDEBITACCT IS NULL THEN NULL
	       WHEN length(m.GLDEBITACCT) - length(replace(m.GLDEBITACCT,'-','')) < 2 THEN NULL
		   ELSE SUBSTR(m.GLDEBITACCT, LOCATE('-', m.GLDEBITACCT, LOCATE('-', m.GLDEBITACCT)+1)+1)
	  END AS SAP_GL_CODE
	, pl.ORDERQTY
	, pl.GLDEBITACCT AS PL_GLDEBITACCT
	, CASE WHEN pl.GLDEBITACCT IS NULL THEN NULL
	       WHEN length(pl.GLDEBITACCT) - length(replace(pl.GLDEBITACCT,'-','')) >= 2 THEN
				SUBSTR(pl.GLDEBITACCT, LOCATE('-', pl.GLDEBITACCT)+1, LOCATE('-', pl.GLDEBITACCT, LOCATE('-', pl.GLDEBITACCT)+1)-LOCATE('-', pl.GLDEBITACCT)-1)
		   ELSE SUBSTR(pl.GLDEBITACCT, LOCATE('-', pl.GLDEBITACCT)+1)
	  END AS PL_COSTCENTER
	, CASE WHEN m.GLDEBITACCT IS NULL THEN NULL
	       WHEN length(pl.GLDEBITACCT) - length(replace(pl.GLDEBITACCT,'-','')) < 2 THEN NULL
		   ELSE SUBSTR(pl.GLDEBITACCT, LOCATE('-', pl.GLDEBITACCT, LOCATE('-', pl.GLDEBITACCT)+1)+1)
	  END AS PL_SAP_GL_CODE
	FROM (
		-- no inspection and migrated data
		SELECT m.matrectransid, m.ponum, m.polinenum, m.porevisionnum, m.transdate, m.statusdate AS completeddate, m.statusdate AS actualdate
			, m.itemnum, (m.quantity-m.rejectqty) AS quantity, m.linecost, m.STE_CSWNGRNNUM, m.STE_CSWNGRNDATE, m.PACKINGSLIPNUM
			, m.GLDEBITACCT, m.STE_MIGRATIONID, M.STE_CSWNACPQTY, M.STE_CSWNRCTQTY, M.STE_CSWNRTNTOSUPL, M.STE_CSWNRCTSTATUS
		FROM maximo.MATRECTRANS m
		WHERE m.ISSUETYPE='RECEIPT' AND m.STATUS='COMP' AND m.FROMSTORELOC IS NULL AND m.TOSTORELOC!='L100000019292'	
			--AND m.ponum='AA10016094'
		
		UNION
		
		-- inspection
		SELECT r.matrectransid, r.ponum, r.polinenum, r.porevisionnum, r.transdate, m.transdate AS completeddate, m.actualdate AS actualdate
			, r.itemnum, (m.quantity+COALESCE(rtn.quantity,0)) AS quantity, m.linecost, r.STE_CSWNGRNNUM, r.STE_CSWNGRNDATE, r.PACKINGSLIPNUM
			, r.GLDEBITACCT, r.STE_MIGRATIONID, r.STE_CSWNACPQTY, r.STE_CSWNRCTQTY, r.STE_CSWNRTNTOSUPL, r.STE_CSWNRCTSTATUS
			--, rtn.tostoreloc, r.tostoreloc, m.tostoreloc
		FROM maximo.MATRECTRANS m
		JOIN maximo.MATRECTRANS r ON r.matrectransid=m.receiptref
		LEFT JOIN maximo.matrectrans rtn ON rtn.issuetype='RETURN' AND rtn.receiptref=m.receiptref AND rtn.tostoreloc=m.tostoreloc 
		WHERE m.ISSUETYPE='TRANSFER' AND m.STATUS='COMP' AND m.FROMSTORELOC='L100000019292' AND m.TOSTORELOC IS NOT NULL AND m.TOSTORELOC!='L100000019292'
			--AND m.ponum='AA10016094'
			--and r.STE_CSWNGRNNUM='GRN25/0307'
	) m
	JOIN maximo.POLINE pl ON pl.PONUM=m.PONUM AND pl.POLINENUM=m.POLINENUM AND pl.REVISIONNUM=m.POREVISIONNUM
) m
JOIN maximo.PO po ON po.PONUM=m.PONUM AND po.REVISIONNUM=m.POREVISIONNUM
JOIN maximo.COMPANIES c ON c.COMPANY=po.VENDOR 
JOIN maximo.ITEM i ON i.ITEMNUM=m.ITEMNUM
--JOIN maximo.POLINE pl ON pl.PONUM=m.PONUM AND pl.POLINENUM=m.POLINENUM AND pl.REVISIONNUM=m.POREVISIONNUM
LEFT JOIN maximo.CHARTOFACCOUNTS coa ON coa.GLACCOUNT=m.GLDEBITACCT
-- LEFT JOIN maximo.STE_CSWNRECEIPT_PER_CC pc ON pc.MATRECTRANSID=m.MATRECTRANSID
-- total invoiced
LEFT JOIN (
	SELECT l.PONUM, l.POLINENUM, l.POREVISIONNUM, SUM(INVOICEQTY) AS INVOICEQTY
	FROM maximo.INVOICELINE l
	GROUP BY l.PONUM, l.POLINENUM, l.POREVISIONNUM
) l ON l.PONUM=m.PONUM AND l.POLINENUM=m.POLINENUM AND l.POREVISIONNUM=m.POREVISIONNUM
-- total received and accepted
LEFT JOIN (
	-- no inspection and migrated data
	SELECT m.ponum, m.polinenum, m.porevisionnum, sum(m.quantity-m.rejectqty) AS ACCEPTEDQTY
	FROM maximo.MATRECTRANS m
	WHERE m.ISSUETYPE='RECEIPT' AND m.STATUS='COMP' AND m.FROMSTORELOC IS NULL AND m.TOSTORELOC!='L100000019292'	
	GROUP BY m.PONUM, m.POLINENUM, m.POREVISIONNUM
) t1 ON t1.PONUM=m.PONUM AND t1.POLINENUM=m.POLINENUM AND t1.POREVISIONNUM=m.POREVISIONNUM
LEFT JOIN (
	-- with inspection
	SELECT r.ponum, r.polinenum, r.porevisionnum, sum(m.quantity+COALESCE(rtn.quantity,0)) AS ACCEPTEDQTY
	FROM maximo.MATRECTRANS m
	JOIN maximo.MATRECTRANS r ON r.matrectransid=m.receiptref
	LEFT JOIN maximo.matrectrans rtn ON rtn.issuetype='RETURN' AND rtn.receiptref=m.receiptref AND rtn.tostoreloc=m.tostoreloc 
	WHERE m.ISSUETYPE='TRANSFER' AND m.STATUS='COMP' AND m.FROMSTORELOC='L100000019292' AND m.TOSTORELOC IS NOT NULL AND m.TOSTORELOC!='L100000019292'
	GROUP BY r.ponum, r.polinenum, r.porevisionnum
) t2 ON t2.PONUM=m.PONUM AND t2.POLINENUM=m.POLINENUM AND t2.POREVISIONNUM=m.POREVISIONNUM
-- Ideally we created records here for migrated data. But at the moment, none is created
LEFT JOIN maximo.INVOICEMATCH im ON im.MATRECTRANSID=m.MATRECTRANSID
WHERE 1=1
	--AND m.ISSUETYPE IN ('RECEIPT')	-- MOVED TO SUBQUERY
	AND po.STATUS IN (SELECT VALUE FROM MAXIMO.SYNONYMDOMAIN WHERE DOMAINID='POSTATUS' AND MAXVALUE IN ('APPR', 'INPRG', 'CLOSE', 'REVISE'))
	-- Accrual: Receipt which has not been invoiced
	AND COALESCE(l.INVOICEQTY,0) < m.ORDERQTY
	AND COALESCE(l.INVOICEQTY,0) < (COALESCE(t1.ACCEPTEDQTY,0) + COALESCE(t2.ACCEPTEDQTY,0))
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
	--AND m.STATUS NOT IN ('WINSP', 'WASSET')	-- MOVED TO SUBQUERY
	--AND m.STE_CSWNGRNNUM IN ('25/0264', '25/0263')
;

CREATE OR REPLACE VIEW MAXIMO.STE_RPT_ACCRUAL_NS AS
SELECT
	'2.2' AS VERSION
	, m.SERVRECTRANSID
	, m.STE_MIGRATIONID AS PK_RCT_ITEMS
	, m.PACKINGSLIPNUM AS PACKINGSLIPNUM
	, CAST(m.TRANSDATE AS DATE) AS TRANSDATE
	, m.TRANSDATE AS TRANSDATETIME
	, m.LINECOST AS LINECOST
	, 'NS' AS STK_NS
	, m.ITEMNUM
	, i.STE_CSWNITEMNO AS COSWIN_ITEM_CODE
	, i.DESCRIPTION AS ITEM_DESCRIPTION
	, m.STE_CSWNGRNNUM AS GRNUM
	, m.STE_CSWNGRNDATE AS GRDATE
	, c.STE_CSWNSAPVNDCODE AS SAP_VENDOR_CODE
	, c.NAME AS SUPPLIER_NAME
	, m.GLDEBITACCT
	, m.COSTCENTER
	, m.SAP_GL_CODE
	--, coa.GLCOMP02 AS COSTCENTER 
	--, coa.GLCOMP03 AS SAP_GL_CODE 
	--, coalesce(pc.QUANTITY, m.STE_CSWNACPQTY) AS QUANTITY_PER_CC
	, CASE WHEN m.TRANSDATE<='2025-03-30' THEN COALESCE(m.STE_CSWNACPQTY, m.QUANTITY) 
		   ELSE m.QUANTITY
	  END AS QUANTITY
	, m.ORDERQTY
	, l.INVOICEQTY
	, t.ACCEPTEDQTY
	--, m.STATUS
	, m.PL_GLDEBITACCT
	, m.PL_COSTCENTER
	, m.PL_SAP_GL_CODE
FROM (
	SELECT m.* 
	, CASE WHEN m.GLDEBITACCT IS NULL THEN NULL
	       WHEN length(m.GLDEBITACCT) - length(replace(m.GLDEBITACCT,'-','')) >= 2 THEN
				SUBSTR(m.GLDEBITACCT, LOCATE('-', m.GLDEBITACCT)+1, LOCATE('-', m.GLDEBITACCT, LOCATE('-', m.GLDEBITACCT)+1)-LOCATE('-', m.GLDEBITACCT)-1)
		   ELSE SUBSTR(m.GLDEBITACCT, LOCATE('-', m.GLDEBITACCT)+1)
	  END AS COSTCENTER
	, CASE WHEN m.GLDEBITACCT IS NULL THEN NULL
	       WHEN length(m.GLDEBITACCT) - length(replace(m.GLDEBITACCT,'-','')) < 2 THEN NULL
		   ELSE SUBSTR(m.GLDEBITACCT, LOCATE('-', m.GLDEBITACCT, LOCATE('-', m.GLDEBITACCT)+1)+1)
	  END AS SAP_GL_CODE
	, pl.ORDERQTY
	, pl.GLDEBITACCT AS PL_GLDEBITACCT
	, CASE WHEN pl.GLDEBITACCT IS NULL THEN NULL
	       WHEN length(pl.GLDEBITACCT) - length(replace(pl.GLDEBITACCT,'-','')) >= 2 THEN
				SUBSTR(pl.GLDEBITACCT, LOCATE('-', pl.GLDEBITACCT)+1, LOCATE('-', pl.GLDEBITACCT, LOCATE('-', pl.GLDEBITACCT)+1)-LOCATE('-', pl.GLDEBITACCT)-1)
		   ELSE SUBSTR(pl.GLDEBITACCT, LOCATE('-', pl.GLDEBITACCT)+1)
	  END AS PL_COSTCENTER
	, CASE WHEN m.GLDEBITACCT IS NULL THEN NULL
	       WHEN length(pl.GLDEBITACCT) - length(replace(pl.GLDEBITACCT,'-','')) < 2 THEN NULL
		   ELSE SUBSTR(pl.GLDEBITACCT, LOCATE('-', pl.GLDEBITACCT, LOCATE('-', pl.GLDEBITACCT)+1)+1)
	  END AS PL_SAP_GL_CODE
	FROM maximo.SERVRECTRANS m
	JOIN maximo.POLINE pl ON pl.PONUM=m.PONUM AND pl.POLINENUM=m.POLINENUM AND pl.REVISIONNUM=m.POREVISIONNUM
) m 
JOIN maximo.PO po ON po.PONUM=m.PONUM AND po.REVISIONNUM=m.POREVISIONNUM
JOIN maximo.COMPANIES c ON c.COMPANY=po.VENDOR 
JOIN maximo.ITEM i ON i.ITEMNUM=m.ITEMNUM
--JOIN maximo.POLINE pl ON pl.PONUM=m.PONUM AND pl.POLINENUM=m.POLINENUM AND pl.REVISIONNUM=m.POREVISIONNUM
JOIN maximo.CHARTOFACCOUNTS coa ON coa.GLACCOUNT=m.GLDEBITACCT
-- LEFT JOIN maximo.STE_CSWNRECEIPT_PER_CC pc ON pc.MATRECTRANSID=m.MATRECTRANSID
-- total invoiced
LEFT JOIN (
	SELECT l.PONUM, l.POLINENUM, l.POREVISIONNUM, SUM(INVOICEQTY) AS INVOICEQTY
	FROM maximo.INVOICELINE l
	GROUP BY l.PONUM, l.POLINENUM, l.POREVISIONNUM
) l ON l.PONUM=m.PONUM AND l.POLINENUM=m.POLINENUM AND l.POREVISIONNUM=m.POREVISIONNUM
-- total received and accepted
LEFT JOIN (
	SELECT m.PONUM, m.POLINENUM, m.POREVISIONNUM, SUM(m.QUANTITY) AS ACCEPTEDQTY
	FROM maximo.SERVRECTRANS m
	GROUP BY m.PONUM, m.POLINENUM, m.POREVISIONNUM
) t ON t.PONUM=m.PONUM AND t.POLINENUM=m.POLINENUM AND t.POREVISIONNUM=m.POREVISIONNUM
-- Ideally we created records here for migrated data. But at the moment, none is created
LEFT JOIN maximo.INVOICEMATCH im ON im.SERVRECTRANSID=m.SERVRECTRANSID
WHERE 1=1
	AND m.ISSUETYPE IN ('RECEIPT')
	AND po.STATUS IN (SELECT VALUE FROM MAXIMO.SYNONYMDOMAIN WHERE DOMAINID='POSTATUS' AND MAXVALUE IN ('APPR', 'INPRG', 'CLOSE', 'REVISE'))
	-- Accrual: Receipt which has not been invoiced
	--AND COALESCE(l.INVOICEQTY,0) < pl.ORDERQTY
	--AND COALESCE(l.INVOICEQTY,0) < COALESCE(t.ACCEPTEDQTY,0)
	AND im.INVOICEMATCHID IS NULL
	-- Service Accrual: no partial invoice in coswin)
	AND (m.STE_MIGRATIONID IS NULL OR COALESCE(l.INVOICEQTY,0)=0)
	-- Accrual: valid qty
	AND (
		-- before migration, use ACP_QTY
		(m.TRANSDATE<='2025-03-30' AND COALESCE(m.STE_CSWNACPQTY, m.QUANTITY) > 0)
		-- after migration, use QUANTITY
		OR (m.TRANSDATE>'2025-03-30' AND m.QUANTITY>0)
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
	AND m.STATUS NOT IN ('WINSP', 'WASSET')
;

-- patch some data
update maximo.invoiceline l 
SET invoiceqty=87.6
WHERE invoicelineid=5852 AND invoiceqty=87.59;

CALL MIGRATION.STE_FINISH_PATCH('20250729-01-REPORT');