#날짜 : 2024/07/03
#이름 : 김민희
#내용 : 4장 SQL 고급


#실습 4-1
CREATE TABLE `Member` (
	`uid`	VARCHAR(10) PRIMARY KEY,
	`name`	VARCHAR(10) NOT NULL,
	`hp`	CHAR(13) UNIQUE NOT NULL,
	`pos`	VARCHAR(10) default '사원',
	`dep`	TINYINT,
	`rdate`	DATETIME  NOT NULL
);

CREATE TABLE `Department` (
	`depNo`	TINYINT PRIMARY KEY,
	`name`	VARCHAR(10) NOT NULL,
	`tel`	CHAR(12) NOT NULL
);

CREATE TABLE `Sales` (
	`no`	INT AUTO_INCREMENT PRIMARY KEY,
	`uid`	VARCHAR(10) NOT NULL,
	`year`	YEAR NOT NULL,
	`month`	TINYINT NOT NULL,
	`sale`	INT
);


#실습 4-2
INSERT INTO `Member` VALUES ('a101', '박혁거세', '010-1234-1001', '부장', 101, '2024-07-03 14:33:21');
INSERT INTO `Member` VALUES ('a102', '김유신',   '010-1234-1002', '차장', 101, NOW());
INSERT INTO `Member` VALUES ('a103', '김춘추',   '010-1234-1003', '사원', 101, NOW());
INSERT INTO `Member` VALUES ('a104', '장보고',   '010-1234-1004', '대리', 102, NOW());
INSERT INTO `Member` VALUES ('a105', '강감찬',   '010-1234-1005', '과장', 102, NOW());
INSERT INTO `Member` VALUES ('a106', '이성계',   '010-1234-1006', '차장', 103, NOW());
INSERT INTO `Member` VALUES ('a107', '정철',     '010-1234-1007', '차장', 103, NOW());
INSERT INTO `Member` VALUES ('a108', '이순신',   '010-1234-1008', '부장', 104, NOW());
INSERT INTO `Member` VALUES ('a109', '허균',     '010-1234-1009', '부장', 104, NOW());
INSERT INTO `Member` VALUES ('a110', '정약용',   '010-1234-1010', '사원', 105, NOW());
INSERT INTO `Member` VALUES ('a111', '박지원',   '010-1234-1011', '사원', 105, NOW());

INSERT INTO `Department` VALUES (101, '영업1부', '051-512-1001');
INSERT INTO `Department` VALUES (102, '영업2부', '051-512-1002');
INSERT INTO `Department` VALUES (103, '영업3부', '051-512-1003');
INSERT INTO `Department` VALUES (104, '영업4부', '051-512-1004');
INSERT INTO `Department` VALUES (105, '영업5부', '051-512-1005');
INSERT INTO `Department` VALUES (106, '영업지원부', '051-512-1006');
INSERT INTO `Department` VALUES (107, '인사부', '051-512-1007');

INSERT INTO `Sales` (`uid`, `year`, `month`, `sale`) VALUES ('a101', 2018, 1,  98100);
INSERT INTO `Sales` (`uid`, `year`, `month`, `sale`) VALUES ('a102', 2018, 1, 136000);
INSERT INTO `Sales` (`uid`, `year`, `month`, `sale`) VALUES ('a103', 2018, 1,  80100);
INSERT INTO `Sales` (`uid`, `year`, `month`, `sale`) VALUES ('a104', 2018, 1,  78000);
INSERT INTO `Sales` (`uid`, `year`, `month`, `sale`) VALUES ('a105', 2018, 1,  93000);

INSERT INTO `Sales` (`uid`, `year`, `month`, `sale`) VALUES ('a101', 2018, 2,  23500);
INSERT INTO `Sales` (`uid`, `year`, `month`, `sale`) VALUES ('a102', 2018, 2, 126000);
INSERT INTO `Sales` (`uid`, `year`, `month`, `sale`) VALUES ('a103', 2018, 2,  18500);
INSERT INTO `Sales` (`uid`, `year`, `month`, `sale`) VALUES ('a105', 2018, 2,  19000);
INSERT INTO `Sales` (`uid`, `year`, `month`, `sale`) VALUES ('a106', 2018, 2,  53000);

INSERT INTO `Sales` (`uid`, `year`, `month`, `sale`) VALUES ('a101', 2019, 1,  24000);
INSERT INTO `Sales` (`uid`, `year`, `month`, `sale`) VALUES ('a102', 2019, 1, 109000);
INSERT INTO `Sales` (`uid`, `year`, `month`, `sale`) VALUES ('a103', 2019, 1, 101000);
INSERT INTO `Sales` (`uid`, `year`, `month`, `sale`) VALUES ('a104', 2019, 1,  53500);
INSERT INTO `Sales` (`uid`, `year`, `month`, `sale`) VALUES ('a107', 2019, 1,  24000);

INSERT INTO `Sales` (`uid`, `year`, `month`, `sale`) VALUES ('a102', 2019, 2, 160000);
INSERT INTO `Sales` (`uid`, `year`, `month`, `sale`) VALUES ('a103', 2019, 2, 101000);
INSERT INTO `Sales` (`uid`, `year`, `month`, `sale`) VALUES ('a104', 2019, 2,  43000);
INSERT INTO `Sales` (`uid`, `year`, `month`, `sale`) VALUES ('a105', 2019, 2,  24000);
INSERT INTO `Sales` (`uid`, `year`, `month`, `sale`) VALUES ('a106', 2019, 2, 109000);

INSERT INTO `Sales` (`uid`, `year`, `month`, `sale`) VALUES ('a102', 2020, 1, 201000);
INSERT INTO `Sales` (`uid`, `year`, `month`, `sale`) VALUES ('a104', 2020, 1,  63000);
INSERT INTO `Sales` (`uid`, `year`, `month`, `sale`) VALUES ('a105', 2020, 1,  74000);
INSERT INTO `Sales` (`uid`, `year`, `month`, `sale`) VALUES ('a106', 2020, 1, 122000);
INSERT INTO `Sales` (`uid`, `year`, `month`, `sale`) VALUES ('a107', 2020, 1, 111000);

INSERT INTO `Sales` (`uid`, `year`, `month`, `sale`) VALUES ('a102', 2020, 2, 120000);
INSERT INTO `Sales` (`uid`, `year`, `month`, `sale`) VALUES ('a103', 2020, 2,  93000);
INSERT INTO `Sales` (`uid`, `year`, `month`, `sale`) VALUES ('a104', 2020, 2,  84000);
INSERT INTO `Sales` (`uid`, `year`, `month`, `sale`) VALUES ('a105', 2020, 2, 180000);
INSERT INTO `Sales` (`uid`, `year`, `month`, `sale`) VALUES ('a108', 2020, 2,  76000);


#실습 4-3
select * from `Member` where `name` = '김유신';
#이름이 김유신인 직원 조회

select * from `Member` where `name` <> '김춘추';
#이름이 김춘추가 아닌 직원 전부 조회

select * from `Member` where `pos` in ('사원','대리');
#지급이 사원,대리만 조회 해라

select * from `Member` where `name` like '%신';
#신으로 끝나는 이름 조회

select * from `Member` where `name` like '정_';
#정으로 시작하는 이름이 두글자 (이름이 세글자인 정약용 조회x)

select * from `Member` where `pos`='차장' and dep=101;
#dep가 101인데 직급이 차장인 직원 조회

select * from `Member` where `name`!= '김춘추';
select * from `Member` where `pos`='사원' or `pos`='대리';
select * from `Member` where `dep` in(101,102,103);
select * from `Menber` where `name` like '_성_';

#실습 4-4
#select * from `Sales`; 기본키

select * from `Sales` order by `sale`;
#select * from `Sales` order by `sale` ASC; 위에거랑 같은 말 오름차순

select * from `Member` order by `name`; #가나다순
select * from `Member` order by `name`  DESC;

select * from `Member` order by `rdate` asc;
select * from `Sales` Where `sale` > 50000 order by `sale` desc; 

select * from `Sales` 
where `sale` > 50000 
order by `year`, `month`, `sale` DESC;

#실습 4-5
select * from `Sales` limit 3;
select * from `Sales` limit 0, 3;
select * from `Sales` limit 1, 2;
select * from `Sales` limit 5, 3;



#실습 4-6
select sum(sale) as `합계` from `Sales`;
select count(*) as `갯수` from `Sales`;
#count(all)이라는 뜻임

select concat('Hello', 'World') as `결과`;
select concat(`uid`, `name`, `hp`) from `member` where `uid`='a108';
select now();
insert into `Member` 
values ('a112','유관순','010-1234-1012','대리','107',now());

select avg(sale) as `평균` from `Sales`;
select max(sale) as `최대값` from `Sales`;
select min(sale) as `최소값` from `Sales`;
select ceiling(1.2);
select ceiling(1.8);
select floor(1.2);
select floor(1.8);
select round(1.2);
select round(1.8);
select rand(); # 0~1 사이의 임의의 실수
select ceiling(rand() * 10);
select count(sale) as `갯수` from `Sales`;
select count(*) as `갯수` from `Sales`;

select left('HelloWorld', 5);
select right('HelloWorld', 5);
select substring('HelloWorld', 6, 5);
select concat('Hello', 'World');
select concat(`uid`, `name`, `hp`) from `member` where `uid`='a108';

select curdate(); #현재 날짜 조회
select curtime();
select now();
insert into `Member` values ('a113', '유관순', '010-1234-1012', '대리', '107', now());

select * from `Sales` 
where `sale` > 50000 
order by `year`, `month`, `sale` DESC;

select * from `Sales` where `sale` > 50000 order by `year`, `month`, `sale` DESC;

#실습 4-7 2018년 1월 매출의 총합을 구하시오.
select sum(`sale`) as `합계` from `Sales`;
select sum(`sale`) as `2018 1월 매출 총 합계` from `Sales` where `year`=2018 and `month`=1;



#실습 4-8 2019년 2월에 5만원 이상 매출에 대한 총합과 평균을 구하시오.
select 
sum(`sale`) as `총합`, 
avg(`sale`) as `평균`
from `Sales`
where 
`year`= 2019 and
`month`= 2 and
`sale` >= 50000;


#실습 4-9 2020년 전체  매출 가운데 최저, 최고 매출을 구하시오.
select
	min(`sale`) as `최저매출`,
	max(`sale`) as `최저매출`
from `Sales`
where `year`=2020;



#실습 4-10
SET SESSION sql_mode = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
select * from `Sales` group by `uid`;
select * from `Sales` group by `uid`, `year`;
select `uid`, sum(`sale`) as `합계` from `Sales` group by `uid`;
#a101 모든 매출 합친거

select `uid`, count(*) as `건수` from `Sales` Group by `uid`;
#건수만 그룹으로 데이터 조회
select `uid`, sum(sale) as `합계` from `Sales` group by `uid`;
select `uid`, avg(sale) as `평균` from `Sales` group by `uid`;

select `uid`, `year`, sum(sale) as `합계`
from `Sales`
group by `uid`, `year`;

select `uid`, `year`, sum(sale) as `합계`
from `Sales`
group by `uid`, `year`
order by `year` ASC, `합계` DESC;


#실습 4-11
select `uid`, sum(sale) as `합계` from `Sales`
group by `uid`
having `합계` >= 200000;


select `uid`, `year`, sum(sale) as `합계`
from `Sales`
where `sale` >= 100000
group by `uid`, `year`
having `합계` >= 200000
order by `합계` DESC;


#실습 4-12
create table `Sales2` like `Sales`; #테이블 복사
insert into `Sales2` select * from `Sales`;

set sql_safe_update=0; #조건없이 update 실행(모드 해제)
update `Sale2` set `year` = `year` + 3;

select * from `Sales` where `sale` >= 100000
UNION
select * from `Sales2` where `sale` >= 100000;

#select `uid`, `year, `sale` from Sales
UNION
select `uid`, `year`, `sale` from Sale2;

select `uid`, `year`, `sale` from sales
UNION
select `uid`, `year`, `sale` from sales2;

select `uid`, `year`, sum(sale) as `합계`
from `Sales`
group by `uid`, `year`
UNION
select `uid`, `year`, sum(sale) as `합계`
from `Sales2`
group by `uid`, `year`
order by `year` asc, `합계` desc;

#실습 4-13
select * from `Sales` inner join `Member` on `Sales` .`uid` = `Member`.`uid`;
#기준테이블은 항상 왼쪽

select * from `Sales` as a 
join `Member` as b
on a.uid = b.uid;
#join절에서 별칭 주는 거임 / 다 쓰면 너무 기니까
#매칭되는 컬럼명이 동일 

select * from `Sales` as a 
join `Member` as b
using (`uid`); # =on a.uid = b.uid; 와 같음 
# 매칭되는 컬럼명이 같으면 using 으로 써도 됨

select
	a.`no`,
    a.`uid`,
    a.`sale`,
    b.`name`,
    b.`pos`
from `Sales` as a 
join `Member` as b
using (`uid`);
#원하는 것만 선별해서 진행

select * from `Member` as a
join `Department` as b
on a.dep = b.depNO;
#매칭되는 컬럼 이름이 다름 (rdate까지 `Member`)

select * from `Sales` as a join `Member` as b on a.uid = b.uid;
select * from `Member` as a join `Department` as b on a.dep = b.depNO;

select * from `Sales` as a,
`Member` as b
where a.uid = b.uid;

select * from `Member` as a,
`Department` as b 
where a.dep = b.depNO;

select a.`no`, a.`uid`, a.`sale`, b.`name`, b.`pos`
from `Sales` as a join `Member` as b on a.`uid` = b.`uid`;

SELECT a.`no`, a.`uid`, a.`sale`, b.`name`, b.`pos`, c.`name` FROM `Sales` AS a
JOIN `Member` AS b ON a.uid = b.uid
JOIN `Department` AS c ON b.dep = c.depNo
WHERE `sale` > 100000
ORDER BY `sale` DESC;

#실습 4-14
select * from `Sales` as a left join `Member` as b on a.uid = b.uid;
#이너 조인 : 교집합  
#보통 서로 교차되는 데이터만 조인

select * from `Sales` as a right join `Member` as b on a.uid = b.uid;
#매출이 없는 직원도 나옴 오른쪽 테이블을 기준으로 잡음 (한쪽에 있는 데이터가 다 나와야 함)

select a.no, a.uid, `sale`, `name`, `pos` from Sales as a
left join member as b using(uid);

select a.no, a.uid, `sale`, `name`, `pos` from Sales as a
right join member as b using(uid);


select * from `Member` where `pos`='차장' and dep=101;
#dep가 101인데 직급이 차장인 직원 조회

SELECT 
	a.`no`, 
	a.`uid`, 
    a.`sale`, 
    b.`name`, 
    b.`pos`, 
    c.`name` 
FROM `Sales` AS a
JOIN `Member` AS b ON a.uid = b.uid
JOIN `Department` AS c ON b.dep = c.depNo
WHERE `sale` > 100000
ORDER BY `sale` DESC;

#실습 4-15 모든 직원의 아이디, 이름, 직급, 부서명을 조회하시오.

select 
	a.`no`, 
	a.`uid`, 
    b.`name`, 
    b.`pos`, 
    c.`name` 
from `Sales` as a
join `Member` as b on a.uid = b.uid
join `Department` as c on b.dep = c.depNo
where `sale` > 100000
order by `sale` DESC;

#실습 4-15 모든 직원의 아이디, 이름, 직급, 부서명을 조회하시오.
select 
	`uid`,
    a.`name` as  `직원명`,
    `pos`,
    b.`name` as `부서명`
from `Member` as a
join `department` as b
on a.dep = b.depNO;

#실습 4-16 
select
	a.`uid`,
	  `name`,
	sum(`sale`) as `2019년도 매출합`
from `Sales` as a
join `Member` as b
on a.uid = b.uid
where 
	`year`='2019' and
    `name`='김유신';

#실습 4-17. 
#2019년 50,000이상 매출에 대해 직원별 
#매출의 합이 100,000원 이상인 
#직원이름, 부서명, 직급, 년도, 매출 합을 조회하시오.
#(단, 매출 합이 큰 순서 부터 정렬)

select 
	b.`name`,
    c.`name`,
    `pos`,
    `year`,
	sum(`sale`) as `합계`
from `Sales`
join `Member` as b on a.uid = b.uid
join `Department` as c on b.dep = c.depNo
where `year`=2019 and `sale` >= 50000
group by `uid`
having `합계` >= 100000
order by `합계` desc
limit 2; #우수직원 최우수직원 2명만 선정

