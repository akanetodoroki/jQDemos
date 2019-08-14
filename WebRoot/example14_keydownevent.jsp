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
	$(document).ready(function(){
		//example14_keydownevent.jsp
		myForm('myForm1','main','学生信息编辑',0,0,490,585,'');
		myFieldset('myFieldset1','myForm1','基本信息',10,  10,230,255);
		myFieldset('myFieldset2','myForm1','通信信息',10, 278,230,290);
		myFieldset('myFieldset3','myForm1','个人简介',250, 10,200,557);
		myTextField('stuid','myFieldset1','学号：',70,33*0+20,12,0,120,'D20101');
		myTextField('stuname','myFieldset1','姓名：',70,33*1+20,12,0,155,'贾宝玉');
		myTextField('pycode','myFieldset1','汉语拼音：',70,33*2+20,12,0,155,'jiabaoyu');
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
		myCheckBoxField('hobby1','myFieldset3','个人特长：',65,33*0+20,12,'围棋',1);
		myCheckBoxField('hobby2','myFieldset3','',0,33*0+20,145,'国际象棋',true);
		myCheckBoxField('hobby3','myFieldset3','',0,33*0+20,235,'足球',0);
		myCheckBoxField('hobby4','myFieldset3','',0,33*1+20,77,'长跑',1);
		myCheckBoxField('hobby5','myFieldset3','',0,33*1+20,145,'数学',1);
		myCheckBoxField('hobby6','myFieldset3','',0,33*1+20,235,'信息技术',0);
		myTextareaField('notes','myFieldset3','个人简介：',0,33*2+5,10,95,520,'');
		//myHiddenFields("ff1;ff2");
		//触发右键事件
		/*
		$('#myForm1').bind('contextmenu',function(e){
			e.preventDefault();
			$('#myMenu1').menu('show', {
				left: e.pageX,
				top: e.pageY
			});
		});
		*/
		//$('input, select, textarea').each(function(index){
		$('input, textarea').each(function(index){
			var input = $(this);
			var id=input.attr('id');
			var value=undefined;
			var type=input.attr('type');
			var hidden=input.attr('hidden');
			if (hidden!='hidden' && id!=undefined && type!='checkbox'){
				if (type=='textarea'){
					$('#'+id).on('keydown', 'input', function(e){
						fnKeyDownEvent(e,id);
					});				
				}else{
					$('#'+id).textbox('textbox').bind('keydown',function(e){
						fnKeyDownEvent(e,id);
					});
				} 
				console.log(id+'---'+type+'----'+hidden);
			}
		});
		fnSelectOnFocus();
 		$("#stuid").next("span").find("input").focus();
 		$("#stuid").select();  //IE不支持
	//---------------------end of jquery------------------------
	});
	
	function fnKeyDownEvent(e,id){
		var key=e.which;
		//e.preventDefault();
		var xcmp=[];
		var xtype=[];
		var i=0;
		if (key==13 || key==40 || key==38){  //38--up  40--down
			var xno=-1;
			//$('input, select, textarea').each(function(index){  
			$('input, textarea').each(function(index){  
				var input = $(this);
				field=input.attr('id');
				type=input.attr('type');
				hidden=input.attr('hidden');
				if (field!=undefined && hidden!='hidden' && type!='checkbox'){
					if (id==field) xno=i;
					xcmp[i]=field;
					xtype[i]=type;
					//console.log(field+'---'+field+'-----'+type);
					i++;
				}
			});
			if (xno<xcmp.length && xno>=0){
				var n=0;
				if (key==13 || key==40 ){  //向下
					if (xno<=i) n=xno+1;
					else n=i;
				}else if (key==38 ){   //向上
					if (xno>0) n=xno-1;
					else n=0;
				} 
				var xnewcmp=xcmp[n];
				var xtype=xtype[n];
				if (xtype=='textarea') $("#"+xnewcmp).focus();
				else $("#"+xnewcmp).next("span").find("input").focus();
			}
		}
	}
	//光标聚焦时选中控件中的文本内容
	function fnSelectOnFocus(){
	$('input').on('focus', function() {
		var $this = $(this)
		.one('mouseup.mouseupSelect', function() {
			$this.select();
			return false;
		})
		.one('mousedown', function() {
			// compensate for untriggered 'mouseup' caused by focus via tab
			$this.off('mouseup.mouseupSelect');
		})
		.select();
	});
}
	
</script>
</body>
</html>