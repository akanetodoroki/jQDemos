<%@ page language="java" import="java.util.*"  import="java.sql.*,com.DBConn" pageEncoding="utf-8"%>
<%@page import="com.StringUtil"%>
<%
	//输入一条sql语句（update, insert,delete），在后台执行该sql语句
	//从前台获取数据，使用param传递.
	//request.setCharacterEncoding("ISO-8859-1");  //??
	String selectSql=StringUtil.filterNull(request.getParameter("selectSql"));
	String updateSql=StringUtil.filterNull(request.getParameter("updateSql"));
	String database=StringUtil.filterNull(request.getParameter("database"));
	//String sqlString=new String(request.getParameter("sqlString").getBytes("ISO-8859-1"),"gbk"); 
	//获取数据库连接
	DBConn con=new DBConn();
	Connection connection=con.getConnection(database);
	Statement stmt=connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
	//updateSql=updateSql.replace("\\","\\\\");
	//selectSql=selectSql.replace("\\","\\\\");
	String errmsg="";
	if (!updateSql.equals("")){
		try{
		stmt.executeUpdate(updateSql);
		}catch (SQLException e){
			//errmsg=e.printStackTrace();
			errmsg=e.getMessage();
		}
		
	}
	String str="";
	String value="";
	if (!selectSql.equals("")){  //执行select语句返回一行值，所有属性在其中
		String sqldim[];
		sqldim=selectSql.split("	");  //tab键
		//System.out.println("sqldim1="+sqldim[0]);
		for (int i=0;i<sqldim.length;i++){
			if (!sqldim[i].equals("")){ 
				stmt.executeQuery(sqldim[i]);
				ResultSet rs=stmt.getResultSet();
				ResultSetMetaData rsmd=rs.getMetaData();
				int colcount=rsmd.getColumnCount();
				//System.out.println("sqldim="+sqldim[i]);
				rs.beforeFirst();
				if (rs.next()) {
					for (int j=1;j<=colcount;j++) {
						String field=rsmd.getColumnName(j).toLowerCase();
						value=StringUtil.filterNull(rs.getString(field)).trim().replace("'","\\'");
						value=value.replace("\\","\\\\");
			    		str+=","+field+":\""+value+"\"";
					}
				}
			}
		}
	}
	//System.out.println("{success:true"+str+"}");
	
	if (errmsg.equals("") && !str.equals("")){			
		response.getWriter().write("{success:true,errors:''"+str+"}");
	}else{
		response.getWriter().write("{success:false,errors:\""+errmsg+"\"}");
	}	
	stmt.close();
	connection.close();
%>