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
<div id='main' class="easyui-layout" fit="true" style="margin:0px 0px 0px 0px;">

</div>    
<script>
	$(document).ready(function() {
		var jqsql={};  //sql语句中不能有双引号
		jqsql.area="select rtrim(areaid)+' '+rtrim(areaname) as 'text',* from Areas ";
		myForm('myForm1','main','地区分类',0,0,0,0,'drag');
		$("#myForm1").panel({
			tools: [{
				iconCls:'refreshIcon',
				handler:function(){ fnloadData();}
		    }]
		});
		//定义树控件
		//myDBTree( 'myTree1', 'myForm1', '地区分类11',0,0,0,0,jqsql.area,'areaid',' ',' full');
		var str='<div id="myTree1" class="easyui-tree" style="fit:auto; border: true; padding:5px;"></div>';
		$("#myForm1").append($(str));
		$("#myTree1").tree({
			checkbox: false,
			lines:true
		});
		$.ajax({
			url: "system/easyui_getAllTreeNodes.jsp",
			data: { database: sysdatabasestring, selectsql: jqsql.area, keyfield:'areaid', sortfield:'' }, 
			async: false, method: 'post',    
			success: function(data) {
				var source=eval(data);
				$('#myTree1').tree({ data: source });
			}  
		});
		
		$('#myTree1').tree({  //双击展开或收缩结点
			onDblClick: function(node){
				if (node.state=='closed') $(this).tree('expand', node.target);
				else $(this).tree('collapse', node.target);
			}
		});



		$("#myTree1").tree('collapseAll');
		var roots=$("#myTree1").tree("getRoots");
		$("#myTree1").tree('expand', roots[2].target);
		$("#myTree1").tree('select', roots[2].target);
		
		function fnloadData(){
			$.ajax({
				url: "system/easyui_getAllTreeNodes.jsp",
				data: { database: sysdatabasestring, selectsql: jqsql.area, keyfield:'areaid', sortfield:'' }, 
				async: false, method: 'post',    
				success: function(data) {
					var source=eval(data);
					$('#myTree1').tree({ data: source });
					$("#myTree1").tree('collapseAll');
					//展开第一个节点下的子节点
				},     
				error: function(err) {     
					console.log(err);     
				}     
			});
		}
	//---------------------------------------------------//
	}); //endofjquery
</script>
</body>
</html>