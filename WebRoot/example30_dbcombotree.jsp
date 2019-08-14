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
<div id='main' style="margin:0px 0px 0px 0px;">
	
</div>    
<script>
	$(document).ready(function() {
		var jqsql={};  //sql语句中不能有双引号
		jqsql.party="select Pycode as id,description as party from dictionary where Type='党派'";
		jqsql.title="select Pycode as id,description as title from dictionary where Type='学历'";
		jqsql.area="select AreaName as text, * from Areas ";
		jqsql.degree="select Pycode as id,description as degree from dictionary where Type='学历'";
		myForm('myForm1','main','教师信息编辑',0,0,420,335,'drag');
		myFieldset('myFieldset1','myForm1','',8,10,370,310);
		myTextField('teacherid','myFieldset1','教师编码：',70,35*0+16,16,0,160,'D20101');
		myTextField('name','myFieldset1','姓名：',70,35*1+16,16,0,160,'诸葛亮');
		myTextField('pycode','myFieldset1','拼音：',70,35*2+16,16,0,160,'zhugeliang');
		myComboField('gender','myFieldset1','性别：',70,35*3+16,16,0,115,'男;女;take;task;book;buring','');
		myDateField('birthdate','myFieldset1','出生日期：',70,35*4+16,16,0,115,'5/12/1997');
		myLabelField('areaidx','myFieldset1','出生地：',35*5+20,16,0,0);
		//myDBComboTreeField('areaid','myFieldset1','出生地：',70,35*5+16,16,0,220,jqsql.area,'areaid','','fullx');
		myDBComboField('party','myFieldset1','党派：',70,35*6+16,16,0,160,jqsql.party,'','','');
		myDBComboField('title','myFieldset1','职称：',70,35*7+16,16,0,160,jqsql.title,'','','');
		myDBComboField('degree','myFieldset1','学历：',70,35*8+16,16,0,160,jqsql.degree,'','','');
		myTextField('school','myFieldset1','毕业学校：',70,35*9+16,16,0,205,'');
		//定义combotree控件
		var str='<div id="areaid_div"><input class="easyui-combotree" id="areaid"></div>';
		$("#myFieldset1").append($(str));
		$("#areaid_div").css(myTextCss('myFieldset1',35*5+16,86,0,0));
		$("#areaid").combotree({
			width:205,
			panelHeight: 300,
			valueField: 'areaid',
			textField: 'areaname'
		});
		$("#areaid").attr('xsql',jqsql.area);  //自定义属性
		$("#areaid").attr('xkeyfield','areaid'); //自定义属性
		//提取第一层节点
		var xsql="select * from ("+jqsql.area+") as p where parentnodeid=''";
		$.ajax({     
			type: "Post",     
			url: "system/easyui_getChildNodes.jsp",
			data: { database: sysdatabasestring, selectsql: xsql, keyfield:'areaid', sortfield:'' }, 
			async: false, method: 'post',
			success: function(data) {
				var source=eval(data);
				$('#areaid').combotree({ data: source });
			}   
		});
		//点击展开事件，提取子节点
		$("#areaid").combotree({
			onBeforeExpand: function (node){  //点击展开事件
				var sql=$('#areaid').attr('xsql');
				var keyfield=$('#areaid').attr('xkeyfield');
				var pid=eval("node."+keyfield);
				var xcbtree=$('#areaid').combotree('tree');
				var child_node = xcbtree.tree('getChildren', node.target);
				if (child_node.length==1 && child_node[0].id=='_'+pid){ //生成子节点
					var xsql="select * from ("+sql+") as p where parentnodeid='"+pid+"'";
					console.log(xsql);
					$.ajax({
						url: "system/easyui_getChildNodes.jsp",
						data: { database: sysdatabasestring, selectsql: xsql, keyfield:keyfield, sortfield:'' }, 
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
				};
			}
		});	
		//只能选中叶子节点
		$("#areaid").combotree({
			onClick : function(node) {  
				var cbtree = $(this).tree; //返回树对象  
				//选中的节点是否为叶子节点,如果不是叶子节点,清除选中  
				var isLeaf = cbtree('isLeaf', node.target);  
				if (!isLeaf) $("#areaid").combotree('clear');//清除选中
			}  
		});  
		
		//选定树初始聚焦位置
		var cbtree=$('#areaid').combotree('tree');
		var node=cbtree.tree('find','330000');
		cbtree.tree('select',node.target);
		
	//--------------------//
	});  //endofjquery 
    
</script>
</body>
</html>