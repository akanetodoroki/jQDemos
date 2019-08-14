//将多条sql语句查询得到的值，返回在一行中，要求不同的行列名不同
<%@ page language="java" import="java.util.*"  import="java.sql.*,com.DBConn" pageEncoding="utf-8"%>
<%@page import="com.StringUtil"%>
<%
    //从前台传递参数,使用params传递
	String database=StringUtil.filterNull(request.getParameter("database"));
	String sqlString=StringUtil.filterNull(request.getParameter("sqlString"));//获取sql语句
	//连接数据库
	DBConn con=new DBConn();
	Connection connection=con.getConnection(database);
	Statement stmt=connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
	String sqldim[];
	sqldim=sqlString.split("	");  //tab键
	String str="";
	for (int i=0;i<sqldim.length;i++){
		stmt.executeQuery(sqldim[i]);
		ResultSet rs=stmt.getResultSet();
		ResultSetMetaData rsmd=rs.getMetaData();
		int colcount=rsmd.getColumnCount();
		//System.out.println("sqldim="+sqldim[i]);
		rs.beforeFirst();
		if (rs.next()) {
			for (int j=1;j<=colcount;j++) {
				String field=rsmd.getColumnName(j).toLowerCase();
		    	str+=","+field+":\""+StringUtil.filterNull(rs.getString(field)).trim().replace("'","\\'")+"\"";
			}
		}
	}		
	//System.out.println("{success:true"+str+"}");
	response.getWriter().write("{success:true"+str+"}");
	stmt.close();	
	connection.close();
 %>

 
 