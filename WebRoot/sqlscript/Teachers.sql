use jqdemos
truncate table teachers
insert into Teachers (TeacherID,Name,pycode,Gender,Title,Degree,BirthDate,hiredate,deptID,Password,address,graduate,homephone,research,province,city,party)
values('20000551','马云','mayun','男','教授','博士研究生','1964-12-11','1990-5-18','D1','zxy','浙江省杭州市下沙高教园区','杭州师范大学','86811234','企业管理;区域经济学;管理信息系统;电子商务','浙江省','杭州市','九三学社')
insert into Teachers (TeacherID,Name,pycode,Gender,Title,Degree,BirthDate,hiredate,deptID,Password,address,graduate,homephone,research)
values('20000552','牛顿','Newton','男','教授','硕士','1964-8-1','2000-5-8','D1','zxy','hangzhou','zstu','8681','企业管理;区域经济学;管理信息系统;电子商务;信息系统开发技术')
insert into Teachers (TeacherID,Name,pycode,Gender,Title,Degree,BirthDate,hiredate,deptID,Password)
values('20000553','爱因斯坦','Einstein','男','教授','博士','1955-8-1','1996-4-6','D2','123456')
insert into Teachers (TeacherID,Name,pycode,Gender,Title,Degree,BirthDate,hiredate,deptID,Password,research)
values('20000554','华罗庚','Hualuogeng','男','教授','硕士','1955-8-1','1998-1-6','D1','','管理信息系统;电子商务;信息系统开发技术')
GO