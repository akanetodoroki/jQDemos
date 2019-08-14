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
	//返回sqlserver.xml中所有服务器的名称和密码
	String hostname = "";
	String sqlpassword = "";
	String result="";
	//读sqlserver文件
	String path = application.getRealPath("/");	
	String s1=path.substring(0,path.lastIndexOf("\\"));  //所在文件夹
	String s2="system//sqlservers//sqlserver.xml";
	File f=new File(s1,s2);  //在文件中删除已经存在的这个文件
	if (hostname.equals("") && f.exists()){ 
		DocumentBuilderFactory userDBF=DocumentBuilderFactory.newInstance();
 		userDBF.setIgnoringElementContentWhitespace(true);
 		DocumentBuilder userDB = userDBF.newDocumentBuilder();
		Document doc = userDB.parse("file:///"+s1+"/"+s2);
 		Element root= doc.getDocumentElement();		
     	NodeList nlist=root.getChildNodes();
     	if (nlist!=null){
			for (int i=0;i<nlist.getLength();i++){
				if (nlist.item(i).getNodeType()==1 && nlist.item(i).getNodeName()=="host"){
					NamedNodeMap plist=nlist.item(i).getAttributes();
					hostname="";
					sqlpassword="";
					for (int j=0;j<plist.getLength();j++){
						if (plist.item(j).getNodeName().equals("name") && !plist.item(j).getNodeValue().equals("")){
							hostname=plist.item(j).getNodeValue().trim();
						}
						if (plist.item(j).getNodeName().equals("password") && !plist.item(j).getNodeValue().equals("")){
							sqlpassword=plist.item(j).getNodeValue().trim();
						}
					}
					if (!hostname.equals("")){
						if (!result.equals(""))	result+=";";  //两个服务器之间;分隔
						result+=hostname+"	"+sqlpassword;  //tab分隔用户名和密码之间
					}
				}						
			}
		}
	}
	response.getWriter().write(result);
%>
