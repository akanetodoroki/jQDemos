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
	$(document).ready(function(){
		var studentsource=[
			{"stuid":"D2014540101","stuname":"贾宝玉","pycode":"jiabaoyu","gender":"男","birthdate":"1996-02-10","place":"浙江省杭州市"},
			{"stuid":"D2014540102","stuname":"林黛玉","pycode":"lindaiyu","gender":"女","birthdate":"1996-07-15","place":"浙江省温州市"},
			{"stuid":"D2014540103","stuname":"薛宝钗","pycode":"xuebaocha","gender":"女","birthdate":"1995-12-20","place":"浙江省绍兴市"}
		];
		myForm('myForm1','main','学生信息',0,0,315,520,'');
		myFieldset('myFieldset1','myForm1','基本信息',10,10,240,260);
		myLabelField('stuid','myFieldset1','学生学号：',36*0+25,12,0,0);
		myTextField('stuname','myFieldset1','学生姓名：',70,36*1+20,12,0,160);
		myTextField('pycode','myFieldset1','汉语拼音：',70,36*2+20,12,0,160,'');
		myDateField('birthdate','myFieldset1','出生日期：',70,36*3+20,12,0,120,'1997-2-17');
		myComboField('gender','myFieldset1','性别：',70,36*4+20,12,0,120,'男;女','');
		myTextField('place','myFieldset1','出生地：',70,36*5+20,12,0,160,8,2,'60.25','10','100');
		//myForm1标题上添加按钮
		$("#myForm1").panel({
			tools: [{
				iconCls:'downloadIcon',
				handler:function(){ fnDownLoad();}
		    },{
				iconCls:'downfileIcon',
				handler:function(){ fnDownFile();}
		    }]
		});
		
		//定义图片
		var str='<img id="image1" src="" style="position: absolute; top:18px; left:285px;"></img>';
		$("#myForm1").append($(str));
		//定义combobox
		$("#myFieldset1").append('<div style="position: absolute; top:22px; left:83px; width: 100px; padding-left: 4px;" id="stuid_div"><input class="easyui-combobox" id="stuid" style="padding:0px 6px 0px 6px" /></div>');
		$("#stuid_div").css(myTextCss('myFieldset1',22,83,0,0));
		$("#stuid").combobox({
			width:160,
			panelHeight: 'auto',
			editable: false,
			data: studentsource,
			valueField: 'stuid',
			textField: 'stuid',
			onSelect: function(record) {  //选中事件
				if (record){
					var src="system/images/"+record.stuid+".jpg";
					$("#image1").attr('src',src);
					$("#stuname").textbox("setValue",record.stuname);
					$("#pycode").textbox("setValue",record.pycode);
					$("#gender").textbox("setValue",record.gender);
					$("#birthdate").textbox("setValue",record.birthdate);
					$("#place").textbox("setValue",record.place);
					resizeImage('image1',src,234,225);
					var str='<div id="url" style="position: absolute; top:260px; left:360px;"><a href="mybase//'+record.stuid+'.doc">'+record.stuname+'</a>简介</div>';
					$("#url").remove();  //删除原来学生简介对应的旧链接
					//console.log(str);
					$("#myForm1").append($(str));
				}
			}
		});
		$('#stuid').combobox('select',studentsource[0].stuid);
	
		//定义函数
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
    function fnDownLoad(){  //超链接
		window.document.location.href='system/images/'+$("#stuid").combobox("getValue")+".jpg";    
    }

    function fnDownFile(){  //下载单个文件
    	var xsourcefilename=$("#image1").attr("src");
    	var xtargetfilename=$("#stuname").textbox("getValue")+".jpg";
		var url='system//easyui_fileDownLoad.jsp?source='+xsourcefilename+'&target='+xtargetfilename;
		window.location.href=url;
    }
    </script>
</body>
</html>