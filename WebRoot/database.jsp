<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String path = request.getRealPath("/"); //request.getContextPath();
	path=path.replace("\\","\\\\");
	//String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!doctype html>
<html lang="en">
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
<div id='main' style="margin:0px 0px 0px 0px;">
</div>    
<script>
	var basepath='<%=path%>';
	$(document).ready(function() {
		sysdatabasestring=syshostname+'	'+syssqlpassword+'	'+'master';  
		myForm('myForm1','main','恢复数据库',0,0,220,520,'drag;close');
		myMemoField('results','myForm1','',0,52,10,120,480,'结果反馈：');
		myButton('btntest','myForm1','连接测试',10,20,30,80,'','','');
		myButton('btn64','myForm1','Win64位',10,250,30,80,'','','');
		myButton('btn32','myForm1','Win32位',10,250+81,30,80,'','','');
		myButton('btnscript','myForm1','运行脚本',10,250+81*2,30,80,'','','');
		var sqlfiles='emlab;accounts;areas;customers;dictionary;jqdemos;orders;orderitems;'+
		'products;resourcecategories;students;suppliers;'+
		'sys_FloatToRmb;sys_getPycode;sys_unicodes;teachers;tree';
		$("#btn64").linkbutton('disable');
		$("#btn32").linkbutton('disable');
		$("#btnscript").linkbutton('disable');
		//点击开始运行
		$('#btntest').bind('click',function(e){
			$("#results").val('');
        	$.ajax({
				url: "system/easyui_testSqlConnection.jsp",
				data: { database: sysdatabasestring}, 
				async: false, method: 'post',    
				success: function(data) {
					var message=data.trim()+'';
					if (message==''){
						$("#results").val('数据库连接测试成功！可以恢复数据库。');
						$("#btn64").linkbutton('enable');
						$("#btn32").linkbutton('enable');
						$("#btnscript").linkbutton('enable');						
					}else{
						$("#results").val('错误信息返回：\n'+message);
						$("#btn64").linkbutton('disable');
						$("#btn32").linkbutton('disable');
						$("#btnscript").linkbutton('disable');
					}
				}   
			});
		});
		
		//点击运行脚本，一个个分开运行	
		$('#btnscript').bind('click',function(e){
			$("#btn64").linkbutton('disable');
			$("#btn32").linkbutton('disable');
			$("#btnscript").linkbutton('disable');
			$("#btntest").linkbutton('disable');
			$("#results").val('正在运行脚本：');
			var message='';
			var files=sqlfiles.split(';');
			for (var i=0;i<files.length;i++){
				if (files[i]=='emlab'){
					var database=syshostname+'	'+syssqlpassword+'	'+'master';
				}else{
					var database=syshostname+'	'+syssqlpassword+'	'+sysdbname;
				}  
				console.log('正在运行:'+files[i]+'.sql');
		    	$.ajax({
					url: "system/easyui_runSqlScriptFile.jsp",
					data: { database: database, filename:files[i]+'.sql', filepath:'sqlscript' }, 
					async: false, method: 'post',    
					success: function(data) {
						var msg=data.trim()+'';
						message+='\n'+msg;
					}    
				});
			}
			$("#results").val('脚本运行结果：'+message);
			myShowMessage('数据库'+sysdbname+'和模拟数据已经创建成功！',240);
			$("#btn64").linkbutton('enable');
			$("#btn32").linkbutton('enable');
			$("#btnscript").linkbutton('enable');						
			$("#btntest").linkbutton('enable');						
		});
		
		//点击restore win64	
		$('#btn64').bind('click',function(e){
			$("#btn64").linkbutton('disable');
			$("#btn32").linkbutton('disable');
			$("#btnscript").linkbutton('disable');
			$("#results").val('正在恢复数据库：');
			var database=syshostname+'	'+syssqlpassword+'	'+'master';
			var sql="use master\n";
			sql+=" if (db_id('"+sysdbname+"') is not null)  drop database "+sysdbname+" \n";
			sql+=" restore database "+sysdbname+" from disk='"+basepath+sysdbname+"64.bak'\n";
			console.log(sql);
			var msg=myRunUpdateSql(database,sql);
			if (msg.error==''){
				$("#results").val('数据库'+sysdbname+'已经恢复成功！');
				myShowMessage('数据库'+sysdbname+'已经恢复成功！',200);
			}else{
				$("#results").val('数据库恢复失败！'+msg.error);
			}
			$("#btn64").linkbutton('enable');
			$("#btn32").linkbutton('enable');
			$("#btnscript").linkbutton('enable');					
					
		});
		
		//点击restore win32	
		$('#btn32').bind('click',function(e){
			$("#btn64").linkbutton('disable');
			$("#btn32").linkbutton('disable');
			$("#btnscript").linkbutton('disable');
			$("#results").val('正在恢复数据库：');
			var database=syshostname+'	'+syssqlpassword+'	'+'master';
			var sql="use master\n";
			sql+=" if (db_id('"+sysdbname+"') is not null)  drop database "+sysdbname+" \n";
			sql+=" restore database "+sysdbname+" from disk='"+basepath+sysdbname+"32.bak'\n";
			//console.log(sql);
			var msg=myRunUpdateSql(database,sql);
			if (msg.error==''){
				$("#results").val('数据库'+sysdbname+'已经恢复成功！');
				myShowMessage('数据库'+sysdbname+'已经恢复成功！',210);
			}else{
				$("#results").val('数据库恢复失败！'+msg.error);
			}
			$("#btn64").linkbutton('enable');
			$("#btn32").linkbutton('enable');
			$("#btnscript").linkbutton('enable');					
		});
		$("#myForm1").panel({
			onClose:function(){	
				window.location.href='index.jsp';
			}
		});		
		
	});  //endofjquery 
</script>
</body>
</html>