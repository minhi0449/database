-- AdminOpenMetaInfMng_Sql_Postgres
<select id="selectOpenMetaInfMngListAllCnt" parameterType="egovframework.admin.data.openinf.model.OpenInfVO" resultType="java.lang.Integer" flushCache="true" useCache="false">

		SELECT COUNT(*)
		FROM 
		  TV_MNG_INF A
		  , (
		    SELECT
		      INF_ID
		      , ORG_CD
		      , USR_CD
		    FROM 
		      TB_META_ORG_USR_REL 
		    WHERE 
		      INF_ID IN (  
		        SELECT
		          INF_ID
		        FROM (  
		          SELECT
		            INF_ID
		            , SUM(DECODE(ORG_CD, '6410000', 1, 0)) AS GG
		            , SUM(DECODE(ORG_CD, '6410000', 0, 1)) AS NO_GG
		          FROM
		            TB_META_ORG_USR_REL
		          WHERE
		            DEL_YN = 'N'
		            AND EXP_DTTM = TO_DATE ('99991231', 'YYYYMMDD')
		          GROUP BY
		            INF_ID
		          )
		        WHERE 
		          ((GG = 1 AND NO_GG = 1) OR (GG = 1 AND NO_GG = 0) OR (GG = 0 AND NO_GG = 1))
		      )
		  ) B
		  WHERE
  	A.INF_ID = B.INF_ID
    <if test="accCd != null and accCd == 'DM'">  
        AND B.USR_CD = #{usrCd}
    </if>                        
    <if test="accCd != null and accCd == 'CM'">      
        AND B.ORG_CD = #{orgCd}
    </if>  

    <if test="searchWord != null and searchWord != ''">
        <if test="searchWd != null and searchWd == '0'">
            AND A.INF_NM LIKE '%' || #{searchWord} || '%'
        </if>
        <if test="searchWd != null and searchWd == '1'">
            AND A.DT_NM LIKE '%' || #{searchWord} || '%'
        </if>
    </if>
	</select>
    
    

    -- 모니터링 > 
-- 1. 데이터 있는지 확인
SELECT COUNT(*) as total FROM TB_LOG_LINKSRV;

-- 2. 날짜 범위 확인
SELECT MIN(JOB_DT), MAX(JOB_DT) FROM TB_LOG_LINKSRV;

-- 3. 샘플 데이터 확인
SELECT * FROM TB_LOG_LINKSRV ORDER BY JOB_DT DESC LIMIT 5;



SELECT MAX(SEQCE_NO) AS "seq" FROM TB_LOG_REFINE_FILE;

SELECT COUNT(*)
FROM TB_OPEN_DTFILE A
INNER JOIN (SELECT B.INF_ID, B.INF_NM, C.DT_NM, B.LOAD_CD 
			FROM TB_OPEN_INF B
			INNER JOIN TB_OPEN_DT C
			ON B.DT_ID=C.DT_ID) D 
ON A.INF_ID = D.INF_ID
AND A.DEL_YN = 'N'
INNER JOIN (SELECT LOAD_YMD
					, DTFILE_ID
					, UPL_SCH_NO 
					, ORG_CD
				FROM TB_UPLOAD_SCHE
				WHERE DEL_YN = 'N') E
ON A.DTFILE_ID = E.DTFILE_ID
INNER JOIN TB_OPEN_DTTRAN F
ON E.UPL_SCH_NO = F.UPL_SCH_NO
AND F.DEL_YN = 'N'
AND F.PROC_STAT IN ('I','C','E');


SELECT 
        DITC_CD AS "code",    -- 코드 값
        DITC_NM AS "name"     -- 코드 이름
    FROM TB_COMM_CODE         -- 공통 코드 테이블
    WHERE GRP_CD = 'D1104'    -- 그룹 코드로 필터링
        AND USE_YN = 'Y'      -- 사용 여부 = Y
    ORDER BY V_ORDER;         -- 정렬 순서대로


SELECT 
            DITC_CD AS "code",
            DITC_NM AS "name"
        FROM TB_COMM_CODE
        WHERE GRP_CD = 'D1009'
            AND USE_YN = 'Y'
        ORDER BY V_ORDER;
        
        
select
	A.DTFILE_ID as "dtfileId" ,
	F.DTTRAN_ID as "dttranId" ,
	E.UPL_SCH_NO as "uplSchNo" ,
	D.DT_NM as "dtNm" ,
	D.INF_NM as "infNm" ,
	A.SHT_NM as "shtNm" ,
	D.LOAD_CD as "loadCd" ,
	(
	select
		ORG_NM
	from
		TB_COMM_ORG
	where
		ORG_CD = E.ORG_CD
		and USE_YN = 'Y') as "orgNm" ,
	(
	select
		USR_NM
	from
		TB_COMM_USR
	where
		USR_ID = F.REG_ID) as "usrNm" ,
	(
	select
		USR_CD
	from
		TB_COMM_USR
	where
		USR_ID = F.REG_ID) as "usrCd" ,
	(
	select
		USR_TEL
	from
		TB_COMM_USR
	where
		USR_ID = F.REG_ID) as "usrTel" ,
	(
	select
		USR_EMAIL
	from
		TB_COMM_USR
	where
		USR_ID = F.REG_ID) as "usrEmail" ,
	TO_CHAR(F.END_DTTM, 'YYYY-MM-DD HH24:MI:SS') as "chkDttm" ,
	TO_CHAR(COALESCE(ROUND((F.END_DTTM-F.STRT_DTTM)* 24 * 60 * 60), 0)) as "chkTm" ,
	COALESCE(F.CHCK_YN, 'N') as "chckYn" ,
	decode(F.CHCK_YN, 'N', decode(F.ERR_CNT, 0, F.PROC_RSLT, F.ERR_CNT || ' 건의 오류가 발생하였습니다.'), F.PROC_RSLT) as "procRslt" ,
	decode(F.PROC_STAT, 'T', '예', 'I', '예(이어서저장하기)', 'P', '예', 'U', '예', 'D', '예', 'M', '예', '아니오') "saveYn" ,
	F.DATA_COND_DTTM as "dataCondDttm" ,
	F.LOAD_YMD as "loadYmd"
from
	TB_OPEN_DTFILE A
inner join (
	select
		B.INF_ID,
		B.INF_NM,
		C.DT_NM,
		B.LOAD_CD ,
		B.MULTI_MNG_YN
	from
		TB_OPEN_INF B
	inner join TB_OPEN_DT C on
		B.DT_ID = C.DT_ID) D on
	A.INF_ID = D.INF_ID
	and A.DEL_YN = 'N'
inner join (
	select
		LOAD_YMD ,
		DTFILE_ID ,
		UPL_SCH_NO ,
		ORG_CD
	from
		TB_UPLOAD_SCHE
	where
		DEL_YN = 'N') E on
	A.DTFILE_ID = E.DTFILE_ID
inner join TB_OPEN_DTTRAN F on
	E.UPL_SCH_NO = F.UPL_SCH_NO
	and F.DEL_YN = 'N'
	and F.PROC_STAT in ('I', 'C', 'E', 'P', 'U', 'D', 'M', 'T', 'I')
where
	1 = 1
order by
	F.DTTRAN_ID desc;
        

