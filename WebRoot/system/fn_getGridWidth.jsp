<%@ page language="java" import="java.util.*"  import="java.sql.*,com.DBConn" pageEncoding="utf-8"%>
<%@page import="com.StringUtil"%>
<%
	//如果要返回每列的宽度，可以将值放在data之后的第一行，其他行值不变。
	//从前台url取数据，使用params
	String database=StringUtil.filterNull(request.getParameter("database"));
	String xtablename=StringUtil.getUrlCHN(request.getParameter("tableName"));
	String xsqlstring=StringUtil.getUrlCHN(request.getParameter("sqlString"));
	String xfieldset=StringUtil.getUrlCHN(request.getParameter("fieldSet"));
	//数据库连接
	DBConn con=new DBConn();
	Connection connection=con.getConnection(database);
	Statement stmt=connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
	//计算总行数
	String fiddim[];
	fiddim=xfieldset.split(";");  
	String xcountSql="";
	String sql="";
	for (int i=0;i<fiddim.length;i++){
		if (!sql.equals("")) sql+=",";
		sql+="max(len(rtrim("+fiddim[i]+"))) as sys_"+fiddim[i];
	}
	if (!xtablename.equals(""))
		xcountSql="select "+sql+" from "+xtablename;
	else	
		xcountSql="select "+sql+" from ("+xsqlstring+") as p";
	//System.out.println("xcountSql="+xsqlstring);
	stmt.executeQuery(xcountSql);
	ResultSet rs=stmt.getResultSet();
	rs.beforeFirst();
	ResultSetMetaData rsmd=rs.getMetaData();
	int xcolcount=rsmd.getColumnCount();
	int j=0;
	String field="";
	String value="";
	String str="";
	String result=""; 
	if(rs.next()){
		for (j=1;j<=xcolcount;j++) {
			field=rsmd.getColumnName(j).toLowerCase();
		   	if (j>1){
		   		str=str+",";
		   		//result+=";";
		   	}
	   		value=StringUtil.filterNull(rs.getString(field)).trim().replace("'","\\'");
	    	str=str+field+":\""+value+"\"";
	    	//result+=str;
		}
        result+="{"+str+"}";
	}else
		result+="{}";
	//System.out.println("gridwidth="+result);
	response.getWriter().write(result);
	rs.close();
	stmt.close();
	connection.close();
%>