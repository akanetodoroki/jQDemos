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
		//example04_appendcontrols.jsp
		//定义easyui-panel容器控件
		var str='<div class="easyui-panel" id="myForm1" title="&nbsp;学生信息编辑" style="position:relative; background:#fafafa;" data-options="iconCls:\'panelIcon\'" >';
		$("#main").append($(str));  //在main容器下嵌入一个panel表单
		str='<fieldset id="myFieldset1" style="position:absolute; top:10px; left:10px; width:300px; height:210px; padding: 2px 0px 0px 16px; border:1px solid #B5B8C8;" ><legend>基本信息</legend></fieldset>';
		$("#myForm1").append($(str));  //在myForm1容器下嵌入一个fieldset表单
		str='<fieldset id="myFieldset2" style="position:absolute; top:235px; left:10px; width:300px; height:180px; padding: 2px 0px 0px 16px; border:1px solid #B5B8C8;" ><legend>通信信息</legend></fieldset>';		
		$("#myForm1").append($(str));  //在myForm1容器下嵌入另一个fieldset表单
		//生成表单编辑控件
		str='<label id="stuid_label">学号：</label>';
		str+='<div id="stuid_div"><input class="easyui-textbox" type="text" id="stuid"></input></div>\n';
		str+='<label id="stuname_label">姓名：</label><div id="stuname_div"><input class="easyui-textbox" type="text" id="stuname"></input></div>\n';
		str+='<label id="pycode_label">拼音：</label><div id="pycode_div"><input class="easyui-textbox" type="text" id="pycode"></input></div>\n';
		str+='<label id="gender_label">性别：</label><div id="gender_div"><input class="easyui-combobox" type="text" id="gender"></input></div>\n';
		str+='<label id="birthdate_label">出生日期：</label><div id="birthdate_div"><input class="easyui-datebox" type="text" id="birthdate"></input></div>\n';
		str+='<label id="weight_label">体重：</label><div id="weight_div"><input class="easyui-textbox" type="text" id="weight"></input></div>\n';
		str+='<label id="weightx_label">KG</label>';
		$("#myFieldset1").append($(str));
		str='<label id="address_label">家庭地址：</label><div id="address_div"><input class="easyui-textbox" type="text" id="address" style="padding:0px 2px 0px 4px"></input></div>\n';
		str+='<label id="mobile_label">手机号码：</label>';
		str+='<div id="mobile_div"><input class="easyui-textbox" type="text" id="mobile" style="padding:0px 2px 0px 4px"></input></div>\n';
		str+='<label id="homephone_label">家庭电话：</label>';
		str+='<div id="homephone_div"><input class="easyui-textbox" type="text" id="homephone" style="padding:0px 2px 0px 4px"></input></div>\n';
		str+='<label id="email_label">Email：</label><div id="email_div"><input class="easyui-textbox" type="text" id="email" style="padding:0px 2px 0px 4px"></input></div>\n';
		str+='<label id="weixin_label">微信号：</label><div id="weixin_div"><input class="easyui-textbox" type="text" id="weixin" style="padding:0px 2px 0px 4px"></input></div>\n';
		//$("#myFieldset2").append($(str));
		$(str).appendTo("#myFieldset2");

		//控件位置布局
		$("#stuid_label").css({position: "absolute", top:"23px", left:"10px", width:"65px", "text-align":"right", "z-index":2});
		$("#stuid_div").css({position: "absolute", top:"20px", left:"76px", "z-index":2});

		$("#stuname_label").css({position: "absolute", top:"53px", left:"10px", width:"65px", "text-align":"right", "z-index":2});
		$("#stuname_div").css({position: "absolute", top:"50px", left:"76px","z-index":2});

		$("#pycode_label").css({position: "absolute", top:"83px", left:"10px", width:"65px", "text-align":"right", "z-index":2});
		$("#pycode_div").css({position: "absolute", top:"80px", left:"76px", "z-index":2});

		$("#gender_label").css({position: "absolute", top:"113px", left:"10px", width:"65px", "text-align":"right", "z-index":2});
		$("#gender_div").css({position: "absolute", top:"110px", left:"76px", "z-index":2});

		$("#birthdate_label").css({position: "absolute", top:"143px", left:"10px", width:"65px", "text-align":"right", "z-index":2});
		$("#birthdate_div").css({position: "absolute", top:"140px", left:"76px", "z-index":2});

		$("#weight_label").css({position: "absolute", top:"173px", left:"10px", width:"65px", "text-align":"right", "z-index":2});
		$("#weight_div").css({position: "absolute", top:"170px", left:"76px", "z-index":2});
		$("#weightx_label").css({position: "absolute", top:"173px", left:"190px", width:"25px", "text-align":"right", "z-index":2});

		$("#address_label").css({position: "absolute", top:"23px", left:"10px", width:"65px", "text-align":"right", "z-index":2});
		$("#address_div").css({position: "absolute", top:"20px", left:"76px", "z-index":2});

		$("#mobile_label").css({position: "absolute", top:"53px", left:"10px", width:"65px", "text-align":"right", "z-index":2});
		$("#mobile_div").css({position: "absolute", top:"50px", left:"76px", "z-index":2});

		$("#homephone_label").css({position: "absolute", top:"83px", left:"10px", width:"65px", "text-align":"right", "z-index":2});
		$("#homephone_div").css({position: "absolute", top:"80px", left:"76px", "z-index":2});

		$("#email_label").css({position: "absolute", top:"113px", left:"10px", width:"65px", "text-align":"right", "z-index":2});
		$("#email_div").css({position: "absolute", top:"110px", left:"76px", "z-index":2});

		$("#weixin_label").css({position: "absolute", top:"143px", left:"10px", width:"65px", "text-align":"right", "z-index":2});
		$("#weixin_div").css({position: "absolute", top:"140px", left:"76px", "z-index":2});


		$("#myForm1").panel({width:345, height:465});
		$("#stuid").textbox({width:120});
		$("#birthdate").datebox({width:120});
		$("#weight").numberbox({width:120});
		$("#stuid").textbox('setValue','20143305001');
		//$("#stuname").textbox('setValue','诸葛亮');
		$("#birthdate").datebox('setValue','2015-9-10');
		$("#weight").numberbox({precision:1, max:200, min:30});
		$("#weight").numberbox('setValue',65.5);
		$("#weight").numberbox('textbox').css('text-align','right');
		//设置combobox
		var gendersource=[{'gender':'男'},{'gender':'女'}];
		$("#gender").combobox({width:120, data:gendersource, valueField:'gender', textField:'gender'});
		var items = $('#gender').combobox('getData');
		$("#gender").combobox('select', items[0].gender);
		$("#address").textbox({width:230});
    }); 
</script>
</body>
</html>

