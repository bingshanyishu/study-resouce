create database jingdong;
use jingdong;
CREATE TABLE IF NOT EXISTS ORDERINFO
(                                            -- 订单表
    ORDERID  int primary key auto_increment, -- 订单ID
    USERID   VARCHAR(10) NULL,               -- 用户ID
    ISPAID   VARCHAR(10) NULL,               -- 是否支付
    PRINCE   VARCHAR(10) NULL,               -- 价格
    PAIDTIME VARCHAR(30) NULL                -- 支付时间
);
CREATE TABLE IF NOT EXISTS USERINFO
(                                          -- 用户表
    USERID int primary key auto_increment, -- 用户ID
    SEX    VARCHAR(10) NULL,               -- 性别
    BIRTH  VARCHAR(30) NULL                -- 生日
);
select count(1)
from userinfo; -- 10w
select count(1)
from orderinfo;
-- 54w
##### 所要完成的数据提取任务

# > 1-统计不同月份的下单人数(不是单量)
select *
from orderinfo
where ISPAID = '已支付';
-- 不同月份下单量
select count(1) as 下单量, year(PAIDTIME) as 年份, month(PAIDTIME) as 月份
from orderinfo
where ISPAID = '已支付'
group by year(PAIDTIME), month(PAIDTIME);
-- 不同月份下单用户数
select count(distinct (USERID)) as 下单用户数, count(1) as 下单量, year(PAIDTIME) as 年份, month(PAIDTIME) as 月份
from orderinfo
where ISPAID = '已支付'
group by year(PAIDTIME), month(PAIDTIME);

# > 2-统计用户三月份的复购率和各个月份回购率
# 月度复购率:指在本月中一人多次消费的人数占比
select count(*)
from orderinfo
where ISPAID = '已支付'
  and month(PAIDTIME) = 3;

select count(t.USERID) as 3月份下单用户数, sum(t.是否复购) as 3月份复购用户数
from (
         select USERID, case when count(USERID) > 1 then 1 else 0 end as 是否复购
         from orderinfo
         where ISPAID = '已支付'
           and month(PAIDTIME) = 3
         group by USERID) as t;

#回购率:比如四月份购买了商品,三月月份也购买过商品
select *
from orderinfo
where ISPAID = '已支付'
group by USERID, month(PAIDTIME)
order by USERID asc;
-- 开始写连接,自己连接自己
select year(a_time)   as 年,
       month(a_time)  as 月,
       count(t.a_uid) as 总的消费用户数量,
       count(t.b_uid) as 回购用户数量
from (
         select a.USERID as a_uid, a.PAIDTIME as a_time, b.USERID as b_uid
         from (select USERID, PAIDTIME
               from orderinfo
               where ISPAID = '已支付'
               group by USERID, month(PAIDTIME)) a
                  left join
              (select USERID, PAIDTIME
               from orderinfo
               where ISPAID = '已支付'
               group by USERID, month(PAIDTIME)) b
              on a.USERID = b.USERID and month(a.PAIDTIME) = month(b.PAIDTIME) + 1
     ) as t
group by year(a_time), month(a_time);
select substring('2016/3/1 0:04', 1, 7);
-- 函数使用说明

# 验证数据正确性
# 获取5月份消费用户数
select distinct USERID
from orderinfo
where month(PAIDTIME) = 4
  and USERID in (
    select distinct USERID
    from orderinfo
    where month(PAIDTIME) = 5 -- 发现有6个用户下单
);


# > 3-统计男女的消费频次是否有差异(统计的是每个性别的订单频次,可自行过滤已支付的情况)
select b.SEX, avg(ct)
from (select u.USERID, u.SEX, count(1) as ct
      from orderinfo as o
               join
               (select USERID, SEX from userinfo where sex <> '') as u
               on o.USERID = u.USERID
      group by u.USERID) as b
group by b.SEX;

# > 4-统计多次消费的用户，第一次和最后一次消费时间的间隔(timestampdiff(day,min(PAIDTIME),max(PAIDTIME)))
select USERID,
       min(PAIDTIME),
       max(PAIDTIME),
       datediff(max(PAIDTIME), min(PAIDTIME))
from orderinfo
where ISPAID = '已支付'
group by USERID
having count(1) > 1;

# > 5-统计不同年龄段的用户消费金额是否有差异
select USERID, min(year(now()) - year(BIRTH)) as min_age
from userinfo;
select BIRTH
from userinfo
group by BIRTH
order by BIRTH asc;
select *
from (select * from orderinfo where ISPAID = '已支付') a -- 已支付
         join
     (select USERID, year(now()) - year(BIRTH) as age from userinfo where BIRTH is not null) b -- 生日不为空的人的年龄
     on a.USERID = b.USERID;
-- --
# case
# when  判断条件  then xxx,
# when  判断条件  then xxx
# when  判断条件  then xxx
# else xxxx
# end

select cast(sum(PRINCE) as decimal(12, 2)) as 总金额,
       case
           when age between 10 and 19 then '10-19岁'
           when age between 20 and 29 then '20-29岁'
           when age between 30 and 39 then '30-39岁'
           when age between 40 and 49 then '40-49岁'
           when age between 50 and 59 then '50-59岁'
           when age between 60 and 69 then '60-69岁'
           when age between 70 and 79 then '70-79岁'
           else null
           end                             as age_group
from (select * from orderinfo where ISPAID = '已支付') a -- 已支付
         join
     (select USERID, year(now()) - year(BIRTH) as age from userinfo where BIRTH is not null) b -- 生日不为空的人的年龄
     on a.USERID = b.USERID
group by age_group
order by age_group asc;

# > 6-统计消费的二八法则，消费的top20%用户，贡献了多少额度
-- 每个用户消费总额
select USERID, sum(cast(PRINCE as double))
from orderinfo
where ISPAID = '已支付'
group by USERID;
-- 按照用户总消费额度进行降序
select USERID, sum(cast(PRINCE as double)) as sum_price
from orderinfo
where ISPAID = '已支付'
group by USERID
order by sum_price desc ;
-- 1) 排名函数,用户数*0.2

select sum(sum_price) from
(select *,row_number() over (order by sum_price desc) as 排序 from
(select USERID, sum(cast(PRINCE as double)) as sum_price
from orderinfo
where ISPAID = '已支付'
group by USERID) aa) tt
where tt.排序<(select count(distinct USERID)*0.2 from orderinfo where ISPAID='已支付');

-- 已支付用户总量的20%的人数
select count(distinct USERID)*0.2 from orderinfo where ISPAID='已支付';

-- 2) limit 用户数*0.2



