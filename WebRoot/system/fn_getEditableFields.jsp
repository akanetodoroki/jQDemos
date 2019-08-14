<%@ page language="java" import="java.util.*"  import="java.sql.*,com.DBConn" pageEncoding="utf-8"%>
<%@page import="com.StringUtil"%>
<%
	//说明：判断关键字是否重复，并将数据保存到数据库
	//c:text,char:35,99,167,175,231,239
	//d:datetime,date:40,58,61,42
	//t:time:41
	//n:48,52,56,59,60,62,104,106,108,122,127
	//System.out.println("saverecord");
    //从前台传递参数,使用params传递
	String database=StringUtil.filterNull(request.getParameter("database"));
	String tableName=StringUtil.filterNull(request.getParameter("tableName"));//获取表名
	//连接数据库
	DBConn con=new DBConn();
	Connection connection=con.getConnection(database);
	Statement stmt=connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
	//先判断各个值是否存在
	String fieldSet="";
	int fieldCount=0;
	String sql="select name,type=system_type_id from sys.columns where object_id=object_id('"+tableName+"') ";
	sql+=" and is_computed=0 and is_identity=0 and is_rowguidcol=0"; //提取可编辑的列 
	ResultSet rs =stmt.executeQuery(sql);
	String type="";
	rs.beforeFirst();
	while(rs.next()){
		String xfield=rs.getString("name").toLowerCase();
		int id=rs.getInt("type");
		type="x";
		switch(id){
	case 35:case 99:case 167:case 175:case 231:case 239:
		type="c";
		break;   //字符型
	case 40:case 58:case 61:case 42:
		type="d";
		break; //日期型
	case 41:
		type="t";
		break;  //时间型
	case 104:
		type="l";
		break;  //逻辑型
	case 48:case 52:case 56:case 59:case 60:case 62:case 106:case 108:case 122:case 127:
		type="n";
		break;  //数值型
		} 
		if (!fieldSet.equals("")) fieldSet+=";"; 
		fieldSet+=type+":"+xfield;  //格式：“类型：字段名”
		fieldCount++;
	}			
	//System.out.println("{success:true,fieldSet:'"+fieldSet+"',fieldCount:"+fieldCount+"}");
	response.getWriter().write("{\"fieldSet\":'"+fieldSet+"',\"fieldCount\":"+fieldCount+"}");
	stmt.close();
	connection.close();
%>

 
 