delete from maximo.ste_migration_user_lookup where persistent=0;

insert into maximo.ste_migration_user_lookup (display_name, personid, persistent, status, STE_MIGRATIONID)
select UPPER(a.personid) as display_name, a.personid as personid, 0 as persistent
	, 1 as status, 0 as id
from maximo.person a
left join maximo.ste_migration_user_lookup b on b.display_name=UPPER(a.personid)
where b.display_name is null and a.status = 'ACTIVE'
	and a.displayname not like '%(RESIGNED%'
	and a.displayname not like '%(CONTRACT END%'
	AND a.displayname not like '%(DO NOT USE%'
	AND a.displayname not like '%(POSTED OUT%'
	AND a.displayname not like '%(WRONG%'
	;
	
insert into maximo.ste_migration_user_lookup (display_name, personid, persistent, status, STE_MIGRATIONID)
select UPPER(a.personid) as display_name, a.personid as personid, 0 as persistent
	, 0 as status, a.ste_migrationid as id
from maximo.person a
left join maximo.ste_migration_user_lookup b on b.display_name=UPPER(a.personid)
where b.display_name is null and 
	(a.status = 'INACTIVE'
		or a.displayname like '%(RESIGNED%'
		or a.displayname like '%(CONTRACT END%'
		or a.displayname like '%(DO NOT USE%'
		or a.displayname like '%(POSTED OUT%'
		or a.displayname like '%(WRONG%'
	)
	;
	
insert into maximo.ste_migration_user_lookup (display_name, personid, persistent, status, STE_MIGRATIONID)
select UPPER(a.STE_MIGRATIONEMNO) as display_name, a.personid as personid, 0 as persistent
	, 1 as status, a.ste_migrationid as id
from maximo.person a
left join maximo.ste_migration_user_lookup b on b.display_name=UPPER(a.STE_MIGRATIONEMNO)
where b.display_name is null and a.STE_MIGRATIONEMNO is not null
	and a.status = 'ACTIVE'
	and a.displayname not like '%(RESIGNED%'
	and a.displayname not like '%(CONTRACT END%'
	AND a.displayname not like '%(DO NOT USE%'
	AND a.displayname not like '%(POSTED OUT%'
	AND a.displayname not like '%(WRONG%'
	;
	
insert into maximo.ste_migration_user_lookup (display_name, personid, persistent, status, STE_MIGRATIONID)
select UPPER(a.STE_MIGRATIONEMNO) as display_name, a.personid as personid, 0 as persistent
	, 0 as status, a.ste_migrationid as id
from maximo.person a
left join maximo.ste_migration_user_lookup b on b.display_name=UPPER(a.STE_MIGRATIONEMNO)
where b.display_name is null and a.STE_MIGRATIONEMNO is not null 
	and (a.status = 'INACTIVE'
		or a.displayname like '%(RESIGNED%'
		or a.displayname like '%(CONTRACT END%'
		or a.displayname like '%(DO NOT USE%'
		or a.displayname like '%(POSTED OUT%'
		or a.displayname like '%(WRONG%'
	)
	;
	
insert into maximo.ste_migration_user_lookup (display_name, personid, persistent, status, STE_MIGRATIONID)
SELECT display_name, personid, persistent, status, STE_MIGRATIONID
FROM (
	select UPPER(a.displayname) as display_name, a.personid as personid, 0 as persistent
		, 1 as status, 0 as STE_MIGRATIONID
		, ROW_NUMBER() OVER (PARTITION BY UPPER(a.displayname) ORDER BY a.personid) AS RN
	from maximo.person a
	left join maximo.ste_migration_user_lookup b on b.display_name=UPPER(a.displayname)
	where b.display_name is null and a.status = 'ACTIVE'
		and a.displayname not like '%(RESIGNED%'
		and a.displayname not like '%(CONTRACT END%'
		AND a.displayname not like '%(DO NOT USE%'
		AND a.displayname not like '%(POSTED OUT%'
		AND a.displayname not like '%(WRONG%'
) A
WHERE A.RN=1
;
	
insert into maximo.ste_migration_user_lookup (display_name, personid, persistent, status, STE_MIGRATIONID)
SELECT display_name, personid, persistent, status, STE_MIGRATIONID
FROM (
	select UPPER(a.displayname) as display_name, a.personid as personid, 0 as persistent
		, 0 as status, 0 as STE_MIGRATIONID
		, ROW_NUMBER() OVER (PARTITION BY UPPER(a.displayname) ORDER BY a.personid) AS RN
	from maximo.person a
	left join maximo.ste_migration_user_lookup b on b.display_name=UPPER(a.displayname)
	where b.display_name is null and a.status = 'INACTIVE'
		and a.displayname not like '%(RESIGNED%'
		and a.displayname not like '%(CONTRACT END%'
		AND a.displayname not like '%(DO NOT USE%'
		AND a.displayname not like '%(POSTED OUT%'
		AND a.displayname not like '%(WRONG%'
) A
WHERE A.RN=1
;
	
insert into maximo.ste_migration_user_lookup (display_name, personid, persistent, status, STE_MIGRATIONID)
SELECT a.display_name, a.personid, a.persistent, a.status, a.STE_MIGRATIONID
FROM 
(
	select UPPER(TRIM(SUBSTRING(a.displayname, 0, LOCATE('(RESIGNED', a.displayname)))) as display_name, a.personid as personid
		, 0 as persistent, 0 as status, 0 as STE_MIGRATIONID
		, ROW_NUMBER() OVER (PARTITION BY UPPER(TRIM(SUBSTRING(a.displayname, 0, LOCATE('(RESIGNED', a.displayname)))) ORDER BY a.personid) AS RN
	from maximo.person a
	WHERE a.displayname like '%(RESIGNED%'
) a
left join maximo.ste_migration_user_lookup b on b.display_name=a.display_name
where b.display_name is NULL AND TRIM(a.display_name)!='' AND a.RN=1;

insert into maximo.ste_migration_user_lookup (display_name, personid, persistent, status, STE_MIGRATIONID)
SELECT a.display_name, a.personid, a.persistent, a.status, a.STE_MIGRATIONID
FROM 
(
	select UPPER(TRIM(SUBSTRING(a.displayname, 0, LOCATE('(CONTRACT END', a.displayname)))) as display_name, a.personid as personid
		, 0 as persistent, 0 as status, 0 as STE_MIGRATIONID
		, ROW_NUMBER() OVER (PARTITION BY UPPER(TRIM(SUBSTRING(a.displayname, 0, LOCATE('(CONTRACT END', a.displayname)))) ORDER BY a.personid) AS RN
	from maximo.person a
	WHERE a.displayname like '%(CONTRACT END%'
) a
left join maximo.ste_migration_user_lookup b on b.display_name=a.display_name
where b.display_name is NULL AND TRIM(a.display_name)!='' AND a.RN=1;

insert into maximo.ste_migration_user_lookup (display_name, personid, persistent, status, STE_MIGRATIONID)
SELECT a.display_name, a.personid, a.persistent, a.status, a.STE_MIGRATIONID
FROM 
(
	select UPPER(TRIM(SUBSTRING(a.displayname, 0, LOCATE('(DO NOT USE', a.displayname)))) as display_name, a.personid as personid
		, 0 as persistent, 0 as status, 0 as STE_MIGRATIONID
		, ROW_NUMBER() OVER (PARTITION BY UPPER(TRIM(SUBSTRING(a.displayname, 0, LOCATE('(DO NOT USE', a.displayname)))) ORDER BY a.personid) AS RN
	from maximo.person a
	WHERE a.displayname like '%(DO NOT USE%'
) a
left join maximo.ste_migration_user_lookup b on b.display_name=a.display_name
where b.display_name is NULL AND TRIM(a.display_name)!='' AND a.RN=1;

insert into maximo.ste_migration_user_lookup (display_name, personid, persistent, status, STE_MIGRATIONID)
SELECT a.display_name, a.personid, a.persistent, a.status, a.STE_MIGRATIONID
FROM 
(
	select UPPER(TRIM(SUBSTRING(a.displayname, 0, LOCATE('(POSTED OUT', a.displayname)))) as display_name, a.personid as personid
		, 0 as persistent, 0 as status, 0 as STE_MIGRATIONID
		, ROW_NUMBER() OVER (PARTITION BY UPPER(TRIM(SUBSTRING(a.displayname, 0, LOCATE('(POSTED OUT', a.displayname)))) ORDER BY a.personid) AS RN
	from maximo.person a
	WHERE a.displayname like '%(POSTED OUT%'
) a
left join maximo.ste_migration_user_lookup b on b.display_name=a.display_name
where b.display_name is NULL AND TRIM(a.display_name)!='' AND a.RN=1;

insert into maximo.ste_migration_user_lookup (display_name, personid, persistent, status, STE_MIGRATIONID)
SELECT a.display_name, a.personid, a.persistent, a.status, a.STE_MIGRATIONID
FROM 
(
	select UPPER(TRIM(SUBSTRING(a.displayname, 0, LOCATE('(WRONG', a.displayname)))) as display_name, a.personid as personid
		, 0 as persistent, 0 as status, 0 as STE_MIGRATIONID
		, ROW_NUMBER() OVER (PARTITION BY UPPER(TRIM(SUBSTRING(a.displayname, 0, LOCATE('(WRONG', a.displayname)))) ORDER BY a.personid) AS RN
	from maximo.person a
	WHERE a.displayname like '%(WRONG%'
) a
left join maximo.ste_migration_user_lookup b on b.display_name=a.display_name
where b.display_name is NULL AND TRIM(a.display_name)!='' AND a.RN=1;

