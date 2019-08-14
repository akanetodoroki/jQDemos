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
	<div id="left" class="easyui-panel" data-options="region:'west'" style="width:250px;"></div>
	<div id="container" class="easyui-panel" fit="true" data-options="region:'center'">
		<div id='toolbar' class='easyui-panel' data-options="region:'north'" style="overflow:hidden; background-color: #E0ECFF; height:63px; padding: 1px 1px 1px 10px;"></div>
		<div id='main' class='easyui-panel' data-options="region:'center'" style="padding: 1px 1px 1px 1px;"></div>
		<div id='bottom' class='easyui-panel' data-options="region:'south'" style="padding: 1px 1px 1px 1px;height:110px;width:1000px;"></div>
	</div>
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
		pmyGrid1.height=400;
		pmyGrid1.width=0;
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
		//console.log(tmp);
		//myComboField('searchfield','toolbar','选择关键字:',75,4,10,0,260,tmp,'','checkbox');
		//myTextField('searchtext','toolbar','快速过滤：',65,4,380,0,200,'','');
		//myTextField('locatetext','toolbar','',0,4,644,0,24,'','');
		myTextField('orderid','toolbar','订单编码:',75,4,10,0,200,'','','checkbox');
		myDateField('orderdate','toolbar','订单日期：',65,4,380,0,200,'','');
		myTextField('customerid','toolbar','客户编码：',75,34,10,0,200,'','');
		myTextField('customername','toolbar','客户名称:',65,34,380,0,260,'','','checkbox');
		//myComboField('manager','main','主管员工：',75,340,10,0,200,'','');
		myComboField('productid','container','商品编码:',60,505,10,0,120,'','','');
		myTextField('productname','container','商品名称:',60,505,260,0,200,'','','');
		myTextField('quantityperunit','container','规格型号:',60,505,610,0,200,'','','');
		myTextField('unit','container','计量单位:',60,535,10,0,120,'','','');
		myTextField('quantity','container','数量:',40,535,260,0,120,'','','');
		myTextField('unitprice','container','单价:',40,535,460,0,120,'','','');
		myTextField('amount','container','金额:',60,535,680,0,120,'','','');
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
		    ]]
		    
		});
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
        $("#productid").textbox("setValue", row.productid);
        $("#productname").textbox("setValue", row.productname);
        $("#quantityperunit").textbox("setValue", row.quantityperunit);
        $("#unit").textbox("setValue", row.unit);
        $("#quantity").textbox("setValue", row.quantity);
        $("#unitprice").textbox("setValue", row.unitprice);
        $("#amount").textbox("setValue", row.quantity * row.unitprice);
    }

    function fn_save() {
        if(isAdd){
        	$("#myGrid1").datagrid('appendRow',{
        		productid:$("#productid").textbox("getValue"),
        		productname:$("#productname").textbox("getValue"),
        	});
        }else{
        	var row = $('#myGrid1').datagrid('getSelected');
        	var rowno = $('#myGrid1').datagrid('getRowIndex',row);
        	$("#myGrid1").datagrid('updateRow',{
        		index:rowno,
        		row:{
        			productid:$("#productid").textbox("getValue"),
            		productname:$("#productname").textbox("getValue"),
        		}
        	})
        	
        }
    }

    function fn_delete() { //点击删除。
    	var row = $('#myGrid1').datagrid('getSelected');
    	var rowno = $('#myGrid1').datagrid('getRowIndex',row);
    	var allrow=$("#myGrid1").datagrid('getRows');
    	console.log(allrow.length);
    	$("#myGrid1").datagrid('deleteRow',rowno);
    	if(rowno==allrow.length){
    		$("#myGrid1").datagrid('selectRow',rowno-1);
    	}else{
    		$("#myGrid1").datagrid('selectRow',rowno);
    	}

    }

    function fnRefresh() { //刷新记录
        var pmyGrid1 = {};
        pmyGrid1.id = 'myGrid1';
        pmyGrid1.parent = 'main';
        pmyGrid1.staticsql = "select productid,productname,quantityperunit,unit,";
        pmyGrid1.staticsql += "quantity,unitprice,quantity*unitprice as amount from products";
        pmyGrid1.activesql = pmyGrid1.staticsql;
        pmyGrid1.searchsql = "select ProductID from orderitems";
        pmyGrid1.gridfields = '[@c%c#250,2]商品名称/productname;[@c%c#110,2]规格型号/quantityperunit;[%d#90@c]计量单位/unit;[@c#100]数量/quantity;';
        pmyGrid1.gridfields += '[110]单价/unitprice;[110]金额/amount';
        pmyGrid1.fixedfields = '[@l%c#90]商品编号/productid';
        pmyGrid1.title = false;
        pmyGrid1.menu = 'myMenu1';
        pmyGrid1.checkbox = 'single';
        pmyGrid1.pagesize = 10;
        pmyGrid1.keyfield = 'productid';
        pmyGrid1.rownumbers = true;
        pmyGrid1.collapsible = true;
        pmyGrid1.height = 400;
        pmyGrid1.width = 0;
        pmyGrid1.rowindex = 0;
        //定义grid
        myGrid(pmyGrid1);
        //初始化，显示第一页记录
        myLoadGridData(pmyGrid1, 1);
    }

	
	//左边栏树节点
	$(document).ready(function() {
		myForm('myForm1','left','订单分类',0,0,0,0,'drag');
		$("#myForm1").panel({
			tools: [{
				iconCls:'refreshIcon',
				handler:function(){ fnloadData();}
		    }]
		});
		//定义树控件
		//myDBTree( 'myTree1', 'myForm1', '地区分类11',0,0,0,0,jqsql.area,'areaid',' ',' full');
		var str='<div id="myTree1" class="easyui-tree" style="fit:auto; border: true; padding:5px;"></div>';
		$("#myForm1").append($(str));
		$("#myTree1").tree({
			checkbox: false,
			lines:true
		});
		$.ajax({
			url: "system/easyui_runStoredProcedureforFullTreeNodes.jsp",
			data:{ 
				database:'jqdemos', 
   				sqlprocedure:'ordertree', 
   				paramvalues:''
			},	
   			async: false, method: 'post',    
			success: function(data) {
				var source=eval(data);
				$('#myTree1').tree({ data: source });
			}  
		});
		
		$('#myTree1').tree({  //双击展开或收缩结点
			onDblClick: function(node){
				if (node.state=='closed') $(this).tree('expand', node.target);
				else $(this).tree('collapse', node.target);
			}
		});

		
		/*var roots=$("#myTree1").tree("getRoots");
		$("#myTree1").tree('expand', roots[2].target);
		$("#myTree1").tree('select', roots[2].target);*/
		$("#myTree1").tree({
			onClick: function(node){
				var s1=myGetValue(node.text);
				var s2=getChildren(node.id);
				//console.log(s2);// alert node text property when clicked
			}
		});
		
		function fnloadData(){
			$.ajax({
				url: "system/easyui_runStoredProcedureforFullTreeNodes.jsp",
				data:{ 
					database:'jqdemos', 
	   				sqlprocedure:'ordertree', 
	   				paramvalues:''
				},	
	   			async: false, method: 'post',    
				success: function(data) {
					var source=eval(data);
					$('#myTree1').tree({ data: source });
				}  
			});
		}
		function getChildren(id/*节点ID*/){
		    var $tree = $('#myTree1');
		    var node = $tree.tree('find',id);
		    var childrenNodes = $tree.tree('getChildren',node.target);
		    return childrenNodes;
		}
		$("#myTree1").tree({
			onExpand: function (node){  //点击展开事件
				var pid=node.id;
				var cnodes = $("#myTree1").tree('getChildren', node.target);
				if (cnodes.length==1 && cnodes[0].id=='_'+pid){ //生成子节点
				   	$.ajax({
				   		url: "system/easyui_runStoredProcedureforChildTreeNodes.jsp",
				   		data:{
				   			database:'jqdemos', 
				   			sqlprocedure:'fororderdate', 
				   			paramvalues:pid
				   		}, 
				   		async: false, method: 'post',    
				   		success: function(data) {
				   			eval("source="+data);
							//$("#myTree1").tree('remove', cnodes[0].target); //删除子节点
							$("#myTree1").tree('append', {  //增加数据作为子节点
								parent: node.target,
								data: source 
							});
			   			}     
			   		}); 
				};
			}
		});
		$.ajax({
			url: "system/easyui_runStoredProcedureforChildTreeNodes.jsp",
			data:{
   				database:'jqdemos', 
   				sqlprocedure:'fororderdate', 
   				paramvalues:""
   			},  
			async: false, method: 'post',    
			success: function(data) {
				var source=eval(data);
				$("#tree").tree({ data: source });  //加载json数据到树
			}    
		});
		/*$('#myTree1').tree({
			onSelect: function(node){
				if(node.level==5){
					var xtext=node.text;
					var wheresql='';
					//wheresql+=pmyGrid1.columns[0].field+" in ("+pmyGrid1.searchsql+" ";
					wheresql+="where orderid='"+xtext+"'";
					var togesql=pmyGrid1.columns[0].field+" in ("+pmyGrid1.searchsql+" ";
					if (wheresql!='') pmyGrid1.activesql='select * from ('+pmyGrid1.staticsql+') as p where '+togesql+wheresql+")";
					else pmyGrid1.activesql=pmyGrid1.staticsql;
					//console.log(pmyGrid1.activesql);
					var opts =$("#myGrid1").datagrid('getPager').data("pagination").options; 
					opts.pageNumber=1;
					pmyGrid1.rowindex=0;
					myLoadGridData(pmyGrid1,1);
					
				}
			}
		});*/
		$("#myTree1").tree('collapseAll');
	//---------------------------------------------------//
	}); //endofjquery
	
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
				console.log(row);
			}
	}
</script>
</body>
</html>