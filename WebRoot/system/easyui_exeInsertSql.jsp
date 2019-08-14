<%@ page language="java" import="java.util.*"  import="java.sql.*,com.DBConn" pageEncoding="utf-8"%>
<%@page import="com.StringUtil"%>
<%
	//输入一条sql语句（update, insert,delete），在后台执行该sql语句
	//从前台获取数据，使用param传递.
	String database=StringUtil.filterNull(request.getParameter("database"));
	String tablename=StringUtil.filterNull(request.getParameter("tablename"));
	String insertsql=StringUtil.filterNull(request.getParameter("insertsql"));
	String keyfield=StringUtil.filterNull(request.getParameter("keyfield"));
	String keyvalue=StringUtil.filterNull(request.getParameter("keyvalue"));
	insertsql=DBConn.myFromXcode(insertsql);
	tablename=DBConn.myFromXcode(tablename);	
	//获取数据库连接
	String message="";
	String sql="";
	int rowno=-1;
	DBConn con=new DBConn();
	Connection connection=null;
	Statement stmt= null;	
	//System.out.println("querysql="+selectSql);		
	try{
		message=con.testConnection(database);
	}catch (Exception e){
		message="数据库连接错误！";
		message=e.getMessage();
	}
	//System.out.println("error2");
	if (message.equals("")){
		connection=con.getConnection(database);
		stmt=connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
		if (!keyfield.equals("") && !keyvalue.equals("")){
			sql="select 1 from "+tablename+" where "+keyfield+"='"+keyvalue+"'"; 
			stmt.executeQuery(sql);
			ResultSet rs=stmt.getResultSet();
			rs.beforeFirst();
			if (rs.next()) message="-1";  //主键重复
		}
	}		
	if (message.equals("")){
		try{
			stmt.executeUpdate(insertsql);
		}catch (SQLException e){
			message=e.getMessage();
		}
	}	
	if (message.equals("")){
		sql="select rowno=count(*)+1 from "+tablename+" where "+keyfield+"<'"+keyvalue+"'"; 
		stmt.executeQuery(sql);
		ResultSet rs=stmt.getResultSet();
		rs.first();
		rowno=rs.getInt("rowno");
		System.out.println("rowno="+rowno);
	}
	stmt.close();
	connection.close();
	System.out.println("{\"errors\":"+message+"\",\"rowno\":"+rowno+"}");
	response.getWriter().write("{\"errors\":\""+message+"\",\"rowno\":\""+rowno+"\"}");
%>