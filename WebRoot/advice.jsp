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
	<script type="text/javascript" src="jqeasyui/datagrid-detailview.js"></script>
    <script type="text/javascript" src="jqeasyui/easyui-lang-zh_CN.js"></script>	
	<script type="text/javascript" src="system/easyui_functions.js"></script>
</head>
<body style="margin: 2px 2px 2px 2px;">
<div id='main' class="easyui-layout" data-options="fit:'true'" style="margin:0px 0px 0px 0px;">
 	
</div>    
<script>
$(document).ready(function() {
	var pmyGrid1={};
	pmyGrid1.id='myGrid1';
	pmyGrid1.parent='main';
	pmyGrid1.staticsql="select id,fromwho,content from advice";
	pmyGrid1.activesql=pmyGrid1.staticsql;
	pmyGrid1.summeryfields="";
	pmyGrid1.keyfield='id';
	pmyGrid1.pagesize=100;
	pmyGrid1.rowindex=-1;
	var xcolumns=[
		[  //第一层开始
		 { title: '发布者', field:'fromwho', width: 200, halign:'center', align: 'left', rowspan:2 },
		 { title: '内容', field:'content', width: 1300, halign:'center', align: 'left', rowspan:2 },
 		 
		 
	
		],   //第一层结束 
		[  //第二层开始 
		 
		]
	];
	var xfixedcolumns=[[
		{ title: 'id', field: 'id', width: 20, checkbox: true, sortable: true, align: 'center'},

	]];
	//定义grid及其工具栏
	var myToolbar1 = ['-',{
		text:'输出',
		iconCls:'excelIcon',
		handler: fn_toExcel
	},'-',{
		text:'刷新',
		iconCls:'refreshIcon',
		handler: fn_refresh
	},'-',{
		text:'增加',
		iconCls:'addIcon',
		handler: fn_refresh
	},'-',{
		text:'返回首页',
		iconCls:'returnIcon',
		handler: fn_return
	}];	
	var str='<div id="myGrid1" class="easyui-datagrid"></div>';
	$("#main").append($(str));
	$("#myGrid1").datagrid({
		title: '&nbsp员工建议表',
		iconCls: "panelIcon",
		width:'100%',
		height:'100%',
		nowrap: true,
		pagePosition: 'bottom',  //top,both
		autoRowHeight: false,
		rownumbers: true,
		toolbar: myToolbar1,
		pagination: true,
		pageSize: pmyGrid1.pagesize,
		pageNumber:1,
		striped: true,
		collapsible: false,
		singleSelect: true,
		idField: 'productid',
		frozenColumns: xfixedcolumns,
		columns: xcolumns,
		showFooter: true
	});
	//定义分页栏模式
	myGridPaging(pmyGrid1);
	var opts = $("#myGrid1").datagrid('options');
	myLoadGridData(pmyGrid1,1);
	//数值型数据格式对其
	function fnSetNumberFormat(value){
		if (value==undefined || value==0) value='';
		else value=(1.0*value).toFixed(this.decimal);
		return '<div align="right">' + value+'</div>';
	}
	//输出到excel
	function fn_toExcel(){
		//调用函数的实现方法，适用于头体尾三层的报表
		var pmyReport1={};
		pmyReport1.sql=pmyGrid1.staticsql;
		pmyReport1.sql+="\n order by id";
		pmyReport1.targetfilename="本地备忘录.xls";
		pmyReport1.template="TProductSales.xls";
		var filename="";
		$.ajax({
			url:"example40_toExcelFile.jsp",
			data:{ database:sysdatabasestring, 
				template:pmyReport1.template, 
				selectsql:pmyReport1.sql
			},									
			//method: 'POST',
			async:false, method: 'post',
	   		success:function(data){
	   			eval("var result="+data);
	    		filename=result[0].filename;
			}	
		});
		var xsourcefilename=filename;
		var url='system//easyui_fileDownLoad.jsp?source='+filename+'&target='+pmyReport1.targetfilename;
		window.location.href=url;		
	}

	function fn_refresh(){
		
	}
	function  fn_return(){
		document.location = "indexx.jsp";
	}
//---------------------endofjquery----------------
});

function myGridEvents(id,e){
	
}
</script>
</body>
</html>