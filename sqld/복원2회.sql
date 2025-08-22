create database if not exists sqld;

use sqld;

create table 2_tbl_19 (
	EMPNO int primary key, 
    NAME varchar(50),
    MANAGER int
);


INSERT INTO 2_tbl_19 (EMPNO, NAME, MANAGER) VALUES
(1, 'LIM', NULL),
(2, 'PARK', 1),
(3, 'KIM', 2);

-- 19. 아래의 TBL 테이블에 대해서 아래의 SQL문을 실행하였을 때의 결과건수는 ?

-- select lpad('**', (level-1)* 2, ' ') || empno as emp, name
-- from 2_tbl_19
-- where empno <> 3
-- start with empno = 3
-- connect by empno = prior manager;



-- 문자열 함수
-- SUBSTRING : 문자열 일부 추출
SELECT SUBSTRING('SQLD시험', 1, 4);  -- 결과: SQLD

-- CHAR_LENGTH : 문자열 길이
SELECT CHAR_LENGTH('SQLD');  -- 결과: 4

-- LOCATE : 특정 문자 위치 (Oracle의 INSTR)
SELECT LOCATE('시', 'SQLD시험');  -- 결과: 5

-- CONCAT : 문자열 연결
SELECT CONCAT('SQL', 'D');  -- 결과: SQLD

-- TRIM : 양쪽 공백 제거
SELECT TRIM('   SQLD   ');  -- 결과: SQLD

-- LTRIM : 왼쪽 공백 제거
SELECT LTRIM('   SQLD');  -- 결과: SQLD

-- RTRIM : 오른쪽 공백 제거
SELECT RTRIM('SQLD   ');  -- 결과: SQLD

-- REPLACE : 특정 문자 치환
SELECT REPLACE('SQLD', 'D', '시험');  -- 결과: SQL시험

-- LOWER / UPPER : 대소문자 변환
SELECT LOWER('SQLD');  -- 결과: sqld
SELECT UPPER('sqld');  -- 결과: SQLD


-- 숫자 함수
-- ROUND : 반올림
SELECT ROUND(123.456, 2);  -- 결과: 123.46

-- TRUNCATE : 버림
SELECT TRUNCATE(123.456, 2);  -- 결과: 123.45

-- MOD : 나머지
SELECT MOD(10, 3);  -- 결과: 1
SELECT 10 % 3;      -- 결과: 1 (동일)

-- CEIL / FLOOR : 올림 / 내림
SELECT CEIL(3.14);   -- 결과: 4
SELECT FLOOR(3.14);  -- 결과: 3

-- ABS : 절대값
SELECT ABS(-10);  -- 결과: 10

-- POWER : 거듭제곱
SELECT POWER(2, 3);  -- 결과: 8

-- SQRT : 제곱근
SELECT SQRT(9);  -- 결과: 3



-- 날짜 함수
-- NOW : 현재 날짜와 시간
SELECT NOW();  -- 결과: 2025-08-21 16:30:00 (실행 시점)

-- CURDATE / CURTIME : 현재 날짜, 현재 시간
SELECT CURDATE();  -- 결과: 2025-08-21
SELECT CURTIME();  -- 결과: 16:30:00

-- DATE_ADD : 날짜 더하기
SELECT DATE_ADD('2025-01-01', INTERVAL 2 MONTH);  -- 결과: 2025-03-01

-- DATE_SUB : 날짜 빼기
SELECT DATE_SUB('2025-01-01', INTERVAL 7 DAY);  -- 결과: 2024-12-25

-- DATEDIFF : 날짜 차이 (일 단위)
SELECT DATEDIFF('2025-01-10','2025-01-01');  -- 결과: 9

-- LAST_DAY : 달의 마지막 날
SELECT LAST_DAY('2025-02-10');  -- 결과: 2025-02-28

-- EXTRACT : 연/월/일 추출
SELECT EXTRACT(YEAR FROM NOW());   -- 결과: 2025
SELECT EXTRACT(MONTH FROM NOW());  -- 결과: 8
SELECT EXTRACT(DAY FROM NOW());    -- 결과: 21




