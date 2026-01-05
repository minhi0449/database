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
    
    
    
    
