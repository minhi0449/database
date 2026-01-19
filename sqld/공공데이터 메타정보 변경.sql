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

    
WITH ColumnInfo AS (
    SELECT COL_NM, COL_EXP, COL_SEQ
    FROM TB_OPEN_DTCOLS 
    WHERE DTFILE_ID = ${dtfileId} AND DEL_YN = 'N'
    ORDER BY COL_SEQ
)
SELECT 
    ROW_NUMBER() OVER () AS "rowSeq",
    -- 각 컬럼을 개별적으로 선택
    t.*,
    'Y' AS "nullchckYn",
    'Y' AS "typechckYn", 
    'Y' AS "addrToCoordYn",
    '' AS "errCd",
    '' AS "errDesc",
    'N' AS "delYn"
FROM ${tableName} t
ORDER BY 1;


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


/* 1. 하드코딩 없이 dttran_id와 dtfile_id를 연결하여 
   2. 원본 테이블(tb_nature_park_m)의 4,000건 이상 데이터를 
   3. 상세 그리드 포맷(rowSeq, colSeq, dataVal)으로 Unpivot 조회 */

WITH ColList AS (
    /* 화면에 보여줄 7개 컬럼 정보를 미리 세팅 */
    SELECT col_nm, col_seq 
    FROM tb_open_dtcols 
    WHERE dtfile_id = '3331' AND del_yn = 'N'
),
RawData AS (
    /* 실제 데이터 4,000건+ (날짜 에러를 피하기 위해 dttran_id 기준으로 직접 조회) */
    /* ※ tb_nature_park_m에 dttran_id 컬럼이 없다면 'no' 기준으로 전체 조회 */
    SELECT *, ROW_NUMBER() OVER (ORDER BY no) as row_num 
    FROM tb_nature_park_m
    -- 날짜 컬럼 에러 방지를 위해 조건을 완화하거나 실제 존재하는 컬럼으로 대체하세요.
    -- WHERE dat_crtr_ymd = '20251114'
)
SELECT 
    R.row_num AS "rowSeq",
    C.col_seq AS "colSeq",
    /* JSON 변환으로 CASE문 4,000개 만드는 노가다 방지 (최적화) */
    (row_to_json(R)->>lower(C.col_nm)) AS "dataVal",
    'Y' AS "nullchckYn",
    'Y' AS "typechckYn",
    'Y' AS "addrToCoordYn"
FROM RawData R
CROSS JOIN ColList C
ORDER BY R.row_num ASC, C.col_seq ASC;


