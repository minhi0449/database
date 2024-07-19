# 날짜 : 2024/07/12
# 이름 : 김민희 
# 내용 : SQL 연습문제 5


#실습 5-1
create database `BookStore`;
create user 'bookstore'@'%' identified by '1234';
grant all privileges on `BookStore`. * to 'bookstore'@'%';
flush privileges;

#실습 5-2
create table `Customer` (
	`custId` 	int primary key auto_increment,
    `name`		varchar(10) not null,
	`address`	varchar(20),
    `phone`	 	varchar(13)
);

create table `Book` (
	`bookId` 	int primary key,
    `bookName`	varchar(20) not null,
	`publisher`	varchar(20) not null,
    `price`	 	int
);

create table `Order`(
	`orderId`	int primary key auto_increment,
    `custId`	int not null,
    `bookId`	int not null,
    `salePrice` int not null,
    `orderDate` datetime not null
);

#실습 5-3
insert into `Customer` (`name`, `address`, `phone`) values ('박지성','영국','000-5000-0001');
insert into `Customer` (`name`, `address`, `phone`) values ('김연아','대한민국 서울','000-6000-0001');
insert into `Customer` (`name`, `address`, `phone`) values ('장미란','대한민국 강원도','000-7000-0001');
insert into `Customer` (`name`, `address`, `phone`) values ('추신수','미국 클리블랜드','000-8000-0001');
insert into `Customer` (`name`, `address`, `phone`) values ('박세리','대한민국 대전',null);


insert into `Book` values (1,'축구의 역사','굿스포츠',7000);
insert into `Book` values (2,'축구아는 여자','나무수',13000);
insert into `Book` values (3,'축구의 이해','대한미디어',22000);
insert into `Book` values (4,'골프 바이블','대한미디어',35000);
insert into `Book` values (5,'피겨 교본','굿스포츠',8000);
insert into `Book` values (6,'역도 단계별기술','굿스포츠',6000);
insert into `Book` values (7,'야구의 추억','이상미디어',20000);
insert into `Book` values (8,'야구를 부탁해','이상미디어',13000);
insert into `Book` values (9,'올림픽 이야기','삼성당',7500);
insert into `Book` values (10,'Olympic Champions','pearson',13000);



insert into `Order` (`custId`, `bookId`, `salePrice`, `orderDate`) values (1,1,6000,'2014-07-01');
insert into `Order` (`custId`, `bookId`, `salePrice`, `orderDate`) values (1,3,21000,'2014-07-01');
insert into `Order` (`custId`, `bookId`, `salePrice`, `orderDate`) values (2,5,8000,'2014-07-01');
insert into `Order` (`custId`, `bookId`, `salePrice`, `orderDate`) values (3,6,6000,'2014-07-01');
insert into `Order` (`custId`, `bookId`, `salePrice`, `orderDate`) values (4,7,20000,'2014-07-01');
insert into `Order` (`custId`, `bookId`, `salePrice`, `orderDate`) values (1,2,12000,'2014-07-01');
insert into `Order` (`custId`, `bookId`, `salePrice`, `orderDate`) values (4,8,13000,'2014-07-01');
insert into `Order` (`custId`, `bookId`, `salePrice`, `orderDate`) values (3,10,12000,'2014-07-01');
insert into `Order` (`custId`, `bookId`, `salePrice`, `orderDate`) values (2,10,7000,'2014-07-01');
insert into `Order` (`custId`, `bookId`, `salePrice`, `orderDate`) values (3,8,13000,'2014-07-01');


#실습 5-4
select `custId`, `name`, `address` from `customer`;

#실습 5-5
select `bookname`, `price` from `book`;

#실습 5-6
select `price`, `bookname` from `book`;

#실습 5-7
select * from `book`;

#실습 5-8
select `publisher` from `book`;

#실습 5-9
select distinct `publisher` from `book`;

#실습 5-10
select * from `book` where `price` >= 20000;

#실습 5-11
select * from `book` where `price` < 20000;

#실습 5-12
select * from `book` where `price` between 10000 and 20000;

#실습 5-13
SELECT `bookId`, `bookName`,`price` 
FROM `Book` 
WHERE `price` between 15000 and 30000;


#실습 5-14
select * from `book` where `bookid` in(2,3,5);

#실습 5-15
select * from `book` where bookId % 2 = 0;

#실습 5-16
select * from `Customer` where `name` like '박%';

#실습 5-17
select * from `Customer` where `address` like '대한민국%';

#실습 5-18
select * from `Customer` where `phone` is not null;

#실습 5-19
select * from `Book` where `publisher` = '굿스포츠' or `publisher` = '대한미디어' ;

#실습 5-20
select `publisher` from `book` where `bookName` = '축구의 역사';

#실습 5-21
select `publisher` from `book` where `bookName` like '축구%';

#실습 5-22
select * from `book` where substr(`bookName`,2, 1) = '구';
select * from book where bookName like '_구%';

#실습 5-23
select * from `book` where `bookname` like '축구%' and `price` >= 20000;

#실습 5-24
select * from `book` order by `bookname`;

#실습 5-25
select * from `book` order by `price`, `bookname`;
# 우선순위 가격 먼저

#실습 5-26
select * from `book` order by `price` desc, `publisher` asc;

#실습 5-27
select * from `book` order by `price` desc limit 3;

#실습 5-28
select * from `book` order by `price` limit 3;

#실습 5-29
select sum(`salePrice`) as `총 판매액` from `Order` ;

#실습 5-30
select 
	sum(salePrice) as `총 판매액`,
	avg(salePrice) as `평균값`,
	min(salePrice) as `최저가`,
    max(salePrice) as `최고가`
from `order`;

#실습 5-31
select count(*) as `판매건수` from `order`;

#실습 5-32 문자열 변경 
select 
	 `bookId`,
replace(`bookName`, '야구','농구') as `bookName`,
	 `publisher`,
	 `price`
from `Book`;

#실습 5-33
SET SESSION sql_mode = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
select 
	`custId`,
    count(*) as `수량`
from `order`
where `salePrice` >= 8000
group by `custId`
having `수량` >= 2;

#실습 5-34
select * from `Customer` as a
join `Order` as b on a.custId = b.custId;

#실습 5-35
#실습 5-36
select 
	`name`,
    `salePrice`
from `customer` as a
join `order` as b on a.custId = b.custId;

#실습 5-37 고객별로 주문한 모든 도서의 총 판매액을 조회하고, 고객별로 정렬하시오.
select 
	`name`,
    sum(`salePrice`)
from `Customer` as a
join `Order` as b on a.custId = b.custId
group by `name`
order by `name`;

#실습 5-38.고객의 이름과 고객이 주문한 도서의 이름을 조회하시오.
select 
	`name`,
    `bookname`
from `customer` as a
join `order` as b on a.custId = b.custId
join `book` as c on b.bookId = c.bookId;


#실습 5-39.가격이 20,000원인 도서를 주문한 고객의 이름과 도서의 이름을 조회하시오.
select 
	`name`,
    `bookname`
from `customer` as a
join `order` as b on a.custId = b.custId
join `book` as c on b.bookId = c.bookId
where `salePrice` = 20000;

#실습 5-40.도서를 구매하지 않은 고객을 포함해서 고객명과 주문한 도서의 판매가격을 조회하시오.
# 주문한 내역이 없지만 left join
select 
	`name`, `saleprice` 
from `customer` as a
left join `order` as b on a.custId = b.custId ;

#실습 5-41
select
	sum(`saleprice`) as `총 매출`
from `customer` as a
join `order` as b on a.custId = b.custId
where `name` = '김연아'; 


#실습 5-42
select `bookName` from `Book` order by `price` desc limit 1;

#실습 5-43
select 
	`name` 
from `customer` as a
left join `order` as b on a.custId = b.custId
where `orderId` is null;

#실습 5-44
#insert into `book` set `bookId` = 11, `bookname` = '스포츠의학', `publisher` ='한솔의학서적';


#실습 5-45
#update `customer` set `address` = '대한민국 부산' where `custId` = 5;


#실습 5-46
#delete from `customer` where `custId` = 5;














