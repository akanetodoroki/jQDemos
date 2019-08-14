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
</div>
<script>
	$(function(){
		var studentsource=[
			{"stuid":"D2014540101","stuname":"贾宝玉","pycode":"jiabaoyu","gender":"男","birthdate":"1996-02-10","place":"浙江省杭州市"},
			{"stuid":"D2014540102","stuname":"林黛玉","pycode":"lindaiyu","gender":"女","birthdate":"1996-07-15","place":"浙江省温州市"},
			{"stuid":"D2014540103","stuname":"薛宝钗","pycode":"xuebaocha","gender":"女","birthdate":"1995-12-20","place":"浙江省绍兴市"}
		];
		myForm('myForm1','main','学生信息',0,0,315,540,'');
		myFieldset('myFieldset1','myForm1','基本信息',10,10,240,280);
		myLabel('stuidx','myFieldset1','学生学号：',36*0+25,12,0,0);
		myTextField('stuname','myFieldset1','学生姓名：',70,36*1+20,12,0,175);
		myTextField('pycode','myFieldset1','汉语拼音：',70,36*2+20,12,0,175,'');
		myDateField('birthdate','myFieldset1','出生日期：',70,36*3+20,12,0,120,'1997-2-17');
		myComboField('gender','myFieldset1','性别：',70,36*4+20,12,0,120,'男;女','');
		myTextField('place','myFieldset1','出生地：',70,36*5+20,12,0,175,'');
		//定义学号对应的下拉框combobox
		str='<div id="stuid_div" style="border:0px;">';
		str+='<div class="easyui-combobox" id="stuid" style="padding:0px 6px 0px 6px" ></div>';
		str+='</div>';
		$("#myFieldset1").append($(str));
		$("#stuid_div").css({position:'absolute',top:'24px', left:'86px'});
		$("#stuid").combobox({
			width:175,
			panelHeight: 'auto',
			editable: false,
			data: studentsource,
			valueField: 'stuid',
			textField: 'stuid'
		});
		//定义图片
		var str='<img id="image1" src="" style="position: absolute; top:18px; left:305px;"></img>';
		str+='<div style="position: absolute; top:230px; left:305px; width:200px;">';
		str+='<input id="slider1" class="easyui-slider" value="0" ></div>';
		$("#myForm1").append($(str));
		//定义slider
		$("#slider1").slider({
			showTip: true,
			min:1,
            max:100,
            rule: [0,'|',25,'|',50,'|',75,'|',100],
            tipFormatter: function(value){
                return value;
            }
		});
		//定义下拉框的onselect事件
		$("#stuid").combobox({
			onSelect: function(record) {  //选中事件
				if (record){
					$("#stuname").textbox("setValue",record.stuname);
					$("#pycode").textbox("setValue",record.pycode);
					$("#gender").textbox("setValue",record.gender);
					$("#birthdate").textbox("setValue",record.birthdate);
					$("#place").textbox("setValue",record.place);
					$("#slider1").slider('setValue',30);
					var src="system/images/"+record.stuid+".jpg";
					$("#image1").attr('src',src);
					resizeImage('image1',src);
				}
			}
		});
		//定义slider1的onchange事件
		$("#slider1").slider({
		    onChange: function(value){
            	var src=$("#image1").attr("src");
            	resizeImage('image1',src,value);
           }
		});
		//设置初值
		$("#slider1").slider('setValue',30);
		$('#stuid').combobox('select',studentsource[0].stuid);
		
		//定义图片缩放函数
		function resizeImage(img,src){
			var image=new Image();
			image.src=src;
			ratio=$("#slider1").val()/100.0; 			
			image.onload=function() {  //必须放在onload事件中
				var aheight=image.height+0;  
				var awidth=image.width+0;
				//调整图片大小,按比例缩放
				if (ratio!=0){ 
					awidth = awidth * ratio; 
					aheight = aheight * ratio; 
					$("#image1").css({width: awidth, height: aheight});
				}
			}
		}	
    });
</script>
</body>
</html>