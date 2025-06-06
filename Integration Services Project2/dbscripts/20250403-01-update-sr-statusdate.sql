--DROP TABLE "MIGRATION"."PATCH_20250403_SR_STATUSDATE" IF EXISTS;
CREATE TABLE "MIGRATION"."PATCH_20250403_SR_STATUSDATE"  (
		  "ID" BIGINT NOT NULL GENERATED BY DEFAULT AS IDENTITY (  
		    START WITH +1  
		    INCREMENT BY +1  
		    MINVALUE +1  
		    MAXVALUE +9223372036854775807  
		    NO CYCLE  
		    CACHE 20  
		    NO ORDER ) , 
		  "TICKETID" VARCHAR(10 OCTETS), 
		  "STATUSDATE" TIMESTAMP, 
		  "TICKETUID" BIGINT 
	)   
	IN "USERSPACE1"  
	ORGANIZE BY ROW;

INSERT INTO MIGRATION.PATCH_20250403_SR_STATUSDATE(TICKETID, STATUSDATE, TICKETUID)
SELECT TICKETID, STATUSDATE, TICKETUID FROM MAXIMO.TICKET WHERE STE_MIGRATIONID IS NOT NULL;

UPDATE MAXIMO.TICKET
SET
	STATUSDATE=COALESCE(ACTUALFINISH,ACTUALSTART)
WHERE STE_MIGRATIONID IS NOT NULL
;
