<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	//String path=getServletContext().getRealPath("/"); 
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!doctype html>
<html lang="en">
<style type="text/css">
	.bg { background-color:red }
</style>
<head>
	<title>jQuery&EasyUI实例教程</title>
	<meta charset="utf-8">
	<link rel="stylesheet" type="text/css" href="jqeasyui/themes/default/easyui.me.css">
	<link rel="stylesheet" type="text/css" href="jqeasyui/themes/icon.css">
    <link rel="stylesheet" type="text/css" href="system/css/icon.css">
    <script type="text/javascript" src="jqeasyui/jquery.min.js"></script>
    <script type="text/javascript" src="jqeasyui/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="jqeasyui/easyui-lang-zh_CN.js"></script>	
	<script type="text/javascript" src="system/easyui_functions.js"></script>
</head>
<body style="margin:1px 1px 1px 1px; padding:0px 0px 0px 0px; ">
<div id='main' class="easyui-layout" data-options="fit:true" style="margin:0px 0px 0px 0px;">
	<div id='toolbar' class='easyui-panel' data-options="region:'north'" style="overflow:hidden; background-color: #E0ECFF; height:30px; padding: 8px 1px 0px 12px;">
		<div id="tspan1" style="position:absolute; left:0px; top:0px; width:500px; float:left"></div>
		<div id="tspan2" style="position:relative; top:0px; width:550px; float:right"></div>
	
	</div>
	<div id='left' data-options="region:'west',split:true, title:'tree'" style="width:290px;"></div>
	<div id='right' data-options="region:'center'" style="overflow:hidden; margin:0px 0px 0px 0px; padding: 0px 0px 0px 0px; ">
		<iframe id="mainframe" width="100%" height="100%" src="example01_formbasic.jsp" frameborder="no" border="0" style="overflow-y:hidden; margin:0px 0px 0px 0px; padding:0px 0;"></iframe>
	</div>
	<div id='bottom' data-options="region:'south'" style="height:35px; padding: 2px 0px 0px 2px; ">
		<div id="bspan1" style="position:absolute; left:0px; top:0px; width:400px; float:left"></div>
		<div id="bspan2" style="position:relative;width:385px; float:right"></div>
		
	</div>
</div>    
<script>
	pmyTree1={};
	var basepath='<%=basePath %>';
	$(document).ready(function(){
		rowheight=systext.rowheight+4;
		curnode=null;  //记录新增的临时结点
		keyfield='id';
		keyvalue='';
		keyspec='jQuery+EasyUI实例';
		tablename='sys_menu';
		nodefields="id;title";
		pmyTree1.id='myTree1';
		pmyTree1.parent='left';
		pmyTree1.keyfield='id';
		pmyTree1.sql="select title as text,RIGHT(str(100+id,3),2) as id,url,0 as isparentflag,2 as level,"+
		"cast(chapter as varchar(2)) as parentnodeid,"+
		"cast(chapter as varchar(2))+'#' as ancester from sys_menu "+
		"union all "+
		"select distinct '第'+CAST(chapter as varchar(2))+'章' as text,cast(chapter as varchar(2)),'',1,1,'','' from sys_menu";
		console.log(pmyTree1.sql);
		//alert(9);
		pmyTree1.title='';
		pmyTree1.sortfield='';
		pmyTree1.editable=false;
		pmyTree1.style='full';
		pmyTree1.line=true;
		pmyTree1.width=0;
		pmyTree1.height=0;
		pmyTree1=myDBTree(pmyTree1);		
		$("#left").panel({ title:'jQuery+EasyUI实例'});
		myMenu('myMenu1','工程源码/mnproject/downloadIcon;pdf教材/mnpdf/pdfIcon;word教材/mnword/wordIcon;-;恢复数据库/mndatabase/databaseIcon','');
		myhref("btnexample","tspan1",'',8,10,0,0,'#','blank');
		myhref("btncode","tspan2",'源码下载',0,00,0,0,'#','');
		myhref("btnchnweb","tspan2",'中文网站',0,85,0,0,'http://www.jeasyui.net','blank');
		myhref("btnukweb","tspan2",'英文网站',0,170,0,0,'http://www.jeasyui.com/documentation/index.php','blank');
		myhref("btndemo","tspan2",'实例网站',0,255,0,0,'http://www.jeasyui.com/demo/main/','blank');
		myhref("btnaol","tspan2",'搜索引擎',0,340,0,0,'http://www.aol.com','blank');
		myhref("btnhome","tspan2",'主页',0,425,0,0,'../index.jsp','');
		var str='<div id="btndownload_div"><a href="#" class="btn-separator"></a><a href="#" id="btndownload" xtype="button" class="easyui-menubutton" data-options="menu:\'#myMenu1\' ">下载</a></div>';
		$("#tspan2").append($(str));
		$("#btndownload").menubutton();		
		$("#myMenu1").menu({width:200});		
		$("#btndownload_div").css(myTextCss('tspan2',-6,480,0,0));
		//myButton("btnproject","tspan2",'工程下载',0,80,24,80,'');
		//$("#btndownload_div").css(myTextCss('tspan2',0,80,0,0));
		myLabel("btnprogx","bspan1",'正在运行程序：',8,10,0,0);
		myhref("btnprog","bspan1",'',8,100,0,0,'#','blank');
		myTextField('searchtext','bspan2','站内搜索：',70,3,0,0,300,'','');
		
 		$('#searchtext').textbox({
			buttonIcon:'locateIcon',
            onClickButton: function(e){
            	fn_search();
			}
		});		
		
 		$('#btncode').click(function(e){
 			fnDownLoad(); 		
 		});

 		$('#mnproject').click(function(e){
 			window.location.href='mybase/jQDemos.rar'; 		
 		});
 		$('#mnword').click(function(e){
 			//window.location.href=basepath+'mybase/textbook1.doc';
			var url='mybase/textbook1.doc';
			var targetfile='2015-jQuery实例教材';
			window.location.href='system//easyui_fileDownLoad.jsp?source='+url+'&target='+targetfile;
 			 		
 		});
 		$('#mnpdf').click(function(e){
 			//window.location.href=basepath+'mybase/textbook1.pdf';
			var url='mybase/textbook1.pdf';
			var targetfile='2015-jQuery实例教材';
			window.location.href='system//easyui_fileDownLoad.jsp?source='+url+'&target='+targetfile;
 		});
 		$('#mndatabase').click(function(e){
 			window.location.href='database.jsp';
 		});
		var item = $('#myTree1').tree('getRoot');
		var cnodes=$('#myTree1').tree('getChildren',item.target);
		//console.log(cnodes);
		//console.log(cnodes);
		$("#myTree1").tree('select', cnodes[0].target);
		
		//---------------------end of jquery------------------------
	});
	function fnDownLoad(){
		//var url=$("#progname").textbox("getValue");  //$("#btnexample").attr("href");
		var url=$("#mainframe").attr('src');
		//alert(url);
		var targetfile=url+'.txt';
		window.location.href='system//easyui_fileDownLoad.jsp?source='+url+'&target='+targetfile;
		/*
		var targetfile='system/temp/'+url+'.txt';
		result={};
		$.ajax({     
			type: "Post",     
			url: "system/easyui_doFiles.jsp",     
			//contentType: "application/json; charset=utf-8",     
			//dataType: "json", 
			data: {targetfile:targetfile, sourcefile:sourcefile, action:'copy'}, 
			async: false, method: 'post',   
			success: function(data) {     
				//返回的数据用data获取内容,直接复制到客户端数组source      
				eval("result="+data);
				//console.log(result.filename);
				//console.log(basepath);
				//if (result.filename!='') window.document.location.href=basepath+result.filename;
				if (result.filename!='') window.location.href=basepath+result.filename;
			}     
		});
		*/
		
		
		
	}
	function fn_search(){
		
	}
	
	function myTreeEvents(id,e,node){
		if (e=='onselect'){
			if (node){
				var url=node.url;
				if (url!=''){
					$("#mainframe").attr('src', url);
					//定义程序超链接
					$("#btnexample").text(node.text);
					$("#btnprog").text(node.url);
					$("#btnprog").attr("href",basepath+node.url); 
				} 
			}
		}
	}
</script>
</body>
</html>