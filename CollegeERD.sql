# 날짜 : 2024/07/24
# 이름 : 김민희
# 내용 : 모델링 실습


# 실습 6-8lecture
insert into `Student` values ('20201011','김유신','010-1234-1001',3,'경남 김해시'); 
insert into `Student` values ('20201122','김춘추','010-1234-1002',3,'경남 경주시'); 
insert into `Student` values ('20200213','장보고','010-1234-1003',2,'전남 완도군'); 
insert into `Student` values ('20200324','강감찬','010-1234-1004',2,'서울 관악구'); 
insert into `Student` values ('20200415','이순신','010-1234-1005',1,'서울 종로구'); 

insert into `Lecture` values (101,'컴퓨터과학 개론',2,40,'본301');
insert into `Lecture` values (102,'프로그래밍 언어',3,52,'본302');
insert into `Lecture` values (103,'데이터베이스',3,56,'본303');
insert into `Lecture` values (104,'자료구조',3,60,'본304');
insert into `Lecture` values (105,'운영체제',3,52,'본305');

insert into `Register` values ('20220415',101,60,30,null,null);
insert into `Register` values ('20210324',103,54,36,null,null);
insert into `Register` values ('20201011',105,52,28,null,null);
insert into `Register` values ('20220415',102,38,40,null,null);
insert into `Register` values ('20210324',104,56,32,null,null);
insert into `Register` values ('20210213',103,48,40,null,null);


SELECT 
	`stdNo`,
	`stdName`,
	SUM(`lecCredit`) AS `이수학점`
FROM `Student` AS a
JOIN `Register` AS b ON a.stdNo = b.regStdNo
JOIN `Lecture`  AS c ON b.regLecNo = c.lecNo
where `regGrade` <> 'F'
group by `stdNo`;

# 실습 6-9
select 
	`stdNo`,`stdName`,`stdHp`,`stdYear`
from 
`student` as a
join `register` as b on a.stdNo = b.regStdNo
join `lecture` as c on b.regLecNo = c.lecNo;










