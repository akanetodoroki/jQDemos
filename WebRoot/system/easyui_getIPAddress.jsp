<%@page contentType="application/x-msdownload" %>
<%@page language="java" import="java.util.*" pageEncoding="utf-8" %>
<%@page import="com.StringUtil" import="java.io.*" %>
<%@page import="java.net.InetAddress" %>
<%@page import="java.net.URLEncoder" %>
<%
	//输入两个参数：一个源文件名称sourcefile，一个目标文件名targetfile
	String root = application.getRealPath("/");
	InetAddress addr = InetAddress.getLocalHost();
	String ip = addr.getHostAddress().toString();
	response.getWriter().write("{\"ipaddress\":\""+ip+"\"}");
	//System.out.println("ip="+ip);
	System.out.println("{\"ipaddress\":\""+ip+"\"}");	
%>

