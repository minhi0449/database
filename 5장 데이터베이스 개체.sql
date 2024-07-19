#날짜 : 2024/07/05
#이름 : 김민희
#내용 : 5장 데이터베이스 개체

#실습 5-1
show index from `user1`;
show index from `user2`;
show index from `user3`;

#실습 5-2
create index `idx_user_uid` on `user1` (`uid`);
analyze table `user1`;

select * from `user5`;
insert into `user5` (`name`,`gender`,`age`,`addr`) select `name`,`gender`,`age`,`addr` from `user5`;

update `user5` set `name`='홍길동' where `seq`=3;
update `user5` set `name`='정약용' where `seq`=1000000;

drop table `user5`;

select count(*) from `user5`;
select * from `user5` where `name` = '홍길동';
select * from `user5` where `name` = '정약용';

create index `idx_user5_name` on `user5` (`name`);
analyze table `user1`;

delete from `user5` where `seq` > 5;

# 실습 5-4
create view `vw_user1` as (select `name`, `hp`, `age` from `user1`);
create view `vw_user4_age_under30` as (select * from `user4` where `age` < 30);
create view `vw_member_with_sales` as (
	select
		a.`uid`  as `직원아이디`,
        b.`name` as `직원이름`,
        b.`pos`  as `직급`,
        c.`name` as `부서명`,
        a.`year` as `매출년도`,
        a.`month`as `월`,
        a.`sale` as `매출액`
	from `Sales` as a
    join `Member` as b on a.uid = b.uid
    join `Department` as c on b.dep = c.depNO
    );


# 실습 5-5
select * from `vw_user1`;
select * from `vw_user_age_under30`;
select * from `vw_member_with_sales`;

# 실습 5-6
drop view `vw_user1`;
drop view `vw_user4_age_under30`;

# 실습 5-7
delimiter $$
	create procedure proc_test1()
    begin
		select * from `Member`;
		select * from `Department`;
	end $$
delimiter ;

call proc_test1();

# 실습 5-8
delimiter $$
	create procedure proc_test2(in_userName varchar(10))
    begin
		select * from `Member` where `name` = username;
	end $$
delimiter ;

call proc_test2('김유신');

delimiter $$
	create procedure proc_test3(IN_pos varchar(10), IN_dep tinyint)
	begin
		select * from `Member` where `pos`=_pos and `dep`= _dep;
	end $$
delimiter ;

call proc_test3('차장', 101);

delimiter $$
	create procedure proc_test4(in _pos varchar(10), out _count int)
    begin
		select count(*) into _count from `Member` where `pos`=_pos;
	end $$
delimiter ;

# 실습 5-9
delimiter $$
	create procedure proc_test5(in _name varchar(10))
    begin
		declare userId varchar(10);
        select `uid` into userId from `Member` where `name` = _name;
        select * from `Sales` where `uid`=userId;
	end $$
delimiter ;

call proc_test5('김유신');

delimiter $$
	create procedure proc_test6()
    begin
		declare num1 int;
        declare num2 int;
        
        set num1 = 1;
        set num2 = 2;
        
        if (num1 > num2) then
			select 'num1이 num2보다 크다.' as `결과2`;
		else
			select 'num1이 num2보다 작다.' as `결과2`;
		end if;
	end $$
    delimiter ;
    
    call proc_test6();
    
    delimiter $$
		create procedure proc_test7()
        begin
			declare sum int;
            declare num int;
            
            set sum = 0;
            set num = 0;
            
            while (num <= 10) do
				set sum = sum + num;
                set num = num + 1;
			end while;
            
            select sum as '1부터 10까지 합계';
		end $$
        delimiter ;
            
                
# 실습 5-10
delimiter $$
	create procedure proc_test8()
    begin
		declare total int default 0;
        declare price int;
        declare endOfRow boolean default false;
        declare saleCursor cursor for
				select `sale` from `Sales`;
       declare continue handler for not found set endOfRow = true;
       open saleCursor;
       cursor_loop: LOOP
			fetch salesCursor into price;
            if endOfRow then
				leave cursor_loop;
			end if;
            set total = total + price;
		end loop;
        select total as '전체 합계';  
	end $$
delimiter ;

call proc_test8();

# 실습 5-11 

SET SESSION sql_mode = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
delimiter $$
	create function func_test1(_userid varchar(10)) returns int
    begin
		declare total int;    
        select sum(`sale`) into total from `sale` where `uid`=_userid;
        return total;
	end $$
delimiter ;

select func_test1('a101');









