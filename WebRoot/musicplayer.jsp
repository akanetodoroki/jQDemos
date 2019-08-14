<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title></title>
    
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
  	<div id="left" class="easyui-panel" data-options="region:'west',spilt:true, border:false" style="overflow:auto; background-color: #E0ECFF; width:300px; padding: 1px 1px 1px 10px;">
  	</div>
  	<div id="middle" class="easyui-panel"  data-options="region:'center', split:true" style="overflow:auto;">
  	</div>
  </body>
  
  <script>
  $(document).ready(function() {
	
	 var musicsource=[{"musicid":"01","musicname":"Again","musicfile":"suibian"},
	                  {"musicid":"02","musicname":"Eutopia","musicfile":"suibian"},
	                  {"musicid":"03","musicname":"Ur-Style","musicfile":"suibian"},
	                  {"musicid":"04","musicname":"Again","musicfile":"suibian"},
	                  {"musicid":"05","musicname":"Eutopia","musicfile":"suibian"},
	                  {"musicid":"06","musicname":"Ur-Style","musicfile":"suibian"},
	                  {"musicid":"07","musicname":"Again","musicfile":"suibian"},
	                  {"musicid":"08","musicname":"Eutopia","musicfile":"suibian"},
	                  {"musicid":"09","musicname":"Ur-Style","musicfile":"suibian"},
	                  {"musicid":"10","musicname":"Again","musicfile":"suibian"},
	                  {"musicid":"11","musicname":"Eutopia","musicfile":"suibian"},
	                  {"musicid":"12","musicname":"Ur-Style","musicfile":"suibian"},
	                  {"musicid":"13","musicname":"Again","musicfile":"suibian"},
	                  {"musicid":"14","musicname":"Eutopia","musicfile":"suibian"},
	                  {"musicid":"15","musicname":"Ur-Style","musicfile":"suibian"},
	                  {"musicid":"16","musicname":"Again","musicfile":"suibian"},
	                  {"musicid":"17","musicname":"Eutopia","musicfile":"suibian"},
	                  {"musicid":"18","musicname":"Ur-Style","musicfile":"suibian"},
	                  {"musicid":"19","musicname":"Eutopia","musicfile":"suibian"},
	                  {"musicid":"20","musicname":"Ur-Style","musicfile":"suibian"}
	 ];
	 var str='<div id="musiclist" class="easyui-datalist" title="音乐列表"  data-options="fit:true" style=""></div>';
		$("#left").append($(str));
		$('#musiclist').datalist({
		    checkbox: true,
		    lines: true,
		    data:musicsource,
		    valueField:'musicid',
		    textField:'musicname',
		    onSelect:function(i){
		    	var src="mybase/"+musicsource[i].musicname+".mp3";
		    	$("#main_audio1").attr('src',src);
		    }
		});
		/*$.ajax({     
			type: "Post",     
			url: "system/easyui_execSelect.jsp",     
			//contentType: "application/json; charset=utf-8",     
			//dataType: "json", 
			data: {database: 'jqdemos', selectsql: sql1}, 
			async: false, method: 'post',    
			success: function(data) {     
				//返回的数据用data获取内容,直接复制到客户端数组source      
				var source=eval(data); 
				$('#booklist').datalist({
				    data: source,
				    textField:'bookname',
					valueField:'bookid',
				    checkbox: true,
				    lines: true,
				    onSelect: function (index,row){
						sql="select * from mybooks where bookid='"+row.bookid+"'";
						results=myRunSelectSql('jqdemos',sql);
						mySetFormValues(fieldset,results[0]);
						mySetReadonly(fieldset,true);
						$("#addoredit").val('edit');
					}
				});
			},         
		});*/ 
	 str='<audio id="main_audio1" src="mybase/Again.mp3" autoplay="autoplay" loop="true" controls="controls"  preload="auto" '+
	    'style="position:absolute; top:50px;left:140px; width:400px;"></audio>'
	 $("#middle").append($(str));
	
  /*function myownfunction(i){
	  var musicsource=[{"musicid":"01","musicname":"Again","musicfile":"suibian"},
		                  {"musicid":"02","musicname":"Eutopia","musicfile":"suibian"},
		                  {"musicid":"03","musicname":"Ur-Style","musicfile":"suibian"},
		                  {"musicid":"04","musicname":"Again","musicfile":"suibian"},
		                  {"musicid":"05","musicname":"Eutopia","musicfile":"suibian"},
		                  {"musicid":"06","musicname":"Ur-Style","musicfile":"suibian"},
		                  {"musicid":"07","musicname":"Again","musicfile":"suibian"},
		                  {"musicid":"08","musicname":"Eutopia","musicfile":"suibian"},
		                  {"musicid":"09","musicname":"Ur-Style","musicfile":"suibian"},
		                  {"musicid":"10","musicname":"Again","musicfile":"suibian"},
		                  {"musicid":"11","musicname":"Eutopia","musicfile":"suibian"},
		                  {"musicid":"12","musicname":"Ur-Style","musicfile":"suibian"},
		                  {"musicid":"13","musicname":"Again","musicfile":"suibian"},
		                  {"musicid":"14","musicname":"Eutopia","musicfile":"suibian"},
		                  {"musicid":"15","musicname":"Ur-Style","musicfile":"suibian"},
		                  {"musicid":"16","musicname":"Again","musicfile":"suibian"},
		                  {"musicid":"17","musicname":"Eutopia","musicfile":"suibian"},
		                  {"musicid":"18","musicname":"Ur-Style","musicfile":"suibian"},
		                  {"musicid":"19","musicname":"Eutopia","musicfile":"suibian"},
		                  {"musicid":"20","musicname":"Ur-Style","musicfile":"suibian"}
		 ];
	  var src="mybase/"+musicsource[i].musicname+".mp3";
	  $("#main_audio1").attr('src',src);
  
  	}*/
  });
  </script>
</html>
