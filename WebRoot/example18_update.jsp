<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<html>
<style type="text/css">
</style>
<head>
	<meta charset="utf-8">
	<link rel="stylesheet" type="text/css" href="jqeasyui/themes/default/easyui.me.css">
	<link rel="stylesheet" type="text/css" href="jqeasyui/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="system/css/icon.css">
    <script type="text/javascript" src="jqeasyui/jquery.min.js"></script>
    <script type="text/javascript" src="jqeasyui/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="jqeasyui/easyui-lang-zh_CN.js"></script>	
	<script type="text/javascript" src="system/easyui_functions.js"></script>
</head>
<body style="margin: 2px 2px 2px 2px;">
<div id="main" style="margin:2px 2px 2px 2px;">
</div>
<script>
	$(document).ready(function(){
		sql="";  //全局变量，不能写var sql，否则是局部变量 
		myForm('myForm1','main','数据库连接与数据更新',0,0,340,600,'');
		myTextareaField('sqlstmt','myForm1','SQL语句：',0,10,8,75,575,'','');
		myTextareaField('result','myForm1','查询结果：',0,115,8,130,575,'','');
		myButton('cmdcreate','myForm1','建表',275,370,25,70,'','');
		myButton('cmdinsert','myForm1','插入',275,441,25,70,'','');
		myButton('cmddelete','myForm1','删除',275,512,25,70,'','');
		$("#cmdinsert").linkbutton('disable');
		$("#cmddelete").linkbutton('disable');
		var updatesql='';
		//按钮点击事件
		$("#cmdcreate").on('click', function() {
			var updatesql="if (object_id('myProvinces') is not null)\n DROP TABLE myProvinces\n CREATE TABLE myProvinces(ProvinceID nchar(10) primary key, ProvinceName nvarchar(30))"; 
			$("#sqlstmt").val(updatesql);
			sql="select name,CONVERT(varchar(10),crdate,120) as 'createdate' from sysobjects where name like 'my%'"; 
			fnrunUpdate(updatesql);
			$("#cmdinsert").linkbutton('enable');				
		});
		$("#cmdinsert").on('click', function() {
			sql="select * from myProvinces";
			var updatesql="TRUNCATE TABLE myProvinces;\n INSERT INTO myProvinces (ProvinceID, ProvinceName) SELECT areaid,areaname FROM areas WHERE ParentnodeID=''"; 
			$("#sqlstmt").val(updatesql);	
			fnrunUpdate(updatesql);	
			$("#cmddelete").linkbutton('enable');
		});
		$("#cmddelete").on('click', function() {
			sql="select * from myProvinces";
			var updatesql="DELETE myProvinces WHERE ProvinceID in (SELECT TOP 10 ProvinceID FROM myProvinces)";
			$("#sqlstmt").val(updatesql);	
			fnrunUpdate(updatesql);
		});
		
	});	

	function fnrunUpdate(updatesql){
		$("#result").val('');
		$.ajax({
			url: "system/easyui_execUpdate.jsp",
			data: { database: sysdatabasestring, updatesql: updatesql }, 
			async: false,  method:'post',  
			success: function(data) {
				eval("var result="+data);
				if (result.error==''){
					fnrunSelect();
				 } 
			},     
			error: function(err) {     
				console.log(err);     
			}     
		});
	}
	
	function fnrunSelect(){
		$.ajax({
			url: "system/easyui_execSelect.jsp",
			data: { database: sysdatabasestring, selectsql: sql }, 
			async: false,  method:'post',  //IE游览器中post一定要写  
			success: function(data) {
				$("#result").val(data);
			},     
			error: function(err) {     
				console.log(err);     
			}     
		});
	}
    </script>
</body>
</html>