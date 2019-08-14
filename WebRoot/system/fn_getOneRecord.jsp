<%@ page language="java" import="java.util.*"  import="java.sql.*,com.DBConn" pageEncoding="utf-8"%>
<%@page import="com.StringUtil"%>
<%
	//System.out.println("onerecord");
	//从前台取数据，使用params
	String database=StringUtil.filterNull(request.getParameter("database"));
   	String sqlString=StringUtil.filterNull(request.getParameter("sqlString"));//获取主键值
   	String keyField=StringUtil.filterNull(request.getParameter("keyField"));//获取主键值
	//String sqlString=StringUtil.getUrlCHN(request.getParameter("sqlString")); 
   	//System.out.println(sqlString);
	//数据库连接
	DBConn con = new DBConn();
	Connection connection = con.getConnection(database);
	Statement stmt = connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
	StringBuffer result = new StringBuffer();//创建一个stringbuffer 对象用于存放 最终返回结果
	//查询所有供货商信息
	ResultSet rs =stmt.executeQuery(sqlString);
	ResultSetMetaData rsmd=rs.getMetaData();
	rs.last();
	int rowCount=rs.getRow();
   	//System.out.println(sqlString);
	int colCount=rsmd.getColumnCount();		
	String field;
	String str="";
	int j=0;
	if (rowCount>0){
		str="{rowCount:1";
		for (j=1;j<=colCount;j++) {
		field=rsmd.getColumnName(j).toLowerCase();
	    if (j>-1) str=str+",";
	    	str=str+field+":\""+StringUtil.filterNull(rs.getString(field)).trim().replace("'","\\'")+"\"";
		}
		str=str+"}";
		result.append(str);
	}else{
		result.append("{rowCount:0,"+keyField+":\"#\"}");
	}	
	response.getWriter().write(result.toString());
	//System.out.println("onerecord="+result.toString());
	rs.close();
	stmt.close();
	connection.close();
%>