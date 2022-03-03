use  test;
# 触发器的使用
# 1.创建富豪榜
create table wealthy(
    id int primary key auto_increment,
    age int,
    name varchar(20),
    money int
);
# 2.插入数据
insert into wealthy values(1,20,'张三',110);
insert into wealthy values(2,35,'李四',110);
insert into wealthy values(3,35,'王五',90);
insert into wealthy values(4,20,'赵六',90);
# 3.创建平民
create table person(
id int primary key auto_increment,
age int,
name varchar(20),
money int);

# 4.插入平民
insert into person values(0,20,'十一',30);
# 5.编写触发器
drop trigger if exists peopel_trigger_update_after;  -- 如果存在则删除
delimiter $$
create trigger peopel_trigger_update_after after update on person for each row
    begin
        if new.money >200 then -- 资金来路不明
            signal sqlstate 'ERR10' set message_text ='资金可能来路不明'; -- 抛出异常信息
        elseif new.money>50 then  -- 如果大于50，将这条数据插入到富豪榜
            insert into wealthy (age, name, money) VALUES (old.age,old.name,new.money);
        end if;
    end;$$
delimiter ;
show triggers ; -- 查看所有触发器
# 演示触发触发器
update person set money=150 where id=1;

# 函数的使用
select now();
select curdate(),curtime();
select year(now()),year('2020-06-06');
select dayofmonth(now()),dayofyear(now());
select monthname(now());
select timestampdiff(hour ,'2003-2-1',now());  -- 计算两个日期时间差，可以是年月日时分秒
# 假如给你一个日期，再给你个天数，让你求日期
select date_sub(now(),INTERVAL -200 day ); -- 整数：向历史的时间去数，负数：向未来的时候计算；可以是年月日十分秒


# 窗口函数
create database if not exists cookie;
use cookie;
drop table if exists cookie1;
create table cookie1(cookieid varchar(255), createtime date, pv int);
insert into cookie1 (cookieid, createtime, pv) VALUES
('cookie1','2015-04-10',1),
('cookie1','2015-04-11',5),
('cookie1','2015-04-12',7),
('cookie1','2015-04-13',3),
('cookie1','2015-04-14',2),
('cookie1','2015-04-15',4),
('cookie1','2015-04-16',4);
# 基本语法+边界练习
select cookieid,createtime,pv,
       sum(pv) over(partition by cookieid order by createtime asc ) as pv1,
       sum(pv) over(partition by cookieid order by createtime asc
           rows between unbounded preceding and current row ) as pv2,
       sum(pv) over(partition by cookieid order by createtime asc
            rows between 3 preceding and current row ) as pv3,
       sum(pv) over(partition by cookieid order by createtime asc
            rows between 1 preceding and 1 following ) as pv4
from cookie1;

# sql四大排名函数
use cookie;
drop table if exists cookie2;
create table cookie2(cookieid varchar(255), createtime date, pv int);
insert into cookie2 (cookieid, createtime, pv) VALUES
('cookie1','2015-04-10',1),
('cookie1','2015-04-11',5),
('cookie1','2015-04-12',7),
('cookie1','2015-04-13',3),
('cookie1','2015-04-14',2),
('cookie1','2015-04-15',4),
('cookie1','2015-04-16',4),
('cookie2','2015-04-10',2),
('cookie2','2015-04-11',3),
('cookie2','2015-04-12',5),
('cookie2','2015-04-13',6),
('cookie2','2015-04-14',3),
('cookie2','2015-04-15',9),
('cookie2','2015-04-16',7);
select cookieid,createtime,pv,
       ntile(2) over (partition by cookieid order by createtime asc) as rn1, -- 每组切成2片
        ntile(3) over (partition by cookieid order by createtime asc) as rn2
from cookie2;
-- ntile非常强大，比如取出一定比例的数据，如组内的1/2数据
# row_number
select cookieid,createtime,pv,
       row_number() over (partition by cookieid order by pv desc ) as rn
from cookie2;
# rank
select cookieid,createtime,pv,
       rank() over (partition by cookieid order by pv desc ) as rn1,  -- 留空位
        dense_rank() over (partition by cookieid order by pv desc ) as rn2  -- 不留空位
from cookie2;
























