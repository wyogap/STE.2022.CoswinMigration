CALL MIGRATION.STE_START_PATCH('20250423-02-SR-OWNERGROUP');

-- CLEAR SR OWNERGROUP
UPDATE MAXIMO.TICKET
SET
	OWNERGROUP=NULL
WHERE STE_MIGRATIONID IS NOT NULL
;
	
CALL MIGRATION.STE_FINISH_PATCH('20250423-02-SR-OWNERGROUP');
