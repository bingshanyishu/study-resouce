create database if not exists DQLTest default charset='utf8';
use DQLTest;
#创建几个库表
create table Student    -- 学生表
(
Sno char(3) NOT NULL Primary key ,    -- 学号 ，设为主键，不允许空值
Sname char(8) NOT NULL,        -- 学生姓名
Ssex char(2)NOT NULL,        -- 学生性别
Sbirthday datetime,     -- 学生出生年月
Class char(5)         -- 学生所在班级
);

create table Teacher        -- 教师表
(
Tno char(3)NOT NULL primary key,        -- 教工编号设为主键
Tname char(4)NOT NULL,        -- 教工姓名
Tsex char(2)NOT NULL,        -- 教工性别
Tbirthday datetime,        -- 教工出生年月
Prof char(6),        -- 职称
Depart varchar(10) NOT NULL        -- 教工所在部门
);

create table Course        -- 课程表
(
    Cno char(5) NOT NULL Primary key ,        -- 课程号设为主键
    Cname varchar(10) NOT NULL,        -- 课程名称
    Tno char(3) NOT NULL ,        -- 教工编号设为外键
    constraint tno_fk foreign key (`Tno`) references Teacher(Tno)
);

create table Score    -- 成绩表
(
Sno char(3) NOT NULL,    -- 学号设为外键
Cno char(5) NOT NULL,    -- 课程号设为外键
Degree Decimal(4,1),    -- 成绩
constraint s_fk foreign key (`Sno`) references Student(Sno),
constraint c_fk foreign key (`Cno`) references Course(Cno)
);

insert into Student values(108,'曾华','男','1977-09-01','95033');
insert into Student values(105,'匡明','男','1975-10-02','95031');
insert into Student values(107,'王丽','女','1976-01-23','95033');
insert into Student values(101,'李军','男','1976-02-20','95033');
insert into Student values(109,'王芳','女','1975-02-10','95031');
insert into Student values(103,'陆君','男','1974-06-03','95031');

insert into Teacher values(804,'李诚','男','1958-12-02','副教授','计算机系');
insert into Teacher values(856,'张旭','男','1969-03-12','讲师','电子工程系');
insert into Teacher values(825,'王萍','女','1972-05-05','助教','计算机系') ;
insert into Teacher values(831,'刘冰','女','1977-08-14','助教','电子工程系');

insert into Course values('3-105','计算机导论',825);
insert into Course values('3-245','操作系统',804);
insert into Course values('6-166','数字电路',856);
insert into Course values('9-888','高等数学',831);

insert into Score values(103,'3-245',86);
insert into Score values(105,'3-245',75);
insert into Score values(109,'3-245',68);
insert into Score values(103,'3-105',92);
insert into Score values(105,'3-105',88);
insert into Score values(109,'3-105',76);
insert into Score values(101,'3-105',64);
insert into Score values(107,'3-105',91);
insert into Score values(108,'3-105',78);
insert into Score values(101,'6-166',85);
insert into Score values(107,'6-166',79);
insert into Score values(108,'6-166',81);
