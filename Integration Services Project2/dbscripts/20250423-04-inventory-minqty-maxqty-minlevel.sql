CALL MIGRATION.STE_START_PATCH('20250423-04-INVENTORY-MINQTY-MAXQTY-MINLEVEL');

--DROP TABLE "MAXIMO"."CSWN_INVENTORY";
--CREATE TABLE "MAXIMO"."CSWN_INVENTORY"  (
--	PK_STORES_ITEMS BIGINT
--	, TIMESTAMP BIGINT
--	, IS_STOR_CD VARCHAR(10)
--	, ITEM_CD VARCHAR(20)
--	, ITEM_CC VARCHAR(16)
--	, ITEM_MEMO VARCHAR(100)
--	, ITEM_STRING2 VARCHAR(20)
--	, ORDER_UNITS VARCHAR(20)
--	, STOCK_UNITS VARCHAR(6)
--	, ABC_CLASS INTEGER
--	, ABCTYPE VARCHAR(2)
--	, CNT_FREQ INTEGER
--	, ORG_SUPL_CD VARCHAR(20)
--	, STKOUT_RISKP DECIMAL(18,6) 
--	, DT_FIRST_PROC DECIMAL(10,0)
--	, ITEM_NUMBER1 DECIMAL(18,6)
--	, PK_ITEM_INFO BIGINT
--	, MAX_QTY DECIMAL(18,6)
--	, MIN_QTY DECIMAL(18,6)
--	, VAL_METHOD INTEGER
--	, AVG_LEAD_TIME INTEGER
--	, MAX_LEAD_TIME INTEGER
--	, MIN_LEAD_TIME INTEGER
--	, Y_1_CON_QTY DECIMAL(18,6)
--	, Y_2_CON_QTY DECIMAL(18,6)
--	, I_FREE_QTY DECIMAL(18,6)
--	, I_RES_QTY DECIMAL(18,6)
--	, I_INSP_QTY DECIMAL(18,6)
--	, REORD_LEVEL DECIMAL(18,6)
--	, ECON_ORD_QTY DECIMAL(18,6)
--	, I_CYCLE INTEGER
--	, I_CYCLIC_REORDER INTEGER
--	, PK_ITEM_GROUP BIGINT
--	, GRP_CNT_FREQ INTEGER
--	, GRP_PR_AUTO INTEGER
--	, GRP_PO_AUTO INTEGER
--	, SUPL_CD VARCHAR(20)
--	, S_ITEM_REF VARCHAR(20)
--);

-- BRING MAXIMO.CSWN_INVENTORY FROM ON-PREM

-- Restore INVENTORY STE_MAXQTY, STE_MINQTY, MINLEVEL
MERGE INTO MAXIMO.INVENTORY A
USING (
	SELECT A.INVENTORYID , B.MIN_QTY, B.MAX_QTY, B.REORD_LEVEL
	FROM MAXIMO.INVENTORY A
	JOIN MAXIMO.CSWN_INVENTORY B ON B.PK_STORES_ITEMS=A.STE_MIGRATIONID
) B ON B.INVENTORYID=A.INVENTORYID
WHEN MATCHED THEN
UPDATE SET
	STE_MINQTY=B.MIN_QTY,
	STE_MAXQTY=B.MAX_QTY,
	MINLEVEL=B.REORD_LEVEL
;

CALL MIGRATION.STE_FINISH_PATCH('20250423-04-INVENTORY-MINQTY-MAXQTY-MINLEVEL');
