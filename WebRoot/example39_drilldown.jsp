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
<body style="margin:0px 0px 0px 0px;" data-options="fit:true">
<div class="easyui-layout" data-options="fit:true"> 
	<div id="toolbar" class="easyui-panel" data-options="region:'north'" style="overflow:hidden; height:33px; width:100%; background-color: #E0ECFF; margin:1px 1px 1px 1px;"></div>
	<div id="main" class="easyui-panel" data-options="region:'center'" style="position:relative; overflow:auto; width:1200px; margin:1px 1px 1px 1px;">
		<div id="pie1"></div>
		<div id="pie2"></div>
		<div id="chartdiv1" style="text-align:center"></div>
	</div>
</div>
<script>
$(document).ready(function() {
	$("#pie1").css(myTextCss('main',40,2,300,490));
	$("#pie2").css(myTextCss('main',40,500,300,490));
	$("#chartdiv1").css(myTextCss('main',340,5,400,600));
	//$("#chartdiv2").css(myTextCss('main',240,295,155,200));
	//定义grid
	myDateField('datefrom','toolbar','设置区间:',65,6,16,0,100,'2012-01-01','');		
	myDateField('dateto','toolbar','～',16,6,198,0,100,'2013-12-31','');		
	myButton('cmdok','toolbar','开始',5,350,25,68,'searchIcon','','');
	myComboField('rank1','main','选择销售额排名前:',115,10,145,0,60,'10;20;30;40;50','','');	
	myComboField('rank2','main','选择利润额排名前:',115,10,635,0,60,'10;20;30;40;50','','');	
	myLabel('rankx1','main','位客户',10+4,332);	
	myLabel('rankx2','main','位客户',10+4,822);	
	myWindow('myGridWin1','钻取客户月度销售情况',220,200,470,316,'','close;drag');
	myWindow('myGridWin2','钻取商品销售情况',0,0,595,455,'','close;drag');
	myWindow('myChartWin1','利润率（％）',320,640,285,280,'','drag;close');
	fnGenTwoPieChart2();  //打开页面就作图
	fnDrillDownColumnLineChart('');  //第一个图的钻取
	  
	$("#cmdok").bind('click',function(e){
		$("#myGridWin1").window("close");
		$("#myGridWin2").window("close");
		fnGenTwoPieChart2;  //文件名区分大小写');
	});
	
	function fnGenTwoPieChart2(){
		//取日期区间
		var date1=myDateboxValue('datefrom','');
		var date2=myDateboxValue('dateto','');
		//计算销售额和利润额
		var sql="select top "+$("#rank1").textbox("getValue")+" customerid,sum(a.amount) as amount from orderitems a join orders b on a.orderid=b.orderid ";
		sql+="\n where orderdate between '"+$("#datefrom").textbox("getValue")+"' and ";
		sql+=" '"+$("#dateto").textbox("getValue")+"'";
		sql+="\n group by customerid";
		sql+="\n order by amount desc ";
		var source1=myRunSelectSql(sysdatabasestring, sql);  //将销售额和利润额的数据保存到数组变量
		var pmyChart1={};
		pmyChart1.title=date1+"～"+date2+"\n销售额最大的前"+$("#rank1").textbox("getValue")+"位客户";
		pmyChart1.xAxisName="月份";  //x轴坐标名称
		pmyChart1.yAxisName='销售额';  //Y轴坐标名称
		pmyChart1.labelfield='customerid';  //label标签对应的列名
		pmyChart1.valuefield='amount';    //value标签对应的列名
		pmyChart1.data=source1;       //图表数据源
		pmyChart1.type='single';       //圆饼图为单序列图表
		pmyChart1.sliced=true;	     //圆饼图展开
		pmyChart1.height=300;     //圆饼图高度
		pmyChart1.width=490;         //圆饼图宽度
		pmyChart1.drilldown='fnDrillDownColumnLineChart(customerid)';   //向下钻取时调用的js函数名称及参数
		pmyChart1=myGetChartXML(pmyChart1);     //生成圆饼图的xml语句
		myShowFusionChart(pmyChart1,'Doughnut3D','pie1');     //显示圆饼图
		//画圆饼图，先计算每个客户的销售额和利润额
		var sql="select top "+$("#rank2").textbox("getValue")+" customerid,sum(a.amount) as amount,SUM(a.amount-a.Quantity*c.unitprice) as profit from orderitems a join orders b on a.orderid=b.orderid ";
		sql+="\n join products c on a.productid=c.productid ";
		sql+="\n where orderdate between '"+$("#datefrom").textbox("getValue")+"' and ";
		sql+=" '"+$("#dateto").textbox("getValue")+"'";
		sql+="\n group by customerid";
		sql+="\n order by profit desc ";
		var source2=myRunSelectSql(sysdatabasestring, sql);//将查询结果保存到数组变量source2
		var pmyChart2={};
		pmyChart2.colorset=''; //8EBB07;02BEBE;048F8F;D74B4B904990;5C882B;B5AD0A;018ED6;9E0B10';  //F6C11F';
		pmyChart2.title=date1+"～"+date2+"\n利润额最大的前"+$("#rank2").textbox("getValue")+"位客户";
		pmyChart2.xAxisName="月份";
		pmyChart2.yAxisName='利润额';
		pmyChart2.labelfield='customerid';
		pmyChart2.valuefield='profit';
		pmyChart2.data=source2;
		pmyChart2.sliced=true;	
		pmyChart2.height=300;
		pmyChart2.width=490;
		pmyChart2.type='single';
		pmyChart2.drilldown='fnDrillDownCustomerGrid(customerid)'; //钻取时使用的函数和传递的参数
		pmyChart2=myGetChartXML(pmyChart2);
		myShowFusionChart(pmyChart2,'Pie3D','pie2');
	}	
//---------------------//
});  //endofjquery

function fnDrillDownColumnLineChart(cid){  //向下钻取圆柱折线图
	//一级钻取，客户每月销售额+利润额图
	var date1=myDateboxValue('datefrom','');
	var date2=myDateboxValue('dateto','');
	//计算钻取客户每个月的销售额和利润额
	var sql="select sum(a.amount) as amount,SUM(a.amount-a.Quantity*c.unitprice) as profit,100*year(orderdate)+month(orderdate) as month from orderitems a ";
	sql+="\n join orders b on a.orderid=b.orderid ";
	sql+="\n join products c on a.productid=c.productid";
	sql+="\n where orderdate between '"+$("#datefrom").textbox("getValue")+"' and ";
	sql+=" '"+$("#dateto").textbox("getValue")+"'";
	if (cid!='') sql+=" and customerid='"+cid+"'";
	sql+="\n group by year(orderdate),month(orderdate)";
	sql+="\n order by year(orderdate),month(orderdate)";
	var source3=myRunSelectSql(sysdatabasestring, sql);  //将结果集保存到一个数组变量
	var pmyChart3={};
	pmyChart3.title=date1+"～"+date2+"销售额变化图";
	if (cid!=''){  //根据客户编码提取客户名称
		sql="select customerid,customername from customers where customerid='"+cid+"'";
		var customer=myRunSelectSql(sysdatabasestring, sql);
		pmyChart3.title+="\n"+customer[0].customerid+customer[0].customername;
	}else{
		pmyChart3.title+="\n全部客户";
	}
	pmyChart3.xAxisName="月份";
	pmyChart3.labelfield='month';
	pmyChart3.yAxisName='销售额;利润额';  
	pmyChart3.valuefield='amount;profit'; //两个序列的列名
	pmyChart3.data=source3;
	pmyChart3.type='multiple';
	pmyChart3.height=0;
	pmyChart3.width=800;
	pmyChart3.drilldown='fnGenProductGrid(month,"'+cid+'")';  //进行而二级钻取时将月份和客户编码传递给函数
	pmyChart3=myGetChartXML(pmyChart3);
	myShowFusionChart(pmyChart3,'MSColumn3DLineDY','chartdiv1');
	//钻取开始后，关闭三个无关的子窗口
	$("#myGridWin1").window("close");
	$("#myGridWin2").window("close");
	$("#myChartWin1").window("close");
}
//钻取报表
function fnDrillDownCustomerGrid(cid){
	//显示钻取的报表，客户每月销售额+利润额
	var date1=myDateboxValue('datefrom','');
	var date2=myDateboxValue('dateto','');
	var sql="select sum(a.amount) as amount,SUM(a.amount-a.Quantity*c.unitprice) as profit,100*year(orderdate)+month(orderdate) as month from orderitems a ";
	sql+="\n join orders b on a.orderid=b.orderid ";
	sql+="\n join products c on a.productid=c.productid";
	sql+="\n where orderdate between '"+$("#datefrom").textbox("getValue")+"' and ";
	sql+=" '"+$("#dateto").textbox("getValue")+"'";
	if (cid!='') sql+=" and customerid='"+cid+"'";
	sql+="\n group by year(orderdate),month(orderdate)";
	var pmyGrid1={};
	pmyGrid1.id='myGrid1';
	pmyGrid1.parent='myGridWin1';
	pmyGrid1.staticsql=sql;
	pmyGrid1.activesql=pmyGrid1.staticsql;
	pmyGrid1.gridfields='[@c#70]月份/month;[%n90,2]销售额/amount;[%n90,2]利润额/profit';
	pmyGrid1.fixedfields='';
	pmyGrid1.title=''; //不显示标题
	pmyGrid1.checkbox=''; //'single';
	pmyGrid1.pagesize=20;
	pmyGrid1.keyfield='month';
	pmyGrid1.sortfield='';
	pmyGrid1.rownumbers=true;
	pmyGrid1.collapsible=false;
	pmyGrid1.height=400;
	pmyGrid1.width=296;
	pmyGrid1.top=32;
	pmyGrid1.left=3;
	pmyGrid1.rowindex=0;
	$("#myGridWin1").empty();
	var sql="select customerid,customername from customers where customerid='"+cid+"'";
	var customer=myRunSelectSql(sysdatabasestring, sql);
	myLabel('xcustomer1','myGridWin1','客户名称：'+customer[0].customerid+customer[0].customername,8,8);
	//体用函数定义myGrid1
	myGrid(pmyGrid1);
	myLoadGridData(pmyGrid1,1); //显示grid数据
	$("#myGridWin1").window("open");
//计算客户利润率，画仪表盘
var sql="select sum(a.amount) as amount,SUM(a.amount-a.Quantity*c.unitprice) as profit from orderitems a ";
sql+="\n join orders b on a.orderid=b.orderid ";
sql+="\n join products c on a.productid=c.productid";
sql+="\n where orderdate between '"+$("#datefrom").textbox("getValue")+"' and ";
sql+=" '"+$("#dateto").textbox("getValue")+"'";
sql+=" and customerid='"+cid+"'";
var source4=myRunSelectSql(sysdatabasestring, sql);	
//生成仪表盘
var pmyChart4={};
pmyChart4.title=date1+"～"+date2+"销售额变化图";
	if (cid!=''){
		sql="select customerid,customername from customers where customerid='"+cid+"'";
		var customer=myRunSelectSql(sysdatabasestring, sql);
		pmyChart4.title+="\n"+customer[0].customerid+customer[0].customername;
	}else{
		pmyChart4.title+="\n全部客户";
	}
	pmyChart4.type='angular';
	pmyChart4.height=255;
	pmyChart4.width=270;
	pmyChart4.max=60;   //仪表盘显示的最大值
	pmyChart4.min=0;    //仪表盘显示的最小值
	pmyChart4.model=1;
	pmyChart4.radius=110;   //仪表盘的半径大小
	pmyChart4.value=(100.00*source4[0].profit/source4[0].amount).toFixed(3);  //利润率
	pmyChart4.label=pmyChart4.value+'％';   //仪表盘中心点显示的数值文字
	pmyChart4=myGetChartXML(pmyChart4);  //生成仪表盘的xml语句
	myShowFusionChart(pmyChart4,'AngularGauge','myChartWin1');  //显示仪表盘
	$("#myChartWin1").window("open");	//打开窗口显示仪表盘
	$("#myGridWin2").window("close");	//关闭其他窗口
}

function fnGenProductGrid(month,cid){
	//二级钻取，取客户购买的商品销售额和销售量
	var xyear=(''+month).substr(0,4);
	var xmonth=(''+month).substr(4,2);
	var pmyGrid2={};
	pmyGrid2.id='myGrid2';
	pmyGrid2.parent='myGridWin2';
	pmyGrid2.staticsql="select top 100 percent c.productid,c.productname,sum(a.amount) as amount,SUM(a.Quantity) as qty from orderitems a "+
	"\n join orders b on a.orderid=b.orderid "+
	"\n join products c on a.productid=c.productid "+
	"\n where year(orderdate)="+xyear+" and month(orderdate)="+xmonth;
	if (cid!='') pmyGrid2.staticsql+=" \n and b.customerid='"+cid+"'";
	pmyGrid2.staticsql+="\n group by c.productid,c.productname order by amount desc";
	//console.log(pmyGrid2.staticsql);
	pmyGrid2.activesql=pmyGrid2.staticsql;
	pmyGrid2.gridfields='[60]商品编码/productid;[180]商品名称/productname;[%n75,2]销售额/amount;[%n75]销售额/qty';
	pmyGrid2.fixedfields='';
	pmyGrid2.title='';
	pmyGrid2.checkbox=''; //'single';
	pmyGrid2.pagesize=20;
	pmyGrid2.keyfield='productid';
	pmyGrid2.sortfield='-amount';
	pmyGrid2.rownumbers=true;
	pmyGrid2.collapsible=false;
	pmyGrid2.height=524;
	pmyGrid2.width=435;
	pmyGrid2.top=32;
	pmyGrid2.left=3;
	pmyGrid2.rowindex=0;
	$("#myGridWin2").empty();
	myGrid(pmyGrid2);
	myLoadGridData(pmyGrid2,1);
	if (cid!=''){
		var sql="select customerid,customername from customers where customerid='"+cid+"'";
		var customer=myRunSelectSql(sysdatabasestring, sql);
		myLabel('xcustomer2','myGridWin2','客户名称：'+customer[0].customerid+customer[0].customername,8,8);
	}else{
		myLabel('xcustomer2','myGridWin2','客户名称：全部客户',8,8);
	}
	$("#myGridWin2").window("setTitle",'钻取'+xyear+'年'+xmonth+'月份商品销售情况');
	$("#myGridWin2").window("open");
}

String.prototype.getWidth = function(fontSize){  
    var span = document.getElementById("__getwidth");  
    if (span == null) {  
        span = document.createElement("span");  
        span.id = "__getwidth";  
        document.body.appendChild(span);  
        span.style.visibility = "hidden";  
        span.style.whiteSpace = "nowrap";  
    }  
    span.innerText = this;  
    span.style.fontSize = fontSize + "px";  
    return span.offsetWidth;  
}  

</script>
</body>
</html>