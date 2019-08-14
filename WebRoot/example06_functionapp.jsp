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
<body id="main" style="margin: 2px 2px 2px 2px;">
<script>
	$(function(){
		//定义easyui-panel容器控件
		myForm('myForm1','main','学生信息编辑',0,0,490,690,'close;collapse;min;max');
		myFieldset('myFieldset1','myForm1','基本信息',010,10,230,295);
		myFieldset('myFieldset2','myForm1','通信信息',010,320,230,355);
		myFieldset('myFieldset3','myForm1','个人特长',250,10,200,295);
		myFieldset('myFieldset4','myForm1','上传照片',250,320,200,355);
		myTextField('stuid','myFieldset1','学号：',65,33*0+20,12,0,120,'D20101');
		myTextField('stuname','myFieldset1','姓名：',65,33*1+20,12,0,160,'贾宝玉');
		myTextField('pycode','myFieldset1','汉语拼音：',65,33*2+20,12,0,160,'');
		myDateField('birthdate','myFieldset1','出生日期：',65,33*3+20,12,0,120,'1997-2-17');
		myComboField('gender','myFieldset1','性别：',65,33*4+20,12,0,120,'男;女','');
		myNumericField('weight','myFieldset1','体重：',65,33*5+20,12,0,120,8,2,'60.25','10','100');
		myLabel('label1', 'myFieldset1','KG',33*5+18+7,220);

		myTextField('address','myFieldset2','家庭地址：',65,33*0+20,12,0,255,'浙江省杭州市西湖区');
		myTextField('mobile','myFieldset2','手机号码：',65,33*1+20,12,0,180,'');
		myTextField('homephone','myFieldset2','家庭电话：',65,33*2+20,12,0,180,'');
		myTextField('email','myFieldset2','Email：',65,33*3+20,12,0,180,'zxywolf@163.com');
		myTextField('qq','myFieldset2','QQ号：',65,33*4+20,12,0,180,'857199052');
		myTextField('weixin','myFieldset2','微信号：',65,33*5+20,12,0,180,'zxywolf888');
		myCheckBoxField('hobby1','myFieldset3','个人特长：',65,33*0+20,12,'围棋',1);
		myCheckBoxField('hobby2','myFieldset3','',0,33*0+20,135,'国际象棋',true);
		myCheckBoxField('hobby3','myFieldset3','',0,33*0+20,215,'足球',0);
		myCheckBoxField('hobby4','myFieldset3','',0,33*1+20,77,'长跑',1);
		myCheckBoxField('hobby5','myFieldset3','',0,33*1+20,135,'数学',1);
		myCheckBoxField('hobby6','myFieldset3','',0,33*1+20,215,'信息技术',0);
		myMemoField('notes','myFieldset3','个人简介：',0,33*2+5,10,100,273,'');
		myFileField('photo','myFieldset4',26,6,0,240,'','');
		//定义事件		
		$("#photobutton").bind('click',function(e){
			var targetname=$("#stuid").textbox('getValue');
			var result=myFileupLoad('photo','mybase/students/',targetname);
		});
		//添加在函数中没有涉及的属性和事件
		$("#stuname").textbox({
			prompt:"姓名有效长度为20个字符",
			required: true,
			onChange: function(newv,oldv){
				alert("姓名已发生变化，请重新输入拼音");
			}
		});
    });  //endofjquery
    
	function myFileEvents(id,e){
    	
    }
</script>
</body>
</html>
