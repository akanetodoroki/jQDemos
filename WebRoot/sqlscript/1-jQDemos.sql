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
  TeacherID nchar(8) primary key,    --��ʦ����
  Name nchar(20),            --��ʦ����
  pycode nchar(100),         --����ƴ��
  IDNumber nchar(18),        --���֤��
  Type int,                  --Ȩ��
  Gender nchar(2),          --�Ա�   
  DeptID nchar(10),        --��ʦ���ڲ��ű���
  BirthDate date,      --��������
  Hiredate date,      --��У����
  Title nvarchar(20),     --ְ��
  Graduate nvarchar(100),  --��ҵѧУ
  Graduatedate date,  --��ҵʱ��
  Major nvarchar(30),       --��ҵרҵ
  Degree nvarchar(20),      --ѧ��ѧλ
  Party nvarchar(20),       --����
  Province nvarchar(30),    --����ʡ
  City nvarchar(30),    --����ʡ
  Nationality nvarchar(20),    --����
  WorkDate date,   --�μӹ���ʱ��
  Address nvarchar(100),     --��ͥ��ַ
  zip nchar(6),         --��������
  HomePhone nvarchar(20),   --��ͥ�绰
  OfficePhone nvarchar(20),   --�칫�ҵ绰
  Fax nvarchar(20),   --����
  OfficeNo nvarchar(40),   --�칫�ص�
  Mobile nvarchar(20),      --�ƶ��绰
  Email nvarchar(40),       --��������
  weixin nvarchar(20),       --΢��
  QQ nvarchar(20),       --qq
  Homepage nvarchar(40),    --������ҳ
  Institute nvarchar(40),  --�����о���
  TurtorTitle nvarchar(50),  --��ʦ��Ϣ ��˶����������
  Research nvarchar(250),    --�о�����
  Honor nvarchar(500),      --�����ƺ�
  Resume ntext,             --���˼���
  FileSize bigint,                  --��Ƭ��С(x B)
  FileOSname nvarchar(250),         --��Ƭ�ļ����ڵ�·��
  FileSourceName nvarchar(250),     --��ƬԴ�ļ�����
  FileSizeDesc nvarchar(100),       --��Ƭͼ���С
  account nvarchar(20),
  password nvarchar(20),
  usertype tinyint,
  rememberflag tinyint,
  logindate datetime,
  Notes ntext                 --��ע�����˼�飩
)
GO
truncate table teachers
insert into Teachers (TeacherID,Name,pycode,Gender,Title,Degree,BirthDate,hiredate,deptID,Password,address,graduate,homephone,research,province,city,party,account,usertype)
values('20000551','����','mayun','��','����','��ʿ�о���','1964-12-11','1990-5-18','D1','zxy','�㽭ʡ��������ɳ�߽�԰��','����ʦ����ѧ','86811234','��ҵ����;���򾭼�ѧ;������Ϣϵͳ;��������','�㽭ʡ','������','����ѧ��','mayun','1')
insert into Teachers (TeacherID,Name,pycode,Gender,Title,Degree,BirthDate,hiredate,deptID,Password,address,graduate,homephone,research,account,usertype)
values('20000552','ţ��','Newton','��','����','˶ʿ','1964-8-1','2000-5-8','D1','zxy','hangzhou','zstu','8681','��ҵ����;���򾭼�ѧ;������Ϣϵͳ;��������;��Ϣϵͳ��������','zxywolf@126.com','1')
insert into Teachers (TeacherID,Name,pycode,Gender,Title,Degree,BirthDate,hiredate,deptID,Password,account,usertype)
values('20000553','����˹̹','Einstein','��','����','��ʿ','1955-8-1','1996-4-6','D2','123456','zxywolf','1')
insert into Teachers (TeacherID,Name,pycode,Gender,Title,Degree,BirthDate,hiredate,deptID,Password,research,account,usertype)
values('20000555','���޸�','Hualuogeng','��','����','˶ʿ','1955-8-1','1998-1-6','D1','','������Ϣϵͳ;��������;��Ϣϵͳ��������','math','1')
insert into Teachers (TeacherID,Name,pycode,Gender,Title,Degree,BirthDate,hiredate,deptID,Password,account,usertype)
values('20000554','ף����','zhuxiyong','��','����','˶ʿ','1964-8-1','1986-8-1','D2','zxy','zxywolf@163.com','3')
GO
create table Students (
  StudentID nchar(12) primary key,    --ѧ������
  Name nchar(20),            --ѧ������
  Pycode varchar(40),    --ƴ��
  IDNumber nchar(18),        --���֤��
  Gender nchar(2),           --�Ա� 
  DeptID nchar(10),          --ѧ�����ڲ���
  Class nchar(30),           --ѧ�����ڰ༶
  BirthDate date,        --��������
  AdmissionDate datetime,    --��ѧ����
  ClassID varchar(6),
  Graduate nvarchar(100),    --��ѧ��ҵѧУ
  Party nvarchar(20),        --����
  Title  nvarchar(20),       --��ίְ��
  Province nvarchar(30),     --����ʡ
  City nvarchar(30),         --������
  Nationality nvarchar(20),  --����
  Address nvarchar(100),     --��ͥ��ַ
  zip nchar(6),       --��������
  Mother nvarchar(20),       --ĸ������
  Father nvarchar(20),       --��������
  MotherPhone nvarchar(20),  --ĸ�׵绰
  FatherPhone nvarchar(20),  --���׵绰
  HomePhone nvarchar(20),     --��ͥ�绰
  Mobile nvarchar(20),        --�ƶ��绰
  Email nvarchar(40),         --��������
  weixin nvarchar(30),       --΢��
  QQ nvarchar(20),       --qq
  Homepage nvarchar(40),      --������ҳ
  Speciality nvarchar(250),    --�����س������Զ�����ֺŷָ���
  Honor nvarchar(250),        --�����ƺ�
  Score decimal(6,2),
  Resume ntext,               --���˼���
  photoPath nvarchar(100),   --��Ƭ·��
  account nvarchar(20),
  password nvarchar(20),
  usertype tinyint,
  rememberflag tinyint,
  logindate datetime,
  Notes ntext                 --��ע
)
GO
--�γ̱�
create table Courses (
  CourseID nchar(8) primary key,    --�γ̱�
  CourseName nvarchar(100),                --�γ�����
  EnglishName nvarchar(250),        --�γ�Ӣ������
  Language char(1),   --1˫��   2-��Ӣ��
  CategoryID nchar(20),      --�γ����
  Credit decimal(3,1),       --ѧ��
  Hours int,                 --ѧʱ
  DeptID nchar(10),          --����ϵ
  Type nvarchar(20),
  Description ntext,         --�γ̼��
  sortflag tinyint default 0,
  Note ntext                 --��ע
)
GO
------------------------------------------------products-------------------------------
/************************ Products ��Ʒ��*************************/
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
	Taxrate decimal(6,2) default 0, --��ֵ˰��
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
/********************** Suppliers ��Ӧ�̱�************************/
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
	Type nvarchar(40) default '',  --���
	Source nvarchar(40) default '',  --��Դ
	Status nvarchar(40) default '',  --״̬
	Industry nvarchar(40) default '',  --��ҵ
	ContactDate date default '',    --������ϵ����
	Filepath nvarchar(255) default '',
	filename nvarchar(255) default '',
	Notes ntext default '',
	Creator nvarchar(30) default '',
	Operator nvarchar(30) default '',
	CreateDate date default '',
	UpdateDate date default '',
	AccountReceivable decimal(14,2) default 0  --���Ӧ���˿����
 )
GO
/*************************** Orders ������**************************/
CREATE TABLE Orders (
	OrderID nchar(20) PRIMARY KEY CLUSTERED,
	OrderDate date,
	CustomerID nchar(14) default '',
	EmployeeID nchar(14) default '',
	ContactID nchar(14) default '',
	RequiredDate date,    --Ҫ������ʱ��
	ShippedDate date ,   --ʵ�ʷ���ʱ��
    Freight decimal(12,2) DEFAULT 0,   --�˷�
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
	EmployeeID nvarchar(14) default '',    --�����Ա��
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
