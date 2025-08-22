
-- 1. 기본 SELECT 문
-- 모든 사용자 조회
select * from Users;
# * 모든 열(컬럼)을 의미 (애스터리스크)


-- 2. 특정 열 선택하기
-- 사용자의 이름과 이메일만 조회
select username, email, country from users; 


-- 3. WHERE 절로 필터링
-- 대한민국 사용자만 조회하기
SELECT username, full_name, email # 이 세 열만 선택하기
FROM Users # User 테이블에서 데이터를 가져옴
WHERE country = '대한민국'; # country 열의 값이 '대한민국'인 행만 선택



-- 4. ORDER BY 로 정렬하기
-- 노래를 재생 횟수 기준으로 내림차순 정렬
select song_title, artist_id, play_count
from songs
order by play_count desc;
# play_count 열을 기준으로 내림차순(높은값부터) 정렬

select version();

