drop table user1;
drop table studydb;
drop schema studydb;
drop schema bank;
drop schema bankerd;
drop schema bookstore;
drop schema college;
drop schema collegeerd;
drop schema farmstory;
drop schema hospital;
drop schema jboard;
drop schema sakila;
drop schema shop;
drop schema shopping;
drop schema sys;
drop schema theater;
drop schema university;
drop schema world;
drop schema shoperd;


DROP TABLE `User1`;
CREATE TABLE `User1` (
	`uid`	VARCHAR(10),
    `name`	VARCHAR(10),
    `birth` char(10),
    `hp`	CHAR(13),
    `age`	INT
);


create table user1 (
	`uid` varchar(10) primary key,
    `name` varchar(10) not null,
    `birth` varchar(15) not null,
    `hp` varchar(13) not null,
    `age` int not null
);