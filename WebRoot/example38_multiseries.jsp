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
	//定义grid
	var pmyTree1={};
	var pmyTree1={};
	pmyTree1.id='myTree1';
	pmyTree1.parent='treepanel';
	pmyTree1.keyfield='productid';
	pmyTree1.sql="select cast(productid as varchar(16))+' '+productname as text,* from products";
	//console.log(pmyTree1.sql);
	pmyTree1.title='商品分类';
	pmyTree1.sortfield='';
	pmyTree1.editable=false;
	pmyTree1.style='full';
	pmyTree1.line=true;
	pmyTree1.width=0;
	pmyTree1.height=0;
	pmyTree1=myDBTree(pmyTree1);
	//myForm('myForm1','main','FushionChart单序列图表',0,0,0,0,'');
	myTabs('myTab','main','折线图;圆柱图;圆柱折线图;面积图;栏位图',0,0,0,0,'');
	myDateField('datefrom','toolbar','设置区间:',65,4,16,0,100,'2012-01-01','');		
	myDateField('dateto','toolbar','～',16,4,198,0,100,'2012-12-31','');		
	myComboField('yparam','toolbar','选择指标:',65,5,340,0,100,'销售额;利润额','','checkbox');	
	myCheckBoxField('x3d','toolbar','',0,5,340+190,'是否3D显示？','true');
	myButton('cmdok','toolbar','开始',4,450+190,25,68,'searchIcon','','');
	var tree1=$("#myTree1");
	var pmyChart1={};
	pmyChart1.colorset=''; //8EBB07;02BEBE;048F8F;D74B4B904990;5C882B;B5AD0A;018ED6;9E0B10';  //F6C11F';
	pmyChart1.chartno=1;	
	pmyChart1.type='multiple';  //单序列
	$("#myTab").tabs({border:false});
	//初始化时调用函数画图表
	fnGenChartXml();
	
	//编写“开始”按钮的点击事件
	$("#cmdok").bind('click',function(e){
		fnGenChartXml();  //生成图表xml文件并显示;
	});
	//生成xml文件的函数
	function fnGenChartXml(swf,div){
		var node=tree1.tree('getSelected');
		var flag=node.isparentflag;
		var yfield=['amount','profit'];
		var ytitle=['销售额','利润额'];
		//var yparam=$("#yparam").combobox("getText");
		if (flag==1) var xid=node.ancester+node.productid+'#';
		else var xid=node.productid;
		if (flag>0){
			var sql="select sum(a.amount) as amount,SUM(a.amount-a.Quantity*c.unitprice) as profit,100*year(orderdate)+month(orderdate) as month from orderitems a join orders b on a.orderid=b.orderid ";
			sql+="\n join products c on a.productid=c.productid";
			sql+="\n where c.productid in (select productid from products where ancester like '"+xid+"%' and isparentflag=0)";
			sql+="\n and orderdate between '"+$("#datefrom").textbox("getValue")+"' and ";
			sql+=" '"+$("#dateto").textbox("getValue")+"'";
		}else{
			var sql="select sum(a.amount) as amount,SUM(a.amount-a.Quantity*c.unitprice) as profit,100*year(orderdate)+month(orderdate) as month from orderitems a join orders b on a.orderid=b.orderid ";
			sql+="\n join products c on a.productid=c.productid";
			sql+="\n where c.productid='"+xid+"'";
			sql+="\n and orderdate between '"+$("#datefrom").textbox("getValue")+"' and ";
			sql+=" '"+$("#dateto").textbox("getValue")+"'";
		}
		sql+="\n group by year(orderdate),month(orderdate)";
		sql+="\n order by year(orderdate),month(orderdate)";
		//console.log(sql);
		var source=myRunSelectSql(sysdatabasestring, sql);
		var date1=myDateboxValue('datefrom','');
		var date2=myDateboxValue('dateto','');
		pmyChart1.title=date1+"～"+date2+"销售额、利润额变化图\n"+node.productname;
		pmyChart1.xAxisName="月份";
		pmyChart1.labelfield='month';
		pmyChart1.yAxisName='销售额;利润额';
		pmyChart1.valuefield='amount;profit';
		pmyChart1.data=source;
		pmyChart1.height=0;
		pmyChart1.width=0;
		pmyChart1=myGetChartXML(pmyChart1);
		console.log(pmyChart1.xml);
		if ($("#x3d").is(':checked')){
			//文件名区分大小写');
			myShowFusionChart(pmyChart1,'MSSpline','myTab1');	//折线图
			myShowFusionChart(pmyChart1,'MSColumn3D','myTab2');  //圆柱图
			myShowFusionChart(pmyChart1,'MSColumn3DLineDY','myTab3');  //圆柱折线图
			myShowFusionChart(pmyChart1,'MSSplineArea','myTab4');  //面积图;
			myShowFusionChart(pmyChart1,'MSBar3D','myTab5');  //栏位图
		}else{
			myShowFusionChart(pmyChart1,'MSLine','myTab1');	//折线图
			myShowFusionChart(pmyChart1,'MSColumn2D','myTab2'); //圆柱图;
			myShowFusionChart(pmyChart1,'MSColumnLine3D','myTab3');   //圆柱折线图;
			myShowFusionChart(pmyChart1,'MSArea','myTab4');  //面积图;
			myShowFusionChart(pmyChart1,'MSBar2D','myTab5'); //栏位图
		}
	}
	//---------------------//
	});  //endofjquery
	function  myTreeEvents(id,e){
	
	}

</script>
</body>
</html>