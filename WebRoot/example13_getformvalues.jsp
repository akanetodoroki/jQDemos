<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
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
<body class="easyui-layout" data-options="fit:true" style="margin: 2px 2px 2px 2px;">
	<div id='toolbar' class='easyui-panel' data-options="region:'north'" style="overflow:hidden; background-color: #E0ECFF; height:30px;"></div>
	<div id='main' class='easyui-panel' data-options="region:'center'"></div>
    <script>
	$(document).ready(function() {
		myWindow('myWin1','JSon格式数据',10,400,200,520,'','close');
		myTextareaField('xformvalues','myWin1','',0,2,1,152,482,'','');		
		myForm('myForm1','main','学生信息编辑',0,0,790,385,'');
		myFieldset('myFieldset1','myForm1','基本信息',10,12,230,358);
		myFieldset('myFieldset2','myForm1','通信信息',255,12,230,358);
		myFieldset('myFieldset3','myForm1','个人简介',500,12,240,358);
		myTextField('stuid','myFieldset1','学号：',70,33*0+20,12,0,120,'D20101');
		myTextField('stuname','myFieldset1','姓名：',70,33*1+20,12,0,160,'贾宝玉');
		myTextField('pycode','myFieldset1','汉语拼音：',70,33*2+20,12,0,160,'jiabaoyu');
		myDateField('birthdate','myFieldset1','出生日期：',70,33*3+20,12,0,135,'1997-2-17');
		myComboField('gender','myFieldset1','性别：',70,33*4+20,12,0,165,'男;女;tty;ytytyt;fere;ere;re;re;rer;er;er;er;rerere;rert4;er;wrew;r;r;erqw;erw;ew;ew;e;wew;ew;ew;ew;ew;ew;ew;e','');
		myNumericField('weight1','myFieldset1','体重：',70,33*5+20,12,0,135,8,2,'60.25','10','100');
		myLabelField('label1', 'myFieldset1','KG',33*5+18+7,235,0,0);
		myTextField('address','myFieldset2','家庭地址：',70,33*0+20,12,0,240,'浙江省杭州市西湖区');
		myTextField('mobile','myFieldset2','手机号码：',70,33*1+20,12,0,180,'');
		myTextField('homephone','myFieldset2','家庭电话：',70,33*2+20,12,0,180,'');
		myTextField('email','myFieldset2','Email：',70,33*3+20,12,0,180,'zxywolf@163.com');
		myTextField('qq','myFieldset2','QQ号：',70,33*4+20,12,0,180,'857199052');
		myTextField('weixin','myFieldset2','微信号：',70,33*5+20,12,0,180,'zxywolf888');
		myCheckBoxField('hobby1','myFieldset3','个人特长：',65,33*0+20,12,'围棋',1);
		myCheckBoxField('hobby2','myFieldset3','',0,33*0+20,145,'国际象棋',true);
		myCheckBoxField('hobby3','myFieldset3','',0,33*0+20,235,'足球',0);
		myCheckBoxField('hobby4','myFieldset3','',0,33*1+20,77,'长跑',1);
		myCheckBoxField('hobby5','myFieldset3','',0,33*1+20,145,'数学',1);
		myCheckBoxField('hobby6','myFieldset3','',0,33*1+20,235,'信息技术',0);

		myMemoField('notes','myFieldset3','个人简介：',0,33*2+5,10,130,320,'');
		myButton('cmdsave','toolbar','取值',3,10,24,70,'saveIcon','');
		myButton('cmdreset','toolbar','清空',3,81,24,70,'refreshIcon','');
		$("#cmdsave").click(function(event) {
			var data='';
			$("#xformvalues").val('');
			$('input, select, textarea').each(function(index){
				var input = $(this);
				var id=input.attr('id');
				var value=undefined;
				var type=input.attr('type');
				var hidden=input.attr('hidden');
				if (id!=undefined){
					if (type=='text' && hidden!='hidden'){ 
						value=input.textbox('getValue');
					}else if (type=='combobox'){ 
						value=input.combobox('getValue');
					}else if (type=='checkbox'){
						if (input.is(':checked')) value=input.attr('xtext');
					}else if (type!='button'){
						value=input.val();			
					}
					if (value!=undefined){
						if (data!='') data+=',';			
						data+='"'+id+'":"'+value+'"';
						console.log(id+'----'+type+'----'+value);
					}
				}
		   	});
		   	data='{'+data+'}';
		   	$("#myWin1").window('open');
		   	$("#xformvalues").val(data);		
		});
		 
    }); 
    </script>
</body>
</html>