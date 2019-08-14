<%@ page language="java" import="java.util.*"  import="java.sql.*,com.DBConn" pageEncoding="utf-8"%>
<%@page import="com.StringUtil"%>
<%
	///功能：从数据库提取前台TreeGrid控件的节点，包括各列数据。输入参数：searchtext、、keyfield、sqlstring 
	//输出结果中cid为标识值；flag=1表示一次性全部返回节点，flag=0表示分层返回子节点；text为节点内容，暂时没有用到它。
	//如果含有checkboxflag这一列，则显示checkbox 
	//从前台提取传递过来的参数值，使用extjs的extraParams
	//System.out.println("fullsql");
	request.setCharacterEncoding("ISO-8859-1");
	String database=StringUtil.getUrlCHN(request.getParameter("database"));
	String selectsql=StringUtil.getUrlCHN(request.getParameter("selectsql")); //获取节点数据的sql语句
	String keyfield=StringUtil.getUrlCHN(request.getParameter("keyfield"));   //主键字段名
	String sortfield=StringUtil.getUrlCHN(request.getParameter("sortfield"));   //排序列
	String iconcls=StringUtil.getUrlCHN(request.getParameter("iconcls"));   //节点图标文件名
	//selectsql=DBConn.myFromXcode(selectsql);
	//连接数据库
	DBConn con=new DBConn();
	Connection connection=con.getConnection(database);	
	Statement stmt=connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
   	StringBuffer returnResult=new StringBuffer();//创建一个stringbuffer对象用于存放返回结果
	String querystring="";
	ResultSet node_rs=stmt.getResultSet();
	int xx1=selectsql.indexOf(";with ");
	int xx2=selectsql.indexOf("with ");
	int xx3=selectsql.indexOf(" as ");
	if ((xx1>=0 || xx2>=0)&&(xx3>=0)){
		querystring=selectsql;
		if (!sortfield.equals("")) querystring+=" order by "+sortfield;
		else querystring+=" order by rtrim(ancester)+"+keyfield;
	}else{	
		if (sortfield.equals("")){
    		querystring="select * from ("+selectsql+") as p order by rtrim(ancester)+"+keyfield;
    	}else{
    		querystring="select * from ("+selectsql+") as p order by "+sortfield;
    	}
    }	
	System.out.println("sql="+querystring);
	stmt.executeQuery(querystring);
	node_rs=stmt.getResultSet();
	//node_rs.beforeFirst(); //如果还要用结果集，就把指针再移到初始化的位置
	ResultSetMetaData rsmd=node_rs.getMetaData();
	int xcolcount=rsmd.getColumnCount();
	String str="";
	String field="";
	int level=0;
	int i=0;
	int j=0;
	String idfield="";
	for (j=1;j<=xcolcount;j++) {
		field=rsmd.getColumnName(j).toLowerCase();
		if (field.equals("id")){
			idfield=field;
			break;
		}
	}
	if (idfield.equals("")) { idfield=keyfield; }  
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
			str+="{";
			if (!iconcls.equals("")){
				str+="iconCls:'"+iconcls+"',";
			}
			str+="\"id\":\""+StringUtil.filterNull(node_rs.getString(idfield)).trim().replace("\"","").replace("'","\\'")+"\"";  
			for (j=1;j<=xcolcount;j++) {
				field=rsmd.getColumnName(j).toLowerCase();
				//if (!field.equals("id") && (!field.equals(keyfield)) ){  
				if (!field.equals("id")){  
					str=str+",\""+field+"\":\""+StringUtil.filterNull(node_rs.getString(field)).trim().replace("\"","").replace("'","\\'")+"\"";
				}
			}
			//System.out.println(str);			
			returnResult.append(str);
			flag=1;
			if (isParentFlag>0){
				returnResult.append(",\n\"children\":[");
				flag=0;
				//System.out.println(result[level+1]);
			}else{
				returnResult.append("}\n");
			}
			xlevel=level;
			i++;
		} //while
		for (i=1;i<xlevel;i++)	returnResult.append("]}\n");
		returnResult.append("]\n");
	}else{ //rowcount>0
		returnResult.append("");
	}
	System.out.println("result="+returnResult.toString());
	response.getWriter().write(returnResult.toString());
	node_rs.close();
	stmt.close();
	connection.close();
%>	
