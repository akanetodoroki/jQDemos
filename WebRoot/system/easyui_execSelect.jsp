<%@ page language="java" import="java.util.*"  import="java.sql.*,com.DBConn" pageEncoding="utf-8"%>
<%@page import="com.StringUtil"%>
<%
	//从前台取数据,使用extjs的extraParams，根据sql语句获取combo选项
	request.setCharacterEncoding("ISO-8859-1");
	String database=StringUtil.getUrlCHN(request.getParameter("database"));
	String selectsql=StringUtil.getUrlCHN(request.getParameter("selectsql"));
	if (selectsql.equals("xcode")) selectsql="select * from sys_xcodes";  //密码
	//else selectsql=DBConn.myFromXcode(selectsql);
	System.out.println("sql="+selectsql);
	StringBuffer record=new StringBuffer();//创建一个stringbuffer 对象用于存放 最终返回结果
	String value="";
	if ("".equals(selectsql)){
		record.append("[]");
	}else{
		//数据库连接
		DBConn con=new DBConn();
		Connection connection=con.getConnection(database);
		Statement stmt=connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
		stmt.executeQuery(selectsql);
		ResultSet rs=stmt.getResultSet();
		ResultSetMetaData rsmd=rs.getMetaData();
		rs.last();
		int rowCount=rs.getRow();
		int colcount=rsmd.getColumnCount();		
		String field;
		String str="";
		int i=1;
		int j=0;
		//record.append("{totalCount:"+rowCount+",result:[");
		record.append("[\n");
		rs.beforeFirst();
		while(rs.next()) {
			//str="{";
			str="{\"sysrowno\":\""+i+"\"";  //行号
			for (j=1;j<=colcount;j++) {
				field=rsmd.getColumnName(j).toLowerCase();
				value=StringUtil.filterNull(rs.getString(field)).trim();
		    	value=value.replace("\\","\\\\");  //用于kindeditor,客户端返回中有4个\
		    	value=value.replace("\"","\\\"");  //无法返回双引号
			    if (j>0) str=str+",";
			    str=str+"\""+field+"\":\""+value+"\"";
			    //StringUtil.filterNull(rs.getString(field)).trim().replace("'","\\'")+"\"";
	 		}
	 		if (i!=rowCount) str+="},\n";
	 		else str+="}\n";
	 		record.append(str);
	 		i++;
		} 		
		record.append("]");
		stmt.close();
		rs.close();
		connection.close();
	}	
	//record.append("]}");
	response.getWriter().write(record.toString());
	//System.out.println("result="+record.toString());
%>