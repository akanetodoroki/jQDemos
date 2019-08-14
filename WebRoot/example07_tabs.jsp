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
	<div id="myTab" class="easyui-tabs" style="overflow: auto; margin: 0px 0px -19px 0px; width:380px; height:285px;">
		<div id="myTab1" title="基本信息" style="position:relative; overflow:auto;"></div>
		<div id="myTab2" title="通信信息" style="position:relative; overflow:auto;"></div>
		<div id="myTab3" title="个人简历" style="position:relative; overflow:auto;"></div>
		<div id="myTab4" title="上传照片" style="position:relative; overflow:auto;"></div>
	</div>
</div>
<script>
	$(function(){
		var str='<div id="myTab" class="easyui-tabs" style="overflow: auto; margin: 0px 0px -19px 0px; padding 0px 0px 0px 0px;">';
		str+='<div id="myTab1" title="基本信息" style="position:relative; overflow:auto;"></div>';
		str+='<div id="myTab2" title="通信信息" style="position:relative; overflow:auto;"></div>';
		str+='<div id="myTab3" title="个人简历" style="position:relative; overflow:auto;"></div>';
		str+='<div id="myTab4" title="上传照片" style="position:relative; overflow:auto;"></div>';
		str+='</div>';
		//myTabs('myTab','main','基本信息;通信信息;个人简历;上传照片',0,0,285,385,'');
		//在tab中添加其他控件
		myFieldset('myFieldset1','myTab1','基本信息',10,10,230,355);
		myFieldset('myFieldset2','myTab2','通信信息',10,10,230,355);
		myFieldset('myFieldset3','myTab3','个人特长',10,10,230,355);
		myFieldset('myFieldset4','myTab4','上传照片',10,10,230,355);
		myTextField('stuid','myFieldset1','学号：',70,33*0+20,12,0,120,'D20101');
		myTextField('stuname','myFieldset1','姓名：',70,33*1+20,12,0,160,'贾宝玉');
		myTextField('pycode','myFieldset1','汉语拼音：',70,33*2+20,12,0,160,'jiabaoyu');
		myDateField('birthdate','myFieldset1','出生日期：',70,33*3+20,12,0,120,'1927-2-17');
		myComboField('gender','myFieldset1','性别：',70,33*4+20,12,0,120,'男;女','');
		myNumericField('weight','myFieldset1','体重：',70,33*5+20,12,0,120,8,2,'60.25','10','100');
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
		myMemoField('notes','myFieldset3','个人简介：',0,33*2+5,10,130,330,'');
		myFileField('photo','myFieldset4',26,6,0,240,'','');
		myImageField('picture','myFieldset4','',0,85,4,135,340,'');
		var tabcount=$("#myTab").tabs("tabs").length;
		for (var i=1; i<tabcount; i++){
			$("#myTab").tabs('select',i);
		}
		$("#myTab").tabs('select',0);
		var currTab = $("#myTab").tabs('getTab', 0);
		$("#myTab").tabs('update', { tab: currTab, options:{} });
	    //点击上传控件
		$("#photobutton").bind('click',function(e){
			var targetname=$("#stuid").textbox('getValue');
			var result=myFileupLoad('photo','mybase/students/',targetname);
		});
    });
	function myFileEvents(id,e){
		var result={};
		result.error=$("#"+id).attr('xerror');
		result.targetfile=$("#"+id).attr('xtargetfile');  
		result.targetpath=$("#"+id).attr('xtargetpath');
		if (result.error==''){
			var src=result.targetpath+result.targetfile+'?timestemp='+new Date().getTime();
			$("#picture").attr('src',src);
			myResizeImage('photopath',src,240,200);
		}	
    }
</script>
</body>
</html>

