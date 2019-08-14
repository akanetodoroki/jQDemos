<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="com.DBConn" %>
<%@ page import="com.UserBean" %>
<%
	String path = request.getContextPath();
	//String path=getServletContext().getRealPath("/"); 
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<style type="text/css">
	a:link {  text-decoration: none}
	a:hover {color: #FF6600; text-decoration: underline}
	
</style>
<head>
	<title>jQuery&EasyUI实例教程</title>
	<meta charset="utf-8">
	<link rel="stylesheet" type="text/css" href="jqeasyui/themes/default/easyui.me.css">
	<link rel="stylesheet" type="text/css" href="jqeasyui/themes/icon.css">
    <link rel="stylesheet" type="text/css" href="system/css/icon.css">
    <script type="text/javascript" src="jqeasyui/jquery.min.js"></script>
    <script type="text/javascript" src="jqeasyui/jquery.easyui.min.js"></script>
</head>
<body style="margin:1px 1px 1px 1px; padding:0px 0px 0px 0px; ">
<div id='main' class="easyui-layout" data-options="fit:true" style="margin:0px 0px 0px 0px;">
	<div id='toolbar' class='easyui-panel' data-options="region:'north'" style="overflow:hidden; background-color: #E0ECFF; height:40px; padding: 7px 1px 0px 2px;">
		<div id="tspan1" style="position:relative; top:0px; float:right">
		
		</div>
		<div id="tspan2" style="position:relative; top:0px; float:right">
			<a href="#" class="btn-separator" style="height:30px;"></a>
			<a href="#" id='resource' class="easyui-linkbutton" data-options="plain:true" style="width:70px">资源管理</a>	
			<a href="#" class="btn-separator"></a>
			<a href="#" id='ollearning' class="easyui-menubutton"  data-options="plain:true, menu:'#mm1'" style="width:80px">在线学习</a>	
			<a href="#" class="btn-separator"></a>
			<a href="#" id='ollab' class="easyui-menubutton"  data-options="plain:true, menu:'#mm2' " style="width:80px">在线实验</a>	
			<a href="#" class="btn-separator"></a>
			<a href="#" id='myspace' class="easyui-linkbutton"  data-options="plain:true" style="width:80px">我的空间</a>	
			<a href="#" class="btn-separator"></a>
			<a href="#" id='download' class="easyui-linkbutton"  data-options="plain:true" style="width:80px">常用下载</a>
			<a href="#" class="btn-separator"></a>
			<a href="melab.jsp" id='home' class="easyui-linkbutton" data-options="plain:true" style="width:50px">主页</a>
			<a href="#" class="btn-separator"></a>
			<input id="searchtext" class="easyui-searchbox" data-options="prompt:'搜索资源'" style="width:250px;" />
		</div>	
	</div>
	<div id='center' data-options="region:'center'" style="overflow:hidden; margin:0px 0px 0px 0px; padding: 0px 0px 0px 0px; ">
		<iframe id="mainframe" width="100%" height="100%" src="" frameborder="no" border="0" style="overflow-y:hidden; margin:0px 0px 0px 0px; padding:0px 0;"></iframe>
	</div>
	<div id='bottom' data-options="region:'south'" style="height:35px; padding: 2px 0px 0px 2px; "></div>
</div>   
	<div id="mm1" class="menu-content" style="width:140px; background:#f0f0f0; padding:10px 10px 0; text-align:left">
		<div style="margin:0px 0px 10px 0px;">
			<div style="margin:0px 0;"><img src="system/images/bullet.png"><a href="#" style="padding:0 4px; font-size:12px; color:#444;">在线作业</a></div>
			<div style="margin:6px 0;"><img src="system/images/bullet.png"><a href="#" style="padding:0 4px; font-size:12px; color:#444;">在线讨论</a></div>
			<div style="margin:6px 0;"><img src="system/images/bullet.png"><a href="#" style="padding:0 4px; font-size:12px; color:#444;">在线答疑</a></div>
		</div>
		<div class="menu-sep"></div>
		<div style="margin:0px 0px 10px 0px;">
			<div style="margin:6px 0;"><img src="system/images/bullet.png"><a href="#" style="padding:0 4px; font-size:12px; color:#444;">文档阅读</a></div>
			<div style="margin:6px 0;"><img src="system/images/bullet.png"><a href="#" style="padding:0 4px; font-size:12px; color:#444;">视频播放</a></div>
			<div style="margin:6px 0;"><img src="system/images/bullet.png"><a href="#" style="padding:0 4px; font-size:12px; color:#444;">音频播放</a></div>
		</div>
		<div class="menu-sep"></div>
		<div style="font-size:13px; color:#444; margin:10px 0px 10px 0px;">学习管理系统<div>
		<div style="margin:6px 0;"><img src="system/images/bullet.png"><a id="jqeasyui" href="#" target="_blank" style="padding:0 4px; font-size:12px; color:#444;">软件开发工具</a>	</div>
		<div style="margin:6px 0;"><img src="system/images/bullet.png"><a id="dbms" href="#" style="padding:0 4px; font-size:12px; color:#444;">数据库原理与应用</a></div>
		<div style="margin:6px 0;"><img src="system/images/bullet.png"><a id="datastructure" href="#" style="padding:0 4px; font-size:12px; color:#444;">数据结构</a></div>
    </div>
     <div id="mm2" style="width:100px;">
        
    </div>
	
<script>
	var basepath='<%=basePath %>';
	rowheight=28;
	$(document).ready(function(){
		$('#searchtext').searchbox({
			//buttonIcon:'locateIcon',
            onClickButton: function(e){
            
            }
		}); 
		
		var sql="select type,Description,pycode from dictionary  where Type='在线学习' "+
		"union all "+
		"select type,Description,pycode from dictionary  where Type='远程实验' "+
		"union all "+
		"select type,Description,pycode from dictionary  where Type='我的空间' "+
		"union all "+
		"select type,Description,pycode from dictionary  where Type='常用下载' ";

		//var result=myRunSelectSql(sysdatabasestring, sql);
		//console.log(result.length);

		
		$('#resource').click(function(e){
	 		//$("#mainframe").attr('src', 'resource.jsp');
	 		//alert(basepath+'/index.jsp');
	 		//$("#resource").attr("href",basepath+'index.jsp');  		
	 	});
		$('#jqeasyui').click(function(e){
	 		//$("#mainframe").attr('src', 'index.jsp');
	 		$("#jqeasyui").attr("href",basepath+'index.jsp');  		
	 	});

	 	/*
		$('#ollab').click(function(e){
	 		$("#mainframe").attr('src', 'onlinelab.jsp'); 		
	 	});
		$('#download').click(function(e){
	 		$("#mainframe").attr('src', 'download.jsp'); 		
	 	});
	 	*/
	
	
	});
</script>
</body>
</html>
