<%@ page language="java" import="java.util.*"  import="java.sql.*,com.DBConn" pageEncoding="utf-8"%>
<%@page import="com.StringUtil"%>
<%
	///功能：从数据库提取前台TreeGrid控件的节点，包括各列数据。输入参数：searchtext、rootCode、keyfield、sqlstring 
	//输出结果中cid为标识值；flag=1表示一次性全部返回节点，flag=0表示分层返回子节点；text为节点内容，暂时没有用到它。
	//如果含有syschecked这一列，则显示checkbox 
	//从前台提取传递过来的参数值，使用extjs的extraParams
	request.setCharacterEncoding("ISO-8859-1");
	String database=StringUtil.getUrlCHN(request.getParameter("database"));
	int maxReturnNumber=Integer.parseInt(request.getParameter("maxReturnNumber")); //超过maxReturnNumber分层显示子节点
	String sqlString=StringUtil.getUrlCHN(request.getParameter("sqlString")); //获取节点数据的sql语句
	String keyField=StringUtil.getUrlCHN(request.getParameter("keyField"));   //主键字段名
	String sortField=StringUtil.getUrlCHN(request.getParameter("sortField"));   //排序列
	String rootCode=StringUtil.getUrlCHN(request.getParameter("rootCode"));   //上一级节点的编码
	String selectedCode=StringUtil.getUrlCHN(request.getParameter("selectedCode")) ;  //需要定位选中的节点编码，只有修改、增加和删除节点时才需要定位
	String searchText=StringUtil.getUrlCHN(request.getParameter("searchText")); //前台过滤的条件和新增记录时定位所需
	String whereSQL=searchText;
	System.out.println("treesql1="+sqlString);
	//生成查询语句，从前台传递的字符串中提取和生成过滤条件whereSQL
	String nodeField="";
	int checkedflag=0;
	StringBuffer result=new StringBuffer();//创建一个stringbuffer对象 用于存放最终返回结果
	if (sortField.equals("")) sortField=keyField;
	//System.out.println("wheresql="+whereSQL);
	//连接数据库
	DBConn con=new DBConn();
	Connection connection=con.getConnection(database);	
	StringBuffer querySQL=new StringBuffer();//创建一个stringbuffer对象用来存放查询语句
	Statement stmt=connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
	//计算当前查询中包含的记录数量
	if("".equals(whereSQL)) {
		querySQL.append("select count(*) as n from ("+sqlString+") as p");
	}else{
		//通过CTE递归，适用于sql2005及以上版本	  
	    querySQL.append(";with tmp as ("+sqlString+")");
	    querySQL.append(",tmp1 as ( select "+keyField+",ParentNodeID from tmp");
        if(!whereSQL.equals("")){
        	querySQL.append(" where "+whereSQL);
        }  
        querySQL.append(" union all select b."+keyField+",b.ParentnodeID from tmp1 as a,tmp as b ");
        querySQL.append(" where b."+keyField+"=a.ParentnodeID) ");
        querySQL.append(" select count(*) as n from tmp where "+keyField+" in (select "+keyField+" from tmp1) ");
	}
	//System.out.println("sql0="+querySQL.toString());
	stmt.executeQuery(querySQL.toString());
	ResultSet node_rs=stmt.getResultSet();
	node_rs.last(); //移到最后一行
	int recordCount =node_rs.getInt(1); //得到当前行号，也就是记录数
	if (maxReturnNumber<=0) maxReturnNumber=recordCount+1; //0表示一次全部返回节点
	//System.out.println("n="+recordCount+","+maxReturnNumber+",sql0="+querySQL.toString());
	querySQL=new StringBuffer();
   	StringBuffer returnResult=new StringBuffer();//创建一个stringbuffer对象用于存放返回结果
	String querystring="";
	if (recordCount > maxReturnNumber && selectedCode.equals("")){  
	   //记录数超过规定，而且没有节点选中，则分层显示子节点。这里不是使用递归。
        System.out.println("110keyfield="+keyField);
		result=new StringBuffer();//创建一个stringbuffer对象用来存放结果
		//如果指定要定位的节点的值，那么提取第一层节点及定位节点的所有父节点
		querystring=";with tmp as ("+sqlString+")";
		querystring+=",tmp1 as ( select "+keyField+",ParentNodeID from tmp";
		if(!whereSQL.equals("")){
        	querystring=querystring+" where "+whereSQL;
        }  
        querystring=querystring+" union all select b."+keyField+",b.ParentnodeID from tmp1 as a,tmp as b ";
        querystring=querystring+" where b."+keyField+"=a.ParentnodeID) ";
        querystring=querystring+"select * from tmp where "+keyField+" in (select "+keyField+" from tmp1) ";
		querySQL.append(querystring);
		querySQL.append(" and ISNULL(ParentNodeID,'')='"+rootCode+"'");
		querySQL.append(" order by "+sortField);
		System.out.println("querySQL1="+querySQL.toString());
		stmt.executeQuery(querySQL.toString());
		node_rs=stmt.getResultSet(); //有多个结果集时，需要使用getResultSet()方法
		int isparentflag=-1;
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
			if (field.equals("nodetext")) {nodeField=field; }
			if (field.equals("syschecked")) {checkedflag=1; }
		}
		//从数据库取记录，转换成json格式数据
		while(node_rs.next()){
			str="{cid:\""+StringUtil.filterNull(node_rs.getString(keyField)).trim().replace("\"","").replace("'","\\'")+"\"";   //这里\之后的"为普通字符
			if (nodeField.equals("")) {  
				str=str+",flag:0,text:\""+StringUtil.filterNull(node_rs.getString(keyField)).trim().replace("\"","").replace("'","\\'");
				if (xcolcount>1){
					field=rsmd.getColumnName(2).toLowerCase();
					str=str+"&nbsp;"+StringUtil.filterNull(node_rs.getString(field)).trim().replace("\"","").replace("'","\\'");
				}
				str=str+"\"";   //这里\之后的"为普通字符	
			}else{
				str=str+",flag:0,text:\""+StringUtil.filterNull(node_rs.getString(nodeField)).trim().replace("\"","").replace("'","\\'")+"\"";   //这里\之后的"为普通字符
			}
			if (checkedflag==1){
				if (node_rs.getInt("syschecked")>0) str+=",checked: true";
				else str+=",checked: false";
			} 
			for (j=1;j<=xcolcount;j++) {
				field=rsmd.getColumnName(j).toLowerCase();
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
		//System.out.println("nodes="+result.toString());		
	}else{  
        if (recordCount <= maxReturnNumber || selectedCode.equals("")){ //全部节点显示
			//一次性全部提取记录节点，需要调用递归子程序getAllChildNodeByID。先取第一层节点，之后程序自动递归取后几层。
        	querystring=";with tmp as ("+sqlString+")";
        	querystring=querystring+",tmp1 as ( select "+keyField+",ParentNodeID from tmp";
        	if(!whereSQL.equals("")){
	        	querystring=querystring+" where "+whereSQL;
    	    }  
        	querystring=querystring+" union all select b."+keyField+",b.ParentnodeID from tmp1 as a,tmp as b ";
        	querystring=querystring+" where b."+keyField+"=a.ParentnodeID) ";
        	querystring=querystring+" select * from tmp where "+keyField+" in (select "+keyField+" from tmp1) ";
			querySQL.append(querystring);
			querySQL.append(" and ISNULL(ParentNodeID,'')='"+rootCode+"'");
			//int x1=querystring.lastIndexOf(" from ");  
			//int x2=querystring.lastIndexOf(" order by ");
			//if (x2<=0 || x2<x1) 
			querySQL.append(" order by "+sortField);
			//System.out.println("querySQL2="+querySQL.toString());
		}else{  //第一层节点和被选中的节点
        	//System.out.println("113");		
			//提取第一层节点和选中的节点极其所有父节点，需要调用递归子程序getAllChildNodeByID，但不是全部递归。
			//求出选中节点的所有父节点		 
			querySQL=new StringBuffer();		
			querySQL.append(";with tmp as ("+sqlString+")");
			querySQL.append(",tmp1 as (");
			querySQL.append(" select "+keyField+",ParentNodeID from tmp"); 
			querySQL.append(" where "+keyField+"='"+selectedCode+"'");
 			querySQL.append(" union all select b."+keyField+",b.ParentnodeID from tmp1 as a,tmp as b");  
 			querySQL.append(" where b."+keyField+"=a.ParentnodeID) ");
 			querySQL.append(" select * from tmp where "+keyField+" in (select "+keyField+" from tmp1) and "+keyField+"<>'"+selectedCode+"'");		
			stmt.executeQuery(querySQL.toString());
			//System.out.println(querySQL);		
			node_rs=stmt.getResultSet();
        	String whereSQL1="";
			while(node_rs.next()){//循环输出结果集
				whereSQL1=whereSQL1+" or ParentNodeID='"+StringUtil.filterNull(node_rs.getString(keyField)).replace("'","\\'")+"'";
			}
			//书写SQL语句，提取第一层节点和选中节点的所有父节点。程序会自动利用递归，提取选中节点的每个父节点之下的子节点	  
			querySQL=new StringBuffer();		
			querystring=";with tmp as ( "+sqlString+")";
			querystring=querystring+",tmp1 as ( select "+keyField+",ParentNodeID from tmp ";
        	querystring=querystring+" where ISNULL(ParentNodeID,'')='' "+whereSQL1;        
        	if(!whereSQL.equals("")){
	        	querystring=querystring+" and "+whereSQL;
        	}  
    	    querystring=querystring+" union all select b."+keyField+",b.ParentnodeID from tmp1 as a,tmp as b ";
        	querystring=querystring+" where b."+keyField+"=a.ParentnodeID) ";
        	querystring=querystring+" select * from tmp where "+keyField+" in (select "+keyField+" from tmp1) ";
			querySQL.append(querystring);
			querySQL.append(" and ISNULL(ParentNodeID,'')='"+rootCode+"'");
			//int x1=querystring.lastIndexOf(" from ");  
			//int x2=querystring.lastIndexOf(" order by ");
			//if (x2<=0 || x2<x1)	
			querySQL.append(" order by "+sortField);
			//System.out.println("querySQL3="+querySQL.toString());		
			//System.out.println(whereSQL1);		
		}
		//System.out.println("sql3="+querySQL.toString());
		stmt.executeQuery(querySQL.toString());
		node_rs=stmt.getResultSet();
		node_rs.last(); //移到最后一行
		int rowCount=node_rs.getRow(); //得到当前行号，也就是记录数
		node_rs.beforeFirst(); //如果还要用结果集，就把指针再移到初始化的位置
		ResultSetMetaData rsmd=node_rs.getMetaData();
        int xcolcount=rsmd.getColumnCount();
        String childnodestr="";
		String str="";
		String field="";
		int i=0;
		int j=0;
		for (j=1;j<=xcolcount;j++) {
			field=rsmd.getColumnName(j).toLowerCase();
			if (field.equals("nodetext")) { nodeField=field; }
			if (field.equals("syschecked")) { checkedflag=1; }
		}		
		String keyFieldvalue="";	//类别编码
		int isParentFlag=0;	//是否含有子节点
		if(rowCount>0){//判断结果集是否含有值
			while(node_rs.next()){//循环输出结果集
			keyFieldvalue=StringUtil.filterNull(node_rs.getString(keyField)).replace("'","\\'");  
			isParentFlag=node_rs.getInt("IsParentFlag");
			str="{cid:\""+StringUtil.filterNull(node_rs.getString(keyField)).trim().replace("\"","").replace("'","\\'")+"\""; 
			if (nodeField.equals("")) {  
				str=str+",flag:1,text:\""+StringUtil.filterNull(node_rs.getString(keyField)).trim().replace("\"","").replace("'","\\'");
				if (xcolcount>1){
					field=rsmd.getColumnName(2).toLowerCase();
					str=str+"&nbsp;"+StringUtil.filterNull(node_rs.getString(field)).trim().replace("\"","").replace("'","\\'");
				}	
				str=str+"\"";   //这里\之后的"为普通字符
			}else{
				str=str+",flag:0,text:\""+StringUtil.filterNull(node_rs.getString(nodeField)).trim().replace("\"","").replace("'","\\'")+"\"";   //这里\之后的"为普通字符
			}
			if (checkedflag==1){
				if (node_rs.getInt("syschecked")>0) str+=",checked: true";
				else str+=",checked: false";
			} 
			for (j=1;j<=xcolcount;j++) {
				field=rsmd.getColumnName(j).toLowerCase();  
				str=str+","+field+":\""+StringUtil.filterNull(node_rs.getString(field)).trim().replace("\"","").replace("'","\\'")+"\"";
			}
			returnResult.append(str);
			if(isParentFlag==1){//若当前类别编码信息含有子节点，则调用递归函数获取其下的所有子节点
				returnResult.append(",leaf:false");
				childnodestr=this.getAllChildNodeByID(connection,keyField,sortField,keyFieldvalue,querystring);
				if (childnodestr.equals("")) {   //如果没有子节点，不能写成children:[]。
					returnResult.append("}");
				}else{					
					returnResult.append(",children:[");
					returnResult.append(childnodestr);
					returnResult.append("]}");
				}
			}else if(isParentFlag==0){
				returnResult.append(",leaf:true,iconCls:'leafIcon'}");
			}
			if(i<rowCount-1){
				returnResult.append(",");
			}
			i++;
		}
	}else{ 
		returnResult.append("");
	}
	//System.out.println(returnResult.toString());
	response.getWriter().write("["+returnResult.toString()+"]");
	node_rs.close();
	stmt.close();
	connection.close();
}
%>	

<%
	connection.close();
 %>

<%!/*递归函数 获取对应节点下的所有子节点*/
	public String getAllChildNodeByID(Connection conn,String keyField,String sortField,String keyFieldvalue,String querystring)throws SQLException{
		StringBuffer result=new StringBuffer();//创建一个stringbuffer对象用于存放返回结果
		StringBuffer querySQL=new StringBuffer();//创建一个Stringbuffer对象用于存放查询语句
		Statement childnode_stmt=conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
        querySQL.append(querystring);
        querySQL.append(" and ISNULL(ParentNodeID,'')='"+keyFieldvalue+"'");
        //int x1=querystring.lastIndexOf(" from ");  
		//int x2=querystring.lastIndexOf(" order by ");
		//if (x2<=0 || x2<x1) 
		querySQL.append(" order by "+sortField);
        String childnodestr="";
		childnode_stmt.executeQuery(querySQL.toString());
		//System.out.println("querySQL4="+querySQL.toString());
		ResultSet childnode_rs=childnode_stmt.getResultSet();
		childnode_rs.last(); //移到最后一行
		int rowCount=childnode_rs.getRow(); //得到当前行号，也就是记录数
		childnode_rs.beforeFirst(); //如果还要用结果集，就把指针再移到初始化的位置
		ResultSetMetaData rsmd=childnode_rs.getMetaData();
        int xcolcount=rsmd.getColumnCount();		
		String nodeField="";
		int checkedflag=0;
		String str="";
		String field="";
		int i=0;
		int j=0;
		for (j=1;j<=xcolcount;j++) {
			field=rsmd.getColumnName(j).toLowerCase();
			if (field.equals("nodetext")) { nodeField=field; }
			if (field.equals("syschecked")) { checkedflag=1; }
		}
		String childId ="";	//类别编码
		int isParentFlag=0;	//是否含有子节点
		if(rowCount>0){//判断结果集是否含有值
			i=0;
			while(childnode_rs.next()){//循环结果集
				childId=StringUtil.filterNull(childnode_rs.getString(keyField)).replace("'","\\'");  
				isParentFlag=childnode_rs.getInt("IsParentFlag");
				str="{cid:\""+StringUtil.filterNull(childnode_rs.getString(keyField)).trim().replace("\"","").replace("'","\\'")+"\"";   //这里\之后的"为普通字符
				if (nodeField.equals("")) {  
					str=str+",flag:1,text:\""+StringUtil.filterNull(childnode_rs.getString(keyField)).trim().replace("\"","");
					if (xcolcount>1){
						field=rsmd.getColumnName(2).toLowerCase();
						str=str+"&nbsp;"+StringUtil.filterNull(childnode_rs.getString(field)).trim().replace("\"","").replace("'","\\'");
						str=str+"\"";   //这里\之后的"为普通字符
					}	
				}else{
					str=str+",flag:0,text:\""+StringUtil.filterNull(childnode_rs.getString(nodeField)).trim().replace("\"","").replace("'","\\'")+"\"";   //这里\之后的"为普通字符
				}	
				if (checkedflag==1){
					if (childnode_rs.getInt("syschecked")>0) str+=",checked: true";
					else str+=",checked: false";
				} 
				for (j=1;j<=xcolcount;j++) {
					field=rsmd.getColumnName(j).toLowerCase();  
					str=str+","+field+":\""+StringUtil.filterNull(childnode_rs.getString(field)).trim().replace("\"","").replace("'","\\'")+"\"";
				}				
				result.append(str);
				if(isParentFlag==1){//若当前类别编码信息含有子节点，则调用递归函数获取其下的所有子节点
					childnodestr=this.getAllChildNodeByID(conn,keyField,sortField,childId,querystring);
					if (childnodestr.equals("")) { //如果没有子节点，不能写成children:[]。
						result.append(",leaf:false}");						
					}else {
					result.append(",leaf:false,children:[");
					result.append(childnodestr);
					result.append("]}");
					}
				}else{
					result.append(",leaf:true,iconCls:'leafIcon'}");
				}
				if(i<rowCount-1){
					result.append(",");
				}
			    i++;	
			}
		}
		return result.toString();
	}
%>