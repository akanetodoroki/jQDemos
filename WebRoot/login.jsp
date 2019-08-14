<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.*"  import="java.sql.*,com.DBConn" pageEncoding="utf-8"%>
<%@page import="com.StringUtil"%>
<%@ include file="../src/com/UserBean.java"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<title>移动互联网实验室</title>
	<script type="text/javascript" src="javascript/login.js?time=New Date()"></script>
	<style>
		.xpanel-headerx{
			padding:7px;  //改变header的高度,原值为5
			line-height:15px;
			//color: #15428b;
			font-weight:bold;
			font-size:12px;
			background:	#D2E9FF; //#99BBE8; //orange; //#fafafa;
			//background:url('images/panel_title.png') repeat-x;
			position:relative;
			border:1px solid #15428b; //#99BBE8;
			border-bottom:0px;  //没有底线
		}
		.xpanel-bodyx { 
			border:1px solid #15428b; //#99BBE8; 
			background-color: #ffffff; 
			color: #000000; 
			font-size: 13px;} //#99BBE8
	</style>
</head>
<body>
<%
	request.setCharacterEncoding("ISO-8859-1");
	uri=request.getParameter("uri"); //不能加var，因为在_bean中已经定义了uri变量
	//out.println(uri);
	if (user == null){
		//out.println("<script>$(document).ready(function(){if(window.top!=window.self){window.top.location.href='login.jsp';}else{window.location.href='login.jsp';}});</script>");			
		//return;
	}
	action="login";
%>
<div id="main" style="margin:2px 2px 2px 2px;">
</div>
<script>
	sys.userid='<%=userid %>';
	sys.useraccount='<%=useraccount %>';
	sys.username='<%=username %>';
	sys.userpassword='<%=userpassword %>';
	sys.usertype='<%=usertype %>';
	sys.userright='<%=userright %>';
	sys.userlogindate='<%=userlogindate %>';	
	sys.notes='<%=notes %>';
	sys.flag='<%=flag %>';
	sys.action='<%=action %>';
</script>
</body>
</html>
