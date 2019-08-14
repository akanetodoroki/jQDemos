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
	<div id='main' class='easyui-panel' data-options="region:'center'" style="padding: 1px 1px 1px 1px;"></div>
	<div id='bottom' class='easyui-panel' data-options="region:'east'" style="padding: 1px 1px 1px 1px;width:430px"></div>
<script>
	
	$(function() {
		var pmyGrid1={};
		pmyGrid1.id='myGrid1';
		pmyGrid1.parent='main';
		pmyGrid1.staticsql="select productid,productname,quantityperunit,unit,";
		pmyGrid1.staticsql+="quantity,unitprice,quantity*unitprice as amount from products";
		pmyGrid1.activesql=pmyGrid1.staticsql;
		pmyGrid1.searchsql="select ProductID from orderitems";
		pmyGrid1.gridfields='[@c%c#250,2]商品名称/productname;[@c%c#110,2]规格型号/quantityperunit;[%d#90@c]计量单位/unit;[@c#100]数量/quantity;';
		pmyGrid1.gridfields+='[110]单价/unitprice;[110]金额/amount';
		pmyGrid1.fixedfields='[@l%c#90]商品编号/productid';
		pmyGrid1.title=false;
		pmyGrid1.menu='myMenu1';
		pmyGrid1.checkbox='single';
		pmyGrid1.pagesize=100;
		pmyGrid1.keyfield='productid';
		pmyGrid1.rownumbers=true;
		pmyGrid1.collapsible=true;
		pmyGrid1.height=0;
		pmyGrid1.width=930;
		pmyGrid1.rowindex=0;
		//定义grid
		myGrid(pmyGrid1);
		//初始化，显示第一页记录
		myLoadGridData(pmyGrid1,1);
		myGridEvents(myGrid1,'onSelect');
		//myGrid1定义结束
		$('#bottom').panel({
			doSize:true,
    		title:'订单明细',
    		iconCls:'panelIcon',
    		tools: [{
				iconCls:'addIcon',
				handler:function(){ fn_add();}
		    },{
				iconCls:'deleteIcon',
				handler:function(){ fn_delete();}
		    },{
				iconCls:'saveIcon',
				handler:function(){ fn_save();}
		    },{
				iconCls:'returnIcon',
				handler:function(){ fnRefresh();}
		    }]
		});
		//var str='<select class="easyui-combogrid" id="productid"></select>';
		//$("#bottom").append($(str));
		myTextField('productid','bottom','商品编码:',60,34,10,0,120,'','','');
		myTextField('productname','bottom','商品名称:',60,64,10,0,200,'','','');
		myTextField('quantityperunit','bottom','规格型号:',60,94,10,0,200,'','','');
		myTextField('unit','bottom','计量单位:',60,124,10,0,120,'','','');
		myTextField('quantity','bottom','数量:',60,154,10,0,120,'','','');
		myTextField('unitprice','bottom','单价:',60,184,10,0,120,'','','');
		myTextField('amount','bottom','金额:',60,214,10,0,120,'','','');
		//定义关键字下拉框和查询文本输入框
		var tmp='';  ////从网格中提取列标题作为下拉框选项
		for (var i=0;i<pmyGrid1.columns.length;i++){
			if (tmp!='') tmp+=';';
			tmp+=pmyGrid1.columns[i].title;
		}

	
		$.ajax({     
			type: "Post",     
			url: "system/easyui_execSelect.jsp",     
			//contentType: "application/json; charset=utf-8",     
			//dataType: "json", 
			data: {
				database: 'jqdemos', 
				selectsql: "select productid,productname,quantityperunit,unit from products"				
			}, 
			async: false, method: 'post',    
			success: function(data) {

				var source=eval(data);
				$("#productid").combogrid({
					panelWidth:380,  
				    idField:'productid',
				    textField:'productid',
				    data:source,
				    columns:[[
					{field:'productid',title:'产品编码',width:30},
				    {field:'productname',title:'产品名称',width:210},
				    {field:'quantityperunit',title:'规格型号',width:70},
				    {field:'unit',title:'计量单位',width:50}
				    ]]
				    
				});
			}    
		});


	//---------------------
	});  //endofjquery

	function fn_add(){
		$("#productid").textbox("setValue",'');
		$("#productname").textbox("setValue",'');
		$("#quantityperunit").textbox("setValue",'');
		$("#unit").textbox("setValue",'');
		$("#quantity").textbox("setValue",'');
		$("#unitprice").textbox("setValue",'');
		$("#amount").textbox("setValue",'');
	}	
	
	function fn_delete(){
		var row = $('#myGrid1').datagrid('getSelected');
		var rowno = $('#myGrid1').datagrid('getRowIndex',row);
		var sql="delete from products where ";
		sql+="productid='"+$("#productid").textbox('getValue')+"'";
		var result=myRunUpdateSql('jqdemos',sql);
			if (result.error==''){
				
			};
		$('#myGrid1').datagrid('deleteRow',rowno);
	}	
	
	
	function fn_save(){
		var row = $('#myGrid1').datagrid('getSelected');
		var rowno = $('#myGrid1').datagrid('getRowIndex',row);
		var productname=$("#productname").textbox('getValue');
		var qt=$("#quantityperunit").textbox('getValue');
		var unit=$("#unit").textbox('getValue');
		var quantity=$("#quantity").textbox('getValue');
		var unitprice=$("#unitprice").textbox('getValue');
	    var amount=$("#unitprice").textbox('getValue')*$("#quantity").textbox('getValue');
		var sql="update products set ";
		sql+="productname='"+$("#productname").textbox('getValue')+"',";
		sql+="quantityperunit='"+$("#quantityperunit").textbox('getValue')+"',";
		sql+="unit='"+$("#unit").textbox('getValue')+"',";
		sql+="quantity='"+$("#quantity").textbox('getValue')+"',";
		sql+="unitprice='"+$("#unitprice").textbox('getValue')+"'";
		sql+=" where productid='"+$("#productid").textbox('getValue')+"'";	
		var result=myRunUpdateSql('jqdemos',sql);
			if (result.error==''){
				
			};
		$("#productid").textbox("setValue",'');
		$("#productname").textbox("setValue",'');
		$("#quantityperunit").textbox("setValue",'');
		$("#unit").textbox("setValue",'');
		$("#quantity").textbox("setValue",'');
		$("#unitprice").textbox("setValue",'');
		$("#amount").textbox("setValue",'');
		$('#myGrid1').datagrid('updateRow',{
			index: rowno,
			row: {
				productname:productname,
				quantityperunit: qt,
				unit: unit,
				quantity: quantity,
				unitprice: unitprice,
				amount: amount
			}
		});
	}
	function fnRefresh(){  //刷新记录
		document.location = "indexx.jsp";	
    }
	
	function myGridEvents(id,e){
		e=e.toLowerCase();
		if(e=='onselect')
			{
				var row = $('#myGrid1').datagrid('getSelected');
				var opts = $('#myGrid1').datagrid('getRowIndex',row);
				console.log($(opts));
				$("#productid").textbox("setValue",row.productid);
				$("#productname").textbox("setValue",row.productname);
				$("#quantityperunit").textbox("setValue",row.quantityperunit);
				$("#unit").textbox("setValue",row.unit);
				$("#quantity").textbox("setValue",row.quantity);
				$("#unitprice").textbox("setValue",row.unitprice);
				$("#amount").textbox("setValue",row.quantity*row.unitprice);
			}
	}
</script>
</body>
</html>