# 第六次课作业答案
use homework;
select u.university,count(q.question_id )/count(distinct q.device_id)
from question_practice_detail q
join user_profile u
on q.device_id=u.device_id
group by u.university;
# 事物四大特性：重点
# - 原子性(Atomicity，或称不可分割性)
#   一个事务（transaction）中的所有操作，要么全部完成，要么全部不完成，不会结束在中间某个环节。事务在执行过程中发生错误，会被回滚（Rollback）到事务开始前的状态，就像这个事务从来没有执行过一样
# - 一致性(Consistency)
#   在事务开始之前和事务结束以后，数据库的完整性没有被破坏。这表示写入的资料必须完全符合所有的预设规则，这包含资料的精确度、串联性以及后续数据库可以自发性地完成预定的工作
# - 隔离性(Isolation，又称独立性)
#   数据库允许多个并发事务同时对其数据进行读写和修改的能力，隔离性可以防止多个事务并发执行时由于交叉执行而导致数据的不一致。事务隔离分为不同级别，包括读未提交（Read uncommitted）、读提交（read committed）、可重复读（repeatable read）和串行化（Serializable）
# - 持久性(Durability)
#   事务处理结束后，对数据的修改就是永久的，即便系统故障也不会丢失

# 标记点作用：当你一个事物中有大量sql操作的时候，如果rollback(默认回到原始状态)效率极低，可以考虑回到某个标记点

# mysql数据库默认自动提交事物：
begin;
insert into test.student (name, sex) values ('zhangsan',0);
savepoint p1;
insert into test.student (name, sex) values ('lisi',0);
rollback to p1;
commit ;

# 将set autocommit=0,禁止自动提交(以下必须在黑窗口执行，在dg中查看。分析结论)
# insert into test.student (name, sex) values ('wangwu',0);
# commit ;
#
# mysql> show variables like 'autocommit';
#
# 直接用 SET 来改变 MySQL 的自动提交模式(自动模式)
# 配置仅临时有效
# - **SET AUTOCOMMIT=0** 禁止自动提交，可在黑窗口下操作，每个SQL语句或者语句块所在的事务都需要显示"commit"才能提交事务。
# - **SET AUTOCOMMIT=1** 开启自动提交
#
# SET AUTOCOMMIT=0;
# begin;  | start transaction;
# insert into test.student (id, name, age, gender) VALUES (5,'zhang',22,'男');
# savepoint p1 ;
# insert into test.student (id, name, age, gender) VALUES (5,'zhang',22,'男');
# savepoint p2;
# insert into test.student (name, age, gender) VALUES ('男');  -- 此句报错，可进行回滚
# rollback to p2;
# commit ;


# 视图练习：
use test;
create table student(
    id int not null auto_increment primary key,
    age int,
    sid char(20),
    sex bit,
    name char(20),
    isDelete bit default 0
) ;

insert into student(age,sex,name) values (18, 1, "liudehua");
insert into student(age,sid,sex,name) values (18, '', 1, "liudehua");
insert into student(age,sex,name) values (36, 1, "高磊"),(20, 1, "高鹏鹏"),(30, 1, "高子龙"),(30, 1, "高兴");
insert into student(age,sex,name) values (34, 1, "高%");

# 假设：需要经常过滤id大于3的学生中，对年龄过滤20、30、40
select * from (select * from student where id > 3) as st where age > 20;
select * from (select * from student where id > 3) as st where age > 30;
select * from (select * from student where id > 3) as st where age > 40;

# 视图写法：
create view v_stu as select * from student where id > 3;
select * from v_stu where age>20;
select * from v_stu where age>30;
select * from v_stu where age>40;
# 修改视图：
alter view v_stu as (select * from student where student.name like '高%');
select * from v_stu;
# 删除视图：
drop view v_stu;
# 总结：视图多用于查询频次较高的语句或者逻辑较为复杂的场景，可以考虑建立视图
# 比如：网站首页数据；网站顶部筛选过滤；

# 存储过程练习
create database dba;
use dba;
create table tb1(id int ,name varchar(255));
delimiter $$ -- 修改结尾符为
create procedure ad1()  -- 定义存储过程
begin
    declare i int default 1; -- 声明一个变量i，默认值为1
    while (i<=3)do
        insert into tb1 (id, name) VALUES (i,'zhangsan');
        set i = i+1; -- 每执行一次，i值加1
    end while;
end;$$
delimiter ;
call ad1();  -- 调用存储过程














