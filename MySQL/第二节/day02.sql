# 注释的使用：
# ctrl+/:行注释
/*ctrl+shift+/:块注释 */

# 显示所有数据库
show databases;
# 创建数据库
create database if not exists huzi;
use huzi;
# 创建表
create table student(
    sid int(11) primary key auto_increment,# 整形，如：0，1，2，3，4
    name varchar(255) unique ,# 字符类型
    age int(11) not null
);
# 查看表结构
desc huzi.student;
# 修改表结构
alter table student add tel char(11); # 添加一列
alter table student drop age; # 删除类
alter table student modify column tel int(11);# 修改类数据类型
alter table student change tel telephone char(11); # 修改tel列为telephone
# 修改表明
rename table student to t_stu;
# 查看建表语句
show create table t_stu;
show create database huzi;

# CREATE TABLE `t_stu` (
#   `sid` int DEFAULT NULL,
#   `name`varchar(255 ) DEFAULT NULL,
#   `telephone` char(11) DEFAULT NULL
# ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
# CREATE DATABASE `huzi` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */

# 插入一条数据
insert into `student` (sid, name, age) values (0,"王五",23);
mysql8默认字符集是utf8
schemas:数据库
collations:校对规则，理解为排序规则，公司中比较常见的是utf8_general_ci
users:数据库用户

主键：一个表里面只允许有一个主键列,往往是整形，自增长，不允许为空的列。











