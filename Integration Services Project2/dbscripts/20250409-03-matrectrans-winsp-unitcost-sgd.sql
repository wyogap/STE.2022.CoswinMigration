CALL MIGRATION.STE_START_PATCH('20250409-03-MATRECTRANS-WINSP-UNITCOST-SGD');

-- update holding location
UPDATE maximo.MATRECTRANS m 
SET m.tostoreloc = (SELECT location FROM maximo.locations l WHERE l.TYPE = 'HOLDING' FETCH FIRST 1 ROWS ONLY)
WHERE m.status IN ('WINSP','WASSET')
;

-- update unitcost and linecost for SGD transaction
UPDATE maximo.MATRECTRANS m 
SET 
	m.unitcost=m.currencyunitcost,
	m.exchangerate=1,
	m.linecost=m.currencylinecost,
	m.exchangerate2=1,
	m.linecost2=m.currencylinecost
WHERE m.status IN ('WINSP','WASSET') AND m.currencycode='SGD'
	AND m.currencyunitcost IS NOT null;

-- update unitcost and linecost for SGD transaction FROM invcost.lastcost
MERGE INTO MAXIMO.MATRECTRANS A
USING (
	SELECT m.matrectransid, m.itemnum, max(quantity) AS quantity, max(a.lastcost) AS lastcost
	FROM maximo.MATRECTRANS m 
	JOIN maximo.invcost a ON a.itemnum=m.itemnum
	WHERE m.status IN ('WINSP','WASSET') AND m.currencycode='SGD'
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

ALL MIGRATION.STE_FINISH_PATCH('20250409-03-MATRECTRANS-WINSP-UNITCOST-SGD');
