//将多条sql语句查询得到的值，返回在一行中，要求不同的行列名不同
<%@ page language="java" import="java.util.*"  import="java.sql.*,com.DBConn" pageEncoding="utf-8"%>
<%@page import="com.StringUtil"%>
<%
    //从前台传递参数,使用params传递
	String database=StringUtil.filterNull(request.getParameter("database"));
	String filename=StringUtil.filterNull(request.getParameter("fileName"));
	String dbname=StringUtil.filterNull(request.getParameter("dbName"));
	//连接数据库
	DBConn con=new DBConn();
	Connection connection=con.getConnection(database);
	Statement stmt=connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
	String sql="select 1 from "+dbname+".dbo.sysobjects where name='"+filename+"'";
	ResultSet rs=stmt.executeQuery(sql);
	//System.out.println("sql----"+sql);
	if (rs.next()){
		CallableStatement proc=connection.prepareCall("{call crmlab.dbo."+filename+"()}");   //调用存储过程来进行人员数据的清理
		proc.execute();
		//System.out.println("procedure-"+filename+"---"+database+"---"+dbname+".dbo."+filename);
		proc.close();
	}	
	//connection.commit();
	stmt.close();	
	connection.close();
	response.getWriter().write("{success:true}");
 %>

 
 