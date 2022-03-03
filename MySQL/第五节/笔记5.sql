/* 连接问题：
1、报错rsc public key问题：连接参数加上  ?allowPublicKeyRetrieval=true
2、servertimezone：设置为UTC
   */

# count(*) < count(1) < count(列名,索引列效率高)
use huzi;
select count(1)
from employee;

# 分组统计男女生人数
select count(1), gender
from employee
group by gender;

# 练习:查询每个班级最大分数
# 1、建表语句
CREATE TABLE `student5`
(
    `id`      int(11) primary key AUTO_INCREMENT,
    `name`    varchar(50) NOT NULL COMMENT '姓名',
    `score`   int(11)     NOT NULL COMMENT '成绩',
    `classid` int(11)     NOT NULL COMMENT '班级'
);

# 2、插入数据
insert into student5(Name, Score, ClassId)
values ("lqh", 60, 1);
insert into student5(Name, Score, ClassId)
values ("cs", 99, 1);
insert into student5(Name, Score, ClassId)
values ("wzy", 62, 1);
insert into student5(Name, Score, ClassId)
values ("zqc", 88, 2);
insert into student5(Name, Score, ClassId)
values ("bll", 100, 2);

select max(s.score) as "最高分", s.classid
from student5 s
group by s.classid;
# 显然实际中不符合场景,只能看到班级最高分,但是看不到是谁拿了最高分
select *
from student5
where score in
      (select max(s.score) as "最高分" from student5 s group by s.classid);

# 主键:一个表里可以有或没有,但最多只能有一个
# 外键:一个表里可以有或没有,可以有多个.

# 外键练习
# 创建新库：bj_school
-- 创建班级表（主键表）
create database if not exists bj_school;
use bj_school;
create table if not exists grade
(
    id   int not null auto_increment primary key,
    name char(20)
);
insert into grade(name)
values ('python开发'),
       ('Java开发'),
       ('Web前端'),
       ('C开发');

-- 创建学生表(外键表)
create table student
(
    id       int not null auto_increment primary key,
    name     char(20),
    grade_id int,
    constraint fk_student_grade foreign key (grade_id) references grade (id)
);
insert into student(name, grade_id)
values ("刘德华", 1),
       ("张惠妹", 2),
       ("张学友", 3),
       ("刀郎", 4),
       ("云朵", 4);
# 查看表表之间关系:在库名上-右键-最后一项-选择第一项,即可
# 1. 根据班级id进行分组，汇总各班级人数。
select grade_id, count(1)
from student
group by grade_id;

# 2. 找出班级人数大于1的班级名称。
# select name from student where count(1)>1; #不正确
select *
from grade
where id = (
    select grade_id
    from student
    group by grade_id
    having count(*) > 1
);


# 1.sql语句建立外检表：
use huzi;
create table t_user (  -- 主键表
    uid int primary key auto_increment,
    name varchar(255) not null
);
create table t_order(
    oid int primary key auto_increment,
    price int not null ,
    count int not null , -- 下单量
    uid int not null ,
    constraint fk_order_user  foreign key(uid) references t_user(uid)  -- 外键
);

# 2.用工具建立外检表：
# 需求再次升级：我想实现删除用户的时候，同时把他的订单一起删除

# 课堂练习：
-- 1. 查询Score表中的最高分的成绩。
use dqltest;
select max(`Degree`) from score;
-- 2. 查询Score表中除了每门课程最高分的学生学号和课程号。
# 由于很简单，单表查询，自行处理
-- 3. 查询每门课的平均成绩。
# 单表分组查询，并配合avg平均值函数
-- 4. （最难）查询Score表中至少有5名学生选修的并以3开头的课程的平均分数。
# 可以先自己尝试去拆解需求。
-- 5. 查询分数大于70，小于90的Sno列。
# 单表查询，and或者between都可以
-- 6. 查询所有学生的Sname、Cno和Degree列。（涉及多表查询）
select stu.Sname,sco.Cno,sco.Degree from student stu,score sco where stu.Sno = sco.Sno;









