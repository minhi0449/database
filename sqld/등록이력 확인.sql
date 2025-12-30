<?xml version="1.0" encoding="UTF-8"?>
<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
<!-- @(#)AdminOpenDtchck_Sql_Tibero.xml 1.0 2015/06/01                       -->
<!--                                                                         -->
<!-- COPYRIGHT (C) 2013 WISEITECH CO., LTD. ALL RIGHTS RESERVED.             -->
<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
<!-- 데이터 검증을 관리하는 SQL 파일이다.                                    -->
<!--                                                                         -->
<!-- @author 김은삼                                                          -->
<!-- @version 1.0 2015/06/01                                                 -->
<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
<mapper namespace="egovframework.admin.data.dtfile.dao.OpenDtchckDAO">
    
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- 데이터 검증을 검색한다.                                             -->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- 검색 조건절 -->
    <sql id="searchOpenDtchckWhere">
         WHERE A.DTTRAN_ID    = #{dttranId}
<!--            AND A.DEL_YN       = 'N' -->
    </sql>
    <!-- 검색 데이터 -->
    <select id="searchOpenDtchck" parameterType="params" resultType="record">
		WITH RawData AS (
			SELECT *, ROW_NUMBER() OVER () as row_num 
			FROM ${tableName}
		),
		ColList AS (
			SELECT LOWER(COL_NM) AS COL_NM_LOWER, COL_SEQ 
			FROM TB_OPEN_DTCOLS 
			WHERE DTFILE_ID = CAST(#{dtfileId} AS INTEGER) AND DEL_YN = 'N'
		)
		SELECT 
			R.row_num AS "rowSeq",
			C.COL_SEQ AS "colSeq",
			COALESCE((row_to_json(R)->>C.COL_NM_LOWER), '') AS "dataVal",
			'Y' AS "nullchckYn",
			'Y' AS "typechckYn",
			'Y' AS "addrToCoordYn",
			'' AS "errCd",      
			'' AS "errDesc",    
			'N' AS "delYn"      
		FROM RawData R
		CROSS JOIN ColList C
		ORDER BY R.row_num ASC, C.COL_SEQ ASC
	</select>

    <!-- 검색 카운트 -->
    <select id="searchOpenDtchckCount" parameterType="params" resultType="int">
        SELECT COUNT(*) * (SELECT COUNT(*) FROM TB_OPEN_DTCOLS WHERE DTFILE_ID = #{dtfileId} AND DEL_YN = 'N')
      FROM ${tableName}
    </select>
    
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- 데이터 검증을 전체 검색한다.                                        -->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <select id="searchOpenDtchckAll1" parameterType="params" resultType="record">
        SELECT A.ROW_SEQ - 1 AS "rowIndex",
			A.COL_SEQ - 1 AS "columnIndex",
			A.DATA_VAL AS "dataValue",
			CASE 
				WHEN A.NULLCHCK_YN = 'Y' AND A.TYPECHCK_YN = 'Y' THEN 'true' 
				ELSE 'false' 
			END AS "isValid"
		FROM TB_OPEN_DTCHCK A
		WHERE A.DTTRAN_ID = #{dttranId}::NUMERIC

		UNION ALL

		SELECT 
			data_rows.row_idx AS "rowIndex",
			col_mapping.col_idx AS "columnIndex",
			COALESCE((data_rows.row_data->>col_mapping.col_name), '')::text AS "dataValue",
			'true' AS "isValid"
		FROM (
			SELECT 
				(ROW_NUMBER() OVER ()) - 1 AS row_idx,
				to_json(t.*) AS row_data
			FROM ${tableName} t
		) data_rows
		CROSS JOIN (
			SELECT 
				(dtcols.COL_SEQ - 1) AS col_idx,
				lower(dtcols.COL_NM) AS col_name
			FROM TB_OPEN_DTCOLS dtcols
			WHERE dtcols.DTFILE_ID = #{dtfileId}::NUMERIC 
			AND dtcols.DEL_YN = 'N'
			ORDER BY dtcols.COL_SEQ
		) col_mapping
		WHERE NOT EXISTS (
			SELECT 1 FROM TB_OPEN_DTCHCK C 
			WHERE C.DTTRAN_ID = #{dttranId}::NUMERIC
		)

		ORDER BY "rowIndex", "columnIndex"
    </select>
    
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- 데이터 검증을 등록한다.                                             -->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <insert id="insertOpenDtchck" parameterType="params">
        INSERT INTO TB_OPEN_DTCHCK
               (
                   DTTRAN_ID,
                   ROW_SEQ,
                   COL_SEQ,
                   DATA_VAL,
                   NULLCHCK_YN,
                   TYPECHCK_YN,
                   DTTYPE_ID,
                   DTCOLS_ID,
                   DEL_YN,
                   REG_ID,
                   REG_DTTM,
                   ADDR_TO_COORD_CD
               )
        VALUES (
                   #{dttranId},
                   #{rowSeq},
                   #{colSeq},
                   #{dataVal},
                   #{nullchckYn},
                   #{typechckYn},
                   #{dttypeId},
                   #{dtcolsId},  
                   'N',
                   #{regId},
                   SYSDATE,
                   #{addrToCoordCd}
               )
    </insert>
    
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- 데이터 검증을 삭제한다.                                             -->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <update id="deleteOpenDtchck" parameterType="params">
    	UPDATE TB_OPEN_DTCHCK SET
    		DEL_YN = 'Y'
    		,UPD_ID = #{updId}
    		,UPD_DTTM = SYSDATE
    	WHERE DTTRAN_ID = #{dttranId}
    		AND DEL_YN = 'N'    	
    </update>
    
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- 데이터 검증오류 조회                                                                                                                       -->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <select id="searchDtchckErr" parameterType="params" resultType="record">
        <![CDATA[
        SELECT A.DTTRAN_ID               
		     , A.ERR_SEQ 		     
		     , B.DITC_NM AS CHCK_DESC
		     , A.FILE_HDR_TXT
		     , A.STND_HDR_TXT
          FROM TB_OPEN_DTTRAN_ERR A
               INNER JOIN TB_COMM_CODE B
                  ON B.GRP_CD  = 'C1016'  /*자료입력오류코드*/
                 AND B.DITC_CD = A.ERR_CD
         WHERE A.DTTRAN_ID IN (
			/* 1. 현재 클릭한 스케줄(5897) 관련 ID */
			SELECT DTTRAN_ID FROM TB_OPEN_DTTRAN WHERE UPL_SCH_NO = #{uplSchNo}
			
			UNION
			
			/* 2. 같은 파일명을 가진 다른 스케줄(5904 등)의 오류 ID도 포함 */
			SELECT DTTRAN_ID 
			FROM TB_OPEN_DTTRAN 
			WHERE FILE_NM LIKE (SELECT FILE_NM || '%' FROM TB_OPEN_DTTRAN WHERE DTTRAN_ID = #{dttranId} LIMIT 1)
		)
		ORDER BY A.DTTRAN_ID DESC, A.ERR_SEQ ASC
        
		]]>        
    </select>
    
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- 데이터 검증 항목별 오류 조회                                                                                                                       -->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <select id="searchDtchckColGrpErr" parameterType="params" resultType="record">
       
        <![CDATA[   
                
		SELECT A.DTTRAN_ID
		     , B.DTTYPE_ID
		     , C.DTCOLS_ID
		     , C.COL_EXP
		     , MAX(B.DTTYPE_NM)   AS DTTYPE_NM 
		     , MAX(B.CHCK_DESC) || CASE WHEN MAX(C.SQL_CHCK_DESC) IS NOT NULL THEN '<BR>'||MAX(C.SQL_CHCK_DESC) ELSE '' END  
		     || CASE WHEN  MAX(A.ADDR_TO_COORD_CD) IS NOT NULL AND MAX(A.ADDR_TO_COORD_CD) NOT IN (]]> 
		     	<foreach collection="addrSuccessCode" item="item" index="index" separator=",">#{item}</foreach>
		     <![CDATA[   ) THEN '<BR> 주소정제에 오류가 있습니다. 상세 내용을 확인해 주세요' ELSE '' END AS CHCK_DESC          
		     , MAX(C.NULL_YN)     AS NULLCHCK_YN
		     , COUNT (*)||'건(필수항목누락 : '||SUM(CASE WHEN A.ADDR_TO_COORD_CD IS NULL AND A.NULLCHCK_YN = 'N' THEN 1 ELSE 0 END)||'건, 패턴오류 : '||SUM(CASE WHEN A.ADDR_TO_COORD_CD IS NULL AND A.TYPECHCK_YN = 'N' THEN 1 ELSE 0 END)||'건, 부존재주소 : '
         		|| SUM ( CASE WHEN A.ADDR_TO_COORD_CD IS NULL OR A.ADDR_TO_COORD_CD IN (]]> 
         		<foreach collection="addrSuccessCode" item="item" index="index" separator=",">#{item}</foreach>
         		<![CDATA[   ) THEN 0 ELSE 1 END ) || '건)'  AS ERR_CNT      
		  FROM TB_OPEN_DTCHCK A
		       INNER JOIN TB_OPEN_DTTYPE B
		          ON B.DTTYPE_ID = A.DTTYPE_ID 
		       INNER JOIN TB_OPEN_DTCOLS C
		          ON C.DTCOLS_ID = A.DTCOLS_ID  
		 WHERE (A.TYPECHCK_YN = 'N' OR A.NULLCHCK_YN = 'N' OR ADDR_TO_COORD_CD NOT IN (]]> 
		 	<foreach collection="addrSuccessCode" item="item" index="index" separator=",">#{item}</foreach>
		 	<![CDATA[   ))
				AND A.DTTRAN_ID = (
				SELECT MAX(DTTRAN_ID) 
				FROM TB_OPEN_DTCHCK 
				WHERE DTTRAN_ID <= #{dttranId}::INTEGER
				AND (TYPECHCK_YN = 'N' OR NULLCHCK_YN = 'N')
			) 
			GROUP BY A.DTTRAN_ID , B.DTTYPE_ID , C.DTCOLS_ID , C.COL_EXP 
			ORDER BY A.DTTRAN_ID, MAX(A.COL_SEQ)
		]]>        
    </select>
    
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- 데이터 검증 항목병 상세오류 조회                                                                                                                       -->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <select id="searchDtchckColDetErr" parameterType="params" resultType="record">
               
        <![CDATA[       
						
		SELECT DTTRAN_ID
		    , DTTYPE_ID
		    , ROW_SEQ
		    , COL_NM
		    , COL_EXP
		    , DTCOLS_ID
		    , NULLCHCK_YN
		    , DTTYPE_NM
		    , CHCK_DESC
		    , DATA_VAL
		FROM (
		    SELECT A.DTTRAN_ID,
		        A.DTTYPE_ID,
		        A.ROW_SEQ,
		        C.COL_NM,
		        C.COL_EXP,
		        C.DTCOLS_ID,
		        CASE WHEN A.DATA_VAL IS NOT NULL THEN 'Y' ELSE A.NULLCHCK_YN END AS NULLCHCK_YN,
		        B.DTTYPE_NM,
		        CASE WHEN (A.ADDR_TO_COORD_CD IS NOT NULL AND A.ADDR_TO_COORD_CD NOT IN (]]> 
		        			<foreach collection="addrSuccessCode" item="item" index="index" separator=",">#{item}</foreach>
		        			<![CDATA[    ) ) AND (A.TYPECHCK_YN = 'N')  THEN '[패턴오류]'||B.CHCK_DESC ||'<BR>[주소검증오류]'||(SELECT DITC_NM FROM TB_COMM_CODE WHERE  USE_YN = 'Y' AND GRP_CD = 'D1104' AND DITC_CD = A.ADDR_TO_COORD_CD)
		        		WHEN (A.ADDR_TO_COORD_CD IS NOT NULL AND A.ADDR_TO_COORD_CD NOT IN (]]> 
		        			<foreach collection="addrSuccessCode" item="item" index="index" separator=",">#{item}</foreach>
		        			<![CDATA[    ) )  THEN '[주소검증오류]'||(SELECT DITC_NM FROM TB_COMM_CODE WHERE  USE_YN = 'Y' AND GRP_CD = 'D1104' AND DITC_CD = A.ADDR_TO_COORD_CD)
                        WHEN A.TYPECHCK_YN = 'N' AND NOT (A.ADDR_TO_COORD_CD IS NOT NULL AND A.ADDR_TO_COORD_CD NOT IN (]]> 
                        	<foreach collection="addrSuccessCode" item="item" index="index" separator=",">#{item}</foreach>
                        	<![CDATA[    )) THEN '[패턴오류]'||B.CHCK_DESC
				        ELSE ''
				        END
				         || CASE WHEN C.SQL_CHCK_DESC IS NOT NULL THEN '<BR>' || C.SQL_CHCK_DESC
				        ELSE '' END
				        AS CHCK_DESC,
		        A.DATA_VAL
		    FROM TB_OPEN_DTCHCK A
		        LEFT JOIN TB_OPEN_DTTYPE B ON B.DTTYPE_ID = A.DTTYPE_ID
		        LEFT JOIN TB_OPEN_DTCOLS C ON C.DTCOLS_ID = A.DTCOLS_ID
		    WHERE A.DTTRAN_ID = #{dttranId}
		        AND A.DTTYPE_ID = #{dttypeId}
		        AND A.DTCOLS_ID = #{dtcolsId}
		        AND (TYPECHCK_YN = 'N' OR NULLCHCK_YN = 'N' 
		            OR (A.ADDR_TO_COORD_CD IS NOT NULL AND A.ADDR_TO_COORD_CD NOT IN (]]> 
		            	<foreach collection="addrSuccessCode" item="item" index="index" separator=",">#{item}</foreach>
		            <![CDATA[     ))
		            )
		    ORDER BY DTTRAN_ID, NULLCHCK_YN DESC, ROW_SEQ
		)
		WHERE ROWNUM <= 100
   
		 
		]]>        
    </select>
    
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- CSV 다운로드 상세오류 조회                                                                                                                       -->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <select id="searchDownOpenDtchckErrCsv" parameterType="params" resultType="record">
                  
        SELECT A.DTTRAN_ID
             , A.DTTYPE_ID
             , A.ROW_SEQ
             , C.COL_NM
             , C.COL_EXP
             , C.DTCOLS_ID
             , A.NULLCHCK_YN AS NULLCHCK_YN
             , B.DTTYPE_NM
             , B.CHCK_DESC      
             , A.DATA_VAL          
          FROM TB_OPEN_DTCHCK A
               LEFT JOIN TB_OPEN_DTTYPE B
                 ON B.DTTYPE_ID = A.DTTYPE_ID
               LEFT JOIN TB_OPEN_DTCOLS C
                 ON C.DTCOLS_ID = A.DTCOLS_ID  
         WHERE TYPECHCK_YN = 'N'
           AND A.DTTRAN_ID = #{dttranId}                                    
         ORDER BY DTTRAN_ID                 
                , ROW_SEQ
                
    </select>
    
    <update id="updateCheckAddr" parameterType="params">
        		        
		UPDATE TB_OPEN_DTCHCK A
		   SET NULLCHCK_YN = 'N'
		     , TYPECHCK_YN = 'N'
		 WHERE A.DTTRAN_ID = #{dttranId}
		   AND A.ROW_SEQ   = #{rowSeq}
		   AND (A.DTTRAN_ID, A.ROW_SEQ, A.COL_SEQ) IN
                                  (SELECT Y.DTTRAN_ID
                                        , Y.ROW_SEQ    
                                        , MIN(Y.COL_SEQ) AS COL_SEQ
                                     FROM TB_OPEN_DTCOLS X
                                          INNER JOIN TB_OPEN_DTCHCK Y
                                             ON Y.DTCOLS_ID = X.DTCOLS_ID  
                                    WHERE 1 = 1
                                      AND Y.DTTRAN_ID = A.DTTRAN_ID
                                      AND X.COL_NM IN ('LOCPLC_ROADNM_ADDR','LOCPLC_LOTNO_ADDR')                  
                                    GROUP BY Y.DTTRAN_ID
                                           , Y.ROW_SEQ                       
                                    HAVING ( (MAX(CASE WHEN X.COL_NM = 'LOCPLC_ROADNM_ADDR' AND Y.DATA_VAL IS NULL THEN 'Y' ELSE '0' END) = 'Y' ) AND
                                             (MAX(CASE WHEN X.COL_NM = 'LOCPLC_LOTNO_ADDR' AND Y.DATA_VAL IS NULL THEN 'Y' ELSE '0' END) = 'Y' )
                                           )          
                                  )                     
                
    </update>
    
    <select id="searchAddrConvertDs" parameterType="params" resultType="record">
		SELECT 
		    COUNT(*) CNT
		FROM (SELECT 
				        OWNER_CD,
				        DS_ID,
				        (CASE
				            WHEN TO_NUMBER (TO_CHAR (LAST_DAY (SYSDATE), 'dd')) <![CDATA[  < ]]> refine_setup_dd THEN TO_NUMBER (TO_CHAR (LAST_DAY (SYSDATE), 'dd'))
				            ELSE refine_setup_dd
				         END) AS REFINE_SETUP_DD
			      FROM 
			        ggopenptl.TB_OPEN_DS
			      WHERE 
			        USE_YN = 'Y' 
		    ) D
		 INNER JOIN ALL_TAB_COLUMNS T
		 ON     D.OWNER_CD = T.OWNER
		 AND D.DS_ID = T.TABLE_NAME AND COLUMN_NAME = 'NO'
		 AND EXISTS (SELECT 1
		             FROM TB_OPEN_DSCOL
		             WHERE DS_ID = d.DS_ID
		             AND ADDR_CD IN ('LOTN', 'ROAD', 'ADDR'))
		 AND D.DS_ID = (
			 SELECT DS_ID 
			 FROM TB_OPEN_INF 
			 WHERE INF_ID = (
				 SELECT INF_ID 
				 FROM TB_OPEN_DTFILE 
				 WHERE 1=0 OR 
				 <if test='dtfileId != null and dtfileId != ""'>
				 	DTFILE_ID = #{dtfileId}
				 </if>
				 <if test='dtfileId == null or dtfileId == ""'>
				 	<if test='dttranId != null and dttranId != ""'>
				 	DTFILE_ID = (select DTFILE_ID from TB_OPEN_DTTRAN WHERE DTTRAN_ID = #{dttranId})
				 	</if>
				 </if>
			 )
		 )
    </select>
    
    <select id="searchAddrConvertColumns" parameterType="params" resultType="record">
		SELECT
		    A.DTTRAN_ID as "dttranId"
		    , A.ROW_SEQ as "rowSeq"
		    , A.COL_SEQ as "colSeq"
		    , A.DATA_VAL as "dataVal"
		    , B.COL_NM as "colNm"
		    , C.ADDR_CD as "addrCd"
		    , COUNT(ROW_SEQ) OVER(PARTITION BY ROW_SEQ) AS "colCnt"
		FROM TB_OPEN_DTCHCK A 
		    , TB_OPEN_DTCOLS B
		    , (
				SELECT 
		            A.COL_ID
				    , (CASE WHEN A.COL_ID = 'SIGUN_NM' THEN 'SIGUN' ELSE a.ADDR_CD END) AS ADDR_CD
				FROM 
				    GGOPENPTL.TB_OPEN_DSCOL A
				WHERE
				    (A.ADDR_CD IN ('LOTN', 'ADDR', 'ROAD', 'ZIP5', 'WGSO', 'WGSA') OR COL_ID = 'SIGUN_NM')
				    AND A.DS_ID = (SELECT
		                            C.DS_ID
		                        FROM
		                            TB_OPEN_INF C
		                            , TB_OPEN_DTFILE D
		                        WHERE
		                            C.INF_ID = D.INF_ID AND ( 1=0 OR
			                            <if test='dtfileId != null and dtfileId != ""'>
											 	D.DTFILE_ID = #{dtfileId}
										 </if>
										 <if test='dtfileId == null or dtfileId == ""'>
										 	<if test='dttranId != null and dttranId != ""'>
										 	D.DTFILE_ID = (SELECT DTFILE_ID FROM TB_OPEN_DTTRAN WHERE DTTRAN_ID = #{dttranId})
										 	</if>
										 </if>
										 )
									 )    
		    ) C
		WHERE 
			DTTRAN_ID = #{dttranId}
			AND    A.DTCOLS_ID = B.DTCOLS_ID
			AND B.COL_NM = C.COL_ID
		ORDER BY A.ROW_SEQ, A.COL_SEQ  
    </select>
    
    <select id="searchAddrConvertColumns_NEW" parameterType="params" resultType="record">
		SELECT 
		A.COL_ID AS "colNm",
		B.DATA AS "dataVal",
        (CASE WHEN A.COL_ID = 'SIGUN_NM' THEN 'SIGUN' ELSE A.ADDR_CD END) AS "addrCd"
	  FROM GGOPENPTL.TB_OPEN_DSCOL A
	  INNER JOIN ( ${addrSub} ) B ON A.COL_ID = B.COl_NM 
	 WHERE     (   A.ADDR_CD IN ('LOTN','ADDR', 'ROAD','ZIP5','WGSO','WGSA')
	            OR COL_ID = 'SIGUN_NM')
	       AND A.DS_ID = (SELECT C.DS_ID
	                        FROM TB_OPEN_INF C, TB_OPEN_DTFILE D
                       WHERE C.INF_ID = D.INF_ID  AND
                        <if test='dtfileId != null and dtfileId != ""'>
							 	D.DTFILE_ID = #{dtfileId}
						 </if>
						 <if test='dtfileId == null or dtfileId == ""'>
						 	<if test='dttranId != null and dttranId != ""'>
						 		D.DTFILE_ID = (SELECT DTFILE_ID FROM TB_OPEN_DTTRAN WHERE DTTRAN_ID = #{dttranId})
						 	</if>
						 </if>)
                       
    </select>
    
    <update id="updateDtchkVal" parameterType="params">
    	UPDATE TB_OPEN_DTCHCK
    	SET
    		DATA_VAL = #{dataVal}
    	WHERE
    		DTTRAN_ID = #{dttranId}
    		AND ROW_SEQ = #{rowSeq}
    		AND COL_SEQ = #{colSeq}
    </update>
    
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- 데이터 신규 검증                                       -->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <select id="searchOpenDtchckAllByCustomQuery" parameterType="java.lang.String" resultType="record" flushCache="true" useCache="false">
    /* searchOpenDtchckAllByCustomQuery */
		 	${sql}
    </select>
    
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- 데이터 신규 검증2                                       -->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <select id="selectQueryByCsv" parameterType="params" resultType="record" flushCache="true" useCache="false">
         <![CDATA[${sql}]]>
    </select>
    
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~m,,~~~~~~~ -->
    <!-- 데이터 기준일자 검증                     -->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <select id="checkDataStdDe" parameterType="params" resultType="java.lang.String">
   		SELECT CASE WHEN(
			TO_DATE (	NVL (
			( SELECT MAX (A.DATA_COND_DTTM) DATA_COND_DTTM
			FROM TB_OPEN_DTTRAN A, TB_UPLOAD_SCHE B, TB_OPEN_INF C
			WHERE     A.UPL_SCH_NO = B.UPL_SCH_NO
			AND B.INF_ID = C.INF_ID
			AND A.UPL_SCH_NO = #{uplSchNo}
			AND A.PROC_STAT = 'T'
			AND A.DATA_COND_DTTM IS NOT NULL
			AND DECODE (C.MULTI_MNG_YN, 'Y', A.REG_ID, 1) =
			DECODE (C.MULTI_MNG_YN, 'Y', #{usrId}, 1)
			GROUP BY A.UPL_SCH_NO),
			'0001-01-01'),'YYYY-MM-DD') <![CDATA[ <= ]]>TO_DATE (#{dataCondDttm}, 'YYYY-MM-DD'))
			THEN 'Y'
			ELSE 'N'
			END AS "resultYn"
		FROM DUAL		
    </select>
    
    
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- 컬럼명 리스트로 가져오기  ,검증까지                            -->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <select id="selectColListByDttranId" parameterType="java.lang.String" resultType="record">
	    SELECT F.COL_SEQ     AS "colSeq"
		, F.COL_NM      AS "colNm"
		, F.COL_EXP     AS "colExp"
		, F.NULL_YN     AS "nullYn"
		, B.VERI_TY     AS "veriTy"
		, B.VERI_PAT    AS "veriPat"
		, B.DTTYPE_ID   AS "dttypeId"
		, F.DTCOLS_ID   AS "dtcolsId"
		, F.SQL_VERIFY   AS "sqlVerify"
		FROM TB_OPEN_DTFILE A
		INNER JOIN TB_OPEN_DTTRAN C  ON A.DTFILE_ID = C.DTFILE_ID AND C.DTTRAN_ID = #{dttranId}
		INNER JOIN TB_OPEN_DTCOLS F ON A.DTFILE_ID = F.DTFILE_ID AND C.DTFILE_ID = F.DTFILE_ID
		INNER JOIN TB_OPEN_DTTYPE B ON B.DTTYPE_ID    = F.DTTYPE_ID
		WHERE F.DEL_YN = 'N'
		ORDER BY F.COL_SEQ ASC
    </select>
   
   
      <!-- 바뀐것이 있나  확인하는 쿼리                          -->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <select id="selectUpdateCheck" parameterType="params" resultType="java.lang.Integer">
	    SELECT COUNT(1) AS "updateCnt"
	    FROM TB_OPEN_DTCHCK
		WHERE
    		DTTRAN_ID = #{dttranId}
    		AND ROW_SEQ = #{rowSeq}
    		AND DTCOLS_ID = (SELECT A.DTCOLS_ID FROM TB_OPEN_DTCOLS A
	    INNER JOIN TB_OPEN_DTTRAN B ON A.DTFILE_ID = B.DTFILE_ID
	    WHERE B.DTTRAN_ID =#{dttranId} AND A.COL_NM =#{colNm})
	    AND NOT(NULLCHCK_YN = #{nullchckYn} AND TYPECHCK_YN = #{typechckYn}  AND ADDR_TO_COORD_CD = #{addrToCoordCd})
    </select>
   
   
   <!-- dtcheckUpdate -->
    <update id="updateDtchckBydttranId" parameterType="params">
    	UPDATE TB_OPEN_DTCHCK
    	SET
    		DATA_VAL = #{dataVal},
    		NULLCHCK_YN = #{nullchckYn},
    		TYPECHCK_YN = #{typechckYn},
    		ADDR_TO_COORD_CD = #{addrToCoordCd}
    	WHERE
    		DTTRAN_ID = #{dttranId}
    		AND ROW_SEQ = #{rowSeq}
    		AND DTCOLS_ID = (SELECT A.DTCOLS_ID FROM TB_OPEN_DTCOLS A
	    INNER JOIN TB_OPEN_DTTRAN B ON A.DTFILE_ID = B.DTFILE_ID
	    WHERE B.DTTRAN_ID =#{dttranId} AND A.COL_NM =#{colNm})
    </update>
  
    <update id="updateDttranErrBydttranId" parameterType="params">
    	UPDATE TB_OPEN_DTTRAN
    	SET
    		ERR_CNT = (SELECT COUNT(1) FROM TB_OPEN_DTCHCK WHERE DTTRAN_ID =#{dttranId} AND NOT(NULLCHCK_YN = 'Y' AND TYPECHCK_YN = 'Y'  AND ( ADDR_TO_COORD_CD IN (
    			<foreach collection="addrSuccessCode" item="item" index="index" separator=",">#{item}</foreach>
    		) OR ADDR_TO_COORD_CD IS NULL)))
    		,CHCK_YN = (
    		CASE WHEN (SELECT COUNT(1) FROM TB_OPEN_DTCHCK WHERE DTTRAN_ID =#{dttranId} AND NOT(NULLCHCK_YN = 'Y' AND TYPECHCK_YN = 'Y'  AND ( ADDR_TO_COORD_CD IN (
    			<foreach collection="addrSuccessCode" item="item" index="index" separator=",">#{item}</foreach>
    		) OR ADDR_TO_COORD_CD IS NULL))) = 0 THEN 'Y' ELSE 'N' END
    		)
    		 
    	WHERE
    		DTTRAN_ID = #{dttranId}
    </update>
  	
</mapper>





<?xml version="1.0" encoding="UTF-8"?>
<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
<!-- @(#)AdminOpenDtcols_Sql_Tibero.xml 1.0 2015/06/01                       -->
<!--                                                                         -->
<!-- COPYRIGHT (C) 2013 WISEITECH CO., LTD. ALL RIGHTS RESERVED.             -->
<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
<!-- 데이터 컬럼을 관리하는 SQL 파일이다.                                    -->
<!--                                                                         -->
<!-- @author 김은삼                                                          -->
<!-- @version 1.0 2015/06/01                                                 -->
<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
<mapper namespace="egovframework.admin.data.dtfile.dao.OpenDtcolsDAO">
    
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- 데이터 컬럼을 검색한다.                                             -->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <select id="searchOpenDtcols" parameterType="params" resultType="record">
		WITH base_cols AS (
		    SELECT
		        A.DS_ID,
		        C.COL_EXP,
		        C.UNIT_CD,
		        C.SRC_COL_SIZE,
		        C.SRC_COL_TYPE,
		        C.SRC_COL_ID AS COL_ID,
		        C.NULL_YN,
		        C.V_ORDER
		    FROM TB_OPEN_INF A
		    JOIN TB_OPEN_DTFILE B ON A.INF_ID = B.INF_ID
		    JOIN TB_OPEN_DSCOL C ON A.DS_ID = C.DS_ID
		    WHERE B.DTFILE_ID = #{dtfileId}
		      <![CDATA[AND C.SRC_COL_ID <> 'DATA_COLCT_DE' ]]>
		),
		cols_info AS (
		    SELECT
		        A.DS_ID,
		        C.DTCOLS_ID,
		        C.DTFILE_ID,
		        C.COL_SEQ,
		        C.COL_EXP,
		        C.COL_NM,
		        C.DTTYPE_ID,
		        C.NULL_YN,
		        C.DATA_ALI,
		        C.DATA_FRM,
		        C.DEL_YN,
		        C.SQL_VERIFY,
		        C.SQL_CHCK_DESC,
		        ROW_NUMBER() OVER(ORDER BY C.COL_SEQ DESC) AS RN   -- 역순 번호 (1부터 시작)
		    FROM TB_OPEN_INF A
		    JOIN TB_OPEN_DTFILE B ON A.INF_ID = B.INF_ID
		    JOIN TB_OPEN_DTCOLS C ON B.DTFILE_ID = C.DTFILE_ID
		    WHERE C.DTFILE_ID = #{dtfileId}
		)
		SELECT
		    CASE WHEN B.DTCOLS_ID IS NULL THEN 'I' ELSE 'R' END AS "status",
		    B.DTCOLS_ID AS "dtcolsId",
		    COALESCE(B.DTFILE_ID, CAST(#{dtfileId} AS numeric)) AS "dtfileId",
		    COALESCE(B.COL_SEQ, B.RN) AS "colSeq",   -- 역순 번호를 그대로 사용
		    COALESCE(B.COL_EXP, A.COL_EXP) AS "colExp",
		    COALESCE(B.COL_NM, A.COL_ID) AS "colNm",
		    COALESCE(B.COL_NM, A.COL_ID) AS "colPnm",
		    B.DTTYPE_ID AS "dttypeId",
		    A.SRC_COL_SIZE AS "srcColSize",
		    (SELECT DITC_NM
		     FROM TB_COMM_CODE
		     WHERE GRP_CD = 'D1013'
		       AND DITC_CD = A.UNIT_CD) AS "unitCd",
		    COALESCE(B.NULL_YN, A.NULL_YN) AS "nullYn",
		    B.DATA_ALI AS "dataAli",
		    B.DATA_FRM AS "dataFrm",
		    COALESCE(B.DEL_YN, 'Y') AS "delYn",
		    A.SRC_COL_TYPE AS "type",
		    B.SQL_VERIFY AS "sqlVerify",
		    B.SQL_CHCK_DESC AS "sqlChckDesc"
		FROM base_cols A
		LEFT JOIN cols_info B
		       ON A.DS_ID = B.DS_ID
		      AND A.COL_ID = B.COL_NM
		ORDER BY A.V_ORDER
    </select>
    
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- 데이터 컬럼을 검색한다.(검증용)                                             -->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <select id="searchOpenDtcolsChck" parameterType="params" resultType="record">
        SELECT A.DTCOLS_ID 		AS "dtcolsId",
		       A.DTFILE_ID 		AS "dtfileId",
		       A.COL_SEQ 		AS "colSeq",
		       A.COL_EXP 		AS "colExp",
		       A.COL_NM 		AS "colNm",
		       A.DTTYPE_ID 		AS "dttypeId",
		       A.NULL_YN 		AS "nullYn",
		       A.DATA_ALI 		AS "dataAli",
		       A.DATA_FRM 		AS "dataFrm",
		       A.DEL_YN			AS "delYn",
			   D.SRC_COL_TYPE 	AS "type"
		   FROM TB_OPEN_DTCOLS A INNER JOIN TB_OPEN_DTFILE B
		   	ON A.DTFILE_ID = B.DTFILE_ID
		   	<if test='orgCd != null and orgCd == "6410000"'>
			    AND (A.DEL_YN      = 'N'  OR   (A.COL_NM IN ('DATA_REGIST_INST_NM', 'SIGUN_NM') AND EXISTS(SELECT 1 FROM TB_OPEN_DTCOLS C WHERE C.DTFILE_ID = A.DTFILE_ID AND C.COL_NM = 'DATA_REGIST_INST_NM')))
			</if>
			 <if test='orgCd != null and orgCd != "6410000"'>
			    AND A.DEL_YN      = 'N'
			</if>
		   INNER JOIN TB_OPEN_INF I
		   	ON B.INF_ID = I.INF_ID
		   LEFT OUTER JOIN TB_OPEN_DSCOL D
		   	ON I.DS_ID = D.DS_ID
		   	AND A.COL_NM = D.COL_ID
		  WHERE A.DTFILE_ID 	= #{dtfileId}
		  ORDER BY A.COL_SEQ ASC 
    </select>
    
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- 데이터 컬럼을 검색한다.(검증용)                                             -->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <select id="searchOpenDtcolsChckDataRegistInstNm" parameterType="params" resultType="record">
        SELECT A.DTCOLS_ID 		AS "dtcolsId",
		       A.DTFILE_ID 		AS "dtfileId",
		       A.COL_SEQ 		AS "colSeq",
		       A.COL_EXP 		AS "colExp",
		       A.COL_NM 		AS "colNm"
		   FROM TB_OPEN_DTCOLS A 
		   WHERE A.DTFILE_ID = #{dtfileId}
		   AND A.COL_NM = 'DATA_REGIST_INST_NM'
    </select>
    
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- 데이터 컬럼 스크립트를 검색한다.                                    -->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <select id="searchOpenDtcolsScr" parameterType="params" resultType="string">
        SELECT 
				A.COL_ID 	|| ' ' 		||
				A.SRC_COL_TYPE 			||
				CASE A.SRC_COL_TYPE WHEN 'CLOB' THEN ' '
									WHEN 'DATE' THEN ' '
									WHEN 'NUMBER' THEN '(' || A.SRC_COL_SIZE || DECODE(A.SRC_COL_SCALE,NULL,'',','||A.SRC_COL_SCALE) || ') '
									ELSE '(' || A.SRC_COL_SIZE || ') '
				END						||		 
				CASE A.PK_YN WHEN 'Y' THEN 'CONSTRAINT '||A.COL_ID||'_PK PRIMARY KEY '
							 ELSE ' '
				END						||
				CASE A.NULL_YN WHEN 'N' THEN 'NOT NULL '
							   ELSE ' '
				END
			FROM TB_OPEN_DSCOL A INNER JOIN TB_OPEN_INF B
				ON A.DS_ID = B.DS_ID
			INNER JOIN (SELECT DS_ID, INF_ID
							FROM TB_OPEN_INF
						WHERE INF_ID = #{infId}) C
				ON B.INF_ID = C.INF_ID
			INNER JOIN TB_OPEN_DS D
				ON C.DS_ID = D.DS_ID
			ORDER BY A.COL_SEQ
    </select>
        
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- 데이터 컬럼 템플릿을 검색한다.                                      -->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <select id="searchOpenDtcolsTpl" parameterType="params" resultType="record">
        SELECT A.COL_NM      AS "columnName",
               A.COL_EXP     AS "headerName",
               B.DATA_TY     AS "dataType",
               A.DATA_ALI    AS "dataAlign",
               A.DATA_FRM    AS "dataFormat"
          FROM TB_OPEN_DTCOLS A
          JOIN TB_OPEN_DTTYPE B
            ON B.DTTYPE_ID    = A.DTTYPE_ID
         WHERE A.DTFILE_ID    = #{dtfileId}
           AND A.DEL_YN       = 'N'
         ORDER BY
               A.COL_SEQ ASC
    </select>
    
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- 데이터 컬럼 템플릿 CSV용을 검색한다.                                      -->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <select id="searchOpenDtcolsTplCsv" parameterType="params" resultType="record">
        SELECT A.COL_EXP     AS "headerName"               
          FROM TB_OPEN_DTCOLS A
          JOIN TB_OPEN_DTTYPE B
            ON B.DTTYPE_ID    = A.DTTYPE_ID
        WHERE 1=1
        
        <choose>
            <when test='dtfileId != null and dtfileId != "" and dtfileId != "undefined"'>
                AND A.DTFILE_ID = #{dtfileId}::NUMERIC
            </when>
            <otherwise>
                AND A.DTFILE_ID = -1
            </otherwise>
        </choose>

        <if test='orgNm != null and orgNm == "경기도"'>
            AND (A.DEL_YN = 'N' OR (A.COL_NM IN ('DATA_REGIST_INST_NM', 'SIGUN_NM') 
                AND EXISTS(SELECT 1 FROM TB_OPEN_DTCOLS C WHERE C.DTFILE_ID = A.DTFILE_ID AND C.COL_NM = 'DATA_REGIST_INST_NM')))
        </if>
        <if test='orgNm != null and orgNm != "경기도"'>
            AND A.DEL_YN = 'N'
        </if>

        ORDER BY A.COL_SEQ ASC
    </select>
    
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- 데이터 컬럼 정의를 검색한다.                                        -->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <select id="searchOpenDtcolsDef" parameterType="params" resultType="record">
        SELECT A.COL_EXP     AS "Header",
               A.COL_NM      AS "SaveName",
               A.DATA_ALI    AS "Align",
               'Text'        AS "Type",
               0             AS "Edit",
               CASE REGEXP_REPLACE(A.DATA_FRM, '[^yMdHms]', '')
               WHEN 'yyyyMMddHHmmss' THEN 'YmdHms'
               WHEN 'yyyyMMddHHmm'   THEN 'YmdHm'
               WHEN 'yyyyMMdd'       THEN 'Ymd'
               WHEN 'yyyyMM'         THEN 'Ym'
               WHEN 'MMdd'           THEN 'Md'
               WHEN 'HHmmss'         THEN 'Hms'
               WHEN 'HHmm'           THEN 'Hm'
               ELSE A.DATA_FRM
               END           AS "Format"
          FROM TB_OPEN_DTCOLS A
          JOIN TB_OPEN_DTTYPE B
            ON B.DTTYPE_ID    = A.DTTYPE_ID
         WHERE A.DTFILE_ID    = #{dtfileId}
           <!-- AND A.DEL_YN       = 'N' -->
           AND (A.DEL_YN = 'N' OR (A.COL_NM IN ('DATA_REGIST_INST_NM','SIGUN_NM') 
           AND EXISTS(SELECT 1 FROM TB_OPEN_DTCOLS C WHERE C.DTFILE_ID = A.DTFILE_ID 
                      AND C.COL_NM = 'DATA_REGIST_INST_NM')))
         ORDER BY
               A.COL_SEQ ASC
    </select>
    
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- 데이터 컬럼 검증기를 검색한다.                                      -->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <select id="searchOpenDtcolsVal" parameterType="params" resultType="record">
        SELECT A.COL_SEQ     AS "colSeq"
             , A.COL_NM      AS "colNm"
             , A.COL_EXP     AS "colExp"
             , A.NULL_YN     AS "nullYn"
             , B.VERI_TY     AS "veriTy"
             , B.VERI_PAT    AS "veriPat"
             , B.DTTYPE_ID   AS "dttypeId"
             , A.DTCOLS_ID   AS "dtcolsId" 
             , A.SQL_VERIFY   AS "sqlVerify" 
          FROM TB_OPEN_DTCOLS A
               INNER JOIN TB_OPEN_DTTYPE B
                  ON B.DTTYPE_ID    = A.DTTYPE_ID
         WHERE A.DTFILE_ID    = #{dtfileId}
           AND(A.DEL_YN = 'N' OR (A.COL_NM IN ('DATA_REGIST_INST_NM','SIGUN_NM')
           										AND EXISTS(SELECT 1 FROM TB_OPEN_DTCOLS C WHERE C.DTFILE_ID = A.DTFILE_ID AND C.COL_NM = 'DATA_REGIST_INST_NM') 
           										AND (SELECT ORG_CD FROM TB_UPLOAD_SCHE WHERE UPL_SCH_NO = #{uplSchNo})='6410000' ) ) 
         ORDER BY
               A.COL_SEQ ASC
    </select>
    
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- 데이터 컬럼을 등록한다.                                             -->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <insert id="insertOpenDtcols" parameterType="params">
    <selectKey keyProperty="dtcolsId" resultType="string">
        SELECT SQ_DTCOLS_ID.NEXTVAL
          FROM DUAL
    </selectKey>
        INSERT INTO TB_OPEN_DTCOLS
               (
                   DTCOLS_ID,
                   DTFILE_ID,
                   COL_SEQ,
                   COL_NM,
                   COL_EXP,
                   DTTYPE_ID,
                   NULL_YN,
                   DATA_ALI,
                   DATA_FRM,
                   DEL_YN,
                   REG_ID,
                   REG_DTTM,
                   SQL_VERIFY,
                   SQL_CHCK_DESC
               )
        VALUES (
                   #{dtcolsId},
                   #{dtfileId},
                   #{colSeq},
<!--                    'COL_'||#{colSeq}, -->
				   #{colNm},
                   #{colExp},
                   #{dttypeId},
                   #{nullYn},
                   #{dataAli},
                   #{dataFrm},
                   'N',
                   #{regId},
                   NOW(),
                   #{sqlVerify},
                   #{sqlChckDesc}
               )
    </insert>
    
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- 데이터 컬럼을 수정한다.                                             -->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <update id="updateOpenDtcols" parameterType="params">
        UPDATE TB_OPEN_DTCOLS A
           SET A.COL_SEQ      = #{colSeq},
               A.COL_EXP      = #{colExp},
               A.DTTYPE_ID    = #{dttypeId},
               A.NULL_YN      = #{nullYn},
               A.DATA_ALI     = #{dataAli},
               A.DATA_FRM     = #{dataFrm},
               A.DEL_YN		  = #{delYn},
               A.UPD_ID       = #{updId},
               A.SQL_VERIFY	= #{sqlVerify},
               A.SQL_CHCK_DESC = #{sqlChckDesc},
               A.UPD_DTTM     = NOW()
         WHERE A.DTCOLS_ID    = #{dtcolsId}
    </update>
    
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- 데이터 컬럼 컬럼명을 수정한다.                                      -->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <update id="updateOpenDtcolsColNm" parameterType="params">
        UPDATE TB_OPEN_DTCOLS A
           SET A.COL_NM       = #{colNm}
         WHERE A.DTCOLS_ID    = #{dtcolsId}
           AND A.DEL_YN       = 'N'
    </update>
    
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- 데이터 컬럼을 삭제한다.                                             -->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <delete id="deleteOpenDtcols" parameterType="params">
        UPDATE TB_OPEN_DTCOLS A
           SET A.DEL_YN       = 'Y',
               A.UPD_ID       = #{updId},
               A.UPD_DTTM     = NOW()
         WHERE A.DTCOLS_ID    = #{dtcolsId}
           AND A.DEL_YN       = 'N'
    </delete>
    
    
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- 데이터 컬럼을 등록한다.(파일 등록시)              -2015-07-10 IJSHIN            -->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <insert id="insertOpenDtColumn" parameterType="record">
    <selectKey keyProperty="dtcolsId" resultType="string">
        SELECT SQ_DTCOLS_ID.NEXTVAL
          FROM DUAL
    </selectKey>
        INSERT INTO TB_OPEN_DTCOLS
               (
                   DTCOLS_ID,
                   DTFILE_ID,
                   COL_SEQ,
                   COL_NM,
                   COL_EXP,
                   NULL_YN,
                   DEL_YN,
                   REG_ID,
                   REG_DTTM
               )
        VALUES (
                   #{dtcolsId},
                   #{dtfileId},
                   #{colSeq},
                   #{colId},
                   #{colNm},
                   #{nullYn},
                   'N',
                   #{regId},
                   NOW()
               )
    </insert>
</mapper>




