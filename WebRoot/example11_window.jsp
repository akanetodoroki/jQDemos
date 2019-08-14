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
<body style="margin: 2px 2px 2px 2px;">
<div id='main' style="margin:0px 0px 0px 0px;">
	<div id='layout' class="easyui-layout" style="height:500px">
		<div id='toolbar' class='easyui-panel' data-options="region:'north'" style="overflow:hidden; background-color: #E0ECFF; height:30px; padding: 1px 1px 1px 10px;">
	        <a href="#" class="btn-separator"></a>
	        <a href="#" id="btnadd" xtype="button" class="easyui-linkbutton" data-options="iconCls:'addIcon', plain:true, onClick:fn_add" style="">新增</a>
	        <a href="#" id="btnedit" xtype="button" class="easyui-linkbutton" data-options="iconCls:'editIcon', plain:true, onClick:fn_edit" style="">修改</a>
	        <a href="#" class="btn-separator"></a>
	        <a href="#" id="btndelete" xtype="button" class="easyui-linkbutton" data-options="iconCls:'deleteIcon',plain:true" style="">删除</a>
	        <a href="#" class="btn-separator"></a>
	        <a href="#" id="btnsave" xtype="button" class="easyui-linkbutton" data-options="iconCls:'saveIcon',plain:true" style="">保存</a>
	        <a href="#" class="btn-separator"></a>
	        <a href="#" id="btnrefresh" xtype="button" class="easyui-linkbutton" data-options="iconCls:'refreshIcon',plain:true" style="">刷新</a>
		</div>
		<div id='bottom' data-options="region:'center'" style="padding: 2px 0px 0px 2px; "></div>
	</div>
	
</div>    
<script>
	$(document).ready(function() {
		$("#layout").layout({height:325, width:685});
		myFieldset('myFieldset1','myWin1','基本信息',10,12,225,300);
		myFieldset('myFieldset2','myWin1','通信信息',245,12,225,300);
		myTextField('stuid','myFieldset1','学号：',70,33*0+20,12,0,120,'D20101');
		myTextField('stuname','myFieldset1','姓名：',70,33*1+20,12,0,160,'诸葛亮');
		myTextField('pycode','myFieldset1','汉语拼音：',70,33*2+20,12,0,160,'zhu');
		myDateField('birthdate','myFieldset1','出生日期：',70,33*3+20,12,0,120,'1997-2-17');
		myComboField('gender','myFieldset1','性别：',70,33*4+20,12,0,120,'男;女','');
		myNumericField('weight','myFieldset1','体重：',70,33*5+20,12,0,120,8,2,'60.25','10','100');
		myLabelField('label1', 'myFieldset1','KG',33*5+18+7,220,0,0);
		myTextField('address','myFieldset2','家庭地址：',70,33*0+20,12,0,200,'浙江省杭州市西湖区');
		myTextField('mobile','myFieldset2','手机号码：',70,33*1+20,12,0,200,'');
		myTextField('homephone','myFieldset2','家庭电话：',70,33*2+20,12,0,200,'');
		myTextField('email','myFieldset2','Email：',70,33*3+20,12,0,200,'zxywolf@163.com');
		myTextField('qq','myFieldset2','QQ号：',70,33*4+20,12,0,200,'857199052');
		myTextField('weixin','myFieldset2','微信号：',70,33*5+20,12,0,200,'zxywolf888');
		//设置窗口属性
		$("#myWin1").window({
			closable:true, 
			collapsible:false, 
			resizable:false,
			draggable:false, 
			modal:true, 
			maximizable:false
		});
		//$("#myWin1").window({top:10,left:100});
		//添加按钮
		$("#myWin1").append("<input type='button' value='确定' id='btnok' />");
		$("#myWin1").append("<input type='button' value='关闭' id='btnclose' />");
		$("#btnok").css({position:'absolute', top:485, left:170, width:65});
		$("#btnclose").css({position:'absolute', top:485, left:236, width:65});
		$("#btnclose").on('click', function () {
			$("#myWin1").window('close');		
		});
		//在window控件的标题中添加自己的按钮
		$("#myWin1").window({
			tools:[{
				iconCls:'addIcon',
				handler:function(){
					alert('add');
				}
		
			}]
		});      
		//聚焦控件
		$("input:text").focus(function() { $(this).select(); } );
 		$("#stuid").next("span").find("input").focus();		
	//---------------------end of jquery------------------------
	});
	
	function fn_add(){
		$("#myWin1").window("open");		
	}

	function fn_edit(){
		$("#myWin1").window("open");
	}

	function fn_refresh(){
		alert('refresh');
	}
	    
</script>
</body>
</html>