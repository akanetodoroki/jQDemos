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
    <script>
	$(document).ready(function() {
		//myTabForm('myTab','main','学生信息编辑','基本信息;联系信息;研究方向;个人简历;上传照片',0,0,322,715,'');
		//myForm('myForm','main','学生信息编辑',0,0,432,721,'close;collapse;min;max');
		myTabForm('myTab','main','学生信息编辑','基本信息;联系信息;研究方向;个人简历;上传照片',0,0,00,00,'');
		
		myFieldset('myFieldset1','myTab1','基本信息',10,10,240,290);
		myFieldset('myFieldset2','myTab2','通信信息',10,10,240,370);
		
		myTextField('stuid','myFieldset1','学号：',70,33*0+20,12,0,120,'D20101');
		myTextField('stuname','myFieldset1','姓名：',70,33*1+20,12,0,160,'祝锡永');
		myTextField('pycode','myFieldset1','汉语拼音：',70,33*2+20,12,0,160,'zhu');
		myDateField('birthdate','myFieldset1','出生日期：',70,33*3+20,12,0,120,'1997-2-17');
		myComboField('gender','myFieldset1','性别：',70,33*4+20,12,0,120,'男;女;take;book;tank;bank','');
		myNumericField('weight1','myFieldset1','体重：',70,33*5+20,12,0,120,8,2,'60.25','10','100');
		myLabelField('label1', 'myFieldset1','KG',33*5+18+7,235,0,0);

		myTextField('address','myFieldset2','家庭地址：',70,33*0+20,12,0,260,'浙江省杭州市西湖区');
		myTextField('mobile','myFieldset2','手机号码：',70,33*1+20,12,0,180,'');
		myTextField('homephone','myFieldset2','家庭电话：',70,33*2+20,12,0,180,'');
		myTextField('email','myFieldset2','Email：',70,33*3+20,12,0,180,'zxywolf@163.com');
		myTextField('qq','myFieldset2','QQ号：',70,33*4+20,12,0,180,'857199052');
		myTextField('weixin','myFieldset2','微信号：',70,33*5+20,12,0,180,'zxywolf888');
		myCheckBoxField('research','myTab3','研究方向：',70,33*0+20,12,24,4,'[u150]企业管理;[150]区域经济学;[150]管理信息系统;[150]信息系统开发技术;[150]电子商务;[150]信息系统开发技术;[150]电子商务');
		myCheckBoxField('researchx','myTab3','研究方向：',70,33*3+20,12,24,4,'[120]企业管理;区域经济学;管理信息系统;信息系统开发技术;电子商务;信息系统开发技术;电子商务');
		myMemoField('notes','myTab4','个人简介：',0,10,10,228,685,'');
		myFileUpLoadField('photo','myTab5','',0,10,10,0,500,'个人照片');
		//
		myKeyDownEvent('');
		
    }); 

      
    </script>
</head>
<body style="margin: 2px 2px 2px 2px;">
<div id='main' style="margin:0px 0px 0px 0px;">


</div>
</body>
</html>