<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<!doctype html>
<html lang="en">
<style type="text/css">
	.bg { background-color:red }
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
<body style="margin: 1px 1px 1px 1px;">
<form id='main' class="easyui-layout" data-options="fit:true" style="margin:0px 0px 0px 0px;">
	<div id="myMenu1" class="easyui-menu" data-options="onClick: fn_myMenu1Click" style="width: auto;"></div>
	<div id='toolbar' class='easyui-panel' data-options="region:'north'" style="overflow:hidden; background-color: #E0ECFF; height:30px; padding: 1px 1px 1px 10px;">
		<a href="#" class="btn-separator"></a>
		<a href="#" id='btnadd' xtype="menu" class="easyui-menubutton" data-options="menu:'#btnadd_mm1',iconCls:'addIcon'">新增</a>
		<a href="#" id="btnedit" xtype="button" class="easyui-linkbutton" data-options="iconCls:'editIcon', plain: true" style="">修改</a>
		<a href="#" class="btn-separator"></a>
		<a href="#" id="btndelete" xtype="button" class="easyui-linkbutton" data-options="iconCls:'deleteIcon', plain: true" style="">删除</a>
		<a href="#" class="btn-separator"></a>
		<a href="#" id="btnsave" xtype="button" class="easyui-linkbutton" data-options="iconCls:'saveIcon', plain: true" style="">保存</a>
		<a href="#" class="btn-separator"></a>
		<a href="#" id="btnrefresh" xtype="button" class="easyui-linkbutton" data-options="iconCls:'resetIcon', plain: true" style="">刷新</a>
		<a href="#" xtype="button" class="easyui-menubutton" data-options="">Help</a>
	</div>
	<div id="btnadd_mm1" style="width:150px;">
		<div id="btnaddnode" xtype="button" data-options="iconCls:'icon-undo'">增加结点</div>
		<div id="btnaddsubnode" xtype="button" data-options="iconCls:'icon-redo'">增加子节点</div>
	</div>
	<div id='left' data-options="region:'west',split:true, title:'tree'" style="width:300px;height:400px;"></div>
	<div id='right' data-options="region:'center'" style="padding: 2px  0px  0px  2px; "></div>
</form>    
<script>
	$(document).ready(function() {
		rowheight=systext.rowheight+4;
		curnode=null;  //记录新增的临时结点
		keyfield='categoryid';
		keyvalue='';
		keyspec='资源分类编码';
		tablename='resourcecategories';
		nodefields="categoryid;categoryname";
		//$("#toolbar").//panel({title:' ', height:28});
		jqsql={};  //sql语句中不能有双引号
		jqsql.category="select rtrim(categoryID)+' '+rtrim(categoryname) as 'text',* from ResourceCategories";
		jqsql.account="select accountid+' '+accountname as 'text',* from Accounts";
		//myTabForm('myTab','right','资源分类编辑','基本信息;辅助信息',2,2,0,425,'');
		//var px=sysGetWinSize();
		//$("#layout").layout({ height: (sysGetWinSize()).h-4 });
		myForm('myForm','right','资源分类编辑',0,0,0,480,'');
		myTextField('categoryid','myForm','分类编码：',65,rowheight*0+20,12,0,120,'');
		myTextField('categoryname','myForm','分类名称：',65,rowheight*1+20,12,0,380,'','');
		myTextField('englishname','myForm','英文名称：',65,rowheight*2+20,12,0,380,'','email;password');
		myDateField('birthdate','myForm','出生日期：',65,rowheight*3+20,12,0,380,'');
		myComboField('gender','myForm','性别：',65,rowheight*4+20,12,0,135,'男;女;take;task;book;buring','');
		myCheckBoxField('research','myForm','研究方向：',65,rowheight*5+20,12,24,4,'[u90]企业管理;[120]区域经济学;[120]管理信息系统');
		myTextareaField('description','myForm','分类描述：',65,rowheight*6+20,12,310,370,'');
		$("#left").panel({ title:'资源类别'});

		myMenuItem('myMenu1','新增结点/mnaddnode/addIcon;新增子结点/mnaddsubnode/addIcon;修改结点/mnedit/editIcon;-;删除结点/mndelete/deleteIcon;-;保存结点/mnsave/saveIcon;-;刷新/mnrefresh/refreshIcon');
		myDBTree('myTree1','left','资源分类',0,0,0,0,jqsql.category,'categoryid','','fxull;menu:myMenu1');
		$("#myTree1").tree('collapseAll');
		myHiddenFields('parentnodeid;ancester;level;isparentflag;addoredit');
		$("#myTree1").tree({
			onSelect: function(node){
				if (node){
					if (curnode!=null && curnode.id=='*' && node.id!='*'){
						$('#myTree1').tree('remove', curnode.target); //删除无保存的新节点;
						curnode=null;
					}
					curnode=node;
					//alert(node.id);
					if (node.id!='*'){
					//alert(node.isparentflag);
						mySetFormValue(node);  //将树结点对应值赋值到表单控件中去。
						$("#"+keyfield).textbox({readonly: true});
						mySetFormReadonly(true);
						$("#addoredit").val('update');
						myDisableCmp('btnsave;mnsave',true);
						myDisableCmp('btnadd;btnedit;btndelete;mnaddnode;mnaddsubnode;mnedit;mndelete',false);
						
					}
				}
			}
		});
		
		mySetTreeNodeByIndex('myTree1',0);
		//$("#myTree1").focus();
		$('#myForm, #myTree1').bind('contextmenu',function(e){
			e.preventDefault();
			$('#myMenu1').menu('show', {
				left: e.pageX,
				top: e.pageY
			});
		});
		//$("#gender").combobox('disable');
		$("#btnaddnode").bind('click', function(e){ fn_addnode(e); });
		$("#btnaddsubnode").bind('click', function(e){ fn_addsubnode(e);	});
		$("#btnedit,#mnedit").bind('click', function(e){ fn_editnode(e);	});
		$("#btndelete,#mndelete").bind('click', function(e){ fn_deletenode(e);	});
		$("#btnrefresh,#mnrefresh").bind('click', function(e){ fn_refresh(e);	});
		$("#btnsave, #mnsave").click( function(e){ fn_savenode(e); });
 		$("input:text").focus(function() { $(this).select(); } );		
//---------------------end of jquery------------------------
});

//以下是函数
function fn_addnode(e){  
	var node=$("#myTree1").tree('getSelected');
	if (node.id!='*'){
		var pnode=$("#myTree1").tree('getParent', node.target);  //父节点
		myreSetForm();
		$("#addoredit").val('add');
		if (pnode==null){ //第一层结点的情况
			$("#parentnodeid").val('');
			$("#ancester").val('');
			$("#level").val(1);
			$("#isparentflag").val(0);
			var parentnode=null;
		}else{
			$("#parentnodeid").val(node.parentnodeid);
			$("#ancester").val(node.ancester);
			$("#level").val(node.level);
			$("#isparentflag").val(0);
			var parentnode=pnode.target;
		}	
		$('#myTree1').tree('append', {
				parent: parentnode,
				data: {text:" ",id:"*"} 
		});
		var children = $('#myTree1').tree('getChildren', parentnode);
		//console.log(children);
		var newnode=children[children.length-1];
		$("#myTree1").tree('select', newnode.target);
		curnode=newnode; //放在选中之后
		//$("#main")[0].reset();  //
		//$('#myTree1').tree('remove', child_node[0].target); //删除子节点
		mySetFormReadonly(false);
		myKeyDownEvent(keyfield);  //事件需要重新绑定一次
		myDisableCmp('btnsave;mnsave',false);
		myDisableCmp('btnadd;btnedit;btndelete;mnaddnode;mnaddsubnode;mnedit;mndelete',true);
		myFocus(keyfield);
		console.log($("#parentnodeid").val());  
		console.log($("#ancester").val());
	}  
} 		

function fn_addsubnode(e){
	var node=$("#myTree1").tree('getSelected');
	if (node.id!='*'){
		$("#myTree1").tree('expand', node.target);
		myreSetForm();
		$("#parentnodeid").val(node.id);
		$("#ancester").val(node.ancester+node.id+'#');
		$("#level").val(1*node.level+1);
		$("#isparentflag").val(1*node.isparentflag);
		$("#addoredit").val('addsub');
		//$("#main")[0].reset();
		$('#myTree1').tree('append', {
			parent: node.target,
			data: {text:" ",id:"*"} 
		});
		var children = $('#myTree1').tree('getChildren', node.target);
		var newnode=children[children.length-1];
		$("#myTree1").tree('select', newnode.target);
		curnode=newnode; //放在选中之后
		mySetFormReadonly(false);
		//$('#'+keyfield).textbox('textbox').bind('keydown',function(e){
		myKeyDownEvent(keyfield);  //事件需要重新绑定一次
		//});
		//$("#"+keyfield).next("span").find("input").focus();
		myFocus(keyfield);
		myDisableCmp('btnsave;mnsave',false);
		myDisableCmp('btnadd;btnedit;btndelete;mnaddnode;mnaddsubnode;mnedit;mndelete',true);
		console.log($("#parentnodeid").val());  
		console.log($("#ancester").val());
	}	  
} 

function fn_editnode(e){
	var node=$("#myTree1").tree('getSelected');
	if (node.id!='*'){
		mySetFormReadonly(false);
		$("#"+keyfield).textbox({readonly: true});
		$("#addoredit").val('update');
		$("#"+keyfield).next("span").find("input").focus();
		//$('#'+keyfield).textbox('textbox').bind('keydown',function(e){
		myKeyDownEvent(keyfield);  //事件需要重新绑定一次
		//});
		myDisableCmp('btnsave;mnsave',false);
		myDisableCmp('btnadd;btnedit;btndelete;mnaddnode;mnaddsubnode;mnedit;mndelete',true);
		myFocus('categoryname');
	}	
}
    
function fn_deletenode(e){
	var node=$("#myTree1").tree('getSelected');
	if (node && node.id!='*'){
		var keyvalue=myGetInputValue(keyfield);
		if (node.isparentflag=='1'){
			var msg='&nbsp;'+keyspec+'【'+keyvalue+'】是一个大类，<br>&nbsp;删除它及其所有子结点。';
			msg+='<br><br>'+mySpace(8)+'是否确定？';
			var sql="delete "+tablename+" where "+keyfield+"='"+keyvalue+"'";
			sql+=" or ancester like '"+keyvalue+"#%'\n";
		}else{
			var msg='&nbsp;删除'+keyspec+'【'+keyvalue+'】。';
			msg+='<br><br>&nbsp;是否确定？';
			var sql="delete "+tablename+" where "+keyfield+"='"+keyvalue+"'\n";
		}
		var pnode=$("#myTree1").tree('getParent', node.target);  //父节点
		if (pnode!=null){
			var children = $('#myTree1').tree('getChildren', pnode.target);
			if (children.length==1){
				sql+="update "+tablename+" set isparentflag=0 where "+keyfield+"='"+pnode.id+"'\n";
			}
		}
		$.messager.confirm('系统提示', msg, function(r){
			if (r){
				$.ajax({     
					type: "Post",     
					url: "system//easyui_execSql.jsp",     
					//contentType: "application/json; charset=utf-8",     
					//dataType: "json", 
					data: {
						database: sysdatabasestring, 
						selectsql: '',
						updatesql: sql
					}, 
					async: false,    
					success: function(data) {   
						eval("var source="+data+";");
						var error=source[0].error;
						if (error==''){
							//删除成功,查找新的定位节点
							$('#myTree1').tree('remove', node.target); //删除无保存的新节点;
							if (pnode!=null) var parentnode=pnode.target;
							else var parentnode=null;
							var children = $('#myTree1').tree('getChildren', parentnode);
							var newnode=null;					
							if (children.length>0){
								newnode=children[children.length-1];
							}else if (pnode!=null) {
								newnode=pnode;
								pnode.isparentflag=0;
								$("#myTree1").tree('update',pnode);
							}
							if (newnode!=null){	
								$("#myTree1").tree('select', newnode.target);
							}	
							curnode=newnode; //放在选中之后
						}
					},     
					error: function(err) {
						console.log(err);     
					}     
				});
			}
		});  //messager
	}  //if node
}
    
function fn_refresh(e){
	myLoadTree('myTree1','资源分类',jqsql.category,'categoryid','','fxull;menu:myMenu1');
	mySetTreeNodeByIndex('myTree1',0);	
}

    
function fn_savenode(e){  //ssssssave
	//myGetEditFields(sysdatabasestring,'resourcecategories');
	keyvalue=myGetInputValue(keyfield);
	//alert(keyfield+'--'+keyvalue+'---'+$("#categoryid").textbox('getValue'));
	var xerror='';  //数据验证
	if (keyvalue=='') xerror='类别编码不能为空！';
	if (myGetInputValue('categoryname')==''){
		if (xerror!='') xerror+='<br>'; 
		xerror+='类别名称不能为空！';
	}
	if (xerror==''){
		var addoredit=$("#addoredit").val();
		var	fiddim=nodefields.split(";");  //@tab键@分隔
		var nodefidstr="";
		for (var i=0; i<fiddim.length; i++){
			if (i>0) nodefidstr+="+' '+";
			nodefidstr+="rtrim("+fiddim[i]+")";
		}
		if (addoredit=='update'){
			var sql=myGenUpdateSql(sysdatabasestring,tablename,keyfield)+'\n';
			var querysql="select "+keyfield+" as id,"+nodefidstr+" as text,* from "+tablename+" where "+keyfield+"='"+myGetInputValue(keyfield)+"'\n";
			var url='easyui_execSql.jsp';
			console.log(querysql);
			var params={
				database: sysdatabasestring, 
				selectsql: querysql,
				updatesql: sql
			};
		}else{
			var sql='if not exists(select 1 from '+tablename+' where '+keyfield+"='"+keyvalue+"') \n";
			sql+='begin \n';
			sql+='	'+myGenInsertSql(sysdatabasestring,tablename)+'\n';
			if ($("#addoredit").val()=='addsub'){
				sql+="	update "+tablename+" set isparentflag=1 where "+keyfield+"='"+$("#parentnodeid").val()+"' and isparentflag=0 \n";
			}
			sql+='end\n';
			var url='easyui_insertTreeNode.jsp';
			var params={
				database: sysdatabasestring, 
				tablename: tablename,
				keyfield: keyfield,
				keyvalue: myGetInputValue(keyfield),
				nodefields: nodefields,
				insertsql: sql
			};
		}
		//console.log(sql);
		$.ajax({     
			type: "Post",     
			url: "system//"+url,     
			//contentType: "application/json; charset=utf-8",     
			//dataType: "json", 
			data: params, 
			async: false,    
			success: function(data) {   
				eval("var source="+data+";");
				var error=source[0].error;
				if (error!=''){
					if (error=='-1'){
						error="&nbsp;"+keyspec+"值重复。";  //主键重复
					}
					$.messager.alert('系统提示',error+'<br><br>&nbsp;数据保存失败，请重新输入！','error');
				}else{
					//插入成功,更新节点的值
					var node=$("#myTree1").tree('getSelected');
					if (node){
						$.each(source[0], function(id, v) {  //将json数据复制到node
							eval("node."+id+"='"+v+"';");
							//console.log("node."+id+"='"+v+"';");
						});
						$("#myTree1").tree('update',node);  //刷新树结点
						$("#myTree1").tree('select', node.target);
						curnode=node;					   
			        }
				}
			},     
			error: function(err) {
				console.log(err);     
			}     
		});
	}else{
		$.messager.alert('系统提示',xerror+'<br><br>'+mySpace(7)+'数据验证失败，请重新输入！','error');;	
	}	
}
    
function fn_myMenu1Click(item){
	if (item.id=='mnaddnode') fn_addnode(item);
	else if (item.id=='mnaddsubnode') fn_addsubnode(item);
}

</script>
</body>
</html>