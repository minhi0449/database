#실습 4-1
create database `Theater`;
create user 'theater'@'%' identified by '1234';
grant all privileges on Theater. * to 'theater'@'%';
flush privileges;


#실습 4-2
create table `Movies` (
	`movie_id`	    int primary key auto_increment,
    `title`		    varchar(30) not null,
    `genre`		    varchar(10) not null,
    `release_date`  date not null
);

create table `Customers`(
	`customer_id`	int primary key auto_increment,
    `name`			varchar(20) not null,
    `email`			varchar(50) not null,
    `phone`			char(13) not null
);

create table `Bookings` (
	`booking_id`	int primary key,
	`customer_id`	int not null,
	`movie_id`		int not null,
	`num_tickets`	int not null,
	`booking_date`	datetime not null
);

#실습 4-3
insert into `Movies` (`title`, `genre`, `release_date`) values ('쇼생크의 탈출','드라마','1994-10-14');
insert into `Movies` (`title`, `genre`, `release_date`) values ('타이타닉','로맨스','1997-03-24');
insert into `Movies` (`title`, `genre`, `release_date`) values ('탑건','액션','1987-07-16');
insert into `Movies` (`title`, `genre`, `release_date`) values ('쥬라기공원','액션','1994-02-11');
insert into `Movies` (`title`, `genre`, `release_date`) values ('글래디에이터','액션','2000-05-03');
insert into `Movies` (`title`, `genre`, `release_date`) values ('시네마천국','드라마','1995-04-12');
insert into `Movies` (`title`, `genre`, `release_date`) values ('미션임파서블','액션','1995-11-11');
insert into `Movies` (`title`, `genre`, `release_date`) values ('노트북','로맨스','2003-08-23');
insert into `Movies` (`title`, `genre`, `release_date`) values ('인터스텔라','SF','2011-05-26');
insert into `Movies` (`title`, `genre`, `release_date`) values ('아바타','SF','2010-02-10');

insert into `Customers` (`name`, `email`, `phone`) values ('김유신','kys@example.com','010-1234-1001');
insert into `Customers` (`name`, `email`, `phone`) values ('김춘추','kcc@example.com','010-1234-1002');
insert into `Customers` (`name`, `email`, `phone`) values ('장보고','jbg@example.com','010-1234-1003');
insert into `Customers` (`name`, `email`, `phone`) values ('강감찬','kgc@example.com','010-1234-1004');
insert into `Customers` (`name`, `email`, `phone`) values ('이순신','lss@example.com','010-1234-1005');

insert into `Bookings` values (101,1,1,2,'2023-01-10 00:00:00');
insert into `Bookings` values (102,2,2,3,'2023-01-11 00:00:00');
insert into `Bookings` values (103,3,2,2,'2023-01-13 00:00:00');
insert into `Bookings` values (104,4,3,1,'2023-01-17 00:00:00');
insert into `Bookings` values (105,5,5,2,'2023-01-21 00:00:00');
insert into `Bookings` values (106,3,8,2,'2023-01-21 00:00:00');
insert into `Bookings` values (107,1,10,4,'2023-01-21 00:00:00');
insert into `Bookings` values (108,2,9,1,'2023-01-22 00:00:00');
insert into `Bookings` values (109,5,7,2,'2023-01-23 00:00:00');
insert into `Bookings` values (110,3,4,2,'2023-01-23 00:00:00');
insert into `Bookings` values (111,1,6,1,'2023-01-24 00:00:00');
insert into `Bookings` values (112,3,5,3,'2023-01-25 00:00:00');

#실습 4-4
select title from `movies`;

#실습 4-5
select * from `movies` where `genre` = '로맨스';

#실습 4-6. 개봉일이 2010년 이후인 모든 영화의 제목과 개봉일을 조회하시오.
select 
	`title`,
    `release_date`
from `movies` where `release_date` > '2010-01-01';

#실습 4-7
select 
	`booking_id`, `booking_date`
from `Bookings` where `num_tickets` >= 3;

#실습 4-8
select * from Bookings where booking_date < '2023-01-20';

#실습 4-9
select * from Movies where release_date
between '1990-01-01' and '1999-12-31';

#실습 4-10. 가장 최근에 이루어진 예매 3건의 예약 ID와 예약일자를 조회하시오.
select * from bookings order by booking_date desc
limit 3;

#실습 4-11. 개봉일이 가장 오래된 영화의 제목과 개봉일을 조회하시오.
select title, release_date from Movies
order by release_date asc limit 1;

#실습 4-12. '액션' 장르의 영화 제목과 개봉일을 문자열 결합하여 조회하고, 제목에 '공원'이 포함된
		  #영화만 선택하여 개봉일 기준 오름차순으로 정렬한 후, 상위 1개만 조회하시오 (조건이 두개)
select 
	concat(title, '-', release_date) as movie_info
from Movies
where title like '%공원'
order by release_date asc
limit 1;

#실습 4-13. 고객 ID가 2인 고객이 한 예매의 예약일자와 예매한 영화 제목을 함께 조회하시오.
select booking_date, title
from Bookings
join Movies
using (movie_id) # 결합되는 컬럼이 똑같으니까 using 
where customer_id = 2;

#실습 4-14. 영화를 예매한 고객 이름, 휴대폰, 예매일자, 예매한 영화 제목을 조회하시오.
select
	`name`,
    `phone`,
    `booking_date`,
    `title`
from bookings b
join Customers c on b.customer_id = c.customer_id
join Movies M on b.movie_id = M.movie_id;


#실습 4-15. 장르별로 평균 예매 티켓 수를 조회하시오. 집계는 group by
select
	M.genre,
    avg(B.num_tickets) as avg_tickets
from bookings b
join movies M on b.movie_id = M.movie_id
group by M.genre;

#실습 4-16.고객별 평균 예매 티켓 수를 조회하시오.
SET SESSION sql_mode = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
select
	c.name,
    avg(b.num_tickets) as avg_tickets
from Bookgings B
join Customers C on B.customer.id = C.customer.id
group by C.customer_id;


#실습 4-17. 고객별 전체 예매 티켓 수가 가장 많은 고객순으로 이름과, 전체 티켓 수를 조회하시오.
select
	c.name,
    sum(b.num_ticket) as `전체 예매 티켓 수`
from bookings B
join Customers C on B.customer_id = C.customer_id
group by C.customer_id
order by `전체 예매 티켓 수` desc;



#실습 4-18
select 
	`booking_id`,
    `movie_id`,
    `name`,
    `booking_date`
from bookings B
join Customers C on b.customer_id = C.customer_id
order by B.booking_date asc
limit 1;


#실습 4-19. 각 영화의 장르별로 개봉일이 가장 최근인 영화의 제목을 조회하시오. 서브 쿼리
select 
	genre, title, release_date
from Movies
where (genre, release_date) in (
	select genre, max(release_date)
    from movies
    group by genre
    );

#실습 4-20 서브 쿼리 먼저 생각하기 이름이 김유신을 먼저 조회하자
select * from Movies
where movie_id in (
	select movie_id from bookings
    where customer_id = (select customer_id from Customers where `name` = '김유신')
);




#실습 4-21 예매한 영화 중 가장 많은 티켓을 예매한 고객의 이름과 이메일 조회하시오. 
SELECT name, email FROM Customers
WHERE customer_id = (
SELECT customer_id
FROM Bookings
GROUP BY customer_id
ORDER BY SUM(num_tickets) DESC
# 티켓이 큰 순서로 정렬
LIMIT 1
);

#실습 4-22. 예약된 티켓 수가 평균 예매 티켓 수보다 많은 예매정보를 조회하시오.
SELECT * FROM bookings
WHERE num_tickets > 
         # 여기가 평균 ↓
(SELECT AVG(num_tickets) FROM Bookings);

#실습 4-23. 각 영화별로 예매된 총 티켓 수를 조회하시오.
# 타이틀 가지고 그룹핑 하는 거 
SELECT
M.title, SUM(B.num_tickets) AS total_tickets
FROM Bookings B
JOIN Movies M ON B.movie_id = M.movie_id
GROUP BY M.title;

#실습 4-24. 각 고객별로 예매한 총 티켓 수와 평균 티켓 수를 조회하시오.
SELECT 
	c.name, 
	SUM(b.num_tickets) AS total_tickets, 
    AVG(b.num_tickets) AS avg_tickets
FROM Bookings b
JOIN Customers c ON b.customer_id = c.customer_id
GROUP BY c.name;

#이름으로 그룹을 해서 평균 구할 수 있다 


#실습 4-25. 예매 티켓 수가 가장 많은 고객의 아이디와 이름, 이메일을 조회하시오.
# 김유신 다 더하기 이름으로 그룹핑하고
SELECT
	c.customer_id,
	c.name,
	c.email,
SUM(b.num_tickets) AS `예매 티켓수`
FROM Bookings b
JOIN Customers c ON b.customer_id = c.customer_id
GROUP BY c.customer_id
# group by c.name
ORDER BY `예매 티켓수` DESC;


#실습 4-26. 예매된 티켓 수가 가장 큰 순서로 고객명, 영화제목, 예매 티켓수, 예매일을 조회하시오.
SELECT
c.name,
m.title,
b.num_tickets,
b.booking_date
FROM bookings b
JOIN customers c ON b.customer_id = c.customer_id
JOIN movies m ON b.movie_id = m.movie_id
ORDER BY num_tickets DESC;



# 실습 4-27. 장르가 '액션'이고 평균 예매 티켓 수가 가장 높은 순으로 영화의 제목을 조회하시오.





































