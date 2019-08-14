<%@ page language="java" import="java.util.*"  import="java.sql.*,com.DBConn" pageEncoding="utf-8"%>
<%@page import="com.StringUtil"%>
<%
	//输入一条sql语句（update, insert,delete），在后台执行该sql语句
	//从前台获取数据，使用param传递.
	String database=StringUtil.filterNull(request.getParameter("database"));
	String updatesql=StringUtil.filterNull(request.getParameter("updatesql"));
	String tablename=StringUtil.filterNull(request.getParameter("tablename"));
	//String selectsql=StringUtil.filterNull(request.getParameter("selectsql"));
	//updatesql=DBConn.myFromXcode(updatesql);
	//获取数据库连接
	String errmsg="";
	if (tablename.equals("")){
		String s=updatesql.replaceAll("  "," ");  //双空格换成单空格
		s=s.toLowerCase();
		String tmp[];
		tmp=s.split(" ");
		int index=s.indexOf("(");
		if (tmp.length>2 && index>0 && tmp[0].equals("insert") && tmp[1].equals("into")){
			tablename=s.substring(s.indexOf("into")+5,index);
			//System.out.println("tablename="+tablename);		
		} 
		else if (tmp.length>3 && tmp[0].equals("insert") && !tmp[1].equals("into")) tablename=tmp[1];
	}
	//System.out.println("updatesql="+updatesql);		
	DBConn con=new DBConn();
	Connection connection=con.getConnection(database);
	Statement stmt=connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
	int id=-1;
	if (!updatesql.equals("")){
		try{
			stmt.executeUpdate(updatesql);
		}catch (SQLException e){
			errmsg=e.getMessage();
		}
		if (!tablename.equals("")){
			String sql="select IDENT_CURRENT('"+tablename+"') as id";
			stmt.executeQuery(sql);
			ResultSet rs=stmt.getResultSet();
			if (rs.first()) id=rs.getInt("id");
		}
	}
	stmt.close();
	connection.close();
	//System.out.println("errmsg="+errmsg);		
	if (errmsg.equals("")){			
		response.getWriter().write("{'error':'','identity':'"+id+"'}");
	}else{
		errmsg=errmsg.replace("\"","");
		errmsg=errmsg.replace("'","");
		errmsg=errmsg.replace("\\","\\\\");
		response.getWriter().write("{'error':'"+errmsg+"'}");
	}	
%>