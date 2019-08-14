<%@ page language="java" import="java.util.*"  import="java.sql.*,com.DBConn" pageEncoding="utf-8"%>
<%@page import="com.StringUtil"%>
<%
	//这里不用双引号。如有额问题，通改。
	//如果要返回每列的宽度，可以将值放在data之后的第一行，其他行值不变。
	//从前台url取数据，使用params
	//System.out.println("----fn_getgriddata");
	request.setCharacterEncoding("ISO-8859-1");
	String database=StringUtil.getUrlCHN(request.getParameter("database"));
	String selectsql=StringUtil.getUrlCHN(request.getParameter("selectsql"));
	String xkeyfield=StringUtil.getUrlCHN(request.getParameter("keyfield"));
	String xsortfield=StringUtil.getUrlCHN(request.getParameter("sortfield"));
	int xlimit=Integer.parseInt(request.getParameter("limit")); //每页行数，等于0表示返回全部
	int xstart=Integer.parseInt(request.getParameter("start")); //每页行数，等于0表示返回全部
	String xsummeryfields=StringUtil.getUrlCHN(request.getParameter("summeryfields")); //注释行，可汇总列
	selectsql=selectsql.trim();
	//selectsql=DBConn.myFromXcode(selectsql);
	//System.out.println("limit="+request.getParameter("limit"));
	//System.out.println("start="+request.getParameter("start"));
	//System.out.println("xsummeryfields="+xsummeryfields);
	//System.out.println("sql="+selectsql);	
	//数据库连接
	//System.out.println("sql="+selectsql+"--"+xstart+"--"+xlimit);
	DBConn con=new DBConn();
	Connection connection=con.getConnection(database);
	Statement stmt=connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
	//StringBuffer sqlstmt=new StringBuffer(); //创建一个stringbuffer对象用于存放查询语句
	ResultSetMetaData rsmd=null;
	ResultSet rs=null;
	if (xsortfield.equals("")) xsortfield=xkeyfield;
	//计算总行数
	String xcountsql="";
	String xquerysql="";
	String xwithsql="";
	String xwithtmp="";
	String xsummerysql="";
	String field="";
	String value="";
	String str="";
	String result=""; //用于存放 最终返回结果
	String resultx="''"; //用于存放最终返回的关键字值，放在第一行
	String footer=""; //用于存放注释
	//对带with as的SQL语句进行处理，要求前台sql语句中不能使用query_tmp名称，最后一条查询语句为select * from ?语句。
	int xx1=selectsql.indexOf(";with ");
	int xx2=selectsql.indexOf("with ");
	int xx3=selectsql.indexOf(" as ");
	if ((xx1>=0 || xx2>=0)&&(xx3>=0)){  //selectsql.substring(0,5).toLowerCase().equals("with ")||selectsql.substring(0,6).toLowerCase().equals(";with ")){
		int x1=selectsql.lastIndexOf("select");
		int x2=selectsql.lastIndexOf(" from ");
		//提取with ?? as中的临时表名称
		xwithtmp=selectsql.substring(xx2+5,xx3-1);
		if (x1>0 && x2>x1) {  //包含with和as
			xcountsql=selectsql.substring(0,x1-1)+" select count(*) as n "+selectsql.substring(x2+1)+"\n";
			xsummerysql=selectsql.substring(0,x1-1)+" select "+xsummeryfields+" "+selectsql.substring(x2+1)+"\n";
			xwithsql=selectsql.substring(0,x1-1)+",query_tmp as ("+selectsql.substring(x1)+")\n";
			if (xlimit==0){ 		
				xquerysql="select top 100 percent * from query_tmp where "+xkeyfield+" not in \n";
			}else{
				xquerysql="select top "+xlimit+" * from query_tmp where "+xkeyfield+" not in";
			}
			xquerysql+="(select top "+(xstart)+" "+xkeyfield+" from query_tmp order by "+xsortfield+")\n";
			xquerysql+=" order by "+xsortfield;
			xquerysql=xwithsql+xquerysql;
		}
	}else{	
		xcountsql="select count(*) as n from ("+selectsql+") as p \n";
		xsummerysql="select "+xsummeryfields+" from ("+selectsql+") as p \n";
		xwithsql="with query_tmp as ("+selectsql+")\n";
		if (xlimit==0){ 		
			xquerysql="select top 100 percent * from query_tmp where "+xkeyfield+" not in \n";
		}else{
			xquerysql="select top "+xlimit+" * from query_tmp where "+xkeyfield+" not in \n";
		}	
		xquerysql+="(select top "+(xstart)+" "+xkeyfield+" from query_tmp order by "+xsortfield+")\n";
		xquerysql+=" order by "+xsortfield;
		xquerysql=xwithsql+xquerysql;
	}
	//System.out.println("xcountsql="+xcountsql);	
	//System.out.println("xsummerysql="+xsummerysql);	
	stmt.executeQuery(xcountsql);
	rs=stmt.getResultSet();
	rs.last();
	int rowCount=rs.getInt("n");
	//System.out.println("rowcount="+rowCount);	
	//提取分页数据
	if (xstart<0) { 
		xstart=0; 
	}	
	if (xlimit==0) { 
		xlimit=rowCount;
	}	
	//System.out.println("xquerysql="+xquerysql);	
	stmt.executeQuery(xquerysql);
	ResultSet grid_rs=stmt.getResultSet();
	grid_rs.beforeFirst();
	rsmd=grid_rs.getMetaData();
	int xcolcount=rsmd.getColumnCount();
	//查找关键字所在的行号
	int i=1;
	int j=0;	
	String rowfieldstr="\"\"";
	for (j=1;j<=xcolcount;j++) {
		field=rsmd.getColumnName(j).toLowerCase();
		//if (j>1) rowfieldstr+="+\",";
		//rowfieldstr+="+\",'"+field+"':'\"+StringUtil.filterNull(grid_rs.getString('"+field+"')).trim()+\"'\"";
	}
	//System.out.println(rowfieldstr);	
	//int xwidth[]=new int[xcolcount+4];  //定义整型数组	
	//for (j=1;j<=xcolcount;j++) xwidth[j]=0;
	if(rowCount>0){ //判断结果集是否含有数据
		//result=("{totalCount:\""+rowCount+"\",data:[");
		result="";
		while(grid_rs.next()) { //遍历记录进行数据组合
			//System.out.println("rownumber="+xstart+i);
			//resultx+=",'"+StringUtil.filterNull(grid_rs.getString(xkeyfield)).trim()+"'";
			if (i>1) result+=",";
			str="\"rownumber\":\""+(xstart+i)+"\"";  //记录行号
			for (j=1;j<=xcolcount;j++) {
				field=rsmd.getColumnName(j).toLowerCase();
		    	if (j>0) str=str+",";
		    	value=StringUtil.filterNull(grid_rs.getString(field)).trim();
		    	//value=value.replace("\\","\\\\");  //用于一本格式,客户端返回中有4个\
		    	value=value.replace("\\","\\\\");  //用于kindeditor,客户端返回中有4个\
		    	value=value.replace("\"","\\\"");  //无法返回双引号
		    	str=str+"\""+field+"\":\""+value+"\"";
            }
            if (i==1) result+=""+str+"}\n";
            else result+="{"+str+"}\n";
            //System.out.println("str"+i+"="+str);
			i++;
		}
		//================================================================//
		//计算汇总值作为footer输出
		if (!xsummeryfields.equals("")){
			stmt.executeQuery(xsummerysql);
			grid_rs=stmt.getResultSet();
			grid_rs.beforeFirst();
			rsmd=grid_rs.getMetaData();
			xcolcount=rsmd.getColumnCount();
			footer="";
			i=1;
			while(grid_rs.next()) { //遍历记录进行数据组合
				if (i>1) footer+=",";
				str="{";
				for (j=1;j<=xcolcount;j++) {
					field=rsmd.getColumnName(j).toLowerCase();
			    	if (j>1) str=str+",";
			    	value=StringUtil.filterNull(grid_rs.getString(field)).trim();
			    	value=value.replace("\\","\\\\");  //无法返回斜杠
			    	value=value.replace("\"","\\\"");  //无法返回双引号
			    	str=str+"\""+field+"\":\""+value+"\"";
	            }
	            if (i==1) footer+=""+str+"}\n";
	            else footer+="{"+str+"}\n";
				i++;
			}
		}	
		//==========汇总值计算结束==================================================//		
		str="";
		if (!result.equals(""))	result="{\"total\":\""+rowCount+"\",\"rows\":\n[{"+result+"\n";
		else result="{\"total\":\""+rowCount+"\",\"rows\":[\n";
		result+="],\"footer\":["+footer+"]";
		result+="}";
	}else{
		result+="{\"total\":0,\"rows\":[ ],\"footer\":[ ]}";
	}
	//System.out.println("gridresult="+result);
	//System.out.println("gridresult\n");
	response.getWriter().write(result);
	grid_rs.close();
	stmt.close();
	connection.close();
%>