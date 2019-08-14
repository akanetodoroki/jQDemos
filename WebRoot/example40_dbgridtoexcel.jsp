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
	pmyGrid1.staticsql="select c.productid,c.productname,c.quantityperunit,c.unit,c.unitprice,"+
	"\n SUM(case when datediff(month,b.orderdate,'2012-12-1')=0 then a.quantity else 0 end ) as qty1,"+
	"\n SUM(case when datediff(month,b.orderdate,'2012-12-1')=0 then a.amount else 0 end) as amount1,"+
	"\n SUM(case when datediff(year,b.orderdate,'2012-12-1')=0 then a.quantity else 0 end ) as qty2,"+
	"\n SUM(case when datediff(year,b.orderdate,'2012-12-1')=0 then a.amount else 0 end) as amount2,"+
	"\n 0 as 'sortflag' from OrderItems a"+
	"\n join Orders b on a.OrderID=b.OrderID"+
	"\n join products c on a.productid=c.productid"+
	"\n group by c.productid,c.productname,c.quantityperunit,c.unit,c.unitprice"
	//console.log(pmyGrid1.staticsql);
	pmyGrid1.activesql=pmyGrid1.staticsql;
	pmyGrid1.summeryfields="productname='<center>* 全部商品合计 *</center>',qty1=sum(qty1),amount1=sum(amount1),"+
	"qty2=sum(qty2),amount2=sum(amount2)";
	pmyGrid1.keyfield='productid';
	pmyGrid1.pagesize=10;
	pmyGrid1.rowindex=-1;
	var xcolumns=[
		[  //第一层开始
		 { title: '商品名称', field:'productname', width: 200, halign:'center', align: 'left', rowspan:2 },
		 { title: '规格型号', field:'quantityperunit', width: 130, halign:'center', align: 'left', rowspan:2 },
 		 { title: '计量单位', field:'unit', width: 80, halign:'center', align: 'center', rowspan:2},
		 { title: '单价', field: 'unitprice', width: 70, halign:'center', align: 'right', rowspan:2, decimal:2, formatter: fnSetNumberFormat},
		 { title: '本月销售情况',"colspan":2},
		 { title: '本年销售情况',"colspan":2}
		],   //第一层结束 
		[  //第二层开始 
		 { title: '销售量', field:'qty1', width: 70, halign:'center', align: 'right', decimal:0, formatter: fnSetNumberFormat  },
		 { title: '销售额', field:'amount1', width: 80, halign:'center', align: 'right', decimal:2, formatter: fnSetNumberFormat },
		 { title: '销售量', field:'qty2', width: 70, halign:'center', align: 'right', decimal:0, formatter: fnSetNumberFormat },
		 { title: '销售额', field:'amount2', width: 80, halign:'center', align: 'right', decimal:2, formatter: fnSetNumberFormat }
		]
	];
	var xfixedcolumns=[[
		{ title: 'id', field: 'id', width: 20, checkbox: true, sortable: true, align: 'center'},
		{ title: '商品编码', field:'productid', width: 70, halign:'center', align: 'left' }
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
	}];	
	var str='<div id="myGrid1" class="easyui-datagrid"></div>';
	$("#main").append($(str));
	$("#myGrid1").datagrid({
		title: '&nbsp;商品销售情况月报表（2012年12月份）',
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
		pmyReport1.sql=pmyGrid1.staticsql+" union all ";
		pmyReport1.sql+="\n select '','* 全部商品合计 *','','',0,sum(qty1),sum(amount1),sum(qty2),sum(amount2),1 from (";
		pmyReport1.sql+="\n "+pmyGrid1.staticsql+") as p";
		pmyReport1.sql+="\n order by sortflag,productid";
		pmyReport1.targetfilename="商品销售情况月报表.xls";
		pmyReport1.template="TProductSales.xls";
		/*
		pmyReport1.headerrange='<1-4>'; //标题为第1行到第4行，每页重复
		pmyReport1.headercells="<1,1>商品销售情况月报表;<2,1>2012年12月份";
		//页脚最多只能是左中右三个值
		pmyReport1.footercells="<l>制单人：诸葛亮;<c>第pageno页/共pagecount页";
		pmyReport1.fields="productid;productname;quantityperunit;unit;unitprice;qty1;amount1;qty2;amount2";
		var r=myExportExcelReport(sysdatabasestring,pmyReport1);
		*/
		//后台程序写死的方法，只适用于这个报表模板
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
//---------------------endofjquery----------------
});

function myGridEvents(id,e){
	
}
</script>
</body>
</html>