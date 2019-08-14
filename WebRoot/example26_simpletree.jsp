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
		myForm('myForm1','main','地区信息',0,0,430,300,'');
		var str='<div id="myTree1" class="easyui-tree" style="width:280px; height:360px; padding:5px;"></div>';
		$("#myForm1").append($(str));
		$("#myTree1").tree({ checkbox: true, lines:true});
		//添加根节点
		$("#myTree1").tree('append',{
			parent: null,
			data:{text:"全部地区",id:"*"}
		});
		//提取根节点
		var root = $("#myTree1").tree("getRoot");
		if (root==null) var pnode=null;
		else var pnode=root.target;
		//增加根节点下面的一个子节点
		$("#myTree1").tree('append',{
			parent: pnode,
			data:{text:"北京市",id:"110000"}
		});
		//增加根节点下面的多个子节点
		$("#myTree1").tree('append',{
			parent: pnode,
			data:[
				{text:"天津市",id:"120000"},
				{text:"上海市",id:"310000"},
				{text:"江苏省",id:"320000"},
				{text:"浙江省",id:"330000"},
				{text:"安徽省",id:"340000"},
				{text:"福建省",id:"350000"},
				{text:"江西省",id:"360000"},
				{text:"山东省",id:"370000"},
				{text:"河南省",id:"410000"}
			]
		});
		//根据id值查找节点，
		var node1=$("#myTree1").tree('find','320000');
		if (node1!=null){
			$("#myTree1").tree('append',{
				parent: node1.target,
				data:[
					{text:"南京市",id:"320100"},
					{text:"无锡市",id:"320200"},
					{text:"徐州市",id:"320300"},
					{text:"常州市",id:"320400"},
					{text:"苏州市",id:"320500"},
					{text:"南通市",id:"320600"},
				]
			});
			//$("#myTree1").tree('collapse', node1.target);
		}
		//在子节点中根据id值查找某个节点，
		var node2=null;
		var children = $('#myTree1').tree('getChildren', root.target);
		for (var i=0;i<children.length;i++){
			if (children[i].id=='330000'){
				node2=children[i];
				break;
			}
		}
		if (node2!=null){
			$("#myTree1").tree('append',{
				parent: node2.target,
				data:[
					{text:"杭州市",id:"330100"},
					{text:"宁波市",id:"330200"},
					{text:"温州市",id:"330300"},
					{text:"嘉兴市",id:"330400"},
					{text:"湖州市",id:"330500"},
					{text:"绍兴市",id:"330600"},
				]
			});		
			$("#myTree1").tree('collapse', node1.target);  //收缩父节点，与expand相反
			$("#myTree1").tree('select',node2.target); 	//选中节点
		}
	});	
</script>
</body>
</html>