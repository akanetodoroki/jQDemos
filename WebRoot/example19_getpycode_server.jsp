<%@ page language="java" import="java.util.*"  import="java.sql.*,com.DBConn" pageEncoding="utf-8"%>
<%@page import="com.StringUtil"%>
<%
	//从前台获取数据，使用params传递
	request.setCharacterEncoding("ISO-8859-1");
	String database=StringUtil.getUrlCHN(request.getParameter("database"));
	String chnstr=StringUtil.getUrlCHN(request.getParameter("chnstr"));
	//数据库连接
	DBConn con=new DBConn();
	Connection connection=con.getConnection(database);
	//Statement stmt=connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
	//调用存储过程，有几个变量就写几个问号
	CallableStatement stmt=connection.prepareCall("{call sys_getpycode(?,?)}"); 
    //设置输入参数     
	stmt.setString("@str",chnstr);  //setDate, setINT..
  	//登记输出参数
	stmt.registerOutParameter("@pycode",java.sql.Types.VARCHAR);    //Types.FLOAT,Types.INTEGER
	//执行该存储过程并返回结果集     
	stmt.execute();
	//获取来自结果集中的数据     
	String str=stmt.getString("@pycode");  
	System.out.println("str="+str);   
	//关闭可调用的对象     
	stmt.close();     
	connection.close();
	response.getWriter().write("{pycode:'"+str+"'}");
%>
