<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="com.DBConn" %>
<%@ page import="com.UserBean" %>
<%@ page import="com.StringUtil"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>TForm模板</title>
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
 		//var xmlSrc = 'xml/pCustomerEdit.xml';
		//var myCompiler = new Compiler();
		//var p = myCompiler.compiler(xmlSrc);
		var p=window.top.p;  //从主菜单程序中获取
  		var pmyTable={};  //提取数据表
		var pmyForm={}; //定义表单，一个tab对应一个form
		var pmyService={};
		pmyService.sysdatabasestring=sysdatabasestring; //传递到fn_function.js
		pmyService.sysdate=sysdate;
		pmyTable.sysdatabasestring=sysdatabasestring; //传递到fn_function.js
		pmyForm.sysdatabasestring=sysdatabasestring; //传递到fn_function.js
  		if (p.table!=undefined) pmyTable=myGetTableAttrs(p.table[0],pmyTable);  //获取table值
		if (p.form!=undefined) pmyForm=myGetFormAttrs(p,pmyForm);
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
		//存储grid中combo之类的sql语句，bbar等
		eval(pmyForm.gridcmpstr);
		//生成编译得到的控件和事件		
		eval(pmyForm.tabstr); //定义表单myForm*
		eval(pmyForm.groupboxstr); //定义表单中的groupbox控件
		eval(pmyForm.fieldstr); //定义表单ffffff中的其他控件textfield,combo,datefield
		//将没有定义的列定义到myForm1
	 	pmyForm.fieldset=myGetSQLFields(pmyForm.sql);
		eval(myAddHiddenFields(pmyForm.fieldset,'myForm1'));
		eval(myAddHiddenFields(pmyForm.hiddenfields,'myForm1'));
		eval(myDefineHiddenField('myForm1','addoredit'));
		eval(pmyForm.eventstr); //定义事件在hidden字段之后
		pmyTable.index=1;
		pmyTable.totalcount=0;
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
			eval(myDefineCheckMenu('myFilterCheckMenu',mtitle));
		}	
		var tbar=Ext.create('Ext.toolbar.Toolbar',{region:'north',split:false,id:'tbar'});
		tbar.add({xtype:'tbspacer',width:2});
		if (pmyForm.modal!='window'){
			tbar.add({id:'cmdbar', xtype:'tbseparator'});
			tbar.add({id:'cmdadd', iconCls: 'addIcon',text: '新增',handler: fnAddRecord,tooltip: '增加新记录',xaction:'add'});
			tbar.add({id:'cmdupdate', iconCls: 'editIcon',text: '修改',handler: fnEditRecord,tooltip: '修改当前记录',xaction:'update'});
			tbar.add({id:'cmddelete', iconCls: 'deleteIcon',text: '删除',handler: fnDeleteRecord,tooltip: '删除当前记录',xaction:'delete'});
			tbar.add({id:'reviewbar1', xtype:'tbseparator'});
			tbar.add({id:'cmdreview', iconCls: 'checkIcon',text: '审核',handler: fnReviewRecord,tooltip: '审核当前记录',xaction:'review'});
			tbar.add({id:'editbar1', xtype:'tbseparator'});
			tbar.add({id:'cmdsave', iconCls: 'saveIcon',text: '保存',handler: fnSaveRecord,tooltip: '保存正在修改或新增的记录',xaction:'save'});
			tbar.add({id:'savebar1', xtype:'tbseparator'});
			tbar.add({id:'cmdprint', iconCls: 'printerIcon',text: '打印',handler: fnPrintRecord,tooltip: '打印'+pmyTable.tabletitle,xaction:'print'});
			tbar.add({id:'printbar1', xtype:'tbseparator'});
		    tbar.add({id:'cmdrefresh', iconCls: 'refreshIcon',text: '刷新', id:'refresh',name:'refresh',handler: fnRefreshRecord,tooltip: '刷新全部'});
	    }
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
	    	{xtype:'menuseparator',id:'printbar2'},
			{id:'popprint', iconCls: 'printerIcon',text: '打印',handler: fnPrintRecord,tooltip: '打印'+pmyTable.tabletitle,xaction:'print'},
	    	{xtype:'menuseparator',id:'resetbar1'},
	        {text:'重置',id:'popreset',iconCls:'resetIcon',handler:fnResetRecord},
	    	{xtype:'menuseparator',id:'refreshbar2'},
	        {text:'刷新',id:'poprefresh',iconCls:'refreshIcon',handler:fnRefreshRecord}
	    ]});	
		//可编辑grid中的右键菜单
 		var myEditWin=Ext.create('Ext.window.Window', {
			height: pmyForm.height+64+26, //高度
			width: pmyForm.width+6, //宽度
			closeAction: 'hide',//关闭按钮 效果是隐藏当前窗体
			modal:true,
			tbar:tbar,
			resizable:false,
			layout: 'absolute',//布局方式
			buttons:[
				{text:'保存',id:'btnsave', height:25,handler:function(){ fnSaveRecord(); }},
				{text:'取消',id:'btnclose',height:25,handler:function(){ myEditWin.hide(); }}
			],	
			listeners:{
				show:function(){
					//
				}
			}
		});
		//定义页面布局
		eval(myDefineTab('myFormTab','','north','['+pmyForm.panels+']',pmyForm.height,pmyForm.width,'false','myContextMenu1'));
		if (pmyForm.modal=='window'){
			//只有一个表单时去掉window中的formpanel标题
			if (pmyForm.pagecount>1) myEditWin.add(myFormTab);
			else myEditWin.add(myForm1);
		}else{	
			var myView=Ext.create('Ext.Viewport', {
			       layout: { type: 'border', padding: 5 },
			       defaults: { split: true },
			       items: [ tbar,myFormTab ]
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
			mySetCmpVisible('cmdbar;popinsertitem;popappenditem;popdeleteitem;popresetitem;popsaveitem;savebar3;resetbar1',false);
		}
		/**************************定义tree结束***********************************/
		/**************************以下是函数************************************/
		//tabchange事件
		myFormTab.on('tabchange',function(tabPanel,newCard,oldCard,eOpts ){
	    	myFocusInTab(tabPanel);  //聚焦第一个非只读控件 					
		});
		function fnPrintRecord(){  //ppppppp
			var date=sys.year+'年'+sys.month+'月'+sys.day+'日';
			var xtemplate="TCustomerQuery.xls";
			var xsql=" select customerid,customername,address,province,city,zip,phone,fax,homepage,contactname,employeename";
			xsql+=" from ("+pmyForm.sql+") as p";
			xsql+=" order by "+pmyTable.sortfield;
			//console.info(xsql);
			var xtitlecells="<2,1>"+date;
			var xtitlerange="<1>-<3>";  //标题为第1行到第4行，每页重复
			var xtargetfilename="客户基本信息列表.xls";
			var r=myExportExcelReport(xtemplate,xsql,xtitlecells,xtitlerange,'','',xtargetfilename);		
		}
		
		function fnAddRecord(){//新增 aaaaaa
			Ext.getCmp('addoredit').setValue('1');
       		for (var i=1;i<=pmyForm.pagecount;i++) {
       			eval("myForm"+i+".getForm().reset();");
       			eval(mySetFormReadOnly('myForm'+i,'false'));
       		}	
       		Ext.getCmp(pmyTable.keyfield).setReadOnly(false);
			mySetCmpDisabled('cmdsave;popsave;btnsave;popreset',false);	
			mySetCmpDisabled('cmdupdate;popupdate;cmddelete;popdelete;cmdreview;popreview',true);
			mySetCmpDisabled(pmyForm.fileloadbutton,true);
			Ext.getCmp('sys_checkedimage').setVisible(false);  //
			if (pmyTable.document.datefield!=''){
				Ext.getCmp(pmyTable.document.datefield).setValue(sysdate);
			}
			eval(mySetsysVarsReadOnly(true));
			//mySetCmpDisabled('filepathcmdup;filepathicon',true);
			if (pmyForm.modal=='window'){
				myEditWin.setTitle('新增'+pmyTable.tabletitle);
				//myEditWin.show();
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
       		if (pmyTable.totalcount>0){	
       			Ext.getCmp(pmyTable.keyfield).setReadOnly(true);
       		}else{
       			//修改空记录按新增记录处理
				Ext.getCmp('addoredit').setValue('1');
       		}
			mySetCmpDisabled('cmdupdate;popupdate;cmddelete;popdelete;cmdsave;popsave;btnsave;popreset',false);
			mySetCmpDisabled('cmdreview;popreview',true);
			//mySetCmpDisabled('filepathcmdup;filepathicon',false);
			mySetCmpDisabled(pmyForm.fileloadbutton,false);
			if (pmyForm.modal=='window'){
				myEditWin.setTitle('修改'+pmyTable.tabletitle);
				//myEditWin.show();
			}
	    	//myFormTab.setActiveTab(0);
	    	myFocusInTab(myFormTab);  //聚焦第一个非只读控件       		
		}
		
		function fnReviewRecord(){  //rrrrr审核
			Ext.getCmp('addoredit').setValue('3');
			if (Ext.getCmp(pmyTable.document.reviewflag)!=null){
				if (Ext.getCmp(pmyTable.document.reviewflag).getValue()==''){
					Ext.getCmp(pmyTable.document.reviewflag).setValue(sysusername);
					var flag=true;
				}else{
					Ext.getCmp(pmyTable.document.reviewflag).setValue('');
					var flag=false;
				}
				Ext.getCmp('sys_checkedimage').setVisible(flag);  //
				mySetCmpDisabled('cmdupdate;popupdate;cmddelete;popdelete',flag);
				mySetCmpDisabled('cmdsave;popsave;btnsave',false);  //可以保存
			}	
		}
		
		function uploadfile(){ //上传附件
		
		}
		
		//保存记录
		function fnSaveRecord(){   //ssssss
			var xid=Ext.getCmp(pmyTable.keyfield).getValue();
			var xaddoredit=Ext.getCmp('addoredit').getValue();
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
				updatesql+=" update "+pmyTable.tablename+" set "+pmyTable.document.reviewflag+"='"+Ext.getCmp(pmyTable.document.reviewflag).getValue()+"' where "+pmyTable.keyfield+"='"+xid+"' \n";
				//console.log(updatesql);
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
		        		updatesql="if (select count(*) from "+pmyTable.tablename+" where "+pmyTable.keyfield+"='"+xid+"')=0";
	        			updatesql+=" begin \n"
		        		updatesql+=myGenInsertSql(pmyTable.tablename,pmyForm.editablefieldset,pmyForm.fieldtext);
	        			updatesql+="\n end \n";
		    	    }else{  //修改记录
						//根据表单值和可编辑字段，生成update语句
						updatesql=myGenUpdateSql(pmyTable.tablename,pmyForm.editablefieldset,pmyForm.fieldtext,pmyTable.keyfield,xid);
		        		if (pmyTable.document.reviewflag!=''){
							updatesql+=" and ("+pmyTable.document.reviewflag+"='' or "+pmyTable.document.reviewflag+" is null) \n";
		        		}
	        		}
					var querysql="select count(*) as 'rowno' from "+pmyTable.tablename+" where "+pmyTable.keyfield+"='"+xid+"' ";
					if (pmyTable.document.reviewflag!='') querysql+=" and ("+pmyTable.document.reviewflag+"='' or "+pmyTable.document.reviewflag+" is null) \n";        	
	        	}  //error!=''
	        }  //if addoredit	
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
	       				Ext.getCmp('addoredit').setValue('2');
	       				mySetCmpDisabled('cmdsave;popsave;btnsave;popreset',true);
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
		
		function fnDeleteRecord(){ //删除dddddde
			var xid=Ext.getCmp(pmyTable.keyfield).getValue();
			var updatesql='delete '+pmyTable.tablename+' where '+pmyTable.keyfield+"='"+xid+"'";
			var querysql='';
			pmyTable.msg='';
			pmyTable.error='';
			if (pmyTable.document.reviewflag!=''){
				updatesql+=" and ("+pmyTable.document.reviewflag+"='' or "+pmyTable.document.reviewflag+" is null) \n";
	        	querysql+=" select top 1 "+pmyTable.document.reviewflag+" as 'reviewflag' from "+pmyTable.tablename+" where "+pmyTable.keyfield+"='"+xid+"' ";
				querysql+=" and ("+pmyTable.document.reviewflag+"<>'' and "+pmyTable.document.reviewflag+" is not null) \n";
			}	
			Ext.MessageBox.show({   
	            title: '系统提示',   
	            msg: mySpace(2)+'删除'+pmyTable.tabletitle+'<font color=blue><b>【'+xid+'】</b></font>这条记录。'+mySpace(10)+'<br><br>'+mySpace(2)+'是否确认？<br><br>' , 
	            icon: Ext.MessageBox.QUESTION,  //icon: Ext.MessageBox.INFO  
	            buttons: Ext.Msg.YESNO,
	            fn: function(btn){
	            	if (btn=='yes'){
			            Ext.Ajax.request({
				        	url:'system/fn_executeSql.jsp',
							params:{ database:sysdatabasestring, updateSql:updatesql,selectSql:querysql },									
				        	method: 'POST',async:false,
				        	callback:function(options,success,response){
								var reviewflag=Ext.decode(response.responseText).reviewflag;
								pmyTable.error=Ext.decode(response.responseText).errors;
								if (reviewflag!=undefined && reviewflag!=''){
									pmyTable.error+="<br>"+pmyTable.tabletitle+"<b>["+xid+"]</b>已由<b>"+reviewflag+"</b>审核，无法修改！";
								}
								if (pmyTable.error==''){
				       				Ext.getCmp('addoredit').setValue('2');
				       				mySetCmpDisabled('cmdsave;popsave;btnsave',true);
									Ext.getCmp('filtertext').setValue('');
			       					eval(sysInfo('记录已经成功删除！<br>'+pmyTable.msg,0,0));
									pmyTable.totalcount--;
									if (pmyTable.totalcount>0){
										if (pmyTable.index>pmyTable.totalcount) pmyTable.index=pmyTable.totalcount;
										fnLoadRecord(pmyTable.index);
									}else{
										for (var i=1;i<=pmyForm.pagecount;i++){
						    	   			eval("myForm"+i+".getForm().reset();");
							       		}
							       	}
							    	myFormTab.setActiveTab(0);
							    	myFocusInTab(myFormTab);  //聚焦第一个非只读控件
				       			}else{
									eval(sysError('发现下列错误，'+pmyTable.tabletitle+'删除失败！<br>'+pmyTable.error,0,0));
				       			}
				       		} //callback		           					
						});	//ajax            	
		            }// if btn
				}//fn
			});  //messagebox
		}
		
		function fnRefreshRecord(){  //rrrrre刷新
			Ext.getCmp('filtertext').setValue('');
			fnLoadRecord(pmyTable.index);
		}

		function fnResetRecord(){   //rrrrrreset
			if (Ext.getCmp('addoredit').getValue()=='2'){
				var s=Ext.getCmp(pmyTable.keyfield).getValue();
				for (var i=1;i<=pmyForm.pagecount;i++) {
	       			eval("myForm"+i+".getForm().reset();");
	       		}
	       		Ext.getCmp(pmyTable.keyfield).setValue(s);
       		}
		}
				
		//快速过滤函数
		function fnQuickFilter(){
			var xfilter=Ext.getCmp('filtertext').getValue();
			var xfiltersql=myGetFilterSql(myFilterCheckMenu,xfilter);  //获取过滤条件
			pmyTable.index=1;
			fnLoadRecord(1);
		}

		function fnKeyEvent(field,e) {
			myKeyEvent(field,e,myFormTab);  //笤俑functions中的函数
		}		
		
		function fnMoveRecord(id){
			var k=pmyTable.index;
			var n=pmyTable.totalcount;
			if (id=='rowfirst') k=1;
			else if (id=='rowlast') k=n;
			else if (id=='rownext') k++;
			else if (id=='rowprev') k--;
			if (k<1) k=1;
			if (k>n) k=n;
			pmyTable.index=k;
			fnLoadRecord(k);
		}	
		
		function fnLoadRecord(n){  //llllll
			mySetCmpDisabled('rowfirst;rownext;rowlast;rowprev',true);
			mySetCmpDisabled('cmdadd;popadd;cmdupdate;popupdate;cmddelete;popdelete;cmdprint;popprint',false);
			mySetCmpDisabled('popreset;popsave;cmdsave;btnsave',true);
			var rowcount=0;
			var xfilter=Ext.getCmp('filtertext').getValue();
			var xfiltersql=myGetFilterSql(myFilterCheckMenu,xfilter);  //获取过滤条件
			if (xfilter!=''){
				var sql0="select * from ("+pmyForm.sql+") as p where "+xfiltersql;
			}else{
				var sql0=pmyForm.sql;
			}
			var sql="select top 1 * from ("+sql0+") as p \n";
			sql+=" where "+pmyTable.keyfield+" not in (select top "+(n-1)+" "+pmyTable.keyfield+" from ("+sql0+") as p) \n";
			sql+=sys.sqltab+" select count(*) as 'sysrowcount' from ("+sql0+") as p";
			//console.log(sql);
			Ext.Ajax.request({   
				url: 'system//fn_executeSql.jsp',
				method: 'post',async:false,
     			params:{ database:sysdatabasestring, updateSql:'',selectSql:sql },									
				waitTitle : '系统提示',
				callback:function(options,success,response){
					pmyTable.totalcount=Ext.decode(response.responseText).sysrowcount;
					for (var i=1;i<=pmyForm.pagecount;i++) {
       					//eval("myForm"+i+".getForm().reset();");
						var xfielddim=eval("myForm"+i+".getForm().getFields()");
						for (var j=0;j<xfielddim.length;j++) {
							var f=xfielddim.items[j].getId();
							var value=eval("Ext.decode(response.responseText)."+f);
							if (Ext.getCmp(f)!=null && value!=undefined) {
								Ext.getCmp(f).setValue(value);
							}
						}
					}//i			
				}	
			});
			if (pmyTable.index>1){
				Ext.getCmp('rowfirst').setDisabled(false);
				Ext.getCmp('rowprev').setDisabled(false);
			}
			if (pmyTable.index<pmyTable.totalcount){
				Ext.getCmp('rowlast').setDisabled(false);
				Ext.getCmp('rownext').setDisabled(false);
			}
       		for (var i=1;i<=pmyForm.pagecount;i++) {
       			eval(mySetFormReadOnly('myForm'+i,'true'));
       		}	
		}	

		//初始化ccccc
		mySetCmpDisabled('cmdadd;popadd;cmdupdate;popupdate;cmddelete;popdelete;cmdprint;popprint',false);
		mySetCmpDisabled('cmdsave;popsave;btnsave;popreset',true);
		mySetCmpDisabled('rowfirst;rownext;rowlast;rowprev',true);
		mySetCmpDisabled(pmyForm.fileloadbutton,false);
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
		for (var i=1;i<=pmyForm.pagecount;i++) {
			eval(mySetFormReadOnly('myForm'+i,'true'));
		}
		fnLoadRecord(1);
		myEditWin.setTitle(pmyTable.tabletitle+'管理');
		if (pmyForm.modal=='window') myEditWin.show();
	//****************************end of extjs**************************//
			
	}); 
  
  </script>
  </body>
</html>


