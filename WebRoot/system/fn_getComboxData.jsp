<%@ page language="java" import="java.util.*"  import="java.sql.*,com.DBConn" pageEncoding="utf-8"%>
<%@page import="com.StringUtil"%>
<%
	//从前台取数据,使用extjs的extraParams，根据sql语句获取combo选项
	request.setCharacterEncoding("ISO-8859-1");
	String database=StringUtil.getUrlCHN(request.getParameter("database"));
	String sqlString=StringUtil.getUrlCHN(request.getParameter("sqlString"));
	System.out.println("sql="+sqlString);
	StringBuffer record=new StringBuffer();//创建一个stringbuffer 对象用于存放 最终返回结果
	if ("".equals(sqlString)){
		record.append("[]");
	}else{
		//数据库连接
		DBConn con=new DBConn();
		Connection connection=con.getConnection(database);
		Statement stmt=connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
		StringBuffer querySQL=new StringBuffer();//创建一个stringbuffer对象用于存放查询语句
		//System.out.println(sqlString);
		querySQL.append(sqlString);
		ResultSet rs=stmt.executeQuery(querySQL.toString());
		rs.last();
		int rowCount=rs.getRow();
		rs.beforeFirst();
		ResultSetMetaData rsmd=rs.getMetaData();
		int colcount=rsmd.getColumnCount();		
		String field;
		String str="";
		int i=1;
		int j=0;
		//record.append("{totalCount:"+rowCount+",result:[");
		record.append("[");
		while(rs.next()) {
			if (i==1) str="{";
			else str=",{";
			for (j=1;j<=colcount;j++) {
				field=rsmd.getColumnName(j).toLowerCase();
			    if (j>1) str=str+",";
			    str=str+"\""+field+"\":\""+StringUtil.filterNull(rs.getString(field)).trim().replace("'","\\'")+"\"";
	 		}
	 		str=str+"}";
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
	System.out.println("combox="+record.toString());
%>