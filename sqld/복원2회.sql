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







