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