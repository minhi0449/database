


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
select nullif(0, 0); -- 결과: NULL (0 = 0 이므로)
select nullif(NULL, 0); -- 결과 : NULL (NULL ≠ 0이지만 첫 번째가 NULL)







