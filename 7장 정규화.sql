# 날짜 : 2024/07/19
# 이름 : 김민희
# 내용 : 7장 정규화 실습하기

create table `BookOrder` (
	`orderNo` 		int,
	`orderDate`		date,
	`userId`		varchar(10),
	`userName`		varchar(10),
    `userAddr`		varchar(10),
	`bookNo`		int,
	`bookName`		varchar(20),
	`count`			int,
	`price`			int
);

insert into `bookorder` values (10001, now(), 'a101', '김유신', '김해',101,'프로그래밍',1,28000);
insert into `bookorder` values (10002, now(), 'a102', '김춘추', '경주',101,'프로그래밍',1,60000);
insert into `bookorder` values (10002, now(), 'a102', '김춘추', '경주',102,'자료구조',2,60000);
insert into `bookorder` values (10003, now(), 'a103', '장보고', '완도',102,'자료구조',2,320000);
insert into `bookorder` values (10004, now(), 'a104', '강감찬', '서울',102,'데이터베이스',1,25000);
insert into `bookorder` values (10005, now(), 'a105', '이순신', '서울',110,'데이터베이스',1,41000);
insert into `bookorder` values (10005, now(), 'a105', '이순신', '서울',102,'자료구조',1,41000);




































