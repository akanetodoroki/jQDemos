<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="com.DBConn" %>
<%@ page import="com.UserBean" %>
<%@ page import="com.StringUtil"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>TGridSum模板</title>
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
		pmyGrid1.varname='pmyGrid1';
		pmyGrid1.name='myGrid1';
		pmyGrid1.region='center';
		pmyGrid1.locatekeyvalue='';
		pmyGrid1.keyevent='myGridColumnKeyEvent';
		pmyGrid1.bartitle=pmyGrid1.title;
		pmyGrid1.showtitle='false';
		pmyGrid1.paramsql=pmyGrid1.sql;
		//存储grid中combo之类的sql语句，bbar等
		eval(pmyForm.gridcmpstr);
		eval(myDefineGrid(pmyGrid1));//生成grid
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
		var tbar=Ext.create('Ext.toolbar.Toolbar',{region:'north',split:false,id:'tbar'});
		tbar.add({xtype:'tbspacer',width:2});
		tbar.add({id:'cmdbar', xtype:'tbseparator'});
		tbar.add({id:'cmdsumup', iconCls: 'addIcon',text: '求和',handler: fnSumup,tooltip: '分层汇总',xaction:'edit'});
		tbar.add({id:'cmdsave', iconCls: 'saveIcon',text: '保存',handler: fnSave,tooltip: '保存数据',xaction:'save'});
		tbar.add({id:'savebar1', xtype:'tbseparator'});
		tbar.add({id:'cmdprint', iconCls: 'printerIcon',text: '打印',handler: fnPrint,tooltip: '打印'+pmyGrid1.tabletitle+'列表',xaction:'print'});
		tbar.add({id:'printbar1', xtype:'tbseparator'});
	    tbar.add({id:'cmdrefresh', iconCls: 'refreshIcon',text: '刷新', id:'refresh',name:'refresh',handler: fnRefresh,tooltip: '刷新全部'});
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
	    	{text:'求和',id:'popsumup',iconCls:'sumIcon',handler:fnSumup,xaction:'edit'},
	    	{text:'保存',id:'popsave',iconCls:'saveIcon',handler:fnSave,xaction:'save'},
	    	{xtype:'menuseparator',id:'refreshbar2'},
	        {text:'清空',id:'popreset',iconCls:'resetIcon',handler:fnReset},
	    	{xtype:'menuseparator',id:'refreshbar2'},
	        {text:'重载',id:'poprefresh',iconCls:'refreshIcon',handler:fnRefresh}
	    ]});	
		//可编辑grid中的右键菜单
		/**************************定义右击菜单结束******************************/
		/**************************定义tree开始************************************/
		//alert(pmyGrid1.totalfields);
		var wintoolbar=Ext.create('Ext.toolbar.Toolbar',{
			region:'north',split:false,items:[
				{id:'xrowfirst',iconCls: 'rowfirstIcon',text:'',width:22, handler: function(e) { fnMoveRecord(e.id); },tooltip: '第一行'},
				{id:'xrowprev',iconCls: 'rowprevIcon',text:'',width:24, handler: function(e)   { fnMoveRecord(e.id); },tooltip: '上一行'},
				{id:'xrownext',iconCls: 'rownextIcon',text:'',width:24, handler: function(e)   { fnMoveRecord(e.id); },tooltip: '下一行'},
				{id:'xrowlast',iconCls: 'rowlastIcon',text:'',width:24, handler: function(e)   { fnMoveRecord(e.id); },tooltip: '最后行'}
			]
		});
		/**************************定义myGrid结束**********************************/
		//按钮初始状态设置
		mySetCmpDisabled('cmdsumup;cmdsave;popsum;delete;cmdsave;popsave;btnsave;cmdprint;popprint',false);
		mySetCmpDisabled(pmyForm.fileloadbutton,false);
		//wwwwww
		/****************************页面布局******************************/
		//定义页面布局
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
				{text:'保存',id:'btnsave', height:25,handler:function(){ fnSave(); }},
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
		if (pmyTable.permission.indexOf(';edit;')>=0 || pmyTable.permission.indexOf(';sum;')>=0){
			mySetCmpVisible('cmdsumup;popsumup',true);
			pmyTable.editflag[1]=1;
		}else mySetCmpVisible('cmdsumup;popsumup',false);
		if (pmyTable.permission.indexOf(';print;')<0){
			mySetCmpVisible('cmdprint;popprint;printbar1;printbar2',false);
		}
		if (pmyTable.permission.indexOf(';filter;')<0){
			mySetCmpVisible('cmdfilter;filterbar1;filterbar2;filterbar3;filtertext;columnchoose',false);
		}
		if (pmyTable.editflag[1]==0){  //查询状态
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


		myGrid1bbar.on('xbeforechange',function(bbar,page,e){
			//原来页面的值是否需要保存
			var rs1=myGrid1.store.getUpdatedRecords();
			if (myGrid1.store.getCount()>0 && rs1.length>0){
				Ext.MessageBox.show({   
		            title: '系统提示',   
		            msg: mySpace(2)+pmyGrid1.title+'已经修改，是否保存数据？<br><br>' , 
 		            icon: Ext.MessageBox.QUESTION,  //icon: Ext.MessageBox.INFO  
		            buttons: Ext.Msg.YESNO,
		            fn: function(btn){
		            	if(btn=='yes'){
		            		fnSave();
		            	}
		            }
		           }); 	
			}		
		});
		
		//定义myGrid1事件
		myGrid1.store.on('xbeforeload',function(store){
			var rs1=myGrid1.store.getUpdatedRecords();
			if (myGrid1.store.getCount()>0 && rs1.length>0){
          		fnSave();
			}
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
			myEditWin.setTitle(pmyForm.title);
			myEditWin.show();
		}); 
		
		myGrid1.on('select',function(model,record,index) {  //schange
			mySetMoveRecordBtn(myGrid1,record);	//调用函数,控制记录移动指针的disabled状态
			mySetCmpDisabled('xrowfirst;xrownext;xrowprev;xrowlast',false);
			if (record.get('sysrowno')==1) mySetCmpDisabled('xrowfirst;xrowprev',true);
			if (record.get('sysrowno')==myGrid1.store.getTotalCount()) mySetCmpDisabled('xrowlast;xrownext',true);
			fnLoadRecord();
		});

		myGrid1.on('beforeedit',function(editor,e) {  //eeeeeee
			//console.log(pmyGrid1.lockedcolumncount+'---'+e.colIdx+'---'+myGrid1.columns[e.colIdx].editable);
			if (e.record.get('isparentflag')>0 || !myGrid1.columns[pmyGrid1.lockedcolumncount+e.colIdx].editable ){  //父类不能编辑
				e.cancel=true;
			}else e.cancel=false;
		});

		myGrid1.on('edit',function(editor,e) {  //eeeeeee
			var field=e.field;
			var record=e.record;
			//e.record.commit();
			var level=record.get('level');
			var delta=e.value-e.originalValue;
			if (delta!=0){  //修改各级父节点的值
				for (var i=level;i>1;i--){
					var pvalue=record.get('parentnodeid');
					record=myGrid1.store.findRecord(pmyGrid1.keyfield,pvalue,0,false,false,true);
					if (record) record.set(field,1.0*record.get(field)+delta);
				}
			}
		});
		
		myGrid1.on('xcontainercontextmenu',function(grid, e){  //定义右键   		
   			e.preventDefault();
   			myContextMenu1.showAt(e.getXY());
   		});
   		
   		myGrid1.on('xitemcontextmenu',function(grid, record, item, index, e){  //定义右键   		
   			e.preventDefault();
   			grid.getSelectionModel().select(record);//选中指定行号的记录   
   			myContextMenu1.showAt(e.getXY());
   		});
   		
		myFormTab.on('tabchange',function(tabPanel,newCard,oldCard,eOpts ){
	    	myFocusInTab(tabPanel);  //聚焦第一个非只读控件 					
		});

		function fnPrint(){  //ppppppp
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
		
		function fnSumup(){  //sssss逐级求和
			//var totalfields=pmyGrid1.sumfields+pmyGrid1.avgfields+pmyGrid1.countfields+pmyGrid1.maxfields+pmyGrid1.minfields;
			var str=myCursorforSumup(pmyGrid1.tablename,pmyGrid1.keyfield,pmyGrid1.totalfields);
			Ext.getCmp('filtertext').setValue('');
			Ext.Ajax.request({   
				url: 'system//fn_executeSql.jsp',
				method: 'post',async:false,
     			params:{ database:sysdatabasestring, updateSql:str,selectSql:'' },									
				waitTitle : '系统提示',
				waitMsg: '正在汇总数据,请稍候...',
				callback:function(options,success,response){
					pmyTable.error=Ext.decode(response.responseText).errors;
					fnLoadmyGrid1(myGrid1.store.currentPage,'');
				}
			});		
		}		

		function uploadfile(){ //上传附件
			var records=myGrid1.getSelectionModel().getSelection();//获取gird所有选中的records
			if(records[0]){	//获取第一个record对象
			}					
		}
		
		//保存记录
		function fnSave(){   //ssssssave
			//var totalfields=pmyGrid1.sumfields+pmyGrid1.avgfields+pmyGrid1.countfields+pmyGrid1.maxfields+pmyGrid1.minfields;
			var totalfields=pmyGrid1.totalfields;
			eval(mySetSysVars());  
			//将表中可编辑字段赋值到pmyForm.editablefieldset中
			var xfields=totalfields.split(';');
			alert(totalfields);
			var updatesql='';
			for (var i=0;i<myGrid1.store.getCount();i++){
				var record=myGrid1.store.getAt(i);
				var sql='';
				for (var j=0;j<xfields.length;j++){
					if (xfields[j]!=''){
						if (sql!='') sql+=',';
						sql+=xfields[j]+"='"+record.get(xfields[j])+"'";
					}
				}
				if (sql!='') updatesql+=" update "+pmyGrid1.tablename+" set "+sql+" where "+pmyGrid1.keyfield+"='"+record.get(pmyGrid1.keyfield)+"'\n";
			}
			var rowno=pmyGrid1.index;
			var pageno=myGrid1.store.currentPage;		
       		var totalfields=pmyGrid1.sumfields+pmyGrid1.avgfields+pmyGrid1.countfields+pmyGrid1.maxfields+pmyGrid1.minfields;
			var str=myCursorforSumup(pmyGrid1.tablename,pmyGrid1.keyfield,totalfields);
       		//updatesql+="\n "+str;
       		console.log(updatesql);
			Ext.Ajax.request({   //ssssssa
				url: 'system//fn_executeSql.jsp',
				method: 'post',async:false,
     			params:{ database:sysdatabasestring, updateSql:updatesql,selectSql:'' },									
				waitTitle : '系统提示',
				waitMsg: '正在保存数据,请稍候...',
				callback:function(options,success,response){
					pmyTable.error=Ext.decode(response.responseText).errors;
					if (pmyTable.error==''){
						pmyGrid1.pageno=pageno;
						fnLoadmyGrid1(pageno,'');  
	       				//mySetCmpDisabled('cmdsave;popsave;btnsave',true);
						Ext.getCmp('filtertext').setValue('');
				    	//myFormTab.setActiveTab(0);
				    	//myFocusInTab(myFormTab);  //聚焦第一个非只读控件
       					eval(sysWait('记录已经保存成功！'+pmyTable.msg,160,100,600));
	       			}else{
						eval(sysError('发现下列错误，'+pmyGrid1.tabletitle+'保存失败！<br>'+pmyTable.error,0,0));
	       			}	           					
       			} //calback		
			});	
		}
		
		function fnReset(){ //rrrrrrr

		}
		
		function fnRefresh(){  //rrrrre刷新
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
			fnLoadmyGrid1(1,'','');
		}
		
		function fnLoadmyGrid1(pageno,wheresql){ //lllllo重新加载grid数据
			//新页面加载设置
			if (wheresql==''){
				var sql=pmyGrid1.sql;					
			}else{
				if (wheresql!='') wheresql="("+wheresql+")";
				else wheresql="(1=1)";
				var sql="select * from ("+pmyGrid1.sql+") as p where "+wheresql;
			}
			pmyGrid1.paramsql=sql;	
			//console.log(sql);
			var xpagesize=myGrid1.store.pageSize;
			var newparams={ database:sysdatabasestring, sqlString:sql,keyField:pmyGrid1.keyfield,sortField:pmyGrid1.sortfield,limit:xpagesize,totalFields:pmyGrid1.totalfields };
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
			fnLoadmyGrid1(1,xfiltersql,null);			
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
			mySetCmpDisabled(pmyForm.fileloadbutton,true);
			//显示审核图标标记
			//mySetCmpDisabled('cmdupdate;popupdate;cmddelete;popdelete',flag);
			//mySetCmpDisabled('filepathcmdup;filepathicon',true);
			//Ext.getCmp('filepathsource').setValue(Ext.getCmp('filename').getValue());
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
		fnLoadmyGrid1(1,'','');
		for (var i=1;i<=pmyForm.pagecount;i++) {
			eval(mySetFormReadOnly('myForm'+i,'true'));
		}
		
	//****************************end of extjs**************************//
			
	}); 
  
  </script>
  </body>
</html>


