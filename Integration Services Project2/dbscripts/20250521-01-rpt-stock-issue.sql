CALL MIGRATION.STE_START_PATCH('20250521-01-RPT-STOCK-ISSUE');

CREATE OR REPLACE VIEW MAXIMO.STE_RPT_STOCK_ISSUE AS
SELECT 
	'2.3' AS VERSION
	, mut.MR_STE_MIGRATIONID AS PK_DEM_ISS, mut.STE_MIGRATIONID AS PK_ISS_ITEMS
	, mut.MRID
	, mut.MATUSETRANSID AS Issue_Num
	, mut.STE_ISSUENUM AS Coswin_Issue_Num
	, i.STE_LINE AS Line
	, i.STE_OWNERDEPARTMENT AS Dept
	, i.STE_CSWNAUTHORITY AS Authority_Code
	, i.ITEMNUM AS ITEMNUM
	, i.STE_CSWNITEMNO AS Coswin_Item_Code
	, i.DESCRIPTION AS Item_Description
	, i.STE_ITEMGROUP AS Group_Code
	, aln.DESCRIPTION AS Group_Description
	--, concat(i.STE_ITEMGROUP, CONCAT(' - ', aln.DESCRIPTION)) AS Group_Code_Description
	, i.STE_CSWNITEMCAT AS Category_Code
	, CAST(mut.ACTUALDATE AS DATE) AS Issue_Date
	, mut.ACTUALDATE AS Issue_DateTime
	, -1 * mut.QUANTITY AS Issued_Qty
	, COALESCE(mut.QTYRETURNED,0) AS Returned_Qty
	, ret.ACTUALDATE AS Return_Date
	, mut.MRNUM
	, mut.MR_STE_CSWNDEMREF AS Coswin_Demand_No
	, mut.GLCREDITACCT  
	, mut.GLDEBITACCT  
	, mut.Costcentre
	, mut.MR_STE_CSWNCC AS Coswin_CC_Code
	, gl.COMPTEXT AS CostCentre_Description
	, mut.MR_REQUESTEDBY AS REQUESTEDBY
	, p.DISPLAYNAME AS Requester
	, mut.MR_STE_MIGRATIONDEMANDER AS Coswin_Requester
	, i.ISSUEUNIT
	, mut.CURBAL
	, COALESCE(inv.CURBAL,0) AS Inventory_CURBAL
	, mut.MR_WONUM AS WONUM
	, wo.STE_CSWNWOID AS Coswin_WOID
	, mut.MR_STE_REMARKS AS Remarks
	, mut.MR_ENTERDATE AS Enter_Date
	, mut.LINECOST AS Issue_Value
	, ret.LINECOST AS Return_Value
	, mut.UNITCOST
	, mut.CURRENCYCODE
	, mut.MR_STATUS AS STATUS
	, i.STE_CSWNITEMCAT
	, coalesce(debitsapgl.SAPGL,'432101') AS DEBITSAPGL
	, creditsapgl.SAPGL AS CREDITSAPGL
	, iu.INVUSENUM
	, mut.MR_GLDEBITACCT
	, mut.MR_COSTCENTRE
FROM (
	SELECT mut.* 
	, CASE WHEN mut.GLDEBITACCT IS NULL THEN NULL
	       WHEN length(mut.GLDEBITACCT) - length(replace(mut.GLDEBITACCT,'-','')) >= 2 THEN
				SUBSTR(mut.GLDEBITACCT, LOCATE('-', mut.GLDEBITACCT)+1, LOCATE('-', mut.GLDEBITACCT, LOCATE('-', mut.GLDEBITACCT)+1)-LOCATE('-', mut.GLDEBITACCT)-1)
		   ELSE SUBSTR(mut.GLDEBITACCT, LOCATE('-', mut.GLDEBITACCT)+1)
	  END AS Costcentre
	--, CASE WHEN mut.GLDEBITACCT IS NULL THEN NULL
	--       WHEN length(mut.GLDEBITACCT) - length(replace(mut.GLDEBITACCT,'-','')) < 2 THEN NULL
	--	   ELSE SUBSTR(mut.GLDEBITACCT, LOCATE('-', mut.GLDEBITACCT, LOCATE('-', mut.GLDEBITACCT)+1)+1)
	--  END AS SAP_GL_CODE
	, m.MRID
	, m.STE_MIGRATIONID AS MR_STE_MIGRATIONID
	, m.STE_CSWNDEMREF AS MR_STE_CSWNDEMREF
	, m.STE_CSWNCC AS MR_STE_CSWNCC
	, m.STE_MIGRATIONDEMANDER AS MR_STE_MIGRATIONDEMANDER
	, m.REQUESTEDBY AS MR_REQUESTEDBY
	, m.WONUM AS MR_WONUM
	, m.STE_REMARKS AS MR_STE_REMARKS
	, m.ENTERDATE AS MR_ENTERDATE
	, m.STATUS AS MR_STATUS
	, m.GLDEBITACCT AS MR_GLDEBITACCT
	, CASE WHEN m.GLDEBITACCT IS NULL THEN NULL
	       WHEN length(m.GLDEBITACCT) - length(replace(m.GLDEBITACCT,'-','')) >= 2 THEN
				SUBSTR(m.GLDEBITACCT, LOCATE('-', m.GLDEBITACCT)+1, LOCATE('-', m.GLDEBITACCT, LOCATE('-', m.GLDEBITACCT)+1)-LOCATE('-', m.GLDEBITACCT)-1)
		   ELSE SUBSTR(m.GLDEBITACCT, LOCATE('-', m.GLDEBITACCT)+1)
	  END AS MR_COSTCENTRE
	--, CASE WHEN m.GLDEBITACCT IS NULL THEN NULL
	--       WHEN length(m.GLDEBITACCT) - length(replace(m.GLDEBITACCT,'-','')) < 2 THEN NULL
	--	   ELSE SUBSTR(m.GLDEBITACCT, LOCATE('-', m.GLDEBITACCT, LOCATE('-', m.GLDEBITACCT)+1)+1)
	--  END AS MR_SAP_GL_CODE
	FROM MAXIMO.MATUSETRANS mut 
	JOIN MAXIMO.MR m ON mut.MRNUM=m.MRNUM 
) mut
--JOIN MAXIMO.MR m ON mut.MRNUM=m.MRNUM 
JOIN MAXIMO.ITEM i ON i.ITEMNUM=mut.ITEMNUM
LEFT JOIN MAXIMO.INVUSE iu ON iu.INVUSEID=mut.INVUSEID
--LEFT JOIN MAXIMO.CHARTOFACCOUNTS coa ON coa.GLACCOUNT=mut.GLDEBITACCT
LEFT JOIN MAXIMO.GLCOMPONENTS gl ON gl.GLORDER=1 AND gl.COMPVALUE=mut.MR_COSTCENTRE
LEFT JOIN MAXIMO.ALNDOMAIN aln ON aln.DOMAINID='STE_ITEMGROUP' AND aln.VALUE=i.STE_ITEMGROUP
LEFT JOIN MAXIMO.PERSON p ON p.PERSONID=mut.MR_REQUESTEDBY
LEFT JOIN (
	SELECT a.matusetransid, a.mrnum, a.itemnum, a.quantity, a.unitcost, a.linecost, a.issuetype
		, a.actualdate, a.ste_migrationid
		, b.invuselineid, b.issueid
	FROM MAXIMO.MATUSETRANS a
	JOIN maximo.invuseline b ON b.invuselineid=a.invuselineid
	WHERE a.ISSUETYPE='RETURN'
		AND a.ISSUEID IS NOT null
) ret ON mut.ISSUETYPE='ISSUE' and mut.QTYRETURNED>0 AND ret.ISSUEID=mut.MATUSETRANSID
LEFT JOIN MAXIMO.WORKORDER wo ON wo.WONUM=mut.MR_WONUM
LEFT JOIN (
	SELECT ITEMNUM, SUM(CURBAL) AS CURBAL
	FROM MAXIMO.INVBALANCES
	GROUP BY ITEMNUM
) inv ON inv.ITEMNUM=mut.ITEMNUM
-- SAPGL for debit (40) is based on ITEM GROUP 
LEFT JOIN (
	VALUES('403801', 'BATTERY'),
			('432301', 'CHEMICAL'),
			('432250', 'CM'),
			('432150', 'DIRPURCH'),
			('432301', 'HAZARDOUS'),
			('413101', 'OFSUPPLIES'),
			('403401', 'POL'),
			('441200', 'PUBLICATION'),
			('441200', 'PUBLICATIO'),
			('435901', 'REPAIRWORK'),
			('431150', 'SAFETY'),
			('432401', 'TOOLS'),
			('432401', 'TOOS'),
			('403601', 'TYRES'),
			('432351', 'PAINTS'),
			('434160', 'CS'),
			('434160', 'NS'),
			('434160', 'C7'),
			('434160', 'ND'),
			('435650', 'OTHERS'),
			('440700', 'FREIGHT'),
			('432101', 'DEFAULT')
) AS debitsapgl(sapgl, itemgroup) ON debitsapgl.itemgroup=i.ste_itemgroup
-- SAPGL for credit (50) is based on ITEM CATEGORY
LEFT JOIN (
	VALUES('113602', 'SG_OEM_PWR'),
			('113603', 'SG_OEM_COM'),
			('113604', 'SG_OEM_SYS'),
			('113605', 'SG_OEM_RST'),
			('113606', 'SG_OEM_SIG'),
			('113607', 'SG_OEM_PWY'),
			('113608', 'SG_OEM_PMT'),
			('113610', 'SG_CONSUME'),
			('113612', 'SG_OEM_LRT'),
			('113611', 'SG_LRU')
) AS creditsapgl(sapgl, itemcat) ON creditsapgl.itemcat=i.ste_cswnitemcat
WHERE 1=1
	AND (mut.ISSUETYPE='ISSUE' OR mut.ISSUETYPE='RETURN')
	AND i.STE_CSWNITEMCAT <> 'SG_FAS'
	--AND mut.ACTUALCOST >= 0.02
	--AND mut.ACTUALDATE BETWEEN '2023-01-01' AND '2023-12-31'
	--AND coa.GLCOMP02!=m.STE_CSWNCC
	--AND m.MRNUM='MR00432425'
	--AND ret.QUANTITY>0
	--AND m.WONUM IS NOT NULL 
	--AND m.STE_REMARKS IS NOT null
;

CREATE OR REPLACE VIEW MAXIMO.STE_RPT_ACCRUAL_STK AS
SELECT
	'2.1' AS VERSION
	, m.STE_MIGRATIONID AS PK_RCT_ITEMS
	, m.PACKINGSLIPNUM AS PACKINGSLIPNUM
	, CAST(m.TRANSDATE AS DATE) AS TRANSDATE
	, m.TRANSDATE AS TRANSDATETIME
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
	, CASE WHEN m.STATUSDATE<='2025-03-30' THEN COALESCE(m.STE_CSWNACPQTY, m.QUANTITY) 
		   ELSE m.QUANTITY
	  END AS QUANTITY
	, m.ORDERQTY
	, l.INVOICEQTY
	, t.ACCEPTEDQTY
	, m.STATUS
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
	FROM maximo.MATRECTRANS m
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
	SELECT m.PONUM, m.POLINENUM, m.POREVISIONNUM, SUM(m.QUANTITY) AS ACCEPTEDQTY
	FROM maximo.MATRECTRANS m
	GROUP BY m.PONUM, m.POLINENUM, m.POREVISIONNUM
) t ON t.PONUM=m.PONUM AND t.POLINENUM=m.POLINENUM AND t.POREVISIONNUM=m.POREVISIONNUM
-- Ideally we created records here for migrated data. But at the moment, none is created
LEFT JOIN maximo.INVOICEMATCH im ON im.MATRECTRANSID=m.MATRECTRANSID
WHERE 1=1
	AND m.ISSUETYPE IN ('RECEIPT')
	AND po.STATUS IN ('APPR', 'CLOSE')
	-- Accrual: Receipt which has not been invoiced
	AND COALESCE(l.INVOICEQTY,0) < m.ORDERQTY
	AND COALESCE(l.INVOICEQTY,0) < COALESCE(t.ACCEPTEDQTY,0)
	AND im.INVOICEMATCHID IS NULL
	-- valid qty
	AND (
		-- before migration, use ACP_QTY
		(m.STATUSDATE<='2025-03-30' AND COALESCE(m.STE_CSWNACPQTY, m.QUANTITY) > 0)
		-- after migration, use QUANTITY
		OR (m.STATUSDATE>'2025-03-30' AND m.QUANTITY>0)
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

CREATE OR REPLACE VIEW MAXIMO.STE_RPT_ACCRUAL_NS AS
SELECT
	'2.1' AS VERSION
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
	, m.STATUS
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
	AND po.STATUS IN ('APPR', 'CLOSE')
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

CALL MIGRATION.STE_FINISH_PATCH('20250521-01-RPT-STOCK-ISSUE');