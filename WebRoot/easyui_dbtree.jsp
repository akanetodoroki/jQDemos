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
		jqsql.area="select rtrim(areaid)+' '+rtrim(areaname) as 'text',areaid,areaname,parentnodeid,isparentflag,level,ancester from Areas ";
		jqsql.account="select accountid+' '+accountname as 'text',* from Accounts";
		jqsql.tree="select rtrim(id)+' '+rtrim(name) as 'text',* from tree ";
		myTabForm('myTab','main','分类管理','地区分类;科目分类;资源分类',0,0,0,00,'collapse;drag');
		myDBTree( 'myTree1','myTab1','地区分类',0,0,0,0,jqsql.area,'areaid','','');
		myDBTree('myTree2','myTab2','科目分类',0,0,0,00,jqsql.account,'accountid','','full;edit');
		myDBTree('myTree3','myTab3','资源分类',0,0,500,360,jqsql.tree,'id','','checkbox;full');
		
		//$("#myTree2").tree('expandAll');
		$("#myTree1").tree('collapseAll');
		$("#myTree2").tree('collapseAll');
		$("#myTree3").tree('collapseAll');
		//$("#myTree1").tree('expandAll');
		var id='myTree1';
		
//---------------------
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
</body>
</html>