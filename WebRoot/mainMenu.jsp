<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.sql.*"%>
<%@ page import="com.DBConn" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">    
    <title></title>    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">	
	<link rel="stylesheet" href="system/login/font-awesome/css/font-awesome.css" />
	<link rel="stylesheet" href="system/login/css/mainMenu.css" />
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
  </head>  
  <body>
   <%
    	DBConn db = new DBConn();
    	Connection conn = db.getConnection("embase");
    	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    	ResultSet rs = stmt.executeQuery("SELECT * FROM sys_menu WHERE level = 2");
    	String[] classes = {"green","red","blue","yellow","purple"};
    	String[] icons = {"icon-home","icon-cogs","icon-twitter","icon-beaker","icon-envelope"};
    	int i = 0,j = 0;
    %>
  	<div id="colorNav">
  		<ul>
  			<%
	  			while(rs.next()){
					String menuID = rs.getString("MenuID");
					String menuTitle = rs.getString("MenuTitle");
					String menuUrl = rs.getString("MenuUrl");
	  			}
  			%>
  		</ul>
  	</div>
  </body>
</html>
