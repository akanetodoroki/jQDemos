<%@ page language="java" import="java.util.*"  import="java.sql.*" pageEncoding="utf-8" %>
<%@ page import="com.*" %>
<%@ page import="net.sf.json.JSONObject, net.sf.json.JSONArray" %>
<%@ page import="java.sql.ResultSet, java.sql.ResultSetMetaData" %>
<%
	//这里不用双引号。如有额问题，通改。
	//如果要返回每列的宽度，可以将值放在data之后的第一行，其他行值不变。
	//从前台url取数据，使用paramvalues
	System.out.println("----runprocedure");
	request.setCharacterEncoding("ISO-8859-1");
	String database=request.getParameter("database");
	String sqlprocedure=request.getParameter("sqlprocedure");
	String paramvalues=request.getParameter("paramvalues");
	//function=DBConn.myFromYcode(function);  //解密
	String selectsql="", field, value, xname, xlength, xprec, xscale, str="", result="", resultx="", resulty="";
	int xtype, xisoutparam;	
	ResultSet rs=null;
	ResultSet rsp=null;
	//UserBean userBean = (UserBean)session.getAttribute("user");
	//获取存储过程的参数
	DBConn dbconn=new DBConn();
	Connection connection=dbconn.getConnection("jqdemos");
	Statement stmt=connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
	//获取存储过程中的所有参数，包括输入参数和输出参数
	selectsql="select name,xtype,length,xprec,xscale,isoutparam from syscolumns where id in (select id from sysobjects where name='"+sqlprocedure+"')";
	stmt.executeQuery(selectsql);
	rs=stmt.getResultSet();
	ResultSetMetaData rsmd=rs.getMetaData();
	rs.last();
	int paramCount=rs.getRow();
	String valuelist[];
	//调用存储过程，有几个变量就写几个问号
	str="{call "+sqlprocedure+"(";
	for (int i=0; i<paramCount; i++){
		if (i>0) str+=",";
		str+="?";
	}
	str+=")}";
	System.out.println("procedureparamvalues="+paramvalues);	
	System.out.println("callstr="+str);	
	//CallableStatement stmtp=connection.prepareCall("{call sys_getpycode(?,?)}");
	CallableStatement stmtp=connection.prepareCall(str);
	//根据前台传递的参数值paramsvalues，对存储过程中的所有输入参数进行赋值;同时注册输出变量。
	//stmtp.setString(@name,'诸葛孔明');  //setDate, setINT..
	//stmtp.registerOutParameter(@xname, java.sql.Types.VARCHAR); //Types.FLOAT,Types.INTEGER,cstmt.registerOutParameter(2, java.sql.Types.DECIMAL, 3);
	if (paramvalues.equals("")) paramvalues=" "; 
	valuelist=paramvalues.split("	"); //tab分隔
	int k=0;
	//记录存储过程中的变量参数
	rs.beforeFirst();
	while(rs.next()) {
		xname=rs.getString("name");
		xtype=rs.getInt("xtype");
		//xlength=rs.getString("length");
		//xprec=rs.getString("xprec");
		//xscale=rs.getString("xscale");
		xisoutparam=rs.getInt("isoutparam");
		if (xisoutparam==0){  //为输入参数
		    //设置存储过程的输入参数     
		    if (k<valuelist.length){
				//stmtp.setString(k+1,valuelist[k]);  //setDate, setINT..
				stmtp.setString(xname, valuelist[k]);  //setDate, setINT..
	            System.out.println("inputparam="+xname+"---"+valuelist[k]);
		    }
			k++;
		}else{
		  	//注册存储过程的输出参数
			stmtp.registerOutParameter(xname, java.sql.Types.VARCHAR); //Types.FLOAT,Types.INTEGER
			System.out.println("outputparam="+xname+"---"+xtype);
		}
	}//while 		
	try{
		//执行该存储过程并返回select语句结果集     
		stmtp.execute();
		//mssql server需要先处理结果集的数据，MSSQL不支持在结果集被处理之前处理output的参数。
		//取存储过程中select语句返回的结果集（多行多列值）
		rsp=stmtp.getResultSet();
		while (rsp==null){//找到一个有结果集
			boolean flag=stmtp.getMoreResults();
			rsp=stmtp.getResultSet();
			System.out.println("morers="+flag);
		}
		resultx="";  //之前是output变量返回值，之后为select语句值
		if (rsp!=null){  //具有select语句查询结果
			int columnCount=rsp.getMetaData().getColumnCount();  
			int i=1;
			while(rsp.next()) {
				if (i==1) str=",\"sysrowno\":\""+i+"\""; //行号
				else str="{\"sysrowno\":\""+i+"\""; //行号
				for (int j=1; j<=columnCount; j++) {
					field=rsp.getMetaData().getColumnName(j).toLowerCase();
				    value=StringUtil.filterNull(rsp.getString(field)); //.trim();
					value=value.replace("\\","\\\\");  //无法返回斜杠，用于kindeditor
			    	value=value.replace("\"","\\\"");  //无法返回双引号
			    	value=value.replace("'","\\'");    //替换单引号
				    if (j>0) str=str+",";
			    	str=str+"\""+field+"\":\""+value+"\""; //实际列
				}
				str+="}";
				if (i>1) str=","+str;
			 	str+="\n";
			 	resultx+=str;
			 	i++;
			}
		}
    	//取output输出变量返回的值,一个个变量处理，结果放在json返回数据的第一行中
		resulty="[{'error':''";
		stmtp.getMoreResults();
		System.out.println("mo1111rers=");
		k=1;
		rs.beforeFirst();
		while(rs.next()) {
			xname=rs.getString("name");
			xtype=rs.getInt("xtype");
			//xlength=rs.getString("length");
			//xprec=rs.getString("xprec");
			//xscale=rs.getString("xscale");
			xisoutparam=rs.getInt("isoutparam");
			if (xisoutparam>0){  //为输入参数
				System.out.println("proc3="+xname);
				str=stmtp.getString(xname);  //去掉变量开头的@符号
				System.out.println("procstr="+str);
				resulty+=",\""+xname.substring(1)+"\":\""+str+"\"";
				k++;
			}
		} //while
		if (resultx.equals("")) resultx="}";
		result=resulty+resultx;
		//System.out.println("resultx="+resultx);
		result+="]";
	}catch (Exception e){
		result="[{'error':'"+e.getMessage()+"'}]";
	}
	//System.out.println("procstr="+result);   
	//关闭可调用的对象     
	stmt.close();     
	stmtp.close();     
	if (rs!=null) rs.close();
	if (rsp!=null) rsp.close();
	connection.close();
	response.getWriter().write(result);
%>