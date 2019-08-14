<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="com.DBConn" %>
<%@ page import="com.UserBean" %>
<html>
	<header>
		<link rel="stylesheet" type="text/css" href="ext4.2/resources/css/ext-all.css">  <!-- ext系统样式 -->
		<link rel="stylesheet" type="text/css" href="system/css/mystyle.css"> <!-- ext图标文件 -->
		<script type="text/javascript" src="ext4.2/ext-all.js"></script>  <!-- Ext核心源码 -->
		<script type="text/javascript" src="ext4.2/locale/ext-locale-zh_CN.js"></script>  <!-- 国际化文件 -->
		<script type="text/javascript" src="system/decimalfield.js"></script>   <!-- 自定义加零数值型控件 -->
		<script type="text/javascript" src="system/fn_function.js"></script>  <!-- 公共函数 -->
		<script type="text/javascript" src="system/fn_dspOrder.js"></script>
		<script type="text/javascript" src="system/fn_dspCustomer.js"></script>
	</header>
	<body>
		<%
		UserBean user = (UserBean)session.getAttribute("user");
		if(user == null){
			//response.sendRedirect("login.jsp");  //重定向导致重新登录时页面嵌入到iframe里			
			//out.println("<script type='text/javascript' src='fn_commonHeader.js'></script>");
			out.println("<script>Ext.onReady(function(){if(window.top!=window.self){window.top.location.href='login.jsp';}else{window.location.href='login.jsp';}});</script>");			
			return;
		}	
		%>
	</body>
</html>

