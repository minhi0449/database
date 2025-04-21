
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
select lower(song_title) as song_lower from songs;

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
select substring('abcedf', 2, 3) as result;
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
select substring('user@example.com', position('@' in 'user@example.com')+1) as domain;
-- 결과 : example.com

-- 예시 2: 전화번호 마스킹
-- 개인정보 보호를 위해 전화번호 뒷자리를 마스킹할 때:
select concat(substring('010-1234-5678', 1, 8), '****') as masked_phone;
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
select substring(email, 1, locate('@', email) -1) as email_id
from users;

-- 생일에서 월만 보기
select substring(birth_date, 6, 2) 
as birth_month 
from users;

-- 노래 제목 미리 보기
select substring(song_title, 1, 5) as title_preview
from songs;










