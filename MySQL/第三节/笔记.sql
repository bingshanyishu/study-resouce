# 查看当前数据库支持的引擎有哪些
show engines ;

# 行锁：锁住一行数据，只有等当前连接操作完，别的连接才可以进行此行数据操作；
# 表锁：锁住整张表，只有等当前连接操作完，别的连接才可以进行表数据操作；
# 大小写问题(window下和linux下的大小写有区别；可以通过修改配置文件去让数据库区分大小写问题)
# s:是表的别名;
select s.name as 姓名,s.id as ID from huzi.student as s;

use huzi;
# 建表

# 插入：全列插入
insert into huzi.student values (0,"lisi");
# 缺省插入
insert into huzi.student (`name`) values ("wang");
# 批量插入
insert into huzi.student (`name`) values
("sun"),("xue"),("zhao");
# 更新
# update huzi.student set name="sun" where name="lisi";
update huzi.student set name='xue';
# 删除数据:delete,删除表：drop
delete from huzi.student where id=4;
delete from huzi.student;
# truncat:也是删除行数据，但是不可以加where，执行效率比delete要高。
truncate table huzi.student;
# 删除表
drop table huzi.student;

# 利用工具实现表数据的导入和导出功能：
# 导出：在库或者表上右键，选择导出到文件即可
# 导入：在库或者表上右键，选择导入数据（如果表不存在，会自动建表；如果存在，会直接插入数据）
truncate table huzi.student;

select * from huzi.student;


# 课堂小练习
# 1.建表
use huzi;
CREATE TABLE my_employee(
	id int primary key auto_increment,
	first_name varchar(10),
	last_name varchar(10),
	userid varchar(10) unique ,
	salary double(10,2)  #2代表精度保留两位小数
);
#向my_employee中插入多条语句
INSERT INTO my_employee VALUES
(1,'zhang','haha','kjjs',895),
(2,'li','Betty','sdfa',860),
(3,'wang','haha','wef',1100),
(4,'zhao','haha','asde',750),
(5,'sun','haha','fdaeg',1550);

# 查询数据
select * from my_employee where salary>1000;
# 老板高兴,每人工资加100
update my_employee set salary = salary+100 where first_name='zhang';
# 公司倒闭,清空处理
truncate table my_employee ;
drop table my_employee;
