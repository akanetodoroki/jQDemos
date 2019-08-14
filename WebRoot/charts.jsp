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
    <script type="text/javascript" src="jqeasyui/fusioncharts/fusioncharts.js"></script>	
	<script type="text/javascript" src="system/easyui_functions.js"></script>
</head>
<body class="easyui-layout" data-options="fit:true" style="margin: 2px 2px 2px 2px;">
	<div id='toolbar' class='easyui-panel' data-options="region:'north'" style="overflow:hidden; background-color: #E0ECFF; height:33px; padding: 1px 1px 1px 10px;"></div>
	<div id='bottompanel' class='easyui-panel' data-options="region:'center', split:true" style="padding: 2px 2px 2px 2px;">
		<div class="easyui-layout" data-options="fit:true" style="margin: 0px 0;">
			<div id='treepanel' class='easyui-panel' data-options="region:'north', split:true, border:true" style="height:45%; padding: 1px 1px 1px 1px;"></div>
			<div id='main' class='easyui-panel' data-options="region:'center'" style="padding: 1px 1px 1px 1px;"></div>
		</div>	
	</div>
<script>
$(document).ready(function() {
	//定义树myTree1


	myDateField('datefrom','toolbar','设置区间：',70,4,16,0,100,'2012-01-01','');		
	myDateField('dateto','toolbar','～',16,4,198,0,100,'2012-12-31','');		
	myCheckBoxField('x3d','toolbar','',0,5,340,'是否3D显示？','true');
	myButton('cmdok','toolbar','开始',4,450,25,68,'searchIcon','','');
	//$("#myTab").tabs({border:false});
	//初始化时调用函数画图表
	fnGenChartXml();
	//编写“开始”按钮的点击事件
	
	
	
	//生成xml文件的函数
	function fnGenChartXml(swf,div){
		

		var sql="select sum(a.Amount) as amount,100*year(orderdate)+month(orderdate) as month from orderitems a join Orders b on a.OrderID=b.orderid";
		sql+="\n group by year(orderdate),month(orderdate)";
		sql+="\n order by year(orderdate),month(orderdate)";
		console.log(sql);
		var pmyChart1={};
		pmyChart1.data=myRunSelectSql(sysdatabasestring, sql);
		pmyChart1.colorset='';  //F6C11F';
		pmyChart1.chartno=1;	
		pmyChart1.type='single';  //单序列
		pmyChart1.title='';
		pmyChart1.xAxisName="月份";
		pmyChart1.yAxisName='销售额';
		pmyChart1.labelfield='month';
		pmyChart1.valuefield='amount';
		pmyChart1.height=300;
		pmyChart1.width=800;
		pmyChart1=myGetChartXML(pmyChart1);
		//console.log(pmyChart1.xml);
		if ($("#x3d").is(':checked')){
			myShowFusionChart(pmyChart1,'Line','main');	
		}else{
			myShowFusionChart(pmyChart1,'Line','main');	
		}
	}
	
	
	//---------------------//
});  //endofjquery
function  myTreeEvents(id,e){
	
}
</script>
</body>
</html>