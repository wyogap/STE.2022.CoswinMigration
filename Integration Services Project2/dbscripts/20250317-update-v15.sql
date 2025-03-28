update maximo.alndomain m 
SET orgid=NULL, siteid=null
WHERE domainid IN ('SKILLLEVEL', 'STE_CSWNEQPFUNCTN', 'STE_ITEMCAT',
	'STE_ITEMGROUP', 'STE_STATION', 'STE_TUNNEL', 'STE_VIADUCT');

UPDATE MAXIMO.WORKTYPE
SET 
	TYPE='NONE'
WHERE coalesce(TYPE,'')='';

UPDATE maximo.asset 
SET
 STE_CDTYPE='CD'
WHERE UPPER(TRIM(DESCRIPTION)) LIKE '%(CD)';

UPDATE MAXIMO.LABTRANS
SET 
	REFWO=CONCAT(LEFT('WO00000000',10 - LENGTH(CAST(STE_MIGRATIONWOREF AS varchar(8)))), CAST(STE_MIGRATIONWOREF AS varchar(8)))
WHERE 
	STE_MIGRATIONID IS NOT NULL;