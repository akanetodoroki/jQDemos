<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="com.DBConn" %>
<%@ page import="com.UserBean" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>CRM实验室</title>
		<link rel="stylesheet" type="text/css" href="ext4.2/resources/css/ext-all.css">  <!-- ext系统样式 -->
		<link rel="stylesheet" type="text/css" href="system/css/mystyle.css"> <!-- ext图标文件 -->
		<script type="text/javascript" src="ext4.2/ext-all.js"></script>  <!-- Ext核心源码 -->
		<script type="text/javascript" src="ext4.2/locale/ext-locale-zh_CN.js"></script>  <!-- 国际化文件 -->
		<script type="text/javascript" src="system/decimalfield.js"></script>   <!-- 自定义加零数值型控件 -->
		<script type="text/javascript" src="system/fn_function.js"></script>  <!-- 公共函数 -->
		<script type="text/javascript" src="system/fn_dspOrder.js"></script>
		<script type="text/javascript" src="system/fn_dspCustomer.js"></script>
		<style>
		</style>
	</head>
	<body>
	<%
		String hostname="";
		String sqlpassword="";
		String username="";
		String userid="";
		String password="";
		String logindate="";
		String unittitle="";
		String unitno="";
		UserBean user = (UserBean)session.getAttribute("user");
		if (user != null){
			hostname=user.getHostName();
			sqlpassword=user.getSqlPassword();
			username=user.getUsername();
			userid=user.getAccount();
			password=user.getPassword();
			logindate=user.getLoginDate();
			unittitle=user.getUnitTitle();
			unitno=user.getUnitNo();
		}
		String action="admin";
		action = request.getParameter("action");		
	%>

    <div class="logo">
    	<!-- <img src="system/images/login.png" /> -->
	</div>	
	<script type="text/javascript">
  	//选中子节点，保存后，再过滤，出现问题
	Ext.require(['Ext.form.*','Ext.tree.*','Ext.panel.*','Ext.tab.*','Ext.data.*','Ext.grid.*','Ext.toolbar.*','Ext.menu.*','Ext.Viewport']);
	Ext.onReady(function(){
		Ext.QuickTips.init();
		Ext.form.Field.prototype.msgTarget='side';//统一指定错误信息提示方式//'dtip','title','under'
		Ext.getDoc().on("contextmenu", function(e){  //去掉这个页面的右键菜单
			e.stopEvent();
        });
		eval(sysDisableBackSpace()); //知识点2：处理退格键keycode=8，禁止网页倒回
		sysSetMessageText();      //知识点3：设置EXTJS中messageBox的按钮，以汉字显示
		eval(sysSetTreeStore());  //知识点4：用于避免多次重复加载树！！重要
		sysSetMessageText();
		syshostname='<%=hostname %>';
		syssqlpassword='<%=sqlpassword %>';
		sysusername='<%=username %>';
		sysuserid='<%=userid %>';
		syspassword='<%=password %>';
		syslogindate='<%=logindate %>';
		sysunittitle='<%=unittitle %>';
		action='<%=action %>';
		//菜单存储在crmlab数据库
		sysdatabasestring=syshostname+syschrtab+syssqlpassword+syschrtab+sysdbname;
		var maxReturnNumber=1000;
		var rowHeight=42;
		var toolbar1=Ext.create('Ext.toolbar.Toolbar',{
			region:'north',
			split:false,
			items:[
		        {xtype:'image', id:'logo', width:'100%', src:'system/images/login.png',height:54}
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
				width: 220
			}
		});
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
				if (hostitems==''){  //找不到服务器
					window.location = '/crmlab/server.jsp';
					return;	
				}				
			}
		});
		var hostx=hostitems.split(";");
		if (hostx.length==0){
			return;
		}
		
		var hosty=hostx[0].split(syschrtab);
		syshostname=hosty[0];
		syssqlpassword=hosty[1];
		//生成crmlab数据库
		var databasestring=syshostname+syschrtab+syssqlpassword+syschrtab+"master";
		//alert(databasestring+'----'+sysdbname);
		var result='';
		Ext.Ajax.request({
			url: 'system//fn_newDatabase.jsp',
			form: 'myForm',
			method: 'POST',async:false,
			params: { database: databasestring, dbName: sysdbname },
			callback: function(options, success, response){
				result=response.responseText.myTrim();
				if (result!=''){
					window.location = '/crmlab/server.jsp?action=admin';
					return;							
				}
			}
		});
		sysdatabasestring=syshostname+syschrtab+syssqlpassword+syschrtab+sysdbname;		
		//登录ffffff
		eval(myDefineItemCombox('myForm','hostname','服 务 器：',60,30,80,330,hostitems,'hostname;sqlpassword',''));
		//console.info(myDefineItemCombox('myForm','hostname','服 务 器：',60,30,80,330,hostitems,'hostname;sqlpassword',''));
		eval(myDefineTextField('myForm','account','操 作 员：',60,30+rowHeight*1,80,330,50,'请输入操作员登录账号'));
		eval(myDefinePasswordField('myForm','password','登录密码：',60,30+rowHeight*2,80,330,50,''));
		eval(myAddHiddenFields('unitno;sqlpassword;loginday','myForm'));
		if (hostname.store.getCount()>0){
			var record=hostname.store.getAt(0);
			syshostname=record.get('hostname');
			syssqlpassword=record.get('sqlpassword');
		}
		if (syshostname==''){
			syshostname="localhost";
			sqlpassword="sql2008";
		}
		if (sysuserid==''){
			sysuserid='admin';
			syspassword='admin';
		}
		Ext.getCmp('hostname').setValue(syshostname);
		Ext.getCmp('sqlpassword').setValue(syssqlpassword);
		Ext.getCmp('account').setValue(sysuserid);
		Ext.getCmp('password').setValue(syspassword);
		var myWindow = Ext.create('Ext.window.Window', {
			layout: 'fit',//自适应布局,使唯一子元素充满当前容器
        	width: 510,
	        height: 290,
    	    closeAction: 'hide', //窗口关闭的方式：hide/close
        	plain: true,
        	title: '系统管理员登录',
        	//maximizable: true,     //是否可以最大化
        	//minimizable: true,     //是否可以最小化
        	closable: true,       //是否可以关闭
        	modal: true,           //是否为模态窗口
        	resizable: false,      //是否可以改变窗口大小
        	tbar: toolbar1,
        	items: [myForm],
			buttons: [{
            	text: '确定',
            	id: 'cmdok',
            	disabled: false,
				handler: function () {
					var xerrormsg='';
					if (Ext.getCmp("account").getValue()==''){
						if (xerrormsg!='') xerrormsg+='<br>';
						xerrormsg+='操作员不能为空！';
					}	
					if (xerrormsg==''){					
						var unitno='';
						var unittitle='';
						var dbname=sysdbname;
						var account=Ext.getCmp("account").getValue();
						var password=Ext.getCmp("password").getValue();
						var logindate=sysdate;
						var hostname=Ext.getCmp("hostname").getValue();
						var sqlpassword=Ext.getCmp("sqlpassword").getValue();
						var action='admin';		
						var sql="select * from sys_user where xtype='s' and  account='"+account+"'"; 
						Ext.Ajax.request({
							url: 'system//fn_loginServer.jsp',
							form: 'myForm',
							method: 'POST',async:false,
							params:{ 
								account: account, 
								password: password, 
								unittitle: unittitle, 
								unitno: unitno, 
								hostname: hostname, 
								sqlpassword: sqlpassword, 
								logindate: logindate, 
								dbname: dbname, 
								action: action
							},									
							callback: function(options, success, response){
								error=response.responseText.myTrim();
								if (error=="1"){
									eval(sysWarn('操作员账号不存在！',260,200));
									Ext.getCmp('account').focus(true,100);
								}else if (error=="2"){
									eval(sysWarn('操作员登录密码输入错误！',260,200));
									Ext.getCmp('password').focus(true,100);
								}else if (error!=""){
									eval(sysWarn(error+'<br><br>本次用户登录失败！',300,200));
									Ext.getCmp('hostname').focus(true,100);
								}else{
									//登录成功
									myWindow.hide();
									myTree1.setVisible(true);										
								}
							}
						});
					}else{
						eval(sysError(xerrormsg,260,200));
					}	
            	}           	
        	}, {
	            text: '取消',
				id: 'cmdcancel',
				handler: function () {
                	myWindow.hide(Ext.fly('btn1'));
					window.location = '/crmlab/home.jsp';                	
				 	return;							
            	}
			}],
			listeners: {
				show: function(win){
					Ext.getCmp('account').focus(true,100);
				}
    		}
    	});	

		//tree1
		var pmyTree1={};		
		pmyTree1.selectedcode='';
		pmyTree1.rootcode='';
		pmyTree1.searchtext='';
		pmyTree1.filterfield='';
		pmyTree1.events='storeload;treeload;beforeload';
		pmyTree1.sql="select menuid as cid,menutitle as nodetext,menutitle as text,* from sys_menu where type=9";
		pmyTree1.parentvalue="";
		pmyTree1.name="myTree1";
		pmyTree1.varname="pmyTree1";
		pmyTree1.reloadflag=1;
		pmyTree1.singleexpand='false';
		pmyTree1.title='';
		pmyTree1.roottitle='';
		pmyTree1.bbar='';
		pmyTree1.tbar=''; 
		pmyTree1.height=0;
	    pmyTree1.width=230;
	    pmyTree1.rowheight=24;	    
	    pmyTree1.contextmenu='';//'myContextMenu1';
	    pmyTree1.tablename='sys_menu';
	    pmyTree1.tablespec='菜单';
	    pmyTree1.keyfield='menuid';
	    pmyTree1.keyspec='菜单编码';
	    pmyTree1.fieldset='cid;text;sysnumber:int;menuid;menutitle;menuurl;parentnodeid;isparentflag:int;level:int';
	    pmyTree1.columnfield='';
		pmyTree1.columntitle='';
		pmyTree1.columnwidth='';
		pmyTree1.columnalign='';
		pmyTree1.selectedmenu=[];
		pmyTree1.selectedmenuno=0;
		//定义工具栏
		var toolbar2=Ext.create('Ext.toolbar.Toolbar',{
			region:'north',
			split:false,
			items:[
			{xtype: 'tbspacer', width: 2},	        
			{id:'username',xtype:'displayfield',width:100,value: sysusername},'->','-',
	        //{id:'cmdhome', iconCls: 'homeIcon',tooltip: '返回主页'},
	        {id:'cmdlogout', iconCls: 'logoutIcon',tooltip: '用户注销'},'-',
			{xtype: 'tbspacer', width: 1}	        
	        ]
		});
		//定义树
	    eval(myDefineTree('west',pmyTree1));
	    myTree1.setVisible(false);
	    //myTree1事件
		myTree1.on('beforeload',function(store) {
			var newparams={ database:sysdatabasestring, maxReturnNumber:maxReturnNumber,sqlString:pmyTree1.sql,keyField:'cid',rootCode:pmyTree1.rootcode,selectedCode:pmyTree1.selectedcode };
			Ext.apply(store.proxy.extraParams,newparams);
			store.proxy.url='system//fn_getTreeNodes.jsp';					
		});				
		myTree1.on('itemclick', function(view,record,item,index,e){//监听树选中时间
			var isparentflag=record.get('isparentflag');
			var url=record.raw.menuurl;           		
			if (isparentflag==0 && url!=''){
				Ext.get("mainframe").dom.src = url; //record.raw.title;
			}	
		});


		var myMenuPanel = Ext.create('Ext.panel.Panel', {
    		frame: true,
    		region: 'center',
    		id: 'myMenuPanel',
    		name: 'myMenuPanel',
	        layout: 'column',
	        width:'100%',
	        autoScroll:true,
	        //bbar: toolbar3,
	        border: false,
	        html: "<iframe id='mainframe' name='mainframe' url='' width='100%' height='100%' src=' ' frameborder='no' border='0' style='margin:0 auto; text-align:center'>",
            defaults: {
	            layout: 'anchor',
    	        defaults: {
        	        anchor: '100%'
	           }
	        }
    	});
		/****************************页面布局******************************/
		var myView=Ext.create('Ext.Viewport', {
	        layout: {
	            type: 'border',
	            padding: 5
	        },
	        defaults: {
	            split: true
	        },
	        items: [myTree1, myMenuPanel	]
	    });
	    
	    

    	function fnKeyEvent(field,e) {
    		if (field.id=='password' && e.getKey()==13){
    			Ext.getCmp('cmdok').focus(true,100);
    		}
			myKeyEvent(field,e,myForm);  //笤俑functions中的函数
		}
		
		function fnSelectCombo(combo, record, index) { //combo选中事件
			if (record[0]) {
				var id=combo.id;
				if (id=='hostname') {
					Ext.getCmp('sqlpassword').setValue(record[0].get('sqlpassword'));
				}	
			}
		}
			    

	    //myTree1.store.load();  //菜单条目会重复
		Ext.get("mainframe").dom.src = '';	 //important
		myWindow.show();   
			
	//****************************end of extjs**************************//		
	}); 
  
  </script>
  </body>
</html>
