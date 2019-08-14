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
	//输入一条sql语句（update, insert,delete），在后台执行该sql语句
	//从前台获取数据，使用param传递.
	String errmsg="";
	String database=StringUtil.filterNull(request.getParameter("database"));
	String action=StringUtil.filterNull(request.getParameter("action"));
	String xhostname="";
	String xsqlpassword="";
	String tmp[];
	tmp=database.split("	");  //tab键
	xhostname = tmp[0];
	xsqlpassword = tmp[1];
	String path = application.getRealPath("/");	
	String s1=path.substring(0,path.lastIndexOf("\\"));  //所在文件夹
	String s2="system//sqlservers//sqlserver.xml";
	String str="";
	String result="";
	int x1,x2,x3,i;
	//System.out.println(xhostname+"--"+s2);
	result="<?xml version=\"1.0\" encoding=\"GB2312\" ?>\n";
	result+="<servers>\n";
	if (!action.equals("delete")){ //删除时不添加
		result+="   <host name=\""+xhostname+"\" password=\""+xsqlpassword+"\" />\n";
	}	
	File f=new File(s1,s2);  //在文件中删除已经存在的这个文件
	if (f.exists()){ 
    	FileReader fileReader = new FileReader(f);    
    	BufferedReader br = new BufferedReader(fileReader);
    	i=0;
    	while((str = br.readLine() ) != null){  
			str=str.trim();
			x1=str.toLowerCase().indexOf("<host");
			x2=str.toLowerCase().indexOf("name='"+xhostname.toLowerCase()+"'");
			if (x2<0) x2=str.toLowerCase().indexOf("name=\""+xhostname.toLowerCase()+"\"");
			if (x1>=0 && x2>=0){
				//result+="\n<host name=\""+xhostname+"\" password=\""+xsqlpassword+"\" />";
				//System.out.println(xhostname+"--"+x2+"---"+x1);
			}else if (x1>=0 && x2<0){
				result+="   "+str+"\n";
			}
		}
	}else{
		f.createNewFile();  //创建新文件
	}	
	result+="</servers>";
	//PrintWriter pw = new PrintWriter(new FileOutputStream(s1+"/"+s2));
	FileWriter fw=new FileWriter(s1+"/"+s2);
	BufferedWriter bw= new BufferedWriter(fw); 
	tmp=result.split("\n");
	for (i=0;i<tmp.length;i++){ 
		bw.write(tmp[i]+"\n");
		bw.newLine();  //换行
		//pw.println(tmp[i]+"\n");
	}
	bw.flush();
	fw.close(); 
	bw.close();
	//pw.close(); 
	response.getWriter().write(result);		
%>