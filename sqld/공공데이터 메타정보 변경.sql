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
AND F.PROC_STAT IN ('I','C','E')
<<<<<<< Updated upstream
    
=======

>>>>>>> Stashed changes
