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
		var areasource=[{text:"全部地区", id:"*",	children:[
			{text:"北京市", id:"110000"},
			{text:"天津市", id:"120000"},
			{text:"上海市", id:"310000"},
			{text:"江苏省", id:"320000", 	children:[
				{text:"南京市", id:"320100"},
				{text:"无锡市", id:"320200"},
				{text:"徐州市", id:"320300"},
				{text:"常州市", id:"320400"},
				{text:"苏州市", id:"320500"},
				{text:"南通市", id:"320600"}				
			]},
			{text:"浙江省",id:"330000", children:[
				{text:"杭州市", id:"330100"},
				{text:"宁波市", id:"330200"},
				{text:"温州市", id:"330300"},
				{text:"嘉兴市", id:"330400"},
				{text:"湖州市", id:"330500"},
				{text:"绍兴市", id:"330600"}
			]},
			{text:"安徽省", id:"340000"},
			{text:"福建省", id:"350000"},
			{text:"江西省", id:"360000"},
			{text:"山东省", id:"370000"},
			{text:"河南省", id:"410000"}
		]}];
		myForm('myForm1','main','地区信息',0,0,450,250,'');
		myWindow('myWin1','编辑节点',0,0,170,355,'save;cancel','close;drag;modal');
		myTextField('areaid','myWin1','地区编码：',70,33*0+14,18,0,232,'','');
		myTextField('areaname','myWin1','地区名称：',70,33*1+14,18,0,232,'','');
		var str='<div id="myTree1" class="easyui-tree" style="width:215px; height:380px; padding:5px;"></div>';
		$("#myForm1").append($(str));
		//定义myTree1右键菜单
		myMenu('myMenu1','新增结点/mnaddnode/addIcon;新增子结点/mnaddsubnode/addIcon;修改结点/mneditnode/editIcon;-;删除结点/mndeletenode/deleteIcon','');
		$("#myTree1").tree({
			checkbox: false,
			lines:true,
			xtype:'tree',
			data: areasource,
			onContextMenu: function (e, title) {
				e.preventDefault();
				$("#myMenu1").menu('show', {
					left: e.pageX,
					top: e.pageY
				});
			}
		});

		//提取根节点
		var root = $("#myTree1").tree("getRoot");
		if (root==null) var pnode=null;
		else var pnode=root.target;
		//根据id值和find方法查找节点，找到节点后增加其子节点
		var node1=$("#myTree1").tree('find','330100');
		if (node1!=null){
			$("#myTree1").tree('append',{
				parent: node1.target,  
				data:[
					{text:"西湖区",id:"330101"},
					{text:"上城区",id:"330202"},
					{text:"下城区",id:"330303"},
					{text:"江干区",id:"330404"}
				]
			});		
			$("#myTree1").tree('select',node1.target);
		}
		//定义菜单点击事件
		$("#mnaddnode").bind('click', function(e){ //新增兄弟节点;
			$("#areaid").textbox('setValue','');
			$("#areaname").textbox('setValue','');
			$("#myWin1").window({title: '新增节点'});
			$("#myWin1").window('open');
		});
		$("#mnaddsubnode").bind('click', function(e){ //新增子节点;
			//获取树中当前节点
			$("#areaid").textbox('setValue','');
			$("#areaname").textbox('setValue','');
			$("#myWin1").window({title: '新增子节点'});
			$("#myWin1").window('open');
		});
		
		$("#mneditnode").bind('click', function(e){ //修改节点;
			//获取树中当前节点
			var node=$("#myTree1").tree('getSelected');
			if (node!=null){
				$("#areaid").textbox('setValue',node.id);
				$("#areaname").textbox('setValue',node.text);
				$("#myWin1").window({title: '修改节点'});
				$("#myWin1").window('open');
			}
		});

		$("#myWin1SaveBtn").bind('click', function(e){ //点击窗体中的保存按钮
			var options=$("#myWin1").window('options');
			var action=options.title;
			var xid=$("#areaid").textbox('getValue');
			var xname=$("#areaname").textbox('getValue');
			var node=$("#myTree1").tree('getSelected');
			if (action=='修改节点'){
				node.id=xid;
				node.text=xname;
				$("#myTree1").tree('update',node);  //刷新树结点
			}else if (action=='新增节点'){
				var node=$("#myTree1").tree('getSelected'); //获取树中当前节点
				var pnode=$("#myTree1").tree('getParent', node.target); //求节点的父节点
				$("#myTree1").tree('append',{
					parent:pnode.target,
					data:{ id:xid, text:xname }
				});	
			}else if (action=='新增子节点'){
				var pnode=$("#myTree1").tree('getSelected'); //获取树中当前节点
				$("#myTree1").tree('append',{
					parent:pnode.target,
					data:{ id:xid, text:xname }
				});	
			}
			$("#myWin1").window('close');
		});
		
		$("#mndeletenode").bind('click', function(e){ //删除节点;
			//获取树中当前节点
			var node=$("#myTree1").tree('getSelected');
			if (node!=null){
				var pnode=$("#myTree1").tree('getParent');
				var cnodes=$("#myTree1").tree('getChildren');
				alert(cnodes.length);  //cnodes[n]
				$("#myTree1").tree('remove',node.target);
			}
		});

		$("#myWin1CancelBtn").bind('click', function(e){
			$("#myWin1").window('close');
		});
	});	  //end of juery
</script>
</body>
</html>