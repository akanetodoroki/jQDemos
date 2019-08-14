<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="com.DBConn" %>
<%@ page import="com.UserBean" %>
<%@ page import="com.StringUtil"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>TReport模板</title>
		<link rel="stylesheet" type="text/css" href="ext4.2/resources/css/ext-all.css">	<!-- ext系统样式 -->
		<link rel="stylesheet" type="text/css" href="system/css/mystyle.css"> <!-- ext图标文件 -->
		<script type="text/javascript" src="ext4.2/ext-all.js"></script>  <!-- Ext核心源码 -->
		<script type="text/javascript" src="ext4.2/locale/ext-locale-zh_CN.js"></script>  <!-- 国际化文件 -->
		<script type="text/javascript" src="system/fn_decimalfield.js"></script>   <!-- 自定义加零数值型控件 -->
		<script type="text/javascript" src="system/fn_function.js"></script>  <!-- 公共函数 -->
		<script type="text/javascript" src="system/fn_compilers.js"></script>
		<script type="text/javascript" src="system/fn_dspOrder.js"></script>
		<script type="text/javascript" src="system/fn_dspCustomer.js"></script>
		<script type="text/javascript" src="system/fn_editbutton.js"></script>
		<script type="text/javascript" src="system/fn_treepicker.js"></script>
		<style>
		</style>
	</head>
	<body>
	<%
		String realpath = request.getRealPath("/");
		realpath=realpath.replace("\\","\\\\");
		UserBean user = (UserBean)session.getAttribute("user");
		if (user == null || user.getUnitNo().equals("")){
			//response.sendRedirect("login.jsp");  //重定向
			out.println("<script>Ext.onReady(function(){if(window.top!=window.self){window.top.location.href='login.jsp';}else{window.location.href='login.jsp';}});</script>");			
			return;
		}	
	%>
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
		var realpath='<%=realpath %>';
		sysuserid='<%=user.getUserID() %>';
		sysuseraccount='<%=user.getAccount() %>';
		sysusername='<%=user.getUsername() %>';
		sysdate='<%=user.getLoginDate() %>';
		sysdatabasestring='<%=user.getDatabase() %>';
		sys.userright='<%=user.getUserRight() %>';
		sys.menuurl='<%=request.getServletPath() %>';
		eval(myGetMenuRight(sys.userright,sys.menuurl)); //获取当前页面权限特征值
		//alert(window.location.href);
		var maxReturnNumber=100;  //一次从后台返回记录的数量，超过该值树中节点将分层获取。
		var pageSize=20;
        var restoreGridFlag=0;
 		//var xmlSrc = 'xml/pCustomerEdit.xml';
		//var myCompiler = new Compiler();
		//var p = myCompiler.compiler(xmlSrc);
		var p=window.top.p;  //从主菜单程序中获取
  		var pmyTable={};  //提取数据表
  		var pmyGrid1={}; //定义myGrid1
		var pmyForm={}; //定义表单，一个tab对应一个form
		var pmyTree1={};  		//定义分组树tree1
		var pmyService={};
		var pmyReport1={};
		var pmyFooter1={};
		pmyService.sysdatabasestring=sysdatabasestring; //传递到fn_function.js
		pmyService.sysdate=sysdate;
		pmyTable.sysdatabasestring=sysdatabasestring; //传递到fn_function.js
		pmyGrid1.sysdatabasestring=sysdatabasestring; //传递到fn_function.js
		pmyTree1.sysdatabasestring=sysdatabasestring; //传递到fn_function.js
		pmyForm.sysdatabasestring=sysdatabasestring; //传递到fn_function.js
  		if (p.table!=undefined) pmyTable=myGetTableAttrs(p.table[0],pmyTable);  //获取table值
		if (p.form!=undefined) pmyForm=myGetFormAttrs(p,pmyForm);
		if (p.grid!=undefined) pmyGrid1=myGetGridAttrs(p.grid[0],pmyGrid1);  //获取grid值
		if (p.tree!=undefined) pmyTree1=myGetTreeAttrs(p.tree[0],pmyTree1);
		if (p.report!=undefined) pmyReport1=myGetReportAttrs(p.report[0],pmyReport1);
		if (pmyGrid1.tablename=='' && pmyTable.tablename!='') pmyGrid1.tablename=pmyTable.tablename;
		if (pmyGrid1.tabletitle=='' && pmyTable.tabletitle!='') pmyGrid1.tabletitle=pmyTable.tabletitle;
		if (pmyGrid1.keyfield=='' && pmyTable.keyfield!='') pmyGrid1.keyfield=pmyTable.keyfield;
		if (pmyGrid1.keyspec=='' && pmyTable.keyspec!='') pmyGrid1.keyspec=pmyTable.keyspec;
		if (pmyGrid1.sortfield=='' && pmyTable.sortfield!='') pmyGrid1.sortfield=pmyTable.sortfield;
		if (pmyGrid1.sortfield=='') pmyGrid1.sortfield=pmyGrid1.keyfield;
		if (pmyGrid1.sql=='' && pmyGrid1.tablename!='')	pmyGrid1.sql="select * from "+pmyGrid1.tablename;
		if (pmyForm.rowheight!=undefined && pmyForm.rowheight!='') var rowHeight=pmyForm.rowheight;
		else var rowHeight=32;
		pmyTable.tablename=pmyGrid1.tablename;
		pmyTable.tabletitle=pmyGrid1.tabletitle;
		pmyTable.keyfield=pmyGrid1.keyfield;
		pmyTable.keyspec=pmyGrid1.keyspec;
		pmyTable.sortfield=pmyGrid1.sortfield;
  		pmyTable.permission=';'+myGetOneAttr(p.service,'permissions')+';';
  		sys.year=myGetDatePart('year',sysdate);
		sys.month=myGetDatePart('month',sysdate);
		sys.day=myGetDatePart('day',sysdate);
		sys.date=sys+'-'+sys.month+'-'+sys.day;
		sys.date0=sys.year+'-01-01';
		sys.date1=sys.year+'-'+sys.month+'-01';
		sys.date2=sys.year+'-'+sys.month+'-'+myDaysInaMonth(sys.year,sys.month);
		//处理sql语句中的用户自定义函数
		var sql=pmyGrid1.sql;
		sql=sql.replace('#sysdate',"'"+sysdate+"'");
		var x1=sql.lastIndexOf(' from ')
		var x2=sql.indexOf('dbo.')
		if (x1>=0 && x2>=0){
			var updatesql="if object_id('ptmp') is not null drop table ptmp\n";
			updatesql+="select * into ptmp from ("+sql+") as p\n";
			//console.log(updatesql);
			Ext.Ajax.request({
				url:'system//fn_executeSql.jsp',
				params:{ database:pmyTable.sysdatabasestring, updateSql:updatesql,selectSql:'' },									
				method: 'POST',async:false,
				callback:function(options,success,response){
					//rowno=Ext.decode(response.responseText).rowno;
				}	 
			});
			pmyGrid1.sql="select * from ptmp";
			//console.log(pmyGrid1.sql);
		}	
		//grid初始设置
		pmyGrid1.index=-1;  //聚焦的行号
		pmyGrid1.column=-1;
		//pmyGrid1.bbar='';
		//pmyGrid1.tbar='';
		pmyGrid1.varname='pmyGrid1';
		pmyGrid1.name='myGrid1';
		pmyGrid1.region='center';
		pmyGrid1.locatekeyvalue='';
		pmyGrid1.bartitle=pmyGrid1.title;
		pmyGrid1.showtitle='false';
		pmyGrid1.paramsql=pmyGrid1.sql;
		//存储grid中combo之类的sql语句，bbar等
		eval(pmyForm.gridcmpstr);
		eval(myDefineGrid(pmyGrid1));//生成grid
		pmyTree1.height=0;
		if (pmyTree1.width==0) pmyTree1.width=200;
		pmyTree1.roottitle='全部'+pmyGrid1.tabletitle;
		if (pmyTree1.nodefields!=undefined && pmyTree1.nodefields!=''){
			pmyTree1.groupfields=pmyTree1.nodefields+";-;*/取消分组";
		}else{
			pmyTree1.groupfields='';
		}
		pmyTree1.region='center';
		pmyTree1.selectedcode='';
		pmyTree1.rootcode='';
		pmyTree1.searchtext='';
		pmyTree1.filterfield='';
		pmyTree1.events='storeload;treeload';
		pmyTree1.sql=''; 
		pmyTree1.parentvalue='';
		pmyTree1.keyfield='';  //初始设置为空
		pmyTree1.sortfield='';
		pmyTree1.reloadflag=1;
		pmyTree1.singleexpand='true';
		pmyTree1.pageno=0;		
		pmyTree1.index=-1;		
		//pmyTree1.tbar='';//treetbar
		//pmyTree1.bbar='';
		//pmyTree1.fields='cid;text;nodetext;level;sysnumber;parentnodeid';
		pmyTree1.fields='';  //否则按表格显示
		pmyTree1.name='myTree1';		
		pmyTree1.varname='pmyTree1';		
		//生成编译得到的控件和事件		
		eval(pmyForm.tabstr); //定义表单myForm*
		eval(pmyForm.groupboxstr); //定义表单中的groupbox控件
		eval(pmyForm.fieldstr); //定义表单ffffff中的其他控件textfield,combo,datefield
		if (Ext.getCmp('myForm1')!=undefined){
			//将没有定义的列定义到myForm1
			eval(myAddHiddenFields(pmyGrid1.fieldset,'myForm1'));
			eval(myAddHiddenFields(pmyForm.hiddenfields,'myForm1'));
			//eval(myDefineHiddenField('myForm1','addoredit'));
		}
		eval(pmyForm.eventstr); //定义事件在hidden字段之后
		eval(myGenBtnMoveRecord());  //生成记录移动和指针设置两个函数
		/**************************定义工具栏tbar开始**********************************/
		//定义日期输入栏
		var str='';
		for (var i=1;i<=12;i++){
			if (str!='') str+=',';
			str+="['"+i+"']";
		}
		eval("var data_month=["+str+"];");
		var store_month=new Ext.data.SimpleStore ({
			fields: [{name: 'month', type: 'string'}],
			data: data_month
		});
		pmyWidth={};
		pmyWidth.tmp2="select xlevel=max(level) from products";
		str='';
		for (var i=sys.year-10;i<=sys.year;i++){
			if (str!='') str+=',';
			str+="['"+i+"']";
		}
		eval("var data_year=["+str+"];");
		var store_year=new Ext.data.SimpleStore ({
			fields: [{name: 'year', type: 'string'}],
			data: data_year
		});			
		var searchbar=Ext.create('Ext.toolbar.Toolbar',{
			region:'north',
			split:false,items:['-',{xtype: 'tbspacer', width: 5},
	        {id:'year', xtype:'combobox',labelSeparator:'',
	        fieldLabel:'选择年月：',store: store_year,
	        width:140,cls:'myFieldCSS',labelWidth:66,triggerAction:'all',
	        displayField:'year',valueField:'year',mode:'local',editable:false,
	        resizable:false,lazyRender:false,value:sys.year+'',
	        listeners:{
	        	select: function(combo, record, index){
	        		fnGenTable();
	        		fnLoadmyGrid1(1,'');
	        	}	        
	        }
	        },{text:'年&nbsp;'},
			{id:'month',xtype:'combobox',fieldLabel:'',labelSeparator:'',store: store_month,
			width: 50, cls:'myFieldCSS',labelWidth:20,triggerAction:'all',
			displayField:'month',valueField:'month',mode:'local',editable:false,
			resizable:false,lazyRender:false,value:sys.month+'',
			listeners:{
	        	select: function(combo, record, index){
	        		fnGenTable();
	        		fnLoadmyGrid1(1,'');
	        	}	        
	        }
			},{text:'月份'},'-'			
		]});			
		
		//定义菜单选项
		var mtitle='';
		if (pmyGrid1.filterfields!=undefined){
			var pfid={};
			pfid.fields=pmyGrid1.filterfields;
			pfid=myGetGridColumn(pfid);
			for (var i=0;i<pfid.xtitle.length;i++){
				if (pfid.xfield[i]!='sysrowno'){
					if (mtitle!='') mtitle+=';';
					mtitle=mtitle+pfid.xfield[i]+'/'+pfid.xtitle[i];
				}
			}
		}else{
			for (var i=0;i<pmyGrid1.xtitle.length;i++){
				if (pmyGrid1.xfield[i]!='sysrowno' && pmyGrid1.xshowtitle[i]){
					if (mtitle!='') mtitle+=';';
					mtitle=mtitle+pmyGrid1.xfield[i]+'/'+pmyGrid1.xtitle[i];
				}
			}
		}	
		eval(myDefineCheckMenu('myFilterCheckMenu',mtitle));
		var myGroupMenu=[];
		var myGroupMenux=[];
		eval(myDefineMenu('myGroupMenu',pmyTree1.groupfields,'menuitemIcon'));
		eval(myDefineMenu('myGroupMenux',pmyTree1.groupfields,'menuitemIcon'));
		var myContextMenu2=Ext.create('Ext.menu.Menu',{
			id:'myContextMenu',title:'选择分组',items: myGroupMenux
		});
		var tbar=Ext.create('Ext.toolbar.Toolbar',{region:'north',split:false,id:'tbar'});
		tbar.add({xtype:'tbspacer',width:2});
		tbar.add({id:'cmdbar', xtype:'tbseparator'});
		tbar.add({id:'cmdprint', iconCls: 'printerIcon',text: '打印',handler: fnPrintRecord,tooltip: '打印'+pmyGrid1.tabletitle+'列表',xaction:'print'});
		tbar.add({id:'printbar1', xtype:'tbseparator'});
    	tbar.add({id:'cmdgroup', iconCls: 'groupIcon',text: '分组',tooltip: '记录分组',menu:myGroupMenu});
		tbar.add({id:'groupbar1', xtype:'tbseparator'});
	    tbar.add({id:'cmdrefresh', iconCls: 'refreshIcon',text: '刷新', id:'refresh',name:'refresh',handler: fnRefreshRecord,tooltip: '刷新全部'});
		tbar.add({id:'filterbar1', xtype:'tbseparator'});
		tbar.add({id:'filterbar2', xtype:'tbspacer',width:2});
	    tbar.add({id:'filtertext',xtype:'textfield',emptyText: '快速过滤',enableKeyEvents:true,width:170});
		tbar.add({id:'columnchoose',text:'过滤列选择',menu:myFilterCheckMenu });
		tbar.add({id:'filterbar3', xtype:'tbseparator'});
	    tbar.add({iconCls: 'searchIcon',text: '过滤', id:'cmdfilter',name:'cmdfilter',handler: fnQuickFilter,tooltip: '开始条件过滤'},'-');
	    tbar.add({id:'rowfirst',iconCls: 'rowfirstIcon',text:'',handler: function(e) { myMoveRecord(e.id,pmyGrid1); },tooltip: '第一行'});
	    tbar.add({id:'rowprev', iconCls: 'rowprevIcon', text:'',handler: function(e) { myMoveRecord(e.id,pmyGrid1); },tooltip: '上一行'});
	    tbar.add({id:'rownext', iconCls: 'rownextIcon', text:'',handler: function(e) { myMoveRecord(e.id,pmyGrid1); },tooltip: '下一行'});
	    tbar.add({id:'rowlast', iconCls: 'rowlastIcon', text:'',handler: function(e) { myMoveRecord(e.id,pmyGrid1); },tooltip: '最后一行'},'-');
		/**************************定义工具栏tbar结束**********************************/	
		/**************************定义右击菜单开始******************************/
		var myContextMenu1=Ext.create('Ext.menu.Menu',{//菜单
	    items:[
	    	{xtype:'menuseparator',id:'refreshbar2'},
	        {text:'刷新',id:'poprefresh',iconCls:'refreshIcon',handler:fnRefreshRecord}
	    ]});	
		//可编辑grid中的右键菜单
		/**************************定义tree开始************************************/
		var treetbar=Ext.create('Ext.toolbar.Toolbar',{
			region:'north',spilt:false,items:[{
				text:'&nbsp;&nbsp;选择分组&nbsp;&nbsp;',menu:myGroupMenu
			}]
		});
		var wintoolbar=Ext.create('Ext.toolbar.Toolbar',{
			region:'north',split:false,items:[
				{id:'xrowfirst',iconCls: 'rowfirstIcon',text:'',width:22, handler: function(e) { fnMoveRecord(e.id); },tooltip: '第一行'},
				{id:'xrowprev',iconCls: 'rowprevIcon',text:'',width:24, handler: function(e)   { fnMoveRecord(e.id); },tooltip: '上一行'},
				{id:'xrownext',iconCls: 'rownextIcon',text:'',width:24, handler: function(e)   { fnMoveRecord(e.id); },tooltip: '下一行'},
				{id:'xrowlast',iconCls: 'rowlastIcon',text:'',width:24, handler: function(e)   { fnMoveRecord(e.id); },tooltip: '最后行'}
			]
		});
		pmyTree1.region='west';
	    eval(myDefineTree(pmyTree1));
		var root1=myTree1.setRootNode({
			text:pmyTree1.roottitle,
			iconCls: 'folderopenIcon',
            cid:'',
            level:0,
            expanded:false,                
            leaf:true                
		}); //修改根节点的值
		/**************************定义myGrid结束**********************************/
		//itemgridpanel定义
		var gridpanel=[];
		var str='';
		//按钮初始状态设置
		mySetCmpDisabled('cmdprint;popprint',false);
		mySetCmpDisabled(pmyForm.fileloadbutton,false);
		//计算按钮高度
		var titleheight=16*Math.max(pmyGrid1.bartitle.length,pmyForm.title.length)+20;
		titleheight=Math.max(90,titleheight);
		var s1='';
		for (var j=0;j<pmyGrid1.bartitle.length;j++){
			if (s1!='') s1+='<br>';
			s1+=pmyGrid1.bartitle.substr(j,1);
		}
		var s2='';
		for (var j=0;j<pmyForm.title.length;j++){
			if (s2!='') s2+='<br>';
			s2+=pmyForm.title.substr(j,1);
		}
		
		//wwwwww
		/****************************页面布局******************************/
		//myTree1.collapsed=true;
		mySetCmpVisible('cmdgroup;groupbar1',true);
		//定义页面布局
		eval(myDefinePanel('myGridPanel','','[myGrid1]',0,0,'false'));
		eval(myDefineTab('myFormTab','','center','['+pmyForm.panels+']',pmyForm.height,pmyForm.width,'false','myContextMenu1'));
		var myEditWin=Ext.create('Ext.window.Window', {
			height: pmyForm.height+64, //高度
			width: pmyForm.width+6, //宽度
			closeAction: 'hide',//关闭按钮 效果是隐藏当前窗体
			modal:true,
			resizable:false,
			layout: 'absolute',//布局方式
			buttons:[
				wintoolbar,'->',
				{text:'保存',id:'btnsave', height:25,handler:function(){ fnSaveRecord(); }},
				{text:'取消',id:'btnclose',height:25,handler:function(){ myEditWin.hide(); }}
			],	
			listeners:{
				show:function(){
					//
				}
			}
		});
		//只有一个表单时去掉window中的formpanel标题
		if (pmyForm.pagecount>1) myEditWin.add(myFormTab);
		else myEditWin.add(myForm1);
		//页面布局
		var myView=Ext.create('Ext.Viewport', {
	       layout: { type: 'border', padding: 5 },
	       defaults: { split: true },
	       items: [tbar,myGrid1]
	    });			
		//工具条设置
		pmyTable.editflag=[0,0,0,0,0,0];
		if (pmyTable.permission.indexOf(';print;')<0){
			mySetCmpVisible('cmdprint;popprint;printbar1;printbar2',false);
		}
		if (pmyTable.permission.indexOf(';filter;')<0){
			mySetCmpVisible('cmdfilter;filterbar1;filterbar2;filterbar3;filtertext;columnchoose',false);
		}
		/*
		//myTree1事件
		myTree1.on('beforeload',function(store) {  //bbbbbbe
			var sql=fnGenTreeSql(myTree1);
			var newparams={ database:sysdatabasestring, sqlString:sql,keyField:'cid' };
			Ext.apply(store.proxy.extraParams,newparams);
			store.proxy.url='system//fn_getChildNodes.jsp';					
		});				
		myTree1.on('load',function(){
	    	var root=myTree1.getRootNode();
	    	root.set('text',pmyTree1.grouptext+'（'+root.childNodes.length+'组）');
	    	root.expand();
			var records=this.getSelectionModel().getSelection();
			if (records[0] && records[0]!=root){
			   	records[0].set('text',records[0].get('text')+'（'+records[0].childNodes.length+'组）');
			}
		});
		myTree1.on('select',function(model, record, index) {//监听树选中时间
			pmyTree1.pageno=1;
			pmyGrid1.index=0;
           	fnLoadmyGrid1(1,'');
		});
		myTree1.on('containercontextmenu',function(tree, e){  //定义右键   		
   			e.preventDefault();
   			myContextMenu2.showAt(e.getXY());
   		});
   		myTree1.on('itemcontextmenu',function(tree, record, item, index, e){  //定义右键   		
   			e.preventDefault();
   			myContextMenu2.showAt(e.getXY());
   		});
   		*/
  		
		/**************************定义tree结束***********************************/
		//定义myGrid1事件
		myGrid1.on('beforeload',function(store) {  //bbbbbbe
			var sql=pmyGrid1.sql;
			var newparams={ database:sysdatabasestring, sqlString:sql,keyField:'cid' };
			Ext.apply(store.proxy.extraParams,newparams);
			store.proxy.url='system//fn_getChildNodes.jsp';					
		});				

		myGrid1.store.on('load',function(store){
		/*
			pmyGrid1.error=0;
			var index=0;
			if (pmyGrid1.index>=0 && pmyGrid1.index<myGrid1.store.getCount()){
				index=pmyGrid1.index;
			}				 	
			//if (index<0) index=0;
			//pmyGrid1.index=-1;
			pmyGrid1.column=0;
			if (index<0) index=0;
			if (myGrid1.store.getCount()>0 && index<myGrid1.store.getCount()){		
				setTimeout(function(){
				myGrid1.getSelectionModel().select(index);
				},10);
			}
			*/	
    	});

		myGrid1.on('itemdblclick',function(view,record,item,index,event) {
			//fnLoadRecord();			
          		myEditWin.setTitle(pmyForm.title);
           		myEditWin.show();
		}); 
		
		myGrid1.on('itemclick',function(view,record,item,index,event) {
			fnLoadRecord();
		}); 
		myGrid1.on('select',function(model,record,index) {  //schange
			//记录myTree对应的grid中的页码和行号，以便下次定位
			var tabno=1;
			var pmyTree=eval('pmyTree'+tabno);
			pmyTree.pageno=myGrid1.store.currentPage;
			pmyTree.index=index;
			mySetMoveRecordBtn(myGrid1,record);	//调用函数,控制记录移动指针的disabled状态
			mySetCmpDisabled('xrowfirst;xrownext;xrowprev;xrowlast',false);
			if (record.get('sysrowno')==1) mySetCmpDisabled('xrowfirst;xrowprev',true);
			if (record.get('sysrowno')==myGrid1.store.getTotalCount()) mySetCmpDisabled('xrowlast;xrownext',true);
			fnLoadRecord();
		});
		
		myGrid1.on('containercontextmenu',function(grid, e){  //定义右键   		
   			e.preventDefault();
   			myContextMenu1.showAt(e.getXY());
   		});
   		
   		myGrid1.on('itemcontextmenu',function(grid, record, item, index, e){  //定义右键   		
   			e.preventDefault();
   			grid.getSelectionModel().select(record);//选中指定行号的记录   
   			myContextMenu1.showAt(e.getXY());
   		});
   		
		/**************************以下是函数************************************/
		//tabchange事件
		function fnPrintRecord(){  //ppppppp
			var date=sys.year+'年'+sys.month+'月'+sys.day+'日';
			var xtemplate=pmyReport1.templatename;
			var xtargetfilename=pmyReport1.targetname;
			var xfieldset='';
			for (var i=0;i<myGrid1.columns.length;i++){
				if (myGrid1.columns[i].dataIndex!='sysrowno'){
					if (xfieldset!='') xfieldset+=',';
					xfieldset+=myGrid1.columns[i].dataIndex;
				}
			}
			var xsortfield='';
			if (pmyReport1.sortfield!='') xsortfield=pmyReport1.sortfield;
			else if (pmyGrid1.sortfield!='') xsortfield=pmyGrid1.sortfield;
			if (pmyGrid1.keyfield!='' && pmyGrid1.keyfield!=undefined){
				if (xsortfield!='') xsortfield+=',';
				xsortfield+=pmyGrid1.keyfield;
			} 
			if (pmyReport1.sql=='' || pmyReport1.sql==undefined){
				var xsql="select "+xfieldset+" from ("+pmyGrid1.paramsql+") as p ";
				if (xsortfield!=''){
					xsql+=" order by "+xsortfield;
				}				
			}else{
				var xsql=pmyReport1.sql;
			}
			console.log(xsql);
			//var xtitlecells="<2,1>"+date+';<3,1>yyyyyy';  //分号分割
			//var xtitlerange="<1>-<4>";
			pmyFooter1.footercells='';
			if (pmyForm.reportcmpstr!='') eval(pmyForm.reportcmpstr);
			var xtitlecells=pmyReport1.titlecells;
			
			console.log(pmyForm.reportcmpstr);
			alert(pmyFooter1.footercells);
			var xfootercells=pmyFooter1.footercells;
			var xtitlerange="";
			if (pmyReport1.titlerows>0){
				xtitlerange="<1>-<"+pmyReport1.titlerows+">";  //标题为第1行到第n行，每页重复
			}
			var r=myExportExcelReport(sysdatabasestring,xtemplate,xsql,xtitlecells,xtitlerange,xfootercells,'',xtargetfilename);		
		}
	
		function fnRefreshRecord(){  //rrrrre刷新
			Ext.getCmp('filtertext').setValue('');
			/*
			var root=myTree1.getRootNode();
			root.removeAll();
			var root=myTree1.setRootNode({
				text:pmyTree1.roottitle,
        	    iconCls: 'folderopenIcon',
        	    cid:'',
            	level:0,
            	expanded:false,                
            	leaf:true                
			}); //修改根节点的值
			pmyTree1.reloadflag=0;
			pmyTree1.pageno=1;
			*/
			pmyGrid1.index=0;
			//fnLoadmyTree(myTree1);
			fnLoadmyGrid1(1,'');
		}
		
		function fnLoadmyGrid1(pageno,wheresql){ //lllllo重新加载grid数据
			var xsortfield='';
			if (pmyGrid1.sortfield!='') xsortfield=pmyGrid1.sortfield;
			if (pmyGrid1.keyfield!='' && pmyGrid1.keyfield!=undefined){
				if (xsortfield!='') xsortfield+=',';
				xsortfield+=pmyGrid1.keyfield;
			} 
			var sql=pmyGrid1.sql;
			var wheresqlx='';
			if (wheresql!=''){
				sql="select * from ("+pmyGrid1.sql+") as p where ("+wheresql+')';
			}
			pmyGrid1.sortfield=xsortfield;
			pmyGrid1.paramsql=sql;	
			//console.log(sql);
			//console.log(pmyGrid1.summaryfieldsql);
			var xpagesize=myGrid1.store.pageSize;
			var newparams={ database:sysdatabasestring, sqlString:sql,keyField:pmyGrid1.keyfield,sortField:pmyGrid1.sortfield,limit:xpagesize,summaryFields:pmyGrid1.summaryfieldsql };
			Ext.apply(myGrid1.store.proxy.extraParams,newparams);
			if (pageno>0) myGrid1.store.loadPage(pageno); 	        
			else myGrid1.store.loadPage(1);
		}

				
		//快速过滤函数
		function fnQuickFilter(){
			var xfilter=Ext.getCmp('filtertext').getValue();
			var xfiltersql=myGetFilterSql(myFilterCheckMenu,xfilter);  //获取过滤条件
			//console.log(xfiltersql);
 			pmyGrid1.locatevalue='';
			//pmyTree1.reloadflag=1;
			fnLoadmyGrid1(1,xfiltersql);			
		}


		function fnKeyEvent(field,e) {
			//myKeyEvent(field,e,myFormTab);  //笤俑functions中的函数
		}		
		
		function fnLoadRecord(){  //lll
			var records=myGrid1.getSelectionModel().getSelection();
			for (var i=1;i<=pmyForm.pagecount;i++) {
				eval(mySetFormReadOnly('myForm'+i,'true'));
			}
			if(records[0]){	
				for (var i=1;i<=pmyForm.pagecount;i++) {
					eval('myForm'+i+'.getForm().loadRecord(records[0]);');
	           	}
	           	//特殊字段处理
				for (var j=0;pmyForm.labelfielddim!=undefined && j<pmyForm.labelfielddim.length;j++){
					var ff=p.xfielddim[pmyForm.labelfielddim[j]].name;
					Ext.getCmp(ff).setText(records[0].get(ff));
				}
			}else{  //找不到grid中记录时，清空从表记录和表单
				for (var i=1;i<=pmyForm.pagecount;i++) {
					eval("myForm"+i+".getForm().reset();");
	           	}
			}
			mySetCmpDisabled(pmyForm.fileloadbutton,true);
		}	
		
		
		function fnGenTreeSql(myTree){
			var tabno=1;
			var pmyTree=eval('pmyTree'+tabno);
			var myTree=eval('myTree'+tabno);			
			var records=myTree.getSelectionModel().getSelection();
			if (records[0]){
				var xlevel=1*records[0].get('level');
				var xid=records[0].get('cid');
			}else{
				var xlevel=0;
				var xid='';
			}
			var f1="case when "+pmyTree.groupfield[xlevel+1]+"<>'' then "+pmyTree.groupfield[xlevel+1]+" else '其他' end "; 
			var f2="case when "+pmyTree.groupfield[xlevel+1]+"<>'' and "+pmyTree.groupfield[xlevel+1]+" is not null then 0 else 1 end"; 
			var sql="select distinct "+f1+" as cid,"+f1+" as nodetext,"+f2+" as sortflag,\n";
			sql+="'' as parentnodeid,"+(xlevel+1)+" as level\n";
			if (xlevel<pmyTree.groupfield.length-2) sql+=",1 as isparentflag \n";
			else sql+=",0 as isparentflag ";
			sql+=" from ("+pmyGrid1.sql+") as p\n";
			//取各层条件
			var wheresqly='';
			var pnode=records[0];
			for (var j=xlevel;j>=1;j--){
				var xfield=pmyTree.groupfield[j];
				if (wheresqly!='') wheresqly+=" and ";
				//处理”其他“值，其对应的sortflag=1
				if (pnode.get('sortflag')==1) wheresqly+="("+pmyTree.groupfield[j]+"='' or "+pmyTree.groupfield[j]+" is null) ";
				else wheresqly+=xfield+"='"+pnode.get('cid')+"'";
				pnode=pnode.parentNode;	           		
			}
			if (wheresqly!='') sql+=" where "+wheresqly;  //pmyTree.groupfield[xlevel]+"='"+pmyTree1.rootcode+"'"; 
			sql+=" order by sortflag,cid";
			//sql+=" order by "+pmyTree.groupfield[xlevel+1];
			//console.log('treesql='+sql);
			return(sql);
		}		
		
		function fnMoveRecord(id){
			if (id=='xrowfirst') myMoveRecord('rowfirst',pmyGrid1);
			else if (id=='xrowlast') myMoveRecord('rowlast',pmyGrid1);
			else if (id=='xrownext') myMoveRecord('rownext',pmyGrid1);
			else if (id=='xrowprev') myMoveRecord('rowprev',pmyGrid1);
		}		

		//初始化ccccc
		//myTree1.collapse();
		fnLoadmyGrid1(1,'');
		//pmyTree1.reloadflag=0;
		for (var i=1;i<=pmyForm.pagecount;i++) {
			eval(mySetFormReadOnly('myForm'+i,'true'));
		}
	 //选中第一页面按钮
	//****************************end of extjs**************************//
			
	}); 
  
  </script>
  </body>
</html>


