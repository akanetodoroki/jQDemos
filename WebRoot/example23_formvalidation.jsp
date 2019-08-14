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
<form id='main' style="margin:0px 0px 0px 0px;">
</form>
<script>
	var now = new Date();
	today = now.getFullYear()+'-'+(now.getMonth()+1)+'-'+now.getDate();
	$(document).ready(function() {
		//example23_formvalidation.jsp
		document.onkeypress=myBanBackSpace;
		document.onkeydown=myBanBackSpace;		
		var jqsql={};  //sql语句中不能有双引号
		jqsql.party="select Pycode as id,description as party from dictionary where Type='党派'";
		jqsql.title="select Pycode as id,description as title from dictionary where Type='职称'";
		jqsql.province="select AreaID as provinceid,AreaName as province from Areas where level=1";
		jqsql.city="select AreaID as cityid,AreaName as city, parentnodeid as provinceid from Areas ";
		jqsql.degree="select Pycode as id,description as degree from dictionary where Type='学历'";
		myForm('myForm1','main','教师信息编辑',0,0,540,360,'');
		myTabs('myTab','myForm1','基本信息;联系信息;研究方向',0,0,0,0,'');
		//myTabForm('myTab','main','教师信息编辑','基本信息;联系信息;研究方向',0,0,530,366,'');
		myFieldset('myFieldset1','myTab1','基本信息',10,10,390,335);
		myFieldset('myFieldset2','myTab2','通信信息',10,10,260,335);
		myTextField('teacherid','myFieldset1','教师编码：',70,33*0+20,16,0,120,'20000551');
		myTextField('name','myFieldset1','姓名：',70,33*1+20,16,0,190,'诸葛亮');
		myTextField('pycode','myFieldset1','姓名拼音：',70,33*2+20,16,0,190,'');
		myComboField('gender','myFieldset1','性别：',70,33*3+20,16,0,120,'男;女','','autodrop');
		myDateField('birthdate','myFieldset1','出生日期：',70,33*4+20,16,0,120,'1961-11-12');
		myDBComboField('party','myFieldset1','党派：',70,33*5+20,16,0,160,jqsql.party,'party','','autodrop');
		myDBComboField('title','myFieldset1','职称：',70,33*6+20,16,0,160,jqsql.title,'title','','autodrop');
		myDBComboField('province','myFieldset1','籍贯：',70,33*7+20,16,0,160,jqsql.province,'province','','fnselect');
		myDBComboField('city','myFieldset1','',70,33*8+20,16,0,160,jqsql.city,'city','province(provinceid)','fnselect');
		myLabelField('provincex','myFieldset1','省',33*7+20+4,268,0,0);
		myLabelField('cityx','myFieldset1','市',33*8+20+4,268,0,0);
		myDBComboField('degree','myFieldset1','学历：',70,33*9+20,16,0,160,jqsql.degree,'degree','','autodrop');
		myTextField('graduate','myFieldset1','毕业院校：',70,33*10+20,16,0,230,'');
		myTextField('address','myFieldset2','家庭地址：',70,33*0+20,16,0,230,'浙江省杭州市西湖区');
		myTextField('mobile','myFieldset2','手机号码：',70,33*1+20,16,0,180,'');
		myTextField('homephone','myFieldset2','家庭电话：',70,33*2+20,12,0,180,'');
		myTextField('email','myFieldset2','Email：',70,33*3+20,16,0,180,'zxywolf@163.com','');
		myTextField('qq','myFieldset2','QQ号：',70,33*4+20,16,0,180,'857199052');
		myTextField('weixin','myFieldset2','微信号：',70,33*5+20,16,0,180,'zxywolf888');
		myTextField('homepage','myFieldset2','个人主页：',70,33*6+20,16,0,230,'http://www.jeasyui.com','');
		myCheckBoxGroup('research','myTab3','研究方向：',0,33*0+20,16,24,3,'[u110]企业管理;[110]区域经济学;[110]管理信息系统;[110]电子商务;[150]信息系统开发技术');
		//myCheckBoxField('research','myTab3','研究方向：',0,33*0+20,12,24,3,'[u120]企业管理');
		mySelectComboByIndex('province',6);  //调用函数设置选项初值
		
		//设置出生日期数据验证规则
		//设置email和主页的验证格式
		$("#email").textbox({validType:'email'});
		$("#homepage").textbox({validType:'url'});
		//利用扩展的validationbox
		$('#teacherid').textbox({
			validType:"integer"	//自定义验证规则名，下同	
		});
		$('#birthdate').datebox({
			validType:"date"		
		});
		$('#name').textbox({
			validType:"CHS"		
		});
		$('#pycode').textbox({
			validType:"english"		
		});
		//myForm1标题上添加按钮
		myButton("cmdcheck","myForm1",'提交',465,16,24,70,'','');
		myButton("cmdclear","myForm1",'清空',465,200,24,70,'','');
		myButton("cmdreset","myForm1",'重置',465,271,24,70,'','');
		$("#cmdcheck").on('click',function(){
			fnValidation();
		});
		$("#cmdclear").on('click',function(){
			myClearForm();
		});
		$("#cmdreset").on('click',function(){
			myreSetForm();
		});
		mySelectOnFocus();  //聚焦选中控件内容
		myKeyDownEvent('');
 		$("#teacherid").next("span").find("input").focus();
		$("#teacherid").textbox('readonly',false); 		
 		$("#teacherid").select();  //IE不支持
    }); 
    
    function fnonSelectCombo(id,record){
    	//console.log(record);
    }

	$.extend($.fn.validatebox.defaults.rules, {
		date: {
			validator: function(value, param){
				var now = new Date();
				var d1 = new Date('1949-10-01');
				var d2 = new Date(now.getFullYear(), now.getMonth(), now.getDate());
				var d3 = now.getFullYear()+'-'+now.getMonth()+'-'+now.getDate();
				return d1<=new Date(value) && new Date(value)<=d2;
				//var d1 = $.fn.datebox.defaults.parser(param[0]);
                   //var d2 = $.fn.datebox.defaults.parser(value);
                   //return d2<=d1;
               },
               message: '日期必须在1949-10-01与'+today+'之间！'
           },
		CHS:{  //验证汉字
			validator:function(value){
				return /^[\u0391-\uFFE5]+$/.test(value);
			},
			message:"教师姓名只能输入汉字！"
		},
		english : {// 验证英语 
			validator : function(value) { 
				return /^[A-Za-z]+$/i.test(value); 
			}, 
			message : '姓名拼音只能输入英文字符！'
		},
		integer : {// 验证整数 
			validator : function(value) { 
				return /^[+]?[1-9]+\d*$/i.test(value); 
			}, 
			message : '教师编码只能输入数字！' 
		}, 	             
	});
	
	function fnValidation(){
		var errormsg=[];  //存放数据验证发现的错误信息
		//先判断各个控件是否符合格式要求
		if (!$("#teacherid").textbox('isValid')) errormsg.push('教师编码输入错误！');
		if (!$("#name").textbox('isValid')) errormsg.push('教师姓名输入错误！');
		if (!$("#pycode").textbox('isValid')) errormsg.push('姓名拼音输入错误！');
		if (!$("#birthdate").datebox('isValid')) errormsg.push('出生日期输入错误！');
		if (!$("#email").textbox('isValid')) errormsg.push('Email地址格式错误！');
		if (!$("#homepage").textbox('isValid')) errormsg.push('个人主页格式错误！');
		//判断其他逻辑
		var s1=$("#teacherid").textbox('getValue');
		var s2=$("#name").textbox('getValue');
		var s3=$("#province").combobox('getText');
		var s4=$("#city").combobox('getText');
		if (s1.length==0) errormsg.push('教师编码不能为空！');
		if (s1.length!=8) errormsg.push('教师编码必须是8位数字！');
		else if (s1.substring(0,4)<'1970' || s1.substring(0,4)>now.getFullYear()){
			errormsg.push('教师编码前4位年份超出范围！');
		}
		if (s2.length==0) errormsg.push('教师姓名不能为空！');
		//验证编码是否重复，省份和城市是否存在 
		var sql="select * from teachers where teacherid='"+s1+"'";
		var result=myRunSelectSql(sysdatabasestring,sql);
		if (result.length>0){
			errormsg.push('教师编码重复！');
		}
		//eval("var record1="+$('#province').attr('xrecord'));  //自定义属性
		//var record2=jQuery.parseJSON($('#city').attr('xrecord'));  //自定义属性
		var sql1="select areaid as provinceid from areas where areaname='"+s3+"'";  
		//console.log(sql1);
		var result1=myRunSelectSql(sysdatabasestring,sql1);
		if (result1.length==0){
			errormsg.push('省份名称输入错误！');
		}else{
			var sql2="select 1 as n from areas where areaname='"+s4+"' and parentnodeid='"+result1[0].provinceid+"'";  
			console.log(sql2);
			var result2=myRunSelectSql(sysdatabasestring,sql2);
			//console.log(result2);
			if (result2.length==0){
				errormsg.push('城市名称输入错误！');
			}
		}
		//数据验证结束
		if (errormsg.length>0){
			var str='';
			for (var i=0;i<errormsg.length;i++){
				str+='<br>';
				if (i>0) str+='<span style="padding:0px 0px 0px 42px;">'+errormsg[i]+'</span>';
				else str+=errormsg[i];
			}
			$.messager.alert('系统提示','数据验证发现下列错误，提交失败！<br>'+str,'error');
			//myMessagebox('系统提示','数据验证发现下列错误，提交失败！',errormsg,'error');
		}	
	}  //fn	     
</script>
</body>
</html>