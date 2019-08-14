<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ page import="com.UserBean" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title></title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<!-- ext系统样式 -->
		<link rel="stylesheet" type="text/css" href="ext4.0/resources/css/ext-all.css">
		<!-- 图标文件 -->
		<link rel="stylesheet" type="text/css" href="system/css/mystyle.css">
		<!-- Ext核心源码 -->
		<script type="text/javascript" src="ext4.0/bootstrap.js"></script>
		<!-- 国际化文件 -->
		<script type="text/javascript" src="ext4.0/locale/ext-lang-zh_CN.js"></script>
		<script type="text/javascript" src="system/decimalfield.js"></script>
		<!-- 公共函数 -->
		<script type="text/javascript" src="system/fn_function.js"></script>
		<style>
		</style>
	</head>
	<body>
	<% 
		String action=null;
		action = request.getParameter("action");	
	%>
	<script type="text/javascript">
  	//选中子节点，保存后，再过滤，出现问题
	Ext.require(['Ext.form.*','Ext.tree.*','Ext.panel.*','Ext.tab.*','Ext.data.*','Ext.grid.*','Ext.toolbar.*','Ext.menu.*','Ext.Viewport']);
	Ext.onReady(function(){
		Ext.QuickTips.init();
		Ext.form.Field.prototype.msgTarget='side'; //统一指定错误信息提示方式//'dtip','title','under'
		Ext.getDoc().on("contextmenu", function(e){  //知识点1：去掉页面的右键菜单
			e.stopEvent();
        });
        //alert(syshostname);
		eval(sysDisableBackSpace());
		sysSetMessageText();
		action='<%=action %>';
		var rowHeight = 52;
		var toolbar1=Ext.create('Ext.toolbar.Toolbar',{
			region:'north',
			split:false,
			items:[
		        {xtype:'image', id:'logo', width:'100%', src:'system/images/login.png',height:42}
	        ]
		});
		
		var myForm = Ext.create('Ext.form.Panel', {
			border: false,
			bodyPadding: 5,
			layout: 'absolute',		
			fieldDefaults: {
				labelSeparator: ':',
				labelWidth: 62,
				labelAlign: 'left',
				allowBlank: false,
				msgTarget: 'qtip',
				width: 200
			}
		});
		/*
		var hostitems="";
		Ext.Ajax.request({
			url: 'system//fn_getSqlConnection.jsp',
			//form: 'myForm',
			method: 'POST',async:false,
			params: {  },
			callback: function(options, success, response){
				hostitems=response.responseText;
				hostitems=hostitems.myTrim();
				//alert(hostitems);
			}
		});
		var hostx=hostitems.split(";");
		eval(myDefineItemCombox('myForm','hostname','服务器：',54,30,40,320,hostitems,'hostname;sqlpassword',''));
		Ext.getCmp('hostname').setEditable(true);
		*/
		
		eval(myDefineTextField('myForm','hostname','服务器：',54,30,40,320,50,'请输入数据库服务器名称'));
		eval(myDefinePasswordField('myForm','sqlpassword','sa密码：',54,30+rowHeight*1,40,320,50,''));
		//eval(myDefineButton('myForm','cmdsqlcon','连接测试',20+rowHeight*0,375,0,75));		
		Ext.getCmp('hostname').setValue(syshostname);
		Ext.getCmp('sqlpassword').setValue(syssqlpassword);
		var myWindow = Ext.create('Ext.window.Window', {
			layout: 'fit',//自适应布局,使唯一子元素充满当前容器
        	width: 420,
	        height: 260,
    	    closeAction: 'hide', //窗口关闭的方式：hide/close
        	plain: true,
        	title: '设置数据库服务器',
        	//maximizable: true,     //是否可以最大化
        	//minimizable: true,     //是否可以最小化
        	closable: true,       //是否可以关闭
        	modal: true,           //是否为模态窗口
        	resizable: false,      //是否可以改变窗口大小
        	tbar: toolbar1,
        	items: [myForm],
			buttons: [{
            	text: '测试',
            	id: 'btn1',
            	disabled: false,
				handler: fnTestCon
        	}, {
            	text: '保存',
            	id: 'btn2',
            	disabled: false,
				handler: fnSaveCon
        	}, {
				text: '取消',
            	id: 'btn3',
				handler: function () {
                	myWindow.hide(Ext.fly('btn1'));
    				window.location = '/crmlab/home.jsp';
				 	return;							
            	}
			}],
			listeners: {
				show: function(win){
					Ext.getCmp('hostname').focus(true,100);
				}
    		}
    	});	

    	function fnKeyEvent(field,e) {
			myKeyEvent(field,e,myForm);  //笤俑functions中的函数
		}
		
		function fnSelectCombo(combo, record, index) { //combo选中事件
			if (record[0]) {
				var id=combo.id;
			}
		}
		
		function fnSaveCon(e){
			var xerror=fnTestCon(e);
			var result='';
			if (xerror==''){
				var xdatabasestring=Ext.getCmp("hostname").getValue()+syschrtab+Ext.getCmp("sqlpassword").getValue()+syschrtab+'master';
				//alert( xdatabasestring);
				Ext.Ajax.request({
					url: 'system//fn_setSqlConnection.jsp',
					form: 'myForm',
					params:{ database: xdatabasestring, action: 'save' },									
     				method: 'POST',async:false,
   	    			callback:function(options,success,response){
       					result=response.responseText.myTrim();
       					//alert(result);
       					myWindow.hide();
						if (action=='null'){
							window.location = '/crmlab/admin.jsp';       					
       					}
					}
				});				
			}
		}
		
		function fnTestCon(e){
			var xerrormsg='';
			if (Ext.getCmp("hostname").getValue()==''){
				xerrormsg+='服务器名称不能为空！';
			}
			if (xerrormsg==''){
	    		var xdatabasestring=Ext.getCmp("hostname").getValue()+syschrtab+Ext.getCmp("sqlpassword").getValue()+syschrtab+'master';
	    		//alert(xdatabasestring);
				Ext.Ajax.request({
					url: 'system//fn_testSqlConnection.jsp',
					form: 'myForm',
					params:{ database: xdatabasestring },									
     				method: 'POST',async:false,
   	    			callback:function(options,success,response){
       					//var xerrormsg=Ext.decode(response.responseText).myTrim();
       					xerrormsg=response.responseText.myTrim();
       					if (e.id=='btn1'){ //显示错误信息
	       					if (xerrormsg=='') {
		       					eval(sysInfo('数据库连接测试成功！',0,0));
    		   				}else{
								xerrormsg+='<br>数据库连接测试失败！';       				
       							eval(sysWarn(xerrormsg,300,0));
       						}
       					}
					}
				});	
       		}
       		return(xerrormsg);
       	}	
    	myWindow.show();
		
	//****************************end of extjs**************************//		
	});
	
  </script>

	</body>

</html>
