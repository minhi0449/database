SELECT COUNT(*) FROM `user` WHERE `uid`='abc123';



SELECT SHA2('1234', 256);

select * from `user` where `uid`=?plistimgfileplistimgfileplistimgfile and `pass`=SHA2(?, 256);


SELECT a.*, b.nick FROM `article` AS a
JOIN `user` AS b ON a.writer = b.uid
order BY `no` DESC
LIMIT 0, 10;

SELECT COUNT(*) FROM `article`;

INSERT INTO `article` (`title`, `content`, `writer`, `regip`, `rdate`) 
SELECT `title`, `content`, `writer`, `regip`, `rdate` FROM `article`;


DELETE FROM `article` WHERE `no` > 100;

SELECT * FROM `article` AS a
left JOIN `file` AS b ON a.`no` = b.ano
WHERE `no` = '10';


SELECT a.*, b.nick FROM `comment` AS a
JOIN `user` AS b ON a.writer = b.uid
WHERE `parent` =478;

SELECT LAST_productINSERT_ID(`no`) FROM `comment`;

INSERT INTO `product` VALUES (12,'p101','딸기',8300,8,100,30,3000,0,0,0,NOW(),'딸기');
INSERT INTO `product` VALUES (1,'p101','사과',8300,8,100,30,3000,0,0,0,NOW(),'사과');
INSERT INTO `product` VALUES (1,'p101','사과 500g',4000,100,100,30,3000,0,0,0,'2023-01-01','사과');

INSERT INTO `prodcate` (prodCateNo, prodCateName)
VALUES ('p101', '과일'),
       ('p102', '야채'),
       ('p103', '곡류');
       
       
SELECT * FROM `product`;



SELECT a.prodCateNo, a.pName, b.prodCateName, a.price, a.stock, a.rdate 
FROM `product` AS a
left JOIN `prodcate` AS b
ON a.prodCateNo = b.prodCateNo WHERE a.prodCateNo='p101';


INSERT INTO boardcate (bCateNo, bCateName)
VALUES ('b101','공지사항'),
               ('b102','오늘의 식단'),
               ('b103','나도요리사'),
               ('b104','1:1 고객문의'),
               ('b105','자주묻는 질문'),
               ('b201','농작물이야기'),
               ('b202','텃밭 가꾸기'),
               ('b203','귀농학교'),
               ('b301','이벤트');



SELECT a.prodCateNo, a.pName, b.prodCateName, a.price, a.stock, a.rdate 
FROM `product` AS a
left JOIN `prodcate` AS b ON a.prodCateNo = b.prodCateNo  
LEFT JOIN `plistimgfile` AS c ON a.pList_fNo = c.pList_fNo;


SELECT * FROM product AS p JOIN plistimgfile AS l ON p.pNo=l.pNo;


SELECT filePath FROM plistimgfile WHERE pListfNo = 1;





INSERT INTO grade VALUES 
                        ( '00','관리자'),
                        ('11','VVIP'),
                        ('22','VIP'),
                        ('33','골드'),
                        ('44','실버'),
                        ('55','일반');




















 


