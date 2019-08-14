<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<!doctype html>
<html lang="en">
<style type="text/css">
	.bg { background-color:red }
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
<form id='main' style="margin:0px 0px 0px 0px;">
</form>    
<script>
	$(document).ready(function() {
		//example19_storedprocedure.jsp
		myForm('myForm1','main','学生信息编辑',0,0,285,600,'');
		myFieldset('myFieldset1','myForm1','基本信息',10,  10,230,265);
		myFieldset('myFieldset2','myForm1','通信信息',10, 293,230,290);
		myTextField('stuid','myFieldset1','学号：',70,33*0+20,12,0,120,'D20101');
		myTextField('stuname','myFieldset1','姓名：',70,33*1+20,12,0,165,'贾宝玉');
		myTextField('pycode','myFieldset1','汉语拼音：',70,33*2+20,12,0,165,'');
		myDateField('birthdate','myFieldset1','出生日期：',70,33*3+20,12,0,120,'1917-2-17');
		myComboField('gender','myFieldset1','性别：',70,33*4+20,12,0,120,'男;女','');
		myNumericField('weight','myFieldset1','体重：',70,33*5+20,12,0,120,8,2,'60.25','10','150');
		myLabelField('label1', 'myFieldset1','KG',33*5+18+7,220,0,0);
		myTextField('address','myFieldset2','家庭地址：',70,33*0+20,12,0,190,'浙江省杭州市西湖区');
		myTextField('mobile','myFieldset2','手机号码：',70,33*1+20,12,0,190,'');
		myTextField('homephone','myFieldset2','家庭电话：',70,33*2+20,12,0,190,'');
		myTextField('email','myFieldset2','Email：',70,33*3+20,12,0,190,'zxywolf@163.com');
		myTextField('qq','myFieldset2','QQ号：',70,33*4+20,12,0,190,'857199052');
		myTextField('weixin','myFieldset2','微信号：',70,33*5+20,12,0,190,'zxywolf888');
		mySelectOnFocus();
 		$("#stuid").next("span").find("input").focus();
 		$("#stuid").select();  //聚焦时全选文本，但IE不支持
 		//定义按钮事件
 		$('#stuname').textbox({
			buttonIcon:'locateIcon',
            onClickButton: function(e){
				$.ajax({
					url: "example19_getpycode_server.jsp",
					data: { database: sysdatabasestring, chnstr: $("#stuname").textbox("getValue") }, 
					async: false, method: 'post',    
					success: function(data) {
						eval("var result="+data);
						console.log(result);
						$("#pycode").textbox("setValue",result.pycode); 
					},     
					error: function(err) {     
						console.log(err);     
					}     
				});
			}
		});

 		$("#pycode").textbox({
 			buttonIcon:'helpIcon',
            onClickButton: function(e){
				var xsql="select dbo.sys_GenPycode('"+$("#stuname").textbox("getValue")+"') as pycode";
				$.ajax({
					url: "system/easyui_execSelect.jsp",
					data: { database: sysdatabasestring, selectsql:xsql }, 
					async: false,    
					success: function(data) {
						eval("var result="+data);
						$("#pycode").textbox("setValue",result[0].pycode); 
					},     
					error: function(err) {     
						console.log(err);     
					}     
				});
			}
 		});
 		//重新绑定键盘处理事件
 		//myKeyDownEvent('stuname'); 
 		//myKeyDownEvent('pycode');
 		myKeyDownEvent('');  //键盘控制
 		
	//---------------------end of jquery------------------------
	});
</script>
</body>
</html>