<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="com.DBConn" %>
<%@ page import="com.UserBean" %>
<%@ page import="com.StringUtil"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>TGridFormDetail模板</title>
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
        //console.log(myConvertExpression('a=qty*unitprice*(1-discount)*100.0+max(10*x1,x2/3-x)',''));
        //console.log(myConvertExpression("zip+' '+code+str(asc('x'+x3+2),10,2)+address1",''));
        /*
		//记录各个字段的宽度pmyWidth={}变量在fn_function中定义;
		//格式：表名1:列名11,列名12,列名13;表名2:列名21,列名22,列名23;
		pmyWidth.tmp1="customers:customerid";
		pmyWidth.tmp1+=";contacts:contactid,contactname";
		pmyWidth.tmp1+=";employees:employeename";
		eval(myGetColWidthFromTable(sysdatabasestring,pmyWidth.tmp1));
		pmyWidth.creator=pmyWidth.employeename;
		pmyWidth.reviewer=pmyWidth.employeename;
		pmyWidth.tmp2=syschrtab+"select max(datalength(cast(rtrim(description) as varchar(500)))) as title from dictionary where type='职务'";				
		pmyWidth.tmp2+=syschrtab+"select max(datalength(cast(rtrim(areaname) as varchar(500)))) as province from areas where level=1";				
		pmyWidth.tmp2+=syschrtab+"select max(datalength(cast(rtrim(areaname) as varchar(500)))) as city from areas where level=2";				
		eval(myGetColWidthFromSql(sysdatabasestring,pmyWidth.tmp2,'title;province;city'));
		if (pmyWidth.customerid=0) pmyWidth.customerid=100;
		*/
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
		if (p.group!=undefined) pmyTree1=myGetTreeAttrs(p.group[0],pmyTree1);
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
		if (pmyGrid1.sql=='' && pmyGrid1.tablename!='')	pmyGrid1.sql="select * from "+pmyGrid1.tablename;
		if (pmyForm.rowheight!=undefined && pmyForm.rowheight!='') var rowHeight=pmyForm.rowheight;
		else var rowHeight=32;
  		pmyTable.permission=';'+myGetOneAttr(p.service,'permissions')+';';
		//grid初始设置
		pmyGrid1.index=-1;  //聚焦的行号
		pmyGrid1.column=-1;
		//pmyGrid1.bbar='';
		//pmyGrid1.tbar='';
		pmyGrid1.varname='pmyGrid1';
		pmyGrid1.name='myGrid1';
		pmyGrid1.region='center';
		pmyGrid1.locatekeyvalue='';
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
			var pgrid=eval("pmyItemGrid"+k);
			eval(myDefineGrid(eval("pmyItemGrid"+k)));
		}
		pmyTree1.height=0;
		if (pmyTree1.width==0) pmyTree1.width=200;
		pmyTree1.roottitle='全部'+pmyTable.tabletitle;
		if (pmyTree1.fields!=undefined && pmyTree1.fields!=''){
			pmyTree1.groupfields=pmyTree1.fields+";-;*/取消分组";
		}else{
			pmyTree1.groupfields='';
		}
		pmyTree1.region='west';
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
		//pmyTree1.tbar='';//treetbar
		//pmyTree1.bbar='';
		//pmyTree1.fields='cid;text;nodetext;level;sysnumber;parentnodeid';
		pmyTree1.fields='';  //否则按表格显示
		pmyTree1.name='myTree1';		
		pmyTree1.varname='pmyTree1';		
		pmyTree1.groupid='';
		pmyTree1.grouptext='';
		pmyTree1.groupfield=[];	
		//生成编译得到的控件和事件		
		eval(pmyForm.tabstr); //定义表单myForm*
		eval(pmyForm.groupboxstr); //定义表单中的groupbox控件
		eval(pmyForm.fieldstr); //定义表单ffffff中的其他控件textfield,combo,datefield
		//将没有定义的列定义到myForm1
		eval(myAddHiddenFields(pmyGrid1.fieldset,'myForm1'));
		eval(myAddHiddenFields(pmyForm.hiddenfields,'myForm1'));
		eval(myDefineHiddenField('myForm1','addoredit'));
		eval(pmyForm.eventstr); //定义事件在hidden字段之后
		eval(myMoveRecordByBtn(pmyGrid1));  //定义记录移动函数fnMoveRecord(e)
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
		tbar.add({id:'cmdadd', iconCls: 'addIcon',text: '新增',handler: fnAddRecord,tooltip: '增加一条新记录',xaction:'add'});
		tbar.add({id:'cmdupdate', iconCls: 'editIcon',text: '修改',handler: fnEditRecord,tooltip: '修改当前选中的记录',xaction:'update'});
		tbar.add({id:'cmddelete', iconCls: 'deleteIcon',text: '删除',handler: fnDeleteRecord,tooltip: '删除当前选中的记录',xaction:'delete'});
		tbar.add({id:'reviewbar1', xtype:'tbseparator'});
		tbar.add({id:'cmdreview', iconCls: 'checkIcon',text: '审核',handler: fnReviewRecord,tooltip: '审核当前记录',xaction:'review'});
		tbar.add({id:'editbar1', xtype:'tbseparator'});
		tbar.add({id:'cmdsave', iconCls: 'saveIcon',text: '保存',handler: fnSaveRecord,tooltip: '保存正在修改或新增的记录',xaction:'save'});
		tbar.add({id:'savebar1', xtype:'tbseparator'});
		tbar.add({id:'cmdprint', iconCls: 'printerIcon',text: '打印',handler: fnPrintRecord,tooltip: '打印'+pmyTable.tabletitle+'列表',xaction:'print'});
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
				{id:'xrowfirst',iconCls: 'rowfirstIcon',text:'',width:22, handler: function(e) { fnMoveRecordx(e.id); },tooltip: '第一行'},
				{id:'xrowprev',iconCls: 'rowprevIcon',text:'',width:24, handler: function(e) { fnMoveRecordx(e.id); },tooltip: '上一行'},
				{id:'xrownext',iconCls: 'rownextIcon',text:'',width:24, handler: function(e) { fnMoveRecordx(e.id); },tooltip: '下一行'},
				{id:'xrowlast',iconCls: 'rowlastIcon',text:'',width:24, handler: function(e) { fnMoveRecordx(e.id); },tooltip: '最后行'}
			]
		});				
	    eval(myDefineTree(pmyTree1));
		var root=myTree1.setRootNode({
			text:pmyTree1.roottitle,
			iconCls: 'folderopenIcon',
            cid:'',
            level:0,
            expanded:false,                
            leaf:true                
		}); //修改根节点的值
		myTree1.collapsed=true;
		if (pmyTree1.groupfields!=undefined && pmyTree1.groupfields==''){
			myTree1.setVisible(false);
			mySetCmpVisible('cmdgroup;groupbar1',false);
		}       
		/**************************定义myGrid结束**********************************/
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
		pmyTable.editflag=0;
		if ((pmyTable.permission).indexOf(';add;')<0){
			mySetCmpVisible('cmdadd;popadd',false);
		}else pmyTable.editflag++;
		if (pmyTable.permission.indexOf(';update;')<0){
			mySetCmpVisible('cmdupdate;popupdate',false);
		}else pmyTable.editflag+=2;
		if (pmyTable.permission.indexOf(';review;')<0){
			mySetCmpVisible('cmdreview;popreview;reviewbar1;reviewbar2',false);
		}else pmyTable.editflag+=4;

		if (pmyTable.permission.indexOf(';delete;')<0){
			mySetCmpVisible('cmddelete;popdelete',false);
		}
		if (pmyTable.permission.indexOf(';print;')<0){
			mySetCmpVisible('cmdprint;popprint;printbar1;printbar2',false);
		}
		if (pmyTable.permission.indexOf(';filter;')<0){
			mySetCmpVisible('cmdfilter;filterbar1;filterbar2;filterbar3;filtertext;columnchoose',false);
		}
		if (pmyTable.editflag<=0){  //查询状态
			mySetCmpVisible('cmdbar;cmdsave;popsave;savebar1;savebar2;btnsave',false);
			if (Ext.getCmp('btnclose')!=null) Ext.getCmp('btnclose').setText('关闭');		
		}	
		//初始化ccccc
		fnLoadmyGrid1(1,'');
		for (var i=1;i<=pmyForm.pagecount;i++) {
			eval(mySetFormReadOnly('myForm'+i,'true'));
		}
		if (pmyForm.modal!='window') fnSetBtn(1);  //选中第一页面按钮
		//myTree1事件
		myTree1.on('beforeload',function(store) {
			var newparams={ database:sysdatabasestring, maxReturnNumber:maxReturnNumber,sqlString:pmyTree1.sql,keyField:'nodeid',sortField:pmyTree1.sortfield,rootCode:pmyTree1.rootcode,selectedCode:pmyTree1.selectedcode};
			Ext.apply(store.proxy.extraParams,newparams);
			store.proxy.url='system//fn_getTreeNodes.jsp';					
		});				
		myTree1.on('load',function(){
	    	var root=myTree1.getRootNode();
	    	root.set('text',pmyTree1.grouptext+'（'+root.childNodes.length+'组）');
	    	root.expand();
		});
		myTree1.on('selectionchange',function(model, records) {//监听树选中时间
           	if (records[0]) {//判断是否有节点选中，必须要加
           		var xid=records[0].get('cid');  //获取主码值
           		var xlevel=records[0].get('level');  //获取主码值
           		var xparentnodeid=records[0].get('parentnodeid');  //获取主码值
           		var xsql='';
           		if (xlevel>0 && xlevel<pmyTree1.groupfield.length) {
           			pmyTree1.keyfield=pmyTree1.groupfield[xlevel];
           			if (xlevel<2){
						xsql=pmyTree1.keyfield+"='"+xid+"'";
					}else{
						xsql=pmyTree1.groupfield[1]+"='"+xparentnodeid+"'";
						xsql+=" and "+pmyTree1.groupfield[2]+"='"+xid+"'";
					}
           		}else{
           			pmyTree1.keyfield='';
           		}
           		Ext.getCmp('filtertext').setValue('');
           		pmyGrid1.pageno=1;
           		pmyGrid1.locatevalue='';
           		pmyGrid1.index=0;
           		if (pmyForm.modal!='window') fnSetBtn(1);
           		fnLoadmyGrid1(1,xsql);
      	 	}
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
		
		myGrid1.on('selectionchange',function(model,records) {  //schange
			Ext.getCmp('rowfirst').setDisabled(false);
			Ext.getCmp('rowprev').setDisabled(false);
			Ext.getCmp('rowlast').setDisabled(false);
			Ext.getCmp('rownext').setDisabled(false);
			if (records[0]){			
				if (records[0].get('sysrowno')==1){
					Ext.getCmp('xrowfirst').setDisabled(true);
					Ext.getCmp('xrowprev').setDisabled(true);
				}else if(records[0].get('sysrowno')==myGrid1.store.getTotalCount()){
					Ext.getCmp('xrowlast').setDisabled(true);
					Ext.getCmp('xrownext').setDisabled(true);
				}
				fnLoadRecord();
			}			
			//调用函数,控制记录移动指针的disabled状态
			eval(mySetRecordMoveBtn('myGrid1','records[0]'));
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
			var date=querydate.year+'年'+querydate.month+'月'+querydate.day+'日';
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
			for (var i=1;i<=pItemGridCount;i++) {
				//需要刷新
				eval("pmyItemGrid"+i+".flag=1;");
				//eval("myItemGrid"+i+".store.removeAll(false);");
				eval(myTruncateGrid("myItemGrid"+i));				
				
			}
       		for (var i=1;i<=pmyForm.pagecount;i++) {
       			eval("myForm"+i+".getForm().reset();");
       			eval(mySetFormReadOnly('myForm'+i,'false'));
       		}	
			Ext.getCmp('addoredit').setValue('1');
       		Ext.getCmp(pmyTable.keyfield).setReadOnly(false);
			mySetCmpDisabled('cmdsave;popsave;btnsave;',false);	
			mySetCmpDisabled('cmdupdate;popupdate;cmddelete;popdelete;cmdreview;popreview',true);
			myContextMenu3.setDisabled(false);
			fnSetItemGridEditable(true);
			mySetCmpDisabled(pmyForm.fileloadbutton,true);
			//mySetCmpDisabled('filepathcmdup;filepathicon',true);
			if (pmyForm.modal!='window') fnSetBtn(2);  //选择客户详情状态
			else{
				myEditWin.setTitle('新增'+pmyTable.tabletitle);
				myEditWin.show();
			}
			myFormTab.setActiveTab(0);
	    	myFocusInTab(myFormTab);  //聚焦第一个非只读控件       		
		}
		
		function fnEditRecord(){   //eeeeee修改记录
			mySetCmpDisabled('cmdsave;popsave;btnsave',false);
			myContextMenu3.setDisabled(false);
			fnSetItemGridEditable(true);
       		for (var i=1;i<=pmyForm.pagecount;i++) {
       			eval(mySetFormReadOnly('myForm'+i,'false'));
       		}	
       		Ext.getCmp(pmyTable.keyfield).setReadOnly(true);
			mySetCmpDisabled('cmdupdate;popupdate;cmddelete;popdelete;cmdreview;popreview;cmdsave;popsave;btnsave',false);
			//mySetCmpDisabled('filepathcmdup;filepathicon',false);
			mySetCmpDisabled(pmyForm.fileloadbutton,false);
			if (pmyForm.modal!='window') fnSetBtn(2);  //选择客户详情状态
			else{
				myEditWin.setTitle('修改'+pmyTable.tabletitle);
				myEditWin.show();
			}
	    	//myFormTab.setActiveTab(0);
	    	myFocusInTab(myFormTab);  //聚焦第一个非只读控件       		
		}
		
		function fnReviewRecord(){   //rrrrrr审核记录	
			mySetCmpDisabled('cmdsave;popsave;btnsave',false);
			myContextMenu3.setDisabled(false);
			fnSetItemGridEditable(false);
       		for (var i=1;i<=pmyForm.pagecount;i++) {
       			eval(mySetFormReadOnly('myForm'+i,'true'));
       		}
			var records=myGrid1.getSelectionModel().getSelection();
			if (records[0].get(pmyTable.reviewfield)==''){
				records[0].set(pmyTable.reviewfield,sysusername);
				if (Ext.getCmp(pmyTable.reviewfield)!=null){
					Ext.getCmp(pmyTable.reviewfield).setValue(sysusername);
				}
				mySetCmpDisabled('cmdupdate;popupdate;cmddelete;popdelete;cmdsave;popsave;btnsave',true);
				mySetCmpDisabled(pmyForm.fileloadbutton,true);				
			}else{
				records[0].set(pmyTable.reviewfield,'');
				if (Ext.getCmp(pmyTable.reviewfield)!=null){
					Ext.getCmp(pmyTable.reviewfield).setValue('');
				}
				mySetCmpDisabled('cmdupdate;popupdate;cmddelete;popdelete;cmdreview;popreview;cmdsave;popsave;btnsave',false);
				//mySetCmpDisabled('filepathcmdup;filepathicon',false);
				mySetCmpDisabled(pmyForm.fileloadbutton,false);
			}	
			//mySetCmpDisabled('filepathcmdup;filepathicon',false);
			if (pmyForm.modal!='window') fnSetBtn(2);  //选择客户详情状态
			else{
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
		function fnSaveRecord(){   //ssssss
			/*
			var rs1=myItemGrid1.store.getUpdatedRecords();
			var rs2=myItemGrid1.store.getNewRecords();
			var rs3=myItemGrid1.store.getRemovedRecords();
			*/
			var xid=Ext.getCmp(pmyTable.keyfield).getValue();
			var xaddoredit=Ext.getCmp('addoredit').getValue();
			var nodetext='';
			if (Ext.getCmp(pmyTree1.keyfield)!=null){
				nodetext=Ext.getCmp(pmyTree1.keyfield).getValue();
				xtype=Ext.getCmp(pmyTree1.keyfield).getXType().toLowerCase();
				if (xtype=='datefield'){
					nodetext=Ext.util.Format.date(nodetext,sysfulldateformat);
					if (nodetext=='' || nodetext=='1900-01-01') nodetext='null';
				}
			}
			//Ext.getCmp('filename').setValue(Ext.getCmp('filepathsource').getValue());
			/*	
			if (xaddoredit=='1'){
				Ext.getCmp('createdate').setValue(sysdate);
				Ext.getCmp('creator').setValue(sysusername);
			}else if (xaddoredit=='2'){
				Ext.getCmp('updatedate').setValue(sysdate);
				Ext.getCmp('operator').setValue(sysusername);
			}
			*/
			//数据保存前系统变量赋值,返回字符串命令
			eval(mySetSysVars());
			//前台主表验证数据和替换replace & validation
			pmyTable.error='';
			eval(myFormReplaceValidation(pmyTable,p.replace,p.validation));
			pmyTable.keyvalue=xid;
			//后台验证主键是否重复
			if (xaddoredit=='1') pmyTable.error+=myPKUniqueCheck(pmyTable);
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
					var result=myGridReplaceValidation(sysdatabasestring,grid,table,p.detailgrid[j-1].replace,p.detailgrid[j-1].validation);	        			
        			var tmp=result.split(sys.tab);
        			if (tmp[0]!=''){
	       				pmyTable.error+="<br>["+pgrid.title+"]错误信息：";
        				pmyTable.error+=tmp[0];
        			}
        			if (pgrid.sys_keyvalues!=''){
						detailsql+=" delete "+table+" where "+mfield+"='"+mvalue+"' and "+kfield+" in ("+pgrid.sys_keyvalues+")";
						//console.log(detailsql);
					}
					detailsql+=' '+tmp[1];
	        	}
	        }	
			//数据验证错误判断
			if (pmyTable.error!=''){
				eval(sysError('发现下列错误，记录保存失败！<br>'+pmyTable.error,0,0));
				myFocusInTab(myFormTab);  //聚焦第一个非只读控件
				return;
			}else{ 	//数据库操作语句	
        		var updatesql='';
        		var querysql='';
				//将控件值赋值到pmyForm.editablefieldtext中
       			eval(myGetFormValues(pmyForm));
       			//将表中可编辑字段赋值到pmyForm.editablefieldset中
       			pmyForm.editablefieldset=myGetTableEditableFields(sysdatabasestring,pmyTable.tablename);
				if (xaddoredit=='1'){
					//根据表单值和可编辑字段，生成insert语句
	        		updatesql=myGenInsertSql(pmyTable.tablename,pmyForm.editablefieldset,pmyForm.fieldtext);
	    	    }else{
					//根据表单值和可编辑字段，生成update语句
					updatesql=myGenUpdateSql(pmyTable.tablename,pmyForm.editablefieldset,pmyForm.fieldtext,pmyTable.keyfield,xid);        		
        		}
        		//console.log(pmyForm.fieldtext);
				//console.log(detailsql);
        		//保存明细表
        		updatesql+='\n '+detailsql;
				//求记录的行号，用于grid页面定位行号
       			//var querysql="select rowno=count(*)+1 from "+pmyTable.tablename+" where "+pmyTable.keyfield+"<'"+xid+"'";
				var querysql="select rowno=count(*)+1 from ("+pmyGrid1.paramsql+") as p where "+pmyTable.keyfield+"<'"+xid+"'";
				if (pmyTree1.keyfield!=''){
       				querysql+=" and "+pmyTree1.keyfield+"='"+nodetext+"'";
       			}
       			var xbtn='yes';
       			/*
				if (pmyTable.error!=''){
					Ext.MessageBox.show({   
			            title: '系统提示',   
			            msg: pmyTable.error+"<br>"+mySpace(2)+'发现明细表数据验证错误'+mySpace(10)+'<br><br>'+mySpace(2)+'是否继续保存数据？<br><br>', 
	 		            icon: Ext.MessageBox.QUESTION,  //icon: Ext.MessageBox.INFO  
			            buttons: Ext.Msg.YESNO,
			            fn: function(btn){
			            	xbtn=btn;
			            }
					});       			
        		}
        		*/
				if (xbtn=='yes'){       			
					Ext.Ajax.request({   //ssss
						url: 'system//fn_executeSql.jsp',
						method: 'post',async:false,
	     				params:{ database:sysdatabasestring, updateSql:updatesql,selectSql:querysql },									
						waitTitle : '系统提示',
						waitMsg: '正在保存数据,请稍候...',
						callback:function(options,success,response){
							var rowno=Ext.decode(response.responseText).rowno;
							//记录保存成功，重新加载myGrid1
							//pmyGrid1.locatevalue=xid;  //定位时使用
							var xwheresql='';
	       					if (Ext.getCmp(pmyTree1.keyfield)!=null){
								if (nodetext!='' && pmyTree1.keyfield!=''){
		          					xwheresql=pmyTree1.keyfield+"='"+nodetext+"'";
		          				}	
								var root=myTree1.getRootNode();
								var node=root.findChild('cid',nodetext,true);
								if (node==null){
									pmyTree1.selectedcode=nodetext;
									pmyTree1.rootcode='';
									myTree1.store.load();
								}else{
									myTree1.getSelectionModel().select(node);
									pmyTree1.selectedCode='';
								}
							}								
							var n=Math.floor((rowno-1)/myGrid1.store.pageSize)+1;
							pmyGrid1.locatevalue=''; //xid;  //按记录号定位
							pmyGrid1.index=rowno-(n-1)*myGrid1.store.pageSize-1;
							pmyGrid1.pageno=n;
							fnLoadmyGrid1(n,xwheresql);  
							if (pmyForm.modal!='window') fnSetBtn(2);							
							//聚焦树节点或重载树
	       					Ext.getCmp('addoredit').setValue('2');
	       					mySetCmpDisabled('cmdsave;popsave;btnsave',true);
							Ext.getCmp('filtertext').setValue('');
					    	myFormTab.setActiveTab(0);
					    	myFocusInTab(myFormTab);  //聚焦第一个非只读控件      		
	       					eval(sysWait('记录已经保存成功！',160,100,600));           					
	       				}		
					});	
				}
			}
		}
		
		function fnDeleteRecord(){ //删除客户 dddd
			var records=myGrid1.getSelectionModel().getSelection();
			if (!records[0]){
				Ext.Msg.alert('系统提示','请选择要删除的'+pmyTable.keyspec+'!');
				return;
			}else{	
				var xid=records[0].get(pmyTable.keyfield);
				var sql='delete '+pmyGrid1.tablename+' where '+pmyTable.keyfield+"='"+xid+"'";
				Ext.MessageBox.show({   
		            title: '系统提示',   
		            msg: mySpace(2)+'删除'+pmyTable.keyspec+'<font color=blue><b>【'+xid+'】</b></font>这条记录。'+mySpace(10)+'<br><br>'+mySpace(2)+'是否确认？<br><br>' , 
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
									if (pmyForm.modal!='window') fnSetBtn(1);	
					        	}
				           });	            	
		            	}
		            }					
				});
			}
		}
		
		function fnRefreshRecord(){
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
			fnLoadmyGrid1(1,'');
			pmyGrid1.index=0;
			if (pmyForm.modal!='window') fnSetBtn(1);
		}
		
		function fnLoadmyGrid1(pageno,wheresql){ //重新加载grid数据
			if (wheresql!=''){
				var sql="select * from ("+pmyGrid1.sql+") as p where "+wheresql;
			}else{	
				var sql=pmyGrid1.sql;
			}
			pmyGrid1.paramsql=sql;	
			var xpagesize=myGrid1.store.pageSize;
			var newparams={ database:sysdatabasestring, sqlString:sql,keyField:pmyTable.keyfield,sortField:pmyTable.sortfield,limit:xpagesize,totalFields:pmyGrid1.totalfields };
			Ext.apply(myGrid1.store.proxy.extraParams,newparams);
			if (pageno>0) myGrid1.store.loadPage(pageno); 	        
			else {
				//myGrid1.store.load();
				myGrid1.store.loadPage(1);
			}	
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
	       			var tabtitle=pmyItemGrid.title;
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
						var newparams={ database:sysdatabasestring, sqlString:sql,keyField:xkeyfield,sortField:xsortfield,limit:xpagesize,totalFields:pmyItemGrid.totalfields };
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
			fnLoadmyGrid1(1,xfiltersql);			
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
		
		function fnLoadRecord(){  //lllllllll
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
			mySetCmpDisabled('cmdadd;popadd;cmdupdate;popupdate;cmddelete;popdelete;cmdreview;popreview',false);
			mySetCmpDisabled(pmyForm.fileloadbutton,true);
			//mySetCmpDisabled('filepathcmdup;filepathicon',true);
			//Ext.getCmp('filepathsource').setValue(Ext.getCmp('filename').getValue());
		}	
		
		function fnmyGroupMenuxClick(item,e){
			fnmyGroupMenuClick(item,e);
		}
		function fnmyGroupMenuClick(item,e){
			if (item.keyField!='') {
				pmyTree1.groupid=item.keyField;  //自定义属性
			}else{	
				pmyTree1.groupid=item.textField;  //自定义属性
			}
			pmyTree1.grouptext=item.text;			
			if (pmyTree1.groupid=='*'){
				var root=myTree1.setRootNode({
					text:pmyTree1.roottitle,
					iconCls: 'folderopenIcon',
	            	cid:'',
		            level:0,
	    	        expanded: false,                
	        	    leaf:true                
				}); //修改根节点的值
				root.removeAll();	
				pmyTree1.sql='';
				myTree1.getSelectionModel().select(root);
				myTree1.collapse(Ext.Component.DIRECTION_LEFT);					
			}else{
				var root=myTree1.setRootNode({
					text:item.text+'（全部）',
					iconCls:'folderopenIcon',
	            	cid:'',
		            level:0,
	    	        expanded: false,                
	        	    leaf:false                
				}); //修改根节点的值
				myTree1.expand();
				var tmp=pmyTree1.groupid.split('+');
				pmyTree1.sql='';
				for (var j=1;j<=tmp.length;j++){
					pmyTree1.groupfield[j]=tmp[j-1];
				}	
				if (tmp.length<2){
					pmyTree1.sql=" select "+pmyTree1.groupfield[1]+" as nodeid,"+pmyTree1.groupfield[1]+"+case when "+pmyTree1.groupfield[1]+"='' then '其他' else '' end+'('+cast(count(*) as varchar(10))+')' as nodetext,";
					pmyTree1.sql+="1 as level,0 as isparentflag,'' as parentnodeid,";
					pmyTree1.sql+="case when "+pmyTree1.groupfield[1]+"<>'' then 0 else 1 end as sortflag ";
					pmyTree1.sql+=" from ("+pmyGrid1.sql+") as p group by "+pmyTree1.groupfield[1];
				}else{  //最多支持两层
					pmyTree1.sql=" select "+pmyTree1.groupfield[1]+" as nodeid,"+pmyTree1.groupfield[1]+"+case when "+pmyTree1.groupfield[1]+"='' then '其他' else '' end+'('+cast(count(*) as varchar(10))+')' as nodetext,";
					pmyTree1.sql+="1 as level,1 as isparentflag,'' as parentnodeid,";
					pmyTree1.sql+="case when "+pmyTree1.groupfield[1]+"<>'' then 0 else 1 end as sortflag ";
					pmyTree1.sql+=" from ("+pmyGrid1.sql+") as p group by "+pmyTree1.groupfield[1];
					pmyTree1.sql+=" union all ";
					pmyTree1.sql+=" select "+pmyTree1.groupfield[2]+" as nodeid,"+pmyTree1.groupfield[2]+"+case when "+pmyTree1.groupfield[2]+"='' then '其他' else '' end+'('+cast(count(*) as varchar(10))+')' as nodetext,";
					pmyTree1.sql+="2 as level,0 as isparentflag,"+pmyTree1.groupfield[1]+" as parentnodeid,";
					pmyTree1.sql+="case when "+pmyTree1.groupfield[2]+"<>'' then 0 else 1 end as sortflag ";
					pmyTree1.sql+=" from ("+pmyGrid1.sql+") as p group by "+pmyTree1.groupfield[1]+','+pmyTree1.groupfield[2];
				}
				pmyTree1.sortfield="sortflag,nodeid";
				pmyTree1.rootcode='';
				myTree1.store.load();
				myTree1.expand(Ext.Component.DIRECTION_LEFT);	;
			}		
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
				eval("myItemGrid"+tabno+"CellEditing.startEdit(row, pmyItemGrid"+tabno+".column);");  //ext4.2方法
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
				result=myGridReplaceValidation(sysdatabasestring,grid,table,p.detailgrid[j-1].replace,p.detailgrid[j-1].validation);
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
		
		function fnMoveRecordx(id){
			if (id=='xrowfirst') fnMoveRecord('rowfirst');
			else if (id=='xrowlast') fnMoveRecord('rowlast');
			else if (id=='xrownext') fnMoveRecord('rownext');
			else if (id=='xrowprev') fnMoveRecord('rowprev');
		}		
		/*
		function fnMoveRecord(e){
			//原始程序，不使用函数，不要改写
			pmyGrid1.locatevalue='';
			if (myGrid1.store.getCount()>0){
				var records=myGrid1.getSelectionModel().getSelection();
				if(records[0]){
					pmyGrid1.index=myGrid1.store.indexOf(records[0]);
				}else{
					pmyGrid1.index=-1;
				}
				var loadflag=0;
				var id=(e.id).toLowerCase();
				var pageno=myGrid1.store.currentPage;
				var pagecount=Math.floor((myGrid1.store.getTotalCount()-1)/myGrid1.store.pageSize)+1;
				var rowcount=myGrid1.store.getTotalCount();
				if (id=='rowfirst' || id=='xrowfirst' ) {
					if (pageno>1) {
						loadflag=1;
						myGrid1.store.loadPage(1);
					}
					pmyGrid1.index=0;
				}else if (id=='rowlast' || id=='xrowlast') {
					var rowno=rowcount;
					var n=Math.floor((rowno-1)/myGrid1.store.pageSize)+1;
					pmyGrid1.index=rowno-myGrid1.store.pageSize*(n-1)-1;
					if (pageno!=n) {
						loadflag=1;
						myGrid1.store.loadPage(n);
					}
				}else if (id=='rownext' || id=='xrownext'){
					if(pmyGrid1.index>=0){
						var rowno=pmyGrid1.index+1;
						if (rowno>=myGrid1.store.getCount() && pageno<pagecount) {
							pmyGrid1.index=0;
							rowno=0;
							loadflag=1;
							myGrid1.store.loadPage(pageno+1);
						}
					}else{
						rowno=0;
					}
					pmyGrid1.index=rowno;
				}else if (id=='rowprev' || id=='xrowprev'){
					if(pmyGrid1.index>=0){
						var rowno=pmyGrid1.index-1;
					}else{rowno=0;
				}if (rowno<0 && pageno>1){
					pmyGrid1.index=myGrid1.store.pageSize-1;
					loadflag=1;
					myGrid1.store.loadPage(pageno-1);
				}if (rowno>=0) pmyGrid1.index=rowno;
			}if (loadflag==0 && myGrid1.store.getCount()>0 && pmyGrid1.index<myGrid1.store.getCount()){
				setTimeout(function(){
					myGrid1.getSelectionModel().select(pmyGrid1.index);
				},0);}
			} 		
		}
		*/  //指针移动函数
//console.log('1'+pmyItemGrid1.avgfields);
//console.log('2'+pmyItemGrid1.sumfields);
//console.log('3'+pmyItemGrid1.rmbfield);
//console.log('4'+pmyItemGrid1.rmbstyle);
	//****************************end of extjs**************************//		
	}); 
  
  </script>
  </body>
</html>
