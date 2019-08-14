//功能：从数据库提取前台TreeGrid控件的节点，包括各列数据。输入参数：searchtext、rootCode、keyfield、sqlstring  
//输出结果中cid为标识值；flag=1表示一次性全部返回节点，flag=0表示分层返回子节点；text为节点内容，暂时没有用到它。  
<%@ page language="java" import="java.util.*"  import="java.sql.*,com.DBConn" pageEncoding="utf-8"%>
<%@page import="com.StringUtil"%>
<%
    //从前台提取传递过来的参数值，使用extjs的extraParams
	request.setCharacterEncoding("ISO-8859-1");
	String database=StringUtil.getUrlCHN(request.getParameter("database"));
	String keyField=StringUtil.getUrlCHN(request.getParameter("keyField"));   //获取主键字段名
	String sqlString=StringUtil.getUrlCHN(request.getParameter("sqlString")); //获取要显示的所有列名
	//生成查询语句
	//从前台传递的字符串中提取和生成过滤条件whereSQL
	String nodeField="";
	StringBuffer result=new StringBuffer();//创建一个stringbuffer对象 用于存放最终返回结果
	System.out.println("childsql="+sqlString);
	//连接数据库
	DBConn con=new DBConn();
	Connection connection=con.getConnection(database);	
	StringBuffer querySQL=new StringBuffer();//创建一个stringbuffer对象用来存放查询语句
	Statement stmt=connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
	//计算当前查询中包含的记录数量
   	//System.out.println("110");
	querySQL.append(sqlString);
	stmt.executeQuery(querySQL.toString());
	ResultSet node_rs=stmt.getResultSet(); //有多个结果集时，需要使用getResultSet()方法
	System.out.println("querySQL="+querySQL.toString());
	int isparentflag= -1;
	node_rs.last(); //移到最后一行
	int rowCount =node_rs.getRow(); //得到当前行号，也就是记录数
	node_rs.beforeFirst(); //如果还要用结果集，就把指针再移到初始化的位置
	ResultSetMetaData rsmd=node_rs.getMetaData();
	int xcolcount=rsmd.getColumnCount();
	String str="";
	String field="";
	int i=0;
	int j=0;
	for (j=1;j<=xcolcount;j++) {
		field=rsmd.getColumnName(j).toLowerCase();
		if (field.equals("nodetext")){
			nodeField=field;
			break;
		}
	}
	if (nodeField.equals("")) { nodeField=keyField; }  
	//从数据库取记录，转换成json格式数据
	while(node_rs.next()){
		str="{cid:\""+StringUtil.filterNull(node_rs.getString(keyField)).trim().replace("\"","").replace("'","\\'")+"\"";   //这里\之后的"为普通字符
		if (nodeField.equals("")) {  
			str=str+",sysnumber:"+(i+1)+",text:\""+StringUtil.filterNull(node_rs.getString(keyField)).trim().replace("\"","").replace("'","\\'");
			if (xcolcount>1){
				field=rsmd.getColumnName(2).toLowerCase();
				str=str+"&nbsp;"+StringUtil.filterNull(node_rs.getString(field)).trim().replace("\"","").replace("'","\\'");
			}
			str=str+"\"";   //这里\之后的"为普通字符	
		}else{
			str=str+",sysnumber:"+(i+1)+",text:\""+StringUtil.filterNull(node_rs.getString(nodeField)).trim().replace("\"","").replace("'","\\'")+"\"";   //这里\之后的"为普通字符
		}	
		for (j=1;j<=xcolcount;j++) {
			field=rsmd.getColumnName(j).toLowerCase();
			//if (!field.equals(keyField) && !field.equals(nodeField)){  
			if (!field.equals(nodeField)){  
				str=str+","+field+":\""+StringUtil.filterNull(node_rs.getString(field)).trim().replace("\"","").replace("'","\\'")+"\"";
			}	
		}
		isparentflag=node_rs.getInt("IsParentFlag");
		if (isparentflag==1){
			result.append(str+"}");
			result.append((i==rowCount-1?"":",")+"");
		}else{
			result.append(str+",iconCls:\"leafIcon\",leaf:true }");
			result.append((i==rowCount-1?"":",")+"");				
		}
		i++;
		}
	response.getWriter().write("["+result.toString()+"]");
	node_rs.close();
	stmt.close();
	//System.out.println("childnodes="+result.toString());		
	node_rs.close();
	stmt.close();
	connection.close();
%>