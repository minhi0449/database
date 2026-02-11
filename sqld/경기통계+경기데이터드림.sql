	SELECT
    A.DTFILE_ID AS "dtfileId",
    F.DTTRAN_ID AS "dttranId",
    E.UPL_SCH_NO AS "uplSchNo",
    D.DT_NM AS "dtNm",
    D.INF_NM AS "infNm",
    A.SHT_NM AS "shtNm",
    D.LOAD_CD AS "loadCd",
    
    (
        SELECT ORG_NM
        FROM TB_COMM_ORG
        WHERE ORG_CD = E.ORG_CD
            AND USE_YN = 'Y'
    ) AS "orgNm",
    
    (
        SELECT USR_NM
        FROM TB_COMM_USR
        WHERE USR_ID = F.REG_ID
    ) AS "usrNm",
    
    (
        SELECT USR_CD
        FROM TB_COMM_USR
        WHERE USR_ID = F.REG_ID
    ) AS "usrCd",
    
    (
        SELECT USR_TEL
        FROM TB_COMM_USR
        WHERE USR_ID = F.REG_ID
    ) AS "usrTel",
    
    (
        SELECT USR_EMAIL
        FROM TB_COMM_USR
        WHERE USR_ID = F.REG_ID
    ) AS "usrEmail",
    TO_CHAR(F.END_DTTM, 'YYYY-MM-DD HH24:MI:SS') AS "chkDttm",
    TO_CHAR(COALESCE(
    TO_CHAR(ROUND((F.END_DTTM - F.STRT_DTTM) * 24 * 60 * 60)), 
    '0'
)) AS "chkTm",
    COALESCE(F.CHCK_YN, 'N') AS "chckYn",
    CASE 
        WHEN F.CHCK_YN = 'N' THEN 
            CASE 
                WHEN F.ERR_CNT = 0 THEN F.PROC_RSLT 
                ELSE F.ERR_CNT::text || ' 건의 오류가 발생하였습니다.' 
            END
        ELSE F.PROC_RSLT 
    END AS "procRslt",
    CASE 
        WHEN F.PROC_STAT = 'T' THEN '예'
        WHEN F.PROC_STAT = 'I' THEN '예(이어서저장하기)'
        WHEN F.PROC_STAT = 'P' THEN '예'
        WHEN F.PROC_STAT = 'U' THEN '예'
        WHEN F.PROC_STAT = 'D' THEN '예'
        WHEN F.PROC_STAT = 'M' THEN '예'
        ELSE '아니오'
    END AS "saveYn",
    F.DATA_COND_DTTM AS "dataCondDttm",
    F.LOAD_YMD AS "loadYmd"
FROM TB_OPEN_DTFILE A
INNER JOIN (
    SELECT
        B.INF_ID,
        B.INF_NM,
        C.DT_NM,
        B.LOAD_CD,
        B.MULTI_MNG_YN
    FROM TB_OPEN_INF B
    INNER JOIN TB_OPEN_DT C ON B.DT_ID = C.DT_ID
) D ON A.INF_ID = D.INF_ID AND A.DEL_YN = 'N'
INNER JOIN (
    SELECT
        LOAD_YMD,
        DTFILE_ID,
        UPL_SCH_NO,
        ORG_CD
    FROM TB_UPLOAD_SCHE
    WHERE DEL_YN = 'N'
) E ON A.DTFILE_ID = E.DTFILE_ID
INNER JOIN TB_OPEN_DTTRAN F 
    ON E.UPL_SCH_NO = F.UPL_SCH_NO
    AND F.DEL_YN = 'N'
    AND F.PROC_STAT IN ('I', 'C', 'E', 'P', 'U', 'D', 'M', 'T', 'I')
WHERE 1 = 1
ORDER BY F.DTTRAN_ID DESC;






-- 주소정제
SELECT
    B.INF_NM AS "refOpnDtNm",
    ( SELECT H.DITC_NM
      FROM TB_COMM_CODE H
      WHERE H.GRP_CD = 'C1001'
      AND H.DITC_CD = A.SIGUN_CD) AS "refOrg",
    ( SELECT H.DITC_NM
      FROM TB_COMM_CODE H
      WHERE H.GRP_CD = 'D1009'
      AND H.DITC_CD = B.LOAD_CD) AS "refLoadCd",
    A.TOT_CNT AS "refDealCnt",
    A.REFINE_VAL_CNT AS "refsucc",
    A.REFINE_ERR_CNT AS "refFail",
    A.REFINE_PER AS "refPerc",
    A.COORD_PER AS "refCrdPerc",
    A.DS_ID AS "refOpnDtId",
    TO_CHAR(A.REFINE_DTTM, 'YYYY-MM-DD HH24:MI:SS') AS "refLastDttm"
FROM tb_stat_refine A 
INNER JOIN TB_OPEN_INF B ON A.DS_ID = B.DS_ID
INNER JOIN TB_COMM_ORG C ON A.SIGUN_CD = C.TYPE_CD
WHERE 1=1
    AND B.INF_STATE = 'Y'
    AND B.OPEN_DTTM <= NOW()  
    AND A.YYYYMM = TO_CHAR(NOW(),'YYYYMM') 
ORDER BY A.REFINE_DTTM DESC;

SELECT
    A.DTFILE_ID AS "dtfileId",
    F.DTTRAN_ID AS "dttranId",
    E.UPL_SCH_NO AS "uplSchNo",
    D.DT_NM AS "dtNm",
    D.INF_NM AS "infNm",
    A.SHT_NM AS "shtNm",
    D.LOAD_CD AS "loadCd",
    
    CO.ORG_NM AS "orgNm",
    CU.USR_NM AS "usrNm",
    CU.USR_CD AS "usrCd",
    CU.USR_TEL AS "usrTel",
    CU.USR_EMAIL AS "usrEmail",
    
    TO_CHAR(F.END_DTTM, 'YYYY-MM-DD HH24:MI:SS') AS "chkDttm",
    
    COALESCE(
        ROUND(EXTRACT(EPOCH FROM (F.END_DTTM - F.STRT_DTTM)))::text,
        '0'
    ) AS "chkTm",
    
    COALESCE(F.CHCK_YN, 'N') AS "chckYn",
    CASE 
        WHEN F.CHCK_YN = 'N' THEN 
            CASE 
                WHEN F.ERR_CNT = 0 THEN F.PROC_RSLT 
                ELSE F.ERR_CNT::text || ' 건의 오류가 발생하였습니다.' 
            END
        ELSE F.PROC_RSLT 
    END AS "procRslt",
    CASE 
        WHEN F.PROC_STAT IN ('T', 'P', 'U', 'D', 'M') THEN '예'
        WHEN F.PROC_STAT = 'I' THEN '예(이어서저장하기)'
        ELSE '아니오'
    END AS "saveYn",
    F.DATA_COND_DTTM AS "dataCondDttm",
    F.LOAD_YMD AS "loadYmd"
FROM TB_OPEN_DTFILE A
INNER JOIN (
    SELECT
        B.INF_ID,
        B.INF_NM,
        C.DT_NM,
        B.LOAD_CD,
        B.MULTI_MNG_YN
    FROM TB_OPEN_INF B
    INNER JOIN TB_OPEN_DT C ON B.DT_ID = C.DT_ID
) D ON A.INF_ID = D.INF_ID AND A.DEL_YN = 'N'
INNER JOIN (
    SELECT
        LOAD_YMD,
        DTFILE_ID,
        UPL_SCH_NO,
        ORG_CD
    FROM TB_UPLOAD_SCHE
    WHERE DEL_YN = 'N'
) E ON A.DTFILE_ID = E.DTFILE_ID
INNER JOIN TB_OPEN_DTTRAN F 
    ON E.UPL_SCH_NO = F.UPL_SCH_NO
    AND F.DEL_YN = 'N'
    AND F.PROC_STAT IN ('I', 'C', 'E', 'P', 'U', 'D', 'M', 'T')
    
LEFT JOIN TB_COMM_ORG CO ON CO.ORG_CD = E.ORG_CD AND CO.USE_YN = 'Y'
LEFT JOIN TB_COMM_USR CU ON CU.USR_ID = F.REG_ID

WHERE 1 = 1
ORDER BY F.DTTRAN_ID DESC;


SELECT
    B.INF_NM AS "refOpnDtNm",
    
    -- 기관명
    (
        SELECT H.DITC_NM
        FROM TB_COMM_CODE H
        WHERE H.GRP_CD = 'C1001'
          AND H.DITC_CD = A.SIGUN_CD
        LIMIT 1
    ) AS "refOrg",

    -- 로드 코드명
    (
        SELECT H.DITC_NM
        FROM TB_COMM_CODE H
        WHERE H.GRP_CD = 'D1009'
          AND H.DITC_CD = B.LOAD_CD
        LIMIT 1
    ) AS "refLoadCd",

    A.TOT_CNT AS "refDealCnt",
    A.REFINE_VAL_CNT AS "refSucc",
    A.REFINE_ERR_CNT AS "refFail",
    A.REFINE_PER AS "refPerc",
    A.COORD_PER AS "refCrdPerc",
    A.DS_ID AS "refOpnDtId",
    TO_CHAR(A.REFINE_DTTM, 'YYYY-MM-DD HH24:MI:SS') AS "refLastDttm"

FROM tb_stat_refine A
INNER JOIN TB_OPEN_INF B 
    ON A.DS_ID = B.DS_ID
INNER JOIN TB_COMM_ORG C 
    ON A.SIGUN_CD = C.TYPE_CD

WHERE 1 = 1
  AND B.INF_STATE = 'Y'
  AND B.OPEN_DTTM <= NOW()
  AND A.YYYYMM = TO_CHAR(NOW(), 'YYYYMM')
  AND C.ORG_CD = '6410000'
  AND B.INF_NM LIKE '%' || $1 || '%'

ORDER BY A.REFINE_DTTM DESC;


	-- 스키마 목록 조회
SELECT schema_name 
FROM information_schema.schemata 
WHERE schema_name ILIKE 'ggopengov';
	
	
	SELECT COUNT(*) 
FROM TB_COMM_ORG 
WHERE USE_YN = 'Y';

WITH RECURSIVE org_tree AS (
    SELECT 
        A.ORG_CD,
        A.ORG_NM,
        1 AS ORG_LVL
    FROM TB_COMM_ORG A
    WHERE A.USE_YN = 'Y'
        AND A.ORG_CD_PAR IS NULL
    
    UNION ALL
    
    SELECT 
        child.ORG_CD,
        child.ORG_NM,
        parent.ORG_LVL + 1
    FROM TB_COMM_ORG child
    INNER JOIN org_tree parent ON child.ORG_CD_PAR = parent.ORG_CD
    WHERE child.USE_YN = 'Y'
)
SELECT COUNT(*) FROM org_tree;


-- 1. 재귀 쿼리로 조회되는 데이터
WITH RECURSIVE org_tree AS (
    SELECT 
        A.ORG_CD,
        A.ORG_NM,
        A.ORG_CD_PAR,
        1 AS ORG_LVL
    FROM TB_COMM_ORG A
    WHERE A.USE_YN = 'Y'
        AND A.ORG_CD_PAR IS NULL
    
    UNION ALL
    
    SELECT 
        child.ORG_CD,
        child.ORG_NM,
        child.ORG_CD_PAR,
        parent.ORG_LVL + 1
    FROM TB_COMM_ORG child
    INNER JOIN org_tree parent ON child.ORG_CD_PAR = parent.ORG_CD
    WHERE child.USE_YN = 'Y'
)
SELECT ORG_CD, ORG_NM, ORG_CD_PAR, ORG_LVL
FROM org_tree
ORDER BY ORG_CD;

-- 1. 현재 URL에 대한 메뉴 확인
SELECT * 
FROM TB_COMM_MENU 
WHERE MENU_URL = '/dream/refStat/refStatPage.do';

-- 2. 해당 메뉴의 권한 확인
SELECT M.MENU_ID, M.MENU_NM, MA.ACC_CD, MA.MENU_ACC
FROM TB_COMM_MENU M
LEFT JOIN TB_COMM_MENUACC MA ON M.MENU_ID = MA.MENU_ID
WHERE M.MENU_URL = '/dream/refStat/refStatPage.do';

-- 3. 사용 가능한 권한코드 확인
SELECT DISTINCT ACC_CD 
FROM TB_COMM_MENUACC 
WHERE MENU_ACC != '0';

-- 방법 1: psql 명령어
\d+ tb_stat_use_act

-- 방법 2: SQL 쿼리
SELECT 
    a.attname AS column_name,
    pg_catalog.col_description(a.attrelid, a.attnum) AS comment
FROM 
    pg_catalog.pg_attribute a
WHERE 
    a.attrelid = 'tb_stat_use_act'::regclass
    AND a.attnum > 0 
    AND NOT a.attisdropped
    AND a.attname LIKE '%cnt';

select
	count(B.INF_NM)
from
	tb_stat_refine A
inner join TB_OPEN_INF B on
	A.DS_ID = B.DS_ID
inner join TB_COMM_ORG C on
	A.SIGUN_CD = C.TYPE_CD
where
	1 = 1
	and B.INF_STATE = 'Y'
	and B.OPEN_DTTM <= NOW()
	and A.YYYYMM = TO_CHAR(NOW(), 'YYYYMM')
	and C.ORG_CD = '6410000'



select
	count(B.INF_NM)
from
	tb_stat_refine A
inner join TB_OPEN_INF B on
	A.DS_ID = B.DS_ID
inner join TB_COMM_ORG C on
	A.SIGUN_CD = C.TYPE_CD
where
	1 = 1
	and B.INF_STATE = '11'
	and B.OPEN_DTTM <= NOW()
	and A.YYYYMM = TO_CHAR(NOW(), '202511')
	and C.ORG_CD = '6410000'


select
    count(B.INF_NM)
from
    tb_stat_refine A
inner join TB_OPEN_INF B on
    A.DS_ID = B.DS_ID
inner join TB_COMM_ORG C on
    A.SIGUN_CD = C.TYPE_CD
where
    1 = 1
    and B.INF_STATE = '11'
    and B.OPEN_DTTM <= NOW()
    and A.YYYYMM = TO_CHAR(NOW(), 'YYYYMM')
    and C.ORG_CD = '6410000';


select
    count(*)
from
    tb_stat_refine A
inner join TB_OPEN_INF B on
    A.DS_ID = B.DS_ID
inner join TB_COMM_ORG C on
    A.SIGUN_CD = C.TYPE_CD
where
    B.INF_STATE = '11'
    and B.OPEN_DTTM <= NOW()
    and A.YYYYMM = '202511'
    and C.ORG_CD = '6410000';



select count(*)
from tb_stat_refine
where yyyymm = '202511';


select count(*)
from TB_OPEN_INF
where open_dttm <= now()
  and inf_state = '11';

select distinct a.sigun_cd
from tb_stat_refine a
where yyyymm = '202511';


select distinct type_cd
from tb_comm_org;


select count(*) from TB_OPEN_INF;
select distinct inf_state from TB_OPEN_INF;
select min(open_dttm), max(open_dttm)
from TB_OPEN_INF;



select *
from TB_STAT_REFINE A
join TB_OPEN_INF B on A.DS_ID = B.DS_ID
limit 10;



-- TB_OPEN_INF 상태 값 목록
select 'INF_STATE' as field, inf_state, count(*) 
from TB_OPEN_INF
group by inf_state
order by count(*) desc;

-- 날짜 범위 확인
select min(open_dttm) as min_date, max(open_dttm) as max_date
from TB_OPEN_INF;

-- DS_ID 값 범위 확인
select count(*), count(distinct ds_id) 
from TB_OPEN_INF;

-- YYYYMM이 실제 어떤 값이 있는지 (실제 년월 데이터인지 확인)
select distinct yyyymm 
from TB_STAT_REFINE
order by yyyymm;

-- SIGUN_CD 값 목록
select distinct sigun_cd 
from TB_STAT_REFINE
order by sigun_cd;

SELECT *
FROM (
    SELECT 
        ROW_NUMBER() OVER(ORDER BY REG_DTTM DESC) AS RN,
        TB.*
    FROM (
        SELECT 
            COUNT(*) OVER() AS TOT_CNT
            ,CASE 
                WHEN SYS_TAG = 'K' THEN 'PC'
                WHEN SYS_TAG = 'E' THEN '영문'
                WHEN SYS_TAG = 'M' THEN '모바일'
                ELSE ''
            END AS SYS_TAG
            ,CASE 
                WHEN USER_IP = '0:0:0:0:0:0:0:1' THEN '127.0.0.1'
                ELSE USER_IP 
            END AS USER_IP
            ,MENU_URL
            ,MENU_NM
            ,TO_CHAR(REG_DTTM, 'YYYY-MM-DD HH24:MI:SS') AS REG_DTTM
        FROM TB_LOG_MENU
        WHERE 
            -- ❌ 느림: TO_CHAR로 변환해서 비교
            TO_CHAR(REG_DTTM, 'YYYYMMDD') BETWEEN 
                TO_CHAR(TO_DATE('2025-11-01', 'YYYY-MM-DD'), 'YYYYMMDD')
            AND TO_CHAR(TO_DATE('2025-11-01', 'YYYY-MM-DD') + INTERVAL '1 day', 'YYYYMMDD')
            AND USER_IP NOT LIKE '0:%' 
            AND USER_IP NOT IN ('192.168.24.120', '127.0.0.1')
            AND SYS_TAG = 'K'
    ) TB
) SUB
WHERE RN BETWEEN 1 AND 20;

SELECT *
FROM (
    SELECT 
        ROW_NUMBER() OVER(ORDER BY REG_DTTM DESC) AS RN,
        TB.*
    FROM (
        SELECT 
            COUNT(*) OVER() AS TOT_CNT
            ,CASE 
                WHEN SYS_TAG = 'K' THEN 'PC'
                WHEN SYS_TAG = 'E' THEN '영문'
                WHEN SYS_TAG = 'M' THEN '모바일'
                ELSE ''
            END AS SYS_TAG
            ,CASE 
                WHEN USER_IP = '0:0:0:0:0:0:0:1' THEN '127.0.0.1'
                ELSE USER_IP 
            END AS USER_IP
            ,MENU_URL
            ,MENU_NM
            ,TO_CHAR(REG_DTTM, 'YYYY-MM-DD HH24:MI:SS') AS REG_DTTM
        FROM TB_LOG_MENU
        WHERE 
            -- ✅ 빠름: 날짜를 직접 비교
            REG_DTTM >= TO_DATE('2025-11-01', 'YYYY-MM-DD')
            AND REG_DTTM < TO_DATE('2025-11-01', 'YYYY-MM-DD') + INTERVAL '1 day'
            AND USER_IP NOT LIKE '0:%' 
            AND USER_IP NOT IN ('192.168.24.120', '127.0.0.1')
            AND SYS_TAG = 'K'
    ) TB
) SUB
WHERE RN BETWEEN 1 AND 20;

SELECT *
FROM (
    SELECT 
        ROW_NUMBER() OVER(ORDER BY REG_DTTM DESC) AS RN,
        TB.*
    FROM (
        SELECT 
            COUNT(*) OVER() AS TOT_CNT
            ,CASE 
                WHEN SYS_TAG = 'K' THEN 'PC'
                WHEN SYS_TAG = 'E' THEN '영문'
                WHEN SYS_TAG = 'M' THEN '모바일'
                ELSE ''
            END AS SYS_TAG
            ,CASE 
                WHEN USER_IP = '0:0:0:0:0:0:0:1' THEN '127.0.0.1'
                ELSE USER_IP 
            END AS USER_IP
            ,MENU_URL
            ,MENU_NM
            ,TO_CHAR(REG_DTTM, 'YYYY-MM-DD HH24:MI:SS') AS REG_DTTM
        FROM TB_LOG_MENU
        WHERE 
            REG_DTTM >= TO_TIMESTAMP('2025-11-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS')
            AND REG_DTTM < TO_TIMESTAMP('2025-11-02 00:00:00', 'YYYY-MM-DD HH24:MI:SS')
            AND USER_IP NOT LIKE '0:%' 
            AND USER_IP NOT IN ('192.168.24.120', '127.0.0.1')
            AND SYS_TAG = 'K'
    ) TB
) SUB
WHERE RN BETWEEN 1 AND 20;

SELECT *
FROM (
    SELECT 
        ROW_NUMBER() OVER(ORDER BY REG_DTTM DESC) AS RN,
        TB.*
    FROM (
        SELECT 
            COUNT(*) OVER() AS TOT_CNT
            ,CASE 
                WHEN SYS_TAG = 'K' THEN 'PC'
                WHEN SYS_TAG = 'E' THEN '영문'
                WHEN SYS_TAG = 'M' THEN '모바일'
                ELSE ''
            END AS SYS_TAG
            ,CASE 
                WHEN USER_IP = '0:0:0:0:0:0:0:1' THEN '127.0.0.1'
                ELSE USER_IP 
            END AS USER_IP
            ,MENU_URL
            ,MENU_NM
            ,TO_CHAR(REG_DTTM, 'YYYY-MM-DD HH24:MI:SS') AS REG_DTTM
        FROM TB_LOG_MENU
        WHERE 
            REG_DTTM >= '2025-11-01 00:00:00'::TIMESTAMP
            AND REG_DTTM < '2025-11-02 00:00:00'::TIMESTAMP
            AND USER_IP NOT LIKE '0:%' 
            AND USER_IP NOT IN ('192.168.24.120', '127.0.0.1')
            AND SYS_TAG = 'K'
    ) TB
) SUB
WHERE RN BETWEEN 1 AND 20;


SELECT *
FROM TB_LOG_MENU
WHERE 
    REG_DTTM >= TO_DATE('2025-11-01', 'YYYY-MM-DD')
    AND REG_DTTM < TO_DATE('2025-11-01', 'YYYY-MM-DD') + INTERVAL '1 day'
    AND SYS_TAG = 'K'
;


