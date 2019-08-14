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
	<div id="left" class="easyui-panel" data-options="region:'west'" style="width:400px;"></div>
	<div id="container" class="easyui-panel" fit="true" data-options="region:'center'">
		<div id='main' class='easyui-panel' data-options="region:'center'" style="padding: 1px 1px 1px 1px;"></div>
		<div id='bottom' class='easyui-panel' data-options="region:'south'" style="padding: 1px 1px 1px 1px;height:110px;"></div>
	</div>
<script>
	$(function() {
		var pmyGrid1={};
		pmyGrid1.id='myGrid1';
		pmyGrid1.parent='left';
		pmyGrid1.staticsql="select ProductID,ProductName,QuantityPerUnit,Unit,";
		pmyGrid1.staticsql+="quantity,unitprice,amount from products";
		pmyGrid1.activesql=pmyGrid1.staticsql;
		pmyGrid1.searchsql="select ProductID from orderitems";
		pmyGrid1.gridfields='[@c%c#250,2]商品名称/productname;[@c%c#110,2]规格型号/quantityperunit;[%d#90@c]计量单位/unit;[@c#100]数量/quantity;';
		pmyGrid1.gridfields+='[110]单价/unitprice;[110]金额/amount';
		pmyGrid1.fixedfields='[@l%c#90]商品编号/productid';
		pmyGrid1.title=false;
		pmyGrid1.menu='myMenu1';
		pmyGrid1.checkbox='single';
		pmyGrid1.pagesize=10;
		pmyGrid1.keyfield='productid';
		pmyGrid1.rownumbers=true;
		pmyGrid1.collapsible=true;
		pmyGrid1.height=400;
		pmyGrid1.width=0;
		pmyGrid1.rowindex=0;
		//定义grid
		myGrid(pmyGrid1);
		//初始化，显示第一页记录
		myLoadGridData(pmyGrid1,1);
		myGridEvents(myGrid1,'onSelect');
		//myGrid1定义结束*/
		$('#bottom').panel({
			doSize:true,
    		title:'订单明细',
    		iconCls:'panelIcon',
    		tools: [{
				iconCls:'addIcon',
				handler:function(){ fn_add();}
		    },{
				iconCls:'editIcon',
				handler:function(){ fn_edit();}
		    },{
				iconCls:'deleteIcon',
				handler:function(){ fn_delete();}
		    },{
				iconCls:'saveIcon',
				handler:function(){ fn_save();}
		    },{
				iconCls:'refreshIcon',
				handler:function(){ fnRefresh();}
		    }]
		});
		//定义关键字下拉框和查询文本输入框
		var tmp='';  ////从网格中提取列标题作为下拉框选项
		for (var i=0;i<pmyGrid1.columns.length;i++){
			if (tmp!='') tmp+=';';
			tmp+=pmyGrid1.columns[i].title;
		}
		myTextField('productid','container','商品编码:',60,445,10,0,120,'','','');
		myTextField('productname','container','商品名称:',60,445,260,0,200,'','','');
		myTextField('quantityperunit','container','规格型号:',60,445,550,0,200,'','','');
		myTextField('unit','container','计量单位:',60,475,10,0,120,'','','');
		myTextField('quantity','container','数量:',40,475,260,0,120,'','','');
		myTextField('unitprice','container','单价:',40,475,460,0,120,'','','');
		myTextField('amount','container','金额:',40,475,650,0,120,'','','');
		//过滤记录

		
		$('#orderid').textbox({
			buttonIcon:'icon-filter',
			onClickButton: function(e){
				wheresql=fnGenWhereSql('filter');
				var togesql=pmyGrid1.columns[0].field+" in ("+pmyGrid1.searchsql+" ";
				if (wheresql!='') pmyGrid1.activesql='select * from ('+pmyGrid1.staticsql+') as p where '+togesql+wheresql+")";
				else pmyGrid1.activesql=pmyGrid1.staticsql;
				//console.log(pmyGrid1.activesql);
				var opts =$("#myGrid1").datagrid('getPager').data("pagination").options; 
				opts.pageNumber=1;
				pmyGrid1.rowindex=0;
				myLoadGridData(pmyGrid1,1);
				var s="select a.customerid,CustomerName from orders a join Customers b on a.CustomerID=b.CustomerID "+wheresql;
				t=myRunSelectSql('jqdemos', s);
				//console.log($(t));
				$('#customername').textbox("setValue",t[0].customername);
				$('#customerid').textbox("setValue",t[0].customerid);
			}
		});
		//console.log();
		$("#productid").combogrid({
			panelWidth:380,  
		    idField:'productid',
		    textField:'productid',
		    columns:[[
		    {field:'productid',title:'产品编码',width:60},
		    {field:'productname',title:'产品名称',width:100},
		    {field:'quantityperunit',title:'规格型号',width:120},
		    {field:'unit',title:'计量单位',width:100}
		    ]],
		});
		var xsql="select productid,productname,quantityperunit,unit from products";
		$.ajax({
			type:"post",
			url:"system/easyui_getGridData.jsp",
			data:{
				database:'jqdemos',
				selectsql:xsql,
				keyfield:'productid',
				sortfield:''
			},
			async:false,
			success:function(data){
				alert(source);
				eval("var source="+data+";");
				console.log(source);
				$("#productid").combogrid({data:source});
				$("#productid").combogrid("loadData",source);
			}
		})
		function fnGenWhereSql(action){
			var xtext=$('#orderid').textbox("getValue");
			var wheresql='';
			//wheresql+=pmyGrid1.columns[0].field+" in ("+pmyGrid1.searchsql+" ";
			wheresql+="where orderid='"+xtext+"'";
			return wheresql;
		}
		
	//---------------------
	});  //endofjquery
	

	function fn_add() {
        $("#productid").textbox("setValue", '');
        $("#productname").textbox("setValue", '');
        $("#quantityperunit").textbox("setValue", '');
        $("#unit").textbox("setValue", '');
        $("#quantity").textbox("setValue", '');
        $("#unitprice").textbox("setValue", '');
        $("#amount").textbox("setValue", '');
        isAdd = true; //点击了增加所以将isAdd变量值设置为真。
    }

    function fn_edit() {
        isAdd = false; //点击了编辑所以将isAdd变量值设置为假。
        var row = $('#myGrid1').datagrid('getSelected');
        //console.log(row);
        $("#productid").textbox("setValue", row.productid);
        $("#productname").textbox("setValue", row.productname);
        $("#quantityperunit").textbox("setValue", row.quantityperunit);
        $("#unit").textbox("setValue", row.unit);
        $("#quantity").textbox("setValue", row.quantity);
        $("#unitprice").textbox("setValue", row.unitprice);
        $("#amount").textbox("setValue", row.quantity * row.unitprice);
    }

    function fn_save() {
    	var wheresql='';
		wheresql+="orderid='"+pid+"'";
        if (isAdd) {
            var insql = "insert into Products (ProductID,ProductName) values ('" + $("#productid").textbox('getValue') + "',' ')"
            myRunUpdateSql('jqdemos', insql);
            //如果要新增就先新插入一行。之后再用本来的update语句输入内容。
        }
        var sql = "with tmp as (select a.ProductID,a.ProductName,a.QuantityPerUnit,a.Unit,b.Quantity,b.UnitPrice,OrderID from Products a join OrderItems b on a.ProductID=b.ProductID ) update tmp set ";
        sql += "productname='" + $("#productname").textbox('getValue') + "',";
        sql += "quantityperunit='" + $("#quantityperunit").textbox('getValue') + "',";
        sql += "unit='" + $("#unit").textbox('getValue') + "',";
        sql += "quantity='" + $("#quantity").textbox('getValue') + "',";
        sql += "unitprice='" + $("#unitprice").textbox('getValue') + "'";
        sql += " where productid='" + $("#productid").textbox('getValue') + "'";
        sql += " and "+wheresql+"";
        var result = myRunUpdateSql('jqdemos', sql);
        if (result.error == '') {
            fnRefresh();
        }
        isAdd = false; //将变量改回假。
    }

    function fn_delete() { //点击删除。
        var row = $('#myGrid1').datagrid('getSelected'); //获取当前行内容。
        var desql = "delete from Products where ProductID=" + row.productid; //在数据库中删除这行。
        var result = myRunUpdateSql('jqdemos', desql);
        if (result.error == '') {
            fnRefresh(); //如果删除成功就刷新数据网格。
        }

    }
	
	function myGridEvents(id,e){
		e=e.toLowerCase();
		if(e=='onselect')
			{
				var row = $('#myGrid1').datagrid('getSelected');
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