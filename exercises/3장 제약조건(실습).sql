# 날짜 : 2024.07.02
# 3장 : 제약조건alter

#실습 3-1 기본키 실습하기

create table `user2-1`(
	`uid`	varchar(10) primary key,
    `name`	varchar(10),
    `birth`	char(10),
    `addr`	varchar(50)
);

#실습 3-2 user2-1 데이터 추가하기
select * from `user2-1`;
insert into `user2-1` values ('A101', '김유신', '1968-05-09', '경남 김해시');
insert into `user2-1` values ('A102', '김춘추', '1972-11-23', '경남 경주시');
insert into `user2-1` values ('A103', '장보고', '1978-03-01', '전남 완도군');
insert into `user2-1` values ('A104', '강감찬', '1979-08-16', '서울시 관악구');
insert into `user2-1` values ('A105', '이순신', '1981-05-23', '부산시 진구');

#실습 3-3 고유키 실습하기 
create table `user3-1`(
	`uid`	varchar(10) primary key,
    `name`	varchar(10),
    `birth`	char(10),
    `hp`	char(13) unique,
    `addr`	varchar(50)
);

#실습 3-4 user3-1 데이터 추가하기

insert into `user3-1` values ('A101', '김유신', '1968-05-09', '010-1234-1001', '경남 김해시');
insert into `user3-1` values ('A102', '김춘추', '1972-11-23', '010-1234-1002', '경남 경주시');
insert into `user3-1` values ('A103', '장보고', '1978-03-01', '010-1234-1003', '전남 완도군');
insert into `user3-1` values ('A104', '강감찬', '1978-08-16', '010-1234-1004', '서울시 관악구');
insert into `user3-1` values ('A105', '이순신', '1981-05-23', '010-1234-1005', '부산시 진구');

#실습 3-5 외래키 실습하기
create table `parent-1`(
	`pid`	varchar(10) primary key,
    `name`	varchar(10),
    `birth`	char(10),
    `addr`	varchar(100)
);

create table `child-1`(
	`cid`	varchar(10) primary key,
    `name`	varchar(10),
    `hp`	char(13) unique,
    `parent`varchar(10),
    foreign key (`parent`) references `parent` (`pid`)
);

#실습 3-6 parent-1, child-1  데이터 추가하기
insert into `parent-1` values ('P101', '김유신', '1968-05-09', '경남 김해시');
insert into `parent-1` values ('P102', '김춘추', '1972-11-23', '경남 경주시');
insert into `parent-1` values ('P103', '장보고', '1978-03-01', '전남 완도시');
insert into `parent-1` values ('P104', '강감찬', '1979-08-16', '서울시 관악구');
insert into `parent-1` values ('P105', '이순신', '1981-05-23', '부산시 진구');

insert into `child-1` values ('C101', '김철수', '010-1234-1001', 'P101');
insert into `child-1` values ('C102', '김영희', '010-1234-1002', 'P101');
insert into `child-1` values ('C103', '강철수', '010-1234-1003', 'P103');
insert into `child-1` values ('C104', '이철수', '010-1234-1004', 'P105');


#실습 3-7 

create table `user4-1`(
	`uid`	 varchar(10) primary key,
    `name`	 varchar(10) not null,
    `gender` char(1),
    `age`	 int default 1,
    `hp`     char(13) unique,
    `addr`	 varchar(20)
);

#실습 3-8 user4-1 데이터 추가하기 
insert into `user4-1` values ('A101', '김유신', 'M', '25', '010-1234-1111', '경남 김해시');
insert into `user4-1` values ('A102', '김춘추', 'M', '23', '010-1234-2222', '경남 경주시');
insert into `user4-1` values ('A103', '장보고', 'M', '35', '010-1234-3333', '전남 완도시');
insert into `user4-1` values ('A104', '강감찬', 'M', '42', '010-1234-4444', '서울시 관악구');
insert into `user4-1` values ('A105', null , 'M', null , '010-1234-5555', '부산시 진구');
insert into `user4-1` values ('A106', '신사임당', 'F', '32', null , '강릉시');
insert into `user4-1` values ('A107', '허난설현', 'F', '27', null , '경기도 광주시');

#실습 3-9
create table `user5-1`(
	`seq`	int primary key auto_increment,
    `name`	varchar(10) not null,
    `gender` char(1) check (`gender` in ('M', 'F')),
    `age`   int default 1 check (`age` > 0 and `age` < 100),
    `addr`  varchar(20)
);

#실습 3-10 데이터 추가하기

insert into `user5-1`(`name`, `gender`, `age`, `addr`) values ('김유신', 'M', '25', '경남 김해시');
insert into `user5-1`(`name`, `gender`, `age`, `addr`) values ('김춘추', 'M', '23', '경남 경주시');
insert into `user5-1`(`name`, `gender`, `age`, `addr`) values ('장보고', 'M', '35', '전남 완도시');
insert into `user5-1`(`name`, `gender`, `age`, `addr`) values ('강감찬', 'M', '42', '서울시 관악구');
insert into `user5-1`(`name`, `gender`, `age`, `addr`) values ('이순신', 'A', '51', '부산시');
insert into `user5-1`(`name`, `gender`, `age`, `addr`) values ('신사임당', 'F', '-1', '강릉시');





