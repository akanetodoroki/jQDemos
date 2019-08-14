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
    <script>
	$(document).ready(function() {
		var jqsql={};  //sql语句中不能有双引号
		jqsql.area="select * from Areas union all select * from Areas union all select * from Areas union all select * from Areas union all select * from Areas union all select * from Areas union all select * from Areas union all select * from Areas union all select * from Areas union all select * from Areas union all select * from Areas union all select * from Areas union all select * from Areas union all select * from Areas union all select * from Areas union all select * from Areas union all select * from Areas union all select * from Areas union all select * from Areas";
		jqsql.account="select * from Accounts";
		jqsql.product="select productid,productname,quantityperunit,unitprice,a.supplierid,companyname as suppliername from Products a join suppliers b on a.supplierid=b.supplierid";
		//myTabForm('myTab','main','表格管理','地区列表;科目列表;产品列表',0,0,450,800,'collapse;drag');
		//me.css,datagrid-cell-rownumber改变rownumber的宽度，默认25px
		var pagesize=20; //每页行数只能是10的倍数
		var id='myGrid1';
		var grid=$('#'+id);
		var xcolumns=[[
			{ title: '产品名称', field:'productname', width: 260, halign:'center', align: 'left'	},
			{ title: '单价', field: 'unitprice', width: 120, halign:'center', align: 'right', formatter: function(value) {
				return '<div align="right">' + (1.0*value).toFixed(2) + '</div>';
				}
			},{ title: '供应商', field: 'suppliername', width: 220, halign:'center', align: 'left' }
		]];
		var xfixedcolumns=[[
			{ title: 'id', field: 'id', width: 20, checkbox: true, sortable: true, align: 'center'},
			{ title: '产品编码', field: 'productid', width: 120, checkbox: false, sortable: true, halign:'center', align: 'left'	},
		]];
		grid.datagrid({
			title: '&nbsp;产品列表',
            iconCls: "panelIcon",
            width:780,
            height:450,
            nowrap: true,
            pagePosition: 'bottom',  //top,both
            autoRowHeight: false,
            rownumbers: true,
			pageSize: pagesize,
			pageNumber:1,
            striped: true,
            collapsible: true,
			singleSelect: true, //false,
			//fitColumns: true,
            //sortName: 'productid',
            //sortOrder: 'asc',
            //remoteSort: false,
            idField: 'productid',
            frozenColumns: xfixedcolumns,
			columns: xcolumns,
			pagination: true,
			onSelect: function (index,record){
				//alert(record.productid);  
			}			
		});	
		//grid事件定义		
		grid.datagrid({
			onSelect: function (index,record){
				//alert(record.productid);  
			},
			onRowContextMenu: function(e,index,record){
				e.preventDefault(); //阻止浏览器捕获右键事件  
		        //$(this).datagrid("clearSelections"); //取消所有选中项  
		        $(this).datagrid("selectRow", index); //根据索引选中该行  
		         $('#menu').menu('show', {   //显示右键菜单  
					left: e.pageX, //在鼠标点击处显示菜单  
					top: e.pageY  
				});
			},
			onDblClickRow: function(index,record){
			 //双击跳出窗体
			
			}
		});
			
		myLoadGrid(1,pagesize);
		
		var pg = grid.datagrid("getPager");  
		(pg).pagination({  
			//layout:['list','sep','first','prev','sep',$('#p-style').val(),'sep','next','last','sep','refresh'],
			showPageList:false,
			beforePageText: '第', //页数文本框前显示的汉字  
			afterPageText: '页    共 {pages} 页', 
			displayMsg: '当前显示{from}～{to}行，共{total}行',
			onBeforeRefresh:function(){  
				//alert('before refresh');  
		    },  
			onRefresh:function(pageNumber,pageSize){  
				myLoadGrid(pageNumber,pageSize);  
			},  
			onChangePageSize:function(){  
				//alert('pagesize changed');  
			},  
			onSelectPage:function(pageNumber,pageSize){  
				alert(pageNumber+'----'+pageSize);
				var opts = grid.datagrid('options');
				opts.pageNumber=pageNumber;
				opts.pageSize=pageSize;				
				myLoadGrid(pageNumber,pageSize);  
			}  
		}); 		  

		var panel = grid.datagrid('getPanel').attr('tabindex',0).focus();
		panel.bind('keydown', function(e){
			var delta=0;
			if (e.keyCode==38) delta=-1;   //up
			else if (e.keyCode==40) delta=1;   //down
			if (delta!=0){
				var count = grid.datagrid('getRows').length;   //row count
				var selected = grid.datagrid('getSelected');
				if (selected){
					var index = grid.datagrid('getRowIndex', selected);
					index = index + delta;
					if (index < 0) index = 0;
					if (index >= count) index = count - 1;
					grid.datagrid('clearSelections');
					grid.datagrid('selectRow', index);
				} else {
					grid.datagrid('selectRow', (delta==-1 ? count-1 : 0));
				}
	            return false;
		    }
		});
		
	
	function myLoadGrid(pageNumber,pageSize){
		$.ajax({     
			type: "Post",     
			url: "system/easyui_getGridData.jsp",     
			//contentType: "application/json; charset=utf-8",     
			//dataType: "json", 
			data: {
				database: sysdatabasestring, 
				selectsql: jqsql.product,
				keyfield: 'productid',
				sortfield: '',
				limit: pageSize,
				start: (pageNumber-1)*pageSize,
				summaryFields:''				
			}, 
			async: false,    
			success: function(data) {   
				eval("var source="+data+";");
				//console.log(data);
				$("#"+id).datagrid( "loadData", source );  //必须用loaddata
				//根据总行数改变行号的列宽度，改css
				var rowcount=grid.datagrid('getData').total+'';  //转换为字符型
				var width=(rowcount.length*6+8);
				if (width<25) width=25;
				var px=width+'px';
				//console.log(px);				
				$('.datagrid-header-rownumber,.datagrid-cell-rownumber').css({"width": px});
				$('#'+id).datagrid('resize');  //必须写
				$('#'+id).datagrid('selectRow',0); //选中某行
			},     
			error: function(err) {   
				console.log(err);     
			}     
		});
	}

//---------------------
});

function menuHandler(item){
	var id=item.id;
	var grid=$('#myGrid1');
	if (id=='btn_checkall'){
		grid.datagrid('checkAll');
		//var rows = grid.datagrid('getSelections');
		var rows = grid.datagrid('getRows');
		for (var i=0;i<rows.length;i++){
		
		}
	}else if (id=='btn_uncheckall'){
		grid.datagrid('uncheckAll');
	}
	
}
	
</script>
    
    
</head>
<body>
<div id='main'>
 	<table id="myGrid1" class="easyui-datagrid"	>
    </table>
    <div id="menu" class="easyui-menu" data-options="onClick: menuHandler" style="width: 30px; display: none;">
		<div id="btn_Delete" data-options="iconCls:'deleteIcon'" onclick="">删除</div>  
		<div class="menu-sep"></div>  
		<div id="btn_Modify" data-options="iconCls:'editIcon'">编辑</div>  
		<div class="menu-sep"></div>  
		<div id="btn_checkall" data-options="iconCls:'checkIcon'">全选</div>  
		<div id="btn_uncheckall" data-options="iconCls:'uncheckIcon'">不选</div>  
 	</div>    
</div>    
</body>
</html>