CALL MIGRATION.STE_START_PATCH('20250403-04-RFQ-REMAPPING');

-- CREATE MISSING RFQ PARENT
INSERT INTO MAXIMO.RFQ
(
	RFQNUM, DESCRIPTION, STATUS, STATUSDATE, ENTERDATE, ENTERBY, REPLYDATE, CLOSEONDATE, PURCHASEAGENT, RFQTYPE, 
	REQUIREDDATE, REQUESTEDBY, SHIPTO, SHIPTOATTN, BILLTO, BILLTOATTN, REPLYTO, REPLYTOATTN, FOB, FREIGHTTERMS, 
	SHIPVIA, PAYMENTTERMS, CHANGEBY, CHANGEDATE, PRIORITY, HISTORYFLAG, 
	RFQ1, RFQ2, RFQ3, RFQ4, RFQ5, RFQ6, RFQ7, RFQ8, RFQ9, RFQ10, PRINTDATE, BUYERCOMPANY, ORGID, SITEID, 
	LANGCODE, HASLD, STE_SUBMISSION, STE_TOTALBASECOST, 
	STE_PAYTERMS, STE_SHIPTERMS, STE_REMARKS, STE_CSWNSAPGL, STE_PRNUM, STE_CSWNRFQREF, STE_PONUM,
	STE_MIGRATIONID, STE_MIGRATIONDATE, STE_MIGRATIONTS, 
	RFQID
)
SELECT 
	B.REF_DEVIS_CD AS RFQNUM, 
	DESCRIPTION, STATUS, STATUSDATE, ENTERDATE, ENTERBY, REPLYDATE, CLOSEONDATE, PURCHASEAGENT, RFQTYPE, 
	REQUIREDDATE, REQUESTEDBY, SHIPTO, SHIPTOATTN, BILLTO, BILLTOATTN, REPLYTO, REPLYTOATTN, FOB, FREIGHTTERMS, 
	SHIPVIA, PAYMENTTERMS, CHANGEBY, CHANGEDATE, PRIORITY, HISTORYFLAG, 
	RFQ1, RFQ2, RFQ3, RFQ4, RFQ5, RFQ6, RFQ7, RFQ8, RFQ9, RFQ10, PRINTDATE, BUYERCOMPANY, ORGID, SITEID, 
	LANGCODE, HASLD, STE_SUBMISSION, STE_TOTALBASECOST, 
	STE_PAYTERMS, STE_SHIPTERMS, STE_REMARKS, STE_CSWNSAPGL, STE_PRNUM, STE_CSWNRFQREF, STE_PONUM,
	20250404 AS STE_MIGRATIONID, ADD_HOURS(CURRENT_TIMESTAMP,8) AS STE_MIGRATIONDATE, -1 AS STE_MIGRATIONTS, 
	C.MAX_ID + ROW_NUMBER() OVER (ORDER BY A.RFQID) AS RFQID
FROM MAXIMO.RFQ A
JOIN (
	SELECT A.RFQNUM, B.REF_DEVIS_CD
		, ROW_NUMBER() OVER (PARTITION BY B.REF_DEVIS_CD ORDER BY A.RFQNUM) RN
	FROM MAXIMO.RFQVENDOR A
	JOIN MAXIMO.CSWN_RFQ B ON B.PK_DEVIS=A.STE_MIGRATIONID
	LEFT JOIN MAXIMO.RFQ C ON C.RFQNUM=B.REF_DEVIS_CD
	WHERE A.STE_MIGRATIONID IS NOT NULL
		AND C.RFQNUM IS NULL
	ORDER BY B.REF_DEVIS_CD, A.RFQNUM
) B ON B.RN=1 AND B.RFQNUM=A.RFQNUM 
JOIN (
	SELECT COALESCE(MAX(RFQID),0) AS MAX_ID FROM MAXIMO.RFQ
) C ON 1=1
;

INSERT INTO MAXIMO.RFQLINE
(
	RFQNUM, RFQLINENUM, ITEMNUM, STORELOC, DESCRIPTION, ORDERQTY, ORDERUNIT, REQDELIVERYDATE, 
	ENTERDATE, ENTERBY, RFQL1, RFQL2, RFQL3, RFQL4, RFQL5, PONUM, POLINENUM, ASSETNUM, REQUESTEDBY, 
	ISSUE, RFQLIN1, RFQLIN2, RFQLIN3, RFQLIN4, RFQLIN5, CHARGESTORE, GLDEBITACCT, RECEIPTREQD, CATEGORY, 
	REMARK, LOCATION, MANUFACTURER, MODELNUM, AWARDDATE, VENDOR, SUPERVISOR, PRORATESERVICE, 
	UNITCOST, LINECOST, INSPECTIONREQUIRED, POLINEID, MRNUM, MRLINENUM, 
	RFQL6, RFQL7, RFQL8, RFQL9, RFQL10, RFQLIN6, RFQLIN7, RFQLIN8, RFQLIN9, FINCNTRLID, 
	VENDORPACKCODE, VENDORPACKQUANTITY, VENDORWAREHOUSE, ORGID, SITEID, REFWO, ENTEREDASTASK, 
	LINETYPE, ITEMSETID, CONDITIONCODE, CONTRACTNUM, CONTRACTLINENUM, CONTRACTLINEID, COMMODITYGROUP, 
	COMMODITY, CONVERTTOCONTRACT, CONTRACTREV, LANGCODE, CONVERSION, CONTRACTID, HASLD, MKTPLCITEM, 
	CLASSSTRUCTUREID, POREVISIONNUM, PLUSTCOMP, PLUSTREASON, PLUSTFAILURE, PLUSTPOS, PLUSTACCOMP, PLUSTHASWARRANTY, 
	STE_ALITEMALLOWED, STE_ALTITEMDESC, STE_ALTITEMNUM, STE_ALTITEMQUOTED, STE_WBSNO, ROWSTAMP, STE_CSWNCC,
	STE_COSC, STE_CSWNSAPGL, STE_MIGRATIONITEMPK, STE_MIGRATIONNSITEMPK, 
	STE_MIGRATIONID, STE_MIGRATIONDATE, STE_MIGRATIONTS,
	RFQLINEID
)
SELECT 
	B.REF_DEVIS_CD AS RFQNUM, RFQLINENUM, ITEMNUM, STORELOC, DESCRIPTION, ORDERQTY, ORDERUNIT, REQDELIVERYDATE, 
	ENTERDATE, ENTERBY, RFQL1, RFQL2, RFQL3, RFQL4, RFQL5, PONUM, POLINENUM, ASSETNUM, REQUESTEDBY, 
	ISSUE, RFQLIN1, RFQLIN2, RFQLIN3, RFQLIN4, RFQLIN5, CHARGESTORE, GLDEBITACCT, RECEIPTREQD, CATEGORY, 
	REMARK, LOCATION, MANUFACTURER, MODELNUM, AWARDDATE, VENDOR, SUPERVISOR, PRORATESERVICE, 
	UNITCOST, LINECOST, INSPECTIONREQUIRED, POLINEID, MRNUM, MRLINENUM, 
	RFQL6, RFQL7, RFQL8, RFQL9, RFQL10, RFQLIN6, RFQLIN7, RFQLIN8, RFQLIN9, FINCNTRLID, 
	VENDORPACKCODE, VENDORPACKQUANTITY, VENDORWAREHOUSE, ORGID, SITEID, REFWO, ENTEREDASTASK, 
	LINETYPE, ITEMSETID, CONDITIONCODE, CONTRACTNUM, CONTRACTLINENUM, CONTRACTLINEID, COMMODITYGROUP, 
	COMMODITY, CONVERTTOCONTRACT, CONTRACTREV, LANGCODE, CONVERSION, CONTRACTID, HASLD, MKTPLCITEM, 
	CLASSSTRUCTUREID, POREVISIONNUM, PLUSTCOMP, PLUSTREASON, PLUSTFAILURE, PLUSTPOS, PLUSTACCOMP, PLUSTHASWARRANTY, 
	STE_ALITEMALLOWED, STE_ALTITEMDESC, STE_ALTITEMNUM, STE_ALTITEMQUOTED, STE_WBSNO, ROWSTAMP, STE_CSWNCC,
	STE_COSC, STE_CSWNSAPGL, STE_MIGRATIONITEMPK, STE_MIGRATIONNSITEMPK, 
	20250404 AS STE_MIGRATIONID, ADD_HOURS(CURRENT_TIMESTAMP,8) AS STE_MIGRATIONDATE, -1 AS STE_MIGRATIONTS, 
	C.MAX_ID + ROW_NUMBER() OVER (ORDER BY A.RFQNUM, A.RFQLINENUM) AS RFQLINEID
FROM MAXIMO.RFQLINE A
JOIN (
	SELECT A.RFQNUM, B.REF_DEVIS_CD
		, ROW_NUMBER() OVER (PARTITION BY B.REF_DEVIS_CD ORDER BY A.RFQNUM) RN
	FROM MAXIMO.RFQVENDOR A
	JOIN MAXIMO.CSWN_RFQ B ON B.PK_DEVIS=A.STE_MIGRATIONID
	LEFT JOIN MAXIMO.RFQ C ON C.RFQNUM=B.REF_DEVIS_CD
	WHERE A.STE_MIGRATIONID IS NOT NULL
		AND C.RFQNUM IS NULL
	ORDER BY B.REF_DEVIS_CD, A.RFQNUM
) B ON B.RN=1 AND B.RFQNUM=A.RFQNUM 
JOIN (
	SELECT COALESCE(MAX(RFQLINEID),0) AS MAX_ID FROM MAXIMO.RFQLINE
) C ON 1=1
ORDER BY A.RFQNUM, A.RFQLINENUM;

-- UPDATE RFQVENDOR
MERGE INTO MAXIMO.RFQVENDOR A
USING (
	SELECT A.RFQVENDORID, A.RFQNUM AS ORIG_RFQNUM
		, B.DEVIS_CD, B.REF_DEVIS_CD, B.DV_PO_CD, B.DV_PREQ_REF, B.SUPL_CD
		, C.RFQNUM
	FROM MAXIMO.RFQVENDOR A
	JOIN MAXIMO.CSWN_RFQ B ON B.PK_DEVIS=A.STE_MIGRATIONID
	JOIN MAXIMO.RFQ C ON C.RFQNUM=B.REF_DEVIS_CD
	WHERE A.STE_MIGRATIONID IS NOT NULL
) B ON B.RFQVENDORID=A.RFQVENDORID
WHEN MATCHED THEN
UPDATE SET
	RFQNUM=B.RFQNUM,
	STE_CSWNDEVISCD=B.DEVIS_CD,
	STE_CSWNREFDEVISCD=B.RFQNUM,
	STE_CSWNPOREF=B.DV_PO_CD,
	STE_CSWNPRREF=B.DV_PREQ_REF
;

-- UPDATE QUOTATIONLINE
MERGE INTO MAXIMO.QUOTATIONLINE A
USING (
	SELECT A.QUOTATIONLINEID, A.RFQNUM AS ORIG_RFQNUM
		, B.DEVIS_CD, B.REF_DEVIS_CD, B.SUPL_CD, C.RFQNUM
	FROM MAXIMO.QUOTATIONLINE A
	JOIN maximo.rfqvendor D ON (A.RFQNUM=D.STE_CSWNDEVISCD OR A.RFQNUM=D.STE_CSWNREFDEVISCD) AND A.VENDOR=D.VENDOR
	JOIN MAXIMO.CSWN_RFQ B ON B.PK_DEVIS=D.STE_MIGRATIONID
	JOIN MAXIMO.RFQ C ON C.RFQNUM=B.REF_DEVIS_CD
	WHERE A.STE_MIGRATIONID IS NOT NULL
) B ON B.QUOTATIONLINEID=A.QUOTATIONLINEID
WHEN MATCHED THEN
UPDATE SET
	RFQNUM=B.RFQNUM,
	STE_CSWNDEVISCD=B.DEVIS_CD,
	STE_CSWNREFDEVISCD=B.RFQNUM
;

--SELECT DEVIS_CD, REF_DEVIS_CD FROM MAXIMO.CSWN_RFQ WHERE DEVIS_CD LIKE 'SY0007360300%'

-- REDIRECT LD (RFQ)
MERGE INTO MAXIMO.LONGDESCRIPTION A
USING (
	SELECT A.LONGDESCRIPTIONID, A.LDKEY AS ORIG_LDKEY, B.RFQID, B.RFQNUM
		, C.RFQVENDORID AS LDKEY, C.RFQNUM, C.STE_CSWNREFDEVISCD
	FROM MAXIMO.LONGDESCRIPTION A
	JOIN MAXIMO.RFQ B ON B.RFQID=A.LDKEY
	JOIN MAXIMO.RFQVENDOR C ON C.STE_MIGRATIONID=B.STE_MIGRATIONID
		--C.STE_MIGRATIONDEVISCD=B.RFQNUM
	WHERE A.STE_MIGRATIONID IS NOT NULL
		AND A.LDOWNERTABLE='RFQ' AND A.LDOWNERCOL='STE_REMARKS'
) B ON B.LONGDESCRIPTIONID=A.LONGDESCRIPTIONID
WHEN MATCHED THEN
UPDATE SET
	LDOWNERTABLE='RFQVENDOR',
	LDKEY=B.LDKEY
;

-- REDIRECT LD (RFQLINE)
MERGE INTO MAXIMO.LONGDESCRIPTION A
USING (
	SELECT A.LONGDESCRIPTIONID, A.LDKEY AS ORIG_LDKEY, B.RFQLINEID, B.RFQNUM, B.RFQLINENUM
		, C.QUOTATIONLINEID AS LDKEY, C.RFQNUM, C.STE_CSWNREFDEVISCD, C.RFQLINENUM
	FROM MAXIMO.LONGDESCRIPTION A
	JOIN MAXIMO.RFQLINE B ON B.RFQLINEID=A.LDKEY
	JOIN MAXIMO.QUOTATIONLINE C ON C.STE_MIGRATIONID=B.STE_MIGRATIONID
		--C.STE_MIGRATIONDEVISCD=B.RFQNUM AND C.RFQLINENUM=B.RFQLINENUM
	WHERE A.STE_MIGRATIONID IS NOT NULL
		AND A.LDOWNERTABLE='RFQLINE' AND A.LDOWNERCOL='DESCRIPTION'
) B ON B.LONGDESCRIPTIONID=A.LONGDESCRIPTIONID
WHEN MATCHED THEN
UPDATE SET
	LDOWNERTABLE='QUOTATIONLINE',
	LDKEY=B.LDKEY
;

-- UPDATE RFQVENDOR.HASLD
MERGE INTO MAXIMO.RFQVENDOR A
USING (
	SELECT B.RFQVENDORID
	FROM MAXIMO.LONGDESCRIPTION A
	JOIN MAXIMO.RFQVENDOR B ON B.RFQVENDORID=A.LDKEY
	WHERE A.STE_MIGRATIONID IS NOT NULL
		AND A.LDOWNERTABLE='RFQVENDOR' AND A.LDOWNERCOL='STE_REMARKS'
) B ON B.RFQVENDORID=A.RFQVENDORID
WHEN MATCHED THEN
UPDATE SET
	HASLD=1
;

-- UPDATE QUOTATIONLINE.HASLD
MERGE INTO MAXIMO.QUOTATIONLINE A
USING (
	SELECT B.QUOTATIONLINEID
	FROM MAXIMO.LONGDESCRIPTION A
	JOIN MAXIMO.QUOTATIONLINE B ON B.QUOTATIONLINEID=A.LDKEY
	WHERE A.STE_MIGRATIONID IS NOT NULL
		AND A.LDOWNERTABLE='QUOTATIONLINE' AND A.LDOWNERCOL='DESCRIPTION'
) B ON B.QUOTATIONLINEID=A.QUOTATIONLINEID
WHEN MATCHED THEN
UPDATE SET
	HASLD=1
;

-- MARK RFQ FOR DELETION (THOSE ALREADY IN RFQVENDOR)
MERGE INTO MAXIMO.RFQ A
USING (
	SELECT B.RFQID, B.RFQNUM
	FROM MAXIMO.RFQVENDOR A
	JOIN MAXIMO.RFQ B ON B.RFQNUM=A.STE_CSWNDEVISCD
	WHERE A.STE_CSWNDEVISCD!=STE_CSWNREFDEVISCD
		AND B.STE_MIGRATIONID IS NOT NULL
) B ON B.RFQID=A.RFQID
WHEN MATCHED THEN
UPDATE SET
	STE_MIGRATIONTS=-99
;

--SELECT * FROM MAXIMO.RFQ A WHERE STE_MIGRATIONTS!=-99;

-- MARK RFQLINE FOR DELETION
MERGE INTO MAXIMO.RFQLINE A
USING (
	SELECT A.RFQLINEID, A.RFQNUM, A.RFQLINENUM
	FROM MAXIMO.RFQLINE A
	JOIN MAXIMO.RFQ B ON B.RFQNUM=A.RFQNUM
	WHERE A.STE_MIGRATIONID IS NOT NULL
		AND B.STE_MIGRATIONTS=-99
) B ON B.RFQLINEID=A.RFQLINEID
WHEN MATCHED THEN
UPDATE SET
	STE_MIGRATIONTS=-99
;

-- DELETE
DELETE FROM MAXIMO.RFQLINE WHERE STE_MIGRATIONTS=-99;
DELETE FROM MAXIMO.RFQ WHERE STE_MIGRATIONTS=-99;

-- UPDATE RFQ-PO LINKAGE
MERGE INTO MAXIMO.RFQLINE A
USING (
	SELECT C.RFQNUM, C.RFQLINENUM, C.ITEMNUM, B.RFQLINEID
		, C.POREF, C.PONUM, C.POLINENUM, C.POLINEID, C.REVISIONNUM
	FROM (
		SELECT A.RFQNUM, A.RFQLINENUM, A.ITEMNUM, 1 AS ISAWARDED, B.STE_CSWNPOREF AS POREF
			, D.PONUM, D.POLINENUM, D.POLINEID, D.REVISIONNUM
			, ROW_NUMBER() OVER (PARTITION BY A.RFQNUM, A.ITEMNUM ORDER BY D.POLINEID, B.STE_MIGRATIONID DESC) RN
		FROM MAXIMO.QUOTATIONLINE A
		JOIN MAXIMO.RFQVENDOR B ON B.RFQNUM=A.RFQNUM AND B.VENDOR=A.VENDOR
		LEFT JOIN MAXIMO.POLINE D ON D.PONUM=B.STE_CSWNPOREF AND D.ITEMNUM=A.ITEMNUM
		WHERE A.ISAWARDED=1 
			AND B.STE_CSWNPOREF IS NOT NULL
	) C
	LEFT JOIN MAXIMO.RFQLINE B ON C.RFQNUM=B.RFQNUM AND C.ITEMNUM=B.ITEMNUM
	WHERE C.RN=1
		--AND C.PONUM IS NULL
		-- AND B.RFQLINEID IS NULL
	ORDER BY C.RFQNUM
) B ON B.RFQLINEID=A.RFQLINEID
WHEN MATCHED THEN
UPDATE SET
	PONUM=B.POREF,
	POREVISIONNUM=B.REVISIONNUM,
	POLINENUM=B.POLINENUM,
	POLINEID=B.POLINEID
;

-- UPDATE PR-RFQ LINKAGE
MERGE INTO MAXIMO.PRLINE A 
USING
(
	SELECT E.PRNUM, F.PRLINEID, F.PRLINENUM, F.ITEMNUM, A.RFQID, A.RFQNUM, B.DV_PREQ_REF, C.STE_CSWNDEVISCD, C.STE_CSWNPRREF
		, COALESCE(B.DV_PREQ_REF, C.STE_CSWNPRREF) AS PRREF
		, G.RFQLINENUM, G.RFQLINEID, G.ITEMNUM AS ITEMNUM2
		, ROW_NUMBER() OVER (PARTITION BY E.PRNUM, F.PRLINENUM 
			ORDER BY (CASE WHEN G.STE_MIGRATIONID IS NULL THEN 0 ELSE G.STE_MIGRATIONID END) DESC, 
					 (CASE WHEN C.STE_MIGRATIONID IS NULL THEN 0 ELSE C.STE_MIGRATIONID END) DESC, 
					  A.STE_MIGRATIONID DESC) RN
	FROM maximo.rfq A
	JOIN maximo.cswn_rfq B ON B.PK_DEVIS=A.STE_MIGRATIONID
	LEFT JOIN MAXIMO.RFQVENDOR C ON C.RFQNUM=A.RFQNUM AND C.STE_CSWNPRREF IS NOT NULL
	LEFT JOIN MAXIMO.CSWN_RFQ D ON D.PK_DEVIS=C.STE_MIGRATIONID
	JOIN MAXIMO.PR E ON E.PRNUM=COALESCE(B.DV_PREQ_REF, C.STE_CSWNPRREF)
	JOIN MAXIMO.PRLINE F ON F.PRNUM=E.PRNUM
	LEFT JOIN MAXIMO.RFQLINE G ON G.RFQNUM=A.RFQNUM AND G.ITEMNUM=F.ITEMNUM
	--WHERE E.PRNUM='AFC0004907' 
		--AND F.ITEMNUM='AF000000000000004535'
) B ON B.RN=1 AND B.PRLINEID=A.PRLINEID
WHEN MATCHED THEN
UPDATE SET
	RFQNUM=B.RFQNUM,
	RFQLINENUM=B.RFQLINENUM,
	RFQLINEID=B.RFQLINEID
;

--SELECT count(*) FROM maximo.rfq;		-- 44.939
--SELECT count(*) FROM maximo.rfqline;	-- 78.290

CALL MIGRATION.STE_FINISH_PATCH('20250403-04-RFQ-REMAPPING');
