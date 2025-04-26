CALL MIGRATION.STE_START_PATCH('20250423-01-MATRECTRANS-WINSP-UNITCOST-FX');

-- bring migration.sbst_exchange_rate from on-prem

-- update exchange rate
MERGE INTO maximo.matrectrans A
USING (
	SELECT m.matrectransid, m.transdate, m.status, m.transdate, m.currencycode, r.currency, r.rate
		, m.currencyunitcost, m.currencylinecost
	FROM MAXIMO.MATRECTRANS m
	JOIN migration.sbst_exchange_rate r ON r.currency=m.currencycode AND cast(m.transdate AS date)=cast(r.date AS date)
	WHERE (m.exchangerate=0 OR m.exchangerate=1) AND m.currencycode!='SGD'
		--AND m.status IN ('WINSP','WASSET')
		AND m.currencyunitcost IS NOT NULL
	ORDER BY m.currencycode, m.transdate
) B ON B.matrectransid=A.matrectransid
WHEN MATCHED THEN
UPDATE SET
	exchangerate=B.RATE,
	unitcost=B.currencyunitcost * B.RATE,
	linecost=B.currencylinecost * B.RATE,
	exchangerate2=B.RATE,
	linecost2=B.currencylinecost * B.RATE
;

CALL MIGRATION.STE_FINISH_PATCH('20250423-01-MATRECTRANS-WINSP-UNITCOST-FX');
