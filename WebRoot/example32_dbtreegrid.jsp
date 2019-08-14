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
		sql_students="select StudentID,Name,pycode,case when Gender='f' then '女' else '男' end as gender,"+
		"birthdate,province,city,mobile,homephone,email,weixin,qq from students";
		//me.css,datagrid-cell-rownumber改变rownumber的宽度，默认25px
		var str='<div id="myGrid1" class="easyui-datagrid"></div>';
		$("#main").append($(str));
		var xcolumns=[[
			{ title: '姓名', field:'name', width: 90, halign:'center', align: 'left' },
			{ title: '拼音', field:'pycode', width: 110, halign:'center', align: 'left' },
			{ title: '出生日期', field: 'birthdate', width: 95, halign:'center', align: 'center',	formatter: function(value){
				value=value+'';  //类型转换
				return '<div align="center">' + value.substr(0,4)+'年'+value.substr(5,2)+'月'+value.substr(8,2)+'日'+'</div>'; }
			},
			{ title: '联系电话', field: 'mobile', width: 110, halign:'center', align: 'left' },
			{ title: '家庭电话', field: 'homephone', width: 110, halign:'center', align: 'left' },
			{ title: 'Email', field: 'email', width: 140, halign:'center', align: 'left' },
			{ title: '微信号', field: 'weixin', width: 130, halign:'center', align: 'left' }
		]];
		var xfixedcolumns=[[
			{ title: 'id', field: 'id', width: 20, checkbox: true, sortable: true, align: 'center'},
			{ title: '学号', field: 'studentid', width: 90, checkbox: false, sortable: true, halign:'center', align: 'left'	}
		]];
		$("#myGrid1").datagrid({
			title: '&nbsp;学生列表',
			iconCls: "panelIcon",
			width:780,
            //height:355,
			nowrap: true,
            pagePosition: 'bottom',  //top,both
            autoRowHeight: false,
            rownumbers: true,
			pagination: true,
			pageSize: 10,
			pageNumber:1,
            striped: true,
            collapsible: true,
			singleSelect: true, //false,
			//fitColumns: true,
            //sortName: 'studentid',
            //sortOrder: 'asc',
            //remoteSort: false,
            //idField: 'studentid',
			columns: xcolumns,
            frozenColumns: xfixedcolumns
		});	
		//定义分页栏模式
		var pg = $("#myGrid1").datagrid("getPager");  
		(pg).pagination({  
			//layout:['list','sep','first','prev','sep',$('#p-style').val(),'sep','next','last','sep','refresh'],
			showPageList: false,  //是否显示设置每页显示行数的下拉框
			beforePageText: '第', //页数文本框前显示的汉字  
			afterPageText: '页    共 {pages} 页', 
			displayMsg: '当前显示{from}～{to}行，共{total}行'
		}); 		  

		(pg).pagination({  
			onRefresh:function(pageNumber,pageSize){  
				fnLoadGridData(pageNumber,pageSize);  
			},  
			onChangePageSize:function(pageSize){  
				var opts = $('#myGrid1').datagrid('options');
				opts.pageSize=pageSize;				
				fnLoadGridData(1,pageSize);  
			},  
			onSelectPage:function(pageNumber,pageSize){  
				var opts = $('#myGrid1').datagrid('options');
				opts.pageNumber=pageNumber;
				opts.pageSize=pageSize;				
				fnLoadGridData(pageNumber,pageSize);  
			}  
		}); 		  
		//初始化，显示第一页记录
		var opts = $("#myGrid1").datagrid('options');
		fnLoadGridData(1,opts.pageSize);
	
	function fnLoadGridData(pageNumber,pageSize){
		var opts =$("#myGrid1").datagrid('getPager').data("pagination").options; 
		var pageSize=opts.pageSize;
		var pager =$("#myGrid1").datagrid('getPager');
		pager.pagination('refresh',{	// 改变选项，并刷新分页栏信息
			pageNumber: pageNumber
		});
		$.ajax({     
			type: "Post",     
			url: "system/easyui_getGridData.jsp",     
			//contentType: "application/json; charset=utf-8",     
			//dataType: "json", 
			data: {
				database: sysdatabasestring, 
				selectsql: sql_students,
				keyfield: 'studentid',
				sortfield: '',
				limit: pageSize,
				start: (pageNumber-1)*pageSize,
				summaryfields:''				
			}, 
			async: false, method: 'post',    
			success: function(data) {   
				eval("var source="+data+";");
				$('#myGrid1').datagrid("reload");  //放在loaddata之前，触发onBeforeLoad事件
				$('#myGrid1').datagrid("loadData", source );  //必须用loaddata
				//根据总行数改变行号的列宽度，改css
				var rowcount=$("#myGrid1").datagrid('getData').total+'';  //转换为字符型
				var width=(rowcount.length*6+8);
				if (width<25) width=25;
				var px=width+'px';
				$('.datagrid-header-rownumber,.datagrid-cell-rownumber').css({"width": px});
				$('#myGrid1').datagrid('resize');  //必须写
				if (pmyGrid1.rowindex>0) $('#myGrid1').datagrid('selectRow',pmyGrid1.rowindex); //选中某行
				else $('#myGrid1').datagrid('selectRow',0); //选中第一行
			}    
		});
	}

//---------------------
});
	
</script>
</body>
</html>