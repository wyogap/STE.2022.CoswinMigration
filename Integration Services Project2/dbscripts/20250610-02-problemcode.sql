CALL MIGRATION.STE_START_PATCH('20250610-02-PROBLEMCODE');

-- BACKUP
-- DROP TABLE "MIGRATION"."PATCH_20250610_PROBLEMCODE";
--CREATE TABLE "MIGRATION"."PATCH_20250610_PROBLEMCODE"(
--	FAILURECLASS VARCHAR(30),
--	DESCRIPTION VARCHAR(150),
--	PROBLEMCODE VARCHAR(30),
--	PROBLEM_DESCRIPTION VARCHAR(150),
--	CAUSECODE VARCHAR(30),
--	CAUSE_DESCRIPTION VARCHAR(150),
--	REMEDYCODE VARCHAR(30),
--	REMEDY_DESCRIPTION VARCHAR(150),
--	SEVERITY_CLASSIFICATION VARCHAR(3),
--	SOURCEFILE VARCHAR(30)
--);

-- BRING "MIGRATION".PATCH_20250610_PROBLEMCODE TABLE MANUALLY FROM ON-PREM

-- create failure code definition
INSERT INTO MAXIMO.FAILURECODE
(
	FAILURECODE, DESCRIPTION, ORGID, FAILURECODEID, LANGCODE, HASLD, STE_MIGRATIONDATE, STE_MIGRATIONID
)
SELECT 
	A.FAILURECLASS AS FAILURECODE, A.DESCRIPTION
	, 'SBST' AS ORGID
	, B.MAX_ID + ROW_NUMBER() OVER (ORDER BY FAILURECLASS DESC) AS FAILURECODEID
	, 'EN' AS LANGCODE, 0 AS HASLD
	, CURRENT_TIMESTAMP AS STE_MIGRATIONDATE, 20250610 AS STE_MIGRATIONID
FROM (
	SELECT DISTINCT FAILURECLASS, DESCRIPTION FROM "MIGRATION"."PATCH_20250610_PROBLEMCODE"
) A
JOIN (
	SELECT COALESCE(MAX(FAILURECODEID),0) AS MAX_ID FROM MAXIMO.FAILURECODE
) B ON 1=1
LEFT JOIN MAXIMO.FAILURECODE X ON X.FAILURECODE=A.FAILURECLASS
WHERE X.FAILURECODEID IS NULL
;

INSERT INTO MAXIMO.FAILURECODE
(
	FAILURECODE, DESCRIPTION, ORGID, FAILURECODEID, LANGCODE, HASLD, STE_MIGRATIONDATE, STE_MIGRATIONID
)
SELECT 
	A.PROBLEMCODE AS FAILURECODE, A.PROBLEM_DESCRIPTION AS DESCRIPTION
	, 'SBST' AS ORGID
	, B.MAX_ID + ROW_NUMBER() OVER (ORDER BY PROBLEMCODE DESC) AS FAILURECODEID
	, 'EN' AS LANGCODE, 0 AS HASLD
	, CURRENT_TIMESTAMP AS STE_MIGRATIONDATE, 20250610 AS STE_MIGRATIONID
FROM (
	SELECT DISTINCT PROBLEMCODE, PROBLEM_DESCRIPTION FROM "MIGRATION"."PATCH_20250610_PROBLEMCODE"
) A
JOIN (
	SELECT COALESCE(MAX(FAILURECODEID),0) AS MAX_ID FROM MAXIMO.FAILURECODE
) B ON 1=1
LEFT JOIN MAXIMO.FAILURECODE X ON X.FAILURECODE=A.PROBLEMCODE
WHERE X.FAILURECODEID IS NULL
;

INSERT INTO MAXIMO.FAILURECODE
(
	FAILURECODE, DESCRIPTION, ORGID, FAILURECODEID, LANGCODE, HASLD, STE_MIGRATIONDATE, STE_MIGRATIONID
)
SELECT 
	A.CAUSECODE AS FAILURECODE, A.CAUSE_DESCRIPTION AS DESCRIPTION
	, 'SBST' AS ORGID
	, B.MAX_ID + ROW_NUMBER() OVER (ORDER BY CAUSECODE DESC) AS FAILURECODEID
	, 'EN' AS LANGCODE, 0 AS HASLD
	, CURRENT_TIMESTAMP AS STE_MIGRATIONDATE, 20250610 AS STE_MIGRATIONID
FROM (
	SELECT DISTINCT CAUSECODE, CAUSE_DESCRIPTION FROM "MIGRATION"."PATCH_20250610_PROBLEMCODE"
) A
JOIN (
	SELECT COALESCE(MAX(FAILURECODEID),0) AS MAX_ID FROM MAXIMO.FAILURECODE
) B ON 1=1
LEFT JOIN MAXIMO.FAILURECODE X ON X.FAILURECODE=A.CAUSECODE
WHERE X.FAILURECODEID IS NULL
;

INSERT INTO MAXIMO.FAILURECODE
(
	FAILURECODE, DESCRIPTION, ORGID, FAILURECODEID, LANGCODE, HASLD, STE_MIGRATIONDATE, STE_MIGRATIONID
)
SELECT 
	A.REMEDYCODE AS FAILURECODE, A.REMEDY_DESCRIPTION AS DESCRIPTION
	, 'SBST' AS ORGID
	, B.MAX_ID + ROW_NUMBER() OVER (ORDER BY REMEDYCODE DESC) AS FAILURECODEID
	, 'EN' AS LANGCODE, 0 AS HASLD
	, CURRENT_TIMESTAMP AS STE_MIGRATIONDATE, 20250610 AS STE_MIGRATIONID
FROM (
	SELECT DISTINCT REMEDYCODE, REMEDY_DESCRIPTION FROM "MIGRATION"."PATCH_20250610_PROBLEMCODE"
) A
JOIN (
	SELECT COALESCE(MAX(FAILURECODEID),0) AS MAX_ID FROM MAXIMO.FAILURECODE
) B ON 1=1
LEFT JOIN MAXIMO.FAILURECODE X ON X.FAILURECODE=A.REMEDYCODE
WHERE X.FAILURECODEID IS NULL
;

-- create failurelist hierarchy
INSERT INTO MAXIMO.FAILURELIST
(
	FAILURELIST, FAILURECODE, PARENT, "TYPE", ORGID, STE_MIGRATIONTYPE, STE_MIGRATIONDATE, STE_MIGRATIONID
)
SELECT 
	B.MAX_ID + ROW_NUMBER() OVER (ORDER BY A.FAILURECLASS DESC) AS FAILURELIST
	, A.FAILURECLASS AS FAILURECODE, NULL AS PARENT, NULL AS "TYPE"
	, 'SBST' AS ORGID
	, 'PATCH' AS STE_MIGRATIONTYPE
	, CURRENT_TIMESTAMP AS STE_MIGRATIONDATE, 20250610 AS STE_MIGRATIONID
FROM (
	SELECT DISTINCT FAILURECLASS FROM "MIGRATION"."PATCH_20250610_PROBLEMCODE"
) A
JOIN (
	SELECT COALESCE(MAX(FAILURELIST),0) AS MAX_ID FROM MAXIMO.FAILURELIST
) B ON 1=1
LEFT JOIN MAXIMO.FAILURELIST X ON X.FAILURECODE=A.FAILURECLASS
WHERE X.FAILURELIST IS NULL
;

INSERT INTO MAXIMO.FAILURELIST
(
	FAILURELIST, FAILURECODE, PARENT, "TYPE", ORGID, STE_MIGRATIONTYPE, STE_MIGRATIONDATE, STE_MIGRATIONID
)
SELECT 
	B.MAX_ID + ROW_NUMBER() OVER (ORDER BY A.FAILURECLASS, A.PROBLEMCODE DESC) AS FAILURELIST
	, A.PROBLEMCODE AS FAILURECODE, C.FAILURELIST AS PARENT, 'PROBLEM' AS "TYPE"
	, 'SBST' AS ORGID
	, 'PATCH' AS STE_MIGRATIONTYPE
	, CURRENT_TIMESTAMP AS STE_MIGRATIONDATE, 20250610 AS STE_MIGRATIONID
	--, X.FAILURECODE, X.PARENT
FROM (
	SELECT DISTINCT FAILURECLASS, PROBLEMCODE FROM "MIGRATION"."PATCH_20250610_PROBLEMCODE"
) A
JOIN (
	SELECT COALESCE(MAX(FAILURELIST),0) AS MAX_ID FROM MAXIMO.FAILURELIST
) B ON 1=1
JOIN MAXIMO.FAILURELIST C ON C.FAILURECODE=A.FAILURECLASS
LEFT JOIN MAXIMO.FAILURELIST X ON X.FAILURECODE=A.PROBLEMCODE AND X.PARENT=C.FAILURELIST
WHERE X.FAILURELIST IS NULL
;

INSERT INTO MAXIMO.FAILURELIST
(
	FAILURELIST, FAILURECODE, PARENT, "TYPE", ORGID, STE_MIGRATIONTYPE, STE_MIGRATIONDATE, STE_MIGRATIONID
)
SELECT 
	B.MAX_ID + ROW_NUMBER() OVER (ORDER BY A.FAILURECLASS, A.PROBLEMCODE, A.CAUSECODE DESC) AS FAILURELIST
	, A.CAUSECODE AS FAILURECODE, D.FAILURELIST AS PARENT, 'CAUSE' AS "TYPE"
	, 'SBST' AS ORGID
	, 'PATCH' AS STE_MIGRATIONTYPE
	, CURRENT_TIMESTAMP AS STE_MIGRATIONDATE, 20250610 AS STE_MIGRATIONID
FROM (
	SELECT DISTINCT FAILURECLASS, PROBLEMCODE, CAUSECODE FROM "MIGRATION"."PATCH_20250610_PROBLEMCODE"
) A
JOIN (
	SELECT COALESCE(MAX(FAILURELIST),0) AS MAX_ID FROM MAXIMO.FAILURELIST
) B ON 1=1
JOIN MAXIMO.FAILURELIST C ON C.FAILURECODE=A.FAILURECLASS
JOIN MAXIMO.FAILURELIST D ON D.FAILURECODE=A.PROBLEMCODE AND D.PARENT=C.FAILURELIST
LEFT JOIN MAXIMO.FAILURELIST X ON X.FAILURECODE=A.CAUSECODE AND X.PARENT=D.FAILURELIST
WHERE X.FAILURELIST IS NULL
;

INSERT INTO MAXIMO.FAILURELIST
(
	FAILURELIST, FAILURECODE, PARENT, "TYPE", ORGID, STE_MIGRATIONTYPE, STE_MIGRATIONDATE, STE_MIGRATIONID
)
SELECT 
	B.MAX_ID + ROW_NUMBER() OVER (ORDER BY A.FAILURECLASS, A.PROBLEMCODE, A.CAUSECODE, A.REMEDYCODE DESC) AS FAILURELIST
	, A.REMEDYCODE AS FAILURECODE, E.FAILURELIST AS PARENT, 'REMEDY' AS "TYPE"
	, 'SBST' AS ORGID
	, 'PATCH' AS STE_MIGRATIONTYPE
	, CURRENT_TIMESTAMP AS STE_MIGRATIONDATE, 20250610 AS STE_MIGRATIONID
FROM (
	SELECT DISTINCT FAILURECLASS, PROBLEMCODE, CAUSECODE, REMEDYCODE FROM "MIGRATION"."PATCH_20250610_PROBLEMCODE"
) A
JOIN (
	SELECT COALESCE(MAX(FAILURELIST),0) AS MAX_ID FROM MAXIMO.FAILURELIST
) B ON 1=1
JOIN MAXIMO.FAILURELIST C ON C.FAILURECODE=A.FAILURECLASS
JOIN MAXIMO.FAILURELIST D ON D.FAILURECODE=A.PROBLEMCODE AND D.PARENT=C.FAILURELIST
JOIN MAXIMO.FAILURELIST E ON E.FAILURECODE=A.CAUSECODE AND E.PARENT=D.FAILURELIST
LEFT JOIN MAXIMO.FAILURELIST X ON X.FAILURECODE=A.REMEDYCODE AND X.PARENT=E.FAILURELIST
WHERE X.FAILURELIST IS NULL
;

CALL MIGRATION.STE_FINISH_PATCH('20250610-02-PROBLEMCODE');