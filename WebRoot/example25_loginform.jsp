<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<!doctype html>
<html lang="en">
<style type="text/css">
.form_wrapper{
	background:#fff;
	border:1px solid #ddd;
	margin:0 auto;
	width:350px;
	height:450px;
	font-size:16px;
	-moz-box-shadow:1px 1px 7px #ccc;
	-webkit-box-shadow:1px 1px 7px #ccc;
	box-shadow:1px 1px 7px #ccc;
}
.form_wrapper input[type="submit"] {
	background: #e3e3e3;
	border: 1px solid #ccc;
	color: #333;
	font-family: "Trebuchet MS", "Myriad Pro", sans-serif;
	font-size: 14px;
	font-weight: bold;
	padding: 8px 0 9px;
	text-align: center;
	width: 150px;
	cursor:pointer;
	float:right;
	margin:15px 20px 10px 10px;
	text-shadow: 0px 1px 0px #fff;
	-moz-border-radius: 4px;
	-webkit-border-radius: 4px;
	border-radius: 4px;
	-moz-box-shadow: 0px 0px 2px #fff inset;
	-webkit-box-shadow: 0px 0px 2px #fff inset;
	box-shadow: 0px 0px 2px #fff inset;
}
.form_wrapper input[type="submit"]:hover {
	background: #d9d9d9;
	-moz-box-shadow: 0px 0px 2px #eaeaea inset;
	-webkit-box-shadow: 0px 0px 2px #eaeaea inset;
	box-shadow: 0px 0px 2px #eaeaea inset;
	color: #222;
}
.form_wrapper div.remember{
	float:left;
	width:140px;
	margin:20px 0px 20px 30px;
	font-size:11px;
}
.form_wrapper div.remember input{
	float:left;
	margin:2px 5px 0px 0px;
}
</style>
<head>
	<meta charset="utf-8">
	<meta name="description" content="Expand, contract, animate forms with jQuery wihtout leaving the page" />
	<meta name="keywords" content="expand, form, css3, jquery, animate, width, height, adapt, unobtrusive javascript"/>
	<link rel="stylesheet" type="text/css" href="jqeasyui/themes/default/easyui.me.css">
	<link rel="stylesheet" type="text/css" href="jqeasyui/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="system/css/icon.css">
    <script type="text/javascript" src="jqeasyui/jquery.min.js"></script>
    <script type="text/javascript" src="jqeasyui/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="jqeasyui/easyui-lang-zh_CN.js"></script>	
	<script type="text/javascript" src="system/easyui_functions.js"></script>
	
</head>
<body id="main" style="margin: 20px 1px 1px 1px;">
</div>
	<div id="form_wrapper" class="form_wrapper">
		<div style="padding:20px 30px 20px 30px;background-color:#444;	color:#fff;	font-size:20px;	border-bottom:1px solid #ddd;">登录</div>
		<div style="display:block;	padding:10px 30px 0px 30px;	margin:10px 0px 0px 0px;">
			用户名:
			<input id="username" type="text" class='easyui-textbox'	style="height:34px; width:290px;"/>
		</div>
		<div style="display:block;	padding:10px 30px 0px 30px;	margin:10px 0px 0px 0px;">
			密码:
			<input id="password" type="text" class='easyui-textbox'	style="height:34px; width:290px;"/>
		</div>
		<div style="display:block;	padding:10px 30px 0px 30px;	margin:10px 0px 0px 0px;">
			验证码:
			<input id="code" type="text" class='easyui-textbox'	style="height:34px; width:120px;"/>
		</div>

		<div style="height:80px; margin:30px 0px 0px 0px; padding:20px 30px 20px 30px;background-color:#444; color:#fff; font-size:12px;	border-bottom:1px solid #ddd;">
			<div class="remember"><input type="checkbox" />请记住我</div>
			<input type="submit" value="登录"></input>
			<div ><a href="">用户注册</a></div>
		</div>

	</div>
	<script type="text/javascript">
		$("#username").textbox();
	</script>
</body>
</html>