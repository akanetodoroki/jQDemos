<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.sql.*"%>
<%@ page import="com.DBConn" %>
<%@ page import="com.UserBean" %>
<%@ page import="com.StringUtil"%>
<%@ page import="java.io.*" %>
<%@ page import="java.io.BufferedInputStream" %>
<%@ page import="java.io.BufferedOutputStream" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="javax.xml.parsers.*,org.w3c.dom.*" %>

<%
	String database=StringUtil.filterNull(request.getParameter("database"));
	String dbname=StringUtil.filterNull(request.getParameter("dbName"));
	String sqlfile = request.getParameter("fileName");
	//System.out.println("00000----"+database);	
	String tmp[];
	tmp=database.split("	");  //tab
	String hostname = tmp[0];
	String sqlpassword = tmp[1];
	String errormsg="";
	String str="";
	String path = application.getRealPath("/");	
	String realpath = path.substring(0,path.lastIndexOf("\\"));  //所在文件夹
	String databasestring=hostname+"	"+sqlpassword+"	master";
	DBConn con=new DBConn();
	try{
		errormsg=con.testConnection(databasestring);
	}catch (Exception e){
		errormsg=e.getMessage();
	}
	if (errormsg.equals("")){  //连接成功
		//判断数据库是否存在
		DBConn db = new DBConn();
		Connection conn = db.getConnection(databasestring);
		Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
		String sql="select 1 from master.dbo.sysdatabases where name='"+dbname+"'";
		ResultSet rs = stmt.executeQuery(sql);
		if (!rs.next()){
			stmt.executeUpdate("create database "+dbname);
		}	
		databasestring=hostname+"	"+sqlpassword+"	"+dbname;  //tab
		//System.out.println(databasestring);	
		conn = db.getConnection(databasestring);
		stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
		tmp=sqlfile.split("	");  //tab
		for (int i=0;i<tmp.length;i++){
			String realfile= realpath+"\\"+tmp[i];
			File f=new File(realfile);
			if (f.exists()){ 
		 		//System.out.println("sqlfile2="+realfile);
				stmt.clearBatch();
        		FileReader fileReader = new FileReader(f);    
        		BufferedReader br = new BufferedReader(fileReader);
        		if (i==0){ //create function之前不能有use
        			//sql="use "+dbname;
					//stmt.addBatch("use "+dbname);
        		}    
        		while((str = br.readLine() ) != null){  
        			str=str.trim();
        			if (!str.toLowerCase().equals("go")){ //跳过脚本中的go语句
        				stmt.addBatch("\n"+str);
        				//sql+="\n"+str;    
        			}
        		}
        		//if (tmp[i].indexOf("sys_r")>=0) System.out.println(sql);
        		stmt.executeBatch();
			}else{
				//System.out.println("not found="+realfile);
			}
		}
		rs.close();
		stmt.close();
		conn.close();
	}
	response.getWriter().write(errormsg);
%>
