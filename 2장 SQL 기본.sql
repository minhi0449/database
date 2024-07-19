#날짜 : 2024.07.01
#이름 : 김민희
#내용 : 2장 SQL 기본

#실습 2-1. 테이블 생성, 제거
use StudyDB;

CREATE TABLE `User1`(
	`uid`   VARCHAR(10),
    `name`  VARCHAR(10),
    `hp`    CHAR(13),
    `age`   int
    );
    
    DROP TABLE `User1`;
    
    #실습 2-2 데이터 영역
    SELECT * FROM `User1`;
    INSERT INTO `User1` VALUES	('A101','김유신','010-1234-1111',25);
    INSERT INTO `User1` VALUES	('A102','김춘추','010-1234-2222',23);
    INSERT INTO `User1` VALUES	('A103','장보고','010-1234-3333',32);
    INSERT INTO `User1` (`uid`,`name`,`age`) VALUES ('A104','강감찬','45');
    INSERT INTO `User1` SET
	`uid`='A105',
    `name`='이순신',
    `hp`='010-1234-5555';
    
    #실습 2-3 데이터 조회
    
    select * from `user1`;
    select * from `user1` where `uid`=`a101`;
    select * from `user1` where `name`=`김춘추`;
    select * from `user1` where `age` < 30;
    select * from `user1` where `age` >= 30;
    select `uid`, `name`, `age` from `user1`;
    
    #실습 2-4 데이터 수정
    update `user1` set `hp`='010-1234-4444' where `uid`='a104';
    update `user1` set `age`=54 where `uid`='a105';
    update `user1` set `hp`='010-1234-1001', `age`=27 where `uid`='a101';
    
    #실습 2-5 데이터 삭제
    set sql_safe_updates=0;
    delete from `user1` where `uid`='a101';
    delete from `user1` where `uid`='a102' and `age`=25;
    delete from `user1` where `age` >= 30;
     
    #실습 2-6 테이블 컬럼 수정
    alter table `user1` add `gender` tinyint;
    alter table `user1` add `birth` char(10) after `name`;
    alter table `user1` modify `gender` char(1);
    alter table `user1` modify `age` tinyint;
    alter table `user1` drop `gender`;
    
    #실습 2-7 테이블 복사
    create table `user1copy` like `user1`;
    insert into `user1copy` select * from `user1`;
    
    #실습 2-8 아래와 같이 테이블을 생성 후 데이터를 입력하시오.
    create table `TB1User1`(
	`user_id`    varchar(10),
    `user_name`  varchar(10),
    `user_hp`    char(13),
    `user_age`   int,
    `user_addr`  varchar(10)
    );
    
    SELECT * FROM `TB1User1`;
    INSERT INTO `TB1User1` VALUES	('p101','김유신','010-1234-1001', 25 , '경남 김해시');
    INSERT INTO `TB1User1` VALUES	('p102','김춘추','010-1234-1002', 23 , '경남 경주시');
    INSERT INTO `TB1User1` VALUES	('p103','장보고',null, 31 , '전남 완도군');
    INSERT INTO `TB1User1` VALUES	('p104','강감찬',null, null, '서울시 중구');
    INSERT INTO `TB1User1` VALUES	('p105','이순신','010-1234-1005', 50 , null);
    INSERT INTO `TB1User1` (`uid`,`name`,`hp`,`age`,`addr`) VALUES ('A101','김유신','25');
    
	create table `TB1Product`(
	`prod_no`       int,
    `prod_name`     varchar(10),
    `prod_price`    varchar(13),
    `prod_stock`    int,
    `prod_company`  varchar(10),
    `prod_date`     char(10)
    );
    
    SELECT * FROM `TB1Product`;
    INSERT INTO `TB1Product` VALUES	(1001,'냉장고','800,000', 25 , 'LG전자', '2022-01-06');
    INSERT INTO `TB1Product` VALUES	(1002,'노트북','1,200,000', 120 , '삼성전자', '2022-01-07');
    INSERT INTO `TB1Product` VALUES	(1003,'모니터','350,000', 35 , 'LG전자', '2022-01-13');
    INSERT INTO `TB1Product` VALUES	(1004,'세탁기','1,000,000', 80, '삼성전자', '2022-01-01');
    INSERT INTO `TB1Product` VALUES	(1005,'컴퓨터','1,500,000', 20 , '삼성전자', '2023-10-01');
    INSERT INTO `TB1Product` VALUES	(1006,'휴대폰','950,000', 102 , null, null);
    INSERT INTO `TB1Product` (`prod_no`,`prod_name`,`prod_price`,`prod_price`,`prod_stock`,`prod_company`, `prod_date`) VALUES ('','강감찬','45');

	
    
    select * from `Tb1User`;
    select `user_name` from `Tb1User`;
    select `user_name`, `user_hp` from `tb1user`;
    select * from `tb1user` where `user_id`=`p102`;
    select * from `tb1user` where `user_id`=`p104` or `p105`;
    select * from `tb1user` where `user_addr`='부산시 금정구';
    select * from `tb1user` where `user_age` > 30;
    select * from `tb1user` where `user_hp` is null;
    update `tb1user` set `user_age`=42 where `user_id` = 'p104';
    update `tb1user` set `user_addr`='부산시 진구' where `user_id`='p105';
    
    
    
     