MERGE INTO MAXIMO.ASSET AS A
USING (
	SELECT assetid, assetuid, assetnum, ste_system, ste_subsystem, assettype
		, concat(ste_system,
			CONCAT('/',
			concat(COALESCE(ste_subsystem,''),
			CONCAT('/',
			concat(COALESCE(assettype,''),
			CONCAT('/', assetnum)
		  ))))) AS assetcode
	FROM MAXIMO.ASSET a 
	WHERE ste_system IS NOT null 
) B ON B.assetuid=A.assetuid
WHEN MATCHED THEN
UPDATE SET 
	ste_assetcode=B.assetcode
;