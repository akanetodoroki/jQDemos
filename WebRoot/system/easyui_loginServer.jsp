<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.sql.*"%>
<%@ page import="com.UserBean" %>
<%@ page import="com.StringUtil"%>
<%@ page import="java.io.*" %>

<%
	String userid=StringUtil.filterNull(request.getParameter("userid"));
	String useraccount=StringUtil.filterNull(request.getParameter("useraccount"));
	String username=StringUtil.filterNull(request.getParameter("username"));
	String userpassword=StringUtil.filterNull(request.getParameter("userpassword"));
	String usertype=StringUtil.filterNull(request.getParameter("usertype"));
	String userright=StringUtil.filterNull(request.getParameter("userright"));
	String userlogindate=StringUtil.filterNull(request.getParameter("userlogindate"));
	String usernotes=StringUtil.filterNull(request.getParameter("usernotes"));
	String action=StringUtil.filterNull(request.getParameter("action"));	
	String flag=StringUtil.filterNull(request.getParameter("flag"));	
	UserBean user = null;
	//session.setMaxInactiveInterval(15);//设置session有效时长为15秒
	user = new UserBean(
		userid, 
		useraccount, 
		username, 
		userpassword, 
		usertype, 
		userright,
		userlogindate,
		action, 
		flag,
		usernotes
	);
	session.setAttribute("user",user);
	//System.out.println("user="+username);
	response.getWriter().write("");
%>
