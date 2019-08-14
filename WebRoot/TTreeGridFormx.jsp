<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="com.DBConn" %>
<%@ page import="com.UserBean" %>
<%@ page import="com.StringUtil"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>TTreeGridForm模板</title>
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
		//定义itemgrids,可能不存在
		var pItemGridCount=0;
		if (p.detailgrid!=undefined){
			var pItemGridCount=p.detailgrid.length;
			for (var i=1;i<=pItemGridCount;i++) {
				eval("var pmyItemGrid"+i+"={};");
				eval("pmyItemGrid"+i+".flag=1;"); //生成明细记录的grid，可以有多个
				eval("pmyItemGrid"+i+".sysdatabasestring=sysdatabasestring;");
				eval("pmyItemGrid"+i+".gridpickercolumns=pmyForm.gridpickercolumns;");  //记录picker列，在生成grid时指定类型
				eval("pmyItemGrid"+i+".treepickercolumns=pmyForm.treepickercolumns;");  //记录picker列，在生成grid时指定类型
				var pd=p.detailgrid[i-1];
				eval("pmyItemGrid"+i+"=myGetGridAttrs(pd,pmyItemGrid"+i+");");  //获取grid值
				//设置初值
				eval("pmyItemGrid"+i+".region='center';");
				eval("pmyItemGrid"+i+".index=-1;");
				eval("pmyItemGrid"+i+".column=-1;");
				eval("pmyItemGrid"+i+".bartitle=pmyItemGrid"+i+".title;");
				eval("pmyItemGrid"+i+".showtitle='false';");
				//eval("pmyItemGrid"+i+".bbar='';");
				//eval("pmyItemGrid"+i+".tbar='';");
				eval("pmyItemGrid"+i+".keyevent='myGridColumnKeyEvent';");
				eval("pmyItemGrid"+i+".name='myItemGrid"+i+"';");
				eval("pmyItemGrid"+i+".varname='pmyItemGrid"+i+"';");
				//下一个itemgrid
			}
		}	
		
		//存储grid中combo之类的sql语句，bbar等
		eval(pmyForm.gridcmpstr);
		eval(myDefineGrid(pmyGrid1));//生成grid
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
		}
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
		pmyTree1.groupfield=[];
		if (pmyTable.document.datefield!=''){	
			pmyTree1.groupid=pmyTable.document.datefield;
			//pmyTree1.groupfield[1]=pmyTable.document.datefield;
			pmyTree1.grouptext=pmyGrid1.tabletitle+'日期';
		}else{
			pmyTree1.groupid='';
			pmyTree1.grouptext=pmyGrid1.tabletitle;
		}
		//生成编译得到的控件和事件		
		eval(pmyForm.tabstr); //定义表单myForm*
		eval(pmyForm.groupboxstr); //定义表单中的groupbox控件
		eval(pmyForm.fieldstr); //定义表单ffffff中的其他控件textfield,combo,datefield
		//将没有定义的列定义到myForm1
		eval(myAddHiddenFields(pmyGrid1.fieldset,'myForm1'));
		eval(myAddHiddenFields(pmyForm.hiddenfields,'myForm1'));
		eval(myDefineHiddenField('myForm1','addoredit'));
		eval(pmyForm.eventstr); //定义事件在hidden字段之后
		eval(myGenBtnMoveRecord());  //生成记录移动和指针设置两个函数
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
		tbar.add({id:'cmdadd', iconCls: 'addIcon',text: '新增',handler: fnAddRecord,tooltip: '增加新记录',xaction:'add'});
		tbar.add({id:'cmdupdate', iconCls: 'editIcon',text: '修改',handler: fnEditRecord,tooltip: '修改当前记录',xaction:'update'});
		tbar.add({id:'cmddelete', iconCls: 'deleteIcon',text: '删除',handler: fnDeleteRecord,tooltip: '删除当前记录',xaction:'delete'});
		tbar.add({id:'reviewbar1', xtype:'tbseparator'});
		tbar.add({id:'cmdreview', iconCls: 'checkIcon',text: '审核',handler: fnReviewRecord,tooltip: '审核当前记录',xaction:'review'});
		tbar.add({id:'editbar1', xtype:'tbseparator'});
		tbar.add({id:'cmdsave', iconCls: 'saveIcon',text: '保存',handler: fnSaveRecord,tooltip: '保存正在修改或新增的记录',xaction:'save'});
		tbar.add({id:'savebar1', xtype:'tbseparator'});
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
		var myContextMenu3=Ext.create('Ext.menu.Menu',{//菜单
	    items:[
			{text:'',id:'poptitleitem',xaction:''},'-',
			{text:'插入记录',id:'popinsertitem',iconCls:'addIcon',handler:fnInsertItemRecord,xaction:'add'},
			{text:'追加记录',id:'popappenditem',iconCls:'addIcon',handler: fnInsertItemRecord,xaction:'add'},
	    	{text:'删除记录',id:'popdeleteitem',iconCls:'deleteIcon',handler:fnDeleteItemRecord,xaction:'delete'},
	    	{xtype:'menuseparator',id:'savebar3'},
	    	{text:'保存明细表',id:'popsaveitem',iconCls:'saveIcon',handler:fnSaveItemRecord,xaction:'save'},
	    	{xtype:'menuseparator',id:'resetbar1'},
	        {text:'清空明细表',id:'popresetitem',iconCls:'resetIcon',handler:fnResetItemRecord},
	        {text:'重载明细表',id:'poprefreshitem',iconCls:'refreshIcon',handler:fnRefreshItemRecord}
	    ]});	
		/**************************定义右击菜单结束******************************/
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
		if (pmyTable.document.reviewflag==''){
			pmyTree1.region='west';
		}else{
			pmyTree1.bartitle=pmyTree1.title;
			pmyTree1.title='未审核';		
		}
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
		pmyGrid1.detailgridheight=0; //明细表的高度
		for (i=1;i<=pItemGridCount;i++){
			pmyGrid1.detailgridheight=Math.max(pmyGrid1.detailgridheight,eval("pmyItemGrid"+i+".height"));
			str="var myGridPanel"+i+"=Ext.create('Ext.panel.Panel',{";
			str=str+"	title:'&nbsp;"+eval("pmyItemGrid"+i+".bartitle")+"',";
			str=str+"	containerScroll:true,";
			str=str+"	collapsible:true,";
			str=str+"   layout:'border',";
			str=str+"	items:[myItemGrid"+(i)+"]";
			str=str+"	});";
			str=str+"gridpanel.push(myGridPanel"+i+");";
			eval(str);
		}
		if (pmyGrid1.height>0 && pmyGrid1.detailgridheight<=0){
			pmyGrid1.detailgridheight=Math.max(150,sys.windowheight-pmyGrid1.height);		
		}else if (pmyGrid1.height==0 && pmyGrid1.detailgridheight==0){
			pmyGrid1.detailgridheight=0.3*sys.windowheight;		
		} 			
		//按钮初始状态设置
		mySetCmpDisabled('cmdadd;popadd;cmdupdate;popupdate;cmddelete;popdelete;cmdsave;popsave;btnsave;cmdprint;popprint',false);
		myContextMenu3.setDisabled(true);
		fnSetItemGridEditable(false);
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
		var myBtnPanel=Ext.create('Ext.form.Panel',{
			frame:false,  	//是否具有框架效果  
			region:'west',  
			height: 2*titleheight+40,
			width: 30,
			bodyStyle:'padding:15 15 15 15',
			layout:'absolute',
			border:false,
			items:[{
				xtype:'button',
				id:'mybtn1',
				enableToggle:true,
				allowDepress:true,
				height: titleheight,
        		width:28,
	        	//cls:'x-btn-default-small-btn',
    	    	x:1,
        		y:1,
        		text: s1, //'客<br>户<br>列<br>表',
	 			handler:function(btn){
    	        	fnSetBtn(1);
        		}
			},{
				xtype:'button',
				id:'mybtn2',
				enableToggle:true,
				allowDepress:true,
    	    	height: titleheight,
        		width:28,
	        	x: 1,
    	    	y: titleheight+3,        	
        		text: s2, //'客<br>户<br>详<br>情',
 				handler:function(btn){
					fnSetBtn(2);
	        	}        				
			}]
		});
		//wwwwww
		/****************************页面布局******************************/
		if (pmyTable.document.reviewflag==''){
			myTree1.collapsed=true;
			mySetCmpVisible('cmdgroup;groupbar1',true);
		}else{
			//myTree1.collapsed=true;
			//if (pmyTree1.groupfields!=undefined && pmyTree1.groupfields==''){
				//myTree1.setVisible(false);
				mySetCmpVisible('cmdgroup;groupbar1',false);
			//}
		}       
		//定义页面布局
		if (pmyForm.modal!='window'){
			eval(myDefinePanel('myGridPanel','','[myGrid1]',0,0,'false'));
			if (pItemGridCount>0){
				eval(myDefineTab('myFormTab','','north','['+pmyForm.panels+']',pmyForm.height,pmyForm.width,'false','myContextMenu1'));
				eval(myDefineTab('myItemGridTab','','center','gridpanel',0,0,'false','myContextMenu3'));
				eval(myDefinePanel('myDetailPanel','','[myFormTab,myItemGridTab]',0,0,'false',''));
			}else{
				eval(myDefineTab('myFormTab','','center','['+pmyForm.panels+']',pmyForm.height,pmyForm.width,'false','myContextMenu1'));
				eval(myDefineTab('myItemGridTab','','south','gridpanel',0,0,'false','myContextMenu3'));
				eval(myDefinePanel('myDetailPanel','','[myFormTab]',0,0,'false'));
				myItemGridTab.setVisible(false);
			}
			var myView=Ext.create('Ext.Viewport', {
		        layout: { type: 'border', padding: 5 },
		        defaults: { split: true },
		        items: [tbar,myTree1,Ext.create('Ext.panel.Panel',{
		        	region:'center',
		        	layout:'border',
		        	items:[
		        		myBtnPanel,
		        		Ext.create('Ext.panel.Panel',{
		        			id:'myActivePanel',
				        	region:'center',
				        	layout:'fit',
				        	items:[
				        		myGridPanel
				        	]
				        })
		        	]
		        })]
		    });			
		}else{
			eval(myDefinePanel('myGridPanel','','[myGrid1]',0,0,'false'));
			eval(myDefineTab('myFormTab','','center','['+pmyForm.panels+']',pmyForm.height,pmyForm.width,'false','myContextMenu1'));
			eval(myDefineTab('myItemGridTab','','south','gridpanel',pmyGrid1.detailgridheight,0,'false','myContextMenu3'));
			eval(myDefinePanel('myDetailPanel','','[myGridPanel,myItemGridTab]',0,0,'false'));
			if (pItemGridCount==0){
				myItemGridTab.setVisible(false);
			}
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
		        items: [tbar,myTree1,Ext.create('Ext.panel.Panel',{
		        	region:'center',
		        	layout:'border',
		        	items:[
		        		Ext.create('Ext.panel.Panel',{
		        			//id:'myActivePanel',
				        	region:'center',
				        	layout:'fit',
				        	items:[
				        		myGridPanel
				        	]
				        }),
						Ext.create('Ext.panel.Panel',{
		        			//id:'myActivePanel2',
				        	region:'south',
				        	layout:'fit',
				        	items:[
				        		myItemGridTab
				        	]
				        })				        
		        	]
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
  			//select语句中增加where条件	
			pmyGrid1.sql=myAddWheretoSql(pmyGrid1.sql,pmyTable.document.daterange);	  		
			pmyGrid1.paramsql=pmyGrid1.sql;
  		}
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
			if (pmyForm.modal!='window') fnSetBtn(1);
           	fnLoadmyGrid1(1,'','tree');
		});
		myTree1.on('containercontextmenu',function(tree, e){  //定义右键   		
   			e.preventDefault();
   			myContextMenu2.showAt(e.getXY());
   		});
   		myTree1.on('itemcontextmenu',function(tree, record, item, index, e){  //定义右键   		
   			e.preventDefault();
   			myContextMenu2.showAt(e.getXY());
   		});
  		
		/**************************定义tree结束***********************************/
		/*
		myItemGrid1.on('edit', function(editor, e, eOpts){
			var field = e.field;
			var record = e.record;
			pmyItemGrid1.error = 0;//老师这里一定要写这句话，不然会导致死循环
			if (field == 'contactid'){
				pmyItemGrid1.error = fncontactidColumnCheck(pmyItemGrid1.sql, field);
			}else{
				//pmyItemGrid1.error = 0;//老师这里一定要写这句话，不然会导致死循环
	         }
			//error为1时需重新定位到该单元格
			if (pmyItemGrid1.error == 1){
				editor.xrecord = e.record;
				editor.xcolumn = e.column;
				editor.startEdit(e.record, e.column);
			}
		});		
		myItemGrid1.on('beforeedit',function(editor, e) {
			//Ext.getCmp('myItemGrid1contactidColumn').setReadOnly(true);
			pmyItemGrid1.index=e.rowIdx;
			pmyItemGrid1.column=e.colIdx;
			var rowflag=e.record.data.sysrowno;
			//if (rowflag>0) myGrid1.columns[1].editable=false;
			//else myGrid1.columns[1].editable=true;
			if (!myItemGrid1.columns[e.colIdx+pmyItemGrid1.lockedcolumncount].editable) {
				e.cancel=true;
			}else {
				e.cancel=false;
			}
			var xrecord = editor.xrecord; 
			var	xcolumn = editor.xcolumn;
			if (!Ext.isEmpty(xrecord) && !Ext.isEmpty(xcolumn) && (xrecord != e.record || xcolumn != e.column)){	
				editor.cancelEdit();
				var fn = Ext.Function.createDelayed(function(){
					editor.startEdit(xrecord, xcolumn); //不用startEditByPosition()是以为fixed列的特殊性
					editor.xrecord = null;
					editor.xcolumn = null;
				}, 1);
				fn();
			}
			pmyItemGrid1.xrow=pmyItemGrid1.index;  //放在if error=1之后
			pmyItemGrid1.xcol=pmyItemGrid1.column;
		});
		*/

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
			//fnLoadRecord();			
			if (pmyForm.modal!='window') fnSetBtn(2);
			else{
           		myEditWin.setTitle(pmyForm.title);
           		myEditWin.show();
           	}
		}); 
		
		myGrid1.on('itemclick',function(view,record,item,index,event) {
			var xaddoredit=Ext.getCmp('addoredit').getValue();
			if (xaddoredit!='2') {
				fnLoadRecord();
			}			
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
		myItemGridTab.on('tabchange',function(tabPanel,newCard,oldCard,e ){
			fnLoadItemGrid(0,0);
		});
		
		myFormTab.on('tabchange',function(tabPanel,newCard,oldCard,eOpts ){
	    	myFocusInTab(tabPanel);  //聚焦第一个非只读控件 					
		});

		function fnPrintRecord(){  //ppppppp
			var date=sys.year+'年'+sys.month+'月'+sys.day+'日';
			var xtemplate="TCustomerQuery.xls";
			var xsql=" select customerid,customername,address,province,city,zip,phone,fax,homepage,contactname,employeename";
			xsql+=" from ("+pmyGrid1.paramsql+") as p";
			xsql+=" order by "+pmyGrid1.sortfield;
			//console.info(xsql);
			var xtitlecells="<2,1>"+date;
			var xtitlerange="<1>-<3>";  //标题为第1行到第4行，每页重复
			var xtargetfilename="客户基本信息列表.xls";
			var r=myExportExcelReport(xtemplate,xsql,xtitlecells,xtitlerange,'','',xtargetfilename);		
		}
		
		function fnAddRecord(){//新增 aaaaaa
			for (var i=1;i<=pItemGridCount;i++) {
				//需要刷新
				eval("pmyItemGrid"+i+".flag=1;");
				//eval("myItemGrid"+i+".store.removeAll(false);");
				eval(myTruncateGrid("myItemGrid"+i));				
			}
			//增加一条明细表空记录
			var tabno=1;
			var pgrid=eval("pmyItemGrid"+tabno);
			var grid=eval("myItemGrid"+tabno);
			var mfield=pgrid.masterfield;
			var mvalue=Ext.getCmp(mfield).getValue();
			pgrid.addoredit=1;
			var fields=grid.store.model.getFields();  //获取store全部列
			var str='"sysrowno":"0","'+mfield+'":"'+mvalue+'"';
			for (var j=0;j<fields.length;j++){
				if (fields[j].name!='sysrowno' && fields[j].name!=mfield){
					str+=",\""+fields[j].name+"\":''";
				}
			}
			var data=eval("[{"+str+"}];");
			var row=0;
			pgrid.index=row;
 			eval("var record=myItemGrid"+tabno+".store.insert(row,data);");
			//eval("myItemGrid"+tabno+".getSelectionModel().select(row);");
			eval("myItemGrid"+tabno+"CellEditing.startEdit(row, pmyItemGrid"+tabno+".starteditcolumn);");  //ext4.2方法
			var rowCount=grid.store.getCount();				
			for (var i=0;i<rowCount;i++){
				var record=grid.store.getAt(i);
				record.set('sysrowno',i+1);	
			}
			//插入明细记录结束
       		for (var i=1;i<=pmyForm.pagecount;i++) {
       			eval("myForm"+i+".getForm().reset();");
       			eval(mySetFormReadOnly('myForm'+i,'false'));
       		}	
       		Ext.getCmp(pmyGrid1.keyfield).setReadOnly(false);
			mySetCmpDisabled('cmdsave;popsave;btnsave;',false);	
			mySetCmpDisabled('cmdupdate;popupdate;cmddelete;popdelete;cmdreview;popreview',true);
			myContextMenu3.setDisabled(false);
			fnSetItemGridEditable(true);
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
			if (pmyForm.modal!='window') fnSetBtn(2);  //选择客户详情状态
			else{
				myEditWin.setTitle('新增'+pmyGrid1.tabletitle);
				myEditWin.show();
			}
			myFormTab.setActiveTab(0);
	    	myFocusInTab(myFormTab);  //聚焦第一个非只读控件       		
		}
		
		function fnEditRecord(){   //eeeeeeeee
			Ext.getCmp('addoredit').setValue('2');
			mySetCmpDisabled('cmdsave;popsave;btnsave',false);
			myContextMenu3.setDisabled(false);
			fnSetItemGridEditable(true);
       		for (var i=1;i<=pmyForm.pagecount;i++) {
       			eval(mySetFormReadOnly('myForm'+i,'false'));
       		}	
       		Ext.getCmp(pmyGrid1.keyfield).setReadOnly(true);
			mySetCmpDisabled('cmdupdate;popupdate;cmddelete;popdelete;cmdsave;popsave;btnsave',false);
			mySetCmpDisabled('cmdreview;popreview',true);
			//mySetCmpDisabled('filepathcmdup;filepathicon',false);
			mySetCmpDisabled(pmyForm.fileloadbutton,false);
			if (pmyForm.modal!='window') fnSetBtn(2);  //选择客户详情状态
			else{
				myEditWin.setTitle('修改'+pmyGrid1.tabletitle);
				myEditWin.show();
			}
	    	//myFormTab.setActiveTab(0);
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
			if (pmyForm.modal!='window') fnSetBtn(2);  //选择客户详情状态
			else{
				myEditWin.setTitle('审核'+pmyGrid1.tabletitle);
				myEditWin.show();
			}
		}
		
		function uploadfile(){ //上传附件
			var records=myGrid1.getSelectionModel().getSelection();//获取gird所有选中的records
			if(records[0]){	//获取第一个record对象
			}					
		}
		//保存记录
		function fnSaveRecord(){   //ssssss
			/*
			var rs1=myItemGrid1.store.getUpdatedRecords();
			var rs2=myItemGrid1.store.getNewRecords();
			var rs3=myItemGrid1.store.getRemovedRecords();
			*/
			var xid=Ext.getCmp(pmyGrid1.keyfield).getValue();
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
			eval(myFormReplaceValidation(pmyGrid1,p.grid[0].replace,p.grid[0].validation));
			eval(myFormReplaceValidation(pmyGrid1,p.replace,p.validation));
			eval(myFormReplaceValidation(pmyGrid1,p.form[0].replace,p.form[0].validation));
			pmyTable.msg='';  //提示信息
       		var updatesql='';
       		var querysql='';
			var sqlx='';
			if (xaddoredit=='3'){ //保存审核结果
				updatesql="update "+pmyGrid1.tablename+" set "+pmyTable.document.reviewflag+"='"+Ext.getCmp(pmyTable.document.reviewflag).getValue()+"' where "+pmyGrid1.keyfield+"='"+xid+"' ";
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
				//将表中可编辑字段赋值到pmyForm.editablefieldset中
       			pmyForm.editablefieldset=myGetTableEditableFields(sysdatabasestring,pmyGrid1.tablename);
				//后台验证主码值是否重复
				var kflag=(pmyForm.editablefieldset+';').indexOf(':'+pmyGrid1.keyfield+';');
				if (xaddoredit=='1' && kflag>=0) pmyTable.error+=myPKUniqueCheck(pmyGrid1);
				//前台明细表数据和替换replace & validation
				var detailsql='';
	        	for (var j=1;j<=pItemGridCount;j++){
					var pgrid=eval("pmyItemGrid"+j);
					var grid=eval("myItemGrid"+j);
					if (pgrid.style=='editable'){ 
		       			var table=pgrid.tablename; 
		       			var kfield=pgrid.keyfield;
		       			var mfield=pgrid.masterfield;
		       			var mvalue=Ext.getCmp(mfield).getValue();
						var result=myGridReplaceValidationSql(sysdatabasestring,grid,table,p.detailgrid[j-1].replace,p.detailgrid[j-1].validation);	        			
	        			var tmp=result.split(sys.tab);
	        			if (tmp[0]!=''){
		       				pmyTable.error+="<br>["+pgrid.bartitle+"]错误信息：";
	        				pmyTable.error+=tmp[0];
	        			}
	        			if (pgrid.sys_keyvalues!=''){
							detailsql+=" delete "+table+" where "+mfield+"='"+mvalue+"' and "+kfield+" in ("+pgrid.sys_keyvalues+")";
							//console.log(detailsql);
						}
						detailsql+=' '+tmp[1];
		        	}
		        }  //for j
				//数据验证错误判断
				if (pmyTable.error!=''){
					eval(sysError('发现下列错误，记录保存失败！<br>'+pmyTable.error,0,0));
					myFocusInTab(myFormTab);  //聚焦第一个非只读控件
					return;
				}else{ 	//数据库操作语句	
					//将控件值赋值到pmyForm.editablefieldtext中
	   	   			eval(myGetFormValues(pmyForm));
					if (pmyTree1.keyfield!=''){
	       				querysql+=" and "+pmyTree1.keyfield+"='"+nodetext+"'";
	       			}
					if (xaddoredit=='1'){  //新增记录
						//根据表单值和可编辑字段，生成insert语句新增记录
		        		sqlx="if (select count(*) from "+pmyGrid1.tablename+" where "+pmyGrid1.keyfield+"='"+xid+"')=0";
	        			sqlx+=" begin\n"
		        		updatesql=sqlx+" \n"+myGenInsertSql(pmyGrid1.tablename,pmyForm.editablefieldset,pmyForm.fieldtext);
		        		updatesql+='\n '+detailsql;
	        			updatesql+="\n end \n";
		    	    }else{  //修改记录
						//根据表单值和可编辑字段，生成update语句
		        		if (pmyTable.document.reviewflag!=''){
			        		sqlx="if (select count(*) from "+pmyGrid1.tablename+" where "+pmyGrid1.keyfield+"='"+xid+"' ";
							sqlx+=" and ("+pmyTable.document.reviewflag+"='' or "+pmyTable.document.reviewflag+" is null))>0 \n";        	
		        			sqlx+=" begin\n"
	        			} 
						updatesql=sqlx+" \n"+myGenUpdateSql(pmyGrid1.tablename,pmyForm.editablefieldset,pmyForm.fieldtext,pmyGrid1.keyfield,xid);
		        		updatesql+='\n '+detailsql;
		        		if (pmyTable.document.reviewflag!=''){
		        			updatesql+="\n end \n";
		        		}
	        		}
	        	}  //error!=''
	        }  //if addoredit	
			//保存记录后求记录的行号，用于grid页面定位行号
			var querysql="select rowno=count(*)+1 from ("+pmyGrid1.paramsql+") as p where "+pmyGrid1.keyfield+"<'"+xid+"'";
       		//后台保存未审核凭证是否成功，避免多用户时冲突（一个人已审核，另一个人去保存）
			if (pmyTable.document.reviewflag!=''){
	        	querysql+=sys.sqltab+" select top 1 "+pmyTable.document.reviewflag+" as 'reviewflag' from "+pmyGrid1.tablename+" where "+pmyGrid1.keyfield+"='"+xid+"' ";
				querysql+=" and ("+pmyTable.document.reviewflag+"<>'' and "+pmyTable.document.reviewflag+" is not null) \n";
			}else{
	        	querysql+=sys.sqltab+" select reviewflag=''";
			}        	
        	//console.log(pmyForm.fieldtext);
			//console.log(detailsql);
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
						pmyTable.error+="<br>"+pmyGrid1.tabletitle+"<b>["+xid+"]</b>已由<b>"+reviewflag+"</b>审核，无法修改！";
					}
					if (pmyTable.error==''){
						//记录保存成功，重新加载myGrid1
						var xwheresql='';
	       				if (Ext.getCmp(pmyTree1.keyfield)!=null){
							if (nodetext!='' && pmyTree1.keyfield!=''){
		         				xwheresql=pmyTree1.keyfield+"='"+nodetext+"'";
		         			}	
							var root=myTree1.getRootNode();
							var node=root.findChild('cid',nodetext,true);
							//注意日期2013-03-4 2013-3-4的区别
							if (node==null){
								pmyTree1.selectedcode=nodetext;
								pmyTree1.rootcode='';
								myTree1.store.load();
							}else{
								myTree1.getSelectionModel().select(node);
								pmyTree1.selectedCode='';
							}
						}
						if (myGrid1.store.pageSize<=0){
							var n=1;
							pmyGrid1.index=rowno;
						}else{
							var n=Math.floor((rowno-1)/myGrid1.store.pageSize)+1;
							pmyGrid1.index=rowno-(n-1)*myGrid1.store.pageSize-1;
						}
						pmyGrid1.locatevalue=''; //xid;  //按记录号定位
						pmyGrid1.pageno=n;
						fnLoadmyGrid1(n,xwheresql,'');  
						if (pmyForm.modal!='window') fnSetBtn(2);							
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
						eval(sysError('发现下列错误，'+pmyGrid1.tabletitle+'保存失败！<br>'+pmyTable.error,0,0));
	       			}	           					
       			} //calback		
			});	
		}
		
		function fnDeleteRecord(){ //删除客户 dddd
			var records=myGrid1.getSelectionModel().getSelection();
			if (!records[0]){
				Ext.Msg.alert('系统提示','请选择要删除的'+pmyGrid1.keyspec+'!');
				return;
			}else{	
				var xid=records[0].get(pmyGrid1.keyfield);
				var sql='delete '+pmyGrid1.tablename+' where '+pmyGrid1.keyfield+"='"+xid+"'";
				Ext.MessageBox.show({   
		            title: '系统提示',   
		            msg: mySpace(2)+'删除'+pmyGrid1.tabletitle+'<font color=blue><b>【'+xid+'】</b></font>这条记录。'+mySpace(10)+'<br><br>'+mySpace(2)+'是否确认？<br><br>' , 
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
					        				fnLoadmyGrid1(pageno-1,'','');					        				
					        			}else{  //全部删除的情况
						        			pmyGrid1.index=-1;
											myGrid1.store.loadPage(1);
					        			}
					        		}else{	
										pmyGrid1.index=index;
										myGrid1.store.loadPage(pageno);
									}
									if (pmyForm.modal!='window') fnSetBtn(1);	
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
			if (pmyForm.modal!='window') fnSetBtn(1);  //选中第一页面按钮
			fnLoadmyGrid1(1,'','');
		}
		
		function fnLoadmyGrid1(pageno,wheresql,flag){ //lllllo重新加载grid数据
			//清空明细表
			for (var i=1;i<=pItemGridCount;i++) {
				//需要刷新
				eval("pmyItemGrid"+i+".flag=1;");
				//eval("myItemGrid"+i+".store.removeAll(false);");
				eval(myTruncateGrid("myItemGrid"+i));				
			}	
			var tabno=1;
			var wheresqlx='';
			var myTree=eval('myTree'+tabno);
			var pmyTree=eval('pmyTree'+tabno);
			var wheresqly='';
			if (flag=='tree'){  //按照树节点取条件
				var records=myTree.getSelectionModel().getSelection();
				if (records[0]){
	           		var xid=records[0].get('cid');  //获取主码值
	           		var xlevel=records[0].get('level');  //获取主码值
	           		if (xlevel>0 && xlevel<pmyTree.groupfield.length) {
	           			var pnode=records[0];
	           			var root=myTree.store.getRootNode();
		           		for (var j=xlevel;j>=1;j--){
		           			pmyTree.keyfield=pmyTree.groupfield[j];
		           			if (wheresqly!='') wheresqly+=" and ";
		           			//处理”其他“值，其对应的sortflag=1
							if (pnode.get('sortflag')==1) wheresqly+="("+pmyTree.groupfield[j]+"='' or "+pmyTree.groupfield[j]+" is null)";
		           			else wheresqly+=pmyTree.groupfield[j]+"='"+pnode.get('cid')+"'";
		           			pnode=pnode.parentNode;	           		
		           		}
	           			//pmyTree.keyfield=pmyTree.groupfield[xlevel];
						//wheresqly=pmyTree.keyfield+"='"+xid+"'";
	           		}else{
	           			pmyTree.keyfield='';
	           		}
	           		Ext.getCmp('filtertext').setValue('');
	           	}	
	           	pmyGrid1.locatevalue='';
			}//if tree
			if (wheresql=='' && wheresqlx=='' && wheresqly==''){
				var sql=pmyGrid1.sql;					
			}else{
				if (wheresql!='') wheresql="("+wheresql+")";
				else wheresql="(1=1)";
				if (wheresqlx!='') wheresql+=" and ("+wheresqlx+")";
				if (wheresqly!='') wheresql+=" and ("+wheresqly+")";
				var sql="select * from ("+pmyGrid1.sql+") as p where "+wheresql;
			}
			pmyGrid1.paramsql=sql;	
			//console.log(sql);
			var xpagesize=myGrid1.store.pageSize;
			var newparams={ database:sysdatabasestring, sqlString:sql,keyField:pmyGrid1.keyfield,sortField:pmyGrid1.sortfield,limit:xpagesize,summaryFields:pmyGrid1.summaryFields };
			Ext.apply(myGrid1.store.proxy.extraParams,newparams);
			if (pageno>0) myGrid1.store.loadPage(pageno); 	        
			else myGrid1.store.loadPage(1);
		}

		function fnLoadItemGrid(xpageno,xflag){ //重新加载grid数据,xflag=1强制加载
			if (pItemGridCount>0){
				var records=myGrid1.getSelectionModel().getSelection();
				//var xpagesize=myItemGrid1.store.pagesize;
				if (records[0]){
					var tabno=-1;
					for(var i=0;i<myItemGridTab.items.items.length;i++){
						if(myItemGridTab.activeTab==myItemGridTab.items.items[i]){
	       					tabno=i+1; 
	       					break;
	       				}
	       			}
	       			var pmyItemGrid=eval("pmyItemGrid"+tabno);
	       			var rflag=pmyItemGrid.flag;
	       			var mflag=pmyItemGrid.style;
	       			if (mflag=='editable') mySetCmpVisible('popinsertitem;popappenditem;popdeleteitem;popsaveitem;popresetitem;savebar3;resetbar1',true);
	       			else mySetCmpVisible('popinsertitem;popappenditem;popdeleteitem;popsaveitem;popresetitem;savebar3;resetbar1',false);
	       			var tabtitle=pmyItemGrid.bartitle;
	       			Ext.getCmp('poptitleitem').setText('<b>'+tabtitle+'编辑</b>');
	       			/*
	       			Ext.getCmp('popinsertitem').setText('插入'+tabtitle);
	       			Ext.getCmp('popappenditem').setText('追加'+tabtitle);
	       			Ext.getCmp('popdeleteitem').setText('删除'+tabtitle);
	       			Ext.getCmp('popsaveitem').setText('保存'+tabtitle);
	       			Ext.getCmp('popresetitem').setText('清空'+tabtitle);
	       			Ext.getCmp('poprefreshitem').setText('刷新'+tabtitle);
	       			*/
					if (rflag==1 || xflag==1) {
						eval("pmyItemGrid"+tabno+".flag=0;");
						eval("pmyItemGrid"+tabno+".index=0;");
						eval("pmyItemGrid"+tabno+".column=pmyItemGrid"+tabno+".starteditcolumn;");
						var xid=Ext.getCmp(pmyGrid1.keyfield).getValue();
						var sql=pmyItemGrid.sql;
						sql="select * from ("+sql+") as p where "+pmyItemGrid.masterfield+"='"+xid+"'";
						var xpagesize=pmyItemGrid.pagesize;
						var xkeyfield=pmyItemGrid.keyfield;	
						var xsortfield=pmyItemGrid.sortfield;	
						//console.log(sql);
						pmyItemGrid.paramsql=sql;   //分页行数变化时用到
						var newparams={ database:sysdatabasestring, sqlString:sql,keyField:xkeyfield,sortField:xsortfield,limit:xpagesize,summaryFields:pmyItemGrid.summaryFields };
						var str="Ext.apply(myItemGrid"+tabno+".store.proxy.extraParams,newparams);";
						str=str+"if (xpageno>0) myItemGrid"+tabno+".store.loadPage(xpageno);";	        
						str=str+"else myItemGrid"+tabno+".store.loadPage(1);";	
						eval(str);
						//console.log(str);
					}
				}	
			}	
		}
				
		//快速过滤函数
		function fnQuickFilter(){
			var xfilter=Ext.getCmp('filtertext').getValue();
			var xfiltersql=myGetFilterSql(myFilterCheckMenu,xfilter);  //获取过滤条件
			//console.log(xfiltersql);
 			pmyGrid1.locatevalue='';
			if (pmyForm.modal!='window') fnSetBtn(1);
			pmyTree1.reloadflag=1;
			fnLoadmyGrid1(1,xfiltersql,null);			
		}

		function fnSetBtn(btnid) {
			if (btnid==1) {
 				Ext.getCmp('mybtn1').toggle(true);
 				Ext.getCmp('mybtn2').toggle(false);
            	var panel=Ext.getCmp('myActivePanel');
            	var id=panel.items.items[0].id;
            	if(id!='myGridPanel'){
            		myDetailPanel.setVisible(false);
					myGridPanel.setVisible(true);       	
	            	panel.remove(myDetailPanel,false);
	                panel.add(myGridPanel);
	                panel.doLayout();
            	}
        	}else{
 				Ext.getCmp('mybtn2').toggle(true);
 				Ext.getCmp('mybtn1').toggle(false);
            	var panel=Ext.getCmp('myActivePanel');
            	var id=panel.items.items[0].id;
            	if(id!='myDetailPanel'){
					myDetailPanel.setVisible(true);
					myGridPanel.setVisible(false);       	
	            	panel.remove(myGridPanel,false);
	                panel.add(myDetailPanel);
	                panel.doLayout();
            	}
        	}		
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
				for (var i=1;i<=pItemGridCount;i++) {
					eval("pmyItemGrid"+i+".flag=1;");  //需要刷新
				}
				fnLoadItemGrid(0,0);//加载grid记录
			}else{  //找不到grid中记录时，清空从表记录和表单
				for (var i=1;i<=pmyForm.pagecount;i++) {
					eval("myForm"+i+".getForm().reset();");
	           	}
				for (var i=1;i<=pItemGridCount;i++) {
					eval("pmyItemGrid"+i+".flag=1;");
					//eval("myItemGrid"+i+".store.removeAll(true);");
					eval(myTruncateGrid("myItemGrid"+i));			
				}           	
			}
			myContextMenu3.setDisabled(true);
			fnSetItemGridEditable(false);
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
		
		function fnmyGroupMenuxClick(item,e){
			fnmyGroupMenuClick(item,e);
		}
		function fnmyGroupMenuClick(item,e){
			var tabno=1;
			var pmyTree=eval('pmyTree'+tabno);
			var myTree=eval('myTree'+tabno);
			if (item.keyField!='') {
				pmyTree.groupid=item.keyField;  //自定义属性
			}else{	
				pmyTree.groupid=item.textField;  //自定义属性
			}
			pmyTree.grouptext=item.text;
			fnLoadmyTree(myTree);
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
				myTree1.collapse(Ext.Component.DIRECTION_LEFT);					
			}else{
				myTree1.expand(Ext.Component.DIRECTION_LEFT);
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
		/*
		myTreeTab.on('tabchange',function(tabPanel,newCard,oldCard,eOpts ){
			var tabno=myGetActiveTabIndex(myTreeTab);
			var myTree=eval("myTree"+tabno);
			var pmyTree=eval("pmyTree"+tabno);
			if (pmyTree.reloadflag==1){
				pmyTree.reloadflag=0;
				if (pmyTree.groupfield=='' && tabno==2){
					pmyTree.groupid=pmyTree1.groupid;
					pmyTree.grouptext=pmyTree1.grouptext
				}
				fnLoadmyTree(myTree);	
			}
			var pageno=pmyTree.pageno;
			pmyGrid1.index=pmyTree.index;
			fnLoadmyGrid1(pageno,'','tree');		
		});
		*/
		
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
		
		function fnInsertItemRecord(btn){
			var tabno=myGetActiveTabIndex(myItemGridTab);
			var pgrid=eval("pmyItemGrid"+tabno);
			var mfield=pgrid.masterfield;
			var mvalue=Ext.getCmp(mfield).getValue();
			eval("pmyItemGrid"+tabno+".addoredit=1;");
			var fields=myItemGrid1.store.model.getFields();  //获取store全部列
			var str='"sysrowno":"0","'+mfield+'":"'+mvalue+'"';
			for (var j=0;j<fields.length;j++){
				if (fields[j].name!='sysrowno' && fields[j].name!=mfield){
					str+=",\""+fields[j].name+"\":''";
				}
			}
			var data=eval("[{"+str+"}];");
			if (btn.id=='popappenditem'){
				var row=eval("myItemGrid"+tabno+".store.getCount();");
 				eval("pmyItemGrid"+tabno+".index=row;");
			}else{
				var row=eval("pmyItemGrid"+tabno+".index;");
			}
			if (row>=0){
	 			eval("myItemGrid"+tabno+".store.insert(row,data);");
	 			//eval("pmyItemGrid"+tabno+".index=row;");
	 			//新插入记录后，选中该记录，指针聚焦当前新记录
				eval("myItemGrid"+tabno+".getSelectionModel().select(row);");
				eval("myItemGrid"+tabno+"CellEditing.startEdit(row, pmyItemGrid"+tabno+".starteditcolumn);");  //ext4.2方法
				var rowCount=eval("myItemGrid"+tabno+".store.getCount();");				
				for (var i=0;i<rowCount;i++){
					var record=eval("myItemGrid"+tabno+".store.getAt(i);");
					record.set('sysrowno',i+1);	
				}
			}
		}
		
		function fnDeleteItemRecord(btn){
			var tabno=myGetActiveTabIndex(myItemGridTab);
			var rowCount=eval("myItemGrid"+tabno+".store.getCount();");
			var rowno=eval("pmyItemGrid"+tabno+".index;");
			if (rowCount>0 && rowno<rowCount){
				var record=eval("myItemGrid"+tabno+".store.getAt(rowno);");
				eval("myItemGrid"+tabno+".store.remove(record);");
	  		}
	  		var rowCount=eval("myItemGrid"+tabno+".store.getCount();");				
			for (var i=0;i<rowCount;i++){
				var record=eval("myItemGrid"+tabno+".store.getAt(i);");
				record.set('sysrowno',i+1);	
			}	  		
		}

		function fnSaveItemRecord(j){
       		//保存明细表
       		var result='';
			var pgrid=eval("pmyItemGrid"+j);
       		var grid=eval("myItemGrid"+j);
       		var style=pgrid.style; 
       		var table=pgrid.tablename; 
       		var kfield=pgrid.keyfield;
       		var mfield=pgrid.masterfield;
       		var mvalue=Ext.getCmp(mfield).getValue();
       		if (style!=undefined && style=='editable' && table!=undefined && table!=''){
	       		grid.keyfield=kfield;
	       		grid.masterfield=mfield;
	       		grid.mastervalue=mvalue;
				result=myGridReplaceValidationSql(sysdatabasestring,grid,table,p.detailgrid[j-1].replace,p.detailgrid[j-1].validation);
    	       //	console.log('griderror='+result);
       		}
       		/*
			Ext.Ajax.request({   //ssss
				url: 'system//fn_executeSql.jsp',
				method: 'post',async:false,
    			params:{ database:sysdatabasestring, updateSql:sql,selectSql:'' },									
				waitTitle : '系统提示',
				waitMsg: '正在保存数据,请稍候...',
				callback:function(options,success,response){
					eval("pmyItemGrid"+j+".index=0;");
					var rowno=Ext.decode(response.responseText).rowno;
					eval(sysWait('明细表记录已经保存成功！',160,100,600));           					
       			}		
			});
			*/
			return result;	
		}

		function fnResetItemRecord(){  //清空明细表
			var j=myGetActiveTabIndex(myItemGridTab);
			eval(myTruncateGrid("myItemGrid"+j));
		}
		
		function fnRefreshItemRecord(){
			fnLoadItemGrid(0,1);
		}
		
		function fnSetItemGridEditable(flag){
			for (var i=1;i<=pItemGridCount;i++){
				var grid=Ext.getCmp("myItemGrid"+i);
				if (flag){
					for (var j=0;j<grid.columns.length;j++){
						grid.columns[j].editable=grid.columns[j].xeditable;
					}
				}else{
					for (var j=0;j<grid.columns.length;j++){
						grid.columns[j].editable=false;
					}
				}
			}	
		}
		
		function fnMoveRecord(id){
			if (id=='xrowfirst') myMoveRecord('rowfirst',pmyGrid1);
			else if (id=='xrowlast') myMoveRecord('rowlast',pmyGrid1);
			else if (id=='xrownext') myMoveRecord('rownext',pmyGrid1);
			else if (id=='xrowprev') myMoveRecord('rowprev',pmyGrid1);
		}		

		//初始化ccccc
		if (Ext.getCmp(pmyTable.document.datefield)!=null && Ext.getCmp(pmyTable.document.datefield).getXType()=='datefield' && Ext.getCmp(pmyTable.document.datefield).xreadonly=='false') {
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
		//fnmyGroupMenuxClick(myGroupMenu[0],null);  //加载树		
		myTree1.collapse();
		fnLoadmyGrid1(1,'','');
		pmyTree1.reloadflag=0;
		for (var i=1;i<=pmyForm.pagecount;i++) {
			eval(mySetFormReadOnly('myForm'+i,'true'));
		}
		if (pmyForm.modal!='window') fnSetBtn(1);  //选中第一页面按钮
		
	//****************************end of extjs**************************//
			
	}); 
  
  </script>
  </body>
</html>


