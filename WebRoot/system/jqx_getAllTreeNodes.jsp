<%@ page language="java" import="java.util.*"  import="java.sql.*,com.DBConn" pageEncoding="utf-8"%>
<%@page import="com.StringUtil"%>
<%
	///功能：从数据库提取前台TreeGrid控件的节点，包括各列数据。输入参数：searchtext、、keyfield、sqlstring 
	//输出结果中cid为标识值；flag=1表示一次性全部返回节点，flag=0表示分层返回子节点；text为节点内容，暂时没有用到它。
	//如果含有checkboxflag这一列，则显示checkbox 
	//从前台提取传递过来的参数值，使用extjs的extraParams
	request.setCharacterEncoding("ISO-8859-1");
	String database=StringUtil.getUrlCHN(request.getParameter("database"));
	String sqlString=StringUtil.getUrlCHN(request.getParameter("sqlString")); //获取节点数据的sql语句
	String keyField=StringUtil.getUrlCHN(request.getParameter("keyField"));   //主键字段名
	String sortField=StringUtil.getUrlCHN(request.getParameter("sortField"));   //排序列
	String style=StringUtil.getUrlCHN(request.getParameter("style"));   //参数样式
	/*
	//StringBuffer result=new StringBuffer();//创建一个stringbuffer对象 用于存放最终返回结果
	//StringBuffer[] result = new StringBuffer[10];
	String[] result = new String[20];
	for (int i = 0; i < result.length; i ++) {
     	result[i] = new String();
	}
	*/
	if (sortField.equals("")) sortField=keyField;
	//连接数据库
	DBConn con=new DBConn();
	Connection connection=con.getConnection(database);	
	StringBuffer querySQL=new StringBuffer();//创建一个stringbuffer对象用来存放查询语句
	Statement stmt=connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
	querySQL=new StringBuffer();
   	StringBuffer returnResult=new StringBuffer();//创建一个stringbuffer对象用于存放返回结果
	String querystring="";
	ResultSet node_rs=stmt.getResultSet();
	int level=0;
	int i=0;
	int j=0;
	for (j=1;j<=xcolcount;j++) {
		field=rsmd.getColumnName(j).toLowerCase();
	}		
	int isParentFlag=0;	//是否含有子节点
	node_rs.last();
	int rowCount=node_rs.getRow(); //得到当前行号，也就是记录数
	if(rowCount>0){//判断结果集是否含有值
		node_rs.first();
		node_rs.beforeFirst();
		int xlevel=1;
		int flag=0;
		returnResult.append("[");
		while(node_rs.next()){//循环输出结果集
			isParentFlag=node_rs.getInt("IsParentFlag");
			level=node_rs.getInt("level");
			str="";
			if (level==xlevel){
				if (flag==1) str+=",";
			}else{
				for (i=level;i<xlevel;i++)	returnResult.append("]}\n");
				xlevel=level;
				//if (i<rowCount) str+=",";
				if (flag!=0) str+=",";
			}			
			str+="{\"value\":\""+StringUtil.filterNull(node_rs.getString(keyField)).trim().replace("\"","").replace("'","\\'")+"\"";  
			for (j=1;j<=xcolcount;j++) {			
				field=rsmd.getColumnName(j).toLowerCase();  
				str=str+",\""+field+"\":\""+StringUtil.filterNull(node_rs.getString(field)).trim().replace("\"","").replace("'","\\'")+"\"";
			}
			//System.out.println(str);			
			returnResult.append(str);
			flag=1;
			if (isParentFlag==1){
				returnResult.append(",\n\"items\":[");
				flag=0;
				//System.out.println(result[level+1]);
			}else{
				if (style.indexOf("icon")>=0){
					returnResult.append(", icon:\"system/images/notepad.png\" }\n");
				}else{
					returnResult.append("}\n");
				}				
			}
			xlevel=level;
			i++;
		} //while
		for (i=1;i<xlevel;i++)	returnResult.append("]}\n");
		returnResult.append("]\n");
	}else{ //rowcount>0
		returnResult.append("");
	}
	System.out.println(returnResult.toString());
	response.getWriter().write(returnResult.toString());
	node_rs.close();
	stmt.close();
	connection.close();
%>	
