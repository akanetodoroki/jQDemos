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
<body  style="margin: 2px 2px 2px 2px;">
<div id='main' class="easyui-layout" data-options="fit:true" style="margin:0px 0px 0px 0px;">
 	
</div>    
<script>
	$(document).ready(function() {
		var pmyGrid1={};
		pmyGrid1.id='myGrid1';  //网格名称
		pmyGrid1.parent='main';  //父类容器标识符
		pmyGrid1.staticsql="select teacherid,Name,pycode,case when Gender='f' then '女' else '男' end as gender,"+
		"birthdate,province,city,title,party,research,mobile from teachers";
		pmyGrid1.activesql=pmyGrid1.staticsql;  //根据过滤条件动态变化的查询语句
		pmyGrid1.pagesize=10;    //每页显示行数
		pmyGrid1.keyfield='teacherid';  //数据表关键字
		pmyGrid1.sql_party="select Pycode as id,description as party from dictionary where Type='党派'";
		pmyGrid1.sql_title="select Pycode as id,description as title from dictionary where Type='职称'";
		pmyGrid1.sql_city="select AreaName as text,AreaName as id,areaname as city,* from Areas";
		pmyGrid1.rowindex=-1;
		pmyGrid1.data=[];
		pmyGrid1.gendersource=[{gender:'男'},{gender:'女'}];
		pmyGrid1.researchsource=[{research:'区域经济学'},{research:'国际经济贸易'},{research:'财务管理'},{research:'电子商务'},{research:'企业信息化'}];
		pmyGrid1.titlesource=myRunSelectSql(sysdatabasestring, pmyGrid1.sql_title);
		pmyGrid1.partysource=myRunSelectSql(sysdatabasestring, pmyGrid1.sql_party);
		pmyGrid1.citysource=myLoadComboTreeData('city',pmyGrid1.sql_city,'areaid','','');
		//myMenu('myMenu1','新增结点/mnaddnode/addIcon;新增子结点/mnaddsubnode/addIcon;修改结点/mneditnode/editIcon;-;删除结点/mndeletenode/deleteIcon','');
		var xcolumns=[[{
			title:'教师编码', field:'teacherid', width:75, halign:'center', align: 'left',
			editor:{
				type : 'textbox', options : {required: true}
			}	 
		},{	title:'教师姓名', field:'name', width:80, halign:'center', align: 'left', 
			editor:{
				type:'textbox',
				options:{required: true	}
			}	 			
		},{	title:'拼音', field:'pycode', width:100, halign:'center', align:'left',
			editor:{
				type : 'textbox'
			}
		},{	title: '性别', field: 'gender', width: 55, halign:'center', align: 'center',
			editor:{
				type: 'combobox',
				options:{
					valueField:'gender',
					textField:'gender',
					panelHeight:'auto',
					data: pmyGrid1.gendersource
				 }
			}
		},{	title: '出生日期', field: 'birthdate', width: 95, halign:'center', align: 'center',
			editor:{
				type : 'datebox'
			}			
		},{ title: '职称', field: 'title', width: 95, halign:'center', align: 'left',
			editor : {
				type : 'combobox',
				options : {
					valueField:'title',
					textField:'title',
					panelHeight:'auto',
						data: pmyGrid1.titlesource
				}
			}				
		},{ title: '党派', field: 'party', width: 95, halign:'center', align: 'left',
			editor : {
				type : 'combobox',
				options : {
					valueField:'party',
					textField:'party',
					panelHeight:'auto',
					data: pmyGrid1.partysource
				}
			}				
		},{ title: '出生地', field: 'city', width: 150, halign:'center', align: 'left',
			editor : {
				type : 'combotree',
				options : {
					valueField: 'city',
					textField: 'city',
					panelHeight: 255,
					panelWidth: 180, //'auto',
					data: pmyGrid1.citysource,
					onBeforeExpand: fnExpandComboTree  //点击展开事件
				}
			}				
		},{ title: '研究方向', field: 'research', width: 150, halign:'center', align: 'center',
			editor : {
				type : 'combobox',
				options : {
					valueField: 'research',
					textField: 'research',
					panelHeight: 'auto',
					multiple: true,
					data: pmyGrid1.researchsource,
					formatter: function(row){
 						var s ='<input id="" type="checkbox" class="combobox-checkbox">'+row.research;
            			return s;						
					},
					onLoadSuccess:function(){
						var opts = $(this).combobox('options');
						var target = this;
						var values = $(target).combobox('getValues');
						$.map(values, function(value){
							var el = opts.finder.getEl(target, value);
							el.find('input.combobox-checkbox')._propAttr('checked', true);
						})
					},
					onSelect:function(row){
						var opts = $(this).combobox('options');
						var el = opts.finder.getEl(this, row[opts.valueField]);
						el.find('input.combobox-checkbox')._propAttr('checked', true);
					},
					onUnselect:function(row){
						var opts = $(this).combobox('options');
						var el = opts.finder.getEl(this, row[opts.valueField]);
						el.find('input.combobox-checkbox')._propAttr('checked', false);
					}
				}
			}	 			
		},{ title: '联系电话', field: 'mobile', width: 110, halign:'center', align: 'left',
			editor : {type: 'textbox'}	
		}]]; //列属性定义结束
		var xfixedcolumns=[[
			{ title: 'id', field: 'id', width: 20, checkbox: true, sortable: true, align: 'center'}
		]];
		//定义grid及其工具栏
		var myToolbar1 = ['-',{
            text:'新增',
            iconCls:'addIcon',
            handler: fn_add
        },{
            text:'删除',
            iconCls:'deleteIcon',
            handler: fn_delete
        },'-',{
            text:'保存',
            iconCls:'saveIcon',
            handler: fn_save
        },'-',{
            text:'刷新',
            iconCls:'refreshIcon',
            handler:function(){alert('save')}
        }];
		var str='<div id="myGrid1" class="easyui-datagrid" style="overflow:auto"></div>';
		$("#main").append($(str));
		$("#myGrid1").datagrid({
			title: '&nbsp;教师列表',
			iconCls: "panelIcon",
			width: '100%',
            height: 500, //'100%',
			nowrap: true,
            pagePosition: 'bottom',  //top,both
            autoRowHeight: false,
			rownumbers: true,
			pagination: true,
			pageSize: 10,
			pageNumber:1,
            striped: true,
            collapsible: false,
			singleSelect: true, //false,
			toolbar: myToolbar1,
			//fitColumns: true,
			//sortName: 'studentid',
			//sortOrder: 'asc',
			//remoteSort: false,
			//idField: 'studentid',
			frozenColumns: xfixedcolumns,
			columns: xcolumns,
			onClickCell: function(index,field){
				$("#myGrid1").datagrid('beginEdit',index);
				if (pmyGrid1.rowindex!=index){
					if (pmyGrid1.rowindex>=0) $("#myGrid1").datagrid('endEdit',pmyGrid1.rowindex);
				}
				pmyGrid1.rowindex=index; //记录当前行号
			},
			onSelect: function(index,data){
				$("#myGrid1").datagrid('beginEdit',index);
				if (pmyGrid1.rowindex!=index && pmyGrid1.rowindex>=0){
					$("#myGrid1").datagrid('endEdit',pmyGrid1.rowindex);
				} 
				pmyGrid1.rowindex=index;
			},
			onLoadSuccess: function(data){
				pmyGrid1.data=data.rows;
				//console.log(pmyGrid1.data.length);
			},
			onBeforeLoad:function(){
				fn_save();  //换页之前保存当前页的记录
			}
		});	
		//定义分页栏模式
		myGridPaging(pmyGrid1);
		//初始化，显示第一页记录
		myLoadGridData(pmyGrid1,1);
		//$("#myGrid1").datagrid('beginEdit',0);
		function fnExpandComboTree(node){
			var pid=eval("node.areaid");
			var editors = $('#myGrid1').datagrid('getEditors', pmyGrid1.rowindex);
			console.log(editors[5]);
			for (var i=0;i<editors.length;i++){
				if (editors[i].field=='city'){
					var xcbtree=editors[i].target.combotree('tree');  //$(".datagrid-row-editing td[field=city]");//.combotree('tree');
					break;								
				}
			}
			var child_node = xcbtree.tree('getChildren', node.target);
			if (child_node.length==1 && child_node[0].id=='_'+pid){ //生成子节点
				var xsql="select * from ("+pmyGrid1.sql_city+") as p where parentnodeid='"+pid+"'";
				$.ajax({
					url: "system/easyui_getChildNodes.jsp",
					data: { database: sysdatabasestring, selectsql: xsql, keyfield:'areaid', sortfield:'' }, 
					async: false, method: 'post',    
					success: function(data) {
						var source=eval(data);
						xcbtree.tree('remove', child_node[0].target); //删除子节点
						xcbtree.tree('append', {  //增加数据作为子节点
							parent: node.target,
							data: source 
						});
					}    
				});
			}
		}		
		
		//点击新增记录
		function fn_add(){
			$("#myGrid1").datagrid('endEdit', pmyGrid1.rowindex);
			$("#myGrid1").datagrid('insertRow', { //插入一行到最前行
				index: 0,
				row: {rownumber:"-1"}
			});
			pmyGrid1.rowindex = 0;	
			$("#myGrid1").datagrid('beginEdit', 0);
			$("#myGrid1").datagrid('selectRow', 0);	
		}
		//点击删除记录
		function fn_delete(){
			//快速连续点击删除时，会有错误提示，原因是删除后选中行的问题
			var rows=$("#myGrid1").datagrid('getRows');
			if (rows.length>0){ 
	            $('#myGrid1').datagrid('deleteRow', pmyGrid1.rowindex);
				if (pmyGrid1.rowindex>rows.length-1 && rows.length>0){
					pmyGrid1.rowindex--;  //选中上一行，否则自动选下一行
				}
				$("#myGrid1").datagrid('selectRow', pmyGrid1.rowindex);//选中下一行
			}else{
				myMessagebox('系统提示','记录已经全部被删除！');
			}
		}
		//点击保存记录
		function fn_save(){
			if (pmyGrid1.rowindex>=0) $("#myGrid1").datagrid('endEdit',pmyGrid1.rowindex);
			var sql='';
			for (var i=0;i<pmyGrid1.data.length;i++){
				sql+="\n delete teachers where teacherid='"+pmyGrid1.data[i].teacherid+"'";
			}
			var fieldset='';
			$.ajax({     
				type: "Post",     
				url: "system//easyui_getEditableFields.jsp",     
				//contentType: "application/json; charset=utf-8",     
				//dataType: "json", 
				data: {
					database: sysdatabasestring, 
					tablename: 'teachers'
				}, 
				async: false, method: 'post',    
				success: function(data) {  
					eval("fieldset="+data+";");
				}    
			});
			var rows = $("#myGrid1").datagrid('getRows');  //获取本页全部行
			//var rowstr = JSON.stringify(rows);
			for (var i=0;i<rows.length;i++){
				var record=rows[i];
				var sql1='';
				var sql2='';
				for (var j=0; j<fieldset.length; j++){
					var field=fieldset[j].field;
					var value=eval("record."+field);
					if (value!=undefined){
						if (sql1!=''){
							sql1+=',';
							sql2+=',';
						}
						sql1+=field;
						sql2+="'"+value+"'";
					}	
				}
				sql+="\n insert into teachers ("+sql1+") values ("+sql2+")";
				/*
				if (record.rownumber>0){  //修改记录
					var sql1='';
					for (var j=0; j<fieldset.length; j++){
						var field=fieldset[j].field;
						var value=eval("record."+field);
						if (value!=undefined){
							if (sql1!='') sql1+=',';
							sql1+=field+"='"+value+"'";
						}	
					}
					sql+="\n update teachers set "+sql1+" where teacherid='"+record.teacherid+"'";
				}
				*/	
			}
			myRunUpdateSql(sysdatabasestring, sql);
		}
		
//---------------------
});
	
</script>
</body>
</html>