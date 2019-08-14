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
	String nodefields=StringUtil.filterNull(request.getParameter("nodefields"));
	insertsql=DBConn.myFromXcode(insertsql);
	//获取数据库连接
	String message="";
	String sql="";
	String nodefield="";
	String str="";
	String field="";
	String result="";	
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
		//取结点值
		String fiddim[];
		fiddim=nodefields.split(";");  //@tab键@分隔
		String nodefidstr="";
		for (int i=0; i<fiddim.length; i++){
			if (i>0) nodefidstr+="+' '+";
			nodefidstr+="rtrim("+fiddim[i]+")"; 
		}
		String querysql="select "+keyfield+" as id,"+nodefidstr+" as text,* from "+tablename+" where "+keyfield+"='"+keyvalue+"'";
		//System.out.println(querysql+"-----"+nodefidstr);
		stmt.executeQuery(querysql);
		ResultSet node_rs=stmt.getResultSet(); //有多个结果集时，需要使用getResultSet()方法
		node_rs.beforeFirst(); //如果还要用结果集，就把指针再移到初始化的位置
		ResultSetMetaData rsmd=node_rs.getMetaData();
		int xcolcount=rsmd.getColumnCount();
		if (node_rs.next()){
			str="\"id\":\""+StringUtil.filterNull(node_rs.getString(keyfield)).trim().replace("\"","").replace("'","\\'")+"\"";   //这里\之后的"为普通字符
			for (int j=1;j<=xcolcount;j++) {
				field=rsmd.getColumnName(j).toLowerCase();
				if (!field.equals("id")){  
					str=str+",\""+field+"\":\""+StringUtil.filterNull(node_rs.getString(field)).trim().replace("\"","").replace("'","\\'")+"\"";
				}	
			}
			//System.out.println("str="+str);
		}
	}	
	stmt.close();
	connection.close();
	if (!str.equals("")) str="[{\"error\":\""+message+"\","+str+"}]";
	else str="[{\"error\":\""+message+"\"}]";
	System.out.println(str);
	response.getWriter().write(str);
%>