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
	<div id='leftlist' class='easyui-panel' data-options="region:'west', split:true" style="overflow:auto; width:250px;"></div>
	<div id='toolbar' class='easyui-panel' data-options="region:'south'" style="overflow:hidden; background-color: #E0ECFF; height:33px; padding: 1px 1px 1px 10px;"></div>
	<div id='main' class='easyui-panel' data-options="region:'center'" style="padding: 1px 1px 1px 1px;"></div>
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
		pmyGrid1.title='产品列表';
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
		//myGrid1定义结束
		$('#bottom').panel({
    		title:'订单明细',
    		iconCls:'panelIcon',
		});
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
		//console.log(tmp);
		//myComboField('searchfield','toolbar','选择关键字:',75,4,10,0,260,tmp,'','checkbox');
		//myTextField('searchtext','toolbar','快速过滤：',65,4,380,0,200,'','');
		//myTextField('locatetext','toolbar','',0,4,644,0,24,'','');
		myTextField('orderid','toolbar','订单编码:',75,4,10,0,200,'','','checkbox');
		myDateField('orderdate','toolbar','订单日期：',65,4,380,0,200,'','');
		myComboField('customerid','toolbar','客户编码：',75,34,10,0,200,'','');
		myTextField('customername','toolbar','客户名称:',65,34,380,0,260,'','','checkbox');
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
				var s="select CustomerName from orders a join Customers b on a.CustomerID=b.CustomerID "+wheresql;
				t=myRunSelectSql('jqdemos', s);
				console.log($(t));
				$('#customername').textbox("setValue",t[0].customername);
			}
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
	
	
	

	function myGridEvents(){
		
		
	}
	$(document).ready(function() {
		var jqsql={};  //sql语句中不能有双引号
		jqsql.product="select rtrim(productid)+' '+rtrim(productname) as 'text',* from products ";
		myForm('myForm1','leftlist','产品分类',0,0,0,0,'drag');
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
			checkbox: true,
			lines:true
		});
		$.ajax({
			url: "system/easyui_getAllTreeNodes.jsp",
			data: { database: sysdatabasestring, selectsql: jqsql.product, keyfield:'productid', sortfield:'' }, 
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



		$("#myTree1").tree('collapseAll');
		/*var roots=$("#myTree1").tree("getRoots");
		$("#myTree1").tree('expand', roots[2].target);
		$("#myTree1").tree('select', roots[2].target);*/
		
		function fnloadData(){
			$.ajax({
				url: "system/easyui_getAllTreeNodes.jsp",
				data: { database: sysdatabasestring, selectsql: jqsql.product, keyfield:'prodcutid', sortfield:'' }, 
				async: false, method: 'post',    
				success: function(data) {
					var source=eval(data);
					$('#myTree1').tree({ data: source });
					$("#myTree1").tree('collapseAll');
					//展开第一个节点下的子节点
				},     
				error: function(err) {     
					console.log(err);     
				}     
			});
		}
		$("#myTree1").tree({
			onSelect:function(i,r){
				console.log(r);
			}
			
		});
	//---------------------------------------------------//
	}); //endofjquery
</script>
</body>
</html>