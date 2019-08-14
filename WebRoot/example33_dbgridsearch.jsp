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
<body class="easyui-layout" fit="true" style="margin: 2px 2px 2px 2px;">
	<div id='toolbar' class='easyui-panel' data-options="region:'north'" style="overflow:hidden; background-color: #E0ECFF; height:33px; padding: 1px 1px 1px 10px;"></div>
	<div id='main' class='easyui-panel' data-options="region:'center'" style="padding: 1px 1px 1px 1px;"></div>
<script>
	$(document).ready(function() {
		//example33_dbgridsearch.jsp
		var pmyGrid1={};
		pmyGrid1.id='myGrid1';
		pmyGrid1.parent='main';
		pmyGrid1.staticsql="select StudentID,Name,pycode,case when Gender='f' then '女' else '男' end as gender,";
		pmyGrid1.staticsql+="birthdate,province+' '+city as hometown,mobile,homephone,email,weixin,qq from students";
		pmyGrid1.activesql=pmyGrid1.staticsql;
		pmyGrid1.gridfields='[@l%c#90]姓名/name;[@c%c#110,2]拼音/pycode;[%d#90@c]出生日期/birthdate;[@c#100]所属城市/hometown;';
		pmyGrid1.gridfields+='[110]联系电话/mobile;[110]家庭电话/homephone;[140]Email/email;[130]微信号/weixin;[100]QQ号/qq';
		pmyGrid1.fixedfields='[@l%c#90]学号/studentid';
		pmyGrid1.title='学生列表';
		pmyGrid1.menu='myMenu1';
		pmyGrid1.checkbox='single';
		pmyGrid1.pagesize=10;
		pmyGrid1.keyfield='studentid';
		pmyGrid1.rownumbers=true;
		pmyGrid1.collapsible=true;
		pmyGrid1.height=600;
		pmyGrid1.width=780;
		pmyGrid1.rowindex=0;
		//定义grid
		myGrid(pmyGrid1);
		//初始化，显示第一页记录
		myLoadGridData(pmyGrid1,1);
		var tmp='';
		for (var i=0;i<pmyGrid1.columns.length;i++){
			if (tmp!='') tmp+=';';
			tmp+=pmyGrid1.columns[i].title;
		}
		myComboField('searchfield','toolbar','选择关键字:',75,4,10,0,260,tmp,'','checkbox');
		myTextField('searchtext','toolbar','快速定位：',65,4,380,0,260,'','');
		$('#searchtext').textbox({
			buttonIcon:'searchIcon',
			onClickButton: function(e){
				var xtext=$('#searchtext').textbox("getValue");
				var xfields=';'+$('#searchfield').combobox("getText")+';';
				//console.log(xtext+'---'+xfields);
				if (wheresql!='' && xtext!=''){
					var wheresql='';
					for (var i=0;i<pmyGrid1.columns.length;i++){
						if (xfields.indexOf(';'+pmyGrid1.columns[i].title+';')>=0){
							if (wheresql!='') wheresql+=' or ';
							wheresql+=pmyGrid1.columns[i].field+" like '%"+xtext+"%'";
						}
					}
					var sql='select top 1 '+pmyGrid1.keyfield+' from ('+pmyGrid1.staticsql+') as p where '+wheresql;
					var sources=myRunSelectSql(sysdatabasestring, sql);
					if (sources.length>0){
						var keyvalue=eval('sources[0].'+pmyGrid1.keyfield);
						sql='select count(*)+1 as rowno from ('+pmyGrid1.staticsql+') as p where '+pmyGrid1.keyfield+"<'"+keyvalue+"'";
						//console.log(sql);
						var sources=myRunSelectSql(sysdatabasestring, sql);
						var rowno=sources[0].rowno;
						var opts =$("#myGrid1").datagrid('getPager').data("pagination").options; 
						var pageno=parseInt((rowno-1)/opts.pageSize)+1;
						pmyGrid1.rowindex=rowno-(pageno-1)*opts.pageSize-1;
						var pager =$("#myGrid1").datagrid('getPager');
						pager.pagination('refresh',{	// 改变选项，并刷新分页栏信息
							//pageNumber: pageno
						});
						//opts.pageNumber=pageno;		
						var opts = $("#myGrid1").datagrid('options');		
						opts.pageNumber=pageno;		
						console.log(pageno+'----'+pmyGrid1.rowindex);
						myLoadGridData(pmyGrid1,pageno);
					}else{
						$.messager.alert('系统提示','没有找到满足条件的记录！','info');
					}
				}	            	
			}
			
		}); 

	//---------------------//
	});  //endofjquery

</script>
</body>
</html>