

-- INSTR() 
-- 문법 : INSTR(문자열, 찾을_문자열)
-- 역할 : 주어진 문자열에서 '찾고자 하는 문자열이 처음 등장하는 위치(index) 반환
-- 인덱스 기준 : 1부터 시작 (MySQL은 문자열 인덱스 1부터 )
-- 못 찾으면 : 0 반환

/*
	1. 기본문법
    INSTR(str, substr)
    • str: 검색 대상 문자열
    • substr : 찾고자 하는 부분 문자열
    
    2. 반환값(Return Value)
    • substr이 처음 나타나는 위치 발견 --> [결과] 1이상의 숫자 (index 위치, 1부터 시작)
    • substr이 존재하지 않을 경우 --> [결과] 0
    • str 또는 substr 이 NULL 일 경우 --> NULL    
    
    ✓ MySQL 에서는 문자열 인덱스를 1부터 센다.
    ✓ 0 은 '찾지 못했다' 는 의미
    ✓ NULL은 비교 자체가 불가능했음을 의미
*/

-- -----------------------------------------------------------------
-- -----------------------------------------------------------------


-- INSTR() 단독 사용

select instr('apple', 'p');
-- 결과 : 2

select instr('banana', 'na');
-- 결과 : 3
/*
	INSTR() 함수 핵심
    "일치하는 문자열의 시작위치만' 반환
    → 끝나는 위치나 전체 길이는 반환x
    
    • 'na'는 총 2글자 (즉, 길이 2)
    • 3번 인덱스에서 시작해서 4번까지 포함
    • 3~4번 → 'na' (첫 번째 등장)
    • 5~6번 → 'na' (두 번째 등장)
    --> 첫 번째 매치의 시작 위치만 반환
*/

-- 존재하지 않는 문자 검색
select instr('hello', 'z');
-- 결과 : 0

-- 숫자도 문자열처럼 취급됨
select instr('2025년 05월', '05');
-- result : 7

select instr(NULL, 'a');

-- -----------------------------------------------------------------

-- 3. INSTR() : 실무에서 자주 사용하는 함수와 조합

-- 3-1. INSTR() + WHERE 조건절
-- 'email' 컬럼에 '@gmail' 이 포함된 사용자 검색
select * from users
where instr(email, '@gmail') > 0;


-- last_name에 'an'이 포함된 직원 조회
select emp_no, first_name, last_name
from employees
where instr(last_name, 'an') > 0
limit 5; -- 상위 5개 행만 반환

select emp_no, first_name, last_name
from employees
where instr(last_name, 'an') > 0;

-- last_name에 'an'이 포함된 직원 조회 (사번 10010 미만 직원 조회)
select emp_no, first_name, last_name,
instr(last_name, 'an') as last_name__an
from employees
where emp_no < 10010;

-- 결과 해석
/*
    1. employees 테이블에서
    2. emp_no 가 10010 미만인 데이터 선택
    3. INSTR(last_name, 'an') 실행 결과
		• 'Facello' → an 없음 → 0
	10001 ~ 10009 사번의 last_name에 'an'
	모두 포함되지 않아서 
	INSTR() 함수 결과 --> 0
    
    ** NULL 이 아닌 0을 반환하는 이유:
    함수의 반환 타입이 정수이며, 존재하지 않음을 명시적 숫자값(0)으로 표현
    즉, false 나 NULL (x) / 0으로 실패를 표시
    
    ✰✰ 요약 ✰✰
    사용함수 | INSTR(last_name, 'an')
    결과 값 | 모두 0
    이유    | 'an'이라는 연속된 문자열이 last_name에 존재 x
    반환 0  | 반환 값 0의 의미 - 찾는 문자열이 존재 x
    NULL x | NULL이 아닌 이유 - INSTR() 은 항상 정수 반환. 실패 시 0 반환
*/


-- 이메일에 @gmail이 포함된 직원 조회
select emp_no, first_name, last_name, email
from employees
where INSTR(email, '@gmail') > 0;

-- 입사일(hire_date)이 ‘2000’이라는 문자열을 포함하는지 확인
select emp_no, first_name, hire_date,
instr(hire_date, '2000') as __2000__
from employees
where instr(hire_date, '2000') > 0
limit 10;


select first_name, instr(first_name, 'a') as instr_a 
from employees
where instr(first_name, 'a') > 0;


-- 4. INSTR() 위치 조합 예제

-- 4-1. @ 앞부분(아이디)만 추출
select substring('kim@.com', 1, instr('kim@.com', '@') -1);

-- substring(문자열, 시작위치 , 길이)













