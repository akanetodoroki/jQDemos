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
		$("input:text").focus(function() { $(this).select(); } );		
		var jqsql={};  //sql语句中不能有双引号
		jqsql.party="select Pycode as id,description as party from dictionary where Type='党派'";
		jqsql.title="select Pycode as id,description as title from dictionary where Type='学历'";
		jqsql.province="select AreaID as provinceid,AreaName as province from Areas where level=1";
		jqsql.city="select AreaID as cityid,AreaName as city, parentnodeid as provinceid from Areas ";
		jqsql.degree="select Pycode as id,description as degree from dictionary where Type='学历'";
	
		myForm('myForm1','main','教师信息编辑',0,0,435,348,'close;drag');
		myFieldset('myFieldset1','myForm1','',8,10,385,325);
		myTextField('teacherid','myFieldset1','教师编码：',70,33*0+20,16,0,160,'D20101');
		myTextField('name','myFieldset1','姓名：',70,33*1+20,16,0,160,'诸葛亮');
		myTextField('pycode','myFieldset1','拼音：',70,33*2+20,16,0,160,'zhugeliang');
		myComboField('gender','myFieldset1','性别：',70,33*3+20,16,0,115,'男;女;take;task;book;buring','');
		myDateField('birthdate','myFieldset1','出生日期：',70,33*4+20,16,0,115,'5/12/1997');
		myLabelField('provinceidx','myFieldset1','出生地：',33*5+20+4,16,0,0);
		myLabelField('provincex','myFieldset1','省',33*5+20+5,260,0,0);
		myLabelField('cityx','myFieldset1','市',33*6+20+5,260,0,0);
		myLabelField('partyx','myFieldset1','党派：',33*7+20+4,16,0,0);
		myLabelField('titlex','myFieldset1','职称：',33*8+20+4,16,0,0);
		myLabelField('degreex','myFieldset1','学历：',33*9+20+4,16,0,0);
		myTextField('school','myFieldset1','毕业学校：',70,33*10+20,16,0,220,'');
		//定义其他下拉框
		var str=''; 
		str+='<div id="party_div"><input class="easyui-combobox" id="party"></div>';
		str+='<div id="title_div"><input class="easyui-combobox" id="title"></div>';
		str+='<div id="provinceid_div"><input class="easyui-combobox" id="provinceid"></div>';
		str+='<div id="cityid_div"><input class="easyui-combobox" id="cityid"></div>';
		str+='<div id="degree_div"><input class="easyui-combobox" id="degree"></div>';
		$("#myFieldset1").append($(str));
		$("#provinceid_div").css(myTextCss('myFieldset1',33*5+20,86,0,160));
		$("#cityid_div").css(myTextCss('myFieldset1',33*6+20,86,0,160));
		$("#party_div").css(myTextCss('myFieldset1',33*7+20,86,0,160));
		$("#title_div").css(myTextCss('myFieldset1',33*8+20,86,0,160));
		$("#degree_div").css(myTextCss('myFieldset1',33*9+20,86,0,180));
		$("#party").combobox({
			width:160,
			panelHeight: 'auto',
			valueField: 'party',
			textField: 'party'
		});		
		$("#title").combobox({
			width:160,
			panelHeight: 'auto',
			valueField: 'title',
			textField: 'title'
		});		
		$("#provinceid").combobox({
			width:160,
			panelHeight: 'auto',
			valueField: 'provinceid',
			textField: 'province'
		});		
		$("#cityid").combobox({
			width:160,
			panelHeight: 'auto',
			valueField: 'cityid',
			textField: 'city'
		});	
		$("#degree").combobox({
			width:160,
			panelHeight: 'auto',
			valueField: 'degree',
			textField: 'degree'
		});
		//四个下拉框取值	
		myGetComboxData('party',jqsql.party);
		myGetComboxData('title',jqsql.title);
		myGetComboxData('provinceid',jqsql.province);
		//myGetComboxData('cityid',jqsql.city);
		myGetComboxData('degree',jqsql.degree);
		//定义省份下拉框onselect事件
		$("#provinceid").combobox({
			onSelect: function(record) {  //定义选中事件
				if (record) {  //判断选项是否为空
					var xvalue = $("#provinceid").combobox('getValue');  //提取省份选项的值
					//确定城市选项取数的查询语句
					var sql="select * from ("+jqsql.city+") as p where provinceid='"+xvalue+"'";  
					//console.log(sql);
					$("#city").combobox('clear');  //清空城市下拉框中原来的选项
					myGetComboxData('cityid',sql);  //从数据库中提取新的城市选项
				}		
			}
		});
		
		$("#provinceid,#cityid").combobox({
			filter: function(q, row){
	       		var opts = $(this).combobox('options');
	       		q=q.toLowerCase();  //q为需要检索的值
	       		//var flag=row[opts.textField].indexOf(q) >= 0;
	          	var ss1=row[opts.textField].toLowerCase();
	       		var ss2=myGetMemoCode(ss1); //根据选项中的汉字产生首字母助记码
		   		var flag=0;
	       		var str=q.split(' ');  //多值之间用空格分隔
	       		for (var i=0;i<str.length;i++){
	       			if (str[i]!='') flag+=ss1.indexOf(str[i])>= 0;
	       			if (str[i]!='') flag+=ss2.indexOf(str[i])>= 0;
	       		}
	       		var str=q.split(';'); //多值之间也可以用分号分隔
	       		for (var i=0;i<str.length;i++){
	       			if (str[i]!='') flag+=ss1.indexOf(str[i])>= 0;
	       			if (str[i]!='') flag+=ss2.indexOf(str[i])>= 0;
	       		}
	       		return flag; //flag大于0，则输出显示该选项，否则不显示
	    	}
		});	

		//设置第一个选项（北京市）为初值
		var source=$("#provinceid").combobox('getData');
		if (source.length>0) $("#provinceid").combobox('select',source[0].provinceid);  //触发联动
		myKeyDownEvent('');
	});    
   
    </script>
</body>
</html>