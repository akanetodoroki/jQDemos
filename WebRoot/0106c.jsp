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
<div id='container' class="easyui-layout" data-options="fit:true" style="margin:0px 0px 0px 0px;">
 	<div id='right' class="easyui-panel" data-options="region:'east'" style="margin:0px 0px 0px 0px;width:400px"></div>
 	<div id='main' class="easyui-panel" data-options="region:'center'" style="margin:0px 0px 0px 0px;"></div>
</div>    
<script>
	$(document).ready(function() {
		sql_products="select productid+' '+productname as text,* from products";
		var xcolumns=[[
			//{ title: '商品编码', field:'productid', width: 120, halign:'center', align: 'left' },
			{ title: '商品名称', field:'productname', width: 240, halign:'center', align: 'left' },
			{ title: '英文名称', field:'englishname', width: 180, halign:'center', align: 'left' },
			{ title: '规格型号', field:'quantityperunit', width: 170, halign:'center', align: 'left' },
			{ title: '计量单位', field:'unit', width: 120, halign:'center', align: 'center' },
			{ title: '单价', field: 'unitprice', width: 75, halign:'center', align: 'right',	formatter: function(value){
				if (value==0) value='';
				else value=(1.0*value).toFixed(2);
				return '<div align="right">' + value+'</div>'; }
			}
		]];
		var str='<table id="myTreeGrid1" class="easyui-treegrid" style="overflow:auto"></table>';
		$("#main").append($(str));
		trGrid=$("#myTreeGrid1");
		myMenu('myMenu1','新增节点/mnadd/addIcon;新增子节点/mnaddsub/addIcon;修改节点/mnedit/editIcon;-;删除/mndelete/deleteIcon;-;刷新/mnrefresh/refreshIcon','');
		trGrid.treegrid({
			title: '&nbsp;商品分类列表',
			iconCls: "panelIcon",
			width:955,
            height:'100%', //282, //'100%',
            collapsible: false,
            singleSelect:true,
            rownumbers: true,
			treeField: 'productid',
            idField: 'id',
			frozenColumns:[[{ title: '商品编码', field:'productid', width: 120, halign:'center', align: 'left' }]],
			columns: xcolumns,
			onContextMenu: function(e, row){  //定义右键
				e.preventDefault();
				trGrid.treegrid("select", row.id); //根据索引选中该行
				$("#myMenu1").menu('show', {
					left: e.pageX,
					top: e.pageY
				});
			}				
		});	
		//定义窗口及其编辑控件
		myForm('myForm1','right','订单分类',0,0,0,0,'drag');;
		myFieldset('myFieldset1','myForm1','商品信息',10,10,250,370);
		//myTextField('parentnode','myFieldset1','父类名称：',70,36*0+20,18,0,310,'','hidden');
		myTextField('productid','myFieldset1','商品编码：',70,36*0+20,18,0,120,'');
		myTextField('productname','myFieldset1','商品名称：',70,36*1+20,18,0,250,'');
		myTextField('englishname','myFieldset1','英文名称：',70,36*2+20,18,0,250,'');
		myTextField('quantityperunit','myFieldset1','规格型号：',70,36*3+20,18,0,250,'');
		myTextField('unit','myFieldset1','计量单位：',70,36*4+20,18,0,130,'');
		myNumberField('unitprice','myFieldset1','单价：',70,36*5+20,18,24,127,12,2,'0');
		myHiddenFields("addoredit;level;parentnodeid;ancester");  //隐藏用作变量		
		 //调用通用函数，实现聚焦时全选文本框
		 mySelectOnFocus();
		////调用通用函数，下列各列实现键盘光标上下移动聚焦
		myKeyDownEvent('productid;productname;englishname;quantityperunit;unit;unitprice');		
		//提取TreeGrid1第一层节点
		var sqlx="select * from ("+sql_products+") as p where parentnodeid=''";  //第一层
		$.ajax({
			url: "system/easyui_getChildNodes.jsp",
			data: { database: sysdatabasestring, selectsql: sqlx, keyfield:'productid', sortfield:''}, 
			async: false, method: 'post',    
			success: function(data) {
				//console.log(data);     
				var source=eval(data);
				trGrid.treegrid({ data: source });  //加载json数据到树
			}    
		});
		//定义myTreeGrid1父节点 点击展开事件
		trGrid.treegrid({
			onBeforeExpand: function (node){  //点击展开事件
				var pid=node.id;
				//var sql=trGrid.attr('xsql');
				var sql=sql_products;
				var sqlx="select * from ("+sql+") as p where parentnodeid='"+pid+"'";
				var child_node = trGrid.treegrid('getChildren', pid);
				if (child_node.length==1 && child_node[0].id=='_'+pid){ //生成子节点
					$.ajax({
						url: "system/easyui_getChildNodes.jsp",
						data: { database: sysdatabasestring, selectsql: sqlx, keyfield:'productid', sortfield:'' }, 
						async: false, method: 'post',    
						success: function(data) {
							var source=eval(data);
							trGrid.treegrid('remove', child_node[0].id); //删除虚拟子节点
							trGrid.treegrid('append', {  //增加数据作为子节点
								parent: pid, //这里不能用node.target,
								data: source 
							});
						}     
					});
				}
			},
			//双击展开或收缩结点事件	
			onDblClickRow: function(row){
				if (row.state=='closed') $(this).treegrid('expand', row.id);
				else $(this).treegrid('collapse', row.id);
			}
		});
		//菜单新增按钮事件
		$('#mnadd').bind('click',function(item){
			$("#addoredit").val('add');
			var records=trGrid.treegrid("getSelections");  //取当前节点
			var pnode=trGrid.treegrid("getParent",records[0].id); //取其父节点
			if (pnode!=null){
				var parentstr=pnode.productid+'-'+pnode.productname;
				$("#myEditWin1").window('setTitle','新增商品【所属类别：'+parentstr+'】');
				trGrid.treegrid('expand',pnode.id);  //展开父节点
				trGrid.treegrid('append',{  //添加一个空的临时子节点
					parent:pnode.id,
					data:[{id:'_'+pnode.id,productid:' '}]
				});
				trGrid.treegrid('select','_'+pnode.id);  //聚焦临时子节点
				$("#parentnodeid").val(pnode.productid);
				$("#level").val(1*pnode.level+1);
				$("#ancester").val(pnode.ancester+pnode.id+"#");
			}else{
				$("#myEditWin1").window('setTitle','新增商品【所属类别：无】');
				trGrid.treegrid('append',{   //在根节点中增加一个兄弟节点，空的临时节点
					parent:null,
					data:[{id:'_x',productid:' '}]
				});
				trGrid.treegrid('select','_x');
				$("#parentnodeid").val("");
				$("#level").val(1);
				$("#ancester").val("");
			}	
			$("#productid").textbox("setValue",'');
			$("#productname").textbox("setValue",'');
			$("#englishname").textbox("setValue",'');
			$("#quantityperunit").textbox("setValue",'');
			$("#unit").textbox("setValue",'');
			$("#unitprice").textbox("setValue",'');
			$("#picture").attr('src','');
			$("#productid").textbox("readonly",false);  //设置主键可编辑
			$('#myEditWin1').window('open');		
		});
		//增加子节点
		$('#mnaddsub').bind('click',function(item){
			$("#addoredit").val('addsub');
			var records=trGrid.treegrid("getSelections");
			var pnode=records[0];
			var parentstr=pnode.productid+'-'+pnode.productname;
			$("#myEditWin1").window('setTitle','新增商品【所属类别：'+parentstr+'】');
			trGrid.treegrid('expand',pnode.id);
			trGrid.treegrid('append',{
				parent:pnode.id,
				data:[{id:'_'+pnode.id,productid:' '}]
			});
			trGrid.treegrid('select','_'+pnode.id);
			$("#parentnodeid").val(pnode.productid);
			$("#level").val(1*pnode.level+1);
			$("#ancester").val(pnode.ancester+pnode.id+"#");
			$("#productid").textbox("setValue","");
			$("#productname").textbox("setValue","");
			$("#englishname").textbox("setValue","");
			$("#quantityperunit").textbox("setValue","");
			$("#unit").textbox("setValue","");
			$("#unitprice").textbox("setValue","");
			$("#picture").attr('src','');
			$("#productid").textbox("readonly",false);  //设置主键可编辑
			$('#myEditWin1').window('open');		
		});
		//修改节点eeeeee
		$('#mnedit').bind('click',function(item){
			$("#addoredit").val('edit');
			var records=trGrid.treegrid("getSelections");
			if (records.length>0){
				var pnode=trGrid.treegrid("getParent",records[0].id); //取其父节点
				if (pnode!=null){
					var parentstr=pnode.productid+'-'+pnode.productname;
					$("#myEditWin1").window('setTitle','修改商品【所属类别：'+parentstr+'】');
				}else{
					$("#myEditWin1").window('setTitle','修改商品【所属类别：无】');
				}
				$("#parentnodeid").val(records[0].parentnodeid);
				$("#level").val(records[0].level);
				$("#ancester").val(records[0].ancester);
				$("#productid").textbox("setValue",records[0].productid);
				$("#productname").textbox("setValue",records[0].productname);
				$("#englishname").textbox("setValue",records[0].englishname);
				$("#quantityperunit").textbox("setValue",records[0].quantityperunit);
				$("#unit").textbox("setValue",records[0].unit);
				$("#unitprice").textbox("setValue",records[0].unitprice);
				$("#productid").textbox("readonly",true);  //设置主键只读
				var src='mybase/products/'+records[0].productid+'.jpg';
				$("#picture").attr('src',src);
				myResizeImage('picture',src,231,198);
				//alert(src);
				$("#myEditWin1").window("open");
			}			
		});

		//删除节点及其子节点dddddd
		$('#mndelete').bind('click',function(item){
			var records=trGrid.treegrid("getSelections");
			if (records.length>0){
				if (records[0].isparentflag==0){
					var msg='&nbsp;是否确定删除商品【'+records[0].productid+'】？';
				}else{
					var msg='&nbsp;是否确定删除商品大类【'+records[0].productid+'】？';
				}
				$.messager.confirm('系统提示', msg, function(r){
					if (r){
						errmsg=[];
						var pnode=trGrid.treegrid('getParent',records[0].id);  //求出父节点
						var sql="delete products where productid='"+records[0].productid+"'";
						sql+=" or ancester like '"+records[0].productid+"#%'";
						var result=myRunUpdateSql(sysdatabasestring, sql); //执行删除
						if (result.error!='') errmsg.push(result.error);
						//判断删除之后原来的父节点还有没有子节点，如果没有则将其isparentflag设置为0
						if (pnode!=null){
							sql="update products set isparentflag=0 where productid='"+pnode.productid+"'";
							sql+=" and not exists(select 1 from products where parentnodeid='"+pnode.productid+"')";
							console.log(sql);
							var result=myRunUpdateSql(sysdatabasestring, sql); //执行删除
							if (result.error!='') errmsg.push(result.error);
							console.log(result.error+'---error');
						}
						if (errmsg.length>0) myMessageBox('系统提示','记录删除失败！',errmsg);
						else{
							//删除之后将光标聚焦到兄弟节点，没有兄弟节点时，聚焦到父节点
							var pnode=trGrid.treegrid('getParent',records[0].id);  //求出父节点
							if (pnode!=null) var children=trGrid.treegrid('getChildren',pnode.id);  //求出子节点
							else var children=trGrid.treegrid('getRoots');  //求出子节点,即为所有根节点
							var priorbrother=null;
							var nextbrother=null;
							for (var i=0;i<children.length;i++){
								if (children[i].id==records[0].id) break;
							}
							if (i<children.length-1) nextbrother=children[i+1];
							if (i>0) priorbrother=children[i-1];
							trGrid.treegrid("remove",records[0].id);  //删除节点
							if (nextbrother!=null) trGrid.treegrid('select',nextbrother.id);  //定位到下一个兄弟节点
							else if (priorbrother!=null) trGrid.treegrid('select',priorbrother.id); //定位到上一个兄弟节点
							else if (pnode!=null) trGrid.treegrid('select',pnode.id);  //定位到父节点
							if (pnode!=null && children.length==1) {
								trGrid.treegrid('update',{
									id:pnode.id,
									row: {"isparentflag":"0"}
								});							
							}
						}
					}
				});
			}else{
				$.messager.confirm('系统提示','不存在记录，删除失败！');
			}
		});
		//设计保存按钮事件ssssssave
		$('#fnsave').bind('click',function(item){
			var errmsg=[];
			var addoredit=$("#addoredit").val();
			var records=trGrid.treegrid("getSelections");
			var node=records[0];
			var pnode=trGrid.treegrid("getParent",node.id);
			var s1=$("#productid").textbox('getValue');
			var s2=$("#productname").textbox('getValue');
			var s3=$("#englishname").textbox('getValue');
			var s4=$("#quantityperunit").textbox('getValue');
			var s5=$("#unit").textbox('getValue');
			var s6=$("#unitprice").textbox('getValue');
			if (s6=='') s6='0';  //输错时值为空,不必iaNaN判断
			var s01=$("#parentnodeid").val();
			var s02=$("#level").val();
			var s03=$("#ancester").val();
			if (addoredit=='edit'){  //修改记录
				var sql="update products set productname='"+s2+"',";
				sql+="englishname='"+s3+"',";
				sql+="quantityperunit='"+s4+"',";
				sql+="unit='"+s5+"',";
				sql+="unitprice="+s6;
				sql+=" where productid='"+s1+"'";
			}else{	//新增记录
				var sql="insert into products (productid,productname,englishname,quantityperunit,unit,unitprice,parentnodeid,isparentflag,level,ancester)";
				sql+="values('"+s1+"','"+s2+"','"+s3+"','"+s4+"','"+s5+"','"+s6+"','"+s01+"',0,"+s02+",'"+s03+"')";
				//设置父节点的isparentflag=1
				if (pnode!=null) sql+="\n update products set isparentflag=1 where productid='"+pnode.productid+"'";
			}
			console.log(sql);
			var result=myRunUpdateSql(sysdatabasestring, sql); //执行删除
			if (result.error!=''){
				errmsg.push(result.error);
				myMessagebox('系统提示','记录保存失败！',errmsg);
			}else{  //修改或插入成功之后更新节点
				$("#parentnodeid").val(s01);
				$("#level").val(s02);
				$("#ancester").val(s03);
				var xid=records[0].id;
				var data={'id':s1,
					'productid':s1,
					'productname':s2,
					'englishname':s3,
					'quantityperunit':s4,
					'unit':s5,
					'unitprice':s6,
					'parentnodeid':s01,
					'level':s02,
					'ancester':s03,
					'isparentflag':'0'
				};
				trGrid.treegrid('update',{id:xid, row:data}); //修改更新当前节点
				//修改树中节点之后关闭窗口
				$('#myEditWin1').window('close'); 	
			}
		}); //保存结束
		//设计关闭窗口按钮事件
		$('#myEditWin1CancelBtn').bind('click',function(item){
			$('#myEditWin1').window('close');	
		});
		//定义窗口关闭事件
		$("#myEditWin1").window({
			//如果在窗口编辑商品信息时用户选择“取消”，则关闭窗口，并将空节点删除。
			onClose:function(){
				var records=trGrid.treegrid("getSelections");
				var records=trGrid.treegrid("getSelections");
				if (records.length>0 && records[0].productid.trim()==''){
					var pnode=trGrid.treegrid('getParent',records[0].id);
					if (pnode==null) pnode=trGrid.treegrid('getRoot');
					trGrid.treegrid('remove',records[0].id);
					if (pnode!=null) trGrid.treegrid('select',pnode.id);
				}
			}		
		});	
		//函数全部结束，设置初值，一开始窗口是关闭的。
		$('#myEditWin1').window('close');	
	//---------------------endofjquery
	});
	function fnPictureupLoad(e,id){
		var targetname=$("#productid").textbox('getValue');
		var result=myFileupLoad('filename','mybase/products/',targetname);
		var src=result.targetpath+result.targetfile+'?timestemp='+new Date().getTime();
		$("#picture").attr('src',src);
		myResizeImage('picture',src,231,198);		
	}
		
	$.fn.treegrid.defaults.loadFilter = function(data, parentId){
		var opts = $.data(this, 'treegrid').options;
		if (!opts.columns){
			var dgOpts = $.data(this, 'datagrid').options;
			opts.columns = dgOpts.columns;
			opts.frozenColumns = dgOpts.columns;
		}
		return data;
	};
	function myGridEvents(id,e){
		e=e.toLowerCase();
		if(e=='onselect')
			{
				var row = $('#myTreeGrid1').datagrid('getSelected');
				$("#productid").textbox("setValue",row.productid);
				$("#productname").textbox("setValue",row.productname);
				$("#englishname").textbox("setValue",row.englishname);
				$("#quantityperunit").textbox("setValue",row.quantityperunit);
				$("#unit").textbox("setValue",row.unit);
				$("#unitprice").textbox("setValue",row.unitprice);
			}
	}
</script>
</body>
</html>