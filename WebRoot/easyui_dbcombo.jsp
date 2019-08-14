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
		$("input:text").focus(function() { $(this).select(); } );		
		var jqsql={};  //sql语句中不能有双引号
		jqsql.title="select Pycode as id,description as title from dictionary where Type='学历'";
		jqsql.party="select Pycode as id,description as party from dictionary where Type='党派'";
		jqsql.degree="select Pycode as id,description as degree from dictionary where Type='学历'";
		jqsql.province="select AreaID as provinceid,AreaName as province from Areas where level=1";
		jqsql.city="select AreaID as cityid,AreaName as city, parentnodeid as provinceid from Areas ";
	
		myTabForm('myTab','main','教师信息编辑','个人概况;研究方向;个人简历;上传照片',0,0,670,472,'close;drag');
		myFieldset('myFieldset1','myTab1','基本信息',8,6,350,440);
		myFieldset('myFieldset2','myTab1','通信信息',375,6,220,440);
		myTextField('teacherid','myFieldset1','教师编码：',70,33*0+20,16,0,120,'D20101');
		myTextField('name','myFieldset1','姓名：',70,33*1+20,16,0,260,'祝锡永');
		myTextField('pycode','myFieldset1','拼音：',70,33*2+20,16,0,160,'zhu');
		myComboField('gender','myFieldset1','性别：',70,33*3+20,16,0,135,'男;女;take;task;book;buring','');
		myDateField('birthdate','myFieldset1','出生日期：',70,33*4+20,16,0,135,'5/12/1997');
		myDBComboField('party','myFieldset1','党派：',70,33*5+20,16,0,135,jqsql.party,'party','');
		myDBComboField('title','myFieldset1','职称：',70,33*6+20,16,0,135,jqsql.title,'title','');
		myDBComboField('provinceid','myFieldset1','出生地：',70,33*7+20,16,0,135,jqsql.province,'province','');
		myDBComboField('cityid','myFieldset1','省',20,33*7+20,235,0,150,jqsql.city,'city','provinceid');
		myLabelField('cityx','myFieldset1','市',33*7+20+4,418,0,0);
		myDBComboField('degree','myFieldset1','学历：',70,33*8+20,16,0,135,jqsql.degree,'degree','');
		myTextField('school','myFieldset1','毕业学校：',70,33*9+20,16,0,320,'');
		
		myTextField('address','myFieldset2','家庭地址：',70,33*0+20,12,0,260,'浙江省杭州市西湖区');
		myTextField('mobile','myFieldset2','手机号码：',70,33*1+20,12,0,180,'');
		myTextField('homephone','myFieldset2','家庭电话：',70,33*2+20,12,0,180,'');
		myTextField('email','myFieldset2','Email：',70,33*3+20,12,0,180,'zxywolf@163.com');
		myTextField('qq','myFieldset2','QQ号：',70,33*4+20,12,0,180,'857199052');
		myTextField('weixin','myFieldset2','微信号：',70,33*5+20,12,0,180,'zxywolf888');
		myCheckBoxField('research','myTab2','研究方向：',70,33*0+20,12,24,3,'企业管理;区域经济学;管理信息系统;信息系统开发技术;电子商务');
		myCheckBoxField('subject','myTab2','所属学科：',70,33*2+20,12,0,0,'管理科学与工程');
		myTextareaField('notes','myTab3','',0,12,6,560,442,'个人简历');
		//myEditorField('notes','myTab3','',10,10,6,200,516,'个人简介');
		myFileUpLoadField('filepath','myTab4','',0,4,8,0,40);
		mySetComboxByIndex('provinceid',0);
	}); 
    
    
	function myCheckBoxChange(id,items){
		//讲选中值保存到id_hiddenfield控件中
		var str='';
		var tmp=items.split(';');
		for (var i=1;i<=tmp.length;i++){
			if (i==1 &&tmp.length==1) var itemid=id;
			else var itemid=id+i;
			if ($('#'+itemid).is(':checked')) str+=';'+tmp[i-1];
		}
		$('#'+id+'_values').val(str.substr(1));
		console.log($('#research_values').val());
	}
       
    </script>
</head>
<body style="margin: 2px 2px 2px 2px;">
<div id='main' style="margin:0px 0px 0px 0px;">

</div>    
</body>
</html>