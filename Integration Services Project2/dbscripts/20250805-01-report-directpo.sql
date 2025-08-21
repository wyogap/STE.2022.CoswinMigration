CALL MIGRATION.STE_START_PATCH('20250805-01-REPORT-DIRECTPO');

CREATE OR REPLACE VIEW MAXIMO.STE_RPT_PR_LIST AS
SELECT 
   '1.4' AS VERSION
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
LEFT JOIN maximo.rfqline f ON f.itemnum=b.itemnum AND f.rfqnum=e.rfqnum
LEFT JOIN maximo.quotationline h ON h.itemnum=b.itemnum AND h.rfqnum=e.rfqnum AND h.isawarded=1
LEFT JOIN maximo.rfqvendor g ON g.rfqnum=e.rfqnum AND g.vendor=h.vendor
LEFT JOIN maximo.contract j ON j.contractnum=a.contractrefnum AND j.revisionnum=a.contractrefrev
LEFT JOIN maximo.contractline k ON k.itemnum=b.itemnum and k.contractnum=j.contractnum AND k.revisionnum=j.revisionnum
LEFT JOIN maximo.person l ON l.personid=a.requestedby
LEFT JOIN maximo.companies m ON m.company=c.vendor
WHERE 1=1
	AND a.status IN (SELECT VALUE FROM MAXIMO.SYNONYMDOMAIN WHERE DOMAINID = 'PRSTATUS' AND MAXVALUE IN ('APPR', 'COMP'))
;

CREATE OR REPLACE VIEW MAXIMO.STE_RPT_TRANSACTION_LIST AS
SELECT 
    '1.4' AS VERSION
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

CALL MIGRATION.STE_FINISH_PATCH('20250805-01-REPORT-DIRECTPO');