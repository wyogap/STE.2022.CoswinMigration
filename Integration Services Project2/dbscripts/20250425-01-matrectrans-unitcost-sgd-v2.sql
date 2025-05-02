CALL MIGRATION.STE_START_PATCH('20250425-01-MATRECTRANS-UNITCOST-SGD-V2');

-- update unitcost and linecost for SGD transaction
UPDATE maximo.MATRECTRANS m 
SET 
	m.unitcost=m.currencyunitcost,
	m.exchangerate=1,
	m.linecost=m.currencylinecost,
	m.exchangerate2=1,
	m.linecost2=m.currencylinecost
WHERE m.currencycode='SGD'
	AND m.currencyunitcost IS NOT null;

-- update unitcost and linecost for SGD transaction FROM invcost.lastcost
MERGE INTO MAXIMO.MATRECTRANS A
USING (
	SELECT m.matrectransid, m.itemnum, max(quantity) AS quantity, max(a.lastcost) AS lastcost
	FROM maximo.MATRECTRANS m 
	JOIN maximo.invcost a ON a.itemnum=m.itemnum
	WHERE m.currencycode='SGD'
		AND m.currencyunitcost IS NULL
	GROUP BY m.matrectransid, m.itemnum
) B ON B.MATRECTRANSID=A.MATRECTRANSID
WHEN MATCHED THEN
UPDATE SET
	UNITCOST=B.LASTCOST,
	LINECOST=B.LASTCOST * B.QUANTITY,
	EXCHANGERATE=1,
	LINECOST2=B.LASTCOST * B.QUANTITY,
	EXCHANGERATE2=1,
	CURRENCYUNITCOST=B.LASTCOST,
	CURRENCYLINECOST=B.LASTCOST * B.QUANTITY
;

CALL MIGRATION.STE_FINISH_PATCH('20250425-01-MATRECTRANS-UNITCOST-SGD-V2');
