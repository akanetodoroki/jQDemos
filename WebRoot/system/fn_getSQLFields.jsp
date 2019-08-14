<%@ page language="java" import="java.util.*"  import="java.sql.*,com.DBConn" pageEncoding="utf-8"%>
<%@page import="com.StringUtil"%>
<%
	//System.out.println("getfields");
    //从前台传递参数,使用params传递
	String database=StringUtil.filterNull(request.getParameter("database"));
	String sqlstring=StringUtil.filterNull(request.getParameter("sqlString"));//获取表名
	String sql="";
	//判断with as
	int xx1=sqlstring.indexOf(";with ");
	int xx2=sqlstring.indexOf("with ");
	int xx3=sqlstring.indexOf(" as ");
	System.out.println("xx2="+xx2);	
	if ((xx1>=0 || xx2>=0)&&(xx3>=0)){  //xsqlString.substring(0,5).toLowerCase().equals("with ")||xsqlString.substring(0,6).toLowerCase().equals(";with ")){
		int x1=sqlstring.lastIndexOf("select");
		int x2=sqlstring.lastIndexOf(" from ");
		if (x1>0 && x2>x1) {
			sql=sqlstring.substring(0,x1+6)+" top 0 "+sqlstring.substring(x1+6);
		}
	}else{	
		sql="select top 0 * from ("+sqlstring+") as p";
	}
	//System.out.println("sql="+sql);	
	//连接数据库
	DBConn con=new DBConn();
	Connection connection=con.getConnection(database);
	Statement stmt=connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
	//System.out.println("sql="+sql);	
	//先判断各个值是否存在
	stmt.executeQuery(sql);
	ResultSet grid_rs=stmt.getResultSet();
	grid_rs.beforeFirst();
	ResultSetMetaData rsmd=grid_rs.getMetaData();
	int xcolcount=rsmd.getColumnCount();
	String result="";
	for (int j=1;j<=xcolcount;j++) {
		if (j>1) result+=";";
		result+=rsmd.getColumnName(j).toLowerCase();
	}	
	//System.out.println("fieldset:"+result);
	response.getWriter().write("{success:true,fieldset:'"+result+"'}");
	stmt.close();
	connection.close();
%>

 
 