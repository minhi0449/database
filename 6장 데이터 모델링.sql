# 날짜 : 2024/07/15
# 이름 : 김민희
# 내용 : 데이터 모델링 실습하기

# 실습 6-1



# 실습 6-2
insert into `Customer` values ('c101','김유신','010-1234-1001','경남 김해시','2023-01-01');
insert into `Customer` values ('c102','김춘추','010-1234-1002','경남 경주시','2023-01-02');
insert into `Customer` values ('c103','장보고','010-1234-1003','전남 완도군','2023-01-03');
insert into `Customer` values ('c104','강감찬','010-1234-1004','서울시 관악구','2023-01-04');
insert into `Customer` values ('c105','이순신','010-1234-1005','부산시 금정구','2023-01-05');

insert into `Product` values (1,'새우깡',5000,1500,'농심');
insert into `Product` values (2,'초코파이',2500,2500,'오리온');
insert into `Product` values (3,'포카칩',3600,1700,'오리온');
insert into `Product` values (4,'양파링',1250,1800,'농심');
insert into `Product` values (5,'죠리퐁',2200,null,'크라운');

insert into `Order` (`orderId`,`orderProduct`,`orderCount`,`orderDate`) values ('c102',3,2,'2023-01-01 13:15:10');
insert into `Order` (`orderId`,`orderProduct`,`orderCount`,`orderDate`) values ('c101',4,1,'2023-01-01 13:15:12');
insert into `Order` (`orderId`,`orderProduct`,`orderCount`,`orderDate`) values ('c102',1,1,'2023-01-01 13:15:14');
insert into `Order` (`orderId`,`orderProduct`,`orderCount`,`orderDate`) values ('c105',2,1,'2023-01-01 13:15:18');

# 실습 6-3
select * 
from `Customer` as a
join `Order` as b
on a.custId = b.orderId
join `Product` as c on b.orderProduct = c.prodNo;


















