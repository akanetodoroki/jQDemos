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
<div id='main' class="easyui-layout" data-options="fit:true" style="padding: 1px 0px 1px 1px;" >
	<div id='top' class='easyui-panel' data-options="region:'north'" style="overflow:hidden; background-color: #E0ECFF; height:30px; padding: 1px 1px 1px 10px;">
		<a href="#" class="btn-separator"></a>
		<a href="#" id="btnadd" xtype="button" class="easyui-linkbutton" data-options="iconCls:'addIcon', plain:true, onClick:fnAdd" style="">新增</a>
		<a href="#" id="btnedit" xtype="button" class="easyui-linkbutton" data-options="iconCls:'editIcon', plain:true, onClick:fnEdit" style="">修改</a>
		<a href="#" id="btndelete" xtype="button" class="easyui-linkbutton" data-options="iconCls:'deleteIcon',plain:true, onClick:fnDelete" style="">删除</a>
		<a href="#" class="btn-separator"></a>
		<a href="#" id="btnsave" xtype="button" class="easyui-linkbutton" data-options="iconCls:'saveIcon',plain:true, onClick:fnSave" style="">保存</a>
		<a href="#" class="btn-separator"></a>
		<a href="#" id="btnrefresh" xtype="button" class="easyui-linkbutton" data-options="iconCls:'refreshIcon',plain:true, onClick:fnRefresh" style="">刷新</a>
	</div>	
	<div id='left' class='easyui-panel' data-options="region:'west', split:true" style="overflow:auto; width:200px;"></div>
	<div id='right' class='easyui-panel' data-options="region:'center', split:true" style="overflow:auto; padding: 0px 0px 0px 0px;"></div>
</div>	
<script>
	var now = new Date();
	var today = now.getFullYear()+'-'+(now.getMonth()+1)+'-'+now.getDate();
	var fieldset='teacherid;name;pycode;gender;birthdate;party;title;province;city;degree;graduate;address;mobile;homephone;email;qq;weixin;homepage;research;notes';
	$(function() {
		//example24_addeditdelete.jsp
		document.onkeypress=myBanBackSpace;
		document.onkeydown=myBanBackSpace;	
		var rowheight=36;	
		var jqsql={};  //sql语句中不能有双引号
		jqsql.party="select Pycode as id,description as party from dictionary where Type='党派'";
		jqsql.title="select Pycode as id,description as title from dictionary where Type='职称'";
		jqsql.province="select AreaID as provinceid,AreaName as province from Areas where level=1";
		jqsql.city="select AreaID as cityid,AreaName as city, parentnodeid as provinceid from Areas ";
		jqsql.degree="select Pycode as id,description as degree from dictionary where Type='学历'";
		str='<div id="teacherlist" class="easyui-datalist" title="教师列表" data-options="fit:true" style=""></div>';
		$("#left").append($(str));
		$("#teacherlist").datalist({
			textField:'name',
			valueField:'teacherid',
			checkbox:true,
			onSelect: function (index,row){
				sql="select * from teachers where teacherid='"+row.teacherid+"'";
				results=myRunSelectSql(sysdatabasestring,sql);
				mySetFormValues(fieldset,results[0]);
				mySetReadonly(fieldset,true);
				$("#addoredit").val('edit');
			}
		});
		myForm('myForm1','right','教师信息编辑',0,0,518,372,'');
		myTabs('myTab','myForm1','基本信息;联系信息;研究方向',0,0,485,0,'');
		myFieldset('myFieldset1','myTab1','基本信息',10,10,425,340);
		myFieldset('myFieldset2','myTab2','通信信息',10,10,285,340);
		myTextField('teacherid','myFieldset1','教师编码：',70,rowheight*0+25,16,0,120,'');
		myTextField('name','myFieldset1','姓名：',70,rowheight*1+25,16,0,190,'');
		myTextField('pycode','myFieldset1','姓名拼音：',70,rowheight*2+25,16,0,190,'');
		myComboField('gender','myFieldset1','性别：',70,rowheight*3+25,16,0,120,'男;女','男','autodrop');
		myDateField('birthdate','myFieldset1','出生日期：',70,rowheight*4+25,16,0,120,'1961-11-12');
		myDBComboField('party','myFieldset1','党派：',70,rowheight*5+25,16,0,160,jqsql.party,'party','','autodrop');
		myDBComboField('title','myFieldset1','职称：',70,rowheight*6+25,16,0,160,jqsql.title,'title','','autodrop');
		myDBComboField('province','myFieldset1','籍贯：',70,rowheight*7+25,16,0,160,jqsql.province,'province','','');
		myDBComboField('city','myFieldset1','',70,rowheight*8+25,16,0,160,jqsql.city,'','province(provinceid)','');
		myLabelField('provincex','myFieldset1','省',rowheight*7+25+4,268,0,0);
		myLabelField('cityx','myFieldset1','市',rowheight*8+25+4,268,0,0);
		myDBComboField('degree','myFieldset1','学历：',70,rowheight*9+25,16,0,160,jqsql.degree,'degree','','autodrop');
		myTextField('graduate','myFieldset1','毕业院校：',70,rowheight*10+25,16,0,235,'');
		myTextField('address','myFieldset2','家庭地址：',70,rowheight*0+25,12,0,240,'');
		myTextField('mobile','myFieldset2','手机号码：',70,rowheight*1+25,12,0,180,'');
		myTextField('homephone','myFieldset2','家庭电话：',70,rowheight*2+25,12,0,180,'');
		myTextField('email','myFieldset2','Email：',70,rowheight*3+25,12,0,180,'','');
		myTextField('qq','myFieldset2','QQ号：',70,rowheight*4+25,12,0,180,'');
		myTextField('weixin','myFieldset2','微信号：',70,rowheight*5+25,12,0,180,'');
		myTextField('homepage','myFieldset2','个人主页：',70,rowheight*6+25,12,0,240,'','');
		myCheckBoxGroup('research','myTab3','研究方向：',0,rowheight*0+25,12,24,3,'[u110]企业管理;[110]区域经济学;[110]管理信息系统;[110]电子商务;[140]信息系统开发技术');
		myTextareaField('notes','myTab3','个人简介：',0,rowheight*3+5,10,300,330,'');
		myHiddenFields('addoredit');
		//mySetComboxByIndex('province',0);  //调用函数设置选项初值
		//设置email和主页的验证格式
		$("#email").textbox({validType:'email'});
		$("#homepage").textbox({validType:'url'});
		//利用扩展的validationbox
		$('#teacherid').textbox({
			validType:"integer"	//自定义验证规则名，下同	
		});
		$('#pycode').textbox({
			validType:"english"		
		});
		fnRefresh();
		myKeyDownEvent('');
		mySelectOnFocus();  //聚焦选中控件内容
 		$("#teacherid").next("span").find("input").focus();
 		$("#teacherid").select();  //IE不支持
    }); // endof jquery
    
    function fnAdd(){
  		mySetFormValues(fieldset,null);
  		mySetReadonly(fieldset,false);
    	$("#myTab").tabs('select',0);
    	$("#teacherid").next("span").find("input").focus();
 		$("#teacherid").select();  //IE不支持    	
  		$("#addoredit").val('add');  //新增记录
    }

    function fnEdit(){
    	mySetReadonly(fieldset,false);
  		$("#teacherid").textbox('readonly',true);  //新增记录
    	$("#myTab").tabs('select',0);
    	$("#teacherid").next("span").find("input").focus();
 		$("#teacherid").select();  //IE不支持    	
  		$("#addoredit").val('edit');  //修改记录
    }
    
    function fnDelete(){  //删除记录
    	var keyvalue=$("#teacherid").textbox("getValue");
    	$.messager.confirm('系统提示','删除教师编码'+keyvalue+"<br>是否确定？",function(r){
			if (r){
				var sql="delete teachers where teacherid='"+keyvalue+"'";	
    			var result=myRunUpdateSql(sysdatabasestring,sql);
    			if (result.error==''){
    				fnRefresh();
    			}
    		}	
		});
    }

	function fnSave(){  //保存记录
		var addoredit=$("#addoredit").val();
    	var flag=fnValidation(addoredit);
    	if (flag==1){
    		if (addoredit=='edit'){
    			var sql="update teachers set ";
    			sql+="name='"+$("#name").textbox('getValue')+"',";
    			sql+="pycode='"+$("#pycode").textbox('getValue')+"',";
    			sql+="gender='"+$("#gender").combobox('getValue')+"',";
    			sql+="birthdate='"+$("#birthdate").datebox('getValue')+"',";
    			sql+="party='"+$("#party").combobox('getValue')+"',";
    			sql+="title='"+$("#title").combobox('getValue')+"',";
    			sql+="province='"+$("#province").combobox('getValue')+"',";
    			sql+="city='"+$("#city").combobox('getValue')+"',";
    			sql+="degree='"+$("#degree").combobox('getValue')+"',";
    			sql+="graduate='"+$("#graduate").textbox('getValue')+"',";
    			sql+="address='"+$("#address").textbox('getValue')+"',";
    			sql+="homephone='"+$("#homephone").textbox('getValue')+"',";
    			sql+="mobile='"+$("#mobile").textbox('getValue')+"',";
    			sql+="email='"+$("#email").textbox('getValue')+"',";
    			sql+="weixin='"+$("#weixin").textbox('getValue')+"',";
    			sql+="homepage='"+$("#homepage").textbox('getValue')+"',";
    			sql+="qq='"+$("#qq").textbox('getValue')+"',";
    			sql+="research='"+$("#research").val()+"',";
    			sql+="notes='"+$("#notes").val()+"'";
    			sql+=" where teacherid='"+$("#teacherid").textbox('getValue')+"'";
    		}else{  //add new record
    			var sql="insert into teachers (teacherid,name,pycode,gender,birthdate,party,";
    			sql+="title,province,city,degree,graduate,address,homephone,mobile,email,";
    			sql+="weixin,homepage,qq,research,notes) values(";
    			sql+="'"+$("#teacherid").textbox('getValue')+"',";
    			sql+="'"+$("#name").textbox('getValue')+"',";
    			sql+="'"+$("#pycode").textbox('getValue')+"',";
    			sql+="'"+$("#gender").combobox('getValue')+"',";
    			sql+="'"+$("#birthdate").datebox('getValue')+"',";
    			sql+="'"+$("#party").combobox('getValue')+"',";
    			sql+="'"+$("#title").combobox('getValue')+"',";
    			sql+="'"+$("#province").combobox('getValue')+"',";
    			sql+="'"+$("#city").combobox('getValue')+"',";
    			sql+="'"+$("#degree").combobox('getValue')+"',";
    			sql+="'"+$("#graduate").textbox('getValue')+"',";
    			sql+="'"+$("#address").textbox('getValue')+"',";
    			sql+="'"+$("#homephone").textbox('getValue')+"',";
    			sql+="'"+$("#mobile").textbox('getValue')+"',";
    			sql+="'"+$("#email").textbox('getValue')+"',";
    			sql+="'"+$("#weixin").textbox('getValue')+"',";
    			sql+="'"+$("#homepage").textbox('getValue')+"',";
    			sql+="'"+$("#qq").textbox('getValue')+"',";
    			sql+="'"+$("#research").val()+"',";
    			sql+="'"+$("#notes").val()+"'";
    			sql+=")";
    		}
  			var result=myRunUpdateSql(sysdatabasestring,sql);
   			if (result.error==''){
   				fnRefresh();
   				$("#addoredit").val('edit');
   			}
    	}
    }
    
    function fnRefresh(){  //刷新记录
    	var sql="select teacherid,name from teachers";
		var results=myRunSelectSql(sysdatabasestring,sql);
		$("#teacherlist").datalist({data:results});
		$("#teacherlist").datalist('selectRow',0);
    }

	
	function fnValidation(addoredit){
		var errormsg=[];  //存放数据验证发现的错误信息
		//先判断各个控件是否符合格式要求
		if (!$("#teacherid").textbox('isValid')) errormsg.push('教师编码输入错误！');
		if (!$("#pycode").textbox('isValid')) errormsg.push('姓名拼音输入错误！');
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
		if (addoredit=='add'){
			//新增记录才需要验证编码是否重复 
			var sql="select * from teachers where teacherid='"+s1+"'";
			var result=myRunSelectSql(sysdatabasestring,sql);
			if (result.length>0){
				errormsg.push('教师编码重复！');
			}
		}
		//验证省份和城市是否存在
		var sql1="select areaid as provinceid from areas where areaname='"+s3+"'";  
		var result1=myRunSelectSql(sysdatabasestring,sql1);
		if (result1.length==0){
			errormsg.push('省份名称输入错误！');
		}else{
			var sql2="select 1 as n from areas where areaname='"+s4+"' and parentnodeid='"+result1[0].provinceid+"'";  
			var result2=myRunSelectSql(sysdatabasestring,sql2);
			if (result2.length==0){
				errormsg.push('城市名称输入错误！');
			}
		}
		//数据验证结束
		if (errormsg.length==0){
			return(1);
		}else{	
			myMessage('数据验证发现下列错误，提交失败！@n'+errormsg);
			return(0);
		}
	}  //fn	
	//控件数据验证规则定义
	$.extend($.fn.validatebox.defaults.rules, {
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
	     
</script>
</body>
</html>