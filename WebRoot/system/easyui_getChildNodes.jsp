<%@ page language="java" import="java.util.*"  import="java.sql.*,com.DBConn" pageEncoding="utf-8"%>
<%@page import="com.StringUtil"%>
<%
	request.setCharacterEncoding("ISO-8859-1");
	String database=StringUtil.getUrlCHN(request.getParameter("database"));
	String keyfield=StringUtil.getUrlCHN(request.getParameter("keyfield"));   //获取主键字段名
	String sortfield=StringUtil.getUrlCHN(request.getParameter("sortfield")); 
	String selectsql=StringUtil.getUrlCHN(request.getParameter("selectsql")); //获取要显示的所有列名
	String iconcls=StringUtil.getUrlCHN(request.getParameter("iconcls"));   //节点图标文件名
	//selectsql=DBConn.myFromXcode(selectsql);
	String idfield="";
	StringBuffer result=new StringBuffer();//创建一个stringbuffer对象 用于存放最终返回结果
	//System.out.println("childsql="+selectsql);
	//连接数据库
	if (!selectsql.equals("")){
		DBConn con=new DBConn();
		Connection connection=con.getConnection(database);	
		StringBuffer querySQL=new StringBuffer();//创建一个stringbuffer对象用来存放查询语句
		Statement stmt=connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
		int xx1=selectsql.indexOf(";with ");
		int xx2=selectsql.indexOf("with ");
		int xx3=selectsql.indexOf(" as ");
		if ((xx1>=0 || xx2>=0) && (xx3>=0)){
			querySQL.append(selectsql);
			if (!sortfield.equals("")) querySQL.append(" order by "+sortfield);
		}else{	
			if (!sortfield.equals("")){
		    	querySQL.append("select * from ("+selectsql+") as p order by "+sortfield);
		    }else{
		    	querySQL.append(selectsql);
		    }
		}		    
		System.out.println("xx2="+xx2+",xx3="+xx3+",querySQL="+querySQL.toString());
		stmt.executeQuery(querySQL.toString());
		ResultSet node_rs=stmt.getResultSet(); //有多个结果集时，需要使用getResultSet()方法
		int isparentflag=-1;
		node_rs.last(); //移到最后一行
		int rowCount =node_rs.getRow(); //得到当前行号，也就是记录数
		node_rs.beforeFirst(); //如果还要用结果集，就把指针再移到初始化的位置
		ResultSetMetaData rsmd=node_rs.getMetaData();
		int xcolcount=rsmd.getColumnCount();
		String str="";
		String field="";
		String value="";
		int i=0;
		int j=0;
		for (j=1;j<=xcolcount;j++) {
			field=rsmd.getColumnName(j).toLowerCase();
			if (field.equals("id")){
				idfield=field;
				break;
			}
		}
		if (idfield.equals("")) { idfield=keyfield; }  
		//从数据库取记录，转换成json格式数据
		while(node_rs.next()){
			str="{";
			if (!iconcls.equals("")){
				str+="iconCls:'"+iconcls+"',";
			}
			str+="\"id\":\""+StringUtil.filterNull(node_rs.getString(idfield)).trim().replace("\"","").replace("'","\\'")+"\"";   //这里\之后的"为普通字符
			for (j=1;j<=xcolcount;j++) {
				field=rsmd.getColumnName(j).toLowerCase();
				if (!field.equals("id")){
					value=StringUtil.filterNull(node_rs.getString(field)).trim();  
					value=value.replace("\"","").replace("'","\\'");
					str=str+",\""+field+"\":\""+value+"\"";
				}	
			}
			isparentflag=node_rs.getInt("IsParentFlag");
			if (isparentflag>0){ //下面的closed很重要
				//子节点的值也要各不相同  =下划线+主键值
				String xid="_"+StringUtil.filterNull(node_rs.getString(keyfield)).trim().replace("\"","").replace("'","\\'")+"\"";
				result.append(str+",state:\"closed\",\"children\":[{\"id\":\""+xid+",\"cid\":\"\", \"text\":\" \"");  //添加一个虚拟空节点
				if (!keyfield.equals("id")) result.append(",\""+keyfield+"\":\"\""); 
				result.append("}]}");  //添加一个虚拟空节点
				result.append((i==rowCount-1?"":",")+"");
			}else{
				result.append(str+"}");
				result.append((i==rowCount-1?"":",")+"");				
			}
			i++;
		}
		node_rs.close();
		stmt.close();
		connection.close();
	}else{
		result.append("{}");
	}	
	//System.out.println("childnodes="+result.toString());		
	response.getWriter().write("["+result.toString()+"]");
%>