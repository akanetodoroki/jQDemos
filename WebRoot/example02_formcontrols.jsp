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
<div id='main' style="margin:2px 2px 2px 2px;">
	<div class="easyui-panel" id="myForm1" title="&nbsp;学生信息编辑" style="background:#fafafa;" data-options="iconCls:'panelIcon'" >
		<fieldset id="myFieldset1" style="position:relative; top:10px; left:10px; width:300px; height:230px; padding: 2px 0px 0px 16px; border:1px solid #B5B8C8;" > 
			<legend>基本信息</legend>
			<p>学号：<input class="easyui-textbox" type="text" id="stuid" style="padding:0px 2px 0px 4px"></input></p> 
			<p>姓名：<input class="easyui-textbox" type="text" id="stuname" style="padding:0px 2px 0px 4px"></input></p> 
			<p>拼音：<input class="easyui-textbox" type="text" id="pycode" style="padding:0px 2px 0px 4px"></input> </p>
			<p>性别：<input class="easyui-combobox" type="text" id="gender" style="padding:0px 2px 0px 4px"></input> </p>
			<p>出生日期：<input class="easyui-datebox" type="text" id="birthdate" style="padding:0px 2px 0px 4px"></input> </p>
			<p>体重：<input class="easyui-numberbox" type="text" id="weight" style="padding:0px 2px 0px 4px;"></input> </p>
		</fieldset>
		<fieldset id="myFieldset2" style="position:relative; top:20px; left:10px; width:300px; height:200px; padding: 2px 0px 0px 16px; border:1px solid #B5B8C8;" >
			<legend>通信信息</legend>
			<p>家庭地址：<input class="easyui-textbox" type="text" id="address" style="padding:0px 2px 0px 4px"></input></p> 
			<p>手机号码：<input class="easyui-textbox" type="text" id="mobile" style="padding:0px 2px 0px 4px"></input></p> 
			<p>家庭电话：<input class="easyui-textbox" type="text" id="homephone" style="padding:0px 2px 0px 4px"></input> </p>
			<p>Email：<input class="easyui-textbox" type="text" id="email" style="padding:0px 2px 0px 4px"></input> </p>
			<p>微信号：<input class="easyui-textbox" type="text" id="weixin" style="padding:0px 2px 0px 4px"></input> </p>
		</fieldset>
	</div>
</div>
<script>
	$(document).ready(function(){   //jquery代码从此开始
		//example02_formcontrols.jsp
		var gendersource=[{'gender':'男'},{'gender':'女'}];
		$("#myForm1").panel({width:345, height:505});
		$("#stuid").textbox({width:120});
		$("#birthdate").datebox({width:120});
		$("#weight").numberbox({width:120});
		$("#gender").combobox({width:120, data:gendersource, valueField:'gender', textField:'gender'});
		var items = $('#gender').combobox('getData');
		$("#gender").combobox('select', items[0].gender);
		$("#stuid").textbox('setValue','20143305001');
		$("#stuname").textbox('setValue','诸葛亮');
		$("#birthdate").datebox('setValue','2015-9-10');
		$("#weight").numberbox({precision:1, max:200, min:30});
		$("#weight").numberbox('setValue',65.5);
		$("#weight").numberbox('textbox').css('text-align','right');
    });   //jquery代码从此结束
</script>
</body>
</html>
