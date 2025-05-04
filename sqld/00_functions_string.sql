
-- 파일명: 00_functions_string.sql
-- 설명: MySQL 문자열 관련 함수 예제 모음


-- ============================================================
-- CONCAT () - 문자열 연결 함수 (발음 : 콘캣)
-- ============================================================
-- 설명 : 두 개 이상의 문자열을 연결합니다.
-- 
-- 사용법 : CONCAT(문자열1, 문자열2, ..., 문자열N)
-- ============================================================

select concat('안녕', '하세요') as 인사말;
-- 결과 : '안녕하세요'

-- 여러 문자열과 숫자 연결하기
SELECT CONCAT('이름 : ', '홍길동', ', 나이 : ', 25) as 사용자정보;
-- 결과 : 이름 : 홍길동, 나이 : 25


-- NULL 값이 포함되면 전체 결과가 NULL이 됩니다ㅣ.
SELECT CONCAT('안녕', NULL, '하세요') as 인사말_NULL_포함;
-- 결과 : NULL

-- 연습문제 1 -1 : 사용자 이름과 이메일을 한 줄로 붙여 출력하기
SELECT CONCAT(username, ' (', email, ')') AS user_info
FROM Users;

select concat(user_id, ' by  ', birth_date) as 생년월일
from users;


-- 연습문제 1-2 : 사용자 전체 이름과 생일을 이어서 출력 (예: 김음악.  1996-10-11)
select concat(full_name, ' -     ', birth_date) 
as name_with_birth
from users;

-- 1-3 : 노래 제목과 아티스트 명을 출력하기
select concat(song_title, ' by ', artist_name) as song_and_artist
from songs
join artists on songs.artist_id = artists.artist_id;

-- -----------------------------------------------------------------------

-- 2. LOWER() 연습문제 (소문자로 변환)

-- 2-1. 모든 사용자 이메일을 소문자로 변환해서 보기
select lower(email) as lowercase_email
from users;

select lower(artist_name) as 아티스트_이름_소문자
from artists;

-- 2-2. 노래 제목이 모두 대소문자 섞여있을 때, 통일해서 소문자로 정리
SELECT 
    LOWER(song_title) AS song_lower
FROM
    songs;

-- 2-3. 국가명을 모두 소문자로 통일해서 보여주기
select lower(country) as 국가명_소문자 
from users;

-- -----------------------------------------------------------------------
-- -----------------------------------------------------------------------

-- 3. SUBSTRING() 연습문제 (문자열의 일부를 추출, 시작 위치와 길이 지정)
/*
	SUBSTRING(문자열, 시작위치, 길이)
    · 문자열 : 자르고 싶은 문자열 또는 컬럼명 (email, 'hello' 등)
    · 시작위치 : 몇 번째 글자부터 자를지 (1부터 시작!)
    · 길이 : 몇 글자를 자를지 (생략가능)
    
	* 실제 사용 예시
    1. 이메일에서 도메인 추출
    2. 전화번호 마스킹
    
    * 주의할 점
    1. 시작 위치는 1부터 ! (0 아님)
    2. 음수 사용은 MySQL 에서 안됨 -> Oracle 이나 NoSQL 쪽에서만 가능
    3. LOCATE()랑 같이 사용하면 훨씬 강력
*/

-- -----------------------------------------------------------------------

-- 예제
-- [오류] SUBSTRING('abcdef', 2, 3);
-- 이유 : SQL 에서는 함수를 단독으로 실행할 수 없고, SELECT 문 안에서 사용해야 함
SELECT SUBSTRING('abcedf', 2, 3) AS result;
-- 결과 : bce
-- substring(문자열, 시작위치, 길이)
-- 시작위치 : 2 (b부터 시작) / 길이 : 3 (2부터 3,4) 까지 자르기

--       ✓ 시작위치에서 3글자 
-- | a | b | c | d | e | f |
--       ↑   ↑   ↑

-- -----------------------------------------------------------------------

-- 실제 사용 예시

-- 예시 1: 이메일에서 도메인 추출
-- 이메일 주소에서 '@' 다음의 도메인 부분만 추출하고 싶을 때
SELECT 
    SUBSTRING('user@example.com',
        POSITION('@' IN 'user@example.com') + 1) AS domain;
-- 결과 : example.com

-- 예시 2: 전화번호 마스킹
-- 개인정보 보호를 위해 전화번호 뒷자리를 마스킹할 때:
SELECT CONCAT(SUBSTRING('010-1234-5678', 1, 8), '****') AS masked_phone;
/*
	
	결과 : 010-1234****
    
    왜 결과가 '010-1234****' 인가?
    가장 중요한 부분은 '010-1234-5678' 에서 1번째부터 8글자만 잘라내면 '010-1234' 가 됨
    
    1. SQL 에서 SUBSTRING() 함수는 시작 위치 (1)부터 지정한 길이 (8)만큼 문자열을 잘라냅니다.
    2. '010-1234-5678' 에서 첫 8글자는 '010-1234' (- 하이픈도 한글자로 계산!)
    3. CONCAT() 함수로 '010-1234' 와 '****' 를 이어붙이면 '010-1234' 가 됨
    4. 결과적으로 원래 있었던 두 번째 하이픈(-)이 잘려나가서 나타나지 않게 된거임
	
/*



-- -----------------------------------------------------------------------

-- 3-1. 이메일 앞에 아이디 부분만 추출 (예: music@example.com --> music)
select substring(email, 1, locate('@', email) -1) as email_id
from users;

/*
	LOCATE('@', email): @가 어디 있는지 위치를 찾아줘
    SUBSTRING(email, 1, 그 위치 -1 ): 맨 앞부터    
*/


-- 이메일 ID만 보기
SELECT 
    SUBSTRING(email,
        1,
        LOCATE('@', email) - 1) AS email_id
FROM
    users;

-- 생일에서 월만 보기
SELECT 
    SUBSTRING(birth_date, 6, 2) AS birth_month
FROM
    users;

-- 노래 제목 미리 보기
SELECT 
    SUBSTRING(song_title, 1, 5) AS title_preview
FROM
    songs;



-- ============================================================
-- UPPER() - 문자열을 대문자로 변환 (발음 : 어퍼)
-- ============================================================
-- 설명 : 모든 문자를 대문자로 변환합니다.
-- 
-- 사용법 : UPPER(문자열)

/*
	* 실무 활용:
    - 검색 기능에서 대·소문자 구분 없이 검색할 때
    - 데이터 정규화(표준화)가 필요할 때, 
    - 코드나 식별자를 표준 형식으로 저장할 때
*/

-- ============================================================


-- 기본 사용법 
SELECT UPPER('hello world') AS 대문자_결과;
-- 결과 : HELLO WORLD


-- 혼합된 문자열 대문자로 반환
SELECT UPPER('Hello World 123') AS 대문자_결과;
-- 결과 : HELLO WORLD 123


-- 한글은 영향 없음
select upper('안녕하세요 Hello') as 대문자_결과;
-- 결과 : 안녕하세요 HELLO
-- cmd + d : 되지 않는 경우 - 한글 포함 문자열
-- -> 내부 포맷터가 한글을 처리 못하는 경우 있음 (버그 수준이지만 흔함)


-- 연습문제 4-1. 모든 아티스트 이름을 대문자로 표시하기
select artist_name, upper(artist_name) as 대문자_이름 from Artists;

-- 연습문제 4-2. 노래 제목을 대문자로 변환하여 표시하기
select song_title, upper(song_title) as 대문자_제목
from songs;

-- 연습문제 4-3. 사용자 이름을 모두 대문자로 변환하기
select username, upper(username) as 대문자_사용자명 from users;


-- 4-4. UPPER() 를 사용하여 이메일 도메인 대문자로 변환하기

select username, email, 
concat(substring_index(email, '@', 1), '@',
upper(SUBSTRING_INDEX(email, '@', -1)) ) as '변환된 이메일'
from users;

/*

	1. select username, email: users 테이블에서 username과 email 열을 선택
    2. concat(...): 세 부분을 이어붙입니다.
    2-1. substring_indec(email, '@', 1) : 이메일에서 '@' 앞부분(사용자명) 추출
    2-2. '@' : '@' 기호를 그대로 사용합니다.
    2-3. upper(SUBSTRING_INDEX(email, '@', -1)) : 이메일에서 '@' 뒷부분(도메인)을
		 추출하고 대문자로 변환
	
    SUBSTRING_INDEX() : 특정문자를 기준으로 문자열을 나누고, 원하는 부분만 가져오는 함수
						두 번째 매개변수(-1): 음수일 경우 오른쪽에서 부터 찾습니다.
*/


-- ============================================================
-- TRIM() - 문자열 앞뒤 공백 제거 (발음: 트림)
-- ============================================================
-- 설명: 문자열의 앞뒤 공백을 제거합니다.
-- 
-- 사용법: TRIM(문자열)
/*
	응용: 
	LTRIM() - 왼쪽(앞) 공백만 제거
	RTRIM() - 오른쪽(뒤) 공백만 제거
	TRIM([BOTH|LEADING|TRAILING] [제거할문자] FROM 문자열)
*/
-- ============================================================


-- 기본 사용법
SELECT TRIM('    Hello World    ') AS 공백_제거_결과;
-- 결과: 'Hello World'

-- 왼쪽 공백만 제거
SELECT LTRIM('    Hello World    ') AS 왼쪽_공백_제거;
-- 결과: 'Hello World   '

-- 오른쪽 공백만 제거
SELECT RTRIM('    Hello World    ') AS 오른쪽_공백_제거;
-- 결과: '   Hello World'


-- 고급 기능 : TRIM() 함수는 공백 외에도 다른 문자를 제거할 수 있습니다.

-- 특정 문자 제거 (양쪽 'x' 제거)
SELECT TRIM(BOTH 'x' FROM 'xxxHello Worldxxx') AS 특정문자제거;
-- 결과: 'Hello World'

-- 특정 문자 왼쪽만 제거
SELECT TRIM(LEADING 'x' FROM 'xxx_Hello World_xxx') AS '왼쪽_문자_(x)_제거';
-- 결과: 'Hello Worldxxx'

-- 특정 문자 오른쪽만 제거
SELECT TRIM(TRAILING 'x' FROM 'xxx_Hello World_xxx') AS '오른쪽_문자_(x)_제거'; 
-- 결과: 'xxxHello World'

/*
	실무 활용:
    • 사용자 입력값 정제(사용자가 실수로 공백을 넣은 경우)
	• 파일에서 가져온 데이터 정리
    • 검색 기능에서 정확한 검색을 위한 전처리
*/

-- 포맷팅 / 코드 정렬 단축키 : cmd + B

-- ----------------------------------------------------------------


-- ============================================================
-- REPLACE() - REPLACE(대상문자열, 바꿀문자, 새문자)
-- ============================================================
-- 설명 : 문자열 안의 특정 단어를 다른 단어로 바꿉니다.
-- 
-- 사용법 : REPLACE(대상문자열, 바꿀문자, 새문자)
--          → 대상문자열 안에서 바꿀문자를 새문자로 변경
-- ============================================================



-- 1-1. 이메일 주소에서 'example' 을 'sample' 로 바꾸기
SELECT 
    REPLACE(email, 'example', ' sample ') AS update_email
FROM
    users;

-- 설명 : 이메일 주소 중 'example' --> 'sample' 로 바꿔서 보여줌


-- 1-2. 노래 제목에서 점(.) 을 없애기
select replace(song_title, '.', '') as clean_title_
from songs;
-- 설명 : 노래 제목 안에 있는 '.'(점)을 모두 삭제 해서 깔끔하게 만들어 줍니다.


-- 1-3. 사용자 이름(full_name) 에서 공백(' ')을 하이픈('-') 으로 바꾸기
select replace(full_name, ' ', '-') as name_with_dash
from users;
-- 설명 :이름 안의 빈칸을 '-' 로 바꿔서 연결된 형태로 보여줌





-- ============================================================
-- 지정한 길이만큼 문자열을 반환하는 함수 - LEFT(), RIGHT()
-- ============================================================
-- LEFT() 함수는 문자열의 왼쪽 부터,
-- RIGHT() 함수는 문자열의 오른쪽부터 정의한 위치만큼 문자열을 반환
-- ============================================================
-- 설명 : 문자열 안의 특정 글자나 단어를 다른 글자나 단어로 바꿉니다.
-- 
-- 사용법 : REPLACE(대상문자열, 바꿀문자, 새문자)
--          → 대상문자열 안에 있는 바꿀문자를 새문자로 변경
-- ============================================================
-- ============================================================
-- LEFT() - 레프트 (발음: 레-프트)
-- ============================================================
-- 설명 : 문자열의 왼쪽(처음)부터 지정한 수만큼 글자를 가져옵니다.
-- 
-- 사용법 : LEFT(문자열, 글자수)
--          → 문자열의 왼쪽에서 글자수를 만큼 잘라냅니다.
-- ============================================================


-- 연습문제
-- 1. 이메일 주소 왼쪽 5글자 가져오기
select left(email, 5) as email_start_5
from users;
-- 설명 : 이메일 주소 맨 왼쪽부터 5글자만 잘라서 보여줍니다.alter



-- 2. 노래 제목 앞 3글자만 보여주기
select left(song_title, 3) as '노래제목 앞 3글자'
from songs;


-- 3. 국가명 왼쪽 2글자만 가져오기
select left(country, 2) as country_short from users;



-- 4. Songs 테이블에서 노래 제목 중 'Love'를 'Heart' 로 바꾸는 쿼리
select song_id, song_title, 
replace(song_title, 'Love', 'Heart') as modified_title
from songs
where song_title like '%Love%';




-- ============================================================
-- RIGHT() - 라이트 (발음: 라-이트)
-- ============================================================
-- 설명 : 문자열의 오른쪽(끝)부터 지정한 수만큼 글자를 가져옵니다.
-- 
-- 사용법 : RIGHT(문자열, 글자수)
--          → 문자열의 오른쪽에서 글자수만큼 잘라냅니다.
-- ============================================================


-- 연습문제
-- 1. 이메일 주소 오른쪽 4글자 가져오기
select right(email, 4) as 'email__4'
from users;
-- 설명 : 이메일 주소 끝에서 4글자만 잘라서 보여줍니다. (.com 같은 것)


-- 2. 노래 제목 오른쪽 2글자 가져오기
select right(song_title, 2) as song_end_2
from songs;

-- 3. 사용자 이름 (full_name) 오른쪽 1글자만 보여주기
select right(full_name, 1) as last_char_name
from users;


-- ============================================================
-- REPEAT() - 리핏
-- ============================================================
-- 설명  : 문자열 여러 번 반복하기
-- 
-- 사용법 : REPEAT(문자열, 반복할 횟수) 
--          → 반복할 대상, 몇 번 반복할지 숫자
/*
	1. 문자열 등장
    2.'몇 번 반복할래 ?' 정하기
    3. 그만큼 복붙 복붙 복붙해서 결과 만듬
*/
-- ============================================================


-- 연습문제
-- 1. "Hi"를 5번 반복해 출력해보자!
select repeat("Hi ", 5) as repeated_hi;


select username, repeat(username, 2) as double_username
from users;


-- 1-1. REPEAT() 와 구분자 함께 사용 
select username, repeat(concat(username, ' | '), 2) as double_username22
from users;


-- 1.2. 문자열 연결 연산자 사용 (MySQL 에서는 CONCAT 사용)
select username, username || ' * ' || username as double_username
from users;
/*
	|| : MySQL 에서는 '논리 OR' 연산자 입니다.
		 문자열을 합치는 연산자가 아님
         (발음 : 버티컬 바 / vertical bar)
    
    
*/

select username, concat(username, ' * ', username) as double_username
from users;

-- ------------------------------------------------------------------
-- 일반적인 SQL 문자열 함수 활용 예시 (실무)

-- 1. 데이터 정제(Cleaning)
-- 사용자 입력에서 불필요한 공백과 특수문자 제거
SELECT 
    song_title AS original_title,
    TRIM(REPLACE(REPLACE(song_title, ',', ''), '.', '')) AS clean_title
FROM
    songs
WHERE
    song_title LIKE '%.%' OR song_title LIKE '%,%';


/*
	1. select song_title as original_title
	   : 원래 노래 제목 가져옴

	2. TRIM(REPLACE(REPLACE(song_title, ',', ''), '.', ''))
    
		: 가장 안쪽: REPLACE(song_title, ',', '') - 먼저 쉼표를 제거합니다.
		  중간: REPLACE(첫번째_결과, '.', '') - 그 결과에서 마침표를 제거합니다.
		  바깥쪽: TRIM(두번째_결과) - 마지막으로 앞뒤 공백을 제거합니다.

*/

