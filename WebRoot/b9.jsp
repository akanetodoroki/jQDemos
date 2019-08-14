<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<html>
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
<div id="main" style="margin:2px 2px 2px 2px;">
<a href="#" id="savebutton" class="easyui-linkbutton" iconCls="icon-save">Save</a>
</div>
<script>
	$(function(){
		var studentsource=[
			{"bookid":"9787020002207","bookname":"红楼梦","pycode":"hongloumeng","category":"文学","releasedate":"2003-01-01","writer":"曹雪芹","price":"33.6","press":"人民文学出版社","baozhuang":"平装"},
			{"bookid":"9787550292505","bookname":"牛奶可乐经济学","pycode":"keleniunaijingjixue","category":"经济","releasedate":"2017-01-01","writer":"罗伯特·弗兰克","price":"30.0","press":"北京联合出版公司","baozhuang":"平装"},
			{"bookid":"9787544547642","bookname":"名侦探柯南90","pycode":"mingzhentankenan90","category":"动漫/幽默 ","releasedate":"2017-03-01","writer":"青山刚昌","price":"9.0","press":"长春出版社","baozhuang":"平装"},
			{"bookid":"9787122260598","bookname":"摄影入门：拍出美照超简单","pycode":"sheyingrumen","category":"艺术","releasedate":"2003-01-01","writer":"乔旭亮","price":"24.9","press":"化学工业出版社","baozhuang":"平装"},
			{"bookid":"9787559313607","bookname":"隐世之国·境","pycode":"yingshizhiyi","category":"艺术","releasedate":"2017-01-01","writer":"鹿菏","price":"52.4","press":"黑龙江美术出版社","baozhuang":"平装"},
			{"bookid":"9787566912602","bookname":"之禾的秘密","pycode":"zhihedemimi","category":"艺术","releasedate":"2003-01-01","writer":"洪晃","price":"89.0","press":"东华大学出版社","baozhuang":"平装"},
			{"bookid":"9787520401005","bookname":"孤独星球","pycode":"guduxingqiu","category":"旅游","releasedate":"2017-01-01","writer":"澳大利亚Lonely Planet公司","price":"64.3","press":"中国地图出版社","baozhuang":"平装"},
			{"bookid":"9787508639611","bookname":"人生就是边玩边学","pycode":"hongloumeng","category":"旅游","releasedate":"2003-01-01","writer":"李欣频","price":"19.7","press":"中信出版社","baozhuang":"平装"},
			{"bookid":"9787547705933","bookname":"背包中国","pycode":"beibaozhongguo","category":"旅游","releasedate":"2017-01-01","writer":"一凡","price":"24.0","press":"北京日报出版社（原同心出版社）","baozhuang":"平装"},
			{"bookid":"9787514347692","bookname":"行为心理学","pycode":"xingweixinlixue","category":"心理","releasedate":"2003-01-01","writer":"[美]华生","price":"20.6","press":"现代出版社","baozhuang":"平装"},
			{"bookid":"9787532769186","bookname":"逃避自由","pycode":"taobiziyou","category":"心理","releasedate":"2017-01-01","writer":"[美]弗洛姆","price":"20.8","press":"上海译文出版社","baozhuang":"平装"}
		];//修改书本编码，与此同时将与之对应的书本图片的名字改为书本编码.jpg
		
		
		myWindow('myWin1','JSon格式数据',10,400,200,520,'','close');
		myTextareaField('xformvalues','myWin1','',0,2,1,152,482,'','');	
		myForm('myForm1','main','书本信息',0,0,500,740,'');
		myFieldset('myFieldset1','myForm1','基本信息',10,400,430,280);
		myFieldset('myFieldset2','myForm1','图书',10,10,430,280);
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
		//定义书本对应的下拉框combobox
		var str='<div id="bookid_div" style="border:0px;">';
		str+='<div class="easyui-combobox" id="bookid" style="padding:0px 6px 0px 6px" ></div>';
		str+='</div>';
		str+='<label id="kaibenx"><input checked="true" class="radio" value="16" name="kaiben" type="radio"/>16开&nbsp;&nbsp;&nbsp;<input class="radio" value="32" name="kaiben" type="radio"/>32开</label>';
		str+='<div id="button"><input type="button" id="submit" value="确定" style="width:60px"/><input type="button" id="cancel" value="取消" style="width:60px;margin-left:10px;"/></div>';
		//也可以用myButton函数
		$("#myFieldset1").append($(str));

		$("#price").numberbox({precision:1, max:200, min:0});

		$("#kaibenx").css({position:'absolute',top:'306px',left:'84px'});
		
		$("#button").css({position:'absolute',top:'390px',left:'80px'});

		for(var i=0;i<studentsource.length;i++){
		str='<a id="myfoucs" href="javascript:myownfunction('+i+')" style="position:absolute;top:'+(i*30+20)+'px;left:30px;">'+studentsource[i].bookid+'&nbsp;'+studentsource[i].bookname+'</a>';
		$("#myFieldset2").append($(str));
		}

		
    });
	function myownfunction(i){
		var studentsource=[
		       			{"bookid":"9787020002207","bookname":"红楼梦","pycode":"hongloumeng","category":"文学","releasedate":"2003-01-01","writer":"曹雪芹","price":"33.6","press":"人民文学出版社","baozhuang":"平装"},
		       			{"bookid":"9787550292505","bookname":"牛奶可乐经济学","pycode":"keleniunaijingjixue","category":"经济","releasedate":"2017-01-01","writer":"罗伯特·弗兰克","price":"30.0","press":"北京联合出版公司","baozhuang":"平装"},
		       			{"bookid":"9787544547642","bookname":"名侦探柯南90","pycode":"mingzhentankenan90","category":"动漫/幽默 ","releasedate":"2017-03-01","writer":"青山刚昌","price":"9.0","press":"长春出版社","baozhuang":"平装"},
		       			{"bookid":"9787122260598","bookname":"摄影入门：拍出美照超简单","pycode":"sheyingrumen","category":"艺术","releasedate":"2003-01-01","writer":"乔旭亮","price":"24.9","press":"化学工业出版社","baozhuang":"平装"},
		       			{"bookid":"9787559313607","bookname":"隐世之国·境","pycode":"yingshizhiyi","category":"艺术","releasedate":"2017-01-01","writer":"鹿菏","price":"52.4","press":"黑龙江美术出版社","baozhuang":"平装"},
		       			{"bookid":"9787566912602","bookname":"之禾的秘密","pycode":"zhihedemimi","category":"艺术","releasedate":"2003-01-01","writer":"洪晃","price":"89.0","press":"东华大学出版社","baozhuang":"平装"},
		       			{"bookid":"9787520401005","bookname":"孤独星球","pycode":"guduxingqiu","category":"旅游","releasedate":"2017-01-01","writer":"澳大利亚Lonely Planet公司","price":"64.3","press":"中国地图出版社","baozhuang":"平装"},
		       			{"bookid":"9787508639611","bookname":"人生就是边玩边学","pycode":"hongloumeng","category":"旅游","releasedate":"2003-01-01","writer":"李欣频","price":"19.7","press":"中信出版社","baozhuang":"平装"},
		       			{"bookid":"9787547705933","bookname":"背包中国","pycode":"beibaozhongguo","category":"旅游","releasedate":"2017-01-01","writer":"一凡","price":"24.0","press":"北京日报出版社（原同心出版社）","baozhuang":"平装"},
		       			{"bookid":"9787514347692","bookname":"行为心理学","pycode":"xingweixinlixue","category":"心理","releasedate":"2003-01-01","writer":"[美]华生","price":"20.6","press":"现代出版社","baozhuang":"平装"},
		       			{"bookid":"9787532769186","bookname":"逃避自由","pycode":"taobiziyou","category":"心理","releasedate":"2017-01-01","writer":"[美]弗洛姆","price":"20.8","press":"上海译文出版社","baozhuang":"平装"}
		       		];
		$("#bookid").textbox("setValue",studentsource[i].bookid);
		$("#bookname").textbox("setValue",studentsource[i].bookname);
        $("#pycode").textbox("setValue",studentsource[i].pycode);
        $("#category").textbox("setValue",studentsource[i].category);
        $("#releasedate").textbox("setValue",studentsource[i].releasedate);
        $("#writer").textbox("setValue",studentsource[i].writer);
        $("#price").textbox("setValue",studentsource[i].price);
        $("#press").textbox("setValue",studentsource[i].press);
        $("#baozhuang").textbox("setValue",studentsource[i].baozhuang);
        $("#savebutton").click(function(){
        	studentsource[i].bookid=$("#bookid").val();
        });
	};
	
</script>
</body>
</html>