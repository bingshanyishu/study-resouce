create database if not exists db_company default charset='utf8';
use db_company;
#部门表
create table dept(
	id int not null auto_increment primary key,
	name varchar(20)
)engine=innodb default charset=utf8;

insert into dept(name) values ('研发部'),('渠道部'),('教务部');

# 创建员工表(constraint:限制; 限定; 约束; )
create table emp(
	id int primary key auto_increment,
	name varchar(10),
	gender char(1), -- 性别
	salary double,  -- 工资
	join_date date, -- 入职日期
	dept_id int,
  constraint fk_emp_dept foreign key(dept_id) references dept(id)
)engine=innodb default charset=utf8;
insert into emp(name,gender,salary,join_date,dept_id) values('张三','男',7200,'2013-02-24',1);
insert into emp(name,gender,salary,join_date,dept_id) values('李四','男',3600,'2010-12-02',2);
insert into emp(name,gender,salary,join_date,dept_id) values('王五','男',9000,'2008-08-08',2);
insert into emp(name,gender,salary,join_date,dept_id) values('赵六','女',5000,'2015-10-07',3);
insert into emp(name,gender,salary,join_date,dept_id) values('吴七','女',4500,'2011-03-14',1);

