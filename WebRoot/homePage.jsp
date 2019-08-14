<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.sql.*"%>
<%@ page import="com.DBConn" %>
<%@ page import="com.UserBean" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
  <head>
    <base href="<%=basePath%>">
    <title>embase主页</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!-- ExtJS -->
	<link rel="stylesheet" type="text/css" href="ext4.0/resources/css/ext-all.css"><!-- ext系统样式 -->
	<link rel="stylesheet" type="text/css" href="system/css/icon.css"><!-- 图标文件 -->
	<script type="text/javascript" src="ext4.0/bootstrap.js"></script><!-- Ext核心源码 -->
	<script type="text/javascript" src="ext4.0/locale/ext-lang-zh_CN.js"></script><!-- 国际化文件 -->
	<script type="text/javascript" src="system/fn_function.js"></script>	<!-- 公共函数 -->
	<!-- Libraries -->
	<link type="text/css" href="system/login/css/layout.css" rel="stylesheet" />	
	<script type="text/javascript" src="system/login/js/jquery-1.3.2.min.js"></script>
	<script type="text/javascript" src="system/login/js/easyTooltip.js"></script>
	<script type="text/javascript" src="system/login/js/jquery-ui-1.7.2.custom.min.js"></script>
	<script type="text/javascript" src="system/login/js/jquery.wysiwyg.js"></script>
	<script type="text/javascript" src="system/login/js/hoverIntent.js"></script>
	<script type="text/javascript" src="system/login/js/superfish.js"></script><!-- 下拉菜单 -->
	<script type="text/javascript" src="system/login/js/custom.js"></script><!-- 下拉菜单 -->
	<script type="text/javascript" src="system/login/js/facebox.js"></script>
	<link href="system/login/js/facebox.css" media="screen" rel="stylesheet" type="text/css"/>
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	
	<style>
	.treemenu{ margin-left: 180px; }
	</style>
	<script type="text/javascript">
	jQuery(document).ready(function($) {
		  $('a[rel*=facebox]').facebox() 
	})
	</script>
  </head>
  <body>
    <%
    	UserBean user = (UserBean)session.getAttribute("user");
    	if(user == null){
    		response.sendRedirect("login.jsp");//重定向
    		return;
    	}
    	DBConn db = new DBConn();
    	Connection conn = db.getConnection("embase");
    	String result = this.getAllChildNodeByID(conn, "");
    	conn.close();
    %>
    <%!
    	public String getAllChildNodeByID(Connection conn, String keyValue) throws SQLException{
    		String itemSQL = "SELECT * FROM sys_menu WHERE ISNULL(ParentNodeID, '') = \'" + keyValue + "\'";
    		Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    		ResultSet rs = stmt.executeQuery(itemSQL);
    		StringBuffer result = new StringBuffer();
    		String menuTitle = "";
    		String menuUrl = "";
    		String menuID = "";
    		boolean isParentFlag = false;
    		String childNodeStr = "";
    		result.append("<ul>");
    		while(rs.next()){
    			menuTitle = rs.getString("MenuTitle");
    			menuID = rs.getString("MenuID");
    			menuUrl = rs.getString("MenuUrl");
    			isParentFlag = false;
    			if(rs.getInt("isParentFlag") == 1)isParentFlag = true;
    			result.append("<li>");
    			if(!"".equals(menuUrl)){
    				result.append("<a href='" + menuUrl + "' target='mainContent'>");
    			}
    			else{
    				result.append("<a>");
    			}
    			result.append(menuTitle);
    			result.append("</a>");
    			if(isParentFlag){    				
    				childNodeStr = this.getAllChildNodeByID(conn, menuID);
    				if(!"".equals(childNodeStr)){
    					result.append(childNodeStr);
    				}
    			}
    			result.append("</li>");
    		}
    		result.append("</ul>");
    		return result.toString();
    }
    %>
    <div id="admin" name="admin" style="display:none">
   		<h2>Welcome, <%= user.getUsername() %>!</h2>
   		<div style="border-top:1px solid #ccc;height: 10px;"></div>
   		<p>编号：<%= user.getUserID() %><br/>
   			账号：<%= user.getAccount() %><br/>
   			用户名：<%= user.getUsername() %><br/>
   			密码:<%= user.getPassword() %><br/>
   			附注：<%= user.getNotes() %><br/>
   	</div>   	
    <div id="container">
    	<div id="header">
    		<!-- Top -->
    		<div id="top">    		
    			<!-- Logo -->
    			<div class="logo"> 
    				<a href="<%= request.getRequestURI() %>" title="Administration Home" class="tooltip"><img src="system/login/assets/logo.png" alt="Wide Admin" /></a> 
    			</div>
				<!-- End of Logo -->					
				<!-- Meta information -->
				<div class="meta">
					<p>Welcome, <a href="<%= request.getRequestURI() %>#admin" rel="facebox"><%= user.getUsername() %></a></p>
					<ul>
						<li><span title="End administrator session" class="tooltip" id="signout"><span class="ui-icon ui-icon-power"></span>注销</span></li>
						<li><a href="#" title="Change current settings" class="tooltip"><span class="ui-icon ui-icon-wrench"></span>设置</a></li>
						<li><a href="<%= request.getRequestURI() %>#admin" rel="facebox" title="Go to your account" class="tooltip"><span class="ui-icon ui-icon-person"></span>我的账户</a></li>
					</ul>	
				</div>
				<!-- End of Meta information -->
    		</div>
    		<!-- End of Top-->
			
			<!-- The navigation bar -->
			<div id="navbar"><!-- 导航条 -->
			</div>
			<!-- End of navigation bar -->		
    	</div><!-- End of Header -->
    	
    	<div id="content">
    		<div id="sidebar"></div>
    		<div id="main" class="treemenu">
	    		<div id="loadingMask">
					<div id="loadingText">
						<img src="system/login/assets/twirl.gif" alt="" />
						<div>正在加载……</div>
					</div>
				</div>
    			 <iframe id="mainContent" name="mainContent" frameborder="0" scrolling="no" width="100%" height="100%" src="mainMenu.jsp"></iframe>
  			</div>
    	</div>   	
    </div>
    <script type="text/javascript">
		var winWidth = 0;
		var winHeight = 0;
		//获取窗口宽度
		if (window.innerWidth)//Internet Explorer,Chrome,Firefox,Opera,Safari;
			winWidth = window.innerWidth;
		else if ((document.body) && (document.body.clientWidth))//Internet Explorer 8,7,6,5
			winWidth = document.body.clientWidth;
		//获取窗口高度
		if (window.innerHeight)
			winHeight = window.innerHeight;
		else if ((document.body) && (document.body.clientHeight))
			winHeight = document.body.clientHeight;
		//通过深入Document内部对body进行检测，获取窗口大小
		if (document.documentElement && document.documentElement.clientHeight && document.documentElement.clientWidth){
			winHeight = document.documentElement.clientHeight;
			winWidth = document.documentElement.clientWidth;
		}
		document.getElementById('content').style.height = winHeight-document.getElementById('header').clientHeight+'px';
		document.getElementById('loadingMask').style.height = winHeight-document.getElementById('header').clientHeight+'px';

		//设置菜单
		Ext.get('navbar').dom.innerHTML = "<%= result %>";//注意添加引号
		Ext.query('#navbar>ul')[0].className = 'nav';
		//这段代码本来在custom.js中,需放在这里,不然鼠标移出后菜单消失
		//菜单和导航条的间距,一级菜单和二级菜单之间的间距在core.css .sfHover里调整
		$(function(){
			$("ul.nav").superfish({
				animation:{
				height: "show",//纵向展开
				width: "show",//横向展开
				}, speed : 200//展开速度,成反比
			});
		});

		Ext.onReady(function(){			
			var iframeName = "mainContent";
			var maxReturnNumber = 1000;
			var treeSQL = "select MenuID,menuTitle,MenuTitle as nodeText,MenuUrl as href,ParentNodeID,IsparentFlag,level from sys_menu";			
			Ext.regModel('treeModel',{
				fields: [
					{name: 'cid', type: 'string'},
					{name: 'text', type: 'string'},
					{name: 'menuid', type: 'string'},
					{name: 'menutitle', type: 'string'},
					{name: 'href', type: 'string'},
					{name: 'hrefTarget', type: 'string',defaultValue: iframeName},
					{name: 'parentnodeid', type: 'string'},
					{name: 'isparentflag', type: 'int'},
					{name: 'level', type: 'int'}
				]
			});
			
			var myTreeStore = Ext.create('Ext.data.TreeStore',{
				model: 'treeModel',
				selectedCode: '',//增删改需要记录的节点编码
				rootCode: '',//需要分层展开的父节点
				proxy: {
					url: 'system//fn_getTreeNodes.jsp',
					type: 'ajax',
					extraParams: {maxReturnNumber:maxReturnNumber,keyField:'menuid',sqlString:treeSQL,searchText:''},
					reader: {
						type: 'json'
					}
				},
				root: {
					text: '主界面',
					id: 'root',
					expanded: true,
					href: 'mainMenu.jsp',
					hrefTarget: iframeName
				},
				autoLoad: true
			});
			
			Ext.util.CSS.createStyleSheet(".myTreeCSS1 {height: 26px; vertical-align: middle;}", 'treeCSS');
			//Ext.util.CSS.createStyleSheet("#myTree table{border-spacing: 0 10px;}", 'treeCSS');
			Ext.util.CSS.createStyleSheet("#myTree-body{border: 0px;}", 'treeCSS')
			//导航树
			var myTree = Ext.create('Ext.tree.Panel', {
				id: 'myTree',
				//region: 'west',
				renderTo: 'sidebar',
				//改本页treemenu
				width: 180,  //同时修改system/login/css/core.css中的.treeExpand{margin-left: 200px;}
				height: '100%',
				store: myTreeStore,
				titleCollapse : true,
				//cls: '{font-family:Arial, Century Gothic, Lucida Grande, 微軟正黑體, 微软雅黑;font-style:italic; }',
				rootVisible: false, //important!
				useArrows: true,
				animate: false,
				frame: true,
				collapsible: true,
				collapseDirection: 'left',
				title: '主菜单',
				split: true,
				viewConfig: {
					getRowClass: function(record, rowIndex, rowParams, store){
						return "myTreeCSS1";
					}
				},
				listeners: {
					itemmouseenter: function(view, record, item, index, e){
						this.store.rootCode = record.raw.cid;
						this.store.selectedCode = '';
					},
					itemclick: function(record, item){
						if (item.get('isparentflag')==0){
							//Ext.get('loadingMask').show();  //显示加载的符号
							//Ext.get('mainContent').show({duration: 0, to:{opacity: 1}});
						}	
					},
					beforeload:function(store) {//添加加载前事件
						var newparams={maxReturnNumber:maxReturnNumber,rootCode:this.store.rootCode,selectedCode:this.store.selectedCode};
						Ext.apply(store.proxy.extraParams,newparams);
						store.proxy.url='system//fn_getTreeNodes.jsp';	
					},
					collapse: function(panel){//改变DIV#main的宽度
						//document.getElementById('main').style.width = document.getElementById('content').clientWidth-panel.width+'px'
						var newWidth = document.documentElement.clientWidth-panel.width+'px';						
						//Ext.get('main').dom.style = "margin-left:"+panel.width+'px';//无效
						Ext.get('main').setStyle("margin-left",panel.width+'px');
						Ext.get('main').animate({to: {width: newWidth}});
					},
					expand: function(panel){//改变DIV#main的宽度
						//document.getElementById('main').style.width = document.getElementById('content').clientWidth-panel.width+'px'
						var newWidth = document.documentElement.clientWidth-panel.width+'px';
						Ext.get('main').setStyle("margin-left",panel.width+'px');
						Ext.get('main').animate({to: {width: newWidth}});
					},
					select: function(model, record, index){
						//console.log(this.getRootNode());						
						var title = [];						
						var node = this.store.getRootNode().findChild('cid', record.raw.cid, true);
						if(node){
							var pnode = node.parentNode;
							while(pnode != this.store.getRootNode()){
								title.push(pnode.raw.menutitle);
								pnode = pnode.parentNode;
							}
							var text = "主界面";
							//for(i=title.length-1; i>=0; i--){
								//text += " >> " + title[i];
							//}
							//text += " >> " + record.get("menutitle");
							this.setTitle(text);
						}
					}
				}		
			});
			/*
			var myPanel = Ext.create('Ext.panel.Panel', {
				region: 'center',
				html: ' <iframe id="mainContent" frameborder="no" width="100%" height="100%"></iframe>'
			});
			
			Ext.create('Ext.panel.Panel', {
				width: '100%',
				height: '100%',
				renderTo: 'content',
				layout: {
		            type: 'border',
		            padding: 5
		        },
		        defaults: {
		            split: true
		        },
		        items: [myTree,myPanel]
			});*/
			
			//注销
			Ext.get("signout").on("click", function(e){
				Ext.Ajax.request({
					url: 'system//fn_loginSignOut.jsp',
					params: {action: "signout"},
					method: 'POST',
					callback: function(options,success,response){
						if(response.responseText.replace(/(^\s*)|(\s*$)/g, "") == 'success'){
							window.location = "/embase/login.jsp";
						}
					}
				});
			});

			//控制DIV#main的宽度
			document.getElementById('main').style.width = document.getElementById('content').clientWidth-document.getElementById('myTree').clientWidth+'px';
			//console.log(document.getElementById('main').style.width);	
			//浏览器调整大小时更改DIV#main的宽度
			window.onresize = function(){
				document.getElementById('main').style.width = document.getElementById('content').clientWidth-document.getElementById('myTree').clientWidth+'px';
			}

			//遮罩效果
			Ext.get('mainContent').dom.onload = function(){
				setTimeout(function(){
					Ext.get('loadingMask').hide();
				}, 0);
			};
		});
	</script>
  </body>
</html>

