CALL MIGRATION.STE_START_PATCH('20250408-03-MRLINE-MATUSETRANS-CURRENCYCODE');

UPDATE MAXIMO.MRLINE
SET
	CURRENCYCODE='SGD',
	EXCHANGERATE=1,
	UNITCOST=UNITCOST * EXCHANGERATE,
	LINECOST=LINECOST * EXCHANGERATE
WHERE STE_MIGRATIONID IS NOT NULL AND CURRENCYCODE!='SGD';

MERGE INTO MAXIMO.MATUSETRANS A
USING (
	SELECT A.MATUSETRANSID, A.CURRENCYCODE, A.ACTUALDATE, B.YEAR, B.MONTH, B.RATE
	FROM MAXIMO.MATUSETRANS A
	JOIN migration.sbst_exchange_rate B ON B.CURRENCY=A.CURRENCYCODE AND B.YEAR=YEAR(A.ACTUALDATE) AND B.MONTH=MONTH(A.ACTUALDATE)
	WHERE A.STE_MIGRATIONID IS NOT NULL
	  	AND A.CURRENCYCODE!='SGD' 
) B ON B.MATUSETRANSID=A.MATUSETRANSID
WHEN MATCHED THEN
UPDATE SET
 EXCHANGERATE=B.RATE
;

UPDATE MAXIMO.MATUSETRANS
SET
	CURRENCYCODE='SGD',
	EXCHANGERATE=1,
	UNITCOST=UNITCOST * EXCHANGERATE,
	LINECOST=LINECOST * EXCHANGERATE
WHERE STE_MIGRATIONID IS NOT NULL AND CURRENCYCODE!='SGD';

CALL MIGRATION.STE_FINISH_PATCH('20250408-03-MRLINE-MATUSETRANS-CURRENCYCODE');

