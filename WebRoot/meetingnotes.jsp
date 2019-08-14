<%@ page language="java" import="java.util.*" contentType="text/html;charset=utf-8"  language="java"  pageEncoding="UTF-8" %>
<!doctype html>
<html>
<style type="text/css">
</style>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link rel="stylesheet" type="text/css" href="jqeasyui/themes/default/easyui.css">
	<link rel="stylesheet" type="text/css" href="jqeasyui/themes/default/easyui.me.css">
	<link rel="stylesheet" type="text/css" href="jqeasyui/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="jqeasyui/demo/demo.css">
    <link rel="stylesheet" type="text/css" href="system/css/icon.css">
    <script type="text/javascript" src="jqeasyui/jquery.min.js"></script>
    <script type="text/javascript" src="jqeasyui/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="jqeasyui/easyui-lang-zh_CN.js"></script>	
	<script type="text/javascript" src="system/easyui_functions.js"></script>
	<script type="text/javascript" src="system/easyui_html5media.js"></script>
</head>
<body id='main' class="easyui-layout" data-options="fit:true" style="margin: 1px 1px 1px 1px;">	
	<div id='left' class='easyui-panel' data-options="region:'west', split:true" style="overflow:auto; width:250px;">
	</div>
	<div id='middle' class='easyui-panel' data-options="region:'center', split:true" style="overflow:auto;">
		<a href="indexx.jsp" id="btnreturn" class="easyui-linkbutton" data-options="iconCls:'returnIcon',plain:true" style="">返回首页</a>
	</div>
<script>
	$(document).ready(function() {
		var xsql="select meetingid from meeting";
		var meetingsource=myRunSelectSql('jqdemos',xsql);
		var str='<img id="image1" src="" style="position: absolute; top:18px; left:285px;"></img>';
		$("#middle").append($(str));
		myComboField('meetingid','left','会议日期：',70,36*0+20,12,0,120,'','');
		$("#meetingid").combobox({
			panelWidth:120,  
		    idField:'meetingid',
		    textField:'meetingid',
		    data:meetingsource,
		    onSelect: function(record) {  //选中事件
				if (record){
					var src="mybase/meetings/"+record.meetingid+".png";
					$("#image1").attr('src',src);
					var str='<div id="url" style="position: absolute; top:260px; left:700px;"><a href="mybase/meetings/'+record.meetingid+'.docx">'+record.meetingid+'</a>下载</div>';
					$("#url").remove();  //删除原来学生简介对应的旧链接
					//console.log(str);
					$("#middle").append($(str));
				}
			}
		    
		});
		
		
		
		
		

	});


</script>
</body>
</html>