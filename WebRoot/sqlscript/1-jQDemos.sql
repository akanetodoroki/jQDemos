use master
set nocount on
if (db_id('jqdemos') is null)  create database jqdemos
go
use jqdemos
go
if object_id('sys_users') is not null drop table sys_users
GO
if object_id('Teachers') is not null drop table Teachers
GO
if object_id('Students') is not null drop table Students
GO
if object_id('Courses') is not null drop table Courses
GO
if object_id('Resources') is not null drop table Resources
GO
if object_id('Areas') IS NOT NULL drop table Areas
GO
if OBJECT_id('accounts') is not null drop table accounts
go
if object_id('dictionary') is not null	drop table dictionary
go
if object_id('Books') is not null drop table Books
GO
if object_id('products') is not null drop table products
GO
if object_id('Suppliers') is not null drop table Suppliers
GO
if object_id('orders') is not null drop table orders
GO
if object_id('orderitems') is not null drop table orderitems
GO
if object_id('customers') is not null drop table customers
GO
if object_id('sys_unicodes') is not null drop table sys_unicodes
GO
CREATE TABLE sys_unicodes (
	sysid int IDENTITY (1, 1) ,
	xchn  nchar(2) ,
	xpy   nvarchar(20),
	xpy1  tinyint,
	xpy2  nvarchar(1),
	xcode int NOT NULL PRIMARY KEY CLUSTERED 
)
GO
CREATE TABLE sys_users(
	id bigint identity,
	userid nvarchar(20) primary key,
	account nvarchar(20),
	username nvarchar(30),
	email nvarchar(50),
	mobile nvarchar(20),
	password nvarchar(20),
	usertype tinyint,
	registerdate date,
	logindate datetime
)
go

CREATE TABLE Areas(
	AreaID nchar(10) primary key default '',
	AreaName nvarchar(30) default '',
	PYCode nvarchar(15) default '',
	Zip nchar(10) default '',
	PhoneCode nchar(10) default '',
	ParentNodeID nchar(10) default '',
	IsparentFlag tinyint default '',
	Ancester varchar(255),
	level tinyint default 0
)	
GO
create table dictionary (
  ID bigint identity primary key,
  Type nvarchar(100) default '',
  Description nvarchar(200) default '',
  Pycode nvarchar(255) default '',
  SortFlag tinyint default 0
)
GO
create table books (
	BookID nchar(13) primary key,
	Title nvarchar(50),
	Author nvarchar(20),
	PubID nchar(3),
	Pubdate date,
	Size nvarchar(20),
	Words int,
	Unitprice decimal(8,2),
	Editor nvarchar(20),
	Edition int,
	Translator nvarchar(40),
	Country nvarchar(30),
	Notes ntext
)
go
create table Teachers (
  TeacherID nchar(8) primary key,    --教师编码
  Name nchar(20),            --教师姓名
  pycode nchar(100),         --姓名拼音
  IDNumber nchar(18),        --身份证号
  Type int,                  --权限
  Gender nchar(2),          --性别   
  DeptID nchar(10),        --教师所在部门编码
  BirthDate date,      --出生日期
  Hiredate date,      --进校日期
  Title nvarchar(20),     --职称
  Graduate nvarchar(100),  --毕业学校
  Graduatedate date,  --毕业时间
  Major nvarchar(30),       --毕业专业
  Degree nvarchar(20),      --学历学位
  Party nvarchar(20),       --党派
  Province nvarchar(30),    --籍贯省
  City nvarchar(30),    --籍贯省
  Nationality nvarchar(20),    --民族
  WorkDate date,   --参加工作时间
  Address nvarchar(100),     --家庭地址
  zip nchar(6),         --邮政编码
  HomePhone nvarchar(20),   --家庭电话
  OfficePhone nvarchar(20),   --办公室电话
  Fax nvarchar(20),   --传真
  OfficeNo nvarchar(40),   --办公地点
  Mobile nvarchar(20),      --移动电话
  Email nvarchar(40),       --电子邮箱
  weixin nvarchar(20),       --微信
  QQ nvarchar(20),       --qq
  Homepage nvarchar(40),    --个人主页
  Institute nvarchar(40),  --所在研究所
  TurtorTitle nvarchar(50),  --导师信息 （硕导、博导）
  Research nvarchar(250),    --研究方向
  Honor nvarchar(500),      --荣誉称号
  Resume ntext,             --个人简历
  FileSize bigint,                  --照片大小(x B)
  FileOSname nvarchar(250),         --照片文件所在的路径
  FileSourceName nvarchar(250),     --照片源文件名称
  FileSizeDesc nvarchar(100),       --照片图像大小
  account nvarchar(20),
  password nvarchar(20),
  usertype tinyint,
  rememberflag tinyint,
  logindate datetime,
  Notes ntext                 --备注（个人简介）
)
GO
truncate table teachers
insert into Teachers (TeacherID,Name,pycode,Gender,Title,Degree,BirthDate,hiredate,deptID,Password,address,graduate,homephone,research,province,city,party,account,usertype)
values('20000551','马云','mayun','男','教授','博士研究生','1964-12-11','1990-5-18','D1','zxy','浙江省杭州市下沙高教园区','杭州师范大学','86811234','企业管理;区域经济学;管理信息系统;电子商务','浙江省','杭州市','九三学社','mayun','1')
insert into Teachers (TeacherID,Name,pycode,Gender,Title,Degree,BirthDate,hiredate,deptID,Password,address,graduate,homephone,research,account,usertype)
values('20000552','牛顿','Newton','男','教授','硕士','1964-8-1','2000-5-8','D1','zxy','hangzhou','zstu','8681','企业管理;区域经济学;管理信息系统;电子商务;信息系统开发技术','zxywolf@126.com','1')
insert into Teachers (TeacherID,Name,pycode,Gender,Title,Degree,BirthDate,hiredate,deptID,Password,account,usertype)
values('20000553','爱因斯坦','Einstein','男','教授','博士','1955-8-1','1996-4-6','D2','123456','zxywolf','1')
insert into Teachers (TeacherID,Name,pycode,Gender,Title,Degree,BirthDate,hiredate,deptID,Password,research,account,usertype)
values('20000555','华罗庚','Hualuogeng','男','教授','硕士','1955-8-1','1998-1-6','D1','','管理信息系统;电子商务;信息系统开发技术','math','1')
insert into Teachers (TeacherID,Name,pycode,Gender,Title,Degree,BirthDate,hiredate,deptID,Password,account,usertype)
values('20000554','祝锡永','zhuxiyong','男','教授','硕士','1964-8-1','1986-8-1','D2','zxy','zxywolf@163.com','3')
GO
create table Students (
  StudentID nchar(12) primary key,    --学生编码
  Name nchar(20),            --学生姓名
  Pycode varchar(40),    --拼音
  IDNumber nchar(18),        --身份证号
  Gender nchar(2),           --性别 
  DeptID nchar(10),          --学生所在部门
  Class nchar(30),           --学生所在班级
  BirthDate date,        --出生日期
  AdmissionDate datetime,    --入学日期
  ClassID varchar(6),
  Graduate nvarchar(100),    --中学毕业学校
  Party nvarchar(20),        --党派
  Title  nvarchar(20),       --班委职务
  Province nvarchar(30),     --籍贯省
  City nvarchar(30),         --籍贯市
  Nationality nvarchar(20),  --民族
  Address nvarchar(100),     --家庭地址
  zip nchar(6),       --邮政编码
  Mother nvarchar(20),       --母亲姓名
  Father nvarchar(20),       --父亲姓名
  MotherPhone nvarchar(20),  --母亲电话
  FatherPhone nvarchar(20),  --父亲电话
  HomePhone nvarchar(20),     --家庭电话
  Mobile nvarchar(20),        --移动电话
  Email nvarchar(40),         --电子邮箱
  weixin nvarchar(30),       --微信
  QQ nvarchar(20),       --qq
  Homepage nvarchar(40),      --个人主页
  Speciality nvarchar(250),    --个人特长（可以多个，分号分隔）
  Honor nvarchar(250),        --荣誉称号
  Score decimal(6,2),
  Resume ntext,               --个人简历
  photoPath nvarchar(100),   --照片路径
  account nvarchar(20),
  password nvarchar(20),
  usertype tinyint,
  rememberflag tinyint,
  logindate datetime,
  Notes ntext                 --备注
)
GO
--课程表
create table Courses (
  CourseID nchar(8) primary key,    --课程表
  CourseName nvarchar(100),                --课程名称
  EnglishName nvarchar(250),        --课程英文名称
  Language char(1),   --1双语   2-纯英语
  CategoryID nchar(20),      --课程类别
  Credit decimal(3,1),       --学分
  Hours int,                 --学时
  DeptID nchar(10),          --开课系
  Type nvarchar(20),
  Description ntext,         --课程简介
  sortflag tinyint default 0,
  Note ntext                 --备注
)
GO
------------------------------------------------products-------------------------------
/************************ Products 产品表*************************/
CREATE TABLE Products (
	ProductID nvarchar(14) PRIMARY KEY CLUSTERED,
	pyCode nvarchar(40) default '',
	ProductName nvarchar(100) NOT NULL,
	ProductShortName varchar(12),
	Englishname varchar(100),
	QuantityPerUnit nvarchar(60) default '',
	Unit nvarchar(16) default '',
	UnitPrice decimal(12,2) default 0,
	SupplierID nvarchar(14) default '',
	ParentNodeID nchar(14) default '',
	IsParentFlag tinyint default 0,
	Level tinyint default 0,
	Ancester nvarchar(255) default '',
	Quantity int default 0,
	Amount decimal(14,2) default 0,
	Taxrate decimal(6,2) default 0, --增值税率
	Filepath nvarchar(255) default '',
	filename nvarchar(255) default '',
	ReOrderLevel int DEFAULT (0) ,
	InventoryLimit int DEFAULT (0),
	Creator nvarchar(30) default '',
	Operator nvarchar(30) default '',
	CreateDate date default getdate(),
	UpdateDate date default getdate(),
	Notes ntext default '')
GO
/********************** Suppliers 供应商表************************/
CREATE TABLE Suppliers (
	SupplierID nchar(14) PRIMARY KEY CLUSTERED,
	SupplierName nvarchar(100) NOT NULL default '',
	pyCode nvarchar(40) default '',
	Contactname nvarchar(30)  default '',
	Address nvarchar(100)  default '',
	CityID nvarchar(10)  default '',
	ProvinceID nvarchar(10)  default '',
	Zip nvarchar(10)  default '',
	Phone nvarchar(25)  default '',
	Fax nvarchar(25)  default '',
	Email nvarchar(50)  default '',
	HomePage nvarchar(60)  default '',
	Employees int default 0,
	Revenue decimal(12,2) default 0,
	StockNo char(8) default '',
    Bank nvarchar(40) default '',
	BankAccountno nvarchar(30) default '',
	Taxno nvarchar(30) default '',	
	VatInvoiceTitle nvarchar(100) default '',
	Vatbank nvarchar(40) default '',
	VatbankaccountNo nvarchar(30) default '',
	VatAccountPhone nvarchar(25) default '',
	VatAccountAddress nvarchar(100) default '',
	Owner nvarchar(30) default '',	
	LastMeetDate date default '',
	Type nvarchar(40) default '',  --类别
	Source nvarchar(40) default '',  --来源
	Status nvarchar(40) default '',  --状态
	Industry nvarchar(40) default '',  --行业
	ContactDate date default '',    --初次联系日期
	Filepath nvarchar(255) default '',
	filename nvarchar(255) default '',
	Notes ntext default '',
	Creator nvarchar(30) default '',
	Operator nvarchar(30) default '',
	CreateDate date default '',
	UpdateDate date default '',
	AccountReceivable decimal(14,2) default 0  --年初应收账款余额
 )
GO
/*************************** Orders 订单表**************************/
CREATE TABLE Orders (
	OrderID nchar(20) PRIMARY KEY CLUSTERED,
	OrderDate date,
	CustomerID nchar(14) default '',
	EmployeeID nchar(14) default '',
	ContactID nchar(14) default '',
	RequiredDate date,    --要求运输时间
	ShippedDate date ,   --实际发车时间
    Freight decimal(12,2) DEFAULT 0,   --运费
    Amount decimal(14,2) default 0,
    Notes ntext default ''
)
GO
CREATE TABLE OrderItems (
	OrderID nchar(20) default '',
	ProductID nvarchar(14) default '',
	UnitPrice decimal(12,2) DEFAULT (0),
	Quantity int DEFAULT(0),
	Discount decimal(6,2) DEFAULT (100),
	Amount as CAST(quantity*unitprice*discount/100 AS DECIMAL(16,2)),
	CONSTRAINT PK_OrderItems PRIMARY KEY CLUSTERED (OrderID,ProductID)
)
GO
CREATE TABLE Customers(
	CustomerID nchar(14) PRIMARY KEY CLUSTERED,
	CustomerName nvarchar(100) NOT NULL default '',
	CustomerShortName varchar(12) default '',
	pyCode nvarchar(40) default '',
	ContactID nvarchar(14)  default '',
	EmployeeID nvarchar(14) default '',    --负责的员工
	Address nvarchar(100)  default '',
	CityID nvarchar(10)  default '',
	ProvinceID nvarchar(10)  default '',
	Zip nvarchar(10)  default '',
	Phone nvarchar(25)  default '',
	Fax nvarchar(25)  default '',
	Email nvarchar(50)  default '',
	HomePage nvarchar(60)  default '',
	Filepath nvarchar(255) default '',
	filename nvarchar(255) default '',
	Notes ntext default ''
 )
 GO

--backup database jqdemos to disk='d:\jqdemos64.bak'
--use master restore database jqdemos from disk='d:\jqdemos64.bak' with replace
--select a.*,b.username from sys_userlog a join sys_user b on a.account=b.account where timein between '2012-07-01 00:00:00' and '2012-07-04 23:59:59'

--alter table resources add keywords nvarchar(500)
--alter table resources drop column note
