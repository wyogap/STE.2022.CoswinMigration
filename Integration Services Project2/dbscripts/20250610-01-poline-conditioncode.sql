CALL MIGRATION.STE_START_PATCH('20250610-01-POLINE-CONDITIONCODE');

-- BACKUP
-- DROP TABLE "MIGRATION"."BAK_20250610_POLINE";
CREATE TABLE "MIGRATION"."BAK_20250610_POLINE"(
	POLINEID BIGINT,
	PONUM VARCHAR(10),
	POLINENUM INT,
	ITEMNUM VARCHAR(30),
	CONDITIONCODE VARCHAR(30),
	NEW_CONDITIONCODE VARCHAR(30)
);

INSERT INTO "MIGRATION"."BAK_20250610_POLINE" (
	POLINEID, PONUM, POLINENUM, ITEMNUM, CONDITIONCODE, NEW_CONDITIONCODE
)
SELECT l.polineid, l.ponum, l.polinenum, l.itemnum, l.conditioncode, c.conditioncode AS new_conditioncode 
FROM maximo.poline l
JOIN maximo.po po ON po.ponum=l.ponum
JOIN maximo.item i ON i.itemnum=l.itemnum -- AND i.conditionenabled=1 AND i.itemsetid=l.itemsetid
JOIN maximo.itemcondition c ON c.itemnum=l.itemnum -- AND c.itemsetid=l.itemsetid
WHERE 1=1
	AND ( po.status  =  'ACKNOWLEDGED'  or po.status  =  'INPRG'  or po.status  =  'APPR'  ) 
	AND ( upper( po.receipts )  =  'NONE'  or upper( po.receipts )  =  'PARTIAL'  ) 
	AND po.siteid  =  'NEL'
	AND COALESCE(l.conditioncode,'')!=COALESCE(c.conditioncode,'')
;

MERGE INTO MAXIMO.POLINE A
USING (
	SELECT l.polineid, l.ponum, l.polinenum, l.itemnum, l.conditioncode, c.conditioncode AS new_conditioncode 
	FROM maximo.poline l
	JOIN maximo.po po ON po.ponum=l.ponum
	JOIN maximo.item i ON i.itemnum=l.itemnum -- AND i.conditionenabled=1 AND i.itemsetid=l.itemsetid
	JOIN maximo.itemcondition c ON c.itemnum=l.itemnum -- AND c.itemsetid=l.itemsetid
	WHERE 1=1
		AND ( po.status  =  'ACKNOWLEDGED'  or po.status  =  'INPRG'  or po.status  =  'APPR'  ) 
		AND ( upper( po.receipts )  =  'NONE'  or upper( po.receipts )  =  'PARTIAL'  ) 
		AND po.siteid  =  'NEL'
		AND COALESCE(l.conditioncode,'')!=COALESCE(c.conditioncode,'')
) B ON B.POLINEID=A.POLINEID
WHEN MATCHED THEN
UPDATE SET
	CONDITIONCODE=B.NEW_CONDITIONCODE
;

CALL MIGRATION.STE_FINISH_PATCH('20250610-01-POLINE-CONDITIONCODE');