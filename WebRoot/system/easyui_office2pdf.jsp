<%@page contentType="application/x-msdownload" %>
<%@ page language="java" import="java.util.*"  import="java.sql.*,com.*" pageEncoding="utf-8"%>
<%@page import="com.StringUtil" import="java.io.*" %>
<%@page import="java.net.URLEncoder" %>

<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
	String realpath=getServletContext().getRealPath("/"); 
	request.setCharacterEncoding("ISO-8859-1");
	String sourcefile=StringUtil.getUrlCHN(request.getParameter("sourcefile"));
	String targetfile=StringUtil.getUrlCHN(request.getParameter("targetfile"));
	sourcefile=realpath+DBConn.myFromXcode(sourcefile);
	targetfile=realpath+DBConn.myFromXcode(targetfile);
	String fileext=sourcefile.substring(sourcefile.lastIndexOf(".")+1);
	//sourcefile="C:\\Tomcat6\\webapps\\melab\\mybase\\resources\\resource_2.doc";
	//targetfile="C:\\Tomcat6\\webapps\\melab\\mybase\\resources\\resource_2x.pdf";
	System.out.println("sourcefilename="+sourcefile);
	System.out.println("targetfilename="+targetfile);
	System.out.println("fileext="+fileext);
	String message="";
	//office2pdf file=new office2pdf();
	if (fileext.equals("doc") || fileext.equals("docx")){ 
		message=office2pdf.word2pdf(sourcefile, targetfile);
	}else if (fileext.equals("xls") || fileext.equals("xlsx")){
		//System.out.println("excel");
		message=office2pdf.excel2pdf(sourcefile, targetfile);
	}else if (fileext.equals("ppt") || fileext.equals("pptx")){
		//System.out.println("ppt="+sourcefile);
		message=office2pdf.ppt2pdf(sourcefile, targetfile);
	}
	response.getWriter().write(message.toString());
%>
