<%@ page language="java" import="java.util.*"  import="java.sql.*,com.DBConn" pageEncoding="utf-8"%>
<%@page import="com.StringUtil"%>
<%
	//输入一条sql语句，只有一个列，将返回多行的值合并在一个字符串中。
	//不同记录之间用键分隔
    //从前台传递参数,使用params传递
	String database=StringUtil.filterNull(request.getParameter("database"));
	String sqlString=StringUtil.filterNull(request.getParameter("sqlString"));//获取sql语句
	//连接数据库
	DBConn con=new DBConn();
	Connection connection=con.getConnection(database);
	Statement stmt=connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
	StringBuffer result=new StringBuffer(); //创建一个stringbuffer对象用于存放查询语句
	String str="";
	stmt.executeQuery(sqlString);
	ResultSet rs=stmt.getResultSet();
	ResultSetMetaData rsmd=rs.getMetaData();
	rs.beforeFirst();
	while (rs.next()) {
		String field=rsmd.getColumnName(1).toLowerCase();
		if (!str.equals("")) result.append("	");  //tab分隔
		str=StringUtil.filterNull(rs.getString(field)).trim().replace("'","\\'");
		result.append(str);
	}
	//result.append("}");
	//System.out.println(result.toString());
	response.getWriter().write(result.toString());
	stmt.close();	
	connection.close();
 %>
