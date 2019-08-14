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
<body style="margin: 1px 1px 1px 1px;">
<div id='main' style="margin:0px 0px 0px 0px;">
</div>
<script>
	$(document).ready(function() {
		//example22_setformvalues.jsp
		document.onkeypress=myBanBackSpace;
		document.onkeydown=myBanBackSpace;		
		var jqsql={};  //sql语句中不能有双引号
		jqsql.party="select Pycode as id,description as party from dictionary where Type='党派'";
		jqsql.title="select Pycode as id,description as title from dictionary where Type='职称'";
		jqsql.province="select AreaID as provinceid,AreaName as province from Areas where level=1";
		jqsql.city="select AreaID as cityid,AreaName as city, parentnodeid as provinceid from Areas ";
		jqsql.degree="select Pycode as id,description as degree from dictionary where Type='学历'";
		myForm('myForm1','main','教师信息编辑',0,0,485,375,'');
		myTabs('myTab','myForm1','基本信息;联系信息;研究方向',0,0,0,0,'');
		myFieldset('myFieldset1','myTab1','基本信息',10,10,395,345);
		myFieldset('myFieldset2','myTab2','通信信息',10,10,225,345);
		myTextField('teacherid','myFieldset1','教师编码：',70,33*0+20,16,0,120,'20000551');
		myTextField('name','myFieldset1','姓名：',70,33*1+20,16,0,190,'诸葛亮');
		myTextField('pycode','myFieldset1','拼音：',70,33*2+20,16,0,190,'');
		myComboField('gender','myFieldset1','性别：',70,33*3+20,16,0,120,'男;女','');
		myDateField('birthdate','myFieldset1','出生日期：',70,33*4+20,16,0,120,'5/12/1961');
		myDBComboField('party','myFieldset1','党派：',70,33*5+20,16,0,160,jqsql.party,'party','');
		myDBComboField('title','myFieldset1','职称：',70,33*6+20,16,0,160,jqsql.title,'title','');
		myDBComboField('province','myFieldset1','籍贯：',70,33*7+20,16,0,160,jqsql.province,'province','');
		myDBComboField('city','myFieldset1','',70,33*8+20,16,0,160,jqsql.city,'','province(provinceid)');
		myLabelField('provincex','myFieldset1','省',33*7+20+4,268,0,0);
		myLabelField('cityx','myFieldset1','市',33*8+20+4,268,0,0);
		myDBComboField('degree','myFieldset1','学历：',70,33*9+20,16,0,160,jqsql.degree,'degree','');
		myTextField('graduate','myFieldset1','毕业院校：',70,33*10+20,16,0,235,'');
		myTextField('address','myFieldset2','家庭地址：',70,33*0+20,12,0,235,'浙江省杭州市西湖区');
		myTextField('mobile','myFieldset2','手机号码：',70,33*1+20,12,0,180,'');
		myTextField('homephone','myFieldset2','家庭电话：',70,33*2+20,12,0,180,'');
		myTextField('email','myFieldset2','Email：',70,33*3+20,12,0,180,'zxywolf@163.com');
		myTextField('qq','myFieldset2','QQ号：',70,33*4+20,12,0,180,'857199052');
		myTextField('weixin','myFieldset2','微信号：',70,33*5+20,12,0,180,'zxywolf888');
		myCheckBoxGroup('research','myTab3','研究方向：',0,33*0+20,12,24,3,'[u110]企业管理;[110]区域经济学;[110]管理信息系统;[110]电子商务;[150]信息系统开发技术');
		mySetComboxByIndex('province',0);  //调用函数设置选项初值
		//myForm1标题上添加按钮
		$("#myTab").tabs({
			tools: [{
				iconCls:'refreshIcon',
				handler:function(){ fnRefresh();}
		    }]
		});
		//下列程序将全部控件设置成只读模式
		var type='';
		var id='';
		var value='';
		var hidden='';
		var pid='';  //checkbox的大组名称
		$('input, select, textarea').each(function(index){  
			var input = $(this);
			id=input.attr('id');
			type=input.attr('type');
			hidden=input.attr('hidden');
			if (id!=undefined && hidden!='hidden'){
				if (type=='text') $("#"+id).textbox('readonly',true);
				else if (type=='textarea') $("#"+id).attr('readonly',true);
				else if (type=='combobox') $("#"+id).combobox('disable');
				else if (type=='checkbox') $("#"+id).attr('disabled',true);
				else $("#"+id).attr('readonly',true);
			}
			//console.log(id+'----'+type+'----'+value);
	   	});		
		mySelectOnFocus();  //聚焦选中控件内容
 		$("#teacherid").next("span").find("input").focus();
		$("#teacherid").textbox('readonly',false); 		
 		$("#teacherid").select();  //IE不支持
    }); 

	function fnRefresh(){
		var sql="select * from teachers where teacherid='"+$("#teacherid").textbox('getValue')+"'";
		console.log(sql);
		//var data=myRunSelectSql(sysdatabasestring,sql);
		var result=[];
		$.ajax({     
			type: "Post",     
			url: "system/easyui_execSelect.jsp",     
			//contentType: "application/json; charset=utf-8",     
			//dataType: "json", 
			data: {database: sysdatabasestring, selectsql: sql}, 
			async: false, method: 'post',    
			success: function(data) {     
				//返回的数据用data获取内容,直接复制到客户端数组result      
				eval("result="+data+";");  //or var result=jQuery.parseJSON(data);
			},     
			error: function(err) {     
				console.log(err);     
			}     
		});		
		if (result.length==0){
			$.messager.alert('系统提示','<br>&nbsp;教师编码找不到！','error');
			//icon： 显示图标的图片。可用的值是：error、question、info、warning
			myFocus('teacherid');
		}else{
			$.each(result[0], function(id, value) {  //将json数据复制到表单
				var input = $("#"+id);
				var type=input.attr('type');
				if (input!=undefined){
					if (type=='text'){ 
						input.textbox('setValue',value);
					}else if (type=='combobox'){ 
						input.combobox('setValue',value);
					}else if (type=='checkboxgroup'){
						input.val(value); //设置master的值
						var count=input.attr('itemcount');  //子项个数
						for (var k=1; k<=count; k++){
							var c=$("#"+id+k);  //子项控件名称
							var s1=c.attr('xtext'); //子项标题
							if ((';'+value+';').indexOf(';'+s1+';')>=0) c.prop("checked", true);
							else c.prop("checked", false);
							//console.log((id+k)+'----'+value+'---'+s1);
						}
					}else if (type=='checkbox'){
						var s1=input.attr('xtext'); //子项标题
						if ((';'+value+';').indexOf(';'+s1+';')>=0) input.prop("checked", true);
						else input.prop("checked", false);
					}else{
						input.val(value);			
					}
				}		
			});
		}  //else
	}	     
    </script>
</body>
</html>