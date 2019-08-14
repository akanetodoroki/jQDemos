<%@ page language="java" import="java.util.*" contentType="text/html;charset=utf-8"  language="java"  pageEncoding="UTF-8" %>
<!doctype html>
<html>
<style type="text/css">
</style>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link rel="stylesheet" type="text/css" href="jqeasyui/themes/default/easyui.me.css">
	<link rel="stylesheet" type="text/css" href="jqeasyui/themes/icon.css">
    <link rel="stylesheet" type="text/css" href="system/css/icon.css">
    <script type="text/javascript" src="jqeasyui/jquery.min.js"></script>
    <script type="text/javascript" src="jqeasyui/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="jqeasyui/easyui-lang-zh_CN.js"></script>	
	<script type="text/javascript" src="system/easyui_functions.js"></script>
	<script type="text/javascript" src="system/easyui_html5media.js"></script>
</head>
<body id='main' class="easyui-layout" data-options="fit:true" style="margin: 1px 1px 1px 1px;">
	<div id='top' class='easyui-panel' data-options="region:'north'" style="overflow:hidden; background-color: #E0ECFF; height:30px; padding: 1px 1px 1px 10px;">
		<a href="#" class="btn-separator"></a>
		<a href="#" id="btnadd" xtype="button" class="easyui-linkbutton" data-options="iconCls:'addIcon', plain:true, onClick:fn_add" style="">新增</a>
		<a href="#" id="btndelete" xtype="button" class="easyui-linkbutton" data-options="iconCls:'deleteIcon',plain:true, onClick:fn_delete" style="">删除</a>
		<a href="#" class="btn-separator"></a>
		<a href="#" id="btncollapse" xtype="button" class="easyui-linkbutton" data-options="iconCls:'saveIcon',plain:true, onClick:fn_collapse" style="">收缩</a>
	</div>	
	<div id='bottom' class='easyui-panel' data-options="region:'south'" style="height:35px; overflow:auto; padding:8px 0px 0px 20px;">
	</div>
	<div id='left' class='easyui-panel' data-options="region:'west', split:true" style="overflow:auto; width:250px;">
		<div class="easyui-accordion" data-options="fit:true, border:false">
			<div id='content1' title="C程序设计简介"></div>
			<div id='content2' title="数据库原理与应用简介" data-options="selected:true"></div>
			<div id='content3' title="数据结构简介"></div>
		</div>
	</div>
	<div id='middle' class='easyui-panel' data-options="region:'center', split:true" style="overflow:auto;">
		<div id="middlelayout" class="easyui-layout" data-options="fit:true">
			<div id='middletop' class='easyui-panel' data-options="region:'center',split:true, border:false" style="overflow:hidden"></div>
			<div id='middlebottom' class='easyui-panel' data-options="region:'south', split:true, border:false"  style="overflow:hidden; height:120px;">
			</div>
		</div>
	</div>
<script>
	$(document).ready(function() {
		//实时显示系统当前时间
		setInterval(function() {
		    var now = (new Date()).toLocaleString();
		    $('#bottom').text("系统当前时间："+now);
		},1000);
		//提取服务器的文本文件	  
		//$('#content1').load('mybase/c-programming.txt');		
		/*
		$.ajax({
			url: 'mybase/c-programming.txt',
			cache:false,
			 async: false, type: "post",		
			dataType: 'text',   //html
			success: function(data) {
				console.log(Utf8ToUnicode(data));
				$('#content1').text('');  //清空
				$('#content1').append(data);
			}
		});
		*/
		//添加文字
		$('#content2').append("数据库技术是计算机科学的一个重要组成部分，基于数据库技术的计算机应用已成为当今计算机科学与技术应用的主流，是企业开展信息化和电子商务的技术基础。数据库原理、技术与应用是掌握计算机应用开发技术的基础性课程，也是一门实用性和实战性很强的课程。");
		$('#content3').html("《数据结构》的前半部分从抽象数据类型的角度讨论各种基本类型的数据结构及其应用；后半部分主要讨论查找和排序的各种实现方法及其综合分析比较。");		
		//在右上角区域显示pdf文件
		var str='<object data="mybase/test1.pdf" type="application/pdf" width="100%" height="100%" >\n';
		str+='</object>';			//swf ,,application/x-shockwave-flash, x-mplayer2
		$('#middletop').append($(str));
		//右下角区域播放mp3文件
	    str='<p>&nbsp;新概念英语第4册第1课</p>'+
	    '<audio id="main_audio1" src="mybase/lesson4-01.mp3" controls="controls" autoplay="autoplay" preload="auto" '+
	    'style="position:absolute; top:5px;left:140px; width:400px;"></audio>'+
	    '<p>&nbsp;新概念英语第4册第2课</p>'+
	    '<audio id="main_audio2" src="mybase/lesson4-02.mp3" controls="controls" '+
	    'style="position:absolute; top:40px;left:140px; width:400px;"></audio>'+
		'<p><button onclick="loopPlay()">循环播放</button>'+
		'<button onclick="goToFirst()">从头播放</button></p>';
		$('#middlebottom').append($(str));
	});
	
	function fn_delete(){
		$('#middlelayout').layout('remove','west');
	}
	function fn_collapse(){
		if ($('#newpanel').length>0){
			var popts = $('#newpanel').panel('options');
			var collapsed=popts.collapsed;
			if (collapsed) $('#newpanel').panel('expand');
			else $('#newpanel').panel('collapse');
		}
	}
	
	function fn_add(){
		$('#middlelayout').layout('add',{
			id: 'newpanel',
		    region: 'west',
		    width: 280,
		    title: 'West Title',
		    split: true,
		    //collapsible: true,
		    tools: [{
				iconCls:'addIcon',
				handler:function(){alert('add')}
		    },{
				iconCls:'deleteIcon',
				handler:function(){alert('remove')}
		    }]
		});
	}
	//播放控制函数
	function isPlaying(audio) {return !audio.paused;}
	function loopPlay(){
		var a1=document.getElementById('main_audio1');
		var a2=document.getElementById('main_audio2');
		a1.loop=true;
		a2.loop=true;
	}

	function goToFirst(){
		var a1=document.getElementById('main_audio1');
		var a2=document.getElementById('main_audio2');
		a1.currentTime=0;
		a2.currentTime=0;
		if (isPlaying(a1)){
			a1.play();
			a2.pause();
		}else{
			a1.pause();
			a2.play();
		}
	}

</script>
</body>
</html>