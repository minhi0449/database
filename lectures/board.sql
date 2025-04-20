# 날짜 : 2024.08.19(월)
# 이름 : 김민희
# 내용 : JSP 게시판 프로젝트 실습하기

#데이터베이스 생성
CREATE DATABASE `jboard`;
USE `jboard`;

# 사용자 생성
CREATE USER 'jboard'@'%' IDENTIFIED BY '1234';
GRANT ALL PRIVILEGES ON `jboard`. * TO 'jboard'@'%';
flush PRIVILEGES;

#테이블 생성
CREATE TABLE `user`(
	`uid`			VARCHAR(20) PRIMARY key,
	`pass`		VARCHAR(100),
	`name`		VARCHAR(20),
	`nick`		VARCHAR(20) unique,
	`email`		VARCHAR(20) unique,
	`hp`			CHAR(13) unique,
	`role`		VARCHAR(20) DEFAULT 'user',
	`zip`			CHAR(5),
	`addr1`		VARCHAR(255),
	`addr2`		VARCHAR(255),
	`regip`		VARCHAR(100),
	`regDate`	datetime,
	`leaveDate`	datetime


);
# 대용량 text table primary key 가없음
CREATE TABLE `terms`(
	`terms`		TEXT,
	`privacy`	text
	
);

CREATE TABLE `article`(
	`no`			INT AUTO_INCREMENT PRIMARY KEY ,
	`cate`		VARCHAR(20) DEFAULT 'free',
	`title`		VARCHAR(100) NOT NULL,
	`content`	TEXT NOT NULL,
	`comment`	INT DEFAULT 0,
	`file`		TINYINT DEFAULT 0,  # 파일 첨부 갯수
	`hit`			INT DEFAULT 0,
	`writer`		VARCHAR(20) NOT NULL,
	`regip`		VARCHAR(100) NOT NULL,
	`rdate`		DATETIME,
	FOREIGN KEY(`writer`) REFERENCES `user` (`uid`)
);

CREATE TABLE `comment`(
	`no`				INT AUTO_INCREMENT PRIMARY KEY,
	`parent`			INT NOT NULL,
	`content`		TEXT NOT NULL,
	`writer`			VARCHAR(20) NOT NULL,
	`regip`			VARCHAR(100) NOT NULL,
	`rdate`			DATETIME,
	FOREIGN KEY(`writer`) REFERENCES `user` (`uid`),
	FOREIGN KEY(`parent`) REFERENCES `article` (`no`)

);

CREATE TABLE `file`(
	`fno`			INT AUTO_INCREMENT PRIMARY KEY,
	`ano`			INT NOT NULL,
	`oName`		VARCHAR(100) NOT NULL,
	`sName`		VARCHAR(100) NOT NULL,
	`download`	INT DEFAULT 0,
	`rdate`		DATETIME,
	FOREIGN KEY(`ano`) REFERENCES `article`(`no`)
);













