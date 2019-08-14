<%@ page language="java" import="java.util.*"  import="java.sql.*,com.DBConn" pageEncoding="utf-8"%>
<%@page import="com.StringUtil"%>
<%
	///功能：从数据库提取前台TreeGrid控件的节点，包括各列数据。输入参数：searchtext、、keyfield、sqlstring 
	//输出结果中cid为标识值；flag=1表示一次性全部返回节点，flag=0表示分层返回子节点；text为节点内容，暂时没有用到它。
	//如果含有checkboxflag这一列，则显示checkbox 
	//存储过程的select语句中必须有id,text,isparentflag,parentnodeid,ancester,level这6个列
	//不考虑存储过程中的输出变量
	System.out.println("fullsql");
	request.setCharacterEncoding("utf-8");
	String database=request.getParameter("database").trim();
	String sqlprocedure=request.getParameter("sqlprocedure").trim();
	String paramvalues=request.getParameter("paramvalues");
	//function=DBConn.myFromYcode(function);  //解密
	String selectsql="", field, value, xname, xlength, xprec, xscale, str="", results="";
	int xtype, xisoutparam;	
	ResultSet rs=null, node_rs=null;
	//UserBean userBean = (UserBean)session.getAttribute("user");
	//获取存储过程的参数
	DBConn dbconn=new DBConn();
	Connection connection=dbconn.getConnection(database);
	Statement stmt=connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
	//执行存储过程开始，获取存储过程中的所有参数，包括输入参数和输出参数
	selectsql="select name,xtype,length,xprec,xscale,isoutparam from syscolumns where id in (select id from sysobjects where name='"+sqlprocedure+"')";
	stmt.executeQuery(selectsql);
	System.out.println("sql="+selectsql);	
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
	CallableStatement stmtp=connection.prepareCall(str);
	if (paramvalues.equals("")) paramvalues=" "; 
	valuelist=paramvalues.split("	"); //tab分隔，将各个参数值分离后存放在一个数组中
	int k=0;
	//记录存储过程中的变量参数
	rs.beforeFirst();
	while(rs.next()) {
		xname=rs.getString("name");
		xtype=rs.getInt("xtype");
		xisoutparam=rs.getInt("isoutparam");
		if (xisoutparam==0){  //为输入参数
		    //设置存储过程的输入参数     
		    if (k<valuelist.length) stmtp.setString(xname, valuelist[k]);  //setDate, setINT..
			k++;
		}else{
		  	//注册存储过程的输出参数
			stmtp.registerOutParameter(xname, java.sql.Types.VARCHAR); //Types.FLOAT,Types.INTEGER
		}
	} //while
	//判断存储过程执行后有没有select语句结果集返回
	try{
		//执行该存储过程并返回select语句结果集到node_rs,mssql server需要先处理结果集的数据，MSSQL不支持在结果集被处理之前处理output的参数。
		//stmtp.execute();
		node_rs=stmtp.executeQuery();  //取存储过程中的select语句结果集
	}catch (Exception e){
		//没有select语句结果集时，try之后的语句退出，执行catch之后的语句，这时将node_rs设置为null
		node_rs=null;
	}
	//执行存储过程结束，获取select查询语句的结果集，开始构造树节点
	if (node_rs!=null){ //判断结果集是否含有值
		rsmd=node_rs.getMetaData();
		int columnCount=rsmd.getColumnCount();
		int level=0, i=0, j=0;
		String idfield="", textfield="";  //有没有树节点必须的id列
		for (j=1;j<=columnCount;j++) {
			field=rsmd.getColumnName(j).toLowerCase();
			if (field.equals("id")) idfield=field;
			else if (field.equals("text")) textfield=field;
			if (!idfield.equals("") && !textfield.equals("")) break;
		}
		//if (idfield.equals("")) idfield=rsmd.getColumnName(1).toLowerCase();
		int isParentFlag=0;	//是否含有子节点
		int xlevel=1;
		int flag=0;
		results+="["; 
		while (node_rs.next()){//循环输出结果集
			isParentFlag=node_rs.getInt("isparentflag");
			level=node_rs.getInt("level");
			str="";
			if (level==xlevel){
				if (flag==1) str+=",";
			}else{
				for (i=level;i<xlevel;i++) results+="]}\n";
				xlevel=level;
				if (flag!=0) str+=",";
			}			
			str+="{";
			//先取节点的ID和text列的值，避免列重复
			value=StringUtil.filterNull(node_rs.getString(idfield)).trim();
			str+="\"id\":\""+value.replace("\"","").replace("'","\\'")+"\"";
			value=StringUtil.filterNull(node_rs.getString(textfield)).trim();
			str+=",\"text\":\""+value.replace("\"","").replace("'","\\'")+"\"";
			for (j=1;j<=columnCount;j++){
				field=rsmd.getColumnName(j).toLowerCase();
				if (!field.equals(idfield) && !field.equals(textfield)){
					value=StringUtil.filterNull(node_rs.getString(field)).trim();
					str=str+",\""+field+"\":\""+value.replace("\"","").replace("'","\\'")+"\"";
				}
			}
			//System.out.println(str);			
			results+=str;
			flag=1;
			if (isParentFlag>0){
				results+=",\n\"children\":[";
				flag=0;
			}else{
				results+="}\n";
			}
			xlevel=level;
			i++;
		} //while
		for (i=1;i<xlevel;i++)	results+="]}\n";
		results+="]\n";
	}else{
		results+="";
	}
	//System.out.println("result="+results);
	if (rs!=null) rs.close();
	if (node_rs!=null) node_rs.close();
	stmt.close();
	connection.close();
	response.getWriter().write(results);
%>	
