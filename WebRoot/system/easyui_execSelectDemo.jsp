<%@ page language="java" import="java.util.*"  import="java.sql.*,com.DBConn" pageEncoding="utf-8"%>
<%@page import="com.StringUtil"%>
<%
	//从前台取数据,使用extjs的extraParams，根据sql语句获取combo选项
	request.setCharacterEncoding("ISO-8859-1");
	String database=StringUtil.getUrlCHN(request.getParameter("database"));
	//String selectsql=StringUtil.getUrlCHN(request.getParameter("selectsql"));
	String result=""; //存放最终返回结果
	String value, field, str;
	//数据库连接
	DBConn con=new DBConn();
	Connection connection=con.getConnection(database);
	Statement stmt=connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
	stmt.executeQuery("select * from products"); //执行select查询语句
	ResultSet rs=stmt.getResultSet();  //将查询结果复制到rs变量，这样rs里面就是多行多列的一个结果集，类似于游标declare c1 cursor for selelct * from products。
	ResultSetMetaData rsmd=rs.getMetaData();  //取列名集合
	rs.last();  //rs指针指向最后一条  
	int rowCount=rs.getRow();   //取最后一行行号，就是总的行数
	int colCount=rsmd.getColumnCount();	 //取总列数	
	int i=1, j=0;
	result="[";  //json数据开始，第一个是[，最后一个是]
	rs.beforeFirst();  //指针指向第一条的前面那一条，就是文件头
	while(rs.next()) {  //先指针往下移一条，在判断是不是遇到文件底，如果是返回false，不是文件底返回true
		str="{";
		str+="'productid':'"+rs.getString("productid")+"'";  //列名+值这样的格式，例如：'productid':'1'
		str+=", 'productname':'"+rs.getString("productname")+"'";  //注意前面的逗号，用来分隔两个列
		str+=", 'unitprice':'"+rs.getString("unitprice")+"'";  //注意前面的逗号，用来分隔两个列
		//前面只写3个列，而且写死了。可以写成活的，就是书上例子用循环把每个列都取出来。
		str+='}';
		//这样一行所有列处理结束后再加一个}，str中就是一条记录的json格式数据，例如：str="{'productid':'101', 'productname':'汇源100%橙汁', 'unitprice':'9.95'}"
 		if (i<rowCount) str+=",";  //第2行开始之前要加一个逗号
		result+=str+"\n";  //把这行添加到输出变量result中,第2行开始之前要加一个逗号
 		i++;
	}
	//所有行结束，添加一个]号	
	result+="]"; //返回的是符合json格式的一个字符串
	System.out.println("result="+result);
	//关闭所有数据库连接操作，必须的。
	stmt.close();
	rs.close();
	connection.close();
	response.getWriter().write(result);  //返回的是符合json格式的一个字符串
%>