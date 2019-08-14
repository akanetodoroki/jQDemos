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
		//example29_dbtree.jsp
		var jqsql={};  //sql语句中不能有双引号
		jqsql.area="select rtrim(areaid)+' '+rtrim(areaname) as 'text',areaid,areaname,parentnodeid,isparentflag,level,ancester from Areas ";
		myForm('myForm1','main','地区分类',0,0,0,0,'drag');
		$("#myForm1").panel({
			tools: [{
				iconCls:'refreshIcon',
				handler:function(){ fnloadData();}
		    }]
		});
		//定义树控件
		//myDBTree( 'myTree1', 'myForm1', '地区分类', 0, 0, 0, 0, jqsql.area, 'areaid', ' ' ,' full');		
		var str='<div id="myTree1" class="easyui-tree" style="fit:auto; border: false; padding:5px;"></div>';
		$("#myForm1").append($(str));
		$("#myTree1").tree({
			checkbox: false,
			lines:true,
		});
		$("#myTree1").attr('xsql', jqsql.area);
		//提取第一层节点
		var sqlx="select * from ("+jqsql.area+") as p where parentnodeid=''";  //第一层
		$.ajax({
			url: "system/easyui_getChildNodes.jsp",
			data: { database: sysdatabasestring, selectsql: sqlx, keyfield:'areaid', sortfield:''}, 
			async: false, method: 'post',    
			success: function(data) {
				//console.log(data);     
				var source=eval(data);
				$("#myTree1").tree({ data: source });  //加载json数据到树
			},     
			error: function(err) {     
				console.log(err);     
			}     
		});
		$("#myTree1").tree('collapseAll');
		//定义myTree1的展开事件
		$("#myTree1").tree({
			onBeforeExpand: function (node){  //点击展开事件
				var pid=node.id;
				var sql=$("#myTree1").attr('xsql');
				var child_node = $("#myTree1").tree('getChildren', node.target);
				if (child_node.length==1 && child_node[0].id=='_'+pid){ //生成子节点
					if (sql!='') sqlx="select * from ("+sql+") as p where parentnodeid='"+pid+"'";
					else sqlx='';
					$.ajax({
						url: "system/easyui_getChildNodes.jsp",
						data: { database: sysdatabasestring, selectsql: sqlx, keyfield:'areaid', sortfield:'' }, 
						async: false, method: 'post',    
						success: function(data) {
							var source=eval(data);
							$("#myTree1").tree('remove', child_node[0].target); //删除子节点
							$("#myTree1").tree('append', {  //增加数据作为子节点
								parent: node.target,
								data: source 
							});
						},     
						error: function(err) {     
							console.log(err);     
						}     
					});
				};
			}
		});
		//双击展开或收缩结点事件					
		$('#myTree1').tree({  
			onDblClick: function(node){
				if (node.state=='closed') $(this).tree('expand', node.target);
				else $(this).tree('collapse', node.target);
			}
		});
		$("#myTree1").tree('collapseAll');
		
	//---------------------------------------------------//
	}); //endofjquery
</script>
</body>
</html>