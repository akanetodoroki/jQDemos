<%@ page language="java" import="java.util.*"  import="java.sql.*,com.DBConn" pageEncoding="utf-8"%>
<%@page import="com.StringUtil"%>
<%
	//如果要返回每列的宽度，可以将值放在data之后的第一行，其他行值不变。
	//从前台url取数据，使用params
	//System.out.println("----fn_getchartxml");
	//x规定坐标列名为label，
	String database=StringUtil.getUrlCHN(request.getParameter("database"));
	String xsqlString=StringUtil.getUrlCHN(request.getParameter("sqlString"));
	String xfields=StringUtil.getUrlCHN(request.getParameter("fields"));
	//String xkeyField=StringUtil.getUrlCHN(request.getParameter("keyField"));
	xsqlString=xsqlString.trim();
	//数据库连接
	DBConn con=new DBConn();
	Connection connection=con.getConnection(database);
	Statement stmt=connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
	StringBuffer result=new StringBuffer(); 
	stmt.executeQuery(xsqlString);
	ResultSet rs=stmt.getResultSet();
	rs.last();
	int rowCount=rs.getRow();
	ResultSetMetaData rsmd=rs.getMetaData();
	//int colCount=rsmd.getColumnCount();
	int j=0;
	String xfiddim[];
	xfiddim=xfields.split(";");  
	//int xwidth[]=new int[xcolcount+4];  //定义整型数组	
	//for (j=1;j<=xcolcount;j++) xwidth[j]=0;
	//开始取记录    
	String field="";
	String value="";
	String title="";
	String str="";
	if(rowCount>0){ //判断结果集是否含有数据
		result.append("<categories>\n");
		str=xfiddim[j];
		int index=str.indexOf("/");
		if (index>0){
			field=str.substring(0,index);
			title=str.substring(index);
		}else{
			field=str;
			title=field;
		}
		rs.beforeFirst();
		while(rs.next()) { //遍历记录进行数据组合
		    value=StringUtil.filterNull(rs.getString(field)).trim().replace("'","\\'");
		    result.append("<category label='"+value+"'/>\n");
		}
		result.append("\n</categories>\n");
		for (j=1;j<xfiddim.length;j++){
			str=xfiddim[j];
			index=str.indexOf("/");
			//System.out.println("index="+index+"---"+str);
			if (index>0){
				field=str.substring(0,index);
				title=str.substring(index);
			}else{
				field=str;
				title=field;
			}
			//System.out.println("field="+field+"---title="+title);
			rs.beforeFirst();
			//field=rsmd.getColumnName(j);
 			result.append("<dataset seriesName='"+title+"' Dashed='0' color='F6C11F' >\n");		
			while(rs.next()) { //遍历记录进行数据组合
		    	value=StringUtil.filterNull(rs.getString(field)).trim().replace("'","\\'");
		    	result.append("<set value='"+value+"'/>\n");
            }
 			result.append("</dataset>\n");		
		}
	}else{
		result.append("");
	}
	response.getWriter().write(result.toString());
	//System.out.println("xml="+result.toString());
	rs.close();
	stmt.close();
	connection.close();
%>