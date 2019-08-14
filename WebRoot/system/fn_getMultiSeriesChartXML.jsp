<%@ page language="java" import="java.util.*"  import="java.sql.*,com.DBConn" pageEncoding="utf-8"%>
<%@page import="com.StringUtil"%>
<%
	//从前台url取数据，使用params
	//System.out.println("----fn_getchartxml-multi");
	//x规定坐标列名为label，
	request.setCharacterEncoding("ISO-8859-1");
	String database=StringUtil.getUrlCHN(request.getParameter("database"));
	String xsqlString=StringUtil.getUrlCHN(request.getParameter("sqlString"));
	String xfields=StringUtil.getUrlCHN(request.getParameter("fields"));
	String xlinkfield=StringUtil.getUrlCHN(request.getParameter("linkFields"));
	String xcolors=StringUtil.getUrlCHN(request.getParameter("colors"));
	xsqlString=xsqlString.trim();
	System.out.println("xfields="+xfields);
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
	String xlinkfiddim[];
	String xfiddim[];
	String xcolordim[];
	xfiddim=xfields.split(";");  
	xlinkfiddim=xlinkfield.split(";");  
	xcolordim=xcolors.split(";");  
	//int xwidth[]=new int[xcolcount+4];  //定义整型数组	
	//for (j=1;j<=xcolcount;j++) xwidth[j]=0;
	//开始取记录    
	String field="";
	String value="";
	String title="";
	String str="";
	String keyvalue="";
	if(rowCount>0){ //判断结果集是否含有数据
		result.append("<categories>\n");
		str=xfiddim[j];
		int index=str.indexOf("/");
		if (index>0){
			field=str.substring(0,index);
			title=str.substring(index+1,str.length());
		}else{
			field=str;
			title=field;
		}
		rs.beforeFirst();
		while(rs.next()) { //遍历记录进行数据组合
		    value=StringUtil.filterNull(rs.getString(field)).trim().replace("'","\\'");
		    result.append("<category label='"+value+"'/>\n");
		}
		result.append("</categories>\n");
		//生成数据
		int i=0;
		for (j=1;j<xfiddim.length;j++){
			str=xfiddim[j];
			index=str.indexOf("/");
			//System.out.println("index="+index+"---"+str);
			if (index>0){
				field=str.substring(0,index);
				title=str.substring(index+1,str.length());
			}else{
				field=str;
				title=field;
			}
			//System.out.println("field="+field+"---title="+title);
			rs.beforeFirst();
			//field=rsmd.getColumnName(j);
			if (i>=xcolordim.length) i=0;
			//title不能处理汉字，到前台处理
			if (xcolordim.length>0 && !xcolordim[i].equals("")){
 				//result.append("<dataset seriesName='"+title+"' Dashed='0' color='"+xcolordim[i]+"'");
 				result.append("<dataset seriesName=@title"+j+"@ Dashed='0' color='"+xcolordim[i]+"'");
 			}else{
	 			//result.append("<dataset seriesName='"+title+"' Dashed='0'");
	 			result.append("<dataset seriesName=@title"+j+"@ Dashed='0' color=''");
 			}
 			if (j==xfiddim.length-1 && j>1 ){  //最后一个加这个属性
 				result.append(" parentYAxis='S'");
 			}
 			result.append(" >\n");
 			i++;		
			while(rs.next()) { //遍历记录进行数据组合
		    	value=StringUtil.filterNull(rs.getString(field)).trim().replace("'","\\'");
		    	result.append("<set value='"+value+"'");
		    	if (!xlinkfield.equals("")){  //处理link钻取
		    		result.append(" link='javascript: fn"+xlinkfiddim[0]+field+"Link(\"");
			    	for (int k=0;k<xlinkfiddim.length;k++){
			    		if (k>0) result.append(";");
					    keyvalue=StringUtil.filterNull(rs.getString(xlinkfiddim[k])).trim().replace("'","\\'");
				    	result.append(keyvalue);
			    	}
			    	result.append("\")'");	
		    	}
		   		result.append("  />\n");
            }
 			result.append("</dataset>\n");		
		}
	}else{
		result.append("");
	}
	response.getWriter().write(result.toString());
	System.out.println("xml="+result.toString());
	rs.close();
	stmt.close();
	connection.close();
%>