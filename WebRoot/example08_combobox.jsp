<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<!doctype html>
<html lang="en">
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
<div id='main' style="margin:0px 0px 0px 0px;">
</div>    
<script>
	$(document).ready(function() {
		myForm('myForm1','main','教师信息编辑',0,0,425,360,'close;drag');
		myFieldset('myFieldset1','myForm1','基本信息',8,10,375,335);
		myTextField('teacherid','myFieldset1','教师编码：',70,35*0+20,16,0,135,'D20101');
		myTextField('name','myFieldset1','姓名：',70,35*1+20,16,0,160,'诸葛亮');
		myTextField('pycode','myFieldset1','拼音：',70,35*2+20,16,0,160,'zhugeliang');
		myLabel('genderx','myFieldset1','性别：',35*3+20+3,16,0,0);
		myDateField('birthdate','myFieldset1','出生日期：',70,35*4+20,16,0,135,'5/12/1997');
		myLabel('partyx','myFieldset1','党派：',35*5+20+3,16);
		myLabel('titlex','myFieldset1','职称：',35*6+20+3,16);
		myLabel('degreex','myFieldset1','学历：',35*7+20+3,16);
		myLabel('cityx','myFieldset1','籍贯：',35*8+20+3,16);
		myTextField('school','myFieldset1','毕业院校：',70,35*9+20,16,0,230,'');
		var gendersource =[{"gender":"男"},{"gender":"女"}]; 
		var partysource =[{"party":"中共党员"},{"party":"民主党派"},{"party":"无党派"},{"party":"其他"}];
		var titlesource =[{"title":"教授"},{"title":"副教授"},{"title":"讲师"},{"title":"助教"},{"title":"其它"}];
		var degreesource =[{"degree":"博士研究生"},{"degree":"硕士研究生"},{"degree":"本科"},{"degree":"专科"},{"degree":"高中"},{"degree":"初中"},{"degree":"小学"},{"degree":"其它"}];
		var citysource=[{"cityid":"330100","city":"杭州市"},{"cityid":"330200","city":"宁波市"},{"cityid":"330300","city":"温州市"},{"cityid":"330400","city":"嘉兴市"},{"cityid":"330500","city":"湖州市"},{"cityid":"330600","city":"绍兴市"},{"cityid":"330700","city":"金华市"},{"cityid":"330800","city":"衢州市"},{"cityid":"330900","city":"舟山市"},{"cityid":"331000","city":"台州市"},{"cityid":"331100","city":"丽水市"}];
		$("#myFieldset1").append('<div style="position: absolute; top:125px; left:87px; width: 100px; padding-left: 4px;" id="gender_div"><input class="easyui-combobox" id="gender" style="padding:0px 6px 0px 6px" /></div>');
		$("#gender").combobox({
			width:135,
			panelHeight: 'auto',
			data: gendersource,
			valueField: 'gender',
			textField: 'gender'
		});

		$("#myFieldset1").append('<div style="position: absolute; top:195px; left:87px; width: 100px; padding-left: 4px;" id="party_div"><input class="easyui-combobox" id="party" style="padding:0px 6px 0px 6px" /></div>');
		$("#party").combobox({
			width:160,
			panelHeight: 'auto',
			data: partysource,
			valueField: 'party',
			textField: 'party'
		});
		
		$("#myFieldset1").append('<div style="position: absolute; top:230px; left:87px; width: 100px; padding-left: 4px;" id="title_div"><input class="easyui-combobox" id="title" style="padding:0px 6px 0px 6px" /></div>');
		$("#title").combobox({
			width:160,
			panelHeight: 'auto',
			data: titlesource,
			valueField: 'title',
			textField: 'title'
		});
		
		$("#myFieldset1").append('<div style="position: absolute; top:265px; left:87px; width: 100px; padding-left: 4px;" id="degree_div"><input class="easyui-combobox" id="degree" style="padding:0px 6px 0px 6px" /></div>');
		$("#degree").combobox({
			width:160,
			panelHeight: 120,
			data: degreesource,
			valueField: 'degree',
			textField: 'degree'
		});
		
		$("#myFieldset1").append('<div style="position: absolute; top:300px; left:87px; width: 100px; padding-left: 4px;" id="city_div"><input class="easyui-combobox" id="city" style="padding:0px 6px 0px 6px" /></div>');
		$("#city").combobox({
			width:160,
			panelHeight: 120,
			data: citysource,
			valueField: 'cityid',  //getValue下拉框中提取出来的值
			textField: 'city'  //下拉框显示的值
		});
		//firefox游览器位置调整
		if (sys.browser=='firefox'){
			$("#gender_div").css(myTextCss('myFieldset1',125,87,0,0));
			$("#party_div").css(myTextCss('myFieldset1',195,87,0,0));
			$("#title_div").css(myTextCss('myFieldset1',230,87,0,0));
			$("#degree_div").css(myTextCss('myFieldset1',265,87,0,0));
			$("#city_div").css(myTextCss('myFieldset1',300,87,0,0));
		}
		//设置combobox事件
		$("#degree").combobox({
			onChange:function(newvalue, oldvalue){
                //alert(newvalue+'----'+oldvalue);
			}
        });
		
		$("#city").combobox({
			onSelect: function(record) {  //选中事件
				if (record) {
					//alert(record.city+'---'+record.cityid+'---'+$("#city").combobox('getValue'));
				}
			}		
		});
		//设置下拉框初值
		$('#gender').combobox('select',gendersource[0].gender);
		$('#party').combobox('select',partysource[0].party);
		$('#title').combobox('select',titlesource[1].title);
		$('#degree').combobox('select',degreesource[2].degree);
		$('#city').combobox('select',citysource[0].city);
	}); 
        
    </script>
</body>
</html>