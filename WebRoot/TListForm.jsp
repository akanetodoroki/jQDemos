<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="com.DBConn" %>
<%@ page import="com.UserBean" %>
<%@ page import="com.StringUtil"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>TListForm模板</title>
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
		 .x-grid3-row td, .x-grid3-summary-row td{ 
        	padding-right: 0px; 
    	} 
    	/*去掉行间空白*/ 
    		.x-grid3-row { 
        	border-top-width: 0px; 
        	border-bottom-width: 0px; 
    	} 
		.myGridUdfCSS table td.x-grid-cell
		{
			height: 23px;
			vertical-align: middle;  //垂直居中
			border-left: 10px  !important; //dotted #A3BAE9;
			border-top: 0px  !important; //dotted #A3BAE9;
		    border-bottom: 0px solid #D2D2D2 !important; //dotted #A3BAE9;
		 }
		 .myGridUdfCSS span.x-column-header-text {width: 100%;vertical-align: middle;}
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
		pmyService.sysdatabasestring=sysdatabasestring; //传递到fn_function.js
		pmyService.sysdate=sysdate;
		pmyTable.sysdatabasestring=sysdatabasestring; //传递到fn_function.js
		pmyGrid1.sysdatabasestring=sysdatabasestring; //传递到fn_function.js
		pmyTree1.sysdatabasestring=sysdatabasestring; //传递到fn_function.js
		pmyForm.sysdatabasestring=sysdatabasestring; //传递到fn_function.js
  		if (p.table!=undefined) pmyTable=myGetTableAttrs(p.table[0],pmyTable);  //获取table值
		if (p.form!=undefined) pmyForm=myGetFormAttrs(p,pmyForm);
		if (p.list!=undefined) pmyGrid1=myGetGridAttrs(p.list[0],pmyGrid1);  //获取grid值
		if (p.list!=undefined) pmyTree1=myGetTreeAttrs(p.list[0],pmyTree1);
		if (pmyGrid1.tablename=='') pmyGrid1.tablename=pmyTable.tablename;
		if (pmyGrid1.tabletitle=='') pmyGrid1.tabletitle=pmyGrid1.title;
		if (pmyGrid1.keyfield=='') pmyGrid1.keyfield=pmyTable.keyfield;
		if (pmyGrid1.keyspec=='') pmyGrid1.keyspec=pmyTable.keyspec;
		if (pmyGrid1.sortfield=='')	pmyGrid1.sortfield=pmyTable.sortfield;
		if (pmyGrid1.sortfield=='') pmyGrid1.sortfield=pmyGrid1.keyfield;
		if (pmyTable.tablename=='' && pmyGrid1.tablename!='') pmyTable.tablename=pmyGrid1.tablename;
		if (pmyTable.keyfield=='' && pmyGrid1.keyfield!='') pmyTable.keyfield=pmyGrid1.keyfield;
		if (pmyTable.keyspec=='' && pmyGrid1.keyspec!='') pmyTable.keyspec=pmyGrid1.keyspec;
		if (pmyTable.sortfield=='' && pmyGrid1.sortfield!='') pmyTable.sortfield=pmyGrid1.sortfield;
		if (pmyGrid1.filterfields!='' && pmyForm.filterfields=='') pmyForm.filterfields=pmyGrid1.filterfields;
		pmyTree1.tablename=pmyGrid1.tablename;
		pmyTree1.keyfield=pmyGrid1.keyfield;
		pmyTree1.keyspec=pmyGrid1.keyspec;
		pmyTree1.filterfields=pmyGrid1.filterfields;
		if (pmyForm.rowheight!=undefined && pmyForm.rowheight!='') var rowHeight=pmyForm.rowheight;
		else var rowHeight=32;
  		pmyTable.permission=';'+myGetOneAttr(p.service,'permissions')+';';
  		sys.year=myGetDatePart('year',sysdate);
		sys.month=myGetDatePart('month',sysdate);
		sys.day=myGetDatePart('day',sysdate);
		sys.date=sys+'-'+sys.month+'-'+sys.day;
		sys.date0=sys.year+'-01-01';
		sys.date1=sys.year+'-'+sys.month+'-01';
		sys.date2=sys.year+'-'+sys.month+'-'+myDaysInaMonth(sys.year,sys.month);
		//设置对其方式
		pmyTree1.region='west';
		if (pmyTree1.align!=''){
		    if (pmyTree1.align=='left') {
		    	pmyTree1.region='west';
		    }else if (pmyTree1.align=='right'){
		    	pmyTree1.region='east';
			}else if (pmyTree1.align=='top'){
				pmyTree1.region='north';
			}else if (pmyTree1.align=='bottom'){
				pmyTree1.region='south';
			}
		}else if (pmyForm.align!=''){
		    if (pmyForm.align=='left') {
		    	pmyTree1.region='west';
		    }else if (pmyForm.align=='right'){
	    		pmyTree1.region='east';
			}else if (pmyForm.align=='top'){
				pmyTree1.region='south';
			}else if (pmyForm.align=='bottom'){
				pmyTree1.region='north';
			}
		}
		pmyForm.region='center';
		pmyGrid1.region=pmyTree1.region;
	    if (pmyForm.modal=='window'){
	    	pmyGrid1.region='center';
	    	pmyTree1.region='center';
	    	pmyForm.region='center';
	    }
		if (pmyGrid1.pagesize>0 || pmyGrid1.fields!=''){
			pmyTable.active='grid';
			if ((pmyGrid1.fields=='' || pmyGrid1.fields==undefined) && (pmyGrid1.nodefields!='')){
				pmyGrid1.fields=pmyGrid1.nodefields
			}
		}else{
			pmyTable.active='tree';
			if ((pmyTree1.nodefields=='' || pmyTree1.nodefields==undefined) && (pmyTree1.datafields!='')){
				pmyGrid1.nodefields=pmyGrid1.datafields;
				pmyGrid1.fields=pmyGrid1.datafields;
			}
		}
		//grid初始设置
		pmyGrid1.index=-1;  //聚焦的行号
		pmyGrid1.column=-1;
		pmyGrid1.varname='pmyGrid1';
		pmyGrid1.name='myGrid1';
		pmyGrid1.locatekeyvalue='';
		pmyGrid1.style='';
		pmyGrid1.showline=0;
		pmyGrid1.pagingbar='simple';
		pmyGrid1.paramsql=pmyGrid1.sql;
		pmyTree1.height=0;
		if (pmyTree1.width==0) pmyTree1.width=200;
		pmyTree1.roottitle='全部'+pmyTable.tabletitle;
		pmyTree1.selectedcode='';
		pmyTree1.rootcode='';
		pmyTree1.searchtext='';
		pmyTree1.filterfield='';
		pmyTree1.events='storeload;treeload';
		pmyTree1.parentvalue='';
		pmyTree1.keyfield=pmyTable.keyfield;
		pmyTree1.sortfield='';
		pmyTree1.reloadflag=1;
		pmyTree1.singleexpand='true';
		pmyTree1.pageno=0;		
		pmyTree1.index=-1;		
		pmyTree1.fields='';  //否则按表格显示
		pmyTree1.name='myTree1';		
		pmyTree1.varname='pmyTree1';
		//生成编译得到的控件和事件		
		eval(pmyForm.tabstr); //定义表单myForm*
		eval(pmyForm.groupboxstr); //定义表单中的groupbox控件
		eval(pmyForm.fieldstr); //定义表单ffffff中的其他控件textfield,combo,datefield
		//存储grid中combo之类的sql语句，bbar等
		eval(pmyForm.gridcmpstr);
		
		if (pmyGrid1.sql=='') pmyGrid1.sql=pmyForm.sql;
		if (pmyTree1.sql=='') pmyTree1.sql=pmyForm.sql;
		pmyGrid1=myGetGridNodeTextFields(pmyGrid1);
		pmyTree1=myGetTreeNodeTextFields(pmyTree1);
		//生成sql语句
		if (pmyGrid1.sql==''){
			//pmyGrid1=myGetGridNodeTextFields(pmyGrid1);
			pmyGrid1.sql="select * from "+pmyGrid1.tablename;
    	}
		if (pmyTree1.sql==''){
			pmyTree1.sql="select "+pmyTree1.keyfield+" as 'cid',"+pmyTree1.nodetextfields+" as 'nodetext',*,1 as level,0 as isparentflag,'' as parentnodeid from "+pmyTree1.tablename;
		}else{
			pmyTree1.sql="select "+pmyTree1.keyfield+" as 'cid',"+pmyTree1.nodetextfields+" as 'nodetext',*,1 as level,0 as isparentflag,'' as parentnodeid from ("+pmyTree1.sql+") as p";
		}
		
		/**************************定义工具栏tbar开始**********************************/
		//定义菜单选项
		var mtitle='';
		if (pmyForm.filterfields!=undefined){
			var pfid={};
			pfid.fields=pmyForm.filterfields;
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
		tbar.add({id:'reviewbar1', xtype:'tbseparator'});
		tbar.add({id:'cmdreview', iconCls: 'checkIcon',text: '审核',handler: fnReviewRecord,tooltip: '审核当前记录',xaction:'review'});
		tbar.add({id:'editbar1', xtype:'tbseparator'});
		tbar.add({id:'cmdsave', iconCls: 'saveIcon',text: '保存',handler: fnSaveRecord,tooltip: '保存正在修改或新增的记录',xaction:'save'});
		tbar.add({id:'savebar1', xtype:'tbseparator'});
		tbar.add({id:'cmdprint', iconCls: 'printerIcon',text: '打印',handler: fnPrintRecord,tooltip: '打印'+pmyTable.tabletitle+'列表',xaction:'print'});
		tbar.add({id:'printbar1', xtype:'tbseparator'});
	    tbar.add({id:'cmdrefresh', iconCls: 'refreshIcon',text: '刷新', id:'refresh',name:'refresh',handler: fnRefreshRecord,tooltip: '刷新全部'});
		tbar.add({id:'filterbar1', xtype:'tbseparator'});
		tbar.add({id:'filterbar2', xtype:'tbspacer',width:2});
	    tbar.add({id:'filtertext',xtype:'textfield',emptyText: '快速过滤',enableKeyEvents:true,width:170});
		tbar.add({id:'columnchoose',text:'过滤列选择',menu:myFilterCheckMenu });
		tbar.add({id:'filterbar3', xtype:'tbseparator'});
	    tbar.add({iconCls: 'searchIcon',text: '过滤', id:'cmdfilter',name:'cmdfilter',handler: fnQuickFilter,tooltip: '开始条件过滤'},'-');
	    tbar.add({id:'rowfirst',iconCls: 'rowfirstIcon',text:'',handler: function(e) { fnMoveRecord(e.id); },tooltip: '第一行'});
	    tbar.add({id:'rowprev', iconCls: 'rowprevIcon', text:'',handler: function(e) { fnMoveRecord(e.id); },tooltip: '上一行'});
	    tbar.add({id:'rownext', iconCls: 'rownextIcon', text:'',handler: function(e) { fnMoveRecord(e.id); },tooltip: '下一行'});
	    tbar.add({id:'rowlast', iconCls: 'rowlastIcon', text:'',handler: function(e) { fnMoveRecord(e.id); },tooltip: '最后一行'},'-');
		/**************************定义工具栏tbar结束**********************************/	
		/**************************定义右击菜单开始******************************/
		var myContextMenu1=Ext.create('Ext.menu.Menu',{//菜单
	    items:[
			{text:'新增',id:'popadd',iconCls:'addIcon',handler:fnAddRecord,xaction:'add'},
			{text:'修改',id:'popupdate',iconCls:'editIcon',handler: fnEditRecord,xaction:'update'},
	    	{text:'删除',id:'popdelete',iconCls:'deleteIcon',handler:fnDeleteRecord,xaction:'delete'},
	    	{xtype:'menuseparator',id:'reviewbar2'},
			{text:'审核',id:'popreview',iconCls:'checkIcon',handler: fnReviewRecord,tooltip: '审核当前记录',xaction:'review'},
	    	{xtype:'menuseparator',id:'savebar2'},
	    	{text:'保存',id:'popsave',iconCls:'saveIcon',handler:fnSaveRecord,xaction:'save'},
	    	{xtype:'menuseparator',id:'refreshbar2'},
	        {text:'刷新',id:'poprefresh',iconCls:'refreshIcon',handler:fnRefreshRecord}
	    ]});	
		//可编辑grid中的右键菜单
		/**************************定义tree开始************************************/
		var wintoolbar=Ext.create('Ext.toolbar.Toolbar',{
			region:'north',split:false,items:[
				{id:'xrowfirst',iconCls: 'rowfirstIcon',text:'',width:22, handler: function(e) { fnMoveRecordx(e.id); },tooltip: '第一行'},
				{id:'xrowprev',iconCls: 'rowprevIcon',text:'',width:24, handler: function(e) { fnMoveRecordx(e.id); },tooltip: '上一行'},
				{id:'xrownext',iconCls: 'rownextIcon',text:'',width:24, handler: function(e) { fnMoveRecordx(e.id); },tooltip: '下一行'},
				{id:'xrowlast',iconCls: 'rowlastIcon',text:'',width:24, handler: function(e) { fnMoveRecordx(e.id); },tooltip: '最后行'}
			]
		});
	    //console.log(pmyGrid1.sql);
		eval(myDefineGrid(pmyGrid1));//生成grid
	    eval(myDefineTree(pmyTree1));
		var root=myTree1.setRootNode({
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
		mySetCmpDisabled('cmdadd;popadd;cmdupdate;popupdate;cmddelete;popdelete;cmdsave;popsave;btnsave;cmdprint;popprint',false);
		mySetCmpDisabled(pmyForm.fileloadbutton,false);
		//计算按钮高度
		var titleheight=16*Math.max(pmyGrid1.title.length,pmyForm.title.length)+20;
		titleheight=Math.max(90,titleheight);
		var s1='';
		for (var j=0;j<pmyGrid1.title.length;j++){
			if (s1!='') s1+='<br>';
			s1+=pmyGrid1.title.substr(j,1);
		}
		var s2='';
		for (var j=0;j<pmyForm.title.length;j++){
			if (s2!='') s2+='<br>';
			s2+=pmyForm.title.substr(j,1);
		}
		/****************************页面布局******************************/
		//定义页面布局
		eval(myDefineTab('myFormTab','',pmyForm.region,'['+pmyForm.panels+']',pmyForm.height,pmyForm.width,'false','myContextMenu1'));
	 	var myEditWin=Ext.create('Ext.window.Window', {
			height: pmyForm.height+64, //高度
			width: pmyForm.width+6+8, //宽度
			closeAction: 'hide',//关闭按钮 效果是隐藏当前窗体
			modal:true,
			title:pmyTable.tabletitle+'管理',
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
		if (pmyForm.modal=='window'){
			if (pmyTable.active=='grid'){ 
				var myView=Ext.create('Ext.Viewport', {
			        layout: { type: 'border', padding: 5 },
			        defaults: { split: true },
			        items: [tbar,myGrid1]
			    });
		    }else{
				var myView=Ext.create('Ext.Viewport', {
			        layout: { type: 'border', padding: 5 },
			        defaults: { split: true },
			        items: [tbar,myTree1]
			    });
		    }
			if (pmyForm.pagecount>1) myEditWin.add(myFormTab);
			else myEditWin.add(myForm1);
		}else{
			if (pmyTable.active=='grid'){ 
				var myView=Ext.create('Ext.Viewport', {
			        layout: { type: 'border', padding: 5 },
			        defaults: { split: true },
			        items: [tbar,myGrid1,myFormTab]
			    });
		    }else{
				var myView=Ext.create('Ext.Viewport', {
			        layout: { type: 'border', padding: 5 },
			        defaults: { split: true },
			        items: [tbar,myTree1,myFormTab]
			    });
		    }
	    }			
		//只有一个表单时去掉window中的formpanel标题
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
		if (pmyTable.permission.indexOf(';review;')<0 || pmyTable.document.reviewflag==''){
			mySetCmpVisible('cmdreview;popreview;reviewbar1;reviewbar2',false);
		}else pmyTable.editflag[4]=1;

		if (pmyTable.permission.indexOf(';print;')<0){
			mySetCmpVisible('cmdprint;popprint;printbar1;printbar2',false);
		}
		if (pmyTable.permission.indexOf(';filter;')<0){
			mySetCmpVisible('cmdfilter;filterbar1;filterbar2;filterbar3;filtertext;columnchoose',false);
		}
		if (pmyTable.editflag[1]+pmyTable.editflag[2]+pmyTable.editflag[4]==0){  //查询状态
			mySetCmpVisible('cmdbar;cmdsave;popsave;savebar1;savebar2;btnsave',false);
			if (Ext.getCmp('btnclose')!=null) Ext.getCmp('btnclose').setText('关闭');		
		}else if (pmyTable.editflag[1]+pmyTable.editflag[2]+pmyTable.editflag[3]==0){  //查询状态	
			mySetCmpVisible('cmdbar',false);
		}
		//设置单证区间，编辑状态为当月，查询为多年
		if (pmyTable.document.datefield!=''){	
			if (pmyTable.editflag[1]+pmyTable.editflag[2]+pmyTable.editflag[3]+pmyTable.editflag[4]==0)  //查询状态
	  			pmyTable.document.daterange="("+pmyTable.document.datefield+" between '"+sys.date0+"' and '"+sys.date2+"')";
			else  //编辑或审核状态				
  				pmyTable.document.daterange="("+pmyTable.document.datefield+" between '"+sys.date1+"' and '"+sys.date2+"')";
	  		var x1=(pmyGrid1.sql).lastIndexOf(' from ');
	  		var x2=(pmyGrid1.sql).lastIndexOf(')');
	  		var x3=(pmyGrid1.sql).lastIndexOf(' where ');
	  		if (x3>0 && x3>x2) pmyGrid1.sql+=" and "+pmyTable.document.daterange;
	  		else pmyGrid1.sql+=" where "+pmyTable.document.daterange; 
			pmyGrid1.paramsql=pmyGrid1.sql;
  		}
		//myTree1事件
		myTree1.on('beforeload',function(store) {  //bbbbbbe
			var sql="select "+pmyTable.keyfield+" as 'cid',"+pmyTree1.nodetextfields+" as nodetext,0 as isparentflag,'' as parentnodeid,1 as level,* from ("+pmyForm.sql+") as p";
			//console.log(sql);
			var newparams={ database:sysdatabasestring, sqlString:sql,keyField:'cid' };
			Ext.apply(store.proxy.extraParams,newparams);
			store.proxy.url='system//fn_getChildNodes.jsp';					
		});				
		myTree1.on('load',function(){
	    	var root=myTree1.getRootNode();
	    	root.set('text',"全部"+pmyTable.tabletitle+'（'+root.childNodes.length+'组）');
	    	root.expand();
			var records=this.getSelectionModel().getSelection();
			if (records[0] && records[0]!=root && !records[0].get('leaf')){
			   	records[0].set('text',records[0].get('text')+'（'+records[0].childNodes.length+'组）');
			}
			if (pmyTree1.selectedcode=='' && root.childNodes.length>0) myTree1.getSelectionModel().select(1);
		});
		myTree1.on('select',function(model, record, index) {//监听树选中时间
			pmyTree1.pageno=1;
			mySetCmpDisabled('rowfirst;rownext;rowprev;rowlast',false);
			mySetCmpDisabled('xrowfirst;xrownext;xrowprev;xrowlast',false);
			if (index==1) mySetCmpDisabled('rowfirst;rowprev;xrowfirst;xrowprev',true);
			if (index==myTree1.getRootNode().childNodes.length) mySetCmpDisabled('rowlast;rownext;xrowlast;xrownext',true);
           	fnLoadRecord(record);
		});
		
		myTree1.on('itemdblclick',function(tree,record){
			if (pmyForm.modal=='window' && record.get('leaf')){
				myEditWin.setTitle(pmyTable.tabletitle+'管理');
				myEditWin.show();
			}
		});
		
		myTree1.on('containercontextmenu',function(tree, e){  //定义右键   		
   			e.preventDefault();
   			myContextMenu1.showAt(e.getXY());
   		});
   		myTree1.on('itemcontextmenu',function(tree, record, item, index, e){  //定义右键   		
   			e.preventDefault();
   			myContextMenu1.showAt(e.getXY());
   		});
 		//定义myGrid1事件
		myGrid1.store.on('load',function(store){
			myGrid1.setTitle(pmyGrid1.title+'（'+store.getTotalCount()+'组）');
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
			if (pmyForm.modal=='window'){
           		myEditWin.setTitle(pmyTable.tabletitle+'管理');
           		myEditWin.show();
           	}
		}); 

		myGrid1.on('select',function(model,record,index) {  //schange
			if (record){
				//调用函数,控制记录移动指针的disabled状态
				mySetMoveRecordBtn(myGrid1,record);
				mySetCmpDisabled('xrowfirst;xrownext;xrowprev;xrowlast',false);
				if (record.get('sysrowno')==1) mySetCmpDisabled('xrowfirst;xrowprev',true);
				if (record.get('sysrowno')==myGrid1.store.getTotalCount()) mySetCmpDisabled('xrowlast;xrownext',true);
           		fnLoadRecord(record);
           	}
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
       		Ext.getCmp(pmyTable.keyfield).setReadOnly(false);
			mySetCmpDisabled('cmdsave;popsave;btnsave;',false);	
			mySetCmpDisabled('cmdupdate;popupdate;cmddelete;popdelete;cmdreview;popreview',true);
			mySetCmpDisabled(pmyForm.fileloadbutton,true);
			Ext.getCmp('sys_checkedimage').setVisible(false);  //
			if (pmyTable.document.datefield!=''){
				Ext.getCmp(pmyTable.document.datefield).setValue(sysdate);
			}
			eval(mySetsysVarsReadOnly(true));
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
			myFormTab.setActiveTab(0);
	    	myFocusInTab(myFormTab);  //聚焦第一个非只读控件       		
		}
		
		function fnEditRecord(){   //eeeeeeeee
			Ext.getCmp('addoredit').setValue('2');
			mySetCmpDisabled('cmdsave;popsave;btnsave',false);
       		for (var i=1;i<=pmyForm.pagecount;i++) {
       			eval(mySetFormReadOnly('myForm'+i,'false'));
       		}	
       		Ext.getCmp(pmyTable.keyfield).setReadOnly(true);
			mySetCmpDisabled('cmdupdate;popupdate;cmddelete;popdelete;cmdsave;popsave;btnsave',false);
			mySetCmpDisabled('cmdreview;popreview',true);
			//mySetCmpDisabled('filepathcmdup;filepathicon',false);
			mySetCmpDisabled(pmyForm.fileloadbutton,false);
	    	//myFormTab.setActiveTab(0);
			if (pmyForm.modal=='window'){
				myEditWin.setTitle('修改'+pmyTable.tabletitle);
				myEditWin.show();
			}
	    	myFocusInTab(myFormTab);  //聚焦第一个非只读控件       		
		}
		
		function fnReviewRecord(){  //rrrrr审核
			Ext.getCmp('addoredit').setValue('3');
			var records=myGrid1.getSelectionModel().getSelection();
			if (records[0].get(pmyTable.document.reviewflag)==''){
				records[0].set(pmyTable.document.reviewflag,sysusername);
				if (Ext.getCmp(pmyTable.document.reviewflag)!=null){
					Ext.getCmp(pmyTable.document.reviewflag).setValue(sysusername);
				}
				var flag=true;
			}else{
				records[0].set(pmyTable.document.reviewflag,'');
				if (Ext.getCmp(pmyTable.document.reviewflag)!=null){
					Ext.getCmp(pmyTable.document.reviewflag).setValue('');
				}
				var flag=false;
			}
			Ext.getCmp('sys_checkedimage').setVisible(flag);  //
			mySetCmpDisabled('cmdupdate;popupdate;cmddelete;popdelete',flag);
			mySetCmpDisabled('cmdsave;popsave;btnsave',false);  //可以保存
			if (pmyForm.modal=='window'){
				myEditWin.setTitle('审核'+pmyTable.tabletitle);
				myEditWin.show();
			}			
		}
		
		function uploadfile(){ //上传附件
			var records=myGrid1.getSelectionModel().getSelection();//获取gird所有选中的records
			if(records[0]){	//获取第一个record对象
			}					
		}
		//保存记录
		function fnSaveRecord(){   //ssssssave
			if (pmyTable.active=='grid'){
				var records=myGrid1.getSelectionModel().getSelection();
			}else{
				var records=myTree1.getSelectionModel().getSelection();
			}
			//var fieldset=myTree1.store.model.getFields();
			var xid=Ext.getCmp(pmyTable.keyfield).getValue();
			var xaddoredit=Ext.getCmp('addoredit').getValue();
			var nodetext='';
			if (Ext.getCmp(pmyTree1.keyfield)!=null){
				xtype=Ext.getCmp(pmyTree1.keyfield).getXType().toLowerCase();
				nodetext=Ext.getCmp(pmyTree1.keyfield).getValue();
				if (xtype=='datefield'){
					nodetext=Ext.util.Format.date(nodetext,sysfulldateformat);
					//月日补足0，转换成2013-01-09格式convert(,,,120)
					if (nodetext=='' || nodetext=='1900-01-01') nodetext='null';
				}
			}
			//Ext.getCmp('filename').setValue(Ext.getCmp('filepathsource').getValue());
			//数据保存前系统变量赋值,返回字符串命令
			eval(mySetSysVars());  
			//前台主表验证数据和替换replace & validation
			pmyTable.error='';  //出错信息
			eval(myFormReplaceValidation(pmyTable,p.replace,p.validation));
			pmyTable.msg='';  //提示信息
       		var updatesql='';
       		var querysql='';
			var sqlx='';
			if (xaddoredit=='3'){ //保存审核结果
				updatesql="update "+pmyTable.tablename+" set "+pmyTable.document.reviewflag+"='"+Ext.getCmp(pmyTable.document.reviewflag).getValue()+"' where "+pmyTable.keyfield+"='"+xid+"' ";
			}else{	
				//自动编码列重新计算（当新增记录或原值为0或空时），编码根据日期生成
		       	if (pmyTable.document.datefield!='' && pmyForm.sysnumberdim!=undefined && pmyForm.sysnumberdim.length>0){
					var xsysnumberdim=[];  //记录旧值
					for (var j=0;j<pmyForm.sysnumberdim.length;j++){
	    	   			xsysnumberdim[j]=Ext.getCmp(p.xfielddim[pmyForm.sysnumberdim[j]].name).getValue();
						if (xaddoredit=='1' || xsysnumberdim[j]=='0' || xsysnumberdim[j]==''){  
		    	   			Ext.getCmp(p.xfielddim[pmyForm.sysnumberdim[j]].name).setValue(myGensysNumber(Ext.getCmp(pmyTable.document.datefield).getValue(),p.xfielddim[pmyForm.sysnumberdim[j]].format,pmyTable));
	    	   				if (xsysnumberdim[j]!=Ext.getCmp(p.xfielddim[pmyForm.sysnumberdim[j]].name).getValue()){
	    	   					var s=(p.xfielddim[pmyForm.sysnumberdim[j]].attrs.label).replace(':','').replace('：','')
		    	   				//自动编码值不一致(记录保存时时予以提醒)
		    	   				pmyTable.msg+="<br>"+s+"的值已改为"+Ext.getCmp(p.xfielddim[pmyForm.sysnumberdim[j]].name).getValue()+".";
	    	   				}
	    	   			}	
		       		}
	    	   	}
				pmyTable.keyvalue=xid;
				//后台验证主码值是否重复
				if (xaddoredit=='1') pmyTable.error+=myPKUniqueCheck(pmyTable);
				//数据验证错误判断
				if (pmyTable.error!=''){
					eval(sysError('发现下列错误，记录保存失败！<br>'+pmyTable.error,0,0));
					myFocusInTab(myFormTab);  //聚焦第一个非只读控件
					return;
				}else{ 	//数据库操作语句	
					//将控件值赋值到pmyForm.editablefieldtext中
	   	   			eval(myGetFormValues(pmyForm));
					//将表中可编辑字段赋值到pmyForm.editablefieldset中
	       			pmyForm.editablefieldset=myGetTableEditableFields(sysdatabasestring,pmyTable.tablename);
					if (xaddoredit=='1'){  //新增记录
						//根据表单值和可编辑字段，生成insert语句新增记录
		        		sqlx="if (select count(*) from "+pmyTable.tablename+" where "+pmyTable.keyfield+"='"+xid+"')=0";
	        			sqlx+=" begin\n"
		        		updatesql=sqlx+" \n"+myGenInsertSql(pmyTable.tablename,pmyForm.editablefieldset,pmyForm.fieldtext);
	        			updatesql+="\n end \n";
		    	    }else{  //修改记录
						//根据表单值和可编辑字段，生成update语句
		        		if (pmyTable.document.reviewflag!=''){
			        		sqlx="if (select count(*) from "+pmyTable.tablename+" where "+pmyTable.keyfield+"='"+xid+"' ";
							sqlx+=" and ("+pmyTable.document.reviewflag+"='' or "+pmyTable.document.reviewflag+" is null))>0 \n";        	
		        			sqlx+=" begin\n"
	        			} 
						updatesql=sqlx+" \n"+myGenUpdateSql(pmyTable.tablename,pmyForm.editablefieldset,pmyForm.fieldtext,pmyTable.keyfield,xid);
		        		if (pmyTable.document.reviewflag!=''){
		        			updatesql+="\n end \n";
		        		}
	        		}
	        	}  //error!=''
	        }  //if addoredit	
			//保存记录后求记录的行号，用于grid页面定位行号
			var querysql="select rowno=count(*)+1 from ("+pmyGrid1.paramsql+") as p where "+pmyTable.keyfield+"<'"+xid+"'";
       		//后台保存未审核凭证是否成功，避免多用户时冲突（一个人已审核，另一个人去保存）
			if (pmyTable.document.reviewflag!=''){
	        	querysql+=sys.sqltab+" select top 1 "+pmyTable.document.reviewflag+" as 'reviewflag' from "+pmyTable.tablename+" where "+pmyTable.keyfield+"='"+xid+"' ";
				querysql+=" and ("+pmyTable.document.reviewflag+"<>'' and "+pmyTable.document.reviewflag+" is not null) \n";
			}else{
	        	querysql+=sys.sqltab+" select reviewflag=''";
			}        	
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
					var reviewflag=Ext.decode(response.responseText).reviewflag;
					pmyTable.error=Ext.decode(response.responseText).errors;
					if (xaddoredit!='3' && reviewflag!=undefined && reviewflag!=''){
						pmyTable.error+="<br>"+pmyTable.tabletitle+"<b>["+xid+"]</b>已由<b>"+reviewflag+"</b>审核，无法修改！";
					}
					if (pmyTable.error==''){
						//记录保存成功，重新加载myGrid1或myTree1
						/*
						for (var k=0;k<fieldset;k++){
							var f=fieldset[k].getId();
							if (Ext.getCmp(f)!=null) records[0].set(f,Ext.getCmp(f).getValue());
						}
						*/
						var xwheresql='';
						if (pmyTable.active=='grid'){
							//grid处理	
							if (myGrid1.store.pageSize<=0){
								var n=1;
								pmyGrid1.index=rowno;
							}else{
								var n=Math.floor((rowno-1)/myGrid1.store.pageSize)+1;
								pmyGrid1.index=rowno-(n-1)*myGrid1.store.pageSize-1;
							}
							pmyGrid1.locatevalue=''; //xid;  //按记录号定位
							pmyGrid1.pageno=n;
							fnLoadmyGrid1(n,xwheresql);  
						}else{ 
							var root=myTree1.getRootNode();
							//var node=root.findChild('cid',nodetext,true);
							//注意日期2013-03-4 2013-3-4的区别
							pmyTree1.selectedcode=nodetext;
							//alert(pmyTree1.selectedcode);
							console.log(pmyTree1.sql);
							pmyTree1.rootcode='';
							//myTree1.getRootNode().expand();
							myTree1.store.load();
						}
						//聚焦树节点或重载树
	       				Ext.getCmp('addoredit').setValue('2');
	       				mySetCmpDisabled('cmdsave;popsave;btnsave',true);
						Ext.getCmp('filtertext').setValue('');
				    	myFormTab.setActiveTab(0);
				    	myFocusInTab(myFormTab);  //聚焦第一个非只读控件
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
		
		function fnDeleteRecord(){ //删除客户 ddddddelete
			var cnode=null;
			if (pmyTable.active=='grid'){
				var records=myGrid1.getSelectionModel().getSelection();
			}else{
				var records=myTree1.getSelectionModel().getSelection();
				if (records[0]){
					//var root=myTree1.getRootNode();
					//var node=root.findChild('cid',records[0].get('cid'));
					cnode=records[0].nextSibling;  //selectNext();
					//this.nextSibling();previousSibling();
					if (cnode==null) cnode=records[0].previousSibling;
					if (cnode!=null) pmyTree1.selectedcode=cnode.get('cid');
				}
			}
			if (!records[0]){
				Ext.Msg.alert('系统提示','请选择要删除的'+pmyTable.keyspec+'!');
				return;
			}else{	
				var xid=records[0].get(pmyTable.keyfield);
				var sql='delete '+pmyGrid1.tablename+' where '+pmyTable.keyfield+"='"+xid+"'";
				Ext.MessageBox.show({   
		            title: '系统提示',   
		            msg: mySpace(2)+'删除'+pmyTable.tabletitle+'<font color=blue><b>【'+xid+'】</b></font>这条记录。'+mySpace(10)+'<br><br>'+mySpace(2)+'是否确认？<br><br>' , 
 		            icon: Ext.MessageBox.QUESTION,  //icon: Ext.MessageBox.INFO  
		            buttons: Ext.Msg.YESNO,
		            fn: function(btn){
		            	if(btn=='yes'){
				            Ext.Ajax.request({
					        	url:'system/fn_executeSql.jsp',
								params:{ database:sysdatabasestring, updateSql:sql,selectSql:'' },									
					        	method: 'POST',async:false,
					        	callback:function(options,success,response){
						        	if (pmyTable.active=='grid'){ 
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
									}else{  //tree
										pmyTree1.rootcode='';
										myTree1.store.load();
									}
								}//callback	
				           });  //ajax	            	
		            	}//if
		            }		//fn			
				});//messagebox
			}
		}
		
		function fnRefreshRecord(){  //rrrrre刷新
			Ext.getCmp('filtertext').setValue('');
			if (pmyTable.active=='grid'){
				pmyGrid1.index=0;
				fnLoadmyGrid1(1,'');
			}else{
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
				pmyTree1.selectedecode='';
				pmyTree1.rootcode='';
				myTree1.store.load();
			}
		}
		
		function fnLoadmyGrid1(pageno,wheresql){ //lllllo重新加载grid数据
			var tabno=1;
			if (wheresql==''){
				var sql=pmyGrid1.sql;					
			}else{
				if (wheresql!='') wheresql="("+wheresql+")";
				var sql="select * from ("+pmyGrid1.sql+") as p where "+wheresql;
			}
			pmyGrid1.paramsql=sql;	
			//console.log(sql);
			var xpagesize=myGrid1.store.pageSize;
			var newparams={ database:sysdatabasestring, sqlString:sql,keyField:pmyTable.keyfield,sortField:pmyTable.sortfield,limit:xpagesize,totalFields:pmyGrid1.totalfields };
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
			pmyTree1.reloadflag=1;
			fnLoadmyGrid1(1,xfiltersql);			
		}

		function fnKeyEvent(field,e) {
			myKeyEvent(field,e,myFormTab);  //调用functions中的函数
		}		
		
		function fnLoadRecord(record){  //lll
			//var records=myGrid1.getSelectionModel().getSelection();
			for (var i=1;i<=pmyForm.pagecount;i++) {
				eval(mySetFormReadOnly('myForm'+i,'true'));
			}
			if(record){	
				Ext.getCmp('addoredit').setValue('2');
				for (var i=1;i<=pmyForm.pagecount;i++) {
					eval('myForm'+i+'.getForm().loadRecord(record);');
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
			mySetCmpDisabled('cmdsave;popsave;btnsave',true);
			mySetCmpDisabled('cmdreview;popreview',false);
			mySetCmpDisabled('cmdadd;popadd',false);
			mySetCmpDisabled(pmyForm.fileloadbutton,true);
			//显示审核图标标记
			if (pmyTable.document.reviewflag!='' && records[0] && records[0].get(pmyTable.document.reviewflag)!='') var flag=true;
			else var flag=false;
			Ext.getCmp('sys_checkedimage').setVisible(flag);  //
			mySetCmpDisabled('cmdupdate;popupdate;cmddelete;popdelete',flag);
			//mySetCmpDisabled('filepathcmdup;filepathicon',true);
			//Ext.getCmp('filepathsource').setValue(Ext.getCmp('filename').getValue());
		}
		
		function fnMoveRecord(id){
			if (pmyTable.active=='tree'){
				var records=myTree1.getSelectionModel().getSelection();
				if (records[0]){
					var root=myTree1.getRootNode();
					var node=null;
					if (id=='rownext'){
						if (records[0]==root) node=myTree1.getSelectionModel().select(1);
						else node=records[0].nextSibling;
					}
					else if (id=='rowprev') node=records[0].previousSibling;
					else if (id=='rowlast') node=myTree1.getSelectionModel().select(root.childNodes.length);
					else if (id=='rowfirst') node=myTree1.getSelectionModel().select(1);
					if (node!=null) myTree1.getSelectionModel().select(node);
				}	
			}else{
				myMoveRecord(id,pmyGrid1);			
			}
		}		

		function fnMoveRecordx(id){
			if (id=='xrowfirst') fnMoveRecord('rowfirst');
			else if (id=='xrowlast') fnMoveRecord('rowlast');
			else if (id=='xrownext') fnMoveRecord('rownext');
			else if (id=='xrowprev') fnMoveRecord('rowprev');
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
		if (pmyTable.active=='grid'){
			fnLoadmyGrid1(1,'');
		}else{
			var root=myTree1.getRootNode();
			root.removeAll();
			var root=myTree1.setRootNode({
				text:'',
        	    iconCls: 'folderopenIcon',
        	    cid:'',
            	level:0,
            	expanded:false,                
            	leaf: false                
			}); //修改根节点的值
			pmyTree1.rootcode='';
			myTree1.store.load();
		}	
		for (var i=1;i<=pmyForm.pagecount;i++) {
			eval(mySetFormReadOnly('myForm'+i,'true'));
		}
		if (pmyForm.modal=='window') myEditWin.show();
		
	//****************************end of extjs**************************//
			
	}); 
  
  </script>
  </body>
</html>


