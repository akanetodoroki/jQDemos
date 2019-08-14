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
		<div id="middlelayout" class="easyui-layout" data-options="fit:true">
			<div id='middlebottom' data-options="region:'north', split:true, border:false"  style="overflow:hidden; height:20px;"></div>
			<div id='middletop' class='easyui-panel' data-options="region:'center',split:true, border:false" style="overflow:hidden">
			</div>
			<div id='bottom' class='easyui-panel' data-options="region:'south'" style="height:35px; overflow:auto; padding:8px 0px 0px 20px;"></div>
		</div>
	</div>
<script>
	$(document).ready(function() {
		

		var xsql="select bookid,bookname,pycode,category,releasedate,writer,price,press,baozhuang from mybooks";
		var studentsource=myRunSelectSql('jqdemos',xsql);
		myForm('myForm1','middletop','书本信息',0,0,500,740,'');
		myFieldset('myFieldset1','myForm1','基本信息',10,200,430,280);
		myTextField('bookid','myFieldset1','书本编码：',70,36*0+20,12,0,175);
		myTextField('bookname','myFieldset1','书本名称：',70,36*1+20,12,0,175);
		myTextField('pycode','myFieldset1','汉语拼音：',70,36*2+20,12,0,175,'');
		myDateField('releasedate','myFieldset1','出版日期：',70,36*3+20,12,0,120,'1997-2-17');
		myComboField('category','myFieldset1','类别：',70,36*4+20,12,0,120,'文学;艺术;动漫/幽默 ;娱乐时尚;旅游;心理;管理;经济','');
		myTextField('writer','myFieldset1','作者：',70,36*5+20,12,0,175,'');
		myNumberField('price','myFieldset1','价格：',70,36*6+20,12,0,45,'');
		myTextField('press','myFieldset1','出版社：',70,36*7+20,12,0,175,'');
		myLabel('kaiben','myFieldset1','开本：',36*8+20,12,0,0);
		myTextField('baozhuang','myFieldset1','包装：',70,36*9+20,12,0,175,'');
		
		var str='<ul id="booklist" class="easyui-datalist" title="书本列表"  data-options="fit:true" style=""></ul>';
		$("#left").append($(str));
		$('#booklist').datalist({
		    url: studentsource,
		    checkbox: true,
		    lines: true
		});
		console.log($(str));
		
		
		for(var i=0;i<studentsource.length;i++){
			str='<li id="myfocus" onclick="myownfunction('+i+')" style="position:absolute;top:'+(i*40+50)+'px;left:30px;">'+studentsource[i].bookid+'&nbsp;'+studentsource[i].bookname+'</li>';
			$("#left").append($(str));
			}
		$("li").css({'list-style-type':'none'});
		//实时显示系统当前时间
		setInterval(function() {
		    var now = (new Date()).toLocaleString();
		    $('#bottom').text("系统当前时间："+now);
		},1000);

	});
	function myownfunction(i){
		var xsql="select bookid,bookname,pycode,category,releasedate,writer,price,press,baozhuang from mybooks";
		var studentsource=myRunSelectSql('jqdemos',xsql);
		$("#bookid").textbox("setValue",studentsource[i].bookid);
		$("#bookname").textbox("setValue",studentsource[i].bookname);
        $("#pycode").textbox("setValue",studentsource[i].pycode);
        $("#category").textbox("setValue",studentsource[i].category);
        $("#releasedate").textbox("setValue",studentsource[i].releasedate);
        $("#writer").textbox("setValue",studentsource[i].writer);
        $("#price").textbox("setValue",studentsource[i].price);
        $("#press").textbox("setValue",studentsource[i].press);
        $("#baozhuang").textbox("setValue",studentsource[i].baozhuang);
	};

</script>
</body>
</html>