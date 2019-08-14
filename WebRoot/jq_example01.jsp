<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<!doctype html>
<html lang="en">
<style type="text/css">
.input{ 
	padding-left: 4px; padding-right: 4px; padding-top: 3px; 
	padding-bottom: 3px; font-size: 13px;
}	

</style>
<head>
	<meta charset="utf-8">
	<link rel="stylesheet" href="jquery/css/jquery-ui.css" type="text/css" /> 
	<link rel="stylesheet" href="jquery/css/jquery.css" type="text/css" />
	<link rel="stylesheet" href="bootstrap/css/bootstrap-theme.min.css" type="text/css" />

	<script type="text/javascript" src="jquery/jquery-1.11.3.min.js"></script>
	<script type="text/javascript" src="jquery/jquery-ui-1.11.4.js"></script>
	<script type="text/javascript" src="bootstrap/js/bootstrap.min.js"></script>

	<script type="text/javascript" src="jquery/numeric.js"></script>
	<script type="text/javascript" src="system/jq_functions.js"></script>
  <script>
    $(document).ready(function() {
    //动态加载插件库
	//$.jqx.theme = 'bootstrap';
	//myDefineTabs('myTab','main','教师信息','基本信息;联系信息;研究方向;个人简历',10,10,266,670,true);
	//myDefinePanel('myPanel1','main','',39,4,220,280,true);
	//myDefinePanel('myPanel2','main','',39,300,220,360,true);
	//$('#myTab').jqxTabs('addLast','xxxx',''); 	
	//var t2=$('#myTab').append('<div id="myTab5"></div>');
	//console.log(t2);
	myTextField('text1','fieldset1','学号：',70,33*0+25,10,0,120,'D20101');
	myTextField('text2','fieldset1','姓名：',70,33*1+25,10,0,160,'祝锡永');
	myTextField('text3','fieldset1','拼音：',70,33*2+25,10,0,160,'zhu');
	//myStaticComboField('gender','fieldset1','性别：',70,33*3+25,10,0,135,'男;女','');
	myDateField('birthdate','fieldset1','出生日期：',70,33*4+25,10,0,135,'5/12/1997');
	myNumericField('weight', 'fieldset1','体重：',70,33*5+25,10,20,135,8,2,'60.25',0,0);
	myLabelField('label1', 'fieldset1','KG',33*5+25+5,232,0,0);
	/*
	myTextField('address','fieldset1','家庭地址：',70,33*0+15,10,0,260,'浙江省杭州市西湖区');
	myTextField('mobile','fieldset1','手机号码：',70,33*1+15,10,0,180,'');
	myTextField('homephone','fieldset1','家庭电话：',70,33*2+15,10,0,180,'');
	myTextField('email','fieldset1','Email：',70,33*3+15,10,0,180,'zxywolf@163.com');
	myTextField('qq','fieldset1','QQ号：',70,33*4+15,10,0,180,'zxywolf@163.com');
	myTextField('weixin','fieldset1','微信号：',70,33*5+15,10,0,180,'zxywolf@163.com');
	//myEditorField('notes','myTab4',33*5+15,10,233,0,'个人简介');
	console.log($('#qq').attr('data-theme'));
	*/
	
	
	$('#fieldset1').css({position: "absolute","top":45,"left":10, "width": 420, "height":300, "z-index":2});
	//$('#birthdate1').val("1997-1-3");
	//$('#birthdate').layout('resize', {width:80, height:300 });

	
/*	
 var gendersource = [{"gender":"男"},{"gender":"女"}];
$("#fieldset1").append("<label id=\"labelgender\" align=\"right\" style=\"font-size: 13px; font-family: 宋体; TOP: 118px; LEFT: 10px;  WIDTH: 70px; POSITION: absolute\">性别：</label>");
$("#fieldset1").append("<input class='easyui-combobox' id=\"gender\"+ \"\" />");
$("#gender").css("position": "absolute","top":114,"left":80, "width": 135, "z-index":2});
$("#gender").css("position","absolute");
$('#gender').combobox({    
    //url:'combobox_data.json',    
    valueField:'gender',    
    textField:'gender',
    data:gendersource   
}); 
*/

	
	//键盘处理
	$(document).keydown(function(e){
		var id=$("input:focus").attr("id");
		var $inp = $('input:text'); 
		$inp.bind('keydown', function(e) { 
		var key = e.which; 
		if (key == 13) { 
			e.preventDefault(); 
			var nxtIdx = $inp.index(this) + 1; 
			$(":input:text:eq(" + nxtIdx + ")").focus();    
		   /*
		   if (id=="datepicker2"){
		   }else if (id=="datepicker2"){
			alert(9);
			 $("#text1").focus(function(){  
					$("#datepicker2").val($("#datepicker2").val());    
					$("#datepicker2").focus();
			});		
			$("#text1").focus();
				return false;    
				
		   
		   }else if (id=="text1") $("#text2").focus();
		   else if (id=="text2") $("#datepicker1").focus();
		   */
		}
	})  
	});  
	

    
//------------------------------//    
});
  
</script>
</head>

<body class='default'>
    <div id='main'></div>
<form id="form-inline">
    <fieldset id='fieldset1' >
        <legend>教师个人信息</legend>
    </fieldset>
</form>
 
</body>
</html>	
