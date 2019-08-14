<%@ page language="java" import="java.util.*" contentType="text/html;charset=utf-8"  language="java"  pageEncoding="UTF-8" %>
<!doctype html>
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
<body id='main' class="easyui-layout" data-options="fit:true" style="margin: 100px 1px 1px 460px;">	
<script>
$(document).ready(function() {
	
	myForm('myForm1','main','用户信息',0,0,430,340,'');
	myFieldset('myFieldset1','myForm1','基本信息',10,10,250,280);
	myTextField('account','myFieldset1','账号：',70,36*0+20,12,0,175);
	myTextField('password','myFieldset1','密码：',70,36*1+20,12,0,175);
	myTextField('codex','myFieldset1','验证码：',70,36*2+20,12,0,175,'');
	str='<img id="codeimg" src="system/images/5keYC.jpg"></img>';
	$("#myFieldset1").append($(str));
	$("#codeimg").css({position:'absolute',top:120,left:140});
	myButton('ok','myForm1','确认',200,70,0,70);
	myButton('cancel','myForm1','取消',200,150,0,70);
	codesource=myRunSelectProcedure('jqdemos','code','');
	var src=codesource[0].codesrc;
	$("#codeimg").attr('src',src);
	//mySetValue('codey', codesource[0].codeid); //src img
	//定义事件		
	$("#ok").bind('click',function(e){
		errormsg='';
		if (myGetValue('account')=='') errormsg+='用户账号不能为空';
		if (myGetValue('password')=='') errormsg+='<br>登录密码不能为空';
		s1=myGetValue('account');
		s2=myGetValue('password');
		s3=myGetValue('codex');
		if (s3!=codesource[0].codeid) errormsg+='<br>验证码错误';
		if (errormsg==''){
			s=s1+'	'+s2;  //tab
			source=myRunSelectProcedure('jqdemos','login1',s);
			console.log(source);
			if (source[0].n2==1){
				$.messager.show({
					title:'系统提示',
					msg:'登录成功！',
					showType:'show',
					width:200,
					timeout:0,
					style:{
						top: 100,
						left:40
					}
				});
				document.location = "indexx.jsp";
			}else if (source[0].n1==1){
				$.messager.show({
					title:'系统提示',
					msg:'密码错误！',
					showType:'show',
					width:200,
					timeout:0,
					style:{
						top: 100,
						left:40
					}
				});
			}else{
				$.messager.show({
					title:'系统提示',
					msg:'该用户不存在！',
					showType:'show',
					width:200,
					timeout:0,
					style:{
						top: 100,
						left:40
					}
				});
			}
		}else{
			$.messager.show({
				title:'系统提示',
				msg:errormsg,
				showType:'show',
				width:200,
				timeout:0,
				style:{
					//right:'',
					top: 100,
					left:40
					//bottom:''
				}
			});
		}	
	});
	//添加在函数中没有涉及的属性和事件
	$("#password").textbox({
		type:'password'			
	});
	$("#account").next("span").find("input").focus();
	function myRunSelectProcedure(database,proc,valuelist){  //单行结果集
		result={};
		$.ajax({     
			type: "Post",     
			url: "system/easyui_runSelectStoredProcedure.jsp",     
			//contentType: "application/json; charset=utf-8",     
			//dataType: "json", 
			data: {sqlprocedure:proc,paramvalues:valuelist}, 
			async: false, method: 'post',   
			success: function(data) {     
				//返回的数据用data获取内容,直接复制到客户端数组source      
				eval("result="+data);
			},     
			error: function(err) {     
				result="{'error':'"+err+"'}";     
			}     
		});
		return (result); 
	}
});
</script>
</body>
</html>