<%@ page language="java" import="java.util.*" contentType="text/html;charset=utf-8"  language="java"  pageEncoding="UTF-8" %>
<!doctype html>
<html>
<style type="text/css">
</style>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link rel="stylesheet" type="text/css" href="jqeasyui/themes/default/easyui.me.css">
	<link rel="stylesheet" type="text/css" href="jqeasyui/themes/icon.css">
    <link rel="stylesheet" type="text/css" href="system/css/icon.css">
    <link rel="stylesheet" type="text/css" href="index.css">
    <script type="text/javascript" src="jqeasyui/jquery.min.js"></script>
    <script type="text/javascript" src="jqeasyui/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="jqeasyui/easyui-lang-zh_CN.js"></script>
    <script type="text/javascript" src="jqeasyui/fusioncharts/fusioncharts.js"></script>		
	<script type="text/javascript" src="system/easyui_functions.js"></script>
	<script type="text/javascript" src="system/easyui_html5media.js"></script>
</head>
<body id='main' class="easyui-layout" data-options="fit:true" style="margin: 1px 1px 1px 1px;">
	<div id='top' class='easyui-panel' data-options="region:'north'" style="overflow:hidden; background-color: #E0ECFF; height:30px; padding: 6px 1px 1px 10px;"></div>	
	<div id='bottom' class='easyui-panel' data-options="region:'south'" style="height:35px; overflow:auto; padding:8px 0px 0px 20px;">
	</div>
	<div id='left' class='easyui-panel' data-options="region:'west', split:true" style="overflow:auto; width:200px;">
		<div class="easyui-accordion" data-options="fit:true, border:false">
			<div id='content1' title="我的工作台"></div>
			<div id='content2' title="公司资源管理"></div>
			<div id='content3' title="设置"></div>
		</div>
	</div>
	<div id='middle' class='easyui-panel' data-options="region:'center', split:true" style="overflow:auto;">
		<div id="middlelayout" class="easyui-layout" data-options="fit:true">
			<div id='middletop' class='easyui-panel' data-options="region:'center',split:true, border:false" style="overflow:hidden"><div id="win" class="easyui-window"></div></div>
			<div id='middlebottom' class='easyui-panel' data-options="region:'south', split:true, border:false"  style="overflow:hidden; height:220px;">
				<div id="newscontent"  style=" width:890px;height:200px;float:left;margin: 40px 20px;"></div>
				<div id="newsicon"  style="width:200px;height:200px;float:left;margin:20px 0px 0px 30px"><img src="system/images/menu/a12.png"></div>
				
			</div>
		</div>
	</div>
<script>
	$(document).ready(function() {
		//实时显示系统当前时间
		setInterval(function() {
		    var now = (new Date()).toLocaleString();
		    $('#top').text("XX有限公司 XXX 您好，现在是"+now);
		},1000);
		//提取服务器的文本文件	  
		//$('#content1').load('mybase/c-programming.txt');		
		/*
		$.ajax({
			url: 'mybase/c-programming.txt',
			cache:false,
			 async: false, type: "post",		
			dataType: 'text',   //html
			success: function(data) {
				console.log(Utf8ToUnicode(data));
				$('#content1').text('');  //清空
				$('#content1').append(data);
			}
		});
		*/
		//添加文字
		var xsql="select id,text,date from news";
		var newssource=myRunSelectSql('jqdemos',xsql);
		var str='<ul id="newslist" class="easyui-datalist" title=""  data-options="fit:true" style="width:880px"></ul>';
		$("#newscontent").append($(str));
		$('#newslist').datalist({
		    url: newssource,
		    checkbox: true,
		    lines: true
		});
		for(var i=0;i<3;i++){
			str='<li id="myfocus" onclick="" style="position:absolute;top:'+(i*60+50)+'px;left:30px;width:880px;font-size:14px">&nbsp;&nbsp;'+newssource[i].text+'<br/>'+newssource[i].date+'</li>';
			$("#newscontent").append($(str));
			}
		$("li").css({'list-style-type':'none'});
		
		var str='<a id="more" class="easyui-linkbutton" style="position:absolute;top:8px;left:850px;font-size:16px;" >更多》》</a>';
		$("#newscontent").append($(str));
		
		$('#win').window({
			top:40,
			left:400,
		    width:600,
		    height:400,
		    title:'所有公告',
		    modal:true,
		    closed:true
		});
		var pmyGrid1 = {};
        pmyGrid1.id = 'myGrid1';
        pmyGrid1.parent = 'win';
        pmyGrid1.staticsql = "select id,text,";
        pmyGrid1.staticsql += "date from news";
        pmyGrid1.activesql = pmyGrid1.staticsql;
        pmyGrid1.searchsql = "select id from news";
        pmyGrid1.gridfields = '[@c%c#480,2]公告内容/text;';
        pmyGrid1.gridfields += '[80]发布日期/date';
        pmyGrid1.fixedfields = '';
        pmyGrid1.title = false;
        pmyGrid1.menu = 'myMenu1';
        pmyGrid1.checkbox = 'single';
        pmyGrid1.pagesize = 20;
        pmyGrid1.keyfield = 'id';
        pmyGrid1.rownumbers = false;
        pmyGrid1.collapsible = true;
        pmyGrid1.height = 350;
        pmyGrid1.width = 590;
        pmyGrid1.rowindex = 0;
        //定义grid
        myGrid(pmyGrid1);
        //初始化，显示第一页记录
        myLoadGridData(pmyGrid1, 1);
        $('#more').bind('click', function(){
    		$("#win").window({
    			closed:false
    		});
        });

        
		
		var str='<br/><a href="0106test.jsp" class="menubutton"><img src="system/images/menu/a6.png"></a><a href="1217b.jsp" class="menubutton"><img src="system/images/menu/a5.png"></a><br/>';
		$('#content1').append($(str));
		var str='<a href="notes.jsp" class="menubutton"><img src="system/images/menu/a7.png"></a><a href="tongji.jsp" class="menubutton"><img src="system/images/menu/a8.png"></a><br/>';
		$('#content1').append($(str));
		var str='<a href="meetingnotes.jsp" class="menubutton"><img src="system/images/menu/a9.png"></a><a href="advice.jsp" class="menubutton"><img src="system/images/menu/a11.png"></a><br/>';
		$('#content1').append($(str));
		var str='<br/><a href="employees.jsp" class="menubutton"><img src="system/images/menu/a2.png"></a><a href="products.jsp" class="menubutton"><img src="system/images/menu/a1.png"></a><br/>';
		$('#content2').append($(str));
		$('#content3').html("");		
		$("#btn").css({padding:"0px 0px 0px 20px","text-decoration":"none","color":"#000000"});
		
		
		//生成xml文件的函数
		var sql="select sum(a.Amount) as amount,100*year(orderdate)+month(orderdate) as month from orderitems a join Orders b on a.OrderID=b.orderid";
		sql+="\n group by year(orderdate),month(orderdate)";
		sql+="\n order by year(orderdate),month(orderdate)";
		console.log(sql);
		var pmyChart1={};
		pmyChart1.data=myRunSelectSql(sysdatabasestring, sql);
		pmyChart1.colorset='';  //F6C11F';
		pmyChart1.chartno=1;	
		pmyChart1.type='single';  //单序列
		pmyChart1.title='近日总销售额';
		pmyChart1.xAxisName="月份";
		pmyChart1.yAxisName='销售额';
		pmyChart1.labelfield='month';
		pmyChart1.valuefield='amount';
		pmyChart1.height=0;
		pmyChart1.width=0;
		pmyChart1=myGetChartXML(pmyChart1);
		//console.log(pmyChart1.xml);
		if ($("#x3d").is(':checked')){
			myShowFusionChart(pmyChart1,'Line','middletop');	
		}else{
			myShowFusionChart(pmyChart1,'Line','middletop');	
		}
		
		
	});
		

	
	

		function myGridEvents(id,e) {
			e=e.toLowerCase();
			if(e=='onclickcell')
				{
					var row = $('#myGrid1').datagrid('getSelected');
					$.messager.show({
						title:'具体内容',
						msg:row.text,
						showType:'show',
						width:400,
						height:200,
						timeout:0,
						style:{
							top: 100,
							left:450
						}
					});
					
				}

    	}
</script>
</body>
</html>