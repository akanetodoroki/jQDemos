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
	<div id='toolbar' class='easyui-panel' data-options="region:'north'" style="overflow:hidden; background-color: #E0ECFF; height:33px; padding: 1px 1px 1px 10px;">
		 <a href="indexx.jsp" id="btnreturn" class="easyui-linkbutton" data-options="iconCls:'returnIcon',plain:true" style="margin-left:525px">返回首页</a>
	</div>
	<div id='bottompanel' class='easyui-panel' data-options="region:'center', split:true" style="padding: 2px 2px 2px 2px;">
		<div class="easyui-layout" data-options="fit:true" style="margin: 0px 0;">
			<div id='treepanel' class='easyui-panel' data-options="region:'north', split:true, border:true" style="height:45%; padding: 1px 1px 1px 1px;"></div>
			<div id='main' class='easyui-panel' data-options="region:'center'" style="padding: 1px 1px 1px 1px;"></div>
		</div>	
	</div>
<script>
$(document).ready(function() {
	//定义树myTree1
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
	//myDBTree('myTree1','treepanel','商品分类',0,0,0,0,pmyTree1.sql,pmyTree1.keyfield,'','');
	myTabs('myTab','main','折线图;直方图;面积图;栏位图;圆饼图;环饼图',0,0,0,0,'');
	myDateField('datefrom','toolbar','设置区间：',70,4,16,0,100,'2012-01-01','');		
	myDateField('dateto','toolbar','～',16,4,198,0,100,'2012-12-31','');		
	myCheckBoxField('x3d','toolbar','',0,5,340,'是否3D显示？','true');
	myButton('cmdok','toolbar','开始',4,450,25,68,'searchIcon','','');
	var tree1=$("#myTree1");
	//$("#myTab").tabs({border:false});
	//初始化时调用函数画图表
	fnGenChartXml();
	//编写“开始”按钮的点击事件
	$("#cmdok").bind('click',function(e){
		fnGenChartXml();  //生成图表xml文件并显示;
	});
	//生成xml文件的函数
	function fnGenChartXml(swf,div){
		var date1=myDateboxValue('datefrom','');
		var date2=myDateboxValue('dateto','');
		var node=tree1.tree('getSelected');
		var flag=node.isparentflag;
		if (flag==1) var xid=node.ancester+node.productid+'#';
		else var xid=node.productid;
		if (flag>0){
			var sql="select sum(a.amount) as amount,100*year(orderdate)+month(orderdate) as month from orderitems a join orders b on a.orderid=b.orderid ";
			sql+="\n where productid in (select productid from products where ancester like '"+xid+"%' and isparentflag=0)";
			sql+="\n and orderdate between '"+$("#datefrom").textbox("getValue")+"' and ";
			sql+=" '"+$("#dateto").textbox("getValue")+"'";
		}else{
			var sql="select sum(a.amount) as amount,100*year(orderdate)+month(orderdate) as month from orderitems a join orders b on a.orderid=b.orderid ";
			sql+=" where productid='"+xid+"'";
			sql+=" and orderdate between '"+$("#datefrom").textbox("getValue")+"' and ";
			sql+=" '"+$("#dateto").textbox("getValue")+"'";
		}
		sql+="\n group by year(orderdate),month(orderdate)";
		sql+="\n order by year(orderdate),month(orderdate)";
		console.log(sql);
		var pmyChart1={};
		pmyChart1.data=myRunSelectSql(sysdatabasestring, sql);
		pmyChart1.colorset='';  //F6C11F';
		pmyChart1.chartno=1;	
		pmyChart1.type='single';  //单序列
		pmyChart1.title=date1+"～"+date2+"销售额变化图\n"+node.productname;
		pmyChart1.xAxisName="月份";
		pmyChart1.yAxisName='销售额';
		pmyChart1.labelfield='month';
		pmyChart1.valuefield='amount';
		pmyChart1.height=0;
		pmyChart1.width=0;
		pmyChart1=myGetChartXML(pmyChart1);
		//console.log(pmyChart1.xml);
		if ($("#x3d").is(':checked')){
			myShowFusionChart(pmyChart1,'Line','myTab1');	
			myShowFusionChart(pmyChart1,'Column3D','myTab2');  //文件名区分大小写');
			myShowFusionChart(pmyChart1,'Area2D','myTab3');  //文件名区分大小写');
			myShowFusionChart(pmyChart1,'Bar2D','myTab4');  //文件名区分大小写');
			myShowFusionChart(pmyChart1,'Pie3D','myTab5');
			myShowFusionChart(pmyChart1,'Doughnut3D','myTab6');
		}else{
			myShowFusionChart(pmyChart1,'Line','myTab1');	
			myShowFusionChart(pmyChart1,'Column2D','myTab2');  //文件名区分大小写');
			myShowFusionChart(pmyChart1,'Area2D','myTab3');  //文件名区分大小写');
			myShowFusionChart(pmyChart1,'Bar2D','myTab4');  //文件名区分大小写');
			myShowFusionChart(pmyChart1,'Pie2D','myTab5');
			myShowFusionChart(pmyChart1,'Doughnut2D','myTab6');
		}
	}
	
	function fnShowChart(pmyChart1,swf,div){
			//Pyramid;仪表盘/AngularGauge;温度计/Thermometer
		var pw=$("#"+div).width();
		var ph=$("#"+div).height();
		var xwidth=0;
		var xheight=0;
		var charttype=[];
		charttype[1]=";MSSpline;MSColumn3D;MSColumn3DLineDY;MSSplineArea;MSLine;MSColumn2D;MSColumnLine3D;MSArea;";  //多序列
		charttype[1]+="Line;Column3D;Column2D;Area2D;";    //折线图、圆柱体、面积图
		charttype[2]=";MSBar3D;MSBar2D;Bar2D;";  //栏位图
		charttype[3]=";Doughnut3D;Doughnut2D;Pie3D;Pie2D;";    //圆饼图环饼图
		charttype[4]=";Pyramid;";  
		//ert(charttype.length);
		var n=pmyChart1.data.length;
		for (var i=1;i<charttype.length-1;i++) charttype[i]=charttype[i].toLowerCase();
		var xswf=";"+swf.toLowerCase()+";";
		if (charttype[1].indexOf(xswf)>=0){  //折线图圆柱图
			xwidth=Math.max(n*7*6+172,600);
			xheight=300;
		}else if (charttype[2].indexOf(xswf)>=0){  //栏位图
			xheight=Math.max(Math.min(280+n*12,700),450);
			xwidth=300;
		}else if (charttype[3].indexOf(xswf)>=0){  //圆饼图
			xwidth=Math.max(Math.min(300+n*20,600),400);
			xheight=1.0*xwidth*0.65;
		}else if (charttype[4].indexOf(xswf)>=0){  //圆锥图
			xheight=Math.max(Math.min(350+n*12,700),450);
			xwidth=600;
		}
		//console.log(pmyChart1.width);
		if (pmyChart1.width<=0 && xwidth<pw) xwidth='100%';
		else xwidth=Math.max(xwidth,pmyChart1.width);
		if (pmyChart1.height<=0 && xheight<ph) xheight='99%';
		else xheight=Math.max(xheight,pmyChart1.height);
		//显示chart
		var chart = new FusionCharts("jqeasyui/fusioncharts/swf/"+swf+".swf","chartid_"+pmyChart1.chartno,""+xwidth+"",""+xheight+"","0","1");
		//var chart = new FusionCharts("system/fusioncharts/swf/MSColumnLine3D.swf", "myChart1","748","400","0","0");
	  	chart.setDataXML(pmyChart1.xml);
		//chart.setDataURL("system/fusioncharts/xml/Bar2D.xml");
	  	chart.render(div);
	  	pmyChart1.chartno++;
	}	
	
	//---------------------//
});  //endofjquery
function  myTreeEvents(id,e){
	
}
</script>
</body>
</html>