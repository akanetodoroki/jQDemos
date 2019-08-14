<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.sql.*"%>
<%@ page import="com.DBConn" %>
<%@ page import="com.UserBean" %>
<%@ page import="com.StringUtil"%>
<%@ page import="java.io.*" %>
<%@ page import="java.io.BufferedInputStream" %>
<%@ page import="java.io.BufferedOutputStream" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="javax.xml.parsers.*,org.w3c.dom.*" %>

<%
	int userid=Integer.parseInt(request.getParameter("userid"));
	String account=StringUtil.filterNull(request.getParameter("account"));
	String username=StringUtil.filterNull(request.getParameter("username"));
	String pwd=StringUtil.filterNull(request.getParameter("pwd"));
	String unittitle=StringUtil.filterNull(request.getParameter("unittitle"));
	String unitno=StringUtil.filterNull(request.getParameter("unitno"));
	String notes=StringUtil.filterNull(request.getParameter("notes"));
	String userright=StringUtil.filterNull(request.getParameter("userright"));
	String hostname=StringUtil.filterNull(request.getParameter("hostname"));
	String sqlpassword=StringUtil.filterNull(request.getParameter("sqlpassword"));
	String logindate=StringUtil.filterNull(request.getParameter("logindate"));
	String databasestring=StringUtil.filterNull(request.getParameter("databasestring"));
	String action=StringUtil.filterNull(request.getParameter("action"));
	UserBean user = null;
	user = new UserBean(userid, account, username, pwd, unittitle, unitno, notes, userright, hostname,	sqlpassword, logindate, databasestring, action);
	session.setAttribute("user",user);
	response.getWriter().write("");
%>
