<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<!doctype html>
<html lang="en">
<style type="text/css">
.scrollbar-vertical{
    top: 0;
    right: 0;
    width: 17px;
    height: 100%;
    overflow-x: hidden;
    scrollbar-3dlight-color:#999;
    scrollbar-arrow-color:white;
    scrollbar-base-color:white;
    scrollbar-face-color:#999;
    border-radius:5px 5px; 
}
</style>
<head>
	<meta charset="utf-8">
	<link rel="stylesheet" type="text/css" href="jqeasyui/themes/default/easyui.me.css">
	<link rel="stylesheet" type="text/css" href="jqeasyui/themes/icon.css">
    <link rel="stylesheet" type="text/css" href="system/css/icon.css">
    <link rel="stylesheet" type="text/css" href="system/css/textgrid.css">
    <script type="text/javascript" src="jqeasyui/jquery.min.js"></script>
    <script type="text/javascript" src="jqeasyui/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="jqeasyui/easyui-lang-zh_CN.js"></script>	
	<script type="text/javascript" src="system/easyui_functions.js"></script>
	<script type="text/javascript" src="system/easyui_grid.js"></script>
</head>
<body id='main' style="margin: 2px 2px 2px 2px;">
	<div id='main1' class='easyui-layout' data-options="fit:true" style="overflow:hidden; margin:0px 0px 0px 0px;">
		<div id='toolbar' class='easyui-panel' data-options="region:'north'" style="overflow:hidden; background-color:#E0ECFF; height:32px; padding: 3px 6px 0px 0px;"></div>
		<div id='gridpanel' class='easyui-panel' data-options="region:'center',fit:true" style="overflow:auto; border-width:0px;"></div>
	</div>
<script>
	var pmyGrid1={};
	$(function() {
		document.onkeypress=myBanBackSpace;
		document.onkeydown=myBanBackSpace;
		myButtonGroup('cmdbar','toolbar','-;|保存/cmdsave/saveIcon;|重置/cmdreset/resetIcon;|刷新/cmdrefresh/refreshIcon;|',6,10,17,60);	
		myMenuItem('myMenu1','新增/popappend/addIcon;插入/popinsert/insertIcon;删除/popdelete/deleteIcon;-;保存/popsave/saveIcon;-;重置/popreset/resetIcon','');
		pmyGrid1.parent='gridpanel';	
		pmyGrid1.id='myGrid1';
		pmyGrid1.rowheight=32;
		pmyGrid1.headerheight=30;
		pmyGrid1.rownumberwidth=40;
		pmyGrid1.checkboxwidth=30;
		pmyGrid1.append='auto';
		pmyGrid1.editable=true;
		pmyGrid1.menu='myMenu1';
		pmyGrid1.rows=20;
		pmyGrid1.top=0;
		pmyGrid1.left=20;
		pmyGrid1.height=0;
		pmyGrid1.width=00;
		pmyGrid1.rownumber=true;
		pmyGrid1.checkbox=true;
		pmyGrid1.clickonselect=true;
		pmyGrid1.select='single';		
		pmyGrid1.pagesize=0;
		pmyGrid1.pagenumber=1;
		pmyGrid1.gridfields='[#100]教师编码/teacherid;[#100]姓名/name;[#100]拼音/pycode;[@c%b#70]性别/gender;[%d#100]出生日期/birthdate;[%x#150]职称/title;[%x#150]党派/party;[%x#150]出生地/city;[%b#200]研究方向/research;[#150]联系电话/mobile';
		pmyGrid1.tablename='teachers';
		pmyGrid1.title='选项编辑';
		pmyGrid1.keyfield='teacherid';
		pmyGrid1.sortfield='';
		pmyGrid1.staticsql="select teacherid,Name,pycode,case when Gender='f' then '女' else '男' end as gender,"+
		"birthdate,province,city,title,party,research,mobile from teachers";
		pmyGrid1.activesql=pmyGrid1.staticsql;  //根据过滤条件动态变化的查询语句
		pmyGrid1.keyfield='teacherid';  //数据表关键字
		pmyGrid1.sql_party="select Pycode as id,description as text from dictionary where Type='党派'";
		pmyGrid1.sql_title="select Pycode as id,description as text from dictionary where Type='职称'";
		pmyGrid1.sql_city="select AreaName as text,AreaName as id from Areas where level=1";
		pmyGrid1.rowindex=-1;
		pmyGrid1.data=[];
		pmyGrid1.items_gender='男;女';
		pmyGrid1.items_research='[@]区域经济学;国际经济贸易;财务管理;电子商务;企业信息化';
		pmyGrid1=myTextGrid(pmyGrid1); //生成网格
		myLoadTextGridData(pmyGrid1);
		$("#popappend").click(function(e){
			pmyGrid1=myAppendGridRow(pmyGrid1);
			myCellFocus(pmyGrid1.rows-1,0);
		});
		$("#popinsert").click(function(e){
			var row=$("#cell_0").attr('xrow');
			pmyGrid1=myInsertGridRow(pmyGrid1,row);
		});
		$("#popdelete").click(function(e){
			var row=$("#cell_0").attr('xrow');
			pmyGrid1=myDeleteGridRow(pmyGrid1,row);
		});
		$("#popsave,#cmdsave").click(function(e){
			pmyGrid1=mySaveGridRows(pmyGrid1);
			//var result=myRunUpdateSql(sysdatabasestring, sql);
		});
		$("#popreset,#cmdreset,#cmdrefresh,#poprefresh").click(function(e){
			pmyGrid1.rowindex=0;
			myLoadTextGridData(pmyGrid1);
		});		
		//var div= $('#'+myGrid1.id);
		//var hasVerticalScrollbar= div[0].scrollHeight > div[0].clientHeight;
		//var hasHorizontalScrollbar= div[0].scrollWidth > div[0].clientWidth;
		//console.log(hasHorizontalScrollbar);
		//console.log(hasVerticalScrollbar);
//---------------------
	});
	function myGridEvents(id,e){
		
	}	
</script>
</body>
</html>