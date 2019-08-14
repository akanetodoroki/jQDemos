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
		var sql="select areaid,areaname from areas where parentnodeid=''"; 
		myForm('myForm1','main','数据库连接与数据检索',0,0,365,600,'');
		myTextareaField('sqlstmt','myForm1','查询语句：',0,10,8,70,575,'','');
		myTextareaField('result','myForm1','查询结果：',0,115,8,155,575,'','');
		myButton('cmdquery','myForm1','运行SQL',300,430,25,75,'','');
		myButton('cmdreset','myForm1','清空',300,506,25,70,'','');
		$("#sqlstmt").val(sql);
		//按钮点击事件
		$("#cmdreset").on('click', function() {
			$("#sqlstmt").val(sql);	
			$("#result").val('');	
		});

		$("#cmdquery").on('click', function() {
			var xsql=$("#sqlstmt").val();
			$.ajax({
				url: "system/easyui_execSelect.jsp",
				data: { database: sysdatabasestring, selectsql: xsql }, 
				async: false, method: 'post',    
				success: function(data) {
					$("#result").val(data); //赋值
				},     
				error: function(err) {     
					console.log(err);     
				}     
			});
		});
	});	


     
    </script>
</body>
</html>