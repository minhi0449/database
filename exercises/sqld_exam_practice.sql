


-- SQLD 시험 대비
-- MySQL employees 테이블 실전 쿼리 예제

use employees;

-- ==========================================================================
-- 1. 기본 SELECT 문 (Basic SELECT Statements)
-- ==========================================================================

-- 1-1. 전체 직원 조회 (모든 컬럼)
-- 용도: 테이블의 전체 데이터 구조와 내용을 파악할 때 사용
SELECT * 
FROM employees;

-- 1-2. 특정 컬럼만 조회 (성능 최적화를 위해 필요한 컬럼만 선택)
-- 용도: 필요한 정보만 선별적으로 가져와 네트워크 트래픽과 메모리 사용량 절약
SELECT emp_no, first_name, last_name, hire_date 
FROM employees;

-- 1-3. DISTINCT를 사용한 중복 제거
-- 용도: 중복된 값을 제거하여 고유한 값들만 조회
SELECT DISTINCT
    gender
FROM
    employees;

-- ==========================================================================
-- 2. WHERE 절을 활용한 조건부 조회 (Conditional Queries - 조건부 쿼리)
-- ==========================================================================

-- 2-1. 단일 조건 검색 (특정 성별의 직원만 조회)
-- 용도: 하나의 조건에 맞는 데이터 필터링
SELECT 
    emp_no, first_name, last_name, gender
FROM
    employees
WHERE
    gender = 'F';
    
-- 2-2. 날짜 범위 검색 (특정 기간에 입사한 직원들)
-- 용도: 특정 날짜 범위에 해당하는 데이터 조회 (인사팀에서 연도별 입사자 현황 파악 시 활용)
select emp_no, first_name, last_name, gender, hire_date
from employees
where gender = 'M'
and hire_date >= '1995-01-01';

-- NVL (값, 대체값) : 값이 NULL 이면 대체값 사용
SELECT IFNULL(NULL, '대체값') AS null_handing; -- 결과 : 대체값
select ifnull('값', '대체값') as NULLIF; -- 결과 : 값
SELECT IFNULL(NULL, NULL);
SELECT NULLIF(0, 0); -- 결과: NULL (0 = 0 이므로)
SELECT NULLIF(NULL, 0); -- 결과 : NULL (NULL ≠ 0이지만 첫 번째가 NULL)



select NVL(salary, 0) from employees;



-- COALESCE(값1, 값2, 값3, ...)
-- 왼쪽부터 차례대로 검사해서 NULL이 아닌 첫 번째 값을 찾으면 그 값을 반환
-- 모든 값이 NULL 이면 NULL 을 반환

-- -----------------------------------------------------------------------------

select emp_no, 
concat(first_name, ' ', last_name) as full_name -- 이름과 성을 합쳐서 full_name 컬럼 생성
from employees
limit 5;


-- DATEDIF(날짜1, 날짜2)
-- 결과 : `날짜1 - 날짜2`
SELECT DATEDIFF('2025-05-29', '2025-05-01');
SELECT DATEDIFF('5/29', '5/1');

-- -----------------------------------------------------------------------------

-- 날짜 함수
-- NOW 

-- 현재 날짜와 시간
select now() as current_datetime;
-- 결과 : 2025-05-30 00:11:55

-- 2. 로그 기록용
select concat('접속시간: ', now()) as log_entry;
-- 결과 : 접속시간: 2025-05-30 00:11:23

-- 3. 시스템 시간 확인
select '시스템 현재 시간', now() as system_time;

-- -----------------------------------------------------------------------------

-- DATE() - 데이트, 날짜 부분만 추출
-- 날짜 시간에서 날짜 부분만 뽑아내는 함수

-- 1. 현재 날짜만 
select date(now()) as today;
-- 결과 : 2025-05-30

-- 2. 특정 시간에서 날짜만
select date('2025-12-25 23:59:59') as christmas;


-- 3. 생년월일에서 날짜만
select date('1999-09-09 00:00:00') as birth_date; 

-- -----------------------------------------------------------------------------

-- DATEDIFF() - 데이트디프, 날짜 차이 계산
-- 두 날짜 사이의 일수를 계산하는 함수

-- 1. 오늘부터 크리스마스까지
select DATEDIFF('2025-12-25', '2025-05-30') as days_to_christmas;
-- 결과 : 209

-- 2. 나이 계산(일 단위)
select DATEDIFF('2025-05-30', '1996-10-11');
-- 결과 : 10458

-- 3. 프로젝트 기간
select datediff('2024-06-30', '2024-06-01');

-- -----------------------------------------------------------------------------

-- YEAR() - 이어, 연도 추출
-- 1. 현재 연도
select year(now()) as current_year;

-- 2. 생년 추출
select year('1990-03-15') as birth_year;

-- 3. 입사 년도
select year('2022-09-01 00:00:00') as join_year;

-- -----------------------------------------------------------------------------

-- DAY() - 데이, 일 추출
-- 날짜에서 일(1-31)만 추출하는 함수

-- 1. 현재 일
select day(now()) as current_day;
-- 결과 : 30

-- 2. 생일 일 
select day('1999-05-17') as birth_day;
-- 결과 : 17

-- 3. 월급날
select day('2024-05-25') as payday;
-- 결과 : 25

-- -----------------------------------------------------------------------------

-- DATE_FORMAT() - 데이트 포맷, 날짜 형식 변경
-- 날짜를 원하는 형태로 변경해주는 함수

-- 1. 한국 날짜 형식
select date_format(NOW(), '%y년 %m월 %d일') as korean_date;
-- 결과 : 25년 05월 30일

select date_format(NOW(), '%Y년 %m월 %d일') as korean_date;
-- 결과 : 2025년 05월 30일

-- 2. 시간 포함 형식
select date_format(now(), '%Y-%M-%D %h:%i:%s') as full_datetime;
-- 결과 : 2025-May-30th 12:35:30
