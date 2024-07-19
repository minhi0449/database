# 날짜 : 2024/07/19
# 이름 : 김민희
# 내용 : 8장 트랜잭션 실습하기


# 실습 8-1
select @@autocommit;
set autocommit = 0;
update `bank_account` set `a_balance` = '100000' where `a_no` = '101-11-1001';

start transaction;
select * from `bank_account`;

update `bank_account` 
set `a_balance` = `a_balance` - 10000
where `a_no` = '101-11-1001';

update `bank_account` 
set `a_balance` = `a_balance` + 10000
where `a_no` = '101-11-1212';                   

commit; -- 작업 확정(트랜잭션 종료)

select * from `bank_account`;


# 실습 8-2 트랜잭션 Rollback
start transaction;
select * from `bank_account`;

update `bank_account` 
set `a_balance` = `a_balance` - 10000
where `a_no` = '101-11-1001';

update `bank_account` 
set `a_balance` = `a_balance` + 10000
where `a_no` = '101-11-1212';                   

commit; -- 작업 확정(트랜잭션 종료)
rollback;
select * from `bank_account`;

# 실습 8-3 커밋 OFF
select @@autocommit;



























