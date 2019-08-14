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
<div id='main' class="easyui-layout" data-options="fit:'true'" style="margin:0px 0px 0px 0px;">
 	<div  id='top' class='easyui-panel' data-options="region:'north'" style="overflow:hidden; background-color: #E0ECFF; height:80px;padding: 1px 1px 1px 10px;"></div>
 	<div  id='middle' class='easyui-panel' data-options="region:'center', split:true" style="overflow:auto;"></div>
</div>    
<script>
	$(document).ready(function() {
		myTextField('orderid','top','订单号：',70,10,10,20,120,'','');
		myDateField('orderdate','top','订单日期：',70,10,220,20,120,'','');
		myTextField('customerid','top','客户编码：',70,40,10,20,120,'','');
		myTextField('customername','top','客户名称：',70,40,220,20,120,'','');
		var jqsql={}; 
		var pmyGrid1={};//sql语句中不能有双引号
		jqsql.students="select productid,productname,quantityperunit,unit,quantity,unitprice,quantity*unitprice as amount from products";
		pmyGrid1.staticsql="select productid,productname,quantityperunit,unit,quantity,unitprice,";
		pmyGrid1.activesql=jqsql.students;
		//me.css,datagrid-cell-rownumber改变rownumber的宽度，默认25px
		var str='<div id="myGrid1" class="easyui-datagrid"></div>';
		$("#middle").append($(str));
		var xcolumns=[[
			{ title: '商品编码', field:'productid', width: 90, halign:'center', align: 'right' },
			{ title: '商品名称', field:'productname', width: 270, halign:'center', align: 'center'	},
			{ title: '规格型号', field: 'quantityperunit', width: 95, halign:'center', align: 'center' },
			{ title: '计量单位', field: 'unit', width: 60, halign:'center', align: 'center'  },
			{ title: '数量', field: 'quantity', width: 50, halign:'center', align: 'right' },
			{ title: '单价', field: 'unitprice', width: 50, halign:'center', align: 'right' },
			{ title: '金额', field: 'amount', width: 70, halign:'center', align: 'right' }
		]];
		var xfixedcolumns=[[
			//{ title: 'id', field: 'id', width: 20, checkbox: true, sortable: true, align: 'center'},
			{ title: '序号', field: 'rownumber', width: 90, halign:'center', align: 'right' }
		]];
		$("#myGrid1").datagrid({
			title: false,
			iconCls: "panelIcon",
			width:780,
            height:455,
			nowrap: true,
            pagePosition: 'bottom',  //top,both
            autoRowHeight: false,
            rownumbers: false,
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
            buttons: [{
				iconCls:'addIcon',
				handler:function(){alert('add')}
				},'-',{
					iconCls:'saveIcon',
					handler:function(){alert('save')}
				}],
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
			var pager =$("#myGrid1").datagrid('getPager');
			pager.pagination('refresh',{	// 改变选项，并刷新分页栏信息
				pageNumber: pageNumber
			});
			var opts =$("#myGrid1").datagrid('getPager').data("pagination").options; 
			opts.pageNumber=pageNumber;
			var pageSize=opts.pageSize;
			$.ajax({     
				type: "Post",     
				url: "system/easyui_getGridData.jsp",     
				//contentType: "application/json; charset=utf-8",     
				//dataType: "json", 
				data: {
					database: sysdatabasestring, 
					selectsql: jqsql.students,
					keyfield: 'productid',
					sortfield: '',
					limit: pageSize,
					start: (pageNumber-1)*pageSize,
					summeryfields:''				
				}, 
				async: false, method: 'post',    
				success: function(data) {   
					eval("var source="+data+";");
					$("#myGrid1").datagrid("reload");  //放在loaddata之前，触发onBeforeLoad事件
					$("#myGrid1").datagrid("loadData", source );  //必须用loaddata
					//根据总行数改变行号的列宽度，改css
					var rowcount=$("#myGrid1").datagrid('getData').total+'';  //转换为字符型
					var width=(rowcount.length*6+8);
					if (width<25) width=25;
					var px=width+'px';
					$('.datagrid-header-rownumber,.datagrid-cell-rownumber').css({"width": px});
					$("#myGrid1").datagrid('resize');  //必须写
					$("#myGrid1").datagrid('selectRow',0); //选中第一行
				} 
			}); 
		}
		$('#orderid').textbox({
			buttonIcon:'icon-filter',
			onClickButton: function(e){
				wheresql=fnGenWhereSql('filter');
				if (wheresql!='') pmyGrid1.activesql='select * from ('+pmyGrid1.staticsql+') as p where '+wheresql;
				else pmyGrid1.activesql=pmyGrid1.staticsql;
				//console.log(pmyGrid1.activesql);
				var opts =$("#myGrid1").datagrid('getPager').data("pagination").options; 
				opts.pageNumber=1;
				pmyGrid1.rowindex=0;
				myLoadGridData(pmyGrid1,1);            	
			}
		});
		function fnGenWhereSql(action){
			var xtext=$('#orderid').textbox("getValue");
			//var xfields=';'+$('#searchfield').combobox("getText")+';';
			var wheresql='';
			for (var i=0;i<myGrid1.columns.length;i++){
				
					if (wheresql!='') wheresql+=' or ';
					wheresql+=pmyGrid1.columns[i].field+" like '%"+xtext+"%'";
				
			}
			return wheresql;
		}
//---------------------
	});
	
</script>
</body>
</html>