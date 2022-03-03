/*join 建表语句*/
drop database if exists db6;
create database db6;
use db6;

/* 左表t1*/
drop table if exists t1;
create table t1
(
    id   int not null,
    name varchar(20)
);
insert into t1
values (1, 't1a');
insert into t1
values (2, 't1b');
insert into t1
values (3, 't1c');
insert into t1
values (4, 't1d');
insert into t1
values (5, 't1f');

/* 右表 t2*/
drop table if exists t2;
create table t2
(
    id   int not null,
    name varchar(20)
);
insert into t2
values (2, 't2b');
insert into t2
values (3, 't2c');
insert into t2
values (4, 't2d');
insert into t2
values (5, 't2f');
insert into t2
values (6, 't2a');

# 1.笛卡尔积
# select * from t1,t2;
# select * from t1 join t2; -- 等价语句
# 2.内连接
select t1.id, t1.name, t2.name
from t1
         join t2 on t1.id = t2.id;
# 3.左连接:左表全部保留，右表关联不上的用null表示
select *
from t1
         left join t2 on t1.id = t2.id;
# 4.右连接-右表全部保留，左表关联不上的用null表示
select *
from t1
         right join t2 on t1.id = t2.id;
# 5.左表独有数据
select *
from t1
         left join t2 on t1.id = t2.id
where t2.id is null;
# 6.右表独有数据
select *
from t1
         right join t2 on t1.id = t2.id
where t1.id is null;
# 7.全连接(mysql不支持全连接，但是可以通过union变相实现全连接；oracle支持全连接)
# 含义：两表关联，查询出所有数据
select *
from t1
         left join t2 on t1.id = t2.id
union
select *
from t1
         right join t2 on t1.id = t2.id;
# 结论：union和union all都可以完成两个表连接，union可以自动对数据去重，union all不去重；
# union all 比 union 效率高很多。
# 8.并集去交集
select *
from t1
         left join t2 on t1.id = t2.id
where t2.id is null
union
select *
from t1
         right join t2 on t1.id = t2.id
where t1.id is null;

# 1. 查询员工表中所有员工姓名及所在部门。
use db_company;
select e.name, d.name
from emp e
         left join dept d on e.dept_id = d.id;
# 2. 查询王五的信息，显示员工 id，姓名，性别，工资和所在的部门名称。
select e.id, e.name, e.gender, e.salary, d.name
from emp e
         left join dept d on e.dept_id = d.id
where e.name = '王五';
# 3. 通过左连接连接部门表和员工表，观察有什么变化?
select *
from dept
         left join emp e on dept.id = e.dept_id;
select *
from emp e
         left join dept on dept.id = e.dept_id;
# 4. 通过右连接连接部门表和员工表，观察有什么变化?

# 课堂练习:都用子查询实现
# 1. 查询渠道部有所有员工信息。
select *
from emp
where dept_id = (select dept.id from dept where dept.name = "渠道部");
# 2. 查询工资最高的员工信息。
select *
from emp
where salary = (select max(salary) from emp);
# 3. 查询工资小于平均工资的员工信息。(思考:如何在每条记录上都配上平均薪资)
select *
from emp
where salary < (select avg(salary) from emp);
select avg(salary)
from emp;
# 4. 查询工资大于 5000 的员工，来自哪些部门？
select *
from dept
where id in (select dept_id from emp where salary > 5000);
# 5. 查询研发部与渠道部所有的员工信息。
select *
from emp
where dept_id in (
    select id
    from dept
    where name in ('研发部', '渠道部')
);
# 6. 查询出 2011 年以后入职的员工信息，包括部门名称
# 方法(推荐):
select *, dept.name
from emp
         left join dept on emp.dept_id = dept.id
where join_date >= '2011-01-01';

# 课堂练习students.sql:
use dqltest;
# 1. 查询最高分同学的Sno、Cno和Degree列。
select * from score where Degree = (select max(Degree) from score);
# 2. 查询和“李军”同性别的所有同学的Sname.
select Sname from student where Ssex =
                                (select Ssex from student where Sname='李军') and Sname!= '李军';
# 3. 查询“男”教师及其所上的课程。
select * from course c join teacher t on c.Tno = t.Tno and t.Tsex = '男';
# 4. 查询所有学生的Sname、Cno和Degree列。
select * from student stu join score s on stu.Sno = s.Sno;
# 5. 查询所有学生的Sno、Cname和Degree列。
# select * from score s join course c on s.Cno = c.Cno;

# 升级
select avg(Degree),max(Degree),c.Cname from score s join course c on s.Cno = c.Cno group by c.Cname ;













