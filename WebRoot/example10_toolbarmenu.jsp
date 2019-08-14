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
<body id="xbody" style="margin: 2px 2px 2px 2px;">
<form id='main' style="margin:0px 0px 0px 0px;">
<div id='layout' class="easyui-layout" style="height:500px">
	<div id='toolbar' class='easyui-panel' data-options="region:'north'" style="overflow:hidden; background-color: #E0ECFF; height:30px; padding: 1px 1px 1px 10px;">
		<a href="#" class="btn-separator"></a>
		<a href="#" id="btnadd" xtype="button" class="easyui-linkbutton" data-options="iconCls:'addIcon', plain:true, onClick:fn_add" style="">新增</a>
		<a href="#" id="btnedit" xtype="button" class="easyui-linkbutton" data-options="iconCls:'editIcon', plain:true" style="">修改</a>
		<a href="#" class="btn-separator"></a>
		<a href="#" id="btndelete" xtype="button" class="easyui-linkbutton" data-options="iconCls:'deleteIcon',plain:true, onClick:fn_delete" style="">删除</a>
		<a href="#" class="btn-separator"></a>
		<a href="#" id="btnsave" xtype="button" class="easyui-linkbutton" data-options="iconCls:'saveIcon',plain:true, onClick:fn_save" style="">保存</a>
		<a href="#" class="btn-separator"></a>
		<a href="#" id="btnrefresh" xtype="button" class="easyui-linkbutton" data-options="iconCls:'refreshIcon',plain:true" style="">刷新</a>
		<a href="#" class="btn-separator"></a>
		<a href="#" xtype="button" class="easyui-menubutton" data-options="menu:'#btnhelp_menuitem', iconCls:'helpIcon'">帮助</a>
	</div>
	<div id='bottom' data-options="region:'center'" style="padding: 2px 0px 0px 2px; "></div>
</div>
<div id="btnhelp_menuitem" style="width:150px;">
	<div id="btnbookonline" data-options="iconCls:'pdfIcon'">操作说明</div>
	<div id="btndemo" data-options="iconCls:'wordIcon'">实例演示</div>
</div>
<div id="myMenu1" class="easyui-menu" data-options="onClick: fn_myMenu1Click" style="width: auto;"></div>
</form>    
<script>
	$(document).ready(function() {
		$("#layout").layout({height:321, width:676});
		myForm('myForm1','bottom','学生信息编辑',0,0,285,670,'');
		myFieldset('myFieldset1','myForm1','基本信息',10,14,230,270);
		myFieldset('myFieldset2','myForm1','通信信息',10,300,230,355);
		myTextField('stuid','myFieldset1','学号：',70,33*0+20,12,0,120,'D20101');
		myTextField('stuname','myFieldset1','姓名：',70,33*1+20,12,0,160,'贾宝玉');
		myTextField('pycode','myFieldset1','汉语拼音：',70,33*2+20,12,0,160,'jiabaoyu');
		myDateField('birthdate','myFieldset1','出生日期：',70,33*3+20,12,0,120,'1997-2-17');
		myComboField('gender','myFieldset1','性别：',70,33*4+20,12,0,120,'男;女','');
		myNumericField('weight','myFieldset1','体重：',70,33*5+20,12,0,120,8,2,'60.25','10','100');
		myLabelField('label1', 'myFieldset1','KG',33*5+18+7,220,0,0);
		myTextField('address','myFieldset2','家庭地址：',70,33*0+20,12,0,255,'浙江省杭州市西湖区');
		myTextField('mobile','myFieldset2','手机号码：',70,33*1+20,12,0,180,'');
		myTextField('homephone','myFieldset2','家庭电话：',70,33*2+20,12,0,180,'');
		myTextField('email','myFieldset2','Email：',70,33*3+20,12,0,180,'zxywolf@163.com');
		myTextField('qq','myFieldset2','QQ号：',70,33*4+20,12,0,180,'857199052');
		myTextField('weixin','myFieldset2','微信号：',70,33*5+20,12,0,180,'zxywolf888');
		//利用appendItem添加右键菜单的子菜单项
		$("#myMenu1").menu('appendItem',
			{text: '新增结点',id: 'mnadd', iconCls:'addIcon'}
		);
		$("#myMenu1").menu('appendItem',
			{text: '修改记录',id: 'mnedit', iconCls:'editIcon'}
		);
		$("#myMenu1").menu('appendItem',
			{text: '删除记录',id: 'mndelete', iconCls:'deleteIcon', onclick: function(){
				fn_delete();
			}
		});
		$("#myMenu1").menu('appendItem',
			{separator:true}
		);
		$("#myMenu1").menu('appendItem',
			{text: '保存记录',id: 'mnsave', iconCls:'saveIcon', onclick: function(){
				fn_save();
			}
		});
		$("#myMenu1").menu('appendItem',
			{separator:true}
		);
		$("#myMenu1").menu('appendItem',
			{text: '重置',id: 'mnreset', iconCls:'resetIcon'}
		);
		$("#myMenu1").menu('appendItem',
			{text: '刷新',id: 'mnrefresh', iconCls:'refreshIcon'}
		);
		//绑定按钮和菜单的click事件
		$("#btnrefresh,#mnrefresh").bind('click', function(e){ fn_refresh(e); });
		//触发右键事件
		$('#myForm1').bind('contextmenu',function(e){
			e.preventDefault();
			$('#myMenu1').menu('show', {
				left: e.pageX,
				top: e.pageY
			});
		});

 		$("#stuid").next("span").find("input").focus();		
	//---------------------end of jquery------------------------
	});
	
	function fn_add(){
		$.messager.show({
			title:'系统提示',
			msg:'系统已切换至新增记录模式。<br>表单已经清空。',
			showType:'show',
			width:200,
			timeout:0,
			style:{
				//right:'',
				top: 100
				//bottom:''
			}
		});
	}
	
	function fn_save(){
		$.messager.alert('系统提示','数据已经保存成功！','info');
		//icon： 显示图标的图片。可用的值是： error、question、info、warning
	}
	
	function fn_delete(){
		$.messager.confirm('系统提示','是否确定删除记录？',function(r){
		    if (r){
		        alert('确定删除');
		    }
		});
	}
	function fn_refresh(){
		alert('refresh');
	}
	    
	function fn_myMenu1Click(item){
		if (item.id=='mnreset'){
			$("#main")[0].reset(); 
			$.messager.show({
				title:'系统提示',
				width:200,
				msg:'表单数据已经被重置。',
				timeout:2000,
				showType:'slide'
			});  
		}
	}
</script>
</body>
</html>