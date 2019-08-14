<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="com.DBConn" %>
<%@ page import="com.UserBean" %>
<%@ page import="com.StringUtil"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>TGridCheckTree模板</title>
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
			//response.sendRedirect("login.jsp");//重定向
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
		var maxReturnNumber=0;  //一次从后台返回记录的数量，超过该值树中节点将分层获取。
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
		if (pmyGrid1.tablename=='') pmyGrid1.tablename=pmyTable.tablename;
		if (pmyGrid1.tabletitle=='') pmyGrid1.tabletitle=pmyGrid1.title;
		if (pmyGrid1.keyspec=='') pmyGrid1.keyspec=pmyTable.keyspec;
		if (pmyGrid1.sortfield=='')	pmyGrid1.sortfield=pmyTable.sortfield;
		if (pmyGrid1.sortfield=='') pmyGrid1.sortfield=pmyGrid1.keyfield;
		if (pmyTable.tablename=='' && pmyGrid1.tablename!='') pmyTable.tablename=pmyGrid1.tablename;
		pmyTable.keyfield=pmyGrid1.keyfield;  //onchange时用
		pmyTable.keyspec=pmyGrid1.keyspec;
		pmyTable.sortfield=pmyGrid1.sortfield;
		if (pmyGrid1.sql=='' && pmyGrid1.tablename!='')	pmyGrid1.sql="select * from "+pmyGrid1.tablename;
		if (pmyForm.rowheight!=undefined && pmyForm.rowheight!='') var rowHeight=pmyForm.rowheight;
		else var rowHeight=32;
		pmyGrid1.bartitle=pmyGrid1.title;
		//pmyGrid1.title='';
		if (pmyTree1.pagesize!=undefined && pmyTree1.pagesize!='') maxReturnNumber=1*pmyTree1.pagesize;
  		pmyTable.permission=';'+myGetOneAttr(p.service,'permissions')+';';
  		sys.year=myGetDatePart('year',sysdate);
		sys.month=myGetDatePart('month',sysdate);
		sys.day=myGetDatePart('day',sysdate);
		sys.date=sys+'-'+sys.month+'-'+sys.day;
		sys.date0=sys.year+'-01-01';
		sys.date1=sys.year+'-'+sys.month+'-01';
		sys.date2=sys.year+'-'+sys.month+'-'+myDaysInaMonth(sys.year,sys.month);
		//grid初始设置
		pmyGrid1.index=-1;  //聚焦的行号
		pmyGrid1.column=-1;
		pmyGrid1.varname='pmyGrid1';
		pmyGrid1.name='myGrid1';
		pmyGrid1.region='west';
		pmyGrid1.locatekeyvalue='';
		pmyGrid1.paramsql='';
		pmyGrid1.contextmenu='myContextMenu1';
		//存储grid中combo之类的sql语句，bbar等
		pmyTree1.height=0;
		if (pmyTree1.width==0) pmyTree1.width=200;
		pmyTree1.roottitle='全部'+pmyTable.tabletitle;
		pmyTree1.region='center';
		pmyTree1.selectedcode='';
		pmyTree1.rootcode='';
		pmyTree1.searchtext='';
		pmyTree1.events='storeload;treeload';
		pmyTree1.parentvalue='';
		pmyTree1.reloadflag=1;
		pmyTree1.singleexpand='false';
		pmyTree1.pageno=0;		
		pmyTree1.index=-1;		
		pmyTree1.name='myTree1';		
		pmyTree1.varname='pmyTree1';		
		pmyTree1.contextmenu='myContextMenu2';
		//生成编译得到的控件和事件		
		eval(pmyForm.tabstr); //定义表单myForm*
		eval(pmyForm.groupboxstr); //定义表单中的groupbox控件
		eval(pmyForm.fieldstr); //定义表单ffffff中的其他控件textfield,combo,datefield
		eval(pmyForm.gridcmpstr);
		/**************************定义工具栏tbar开始**********************************/
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
		var tbar=Ext.create('Ext.toolbar.Toolbar',{region:'north',split:false,id:'tbar'});
		tbar.add({xtype:'tbspacer',width:2});
		tbar.add({id:'cmdbar', xtype:'tbseparator'});
		tbar.add({id:'cmdadd', iconCls: 'addIcon',text: '新增',handler: fnAddRecord,tooltip: '增加新记录',xaction:'add'});
		tbar.add({id:'cmdupdate', iconCls: 'editIcon',text: '修改',handler: fnEditRecord,tooltip: '修改当前记录',xaction:'update'});
		tbar.add({id:'cmddelete', iconCls: 'deleteIcon',text: '删除',handler: fnDeleteRecord,tooltip: '删除当前记录',xaction:'delete'});
		tbar.add({id:'cmdeditbar1', xtype:'tbseparator'});
		tbar.add({id:'cmdsave', iconCls: 'saveIcon',text: '保存',handler: fnSaveRecord,tooltip: '保存正在修改或新增的记录',xaction:'save'});
		tbar.add({id:'cmdsavebar1', xtype:'tbseparator'});
		tbar.add({id:'cmdprint', iconCls: 'printerIcon',text: '打印',handler: fnPrintRecord,tooltip: '打印'+pmyTable.tabletitle+'列表',xaction:'print'});
		tbar.add({id:'cmdprintbar1', xtype:'tbseparator'});
	    tbar.add({id:'cmdrefresh', iconCls: 'refreshIcon',text: '刷新', id:'refresh',name:'refresh',handler: fnRefreshRecord,tooltip: '刷新全部'});
		tbar.add({id:'cmdfilterbar1', xtype:'tbseparator'});
		tbar.add({id:'cmdfilterbar2', xtype:'tbspacer',width:2});
	    tbar.add({id:'filtertext',xtype:'textfield',emptyText: '快速过滤',enableKeyEvents:true,width:170});
		tbar.add({id:'columnchoose',text:'过滤列选择',menu:myFilterCheckMenu });
		tbar.add({id:'cmdfilterbar3', xtype:'tbseparator'});
	    tbar.add({iconCls: 'searchIcon',text: '过滤', id:'cmdfilter',name:'cmdfilter',handler: fnQuickFilter,tooltip: '开始条件过滤'},'-');
	    tbar.add({id:'rowfirst',iconCls: 'rowfirstIcon',text:'',handler: function(e) { myMoveRecord(e.id,pmyGrid1); },tooltip: '第一行'});
	    tbar.add({id:'rowprev', iconCls: 'rowprevIcon', text:'',handler: function(e) { myMoveRecord(e.id,pmyGrid1); },tooltip: '上一行'});
	    tbar.add({id:'rownext', iconCls: 'rownextIcon', text:'',handler: function(e) { myMoveRecord(e.id,pmyGrid1); },tooltip: '下一行'});
	    tbar.add({id:'rowlast', iconCls: 'rowlastIcon', text:'',handler: function(e) { myMoveRecord(e.id,pmyGrid1); },tooltip: '最后一行'},'-');
		/**************************定义工具栏tbar结束**********************************/	
		/**************************定义右击菜单开始******************************/
		var myContextMenu1=Ext.create('Ext.menu.Menu',{//菜单
	    items:[
			{text:'新增',id:'popxadd',iconCls:'addIcon',handler:fnAddRecord,xaction:'add'},
			{text:'修改',id:'popxupdate',iconCls:'editIcon',handler: fnEditRecord,xaction:'update'},
	    	{text:'删除',id:'popxdelete',iconCls:'deleteIcon',handler:fnDeleteRecord,xaction:'delete'},
	    	{id:'popxsavebar1',xtype:'menuseparator'},
	    	{text:'保存',id:'popxsave',iconCls:'saveIcon',handler:fnSaveRecord,xaction:'save'},
	    	{id:'popxrefreshbar1',xtype:'menuseparator'},
	        {text:'刷新',id:'popxrefresh',iconCls:'refreshIcon',handler:fnRefreshRecord}
	    ]});	
		//可编辑grid中的右键菜单
		var myContextMenu2=Ext.create('Ext.menu.Menu',{//菜单
	    items:[
			{text:'全选',id:'popyall',iconCls:'addIcon',handler:function(e){fnAllNodes(e.id);},xaction:'add'},
			{text:'反选',id:'popynone',iconCls:'addIcon',handler: function(e){fnAllNodes(e.id);},xaction:'add'},
	    	{id:'popysavebar1',xtype:'menuseparator'},
	    	{text:'保存',id:'popysave',iconCls:'saveIcon',handler:fnSaveRecord,xaction:'save'},
	    	{id:'popyrefreshbar1',xtype:'menuseparator'},
	        {text:'重载',id:'popyrefresh',iconCls:'refreshIcon',handler:fnRefreshNodes}
	    ]});	
		/**************************定义右击菜单结束******************************/
		/**************************定义tree开始************************************/
		var wintoolbar=Ext.create('Ext.toolbar.Toolbar',{
			region:'north',split:false,items:[
				{id:'xrowfirst',iconCls: 'rowfirstIcon',text:'',width:22, handler: function(e) { fnMoveRecord(e.id); },tooltip: '第一行'},
				{id:'xrowprev',iconCls: 'rowprevIcon',text:'',width:24, handler: function(e)   { fnMoveRecord(e.id); },tooltip: '上一行'},
				{id:'xrownext',iconCls: 'rownextIcon',text:'',width:24, handler: function(e)   { fnMoveRecord(e.id); },tooltip: '下一行'},
				{id:'xrowlast',iconCls: 'rowlastIcon',text:'',width:24, handler: function(e)   { fnMoveRecord(e.id); },tooltip: '最后行'}
			]
		});
		//设置对其方式
		//alert(pmyGrid1.align);
		if (pmyGrid1.align!=''){
		    if (pmyGrid1.align=='left') {
		    	pmyGrid1.region='west';
		    }else if (pmyGrid1.align=='right'){
		    	pmyGrid1.region='east';
			}else if (pmyGrid1.align=='top'){
				pmyGrid1.region='north';
			}else if (pmyGrid1.align=='bottom'){
				pmyGrid1.region='south';
			}
		}else if (pmyTree1.align!=''){
		    if (pmyTree1.align=='left') {
		    	pmyGrid1.region='west';
		    }else if (pmyTree1.align=='right'){
	    		pmyGrid1.region='east';
			}else if (pmyTree1.align=='top'){
				pmyGrid1.region='south';
			}else if (pmyTree1.align=='bottom'){
				pmyGrid1.region='north';
			}
		}
    	pmyTree1.region='center';
	    if (pmyForm.modal=='window'){
	    	pmyForm.region='center';
	    }else{
	    	if (pmyGrid1.region=='west' || pmyGrid1.region=='east') pmyForm.region='north';
	    	else if (pmyGrid1.region=='north' || pmyGrid1.region=='south') pmyForm.region='west';
	    }		
		//alert(pmyForm.modal);
		//生成sql语句
		pmyTree1=myGetTreeNodeTextFields(pmyTree1);
		if (pmyTree1.sql==''){
			pmyTree1.sql="select "+pmyTree1.keyfield+" as 'cid',"+pmyTree1.nodetextfields+" as 'nodetext',*,1 as syschecked from "+pmyTree1.tablename;
		}else{	
			pmyTree1.sql="select "+pmyTree1.keyfield+" as 'cid',"+pmyTree1.nodetextfields+" as 'nodetext',*,1 as syschecked from ("+pmyTree1.sql+") as p";
	    }
		eval(myDefineGrid(pmyGrid1));//生成grid
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
		//将没有定义的列定义到myForm1
		eval(myAddHiddenFields(pmyGrid1.fieldset,'myForm1'));
		eval(myAddHiddenFields(pmyForm.hiddenfields,'myForm1'));
		eval(myDefineHiddenField('myForm1','addoredit'));
		eval(pmyForm.eventstr); //定义事件在hidden字段之后
		eval(myGenBtnMoveRecord());  //生成记录移动和指针设置两个函数
		
		//按钮初始状态设置
		mySetCmpDisabled('cmdadd;popadd;cmdupdate;popupdate;cmddelete;popdelete;cmdprint;popprint',false);
		mySetCmpDisabled(pmyForm.fileloadbutton,false);
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
		eval(myDefineTab('myFormTab','',pmyForm.region,'['+pmyForm.panels+']',pmyForm.height,pmyForm.width,'false','myContextMenu1'));
		if (pmyForm.pagecount>0){
			myEditWin.add(myFormTab);  //tab时scrollbar和splitter起作用
		}else{
			myEditWin.add(myForm1);
		}
		if (pmyForm.pagecount>0){
			var xform=myFormTab;
		}else{
			myForm1.region=pmyForm.region;
			myForm1.setWidth(pmyForm.width);
			var xform=myForm1;
			myFormTab.setVisible(false);
		}
		//页面布局
		if (pmyForm.modal=='window'){
			var myView=Ext.create('Ext.Viewport', {
		        layout: { type: 'border', padding: 5 },
		        defaults: { split: true },
		        items: [tbar,myGrid1,myTree1]
		    });		
		}else{	
		var splitter1=Ext.create('Ext.resizer.Splitter',{
		        	region:'west', layout:'border'});		
			var myView=Ext.create('Ext.Viewport', {
				layout: { type: 'border', padding: 5 },
				defaults: { split: true },
				items: [tbar,myGrid1,Ext.create('Ext.panel.Panel',{
		        	region:'center',
		        	layout:'border',
		        	items:[	xform,        	
		        	myTree1 ]
		        })]			        	
			});	
			
		}	
		//工具条设置
		pmyTable.editflag=[0,0,0,0,0,0];
		if ((pmyTable.permission).indexOf(';add;')<0){
			mySetCmpVisible('cmdadd;popadd',false);
		}else pmyTable.editflag[1]=1;
		if (pmyTable.permission.indexOf(';update;')<0){
			mySetCmpVisible('cmdupdate;popupdate',false);
		}else pmyTable.editflag[2]=1;
		if (pmyTable.permission.indexOf(';delete;')<0){
			mySetCmpVisible('cmddelete;popdelete',false);
		}else pmyTable.editflag[3]=1;
		if (pmyTable.permission.indexOf(';print;')<0){
			mySetCmpVisible('cmdprint;popxprint;cmdprintbar1',false);
		}
		if (pmyTable.permission.indexOf(';filter;')<0){
			mySetCmpVisible('cmdfilter;cmdfilterbar1;cmdfilterbar2;cmdfilterbar3;filtertext;columnchoose',false);
		}
		if (pmyTable.editflag[1]+pmyTable.editflag[2]==0){  //查询状态
			mySetCmpVisible('cmdbar;cmdsave;popsave;cmdsavebar1;popxsavebar1;btnsave',false);
			if (Ext.getCmp('btnclose')!=null) Ext.getCmp('btnclose').setText('关闭');		
		}else if (pmyTable.editflag[1]+pmyTable.editflag[2]+pmyTable.editflag[3]==0){  //查询状态	
			mySetCmpVisible('cmdbar',false);
		}
		//myTree1事件
		myTree1.on('beforeload',function(store) {  //bbbbbbe
			var newparams={ database:sysdatabasestring, maxReturnNumber:0,sqlString: pmyTree1.sql,keyField:pmyTree1.keyfield,rootCode:pmyTree1.rootcode,selectedCode:pmyTree1.selectedcode,searchText:pmyTree1.searchtext };
			Ext.apply(store.proxy.extraParams,newparams);
			store.proxy.url='system//fn_getTreeNodes.jsp';					
		});	
					
		myTree1.on('load',function(){
	    	var root=myTree1.getRootNode();
		});
		myTree1.on('select',function(model, record, index) {//监听树选中时间
			//pmyTree1.setchkflag=record.get('checked');
		});
		/*
		myTree1.on('containercontextmenu',function(tree, e){  //定义右键   		
   			e.preventDefault();
   			myContextMenu2.showAt(e.getXY());
   		});
   		myTree1.on('itemcontextmenu',function(tree, record, item, index, e){  //定义右键   		
   			e.preventDefault();
   			myContextMenu2.showAt(e.getXY());
   		});
		*/
		
		myTree1.on('xitemclick',function(tree,record ){
			node=record;
			//alert(pmyTree1.setchkflag);
			//alert(node.hasChildNodes());
			if (pmyTree1.setchkflag!=''){
				if (node.hasChildNodes()){
		    		node.set('checked',pmyTree1.setchkflag);
		        	//node.expand();
	    	    	node.eachChild(function(child) {
	           			child.set('checked',pmyTree1.setchkflag);
	           			//myTree1.fireEvent('checkchange', child, pmyTree1.setchkflag);     
	        		});
	        	}else{
		  			//设置各级父节点的状态
	  				//pmyTree1.setchkflag=0;
	  				fnSetParentNodeState(node);
	        	}
	        }	
	        /*	
			//if (record.get('leaf')) pmyTree1.setchkflag=1;
			//else pmyTree1.setchkflag=0;
			*/
		});
				
		myTree1.on('checkchange', function(node, checked) {   //
			pmyTree1.setchkflag=checked;
			/*
			node.parentNode.cascadeBy(function(n){
		    	n.set('checked', checked);
		    });
		    */
		    //错误：父节点无法点击
		    if (node.hasChildNodes()){
				var setchkflag=0;  
	    		node.set('checked',checked);
    	    	node.eachChild(function(child) {
           			child.set('checked',checked);
           			myTree1.fireEvent('checkchange', child, checked);
        		});
        	}else{
	  			//设置各级父节点的状态
	  			fnSetParentNodeState(node);
        	}
    	});   

 	function fnSetParentNodeState(node){
	  		//设置各级父节点的状态。当小按钮选项发生变化，叶子节点选项发生变化，父节点可能也要随之变化。
	  		myTree1.suspendEvents(true);
	  		if (node!=root){ 
	  		//console.log(node.get('cid'));
	  			var pnode=node.parentNode;
	  			for (; pnode!=root; pnode=pnode.parentNode) {
					var flag=0;
					pnode.eachChild(function(child) {     
           				if (child.get('checked')) flag=1;
	        		});
	        		pnode.set('checked',flag);
	        		//处理下一个父节点
				}
			}
			myTree1.resumeEvents();
	  	}
  		
		//定义myGrid1事件
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
			if (pmyForm.modal=='window'){
				myEditWin.setTitle(pmyForm.title);
           		myEditWin.show();
           	}
		}); 
		
		myGrid1.on('select',function(model,record,index) {  //schange
			//记录myTree对应的grid中的页码和行号，以便下次定位
			fnLoadRecord();
			fnResetNodes(record);
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
		myFormTab.on('tabchange',function(tabPanel,newCard,oldCard,eOpts ){
	    	myFocusInTab(tabPanel);  //聚焦第一个非只读控件 					
		});

		function fnPrintRecord(){  //ppppppp
			var date=sys.year+'年'+sys.month+'月'+sys.day+'日';
			var xtemplate="TCustomerQuery.xls";
			var xsql=" select customerid,customername,address,province,city,zip,phone,fax,homepage,contactname,employeename";
			xsql+=" from ("+pmyGrid1.paramsql+") as p";
			xsql+=" order by "+pmyTable.sortfield;
			//console.info(xsql);
			var xtitlecells="<2,1>"+date;
			var xtitlerange="<1>-<3>";  //标题为第1行到第4行，每页重复
			var xtargetfilename="客户基本信息列表.xls";
			var r=myExportExcelReport(xtemplate,xsql,xtitlecells,xtitlerange,'','',xtargetfilename);		
		}
		
		function fnAddRecord(){//新增 aaaaaa
       		for (var i=1;i<=pmyForm.pagecount;i++) {
       			eval("myForm"+i+".getForm().reset();");
       			eval(mySetFormReadOnly('myForm'+i,'false'));
       		}	
       		Ext.getCmp(pmyGrid1.keyfield).setReadOnly(false);
			mySetCmpDisabled('cmdsave;popsave;btnsave;',false);	
			mySetCmpDisabled('cmdupdate;popupdate;cmddelete;popdelete',true);
			//myContextMenu2.setDisabled(false);
			mySetCmpDisabled(pmyForm.fileloadbutton,true);
			eval(mySetsysVarsReadOnly(true));
			fnAllNodes('popynone');
			//设置系统序号只读状态
			/*
			if (pmyForm.sysnumberdim!=undefined && pmyForm.sysnumberdim.length>0){
				for (var j=0;j<pmyForm.sysnumberdim.length;j++){
					Ext.getCmp(p.xfielddim[pmyForm.sysnumberdim[j]].name).setReadOnly(true);
				}
			}
			*/
			//mySetCmpDisabled('filepathcmdup;filepathicon',true);
			Ext.getCmp('addoredit').setValue('1');
			if (pmyForm.modal=='window'){
				myEditWin.setTitle('新增'+pmyTable.tabletitle);
				myEditWin.show();
			}
			if (myFormTab.isVisible()){
				myFormTab.setActiveTab(0);
	    		myFocusInTab(myFormTab);
	    	}else myFocusInTab(myForm1);        		
		}
		
		function fnEditRecord(){   //eeeeeeeee
			Ext.getCmp('addoredit').setValue('2');
			mySetCmpDisabled('cmdsave;popsave;btnsave',false);
			//myContextMenu2.setDisabled(false);
       		for (var i=1;i<=pmyForm.pagecount;i++) {
       			eval(mySetFormReadOnly('myForm'+i,'false'));
       		}	
       		Ext.getCmp(pmyGrid1.keyfield).setReadOnly(true);
			mySetCmpDisabled('cmdupdate;popupdate;cmddelete;popdelete;cmdsave;popsave;btnsave',false);
			//mySetCmpDisabled('filepathcmdup;filepathicon',false);
			mySetCmpDisabled(pmyForm.fileloadbutton,false);
			if (pmyForm.modal=='window'){
				myEditWin.setTitle('修改'+pmyTable.tabletitle);
				myEditWin.show();
			}	
			if (myFormTab.isVisible()){
				//myFormTab.setActiveTab(0);
	    		myFocusInTab(myFormTab);
	    	}else myFocusInTab(myForm1);        		
		}
		
		function uploadfile(){ //上传附件
			var records=myGrid1.getSelectionModel().getSelection();//获取gird所有选中的records
			if(records[0]){	//获取第一个record对象
			}					
		}
		//保存记录
		function fnSaveRecord(){   //ssssss
			if (pmyTable.tablename==pmyGrid1.tablename){
				var pt=pmyTable;
				var pr=p.replace;
				var pv=p.validation;
			}else{
				var pt=pmyGrid1;
				var pr=p.replace;
				var pv=p.validation;
			}
			var xaddoredit=Ext.getCmp('addoredit').getValue();
			var xid='';
			pmyTable.error='';
			if (Ext.getCmp(pmyGrid1.keyfield)!=null){
				xtype=Ext.getCmp(pmyGrid1.keyfield).getXType().toLowerCase();
				xid=Ext.getCmp(pmyGrid1.keyfield).getValue();
				if (xtype=='datefield'){
					xid=Ext.util.Format.date(xid,sysfulldateformat);
					if (xid=='' || xid=='1900-01-01') xid='null';
				}
			}
			//Ext.getCmp('filename').setValue(Ext.getCmp('filepathsource').getValue());
			//数据保存前系统变量赋值,返回字符串命令
			eval(mySetSysVars());  
			//前台主表验证数据和替换replace & validation
			pmyTable.error='';  //出错信息
			eval(myFormReplaceValidation(pmyGrid1,p.replace, p.validation));
			var xvalues=fnGetTreeCheckState();
			pmyTable.msg='';  //提示信息
       		var updatesql='';
       		var querysql='';
			//自动编码列重新计算（当新增记录或原值为0或空时），编码根据日期生成
			pmyTable.keyvalue=xid;
			//将表中可编辑字段赋值到pmyForm.editablefieldset中
			pmyForm.editablefieldset=myGetTableEditableFields(sysdatabasestring,pmyGrid1.tablename);
			//后台验证主码值是否重复
			var kflag=(pmyForm.editablefieldset+';').indexOf(':'+pmyGrid1.keyfield+';');
			if (xaddoredit=='1' && kflag>=0) pmyTable.error+=myPKUniqueCheck(pmyGrid1);
			//前台明细表数据和替换replace & validation
			//数据验证错误判断
			if (pmyTable.error!=''){
				eval(sysError('发现下列错误，记录保存失败！<br>'+pmyTable.error,0,0));
				if (myFormTab.isVisible()){
					myFormTab.setActiveTab(0);
		    		myFocusInTab(myFormTab);
		    	}else myFocusInTab(myForm1);        		
				return;
			}else{ 	//数据库操作语句	
				//将控件值赋值到pmyForm.editablefieldtext中
	   	   		eval(myGetFormValues(pmyForm));
				if (xaddoredit=='1'){  //新增记录
					//根据表单值和可编辑字段，生成insert语句新增记录
		       		updatesql+=myGenInsertSql(pmyGrid1.tablename,pmyForm.editablefieldset,pmyForm.fieldtext);
		        }else{  //修改记录
					//根据表单值和可编辑字段，生成update语句
					updatesql+=myGenUpdateSql(pmyGrid1.tablename,pmyForm.editablefieldset,pmyForm.fieldtext,pmyGrid1.keyfield,xid);
	        	}
	        	if (pmyGrid1.valuefields!=''){
		       		updatesql+="\n update "+pmyGrid1.tablename+" set "+pmyGrid1.valuefields+"='"+xvalues+"'\n";
		       		updatesql+=" where "+pmyGrid1.keyfield+"='"+xid+"'\n";
	        	}
				var records=myGrid1.getSelectionModel().getSelection();	        	
	        	if (pmyTable.tablename!=''){
	        		var sql1='';
	        		var sql2='';
	        		if (pmyTable.valuefields!=undefined && pmyTable.valuefields!=''){
	        			var tmp=pmyTable.valuefields.split(';');
	        			for (var k=0;k<tmp.length;k++){
		        			if (records[0].get(tmp[i])!=undefined){
		        				sql1+=tmp[k];
		        				sql2+="'"+records[0].get(tmp[i])+"'";
		        			}	
	        			}
	        		}
		       		updatesql+=" delete "+pmyTable.tablename+" where "+pmyGrid1.keyfield+"='"+xid+"'\n";
		       		var tmp=xvalues.split(sys.tab);
		       		for (var k=0;k<tmp.length;k++){
		       			if (sql1!='') updatesql+="insert into "+pmyTable.tablename+"("+pmyGrid1.keyfield+","+pmyTree1.keyfield+","+sql1+") values('"+xid+"','"+tmp[k]+"'"+sql2+")\n";
		       			else updatesql+="insert into "+pmyTable.tablename+"("+pmyGrid1.keyfield+","+pmyTree1.keyfield+") values('"+xid+"','"+tmp[k]+"')\n";
		       		}
	        	} 
	        }  //error!=''
			//保存记录后求记录的行号，用于grid页面定位行号
			var querysql="select rowno=count(*)+1 from ("+pmyGrid1.paramsql+") as p where "+pmyGrid1.keyfield+"<'"+xid+"'\n";
        	//console.log(pmyForm.fieldtext);
       		//console.log(updatesql);
       		//console.log(querysql);
			Ext.Ajax.request({   //ssssssa
				url: 'system//fn_executeSql.jsp',
				method: 'post',async:false,
     			params:{ database:sysdatabasestring, updateSql:updatesql,selectSql:querysql },									
				waitTitle : '系统提示',
				waitMsg: '正在保存数据,请稍候...',
				callback:function(options,success,response){
					var rowno=Ext.decode(response.responseText).rowno;
					pmyTable.error=Ext.decode(response.responseText).errors;
					if (pmyTable.error==''){
						//记录保存成功，重新加载myGrid1
						if (myGrid1.store.pageSize<=0){
							var n=1;
							pmyGrid1.index=rowno;
						}else{
							var n=Math.floor((rowno-1)/myGrid1.store.pageSize)+1;
							pmyGrid1.index=rowno-(n-1)*myGrid1.store.pageSize-1;
						}
						pmyGrid1.pageno=n;
						fnLoadmyGrid1(n,'');  
						//聚焦树节点或重载树
	       				Ext.getCmp('addoredit').setValue('2');
	       				mySetCmpDisabled('cmdsave;popsave;btnsave',true);
						Ext.getCmp('filtertext').setValue('');
	       				if (pmyForm.modal=='window') myEditWin.hide();
						if (myFormTab.isVisible()){
							myFormTab.setActiveTab(0);
				    		myFocusInTab(myFormTab);
				    	}else myFocusInTab(myForm1);        		
				    	if (pmyTable.msg!=''){
	       					eval(sysInfo('记录已经保存成功！<br>'+pmyTable.msg,0,0));
				    	}else{     		
	       					eval(sysWait('记录已经保存成功！'+pmyTable.msg,160,100,600));
	       				}
	       			}else{
						eval(sysError('发现下列错误，'+pmyTable.tabletitle+'保存失败！<br>'+pmyTable.error,0,0));
	       			}	           					
       			} //calback		
			});	
		}
		
		function fnDeleteRecord(){ //删除 dddd
			var records=myGrid1.getSelectionModel().getSelection();
			if (!records[0]){
				Ext.Msg.alert('系统提示','请选择要删除的'+pmyGrid1.keyspec+'!');
				return;
			}else{	
				var xid=records[0].get(pmyGrid1.keyfield);
				var sql='delete '+pmyGrid1.tablename+' where '+pmyGrid1.keyfield+"='"+xid+"'\n";
				if (pmyTable.tablename!=undefined && pmyTable.tablename!='' && pmyTable.tablename!=pmyGrid1.tablename){
					sql+=' delete '+pmyTable.tablename+' where '+pmyGrid1.keyfield+"='"+xid+"'";
				}
				Ext.MessageBox.show({   
		            title: '系统提示',   
		            msg: mySpace(2)+'删除'+pmyGrid1.keyspec+'<font color=blue><b>【'+xid+'】</b></font>这条记录。'+mySpace(10)+'<br><br>'+mySpace(2)+'是否确认？<br><br>' , 
 		            icon: Ext.MessageBox.QUESTION,  //icon: Ext.MessageBox.INFO  
		            buttons: Ext.Msg.YESNO,
		            fn: function(btn){
		            	if(btn=='yes'){
				            Ext.Ajax.request({
					        	url:'system/fn_executeSql.jsp',
								params:{ database:sysdatabasestring, updateSql:sql,selectSql:'' },									
					        	method: 'POST',async:false,
					        	callback:function(options,success,response){
					        		//删除记录后的定位处理
									pmyGrid1.locatevalue='';
					        		var index=myGrid1.store.indexOf(records[0]);
									var pageno=myGrid1.store.currentPage;
					        		if ((pageno-1)*myGrid1.store.pageSize+index==myGrid1.store.getTotalCount()-1){
					        			if (index>0){
					        				pmyGrid1.index=index-1;
					        				myGrid1.store.loadPage(pageno);
					        			}else if (pageno>1){
					        				pmyGrid1.index=0;
					        				fnLoadmyGrid1(pageno-1,'');					        				
					        			}else{  //全部删除的情况
						        			pmyGrid1.index=-1;
											myGrid1.store.loadPage(1);
					        			}
					        		}else{	
										pmyGrid1.index=index;
										myGrid1.store.loadPage(pageno);
									}
					        	}
				           });	            	
		            	}
		            }					
				});
			}
		}
		
		function fnRefreshRecord(){  //rrrrre刷新
			Ext.getCmp('filtertext').setValue('');
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
			pmyGrid1.index=0;
			fnLoadmyTree(myTree1);
			fnLoadmyGrid1(1,'');
		}
		
		//快速过滤函数
		function fnQuickFilter(){
			var xfilter=Ext.getCmp('filtertext').getValue();
			var xfiltersql=myGetFilterSql(myFilterCheckMenu,xfilter);  //获取过滤条件
			//console.log(xfiltersql);
 			pmyGrid1.locatevalue='';
			pmyTree1.reloadflag=1;
			fnLoadmyGrid1(1,xfiltersql);			
		}

		function fnKeyEvent(field,e) {
			myKeyEvent(field,e,myFormTab);  //笤俑functions中的函数
		}		
		
		function fnLoadRecord(){  //lll
			var records=myGrid1.getSelectionModel().getSelection();
			for (var i=1;i<=pmyForm.pagecount;i++) {
				eval(mySetFormReadOnly('myForm'+i,'true'));
			}
			if(records[0]){	
				Ext.getCmp('addoredit').setValue('2');
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
			//mySetCmpDisabled('cmdsave;popsave;btnsave',true);
			mySetCmpDisabled('cmdadd;popadd',false);
			mySetCmpDisabled(pmyForm.fileloadbutton,true);
			mySetCmpDisabled('cmdupdate;popupdate;cmddelete;popdelete',false);
			//mySetCmpDisabled('filepathcmdup;filepathicon',true);
			//Ext.getCmp('filepathsource').setValue(Ext.getCmp('filename').getValue());
		}	
		
		function fnLoadmyTree(myTree){   //llllllo
			var pmyTree=eval('p'+myTree.id);
			if (pmyTree.groupid=='*'){
				var root=myTree.setRootNode({
					text: pmyTree.roottitle,
					iconCls: 'folderopenIcon',
	            	cid: '',
		            level: 0,
	    	        expanded: false,                
	        	    leaf: true                
				}); //修改根节点的值
				root.removeAll();	
				pmyTree.sql='';
				myTree.getSelectionModel().select(root);
			}else{
				var root=myTree.setRootNode({
					text: pmyTree.grouptext,
					iconCls:'folderopenIcon',
	            	cid:'',
		            level:0,
	    	        expanded: false,                
	        	    leaf:false                
				}); //修改根节点的值
				//if (pmyTree.groupfield[1]!=''){
				var tmp=pmyTree.groupid.split('+');
				pmyTree.sql='';
				pmyTree.groupfield=[];
				for (var j=1;j<=tmp.length;j++){
					pmyTree.groupfield[j]=tmp[j-1];
				}
				pmyTree.sortfield="cid";
				pmyTree.rootcode='';
				myTree.store.load();
			}		
		}
		
		function fnLoadmyGrid1(pageno,wheresql){ //lllllo重新加载grid数据
			if (wheresql!='') var sql="select * from ("+pmyGrid1.sql+") as p where "+wheresql;
			else var sql=pmyGrid1.sql;
			pmyGrid1.paramsql=sql;	
			//console.log(sql);
			var xpagesize=myGrid1.store.pageSize;
			var newparams={ database:sysdatabasestring, sqlString:sql,keyField:pmyTable.keyfield,sortField:pmyTable.sortfield,limit:xpagesize,totalFields:pmyGrid1.totalfields };
			Ext.apply(myGrid1.store.proxy.extraParams,newparams);
			if (pageno>0) myGrid1.store.loadPage(pageno); 	        
			else myGrid1.store.loadPage(1);
		}

		function fnMoveRecord(id){
			if (id=='xrowfirst') myMoveRecord('rowfirst',pmyGrid1);
			else if (id=='xrowlast') myMoveRecord('rowlast',pmyGrid1);
			else if (id=='xrownext') myMoveRecord('rownext',pmyGrid1);
			else if (id=='xrowprev') myMoveRecord('rowprev',pmyGrid1);
		}
		
		
		function fnAllNodes(id){
			if (id=='popyall') var state=true;
			else var state=false;
			//var nodecount=myTree1.store.tree.flatten().length;
			myTree1.getRootNode().cascadeBy(function(){
				this.set( 'checked', state );
			});
		}
		
		function fnGetTreeCheckState(){  //ggggget
			var xvalues='';
			//var nodecount=myTree1.store.tree.flatten().length;
			myTree1.getRootNode().cascadeBy(function(){
				if (this.get('leaf') && this.get('checked') ){
					if (xvalues!='') xvalues+=sys.tab;
					xvalues+=this.get(pmyTree1.keyfield);
				}
			});
			return(xvalues);
		}
		
		function fnSetTreeCheckState(myTree1,xvalues){  //ssssset
			var pnodes=[];
			for (var i=0;i<=30;i++) pnodes[i]=0; 
			var nodecount=myTree1.store.tree.flatten().length;
			for (var i=nodecount-1;i>1;i--){
				var recordx=myTree1.getSelectionModel().select(i);
				var records=myTree1.getSelectionModel().getSelection();
				var record=records[0];
				var level=1.0*record.get('level');  //转换类型
				var leaf=record.get('leaf');
				if (!leaf){
					if (pnodes[level+1]>0) record.set('checked',true);
					else record.set('checked',false);
					pnodes[level+1]=0;
				}else{
					if (xvalues.indexOf(sys.tab+record.get(pmyTree1.keyfield)+sys.tab)>=0) record.set('checked',true);
					else record.set('checked',false);
				}
				if (record.get('checked')) pnodes[level]=pnodes[level]+1;
				//console.log(record.get(pmyTree1.keyfield)+'--'+level+'---'+pnodes[level]+'---'+record.get('checked'));
			}	
		}
		
		function fnResetNodes(record){   //ccccccchk
			var sql='';
			//var records=myGrid1.getSelectionModel().getSelection();
			if (record){
				if (pmyTable.tablename==pmyGrid1.tablename){
					if (pmyTable.valuefields!='') var valuefields=pmyTable.valuefields
					else if (pmyGrid1.valuefields!='') var valuefields=pmyGrid1.valuefields;
					else var valuefields=pmyTree1.keyfield;
					sql="select "+valuefields+" as xvalues from "+pmyTable.tablename+" where "+pmyGrid1.keyfield+"='"+record.get(pmyGrid1.keyfield)+"'";
				}else{
					if (pmyGrid1.valuefields!='') var valuefields=pmyGrid1.valuefields;
					else var valuefields=pmyTree1.keyfield;
					sql="select "+valuefields+" as xvalues from "+pmyGrid1.tablename+" where "+pmyGrid1.keyfield+"='"+record.get(pmyGrid1.keyfield)+"'";
				}
				//console.log(sql);
				Ext.Ajax.request({   //ssssssa
					url: 'system//fn_executeSql.jsp',
					method: 'post',async:false,
	     			params:{ database:sysdatabasestring, updateSql:'',selectSql:sql },									
					waitTitle : '系统提示',
					waitMsg: '正在保存数据,请稍候...',
					callback:function(options,success,response){
						var xvalues=sys.tab+Ext.decode(response.responseText).xvalues+sys.tab;
						//console.log('v='+xvalues);
						fnSetTreeCheckState(myTree1,xvalues);
					}
				});	
			}	
	    }
	    	
		function fnRefreshNodes(){
			var records=myGrid1.getSelectionModel().getSelection();
			if (records[0])	fnResetNodes(records[0]);
		}
				

		//初始化ccccc
		if (pmyTable.document.datefield!='' && Ext.getCmp(pmyTable.document.datefield).getXType()=='datefield' && Ext.getCmp(pmyTable.document.datefield).xreadonly=='false') {
			Ext.getCmp(pmyTable.document.datefield).setMinValue(sys.date1);
			Ext.getCmp(pmyTable.document.datefield).setMaxValue(sys.date2);
		}
		var sys_checkedimage={
			xtype:'image',id:'sys_checkedimage',name:'sys_checkedimage',
			width:46,height:47,y:40,x:270,
			src:'../'+sys.project+'/system/images/chnchecked.png'
		};
		myForm1.add(sys_checkedimage);
		Ext.getCmp('sys_checkedimage').setVisible(false);
		var root=myTree1.setRootNode({
			text: pmyTree1.title,
			iconCls:'folderopenIcon',
			cid:'',
			level:0,
			expanded: false,                
			leaf:false                
		}); 
		root.expand();	
		myTree1.expandAll();		
		//myTree1.store.load();
		fnLoadmyGrid1(1,'');
		pmyTree1.reloadflag=0;
		for (var i=1;i<=pmyForm.pagecount;i++) {
			eval(mySetFormReadOnly('myForm'+i,'true'));
		}
		
	//****************************end of extjs**************************//
			
	}); 
  
  </script>
  </body>
</html>


