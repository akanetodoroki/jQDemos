<%@page contentType="application/x-msdownload" %>
<%@ page language="java" import="java.util.*"  import="java.sql.*,com.DBConn" pageEncoding="utf-8"%>
<%@page import="com.StringUtil" import="java.io.*" %>
<%@page import="java.io.BufferedInputStream" %>
<%@page import="java.io.BufferedOutputStream" %>
<%@page import="java.net.URLEncoder" %>
<%@ page import="net.sf.json.JSONObject"%>

<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
	String realpath=getServletContext().getRealPath("/"); 
	//从前台取数据,使用extjs的extraParams，根据sql语句获取combo选项
	request.setCharacterEncoding("ISO-8859-1");
	String filenames=StringUtil.getUrlCHN(request.getParameter("filenames"));
	filenames=DBConn.myFromXcode(filenames);
	//System.out.println("filenames="+filenames);
	String message="";
	String deletefile;
	String tmp[];
	tmp=filenames.split("	");  //tab键分割
	for (int i=0;i<tmp.length;i++){
		if (!tmp[i].equals("")){
			File file1 = new File(realpath+tmp[i]);
			//System.out.println("deletedfilename1="+realpath+tmp[i]);
			if (file1.exists()) {
				//System.out.println("deletedfilename2="+realpath+tmp[i]);
				file1.delete();
			}
		}
	}
	response.getWriter().write(message);
%>
