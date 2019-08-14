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
	String xlinkfield=StringUtil.getUrlCHN(request.getParameter("linkFields"));
	String xcolors=StringUtil.getUrlCHN(request.getParameter("colors"));
	//String xlinkfield=StringUtil.getUrlCHN(request.getParameter("linkfield"));
	xsqlString=xsqlString.trim();
	//数据库连接
	DBConn con=new DBConn();
	Connection connection=con.getConnection(database);
	Statement stmt=connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
	StringBuffer result=new StringBuffer(); 
	//System.out.println("chartsql="+xsqlString);
	stmt.executeQuery(xsqlString);
	ResultSet rs=stmt.getResultSet();
	rs.last();
	int rowCount=rs.getRow();
	ResultSetMetaData rsmd=rs.getMetaData();
	//int colCount=rsmd.getColumnCount();
	int i=1;
	int j=0;
	String xlinkfiddim[];
	String xfiddim[];
	String xcolordim[];
	xfiddim=xfields.split(";");  
	xlinkfiddim=xlinkfield.split(";");  
	xcolordim=xcolors.split(";");  
	//if (xcolordim.length==0){ xcolordim[0]="F6C11F"; }
	//int xwidth[]=new int[xcolcount+4];  //定义整型数组	
	//for (j=1;j<=xcolcount;j++) xwidth[j]=0;
	//开始取记录    
	String field1="";
	String value1="";
	String title1="";
	String field2="";
	String value2="";
	String title2="";
	String value3="";
	String str="";
	if(rowCount>0){ //判断结果集是否含有数据
		str=xfiddim[0];
		int index=str.indexOf("/");
		if (index>0){
			field1=str.substring(0,index);
			title1=str.substring(index);
		}else{
			field1=str;
			title1=field1;
		}
		str=xfiddim[1];
		index=str.indexOf("/");
		if (index>0){
			field2=str.substring(0,index);
			title2=str.substring(index);
		}else{
			field2=str;
			title2=field2;
		}
		i=0;
		rs.beforeFirst();
		while(rs.next()) { //遍历记录进行数据组合
		    value1=StringUtil.filterNull(rs.getString(field1)).trim().replace("'","\\'");
		    value2=StringUtil.filterNull(rs.getString(field2)).trim().replace("'","\\'");
		    if (i>=xcolordim.length) i=0;
			//System.out.println("values="+value1+"---"+value2+"---"+i);
			//set color必须有，值为空也可以
			if (xcolordim.length>0 && !xcolordim[i].equals("")){
		    	result.append("<set color=\""+xcolordim[i]+"\" label=\""+value1+"\" value=\""+value2+"\"");
		    }else{
		    	result.append("<set color='' label=\""+value1+"\" value=\""+value2+"\"");
		    }
		    if (!xlinkfield.equals("")){  //处理link钻取
		    	result.append(" link='javascript: fn"+xlinkfiddim[0]+field2+"Link(\"");
		    	for (int k=0;k<xlinkfiddim.length;k++){
		    		if (k>0) result.append(";");
				    value3=StringUtil.filterNull(rs.getString(xlinkfiddim[k])).trim().replace("'","\\'");
			    	result.append(value3);
			    }
			    result.append("\")'");	
		    }
		    result.append(" />\n");
		    i++;
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