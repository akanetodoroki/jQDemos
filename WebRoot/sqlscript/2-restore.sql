use master
if (db_id('jqdemos') is not null)  drop database jqdemos
go
restore database jqdemos from disk='d:\myjsp\jqdemos64.bak' with replace
 