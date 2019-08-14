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
<div id='main' class="easyui-layout" data-options="fit:'true'">
	<div id="left" class="easyui-panel" data-options="region:'west'" style="overflow:auto;width:400px;">
		<div id="tree" class="easyui-tree" style="width:370px;height:800px;padding:5px;"></div>
	</div>
	
	<div id="right" class="easyui-panel" data-options="region:'center'" style="overflow:hidden;">
	 	
	 	<div id='right_layout' class="easyui-layout" data-options="fit:'true'">
		 	<div id="right_top" class="easyui-panel" data-options="region:'north'" style="overflow:hidden;height:140px;"></div>
		 	
		 	<div id="right_center" class="easyui-panel" data-options="region:'center'" style="overflow:hidden;">
		 		<div id="grid" class="easyui-datagrid" ></div>
		 	</div>
		 	
		 	<div id="right_bottom" class="easyui-panel" data-options="region:'south'" style="overflow:hidden;height:280px;"></div>
		</div>
	
	</div>
</div>

<div id="win" class="easyui-window" title="商品信息" style="position:relative;width:930px;height:735px;">
	<div id="product_grid" class="easyui-datagrid"></div>
</div>
    
<script>	
	index=0;
	what='save';
	$(document).ready(function() {
		$("#tree").tree({
			checkbox:false,
			lines:true
		});
		
		$("#tree").tree({  
			onBeforeExpand: function(node){
				var pid=node.id;
				console.log(node.id);
				var cnodes = $("#tree").tree('getChildren', node.target);
				if (cnodes.length==0){ //生成子节点
					$.ajax({
						url: "system/easyui_runStoredProcedureforChildTreeNodes.jsp",
						data:{
			   				database:'jqdemos', 
			   				sqlprocedure:'fororderdate', 
			   				paramvalues:node.id
			   			},  
						async: false, method: 'post',    
						success: function(data) {
							var source=eval(data);
							$("#tree").tree('append',{
								parent:node.target,
								data:source
							});
						}    
					});
				}
				
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

		$("#tree").tree({  
			onDblClick: function(node){
				index:0;
				if(node.id.length<11){
					if (node.state=='closed') $(this).tree('expand', node.target);
					else $(this).tree('collapse', node.target);
				}
				else{
					$("#orderid").textbox('setValue',node.text.substring(4,15));
					//$("#orderid").textbox('setValue',node.text);
				}
			}
		});
		
		
		myTextField('orderid','right_top','订单编号：',80,20,10,30,200);
		myTextField('customerid','right_top','客户编码：',80,80,10,30,200);
		myTextField('customername','right_top','客户名称：',80,80,400,30,200);
		myDateField('orderdata','right_top','订单日期：',80,20,400,30,200);
		
		myTextField('productid','right_bottom','商品编码：',80,20,10,30,200);
		myTextField('productname','right_bottom','商品名称：',80,80,10,30,300);
		myTextField('quantityperunit','right_bottom','规格型号：',80,140,10,30,300);
		myTextField('unit','right_bottom','计量单位：',80,200,10,30,200);
		myNumberField('quantity','right_bottom','数量：',60,20,400,30,200);
		myNumberField('unitprice','right_bottom','单价：',60,80,400,30,200,'',2);
		myNumberField('amount','right_bottom','金额：',60,140,400,30,200,'',2);
		
		myButton('insert','right_bottom','&nbsp;增加',200,400,35,80,'addIcon','','insert');
		myButton('updata','right_bottom','&nbsp;保存',200,490,35,80,'editIcon','','save');
		myButton('delete','right_bottom','&nbsp;删除',200,580,35,80,'deleteIcon','','deleted');
		myButton('find','right_bottom','&nbsp;',20,294,30,35,'searchIcon','','find');
		
		$('#productid').textbox('textbox').attr('readonly',true);  //设置输入框为禁用
		$('#productname').textbox('textbox').attr('readonly',true);  //设置输入框为禁用
		$('#quantityperunit').textbox('textbox').attr('readonly',true);  //设置输入框为禁用
		$('#unit').textbox('textbox').attr('readonly',true);  //设置输入框为禁用
		
		var xcolumns=[[
		   			{ title: '商品名称', field:'productname', width: 300, halign:'center', align: 'center' },
		   			{ title: '规格型号', field: 'quantityperunit', width: 150, halign:'center', align: 'center'},
		   			{ title: '计量单位', field: 'unit', width: 100, halign:'center', align: 'center' },
		   			{ title: '数量', field: 'quantity', width: 100, halign:'center', align: 'right' },
		   			{ title: '单价', field: 'unitprice', width: 100, halign:'center', align: 'right' },
		   			{ title: '金额', field: 'amount', width: 100, halign:'center', align: 'right' }
		   		]];
		var xfixedcolumns=[[{ title: '商品编码', field:'productid', width: 200, halign:'center', align: 'center' }]];

		$("#orderid").combogrid({
			/*title: '&nbsp;订单列表',
			iconCls: "panelIcon",*/
			panelWidth:800,
			panelHeight:120,
			idField:'orderid',
			textFiedl:'orderid',
			nowrap: true,
            pagePosition: 'bottom',  
            autoRowHeight: false,
            rownumbers: true,
			pagination: true,
			pageSize: 10,
			pageNumber:1,
            striped: true,
            collapsible: true,
			singleSelect: true, 
			columns:[[
			           {field:'orderid',title:'订单编号',width:60},
			           {field:'orderdate',title:'订单日期',width:100},
			           {field:'customerid',title:'客户编码',width:120},
			           {field:'employeeid',title:'员工编码',width:100}
			           ]],
			data:[{orderid:'',orderdate:'',customerid:'',employeeid:''}],
		});
		
		/*var pg = $("#orderid").datagrid("getPager");  
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
				var opts = $('#orderid').datagrid('options');
				opts.pageSize=pageSize;				
				fnLoadGridData(1,pageSize);  
			},  
			onSelectPage:function(pageNumber,pageSize){  
				var opts = $('#orderid').datagrid('options');
				opts.pageNumber=pageNumber;
				opts.pageSize=pageSize;				
				fnLoadGridData(pageNumber,pageSize);  
			}  
		}); 		  
		//初始化，显示第一页记录
		var opts = $("#orderid").datagrid('options');
		fnLoadGridData(1,opts.pageSize);*/

		
		$("#orderid").textbox({
			onChange:function(newValue,oldValue){
					$.ajax({     
						type: "Post",     
						url: "system/easyui_runStoredProcedureforChildTreeNodes.jsp",     
						data: {
							database:'jqdemos', 
							sqlprocedure:'fororder',
							paramvalues:newValue,
						}, 
						async: false, method: 'post',    
						success: function(data) {   
							data="{total:50,rows:"+data+"}";
							eval("var sourse="+data);
							$("#orderdata").datebox('setValue',sourse.rows[0].orderdate);
							$("#customerid").textbox('setValue',sourse.rows[0].customerid);
							$("#grid").datagrid("loadData", sourse ); 
							$("#grid").datagrid("selectRow",index);
						} 
					}); 
			}
		});
		
		
		
		
		
		$("#customerid").textbox({
			onChange:function(newValue,oldValue){
				$.ajax({     
					type: "Post",     
					url: "system/easyui_runStoredProcedureforChildTreeNodes.jsp",     
					data: {
						database:'jqdemos', 
						sqlprocedure:'forname',
						paramvalues:newValue,
					}, 
					async: false, method: 'post',    
					success: function(data) {   
						eval("var sourse="+data);
						$("#customername").textbox('setValue',sourse[0].customername);
					} 
				}); 
				
			}
		});
		
		$("#quantity").numberbox({
			onChange:function(newValue,oldValue){
				$("#amount").numberbox('setValue',newValue*$("#unitprice").numberbox('getValue'));
			}
		});
		
		$("#unitprice").numberbox({
			onChange:function(newValue,oldValue){	
				$("#amount").numberbox('setValue',newValue*$("#quantity").numberbox('getValue'));
			}
		});
		
		
		$("#grid").datagrid({
			title: '&nbsp;订单详情',
			iconCls: "panelIcon",
			width:1082,
            height:455,
			nowrap: true,

            autoRowHeight: true,
            rownumbers: true,

			pageSize: 10,
			pageNumber:1,
            striped: true,
            collapsible: true,
			singleSelect: true, 
            buttons: [{
				iconCls:'addIcon',
				handler:function(){alert('add')}
				},'-',{
					iconCls:'saveIcon',
					handler:function(){alert('save')}
				}],
				toolbar: [{
					iconCls: 'icon-edit',
					handler: function(){alert('edit')}
				},'-',{
					iconCls: 'icon-help',
					handler: function(){alert('help')}
				}],
			columns: xcolumns,
            frozenColumns: xfixedcolumns
		});	
		
		$("#grid").datagrid({
			onSelect:function(rowIndex,rowData){
				index=rowIndex;
				$("#productid").textbox('setValue',rowData.productid);
				$("#productname").textbox('setValue',rowData.productname);
				$("#quantityperunit").textbox('setValue',rowData.quantityperunit);
				$("#unit").textbox('setValue',rowData.unit);
				$("#quantity").numberbox('setValue',rowData.quantity);
				$("#unitprice").numberbox('setValue',rowData.unitprice);
			}
		});	
		
		var product_columns=[[
		      				{ title: '商品编码', field:'productid', width: 200, halign:'center', align: 'center' },
		      	   			{ title: '商品名称', field:'productname', width: 300, halign:'center', align: 'center' },
		      	   			{ title: '规格型号', field: 'quantityperunit', width: 150, halign:'center', align: 'center'},
		      	   			{ title: '计量单位', field: 'unit', width: 100, halign:'center', align: 'center' },
		      	   			{ title: '单价', field: 'unitprice', width: 100, halign:'center', align: 'right' },
		      	   		]];
	
		
		$("#product_grid").datagrid({
			title: '&nbsp;商品列表',
			iconCls: "panelIcon",
			width:900,
            height:680,
			nowrap: true,
            autoRowHeight: true,
            rownumbers: true,
			pageSize: 10,
			pageNumber:1,
            striped: true,
            collapsible: true,
			singleSelect: true, 
			columns:product_columns,
			pagination:true,
			pagePosition:'bottom'
		});	
		
		$.ajax({     
			type: "Post",     
			url: "system/procedure.jsp",     
			data: {
				database:'jqdemos', 
				sqlprocedure:'forproducts',
				paramvalues:''
			}, 
			async: false, method: 'post',    
			success: function(data) {   
				data="{total:100,rows:"+data+"}";
				
				eval("sourse="+data);
				$("#product_grid").datagrid("loadData", sourse ); 
			} 
		});
		
		$("#product_grid").datagrid({
			onDblClickRow:function(rowIndex,rowData){
				$("#productid").textbox('setValue',rowData.productid);
				$("#productname").textbox('setValue',rowData.productname);
				$("#quantityperunit").textbox('setValue',rowData.quantityperunit);
				$("#unit").textbox('setValue',rowData.unit);
				$("#unitprice").numberbox('setValue',rowData.unitprice);
				$("#win").window('close');
			}
		});	
		$("#win").window('close');
	});
	
	function insert(){
		what='insert';
		$("#productid").textbox('setValue','');
		$("#productname").textbox('setValue','');
		$("#quantityperunit").textbox('setValue','');
		$("#unit").textbox('setValue','');
		$("#quantity").numberbox('setValue','');
		$("#unitprice").numberbox('setValue','');
	};
	
	function save(){
		var id=$("#productid").textbox('getValue');
		var name=$("#productname").textbox('getValue');
		var quantityperunit=$("#quantityperunit").textbox('getValue');
		var unit=$("#unit").textbox('getValue');
		var quantity=$("#quantity").numberbox('getValue');
		var unitprice=$("#unitprice").numberbox('getValue');
		var amount=$("#amount").numberbox('getValue');
		
		if(id==''||name==''||quantity<=0||unitprice<=0)
			$.messager.alert('系统提示','请验证数据!编码，名称不能为空；数量，单价为正！','error');
		else{
				if(what=='save'){
					$("#grid").datagrid('updateRow',{
						index:index,
						row:{
							productid: id,
							productname:name ,
							quantityperunit:quantityperunit,
							unit:unit,
							quantity:quantity,
							unitprice:unitprice,
							amount:amount}
					});
				}
				else if(what=='insert'){
					$("#grid").datagrid('appendRow',{
						productid: id,
						productname:name ,
						quantityperunit:quantityperunit,
						unit:unit,
						quantity:quantity,
						unitprice:unitprice,
						amount:amount
					});
				}
			}
		what='save';	
	};
	
	function deleted(){
		$("#grid").datagrid('deleteRow',index);	
		var p=$("#grid").datagrid('getData');
		if(index+1<p.rows.length)
			$("#grid").datagrid('selectRow',index);	
		else
			$("#grid").datagrid('selectRow',p.rows.length-1);	
	};
	
	function find(){
		$("#win").window('open');
	};
	
	function fnLoadGridData(pageNumber,pageSize){
		var pager =$("#orderid").datagrid('getPager');
		pager.pagination('refresh',{	// 改变选项，并刷新分页栏信息
			pageNumber: pageNumber
		});
		var opts =$("#orderid").datagrid('getPager').data("pagination").options; 
		opts.pageNumber=pageNumber;
		var pageSize=opts.pageSize;
		$.ajax({     
			type: "Post",     
			url: "system/easyui_runStoredProcedureforGrid.jsp",     
			//contentType: "application/json; charset=utf-8",     
			//dataType: "json", 
			data: {
				database:'jqdemos', 
				sqlprocedure:'fororderid',
				paramvalues:'A',
				start:(pageNumber-1)*pageSize+1,
				limit:pageSize
			}, 
			async: false, method: 'post',    
			success: function(data) {   
				eval("source="+data);
				$("#orderid").datagrid("reload");  //放在loaddata之前，触发onBeforeLoad事件
				$("#orderid").datagrid("loadData", source );  //必须用loaddata
				//根据总行数改变行号的列宽度，改css
				var rowcount=$("#orderid").datagrid('getData').total+'';  //转换为字符型
				var width=(rowcount.length*6+8);
				if (width<25) width=25;
				var px=width+'px';
				$('.datagrid-header-rownumber,.datagrid-cell-rownumber').css({"width": px});
				$("#orderid").datagrid('resize');  //必须写
				$("#orderid").datagrid('selectRow',0); //选中第一行
			} 
		}); 
	}
	

	
</script>
</body>
</html>