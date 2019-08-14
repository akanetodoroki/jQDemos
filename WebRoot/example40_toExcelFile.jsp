<%@ page language="java" import="java.util.*"  import="java.sql.*,com.DBConn" pageEncoding="utf-8"
contentType ="text/html;charset=gb2312" 
%>
<%@ page import="com.StringUtil,java.net.URLEncoder,
	org.apache.poi.hssf.usermodel.HSSFWorkbook,
	org.apache.poi.hssf.usermodel.HSSFSheet,
	org.apache.poi.hssf.usermodel.HSSFRow,
	org.apache.poi.hssf.usermodel.HSSFCell,
	org.apache.poi.hssf.util.Region,
	org.apache.poi.hssf.util.*,
	org.apache.poi.hssf.usermodel.HSSFFont,
 	org.apache.poi.hssf.usermodel.HSSFPrintSetup,
	org.apache.poi.hssf.usermodel.HSSFRichTextString,
	org.apache.poi.hssf.usermodel.*,
	org.apache.poi.hssf.*,
	org.apache.poi.poifs.filesystem.POIFSFileSystem,	
	java.io.* "
%> 
<% 
	//不是数据库中取出的列，汉字处理会乱码
	request.setCharacterEncoding("ISO-8859-1");
	request.setCharacterEncoding("utf8");
	String database=StringUtil.getUrlCHN(request.getParameter("database"));
	String xtemplate=StringUtil.getUrlCHN(request.getParameter("template"));
	String xselectsql=StringUtil.getUrlCHN(request.getParameter("selectsql"));
	xselectsql=xselectsql.trim();
	//数据库连接
	DBConn con=new DBConn();
	Connection connection=con.getConnection(database);
	Statement stmt=connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
	//执行查询语句
	stmt.executeQuery(xselectsql);
	ResultSet grid_rs=stmt.getResultSet();
	//ResultSetMetaData rsmd=grid_rs.getMetaData();
	int i=1;
	int j=0;
	int k=0;
	String fields="productid;productname;quantityperunit;unit;unitprice;qty1;amount1;qty2;amount2";
	String fielddim[];
	fielddim=fields.split(";");
	String value="";
	//取模板excel文件的路径和文件
	String root = application.getRealPath("/");
	String templatefile=root+"system/templates/"+xtemplate;
	//定义poi
	POIFSFileSystem fs=new POIFSFileSystem(new FileInputStream(templatefile));     
	HSSFWorkbook wb = new HSSFWorkbook(fs);     
	HSSFSheet sheet = wb.getSheetAt(0);
	//处理表头，每页重复打印第1行第1列~第4行第9列这个区域
	wb.setRepeatingRowsAndColumns(0,0,8,0,3);//(0,x1,x2,y1,y2)  
	HSSFRow row = null;
	HSSFCell cell = null;
	//记录模板表体中的第5行，其他行的单元格格式以第5为标准
	HSSFRow formatrow = sheet.getRow(4); 
	grid_rs.beforeFirst();
	i=1;
	while(grid_rs.next()) { //遍历记录进行数据组合
		if (i==1){
			row = sheet.getRow(4); //表体中第1行（即模板中第5行）不用创建，因为原来就存在
		}else{ 
			row = sheet.createRow(i+3);  //表体中第2行（模板中的第6行）之后的行需要新创建
		}
		for (j=1;j<=fielddim.length;j++) {  //循环处理一行中的每个列
			if (i==1){
				cell = row.getCell(j-1);
			}else{
				cell = row.createCell(j-1);
			} 
	  	  	value=grid_rs.getString(fielddim[j-1]).trim();  //提取取数据表中某个列的值
	    	cell.setCellValue(new HSSFRichTextString(value));  //将数据表某列值填充到单元格
			//将模板第5行formatrow的cellstyle复制过来存放在新的行中
			cell.setCellStyle(formatrow.getCell(j-1).getCellStyle());
			cell.setCellType(formatrow.getCell(j-1).getCellType());
		}
		row.setHeight(formatrow.getHeight());  //按模板设置行高
		i++;
	}	
	//表头前2行内容修改
	row = sheet.getRow(0);
	cell = row.getCell(0);
	cell.setCellValue("商品销售月报表");  //修改表头第1行
	row = sheet.getRow(1);
	cell = row.getCell(0);
	cell.setCellValue("2012年12月31日");  //修改表头第2行
	//写页脚footer的内容
	HSSFFooter footer=sheet.getFooter();
	footer.setLeft("制表人：诸葛亮");   //在页脚左边设置文字
	//在页脚中间显示页码，即页码居中
	footer.setCenter("第"+HSSFFooter.page()+"页/共"+HSSFFooter.numPages()+"页");  
	//写内容到临时文件
    String filename=root+"system/temp/"+xtemplate;
    FileOutputStream fo=new FileOutputStream(filename);
    wb.write(fo);
    fo.close();
    filename="////system////temp////"+xtemplate;  //需要4根斜杠。去掉root，在下载时自动会加上
	response.getWriter().write("[{\"totalcount\":\""+(i-1)+"\",\"filename\":\""+filename+"\"}]");
	grid_rs.close();
	stmt.close();
	connection.close();   
%>