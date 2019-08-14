<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ page import="com.UserBean" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title></title>
		<link rel="stylesheet" type="text/css" href="ext4.2/resources/css/ext-all.css">  <!-- ext系统样式 -->
		<link rel="stylesheet" type="text/css" href="system/css/mystyle.css"> <!-- ext图标文件 -->
		<script type="text/javascript" src="ext4.2/ext-all.js"></script>  <!-- Ext核心源码 -->
		<script type="text/javascript" src="ext4.2/locale/ext-locale-zh_CN.js"></script>  <!-- 国际化文件 -->
		<script type="text/javascript" src="system/decimalfield.js"></script>   <!-- 自定义加零数值型控件 -->
		<script type="text/javascript" src="system/fn_function.js"></script>  <!-- 公共函数 -->
		<script type="text/javascript" src="system/fn_compilers.js"></script>
		<script type="text/javascript" src="system/fn_dspOrder.js"></script>
		<script type="text/javascript" src="system/fn_dspCustomer.js"></script>
		<style type="text/css">
			.css1 table{border-collapse: collapse; border: none}
			.css2 table td{border: 'solid #ededed 1px';}
			.css3 table td{padding: 0 4px 0 6px;}
		</style>
  	</head>
  	<body>
	<%
		UserBean user = (UserBean)session.getAttribute("user");
		if (user == null || user.getUnitNo().equals("")){
			//response.sendRedirect("login.jsp");//重定向
			out.println("<script>Ext.onReady(function(){if(window.top!=window.self){window.top.location.href='login.jsp';}else{window.location.href='login.jsp';}});</script>");			
			return;
		}	
	%>  	
  	<script type="text/javascript">
  	//xml文件中定义nodefields显示树，datafields显示表格
  	//选中子节点，保存后，再过滤，出现问题
	Ext.require(['Ext.form.*','Ext.tree.*','Ext.panel.*','Ext.tab.*','Ext.data.*','Ext.grid.*','Ext.toolbar.*','Ext.menu.*','Ext.Viewport']);
	Ext.onReady(function(){
		Ext.QuickTips.init();
		Ext.form.Field.prototype.msgTarget='side';//统一指定错误信息提示方式//'dtip','title','under'
		Ext.getDoc().on("contextmenu", function(e){  //去掉这个页面的右键菜单
			e.stopEvent();
		});
		eval(sysDisableBackSpace());
		sysSetMessageText();    
		eval(sysSetTreeStore());
		sysuserid='<%=user.getUserID() %>';
		sysuseraccount='<%=user.getAccount() %>';
		sysusername='<%=user.getUsername() %>';
		sysdate='<%=user.getLoginDate() %>';
		sysdatabasestring='<%=user.getDatabase() %>';
		sys.userright='<%=user.getUserRight() %>';
		sys.menuurl='<%=request.getServletPath() %>';
		//Ext.util.CSS.createStyleSheet('fieldset > div{height: 90% !important;}','fieldsetCSS');		
		var maxReturnNumber=10;  //一次从后台返回记录的数量，超过该值树中节点将分层获取。
		var p=window.top.p;  //从主菜单程序中获取
  		var pmyTable={}; //提取数据表
		var pmyForm={};  //提取表单
  		var pmyTree1={};  //提取树myTree1
		var pmyService={};
		pmyService.sysdatabasestring=sysdatabasestring; //传递到fn_function.js
		pmyService.sysdate=sysdate;
		pmyTable.sysdatabasestring=sysdatabasestring; //传递到fn_function.js
		pmyTree1.sysdatabasestring=sysdatabasestring; //传递到fn_function.js
		pmyForm.sysdatabasestring=sysdatabasestring; //传递到fn_function.js
  		pmyTable=myGetTableAttrs(p.table[0],pmyTable);  //获取table值
		pmyForm=myGetFormAttrs(p,pmyForm);
		pmyTable.sysdatabasestring=sysdatabasestring;//数据库连接信息
		pmyTable.sysdate=sysdate;
		pmyTree1=myGetTreeAttrs(p.tree[0],pmyTree1);  //获取grid值
		eval(mySetupTree('myTree1'));
		if (pmyForm.rowheight!=undefined && pmyForm.rowheight!='') var rowHeight=pmyForm.rowheight;
		else var rowHeight=32;
  		pmyTable.permission=';'+myGetOneAttr(p.service,'permissions')+';';
		//region设置
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
		if (pmyForm.modal=='window'){
			pmyTree1.region='center';
			pmyForm.region='center';
		}	
		/**************************定义tree结束***********************************/
		//定义界面 fffffff
		if ((pmyTree1.datafields==undefined || pmyTree1.datafields=='') && pmyTree1.nodetextfields!=''){
			pmyTree1=myGetTreeNodeTextFields(pmyTree1);
			var sql="select "+pmyTree1.keyfield+" as cid,"+pmyTree1.nodetextfields+" as nodetext,* from ("+pmyTree1.sql+") as p";
			pmyTree1.sql=sql;
			//alert(sql); 
		}
	    eval(myDefineTree(pmyTree1)); //定义树myTree1
		eval(pmyForm.tabstr); //定义表单myForm*
		eval(pmyForm.groupboxstr); //定义表单中的groupbox控件
		eval(pmyForm.fieldstr); //定义表单ffffff中的其他控件textfield,combo,datefield
		eval(myAddHiddenFields(pmyTree1.fieldset+';addoredit;nodetype','myForm1'));
		eval(pmyForm.eventstr); //定义表单ffffff中的其他控件textfield,combo,datefield
		if (pmyForm.modal=='window'){
			eval(myDefineTab('myFormTab','','center','['+pmyForm.panels+']',pmyForm.height,pmyForm.width,'false','myContextMenu2'));
		}else{
			eval(myDefineTab('myFormTab','',pmyForm.region,'['+pmyForm.panels+']',pmyForm.height,pmyForm.width,'false','myContextMenu2'));
		}
		/**************************定义window开始******************************/
		//定义过滤菜单
		eval(myDefineCheckMenu('myFilterCheckMenu',pmyTree1.filterfields));
		//定义工具栏tbar
		var wintoolbar=Ext.create('Ext.toolbar.Toolbar',{
			region:'north',split:false,items:[
				{id:'xrowfirst',iconCls: 'rowfirstIcon',text:'',width:22, handler: fnwinMoveRecord,tooltip: '第一行'},
				{id:'xrowprev',iconCls: 'rowprevIcon',text:'',width:24, handler: fnwinMoveRecord,tooltip: '上一行'},
				{id:'xrownext',iconCls: 'rownextIcon',text:'',width:24, handler: fnwinMoveRecord,tooltip: '下一行'},
				{id:'xrowlast',iconCls: 'rowlastIcon',text:'',width:24, handler: fnwinMoveRecord,tooltip: '最后行'}
			]
		});				
		var tbar=Ext.create('Ext.toolbar.Toolbar',{region:'north',split:false});
		tbar.add({xtype:'tbspacer',width:2});
		tbar.add({id:'cmdbar', xtype:'tbseparator'});
		tbar.add({id:'cmdaddmenu',iconCls:'addIcon',text:'新增',menu:[
			{id:'cmdadd',text:'新增节点',handler: fnAddRecord},
			{id:'cmdaddchild',text:'新增子节点',handler:fnAddChildRecord}]
		});
		tbar.add({id:'cmdupdate', iconCls: 'editIcon',text: '修改',handler: fnEditRecord,tooltip: '修改当前选中的记录',xaction:'update'});
		tbar.add({id:'cmddelete', iconCls: 'deleteIcon',text: '删除',handler: fnDeleteRecord,tooltip: '删除当前选中的记录',xaction:'delete'});
		tbar.add({id:'savebar1', xtype:'tbseparator'});
		tbar.add({id:'cmdsave', iconCls: 'saveIcon',text: '保存',handler: fnSaveRecord,tooltip: '保存正在修改或新增的记录',xaction:'save'});
		tbar.add({id:'printbar1', xtype:'tbseparator'});
		tbar.add({id:'cmdprint', iconCls: 'printerIcon',text: '打印',handler: fnPrintRecord,tooltip: '打印'+pmyTable.tabletitle+'列表',xaction:'print'});
		tbar.add({id:'refreshbar1', xtype:'tbseparator'});
	    tbar.add({id:'cmdrefresh', iconCls: 'refreshIcon',text: '刷新',handler: fnRefresh,tooltip: '刷新全部'});
		tbar.add({id:'filterbar1', xtype:'tbseparator'});
		tbar.add({id:'filterbar2', xtype:'tbspacer',width:2});
	    tbar.add({id:'filtertext',xtype:'textfield',emptyText: '快速过滤',enableKeyEvents:true,width:170});
		tbar.add({id:'columnchoose',text:'过滤列选择',menu:myFilterCheckMenu });
		tbar.add({id:'filterbar3', xtype:'tbseparator'});
	    tbar.add({iconCls: 'searchIcon',text: '过滤', id:'cmdfilter',name:'cmdfilter',handler: fnQuickFilter,tooltip: '开始条件过滤'},'-');
		tbar.add({id:'rowfirst',iconCls: 'rowfirstIcon',text:'',width:24, handler: fnwinMoveRecord,tooltip: '第一行'});
		tbar.add({id:'rowprev',iconCls: 'rowprevIcon',text:'',width:24, handler: fnwinMoveRecord,tooltip: '上一行'});
		tbar.add({id:'rownext',iconCls: 'rownextIcon',text:'',width:24, handler: fnwinMoveRecord,tooltip: '下一行'});
		tbar.add({id:'rowlast',iconCls: 'rowlastIcon',text:'',width:24, handler: fnwinMoveRecord,tooltip: '最后行'},'-');
		//定义右击菜单
		var myContextMenu1=Ext.create('Ext.menu.Menu',{ id:'myContextMenu1' });
		myContextMenu1.add({text:'新增节点',id:'popadd',iconCls:'addIcon',handler:fnAddRecord});
		myContextMenu1.add({text:'新增子节点&nbsp;',id:'popaddchild',iconCls:'addIcon',handler:fnAddChildRecord});
		myContextMenu1.add({id:'popaddbar1', xtype:'menuseparator'});
		myContextMenu1.add({text:'修改',id:'popupdate1',iconCls:'editIcon',handler: fnEditRecord});
		myContextMenu1.add({id:'popupdatebar1', xtype:'menuseparator'});
	    myContextMenu1.add({text:'删除',id:'popdelete',iconCls:'deleteIcon',handler:fnDeleteRecord});
		myContextMenu1.add({id:'popdeletebar1', xtype:'menuseparator'});
		myContextMenu1.add({text:'保存',id:'popsave1',iconCls:'saveIcon',handler:fnSaveRecord,tooltip: '保存'+pmyTable.tabletitle});
		myContextMenu1.add({id:'popsavebar1',xtype:'menuseparator'});
		myContextMenu1.add({text:'打印',    id:'popprint',iconCls:'printerIcon',handler:fnPrintRecord,tooltip: '打印'+pmyTable.tabletitle+'列表'});
		myContextMenu1.add({id:'popprintbar1', xtype:'menuseparator'});
		myContextMenu1.add({text:'刷新',id:'poprefresh1',iconCls:'refreshIcon',handler:fnRefresh});
		var myContextMenu2=Ext.create('Ext.menu.Menu',{ id:'myContextMenu2' });
		myContextMenu2.add({text:'保存',id:'popsave2',iconCls:'saveIcon',handler:fnSaveRecord,tooltip: '保存'+pmyTable.tabletitle});
		myContextMenu2.add({id:'popsavebar2',xtype:'menuseparator'});
		myContextMenu2.add({text:'修改',id:'popupdate2',iconCls:'editIcon',handler: fnEditRecord});
		myContextMenu2.add({id:'popupdatebar2',xtype:'menuseparator'});
		myContextMenu2.add({text:'清空',id:'popreset',iconCls:'resetIcon',handler:fnResetRecord});
		myContextMenu2.add({id:'popresetbar1',xtype:'menuseparator'});
		myContextMenu2.add({text:'重置',id:'popreload',iconCls:'refreshIcon',handler:fnReLoadRecord});
		if (pmyForm.modal=='window'){
		    var myEditWin=Ext.create('Ext.window.Window', {
				height: pmyForm.height+64, //高度
				width: pmyForm.width+6, //宽度
				closeAction: 'hide',//关闭按钮 效果是隐藏当前窗体
				modal:true,
				resizable:false,
				layout: 'absolute',//布局方式
				items:[myFormTab],
				buttons:[
					wintoolbar,'->',
					{id:'btnsave',text:'保存',height:25,handler:function(){ fnSaveRecord(); }},
					{id:'btnclose',text:'取消',height:25,handler:function(){ myEditWin.hide(); }}
				],	
				listeners:{
					show:function(){
						//
					}
				}
			});
			var view=Ext.create('Ext.Viewport', {
		        layout: { type: 'border', padding: 5 },
		        defaults: { split: true },
		        items: [tbar,myTree1]
		    });
			//mySetCmpVisible('cmdsave;savebar1;popupdate2;popupdatebar2',false);
			mySetCmpVisible('cmdsave;savebar1;popupdate2;popupdatebar2',true);
		}else{
			var view=Ext.create('Ext.Viewport', {
		        layout: { type: 'border', padding: 5 },
		        defaults: { split: true },
		        items: [tbar,myTree1,myFormTab]
		    });	
			//wintoolbar.setBorder(false);
			//tbar.add(wintoolbar);
			//tbar.add({xtype:'tbseparator'});
		}
		//初始设置
		mySetCmpDisabled('cmdsave;popsave1;popsave2;popreload;popreset',true);	
		mySetCmpDisabled('cmdadd;popadd;cmdaddchild;popaddchild;cmdupdate1;popupdate1;popupdate2;cmddelete;popdelete',false);
		/**************************定义border布局 view结束****************************/	
		//工具条设置
		pmyTable.editflag=0;
		if ((pmyTable.permission).indexOf(';add;')<0){
			mySetCmpVisible('cmdaddmenu;popadd;popaddchild;popaddbar1',false);
		}else pmyTable.editflag++;
		if (pmyTable.permission.indexOf(';update;')<0){
			mySetCmpVisible('cmdupdate;popupdate1;popupdate2;updatebar1;popupdatebar1;popupdatebar2',false);
		}else pmyTable.editflag+=2;
		if (pmyTable.permission.indexOf(';delete;')<0){
			mySetCmpVisible('cmddelete;popdelete;popdeletebar1',false);
		}
		if (pmyTable.permission.indexOf(';print;')<0){
			mySetCmpVisible('cmdprint;popprint;printbar1;popprintbar1',false);
		}
		if (pmyTable.permission.indexOf(';filter;')<0){
			mySetCmpVisible('cmdfilter;filterbar1;filterbar2;filterbar3;filtertext;columnchoose',false);
		}
		if (pmyTable.editflag==0){  //查询状态
			mySetCmpVisible('cmdbar;cmdsave;btnsave;popsave1;popsave2;savebar1;popsavebar1;popsavebar2',false);
			if (Ext.getCmp('btnclose')!=null) Ext.getCmp('btnclose').setText('关闭');		
		}	
		/*
		var cmp=Ext.ComponentMgr.all;
		console.log(cmp);
		for (j=0;j<cmp.length;j++){
			console.log(cmp.map[j]);
		}
		*/
		//alert(pmyTree1.datafields+'---'+pmyTree1.nodetextfields);
		//alert(pmyTree1.sql=sql);
		/**************************以下是函数************************************/		
		myTree1.on('load',function(){
	    	var root=myTree1.getRootNode();
	    	if (pmyTree1.selectedcode=='' && pmyTree1.rootcode==''){
		    	if (root.hasChildNodes()){
					var node=root.childNodes[0];
					myTree1.getSelectionModel().select(node);//选中第一个节点
					//展开第一个节点
					pmyTree1.rootcode=node.get('cid');
					node.expand();
		    	}
	    	}
		});

		myTree1.on('select',function(tree, record, index, e) {
			pmyTree1.index=index;
			mySetCmpDisabled('rowfirst;rowprev;rowlast;rownext',false);
			mySetCmpDisabled('xrowfirst;xrowprev;xrowlast;xrownext',false);
			var totalcount=myTree1.store.tree.flatten().length;
			index=pmyTree1.index;  
			if (index<=0) mySetCmpDisabled('rowfirst;rowprev;xrowfirst;xrowprev',true);
			if (index>=totalcount-2) mySetCmpDisabled('rowlast;rownext;xrowlast;xrownext',true);
			fnLoadRecord(record);
		});

		myTree1.on('itemdblclick',function(record) {
			var records=myTree1.getSelectionModel().getSelection();
			if (records[0] && records[0].get('isparentflag')==0){  //子节点
				fnShowRecord();
			}
		});

		function fnKeyEvent(field,e) {
			myKeyEvent(field,e,myFormTab);  //笤俑functions中的函数
		}
		
		function fnPrintRecord(){  //pppppp
			var date=myGetDatePart('year',sysdate)+'年'+myGetDatePart('month',sysdate)+'月'+myGetDatePart('day',sysdate)+'日';		
			var xtemplate="TProductEdit.xls";
			var xsql="select productid,productname,quantityperunit,unit,unitprice,taxrate,a.supplierid,suppliername from ";
			xsql+=" products a join suppliers b on a.supplierid=b.supplierid";
			xsql+=" order by productid";
			var xtitlecells= "<2,1>"+date+"打印";
			var xtitlerange="<1>-<3>";
			var xtargetfilename="产品分类基本信息表.xls";
			//alert(xsql);
			var r=myExportExcelReport(xtemplate,xsql,xtitlecells,xtitlerange,'','',xtargetfilename);
		}
		
		function fnLoadRecord(record){
           	if (record) {//判断是否有节点选中
				mySetCmpDisabled('cmdsave;popsave1;popsave2;popreload;popreset',true);	
				mySetCmpDisabled('cmdadd;popadd;cmdaddchild;popaddchild;cmdupdate;popupdate1;popupdate2;cmddelete;popdelete',false);
	       		for (var i=1;i<=pmyForm.pagecount;i++) {
					eval("myForm"+i+".getForm().loadRecord(record);");
					eval(mySetFormReadOnly('myForm'+i,'true'));					
				}
           		Ext.getCmp(pmyTable.keyfield).setReadOnly(true);//将产品编码字段设置为只读
	           	//特殊字段处理
				for (var j=0;pmyForm.labelfielddim!=undefined && j<pmyForm.labelfielddim.length;j++){
					var ff=p.xfielddim[pmyForm.labelfielddim[j]].name;
					Ext.getCmp(ff).setText(records[0].get(ff));
				}
				mySetCmpDisabled(pmyForm.fileloadbutton,true);
				if (pmyForm.modal=='window'){
					myEditWin.setTitle('&nbsp;'+pmyForm.title);
					if (Ext.getCmp('btnclose')!=null) Ext.getCmp('btnclose').setText('关闭');	       			
					if (Ext.getCmp('btnsave')!=null) Ext.getCmp('btnsave').setDisabled(true);	       			
				}
				//Ext.getCmp('filepathsource').setValue(Ext.getCmp('filename').getValue());		
				Ext.getCmp('addoredit').setValue(2);//设置标记值为2 代表修改
				Ext.getCmp('nodetype').setValue(0);
			}
		}
		
		function fnReLoadRecord(){
			var records=myTree1.getSelectionModel().getSelection();
			if (records[0]){
	       		for (var i=1;i<=pmyForm.pagecount;i++) {
					eval("myForm"+i+".getForm().loadRecord(records[0]);");
				}	
			} 
		}	
		
		function fnResetRecord(){
			var xid=Ext.getCmp(pmyTable.keyfield).getValue();
       		for (var i=1;i<=pmyForm.pagecount;i++) {
   	   			eval("myForm"+i+".getForm().reset();");
			}
			Ext.getCmp(pmyTable.keyfield).setValue(xid);
		}

		function fnAddRecord(){ //新增兄弟产品类别节点aaaa
			mySetCmpDisabled('cmdsave;popsave1;popsave2;popreset',false);	
			mySetCmpDisabled('cmdupdate;popupdate1;popupdate2;cmddelete;popdelete;popreload',true);
       		for (var i=1;i<=pmyForm.pagecount;i++) {
   	   			eval("myForm"+i+".getForm().reset();");
				eval(mySetFormReadOnly('myForm'+i,'false'));
			}
			Ext.getCmp(pmyTable.keyfield).setReadOnly(false);//将产品编码字段设置为可读
			//Ext.getCmp('filepathsource').setValue('');
			var root=myTree1.store.getRootNode(); 
			Ext.getCmp('parentnodeid').setValue('');  //设置父节点为空
			Ext.getCmp('ancester').setValue('');  //设置父节点为空
			Ext.getCmp('level').setValue('1'); //设置父节点层次为0
			Ext.getCmp('addoredit').setValue(1);//将标记设置值设置为1
			Ext.getCmp('nodetype').setValue(1);//nodetype 值分为1 2 ：1代表新增兄弟节点 2代表子节点
			var pid='';//父结点值
			var records=myTree1.getSelectionModel().getSelection();//获取树节点选择情况
			if (records[0]){ //若有节点选中
				var xid=records[0].get('cid');//获取节点编码值
				var node=root.findChild('cid',xid,true);  //获取当前选中节点
				var pNode=node.parentNode; //求新节点的父节点
				if (pNode!=root){
					pid=pNode.get('cid');
					Ext.getCmp(pmyTable.keyfield).setValue(pid);
					Ext.getCmp('parentnodeid').setValue(pid);
					if (pNode.get('ancester')!=''){
						Ext.getCmp('ancester').setValue(pNode.get('ancester')+''+pid+'#');
					}else{
						Ext.getCmp('ancester').setValue(pid+'#');
					}
					Ext.getCmp('level').setValue(pNode.get('level')+1); //记录父节点层次
				}
			}	
			//mySetCmpDisabled('filepathcmdup;filepathicon',false);
			mySetCmpDisabled(pmyForm.fileloadbutton,false);
			if (pmyForm.modal=='window'){
				myEditWin.setTitle('&nbsp;新增'+pmyTable.tabletitle);
				if (Ext.getCmp('btnclose')!=null) Ext.getCmp('btnclose').setText('取消');	       			
				if (Ext.getCmp('btnsave')!=null) Ext.getCmp('btnsave').setDisabled(false);	       			
				myEditWin.show();		  
			}
			myFormTab.setActiveTab(0);
	    	myFocusInTab(myFormTab);  //聚焦第一个非只读控件
	    	if (pid!='') {
				Ext.getCmp(pmyTable.keyfield).focus(false,50);  //不选中文本
				Ext.getCmp(pmyTable.keyfield).selectText(pid.length);  //指定光标到某个位置
			}
		}
		
		function fnAddChildRecord(){//新增子产品类别节点
			mySetCmpDisabled('cmdsave;popsave1;popsave2;popreload;popreset',false);	
			mySetCmpDisabled('cmdadd;cmdupdate;popupdate1;popupdate2;cmddelete;popdelete',true);
       		for (var i=1;i<=pmyForm.pagecount;i++) {
   	   			eval("myForm"+i+".getForm().reset();");
				eval(mySetFormReadOnly('myForm'+i,'false'));
			}
			Ext.getCmp(pmyTable.keyfield).setReadOnly(false);//将产品编码字段设置为可读
			//Ext.getCmp('filepathsource').setValue('');
			var root=myTree1.store.getRootNode(); 
			Ext.getCmp('parentnodeid').setValue('');  //设置父节点为空
			Ext.getCmp('ancester').setValue('');  //设置父节点为空
			Ext.getCmp('level').setValue('1'); //设置父节点层次为0
			Ext.getCmp('addoredit').setValue(1);//将标记设置值设置为1
			Ext.getCmp('nodetype').setValue(2);//nodetype 值分为1 2 ：1代表新增兄弟节点 2代表子节点
			var pid='';
			var records=myTree1.getSelectionModel().getSelection();//获取树节点选择情况
			if(records[0]){ //若有节点选中
				pmyTree1.selectedcode='';			  
				pid=records[0].get('cid');//获取节点编码值
				Ext.getCmp(pmyTable.keyfield).setValue(pid);
				Ext.getCmp('parentnodeid').setValue(pid);
				if (records[0].get('ancester')!=''){
					Ext.getCmp('ancester').setValue(records[0].get('ancester')+''+pid+'#');
				}else{
					Ext.getCmp('ancester').setValue(pid+'#');
				}
				Ext.getCmp('level').setValue(records[0].get('level')+1);
				//mySetCmpDisabled('filepathcmdup;filepathicon',false);
				mySetCmpDisabled(pmyForm.fileloadbutton,false);
				if (pmyForm.modal=='window'){
					myEditWin.setTitle('&nbsp;新增'+pmyTable.tabletitle);
       				if (Ext.getCmp('btnclose')!=null) Ext.getCmp('btnclose').setText('取消');	       			
					if (Ext.getCmp('btnsave')!=null) Ext.getCmp('btnsave').setDisabled(false);	       			
					myEditWin.show();
				}		
			}
			myFormTab.setActiveTab(0);
	    	myFocusInTab(myFormTab);  //聚焦第一个非只读控件
	    	if (pid!='') {
				Ext.getCmp(pmyTable.keyfield).focus(false,50);  //不选中文本
				Ext.getCmp(pmyTable.keyfield).selectText(pid.length);  //指定光标到某个位置
			}
		}
		
		function fnEditRecord(btn){//修改类别编码  eeee
			var records=myTree1.getSelectionModel().getSelection();//获取gird所有选中的records
			if(records[0]){	//获取第一个record对象
				fnLoadRecord(records[0]);
				if (pmyTable.editflag<2){ 
		       		for (var i=1;i<=pmyForm.pagecount;i++) {
		       			if (pmyTable.editflag==0) eval(mySetFormReadOnly('myForm'+i,'true'));
		       		}	
					mySetCmpDisabled('cmdsave;popsave1;popsave2;popreload;popreset',true);
				}else{		
		       		for (var i=1;i<=pmyForm.pagecount;i++) {
		       			eval(mySetFormReadOnly('myForm'+i,'false'));
		       		}	
					mySetCmpDisabled('cmdsave;popsave1;popsave2;popreload;popreset',false);	
					Ext.getCmp(pmyTable.keyfield).setReadOnly(true);//将产品编码字段设置为只读				
				}
				//mySetCmpDisabled('filepathcmdup;filepathicon',false);
				mySetCmpDisabled(pmyForm.fileloadbutton,false);
				if (pmyForm.modal=='window'){
	       			if (pmyTable.editflag<2){
	       				myEditWin.setTitle('&nbsp;'+pmyForm.title);
						if (Ext.getCmp('btnclose')!=null) Ext.getCmp('btnclose').setText('关闭');	       			
						if (Ext.getCmp('btnsave')!=null) Ext.getCmp('btnsave').setDisabled(true);	       			
	       			}else{
	       				myEditWin.setTitle('&nbsp;修改'+pmyTable.tabletitle);
	       				if (Ext.getCmp('btnclose')!=null) Ext.getCmp('btnclose').setText('取消');	       			
						if (Ext.getCmp('btnsave')!=null) Ext.getCmp('btnsave').setDisabled(false);	       			
	       			}
	       			
					myEditWin.show();
				}					
	    		myFocusInTab(myFormTab);  //聚焦第一个非只读控件			
	    	}
		}
	
		function fnShowRecord(btn){  //只读显示记录  eeee
			var records=myTree1.getSelectionModel().getSelection();//获取gird所有选中的records
			if(records[0]){	//获取第一个record对象
				fnLoadRecord(records[0]);
	       		for (var i=1;i<=pmyForm.pagecount;i++) {
	       			eval(mySetFormReadOnly('myForm'+i,'true'));
	       		}	
		       	mySetCmpDisabled('cmdsave;popsave1;popsave2;popreload;popreset',true);
				if (pmyForm.modal=='window'){
       				myEditWin.setTitle('&nbsp;'+pmyForm.title);
					if (Ext.getCmp('btnclose')!=null) Ext.getCmp('btnclose').setText('关闭');	       			
					if (Ext.getCmp('btnsave')!=null) Ext.getCmp('btnsave').setDisabled(true);	       			
					myEditWin.show();
				}					
	    	}
		}
	
		function fnUpLoadImage(){
			var records=myTree1.getSelectionModel().getSelection();//获取gird所有选中的records
			if(records[0]){	//获取第一个record对象
				fnLoadRecord(records[0]);
				if (pmyForm.modal=='window'){
					myEditWin.setTitle('&nbsp;修改产品');
					myEditWin.show();					
				}
	       		for (var i=1;i<=pmyForm.pagecount;i++) {
	       			eval(mySetFormReadOnly('myForm'+i,'false'));
	       		}	
				Ext.getCmp(pmyTable.keyfield).setReadOnly(true);//将产品编码字段设置为只读		
				//mySetCmpDisabled('filepathcmdup;filepathicon',false);
				mySetCmpDisabled(pmyForm.fileloadbutton,false);				
				myFormTab.setActiveTab(1);
	    		myFocusInTab(myFormTab);  //聚焦第一个非只读控件			
	    	}	
		}

		function fnDeleteRecord(){//删除类别编码
			var records=myTree1.getSelectionModel().getSelection();
			if(!records[0]){
				eval(sysWarning('请选择要删除的'+pmyTable.tabletitle+'！',0,0));
				return ;
			}else{
				var xid=Ext.getCmp(pmyTable.keyfield).getValue();
				Ext.MessageBox.show({   
		            title: '系统提示',   
		            msg: '删除'+pmyTable.keyspec+'<font color=blue><b>【'+xid+'】</b></font>。'+mySpace(10)+'<br><br>是否确定？', 
		            icon: Ext.MessageBox.QUESTION,  //icon: Ext.MessageBox.INFO  
		            buttons: Ext.Msg.YESNO,
		            fn: function(btn){
		            	if(btn=='yes'){
		            		var root=myTree1.store.getRootNode();
		            		var node=records[0];
		            		var pid=node.get(pmyTable.keyfield);
							var newnode=node.nextSibling;  //找到下一个兄弟节点
							//console.log(newnode);
							if (newnode==null) newnode=node.previousSibling; //找到上一个兄弟节点
							if (newnode==null) newnode=node.parentNode;  //没有兄弟时找父节点
							if (newnode==root && root.hasChildNodes()) newnode=root.childNodes[0];;
		            		node.remove();  //加载时不需要，自动不显示该节点
							if (newnode!=null && newnode!=root){
								myTree1.getSelectionModel().select(newnode);//加载时不需要
								pmyTree1.selectedcode=newnode.get(pmyTable.keyfield);  //加载时需要
							}
				            Ext.getCmp('addoredit').setValue(3);//该变量用来区别新增|修改，这涉及到grid的定位
							var sql="with tmp as (";
							sql+=" select "+pmyTable.keyfield+",parentnodeid from "+pmyTree1.tablename+" where "+pmyTable.keyfield+"='"+xid+"' ";
							sql+=" union all ";
							sql+=" select a."+pmyTable.keyfield+",a.parentnodeid from "+pmyTree1.tablename+" as a,tmp as b ";
							sql+="where a.ParentNodeID=b."+pmyTable.keyfield;
							sql+=")"
							sql+=" delete "+pmyTree1.tablename+" where "+pmyTable.keyfield+" in ";
							sql+=" (select "+pmyTable.keyfield+" from tmp) ";
							if (pid!=''){  //设置父节点的isparentflag值
								sql+=" update "+pmyTree1.tablename+" set IsParentFlag=0 where "+pmyTable.keyfield+"='"+pid+"' and not exists";
								sql+=" (select 1 from "+pmyTree1.tablename+" where ParentNodeID='"+pid+"')";
									
							}
							//console.info(sql);
				            Ext.Ajax.request({//与服务器交互
					        	url:'system//fn_executeSql.jsp',
								params:{ database:sysdatabasestring, updateSql:sql,selectSql:'' },									
					        	method: 'POST',async:false,
					        	callback:function(options,success,response){
									pmyTree1.rootcode='';
									Ext.getCmp('filtertext').setValue('');  //将过滤条件设置为空
									pmyTree1.searchtext='';
									//fnTreeLoad();  //加载时重新聚焦节点
					        	}
				           }); //ajax结束
		            	}
		            }
				});
			}
		}

		function fnSaveRecord(){//保存sssss
			pmyTree1.rootcode='';
			var xid=Ext.getCmp(pmyTable.keyfield).getValue();
			var pid=Ext.getCmp('parentnodeid').getValue().myTrim();
			var pstr=Ext.getCmp('ancester').getValue().myTrim();
			if (pstr!=''){
				pstr=pstr+'#'+pid;
			}else{
				pstr=pid;
			}
			var xaddoredit=Ext.getCmp('addoredit').getValue();
			var records=myTree1.getSelectionModel().getSelection();
			pmyTree1.selectedcode=xid;			
			//Ext.getCmp('filename').setValue(Ext.getCmp('filepathsource').getValue());
			//数据保存前系统变量赋值,返回字符串命令
			eval(mySetSysVars());
			pmyTable.error='';
			//前台验证数据和替换
			//console.log(myFormReplaceValidation(pmyTable,p.replace,p.validation));
			eval(myFormReplaceValidation(pmyTable,p.replace,p.validation));
			pmyTable.keyvalue=xid;
			//后台验证主键是否重复
			if (xaddoredit=='1') pmyTable.error+=myPKUniqueCheck(pmyTable);
			//数据验证错误判断
			if (pmyTable.error!=''){
				eval(sysError('发现下列错误，记录保存失败！<br>'+pmyTable.error,0,0));
				myFocusInTab(myFormTab);  //聚焦第一个非只读控件
				return;
			}else{
        		var updatesql='';
        		var querysql='';
				//将控件值赋值到pmyForm.editablefieldtext中
       			eval(myGetFormValues(pmyForm));
       			//将表中可编辑字段赋值到pmyForm.editablefieldset中
       			pmyForm.editablefieldset=myGetTableEditableFields(sysdatabasestring,pmyTable.tablename);
				if (xaddoredit=='1'){
					//根据表单值和可编辑字段，生成insert语句
	        		updatesql=myGenInsertSql(pmyTable.tablename,pmyForm.editablefieldset,pmyForm.fieldtext);
					if (xaddoredit=='1' && pid!=''){  //修改父节点的isparentflag标志值为1
						updatesql+=' update '+pmyTable.tablename+' set isparentflag=1 where isparentflag=0 and '+pmyTable.keyfield+"='"+pid+"'";
					}
	    	    }else{
					//根据表单值和可编辑字段，生成update语句
					updatesql=myGenUpdateSql(pmyTable.tablename,pmyForm.editablefieldset,pmyForm.fieldtext,pmyTable.keyfield,xid);        		
        		}	
				//console.log(updatesql);
       			querysql="select rowno=count(*)+1 from "+pmyTable.tablename+" where "+pmyTable.keyfield+"<'"+xid+"'";
	       		//数据库中保存记录	
				Ext.Ajax.request({   //ssss
					url: 'system//fn_executeSql.jsp',
					method: 'post',async:false,
     				params:{ database:sysdatabasestring, updateSql:updatesql,selectSql:querysql },									
					waitTitle : '系统提示',
					waitMsg: '正在保存数据,请稍候...',
					callback:function(options,success,response){
						var rowno=Ext.decode(response.responseText).rowno;						
						//记录保存成功，重新加载myGrid1
						if (pmyForm.modal=='window'){
							//myEditWin.hide();
						}
						fnTreeLoad();
       					Ext.getCmp('addoredit').setValue('2');
       					eval(sysWait('记录已经保存成功！',160,100,600));
       				}		
				});
				Ext.getCmp('filtertext').setValue('');  //将过滤条件设置为空
				pmyTree1.searchtext='';
			}  //if error==''
		}
		
		function fnRefresh(){//重新加载数据
			pmyTree1.rootcode='';
			pmyTree1.searchtext='';
			Ext.getCmp('filtertext').setValue('');  //将过滤条件设置为空
			Ext.getCmp('addoredit').setValue('2');//只要用户点击重置/删除/刷新都需将该值设置为空
			myTree1.store.load();
		}
		
		function fnTreeLoad(){//重新加载tree数据
			pmyTree1.rootcode='';
			//searchText='searchText';//设置该值只是为了区别空
			//searchText='';
			myTree1.store.load();//重新加载
		}

		//快速过滤函数
		function fnQuickFilter(){
			var xfilter=Ext.getCmp('filtertext').getValue();
			var xfiltersql=myGetFilterSql(myFilterCheckMenu,xfilter);  //获取过滤条件
			pmyTree1.rootcode='';  //重新生成根节点
			pmyTree1.selectedcode='';
			pmyTree1.searchtext=xfiltersql;
			myTree1.store.load();
		}
		
		function fnwinMoveRecord(e){
			var records=myTree1.getSelectionModel().getSelection();
			var root=myTree1.store.getRootNode();
			if (records[0]){
				var totalcount=myTree1.store.tree.flatten().length;
				index=Math.max(0,pmyTree1.index);  
				if (e.id=='rowfirst' || e.id=='xrowfirst'){
					index=0;
				}
				if (e.id=='rownext' || e.id=='xrownext'){
					index++;
				}
				if (e.id=='rowprev' || e.id=='xrowprev'){
					index--;
				}
				if (e.id=='rowlast' || e.id=='xrowlast'){
					index=totalcount-2;  //扣除一个root节点
				}
				if (index>=0 && index<totalcount-1){
					myTree1.getSelectionModel().select(index);
				}
			}
		}
		
		function fnSelectSimpleCombo(combo,record,index){
			var id=combo.id;
			if (index==1){
			
			}

		}
		//ccccc初始化
		//var newparams={ database:sysdatabasestring, maxReturnNumber:maxReturnNumber,sqlString: pmyTree1.sql,keyField:pmyTree1.keyfield,rootCode:pmyTree1.rootcode,selectedCode:pmyTree1.selectedcode,searchText:'' };
		//Ext.apply(myTree1.store.proxy.extraParams,newparams);
    	//var root=myTree1.getRootNode();
    	//pmyTree1.rootcode='';
		//myTree1.store.load();
		
		//-------------------extjs定义结束-----------------//
	});
  
  </script>
</body>

</html>
