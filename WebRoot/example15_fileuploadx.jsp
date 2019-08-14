<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<html>
<style type="text/css">
</style>
<head>
	<meta charset="utf-8">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<link rel="stylesheet" type="text/css" href="jqeasyui/themes/default/easyui.me.css">
	<link rel="stylesheet" type="text/css" href="jqeasyui/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="system/css/icon.css">
    <script type="text/javascript" src="jqeasyui/jquery.min.js"></script>
    <script type="text/javascript" src="jqeasyui/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="jqeasyui/easyui-lang-zh_CN.js"></script>	
	<script type="text/javascript" src="system/easyui_functions.js"></script>
</head>
<body style="margin: 2px 2px 2px 2px;">
<form id="main" style="margin:2px 2px 2px 2px;">
	
</form>
<script>
	var photopath='<%=basePath %>'+'mybase/students/';
	$(document).ready(function(){
		var studentsource=[
			{"stuid":"D2014540101","stuname":"贾宝玉","pycode":"jiabaoyu","gender":"男","birthdate":"1996-02-10","place":"浙江省杭州市"},
			{"stuid":"D2014540102","stuname":"林黛玉","pycode":"lindaiyu","gender":"女","birthdate":"1996-07-15","place":"浙江省温州市"},
			{"stuid":"D2014540103","stuname":"薛宝钗","pycode":"xuebaocha","gender":"女","birthdate":"1995-12-20","place":"浙江省绍兴市"}
		];
		myForm('myForm1','main','学生信息',0,0,330,525,'');
		myFieldset('myFieldset1','myForm1','基本信息',10,10,240,255);
		myFieldset('myFieldset2','myForm1','',17,285,233,220);
		myLabelField('stuid','myFieldset1','学生学号：',36*0+25,12,0,0);
		myTextField('stuname','myFieldset1','学生姓名：',70,36*1+20,12,0,160);
		myTextField('pycode','myFieldset1','汉语拼音：',70,36*2+20,12,0,160,'');
		myDateField('birthdate','myFieldset1','出生日期：',70,36*3+20,12,0,120,'1997-2-17');
		myComboField('gender','myFieldset1','性别：',70,36*4+20,12,0,120,'男;女','');
		myTextField('place','myFieldset1','出生地：',70,36*5+20,12,0,120,8,2,'60.25','10','100');
		//定义图片
		var str='<img id="image1" src="" style="border:false; position:absolute; top:1px; left:1px; width:224; height:230;"></img>';
		$("#myFieldset2").append($(str));
		//定义combobox
		$("#myFieldset1").append('<div style="position: absolute; top:22px; left:83px; padding-left: 4px;" id="stuid_div"><input class="easyui-combobox" id="stuid" style="padding:0px 6px 0px 6px" /></div>');
		$("#stuid").combobox({
			width:160,
			panelHeight: 'auto',
			editable: false,
			data: studentsource,
			valueField: 'stuid',
			textField: 'stuid',
			onSelect: function(record) {  //选中事件
				if (record){
					var src=photopath+$("#stuid").combobox("getValue")+'.jpg?timestemp='+new Date().getTime();
					console.log(src);
					$("#image1").attr('src',src);
					$("#stuname").textbox("setValue",record.stuname);
					$("#pycode").textbox("setValue",record.pycode);
					$("#gender").textbox("setValue",record.gender);
					$("#birthdate").textbox("setValue",record.birthdate);
					$("#place").textbox("setValue",record.place);
					resizeImage('image1',src,230,224);
					//$("#myForm1").append($(str));
				}
			}
		});
		$('#stuid').combobox('select',studentsource[0].stuid);
		//定义文件上传控件
		$("#myForm1").append('<input type="file" id="file1" style="position: absolute; top:260px; left:16px; width: 200px; padding-left: 4px;" />');
		myButton('btnupload','myForm1','上传',260,435,25,65,'uploadIcon','');
		$('#file1').bind('change',function(v){
			var filename = $("#file1").val();
			if (filename=='')  $("#btnupload").linkbutton('disable');
			else $("#btnupload").linkbutton('enable');
		});
		//定义事件		
		$('#btnupload').bind('click',function(e){
			fnUpload();
		});
		
		//以下为函数
	    function fnUpload(){  //下载多个文件
	 		var targetname = $("#stuid").combobox("getValue");
	 		var filename=$("#file1").val();
	 		var fileext=filename.substring(filename.lastIndexOf(".")+1,255).toLowerCase();//文件扩展名
	 		//alert(filename+'---'+fileext);
	 		if (fileext.toLowerCase()=='jpg'){ //本地限制上传文件类型，服务器端程序不作限制
	 			var form = new FormData(); 
				var xhr = new XMLHttpRequest(); //XMLHttpRequest 对象
				xhr.open("post", "system//fn_fileUpLoad.jsp?filename="+filename+"&targetname="+targetname+"&targetpath=mybase/students", true);
				xhr.onload = function () {
					if(xhr.status == 200){    
						var data = JSON.parse(xhr.responseText);   
						if (data.error == 0) {  
							//上传成功
							//var src='${pageContext.request.contextPath}/images/head.jpg?timestemp='+new Date().getTime();
							var src=photopath+data.targetfile+'?timestemp='+new Date().getTime();
							$("#image1").attr('src',src);
							resizeImage('image1',src,230,224);
							$.messager.show({
								title:'系统提示',
								width:200,
								msg:'文件已经上传成功!',
								timeout:2000,
								showType:'slide'
							}); 
							$("#btnupload").linkbutton('disable');
							console.log('文件上传成功!'+src+'，文件大小：'+data.filesize);
						}else{
							$.messager.alert('系统提示','文件上传失败！','error');
							console.log(data.message);	        		
						}
						$("#file1").val('');
					} 
				};
				xhr.send(form);
			}else{
				$.messager.alert('系统提示','文件类型选择错误，必须是JPG文件！','info');
			}
	    }
    
    		
		//图形缩放函数
		function resizeImage(img,src,winheight,winwidth){
			var image=new Image();
			image.src=src;
			image.onload=function() {  //必须放在onload事件中
				var aheight=image.height+0;  
				var awidth=image.width+0;
				if (awidth>0 && aheight>0) {
					//调整图片大小,按比例缩放
					var Ratio = 1; 
					var wRatio = winwidth / awidth; 
					var hRatio = winheight / aheight; 
					if (wRatio<1 || hRatio<1){ 
						Ratio = (wRatio<=hRatio?wRatio:hRatio); 
					} 
					if (Ratio!=0){ 
						awidth = awidth * Ratio; 
						aheight = aheight * Ratio; 
					}
					$("#image1").css({width:awidth, height:aheight});
				}
			};
			return {};				
		}		
    });
     
    </script>
</body>
</html>