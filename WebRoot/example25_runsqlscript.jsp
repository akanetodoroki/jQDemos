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
		myForm('myForm1','main','运行SQL脚本文件',0,0,265,580,'close;drag');
		myMemoField('results','myForm1','结果反馈：',70,60,16,110,464,'');
		myButton('btnrun','myForm1','运行脚本',190,380,30,90,'runIcon','','');
		myButton('btnclose','myForm1','关闭',190,380+91,30,80,'stopIcon','','');
		myLabelField('sqlfilex','myForm1','选择文件：',25+3,16,0,0);
		var str='<div style="position: absolute; top:25px; left:87px; width: 260px; padding-left: 4px;" id="gender_div">';
		str+='<input class="easyui-combobox" id="sqlfile" style="padding:0px 6px 0px 6px" /></div>';
		$("#myForm1").append($(str));		
		var filesource=[
			{filename:"resourcecategories.sql", filedesc:"生成资源类别表"},
			{filename:"dictionary.sql", filedesc:"生成选项表"},
			{filename:"sys_unicodes.sql", filedesc:"生成汉字字库"},
			{filename:"areas.sql", filedesc:"生成地区表"},
			{filename:"jqdemos.sql", filedesc:"生成实例表"},
			{filename:"products.sql", filedesc:"生成产品表"},
			{filename:"students.sql", filedesc:"生成学生表"},
			{filename:"teachers.sql", filedesc:"生成教师表"},
			{filename:"accounts.sql", filedesc:"生成会计科目表"}
		];
		$("#sqlfile").combobox({
			width:475,
			panelHeight: 'auto',
			panelWidth: 300,
			editable: false,
			multiple:true,
			separator: ';',
			data: filesource,
			valueField: 'filename',
			textField: 'filedesc',
			formatter: formatItem
		});
		
		$("#sqlfile").combobox({
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
		}); 		
		//$('#sqlfile').
		//设置下拉框初值
		$('#sqlfile').combobox('select',filesource[0].filename);

		//以下定义函数和事件
		function formatItem(row){
            var s ='<input id="" type="checkbox" class="combobox-checkbox">'+
			'<span style="color:blue">' + row.filedesc + '</span>'+
			'<span style="font-weight:bold">' + row.filename + '</span>';
            return s;
        }
        
		$('#btnrun').bind('click',function(e){
        	var files='';
        	var records=$("#sqlfile").combobox("getValues");
        	for (var i=0;i<records.length;i++){
        		if (i>0) files+=';';  //文件之间以;键分割
        		files+=records[i];
        	}
			$("#results").val('');
        	$.ajax({
				url: "system/easyui_runSqlScriptFile.jsp",
				data: { database: sysdatabasestring, filename:files,filepath:'sqlscript' }, 
				async: false, method: 'post',    
				success: function(data) {
					var message=data.trim()+'';
					$("#results").val('脚本运行结果：\n'+message);
				},     
				error: function(err) {     
					console.log(err);     
				}     
			});
		});
		$('#btnclose').bind('click',function(e){
			$("#myForm1").panel("close");
		});

	});  //endofjquery 
</script>
</body>
</html>