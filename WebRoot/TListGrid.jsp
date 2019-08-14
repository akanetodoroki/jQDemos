<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="com.DBConn" %>
<%@ page import="com.UserBean" %>
<%@ page import="com.StringUtil"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>TListGrid模板</title>
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
		var p1={};
		p1=myCompileFormFields(p.list[0]);
  		if (p.table!=undefined) pmyTable=myGetTableAttrs(p.table[0],pmyTable);  //获取table值
		if (p1.form[0]!=undefined) pmyForm=myGetFormAttrs(p1,pmyForm);
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
		//if (pmyGrid1.sql=='' && pmyGrid1.tablename!='')	pmyGrid1.sql="select * from "+pmyGrid1.tablename;
		if (pmyGrid1.filterfields!='' && pmyTable.filterfields!='') pmyGrid1.filterfields=pmyTable.filterfields;
		if (pmyTree1.tablename=='') pmyTree1.tablename=pmyTable.tablename;
		if (pmyTree1.tabletitle=='') pmyTree1.tabletitle=pmyTree1.title;
		if (pmyTree1.filterfields!='' && pmyTable.filterfields!='') pmyTree1.filterfields=pmyTable.filterfields;
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
		pmyGrid1.contextmenu='myContextMenu1';
		//存储grid中combo之类的sql语句，bbar等
		eval(pmyForm.gridcmpstr);
		//定义itemgrids,可能不存在
		var pItemGridCount=0;
		if (p.grid!=undefined){
			var pItemGridCount=p.grid.length;
			for (var i=1;i<=pItemGridCount;i++) {
				eval("var pmyItemGrid"+i+"={};");
				eval("pmyItemGrid"+i+".flag=1;"); //生成明细记录的grid，可以有多个
				eval("pmyItemGrid"+i+".sysdatabasestring=sysdatabasestring;");
				eval("pmyItemGrid"+i+".gridpickercolumns=pmyForm.gridpickercolumns;");  //记录picker列，在生成grid时指定类型
				eval("pmyItemGrid"+i+".treepickercolumns=pmyForm.treepickercolumns;");  //记录picker列，在生成grid时指定类型
				var pd=p.grid[i-1];
				eval("pmyItemGrid"+i+"=myGetGridAttrs(pd,pmyItemGrid"+i+");");  //获取grid值
				//设置初值
				eval("pmyItemGrid"+i+".region='center';");
				eval("pmyItemGrid"+i+".index=-1;");
				eval("pmyItemGrid"+i+".column=-1;");
				eval("pmyItemGrid"+i+".reloadflag=1;");
				eval("pmyItemGrid"+i+".contextmenu='myContextMenu2';");
				eval("pmyItemGrid"+i+".keyevent='myGridColumnKeyEvent';");
				eval("pmyItemGrid"+i+".name='myItemGrid"+i+"';");
				eval("pmyItemGrid"+i+".showtitle='false';");
				eval("pmyItemGrid"+i+".varname='pmyItemGrid"+i+"';");
				eval("if (pmyItemGrid"+i+".tablename=='') pmyItemGrid"+i+".tablename=pmyTable.tablename;");
				eval("if (pmyItemGrid"+i+".keyfield=='') pmyItemGrid"+i+".keyfield=pmyTable.keyfield;");
				//下一个itemgrid
			}
		}
		//pmyGrid1.nodetextfields=myGetGridNodeTextFields(pmyGrid1);
		//pmyTree1.nodetextfields=myGetTreeNodeTextFields(pmyTree1);
		pmyGrid1=myGetGridNodeTextFields(pmyGrid1);
		pmyTree1=myGetTreeNodeTextFields(pmyTree1);
		//生成sql语句
		if (pmyGrid1.sql==''){
			pmyGrid1.sql="select distinct "+pmyGrid1.nodetextfields+" from "+pmyGrid1.tablename;
    	}else{
			pmyGrid1.sql="select distinct "+pmyGrid1.nodetextfields+" from ("+pmyGrid1.sql+") as p";
    	}
		if (pmyTree1.sql==''){
			pmyTree1.sql="select distinct "+pmyTree1.keyfield+" as 'cid',"+pmyTree1.nodetextfields+" as 'nodetext',"+pmyTree1.nodetextfieldset.replace(/;/g,",")+",1 as level,0 as isparentflag,'' as parentnodeid from "+pmyTree1.tablename;
		}else{	
			pmyTree1.sql="select distinct "+pmyTree1.keyfield+" as 'cid',"+pmyTree1.nodetextfields+" as 'nodetext',"+pmyTree1.nodetextfieldset.replace(/;/g,",")+",1 as level,0 as isparentflag,'' as parentnodeid from ("+pmyTree1.sql+") as p";
	    }
		//定义树		
		pmyTree1.height=0;
		if (pmyTree1.width==0) pmyTree1.width=200;
		pmyTree1.roottitle='全部'+pmyTable.tabletitle;
		pmyTree1.selectedcode='';
		pmyTree1.rootcode='';
		pmyTree1.searchtext='';
		pmyTree1.filterfield='';
		pmyTree1.events='storeload;treeload';
		pmyTree1.parentvalue='';
		pmyTree1.sortfield='';
		pmyTree1.reloadflag=1;
		pmyTree1.singleexpand='true';
		pmyTree1.pageno=0;		
		pmyTree1.index=-1;	
		pmyTree1.contextmenu='myContextMenu1';	
		//pmyTree1.fields='cid;text;nodetext;level;sysnumber;parentnodeid';
		pmyTree1.fields='';  //否则按表格显示
		pmyTree1.name='myTree1';		
		pmyTree1.varname='pmyTree1';
		//生成编译得到的控件和事件		
		eval(pmyForm.tabstr); //定义表单myForm*
		eval(pmyForm.groupboxstr); //定义表单中的groupbox控件
		eval(pmyForm.fieldstr); //定义表单ffffff中的其他控件textfield,combo,datefield
		//console.log(pmyForm.tabstr); //定义表单myForm*
		//console.log(pmyForm.groupboxstr); //定义表单中的groupbox控件
		//console.log(pmyForm.fieldstr); //定义表单ffffff中的其他控件textfield,combo,datefield
		//将没有定义的列定义到myForm1
	    //alert(pmyTree1.sql);
		/**************************定义工具栏tbar开始**********************************/
		//定义菜单选项
		var mtitle='';
		for (var k=1;k<=pItemGridCount;k++){
			var pgrid=eval("pmyItemGrid"+k);
			if (pgrid.filterfields!=undefined){
				var pfid={};
				pfid.fields=pgrid.filterfields;
				pfid=myGetGridColumn(pfid);
				for (var i=0;i<pfid.xtitle.length;i++){
					if (pfid.xfield[i]!='sysrowno'){
						if (mtitle!='') mtitle+=';';
						mtitle=mtitle+pfid.xfield[i]+'/'+pfid.xtitle[i]+sys.tab+k;
					}
				}
			}else{
				for (var i=0;i<pgrid.xtitle.length;i++){
					if (pgrid.xfield[i]!='sysrowno' && pgrid.xshowtitle[i]){
						if (mtitle!='') mtitle+=';';
						mtitle=mtitle+pgrid.xfield[i]+'/'+pgrid.xtitle[i]+sys.tab+k;
					}
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
		myFilterCheckMenu=mysetCheckMenuVisible(myFilterCheckMenu,1);	    
		/**************************定义工具栏tbar结束**********************************/	
		/**************************定义右击菜单开始******************************/
		var myContextMenu1=Ext.create('Ext.menu.Menu',{//菜单
	    items:[
			{text:'新增',id:'popadd',iconCls:'addIcon',handler:fnAddRecord,xaction:'add'},
			{text:'修改',id:'popupdate',iconCls:'editIcon',handler: fnEditRecord,xaction:'update'},
	    	{text:'删除',id:'popdelete',iconCls:'deleteIcon',handler:fnDeleteRecord,xaction:'delete'},
	    	{xtype:'menuseparator',id:'savebar2'},
	    	{text:'保存',id:'popsave',iconCls:'saveIcon',handler:fnSaveRecord,xaction:'save'},
	    	{xtype:'menuseparator',id:'refreshbar2'},
	        {text:'刷新',id:'poprefresh',iconCls:'refreshIcon',handler:fnRefreshRecord}
	    ]});	
	    
		var myContextMenu2=Ext.create('Ext.menu.Menu',{//菜单
	    items:[
			{text:'追加一行',id:'popappendx',iconCls:'addIcon',handler:fnInsertItemRecord,xaction:'add'},
			{text:'插入一行',id:'popinsertx',iconCls:'editIcon',handler: fnInsertItemRecord,xaction:'update'},
	    	{text:'删除一行',id:'popdeletex',iconCls:'deleteIcon',handler:fnDeleteItemRecord,xaction:'delete'},
	    	{xtype:'menuseparator',id:'savexbar2'},
	    	{text:'保存',id:'popsavex',iconCls:'saveIcon',handler:fnSaveRecord,xaction:'save'},
	    	{xtype:'menuseparator',id:'resetxbar2'},
	        {text:'重置',id:'poprsetx',iconCls:'resetIcon',handler:fnResetItemRecord},
	    	{xtype:'menuseparator',id:'refreshxbar2'},
	        {text:'刷新',id:'poprefreshx',iconCls:'refreshIcon',handler:fnRefreshRecord}
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
			mySetCmpVisible('cmdreview;popreview;reviewbar1;reviewbar2;popreviewx;reviewxbar2',false);
		}else pmyTable.editflag[4]=1;
		if (pmyTable.permission.indexOf(';print;')<0){
			mySetCmpVisible('cmdprint;popprint;printbar1;printbar2',false);
		}
		if (pmyTable.permission.indexOf(';filter;')<0){
			mySetCmpVisible('cmdfilter;filterbar1;filterbar2;filterbar3;filtertext;columnchoose',false);
		}
		if (pmyTable.editflag[1]+pmyTable.editflag[2]+pmyTable.editflag[3]==0){  //查询状态
			mySetCmpVisible('refreshbar2',false);
		}	
		if (pmyTable.editflag[1]+pmyTable.editflag[2]==0){  //查询状态
			mySetCmpVisible('cmdbar;cmdsave;popsave;savebar1;savebar2;popsavex;savexbar2;btnsave',false);
			mySetCmpVisible('popappendx;popinsertx;popdeletex;popreviewx;popsavex;poprsetx;reviewxbar2;savexbar2;resetxbar2;refreshxbar2',false);
			if (Ext.getCmp('btnclose')!=null) Ext.getCmp('btnclose').setText('关闭');		
			for (var k=1;k<=pItemGridCount;k++) {
				var pgrid=eval("pmyItemGrid"+k);
				pgrid.style='single';
			}	
		}
		//是否取当月数据,，改变SQL语句
  		if (pmyTable.document.datefield!=''){
			sys.year=myGetDatePart('year',sysdate);
			sys.month=myGetDatePart('month',sysdate);
			sys.day=myGetDatePart('day',sysdate);
			sys.date=sys+'-'+sys.month+'-'+sys.day;
			sys.date0=sys.year+'-01-01';
			sys.date1=sys.year+'-'+sys.month+'-01';
			sys.date2=sys.year+'-'+sys.month+'-'+myDaysInaMonth(sys.year,sys.month);
			if (pmyTable.editflag[1]+pmyTable.editflag[2]+pmyTable.editflag[3]==0)  //查询状态
	  			pmyTable.document.daterange="("+pmyTable.document.datefield+" between '"+sys.date0+"' and '"+sys.date2+"')";
			else 
				pmyTable.document.daterange="("+pmyTable.document.datefield+" between '"+sys.date1+"' and '"+sys.date2+"')";
			pmyGrid1.sql=myAddWheretoSql(pmyGrid1.sql,pmyTable.document.daterange);	  		
			pmyTree1.sql=myAddWheretoSql(pmyTree1.sql,pmyTable.document.daterange);	  		
  		}
    	console.log(pmyGrid1.sql);
    	//alert(pmyTree1.sql);
    	console.log(pmyItemGrid1.sql);
		
    	if (pmyTable.active=='grid') pmyTree1.sql='';
    	else pmyGrid1.sql='';    	
		eval(myDefineGrid(pmyGrid1));//生成grid
		pmyTable.moverecordevent='';
		for (var k=1;k<=pItemGridCount;k++) {
			eval(myDefineGrid(eval("pmyItemGrid"+k)));
			var pgrid=eval("pmyItemGrid"+k);
			var grid=eval("myItemGrid"+k);
			for (var r=0;r<grid.columns.length;r++){
 				if (grid.columns[r]!=null && grid.columns[r].editable){
 					pgrid.starteditcolumn=r;
 					break;
 				}	
 			}
	 		pmyTable.moverecordevent+="myItemGrid"+k+".on('select',function(model,record,index) {\n";
			pmyTable.moverecordevent+="mySetMoveRecordBtn(myItemGrid"+k+",record);\n";
			pmyTable.moverecordevent+="});\n";
		}
		eval(pmyTable.moverecordevent);  //光标移动按钮disabled状态控制	
	    eval(myDefineTree(pmyTree1));
		var root=myTree1.setRootNode({  //修改根节点的值
			text:pmyTree1.roottitle,
			iconCls: 'folderopenIcon',
            cid:'',
            level:0,
            expanded:false,                
            leaf:true                
		});
		//添加隐藏列
		eval(myAddHiddenFields(pmyGrid1.fieldset,'myForm1'));
		eval(myAddHiddenFields(pmyForm.hiddenfields,'myForm1'));
		eval(myDefineHiddenField('myForm1','addoredit'));
		eval(pmyForm.eventstr); //定义事件在hidden字段之后
		//itemgridpanel定义
		var gridpanel=[];
		var str='';
		pmyGrid1.detailgridheight=0; //明细表的高度
		for (i=1;i<=pItemGridCount;i++){
			pmyGrid1.detailgridheight=Math.max(pmyGrid1.detailgridheight,eval("pmyItemGrid"+i+".height"));
			str="var myGridPanel"+i+"=Ext.create('Ext.panel.Panel',{";
			str=str+"	title:'&nbsp;"+eval("pmyItemGrid"+i+".title")+"',";
			str=str+"	containerScroll:true,";
			str=str+"	collapsible:true,";
			str=str+"   layout:'border',";
			str=str+"	items:[myItemGrid"+(i)+"]";
			str=str+"	});";
			str=str+"gridpanel.push(myGridPanel"+i+");";
			eval(str);
		}
		eval(myDefineTab('myItemGridTab','','center','gridpanel',0,0,'false','myContextMenu2'));
		//按钮初始状态设置
		mySetCmpDisabled('cmdadd;popadd;cmdupdate;popupdate;cmddelete;popdelete;cmdsave;popsave;btnsave;cmdprint;popprint',false);
		mySetCmpDisabled(pmyForm.fileloadbutton,false);
		//计算按钮高度
		/****************************页面布局******************************/
		//定义页面布局
		eval(myDefineTab('myFormTab','',pmyForm.region,'['+pmyForm.panels+']',pmyForm.height,pmyForm.width,'false','myContextMenu1'));
	 	var myEditWin=Ext.create('Ext.window.Window', {
			height: pmyForm.height+64, //高度
			width: pmyForm.width+6+6, //宽度
			closeAction: 'hide',//关闭按钮 效果是隐藏当前窗体
			modal:true,
			title:pmyTable.tabletitle+'管理',
			resizable:false,
			layout: 'absolute',//布局方式
			buttons:[
				{text:'确定',id:'btnsave', height:25,handler:function(){ fnSaveList(); }},
				{text:'取消',id:'btnclose',height:25,handler:function(){ myEditWin.hide(); }}
			],	
			listeners:{
				show:function(){
					//
				}
			}
		});
		if (pmyTable.active=='grid') var cmp1=myGrid1;
		else var cmp1=myTree1;
		if (pItemGridCount==1){
			var cmp2=myItemGrid1;
			myItemGridTab.setVisible(false);
		}else var cmp2=myItemGridTab;
		var myView=Ext.create('Ext.Viewport', {
	        layout: { type: 'border', padding: 5 },
	        defaults: { split: true },
	        items: [tbar,cmp1,cmp2]
	    });
		if (pmyForm.pagecount>1){
			myEditWin.add(myFormTab);
		}
		else{
			myFormTab.setVisible(false);
			myEditWin.add(myForm1);
		}
		//myTree1事件
		myTree1.on('beforeload',function(store) {  //bbbbbbe
	   		var sql=pmyTree1.sql;
			var newparams={ database:sysdatabasestring, sqlString:sql,keyField:'cid' };
			Ext.apply(store.proxy.extraParams,newparams);
			store.proxy.url='system//fn_getChildNodes.jsp';					
		});				
		myTree1.on('load',function(){
	    	var root=myTree1.getRootNode();
	    	root.set('text',"全部"+pmyTree1.title+'（'+root.childNodes.length+'组）');
	    	root.expand();
			var records=myTree1.getSelectionModel().getSelection();
			if (records[0] && records[0]!=root && !records[0].get('leaf')){
			   	records[0].set('text',records[0].get('text')+'（'+records[0].childNodes.length+'组）');
			}
			if (root.childNodes.length>0) myTree1.getSelectionModel().select(1);
		});

		myTree1.on('select',function(model, record, index) {//监听树选中时间
			for (var i=1;i<=pItemGridCount;i++)	eval("pmyItemGrid"+i+".reloadflag=1;");
			if (myItemGridTab.isVisible()) var tabno=myGetActiveTabIndex(myItemGridTab);
			else var tabno=1; 
           	fnLoadmyItemGrid(record);
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

		myGrid1.on('select',function(model,record,index) {  //schange
			for (var i=1;i<=pItemGridCount;i++)	eval("pmyItemGrid"+i+".reloadflag=1;");
			//调用函数,控制记录移动指针的disabled状态
			if (myItemGridTab.isVisible()) var tabno=myGetActiveTabIndex(myItemGridTab);
			else var tabno=1; 
			fnLoadmyItemGrid(record);
			//eval(mySetRecordMoveBtn('myItemGrid'+tabno,'record'));			
		});
		
		/**************************以下是函数************************************/
		myFormTab.on('tabchange',function(tabPanel,newCard,oldCard,eOpts ){
	    	myFocusInTab(tabPanel);  //聚焦第一个非只读控件 					
		});
		
		
		myItemGridTab.on('tabchange',function(tabPanel,newCard,oldCard,eOpts ){  //tttttab
			if (myItemGridTab.isVisible())	var tabno=myGetActiveTabIndex(myItemGridTab);
			else var tabno=1;
			//设置过了条件菜单 
			myFilterCheckMenu=mysetCheckMenuVisible(myFilterCheckMenu,tabno);			
			var pgrid=eval("pmyItemGrid"+tabno);
			var grid=eval("myItemGrid"+tabno);
			if (pgrid.reloadflag==1){
				if (pmyTable.active=='grid') var records=myGrid1.getSelectionModel().getSelection();
				else var records=myTree1.getSelectionModel().getSelection();
				pgrid.index=0;
				pgrid.column=pgrid.starteditcolumn;
				if (records[0]) fnLoadmyItemGrid(records[0]);
			}
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
			mySetCmpDisabled('cmdsave;popsave;btnsave;',false);
			//mySetCmpDisabled('popappendx;popinsertx;popdeletex;popreviewx;popsavex;popresetx;poprefreshx;btnsave;',false);
			mySetCmpDisabled(pmyForm.fileloadbutton,true);
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
			//清空sys_keyvalues值
			for (var i=1;i<=pItemGridCount;i++)	eval("pmyItemGrid"+i+".sys_keyvalues='';");
			myEditWin.setTitle('新增'+pmyGrid1.title);
			myEditWin.show();
			if (myFormTab.visible){
				myFormTab.setActiveTab(0);
	    		myFocusInTab(myFormTab);  //聚焦第一个非只读控件
	    	}else{
		    	myFocusInTab(myForm1);  //聚焦第一个非只读控件
	    	}       		
		}
		
		function fnEditRecord(){   //eeeeeeeee
			//mySetCmpDisabled('btnsave;',false);
       		for (var i=1;i<=pmyForm.pagecount;i++) {
       			eval(mySetFormReadOnly('myForm'+i,'false'));
       		}	
       		if (Ext.getCmp(pmyTable.keyfield)!=null) Ext.getCmp(pmyTable.keyfield).setReadOnly(true);
			mySetCmpDisabled('cmdreview;popreview',true);
			//mySetCmpDisabled('filepathcmdup;filepathicon',false);
			mySetCmpDisabled(pmyForm.fileloadbutton,false);
	    	//myFormTab.setActiveTab(0);
			Ext.getCmp('addoredit').setValue('2');
			myEditWin.setTitle('修改'+pmyTable.tabletitle);
			myEditWin.show();
			if (myFormTab.visible){
				//myFormTab.setActiveTab(0);
	    		myFocusInTab(myFormTab);  //聚焦第一个非只读控件
	    	}else{
		    	myFocusInTab(myForm1);  //聚焦第一个非只读控件
	    	}       		
		}
		
		function uploadfile(){ //上传附件
			var records=myGrid1.getSelectionModel().getSelection();//获取gird所有选中的records
			if(records[0]){	//获取第一个record对象
			}					
		}

		//保存类别
		function fnSaveList(){   //ssssssave保存类别
			pmyTable.error='';
			var xaddoredit=Ext.getCmp('addoredit').getValue();
			//数据保存前系统变量赋值,返回字符串命令
			eval(mySetSysVars());  
			if (pmyTable.active=='grid'){
				var records=myGrid1.getSelectionModel().getSelection();
				var record=records[0];
				var fields=myGrid1.store.model.getFields();  //获取store全部列
				var str="'sysrowno':'0'";
				for (var j=0;j<fields.length;j++){
					if (fields[j].name!='sysrowno' && Ext.getCmp(fields[j].name)!=null){
						var value=Ext.getCmp(fields[j].name).getValue();
						var type=Ext.getCmp(fields[j].name).getXType().toLowerCase();
						//console.log(fields[j].name+'---'+value+'--'+type);
						if (type=='datefield'){
							value=Ext.util.Format.date(value,sysfulldateformat);
							if (value=='' || value=='1900-01-01') value='null';
						}	
						str+=",'"+fields[j].name+"':'"+value+"'";
						if (xaddoredit=='2' && records[0]) records[0].set(fields[j].name,value);
					}
				}
				var data=eval("[{"+str+"}];");
				if (xaddoredit=='1'){  //新增类别
					var row=myGrid1.store.getCount();
		 			pmyGrid1.index=row;
		 			myGrid1.store.insert(row,data);
					for (var i=0;i<myGrid1.store.getCount();i++){
						var record=myGrid1.store.getAt(i);
						record.set('sysrowno',i+1);	
					}
				}
				myGrid1.getSelectionModel().select(pmyGrid1.index);
			}else{  //ssssssave-tree树处理
				var exp=myConvertExpression(pmyTree1.nodetextexpression,'cmp');
				var records=myTree1.getSelectionModel().getSelection();
				var fields=myTree1.store.model.getFields();  //获取store全部列
				var xid='';
				var str="";
				for (var j=0;j<fields.length;j++){
					if (Ext.getCmp(fields[j].name)!=null){
						var value=Ext.getCmp(fields[j].name).getValue();
						var type=Ext.getCmp(fields[j].name).getXType().toLowerCase();
						if (type=='datefield'){
							value=Ext.getCmp(fields[j].name+"_xvalue").getValue()
							//在表达式中替换日期值变量
							exp=eval("exp.replace(/"+fields[j].name+"/g,'"+fields[j].name+"_xvalue')");
							//value=Ext.util.Format.date(value,sysfulldateformat);
							//if (value=='' || value=='1900-01-01') value='null';
						}
						if (str!='') str+=",";	
						str+="'"+fields[j].name+"':'"+value+"'";
						if (xaddoredit=='2' && records[0]) records[0].set(fields[j].name,value);
						if (fields[j].name==pmyTree1.keyfield){
							str+=",'cid':'"+value+"'";
							xid=value;
						}	
					}
				}//for
				//console.log(exp);
				var nodetext=eval(exp);
				str+=",text:'"+nodetext+"'";
				str+=",iconCls: 'leafIcon'";
            	str+=",level:1, expanded:false, leaf:true";
				var data=eval("[{"+str+"}];");
				if (xaddoredit=='1'){  //新增类别
					//treeEditor.startEdit(newNode.ui.textNode)
			    	var root=myTree1.getRootNode();
					root.appendChild(data);
					var record=root.findChild('cid',xid);
					myTree1.getSelectionModel().select(record);
				}else{
					var record=records[0];
					record.set('text',nodetext);  //修改节点文本值
				}		
			}//tree结束
			if (pmyTable.error==''){
				myEditWin.hide();
				fnLoadmyItemGrid(record);
			}
		}
		
		function fnSaveRecord(){  //ssssssave
			var xaddoredit=Ext.getCmp('addoredit').getValue();
			if (myItemGridTab.isVisible())	var tabno=myGetActiveTabIndex(myItemGridTab);
			else var tabno=1; 
			var pgrid=eval("pmyItemGrid"+tabno);
			var grid=eval("myItemGrid"+tabno);
			var xaddoredit=Ext.getCmp('addoredit').getValue();
			pmyTable.error='';
			pmyTable.msg='';
			//保存list数据（grid1 or tree1）
			var plist={}
			plist.updatesql='';
			plist.querysql='';
			if (pmyTable.active=='grid'){
				var records=myGrid1.getSelectionModel().getSelection();
				plist.sql=pmyGrid1.sql;
				plist.keyfield=pmyGrid1.keyfield;
				plist.keyspec=pmyGrid1.keyspec;
				plist.keyvalue='';
				plist.tablename=pmyGrid1.tablename;
				plist.tablespec=pmyGrid1.tablespec;
				plist.editablefieldset=myGetTableEditableFields(sysdatabasestring,pmyGrid1.tablename);
			}else{
				var records=myTree1.getSelectionModel().getSelection();
				plist.sql=pmyTree1.sql;
				plist.keyfield=pmyTree1.keyfield;
				plist.keyspec=pmyTree1.keyspec;
				plist.keyvalue='';
				plist.tablename=pmyTree1.tablename;
				//将表中可编辑字段赋值到pmyForm.editablefieldset中
				plist.editablefieldset=myGetTableEditableFields(sysdatabasestring,pmyTree1.tablename);
			}
			if (records[0]){
				//取关键字值--type
				if (Ext.getCmp(plist.keyfield)!=null){
					xtype=Ext.getCmp(plist.keyfield).getXType().toLowerCase();
					//plist.keyvalue=Ext.getCmp(plist.keyfield).getValue();
					plist.keyvalue=records[0].get(plist.keyfield);
					if (xtype=='datefield'){
						plist.keyvalue=Ext.util.Format.date(plist.keyvalue,sysfulldateformat);
						if (plist.keyvalue=='' || plist.keyvalue=='1900-01-01') plist.keyvalue='null';
					}
				}
				var kflag=(plist.editablefieldset+';').indexOf(':'+plist.keyfield+';');
				if (xaddoredit=='1' && plist.keyvalue!='' && kflag>=0) pmyTable.error+=myPKUniqueCheck(plist);			
				plist.records=records;
				eval(mySetSysVars()); //数据保存前系统变量赋值,返回字符串命令
				if (plist.tablename!=pgrid.tablename){
					plist.updatesql+="delete "+plist.tablename+" where "+plist.keyfield+"='"+plist.keyvalue+"'\n";
					if (pmyTable.active=='grid'){
						var result=myGridReplaceValidationSql(sysdatabasestring,myGrid1,plist.tablename,p.list[0].replace,p.list[0].validation,records);
		       			var tmp=result.split(sys.tab);
		       			if (tmp[0]!=''){
		       				pmyTable.error+="<br>["+pmyGrid1.title+"]错误信息：";
		       				pmyTable.error+=tmp[0];
		        		}
		        		plist.updatesql+=" "+tmp[1]+"\n";
	        		}else{
						pmyTable.error='';  //出错信息
						eval(myFormReplaceValidation(pmyTree1,p.list[0].replace,p.list[0].validation));
						eval(myGetFormValues(pmyForm));
						plist.updatesql+=" "+myGenInsertSql(pmyTree1.tablename,plist.editablefieldset,pmyForm.fieldtext)+"\n";
						//plist.updatesql+=" "+myGenUpdateSql(pmyTree1.tablename,plist.editablefieldset,pmyForm.fieldtext,plist.keyfield,plist.keyvalue)+"\n";
	        		}
        		}				
				console.log('msql='+plist.updatesql);
				//处理明细表  
				pgrid.updatesql='';
				pgrid.editablefieldset=myGetTableEditableFields(sysdatabasestring,pgrid.tablename);
				//明细验证数据和替换replace & validation
				if (pgrid.sys_keyvalues!=''){
					//先删除本页记录（其它页不考虑），关键字值放在sys_keyvalues中
					pgrid.updatesql+=" delete "+pgrid.tablename+" where "+pgrid.keyfield+" in ("+pgrid.sys_keyvalues+")";
					pgrid.updatesql+=" and "+plist.keyfield+"='"+plist.keyvalue+"'\n";
				}
				var result=myGridReplaceValidationSql(grid,pgrid.tablename,p.grid[tabno-1].replace,p.grid[tabno-1].validation);	        			
				var tmp=result.split(sys.tab);
				if (tmp[0]!=''){
					if(pmyItemGrid1.title!=''){
						pmyTable.error+="<br>["+pmyItemGrid1.title+"]输入出错信息：";
					}
					pmyTable.error+=tmp[0];
	        	}
	        	pgrid.updatesql+=" "+tmp[1];
				//数据验证错误判断
				if (pmyTable.error!=''){
					eval(sysError('发现下列错误，记录保存失败！<br>'+pmyTable.error,0,0));
					return;
				}
				//数据库操作语句
				var updatesql=plist.updatesql+' '+pgrid.updatesql;	
				//保存记录后求记录的行号，用于grid页面定位行号
				var querysql="select rowno=count(*)+1 from ("+plist.sql+") as p where "+plist.keyfield+"<'"+plist.keyvalue+"'\n";
				console.log(updatesql);
				console.log(querysql);
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
							if (pmyTable.active=='grid'){
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
							}else{	  
								//聚焦树节点或重载树
								var root=myTree1.getRootNode();
								var node=root.findChild('cid',plist.keyvalue,true);
								if (node==null){
									pmyTree1.selectedcode=plist.keyvalue;
									pmyTree1.rootcode='';
									myTree1.store.load();
								}else{
									myTree1.getSelectionModel().select(node);
									pmyTree1.selectedCode='';
								}
							}								
		       				Ext.getCmp('addoredit').setValue('2');
							Ext.getCmp('filtertext').setValue('');
					    	if (pmyTable.msg!=''){
		       					eval(sysInfo('记录已经保存成功！<br>'+pmyTable.msg,0,0));
					    	}else{     		
		       					eval(sysWait('记录已经保存成功！',160,100,600));
		       				}
		       			}else{
							eval(sysError('发现下列错误，'+pmyTable.tabletitle+'保存失败！<br>'+pmyTable.error,0,0));
		       			}	           					
	       			} //callback		
				});	
			}//if records[0]
			
		}
		
		function fnDeleteRecord(){ //ddddddelete删除list
			if (myItemGridTab.isVisible())	var tabno=myGetActiveTabIndex(myItemGridTab);
			else var tabno=1; 
			var pgrid=eval("pmyItemGrid"+tabno);
			var grid=eval("myItemGrid"+tabno);
			var cnode=null;
			if (pmyTable.active=='grid'){
				var records=myGrid1.getSelectionModel().getSelection();
				var xid=records[0].get(pmyGrid1.keyfield);
				var sql='delete '+pmyGrid1.tablename+' where '+pmyGrid1.keyfield+"='"+xid+"'\n";
				if (pmyGrid1.tablename!=pgrid.tablename && pgrid.tablename!=''){
					sql+='delete '+pgrid.tablename+' where '+pmyGrid1.keyfield+"='"+xid+"'\n";
				}
			}else{
				var records=myTree1.getSelectionModel().getSelection();
				if (records[0]){
					cnode=records[0].nextSibling;  //selectNext();
					if (cnode==null) cnode=records[0].previousSibling;
					if (cnode!=null) pmyTree1.selectedcode=cnode.get('cid');
					else pmyTree1.selectedcode='';
					var xid=records[0].get(pmyTree1.keyfield);
					var sql='delete '+pmyTree1.tablename+' where '+pmyTree1.keyfield+"='"+xid+"'\n";
					if (pmyTree1.tablename!=pgrid.tablename && pgrid.tablename!=''){
						sql+='delete '+pgrid.tablename+' where '+pmyTree1.keyfield+"='"+xid+"'\n";
					}
				}
			}
			if (!records[0]){
				Ext.Msg.alert('系统提示','请选择要删除的'+pmyTable.keyspec+'!');
				return;
			}else{	
				//console.log(sql);
				Ext.MessageBox.show({   
		            title: '系统提示',   
		            msg: mySpace(2)+'删除'+pmyTable.tabletitle+'<font color=blue><b>【'+xid+'】</b></font>这类记录。'+mySpace(10)+'<br><br>'+mySpace(2)+'是否确认？<br><br>' , 
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
										if (records[0]){
											//删除子节点节点
											root=myTree1.getRootNode();
											root.removeChild(records[0]);
										}
										if (cnode!=null) myTree1.getSelectionModel().select(cnode);
										else {									
											pmyTree1.rootcode='';
											myTree1.store.load();
										}
									}
								}//callback	
				           });  //ajax	            	
		            	}//if
		            }		//fn			
				});//messagebox
			}
		}
		
		function fnInsertItemRecord(e){  //iiiiiinsert插入明细
			if (pmyTable.active=='grid'){
				var records=myGrid1.getSelectionModel().getSelection();
				var mfield=pmyGrid1.keyfield;
			}else{
				var records=myTree1.getSelectionModel().getSelection();
				var mfield=pmyTree1.keyfield;
			}
			if (records[0]){
				var xid=records[0].get(mfield);
				if (myItemGridTab.isVisible())	var tabno=myGetActiveTabIndex(myItemGridTab);
				else var tabno=1; 
				var pgrid=eval("pmyItemGrid"+tabno);
				var grid=eval("myItemGrid"+tabno);
				pgrid.addoredit=1;
				var fields=grid.store.model.getFields();  //获取store全部列
				var str="'sysrowno':'0','"+mfield+"':'"+xid+"'";
				for (var j=0;j<fields.length;j++){
					if (fields[j].name!='sysrowno' && fields[j].name!=mfield){
						str+=",\""+fields[j].name+"\":''";
					}
				}
				var data=eval("[{"+str+"}];");
				if (e.id=='popappendx') var row=grid.store.getCount();
				else var row=pgrid.index;
				pgrid.index=row;
	 			var record=grid.store.insert(row,data);
				eval("myItemGrid"+tabno+"CellEditing.startEdit(row, pgrid.starteditcolumn);");  //ext4.2方法
				var rowCount=grid.store.getCount();				
				for (var i=0;i<rowCount;i++){
					var record=grid.store.getAt(i);
					record.set('sysrowno',i+1);	
				}
			}	
		}

		function fnDeleteItemRecord(){  //ddddelete
			if (myItemGridTab.isVisible())	var tabno=myGetActiveTabIndex(myItemGridTab);
			else var tabno=1; 
			var pgrid=eval("pmyItemGrid"+tabno);
			var grid=eval("myItemGrid"+tabno);
			pgrid.addoredit=3;
			var rowCount=grid.store.getCount();
			var row=pgrid.index;
			if (rowCount>0 && row<rowCount){
				var record=grid.store.getAt(row);
				grid.store.remove(record);
				if (row>=grid.store.getCount()){
					row=grid.store.getCount()-1;
				}
				pgrid.index=row;
	  		}
	  		var rowCount=grid.store.getCount();				
			for (var i=0;i<rowCount;i++){
				var record=grid.store.getAt(i);
				record.set('sysrowno',i+1);	
			}
			eval("myItemGrid"+tabno+"CellEditing.startEdit(row, pgrid.starteditcolumn);");  //ext4.2方法	  		
		}

		function fnResetItemRecord(){  //aaaaaa
			if (myItemGridTab.isVisible())	var tabno=myGetActiveTabIndex(myItemGridTab);
			else var tabno=1; 
			eval(myTruncateGrid("myItemGrid"+tabno));
			if (pmyTable.active=='grid'){
				var records=myGrid1.getSelectionModel().getSelection();
			}else{
				var records=myTree1.getSelectionModel().getSelection();
			}
			if (records[0]) fnLoadmyItemGrid(records[0]);
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
	            	leaf:false                
				}); //修改根节点的值
				pmyTree1.selectedecode='';
				pmyTree1.rootcode='';
				myTree1.store.load();
			}
		}
		
		function fnLoadmyGrid1(pageno,wheresql){ //lllllo重新加载grid数据
			var sql=pmyGrid1.sql;
			var xpagesize=myGrid1.store.pageSize;
			var newparams={ database:sysdatabasestring, sqlString:sql,keyField:pmyGrid1.keyfield,sortField:'',limit:xpagesize,totalFields:'' };
			Ext.apply(myGrid1.store.proxy.extraParams,newparams);
			if (pageno>0) myGrid1.store.loadPage(pageno); 	        
			else myGrid1.store.loadPage(1);
		}
		
		function fnLoadmyItemGrid(record){  //lllload
			var xfilter=Ext.getCmp('filtertext').getValue();
			var xfilterwhere=myGetFilterSql(myFilterCheckMenu,xfilter);  //获取过滤条件
			for (var i=1;i<=pmyForm.pagecount;i++) {
       			eval("myForm"+i+".getForm().loadRecord(record);");
       			//eval(mySetFormReadOnly('myForm'+i,'true'));
       		}	
			if (myItemGridTab.isVisible())	var tabno=myGetActiveTabIndex(myItemGridTab);
			else var tabno=1; 
			var grid=eval("myItemGrid"+tabno);
			var pgrid=eval("pmyItemGrid"+tabno);
			if (pmyTable.active=='grid'){			
				var xid=record.get(pmyGrid1.keyfield);
				var sql="select * from ("+pgrid.sql+") as p where "+pmyGrid1.keyfield+"='"+xid+"'";
			}else{
				var xid=record.get('cid');
				var sql="select * from ("+pgrid.sql+") as p where "+pmyTree1.keyfield+"='"+xid+"'";
			}
			if (xfilterwhere!='') sql+=" and "+xfilterwhere;
			pgrid.index=-1;
			pgrid.column=pgrid.starteditcolumn;
			pgrid.reloadflag=0;
			Ext.getCmp('addoredit').setValue('2');
			var newparams={ database:sysdatabasestring, sqlString:sql,keyField:pgrid.keyfield,sortField:pgrid.sortfield,limit:grid.store.pageSize,totalFields:'' };
			Ext.apply(grid.store.proxy.extraParams,newparams);
			grid.store.loadPage(1); 	        
		}	
		
		//快速过滤函数
		function fnQuickFilter(){
			if (pmyTable.active=='grid') var records=myGrid1.getSelectionModel().getSelection();
			else var records=myTree1.getSelectionModel().getSelection();
			if (records[0]) fnLoadmyItemGrid(records[0]);			
		}

		function fnKeyEvent(field,e) {
			if (myFormTab.visible){
				myKeyEvent(field,e,myFormTab);  //调用functions中的函数	    	}else{
	    	}else{      		
				myKeyEvent(field,e,myForm1);  //调用functions中的函数
			}
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
			mySetCmpDisabled('cmdupdate;popupdate;cmddelete;popdelete',flag);
			//mySetCmpDisabled('filepathcmdup;filepathicon',true);
			//Ext.getCmp('filepathsource').setValue(Ext.getCmp('filename').getValue());
		}
		
		function fnMoveTreeNode(id){
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
			}
		}		

		function fnMoveRecord(id){
			if (myItemGridTab.isVisible()) var tabno=myGetActiveTabIndex(myItemGridTab);
			else var tabno=1; 
			myMoveRecord(id,eval("pmyItemGrid"+tabno));
		}	
		
		//初始化ccccc
		/*
		var sys_checkedimage={
			xtype:'image',id:'sys_checkedimage',name:'sys_checkedimage',
			width:46,height:47,y:40,x:270,
			src:'../'+sys.project+'/system/images/chnchecked.png'
		};
		myForm1.add(sys_checkedimage);
		Ext.getCmp('sys_checkedimage').setVisible(false);
		*/
		if (pmyTable.document.datefield!='' && Ext.getCmp(pmyTable.document.datefield).getXType()=='datefield' && Ext.getCmp(pmyTable.document.datefield).xreadonly=='false') {
			Ext.getCmp(pmyTable.document.datefield).setMinValue(sys.date1);
			Ext.getCmp(pmyTable.document.datefield).setMaxValue(sys.date2);
		}
		eval(myGenBtnMoveRecord());  //生成记录移动和指针设置两个函数
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
		
	//****************************end of extjs**************************//
			
	}); 
  
  </script>
  </body>
</html>


