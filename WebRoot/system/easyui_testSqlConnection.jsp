<%@ page language="java" import="java.util.*"  import="java.sql.*,com.DBConn" pageEncoding="utf-8"%>
<%@page import="com.StringUtil"%>
<%
	//输入一条sql语句（update, insert,delete），在后台执行该sql语句
	//从前台获取数据，使用param传递.
	String database=StringUtil.filterNull(request.getParameter("database"));
	//获取数据库连接
	String errmsg="";
	DBConn con=new DBConn();
	try{
		errmsg=con.testConnection(database);
	}catch (Exception e){
		errmsg=e.getMessage();
	}
	response.getWriter().write(errmsg);		
%>