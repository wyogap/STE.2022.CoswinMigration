CALL MIGRATION.STE_START_PATCH('20250409-02-PR-RFQ-REFERENCE');

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

CALL MIGRATION.STE_FINISH_PATCH('20250409-02-PR-RFQ-REFERENCE');
