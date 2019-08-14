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
	String database=StringUtil.getUrlCHN(request.getParameter("database"));
	String xtemplate=StringUtil.getUrlCHN(request.getParameter("template"));
	String xselectsql=StringUtil.getUrlCHN(request.getParameter("selectsql"));
	String xheaderrange=StringUtil.getUrlCHN(request.getParameter("headerrange"));
	String xheadercells = StringUtil.getUrlCHN(request.getParameter("headercells"));
	String xfootercells = StringUtil.getUrlCHN(request.getParameter("footercells"));
	String xregionrange=StringUtil.getUrlCHN(request.getParameter("regionrange"));  //sheet最大的行和列数
	String xcolfields=StringUtil.getUrlCHN(request.getParameter("fields"));  //sheet最大的行和列数
	xselectsql=DBConn.myFromXcode(xselectsql);
	//使用?传递，可以设别汉字
	xselectsql=xselectsql.trim();
	//System.out.println("xtemplate---"+xtemplate);
	//System.out.println("xheadercells---"+xheadercells);
	//数据库连接
	DBConn con=new DBConn();
	Connection connection=con.getConnection(database);
	Statement stmt=connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
	Statement stmt1=connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
	String root = application.getRealPath("/");
	String templatefile=root+"system/templates/"+xtemplate;
	stmt.executeQuery(xselectsql);
	ResultSet grid_rs=stmt.getResultSet();
	ResultSetMetaData rsmd=grid_rs.getMetaData();
	grid_rs.last();
	int rowCount=grid_rs.getRow();
	int i=1;
	int j=0;
	int k=0;
	int index1=-1;
	int index2=-1;
	int index3=-1;
	int index4=-1;
	int index5=-1;
	String rangedim[],fielddim[];
	fielddim=xcolfields.split(";");
	if (xcolfields.equals("") || fielddim.length==0){
		for (j=1;j<=rsmd.getColumnCount();j++){
			fielddim[j-1]=rsmd.getColumnName(j).toLowerCase();
		}
	}
	int xcolcount=fielddim.length;
	String field="";
	String value="";
	String s1="";
	String s2="";
	int x1=0;
	int y1=-1;
	int x2=fielddim.length-1;
	int y2=-1;
	//定义poi
	POIFSFileSystem fs=new POIFSFileSystem(new FileInputStream(templatefile));     
	HSSFWorkbook wb = new HSSFWorkbook(fs);     
	HSSFSheet sheet = wb.getSheetAt(0);
	//处理表头
	int firstcellrow=-1;
	int maxrowno=-1;
	if (!xheaderrange.equals("")){  //e.g. <1-3>;<30-32>
		//处理每页中需要重复打印的行
		rangedim=xheaderrange.split(";");
		for (i=0;i<rangedim.length;i++){
			index1=rangedim[i].indexOf("<");
			index2=rangedim[i].indexOf("-");
			index3=rangedim[i].indexOf(">");
			//System.out.println("range="+index1+"--"+index2+"---"+index3);
			if (index1==0 && index3>0){
				if (index2<0){
					s1=rangedim[i].substring(1,index3-1);
					s2=s1;
				}else{ 
					s1=rangedim[i].substring(1,index2);
					s2=rangedim[i].substring(index2+1,index3);
				}	
				y1=Integer.valueOf(s1).intValue()-1;		
				y2=Integer.valueOf(s2).intValue()-1;		
				if (y1>=0 && y2>=y1){
					wb.setRepeatingRowsAndColumns(0,x1,x2,y1,y2);  //每页重复打印这个区域
					if (firstcellrow<0) firstcellrow=y2+1;  //记录表体中的第一行，即格式参照行
				}
			}	
		} //for
	}
	if (firstcellrow<1) firstcellrow=1;
	//前台无法传非字段型字符汉字，只能传英文
	//amount表示“金额合计",amounttax表示‘价税合计’,$total$表示‘合计’
	HSSFRow row = null;
	HSSFCell cell = null;
	//记录模板表体中的第一行，其他行的单元格格式以第一行为标准
	HSSFRow firstrow = sheet.getRow(firstcellrow); 
	grid_rs.beforeFirst();
	i=1;
	while(grid_rs.next()) { //遍历记录进行数据组合
		if (i==1){  //第一行不用创建，原来模板中就有的
			row = sheet.getRow(firstcellrow+i-1);
		}else{  //第二行开始需要创建
			row = sheet.createRow(firstcellrow+i-1);
		}
		k=1;     
		//for (j=1;j<=rsmd.getColumnCount();j++) {  //处理一行中的每列
		for (j=1;j<=xcolcount;j++) {  //处理一行中的每列
			if (i==1){
				cell = row.getCell((short) k-1);
			}else{
				cell = row.createCell((short) k-1);
			} 
			field=fielddim[j-1];  //rsmd.getColumnName(j).toLowerCase();
	    	value=StringUtil.filterNull(grid_rs.getString(field)).trim().replace("'","\\'");
    		//去掉前台合计行中的html标记
	    	value=value.replace("<center>","");
	    	value=value.replace("</center>","");
    		value=value.replace("<b>","");
    		value=value.replace("</b>","");
	    	value=value.replace("&nbsp;","  ");
    		//将第一行的cellstyle复制过来放在新的行中
			cell.setCellStyle(firstrow.getCell(k-1).getCellStyle());
			cell.setCellType(firstrow.getCell(k-1).getCellType());
	    	cell.setCellValue(new HSSFRichTextString(value));
	    	//System.out.println("k="+k+",value="+value);
	    	
	    	//设置行高，否则会行高会发生变化
			row.setHeight(firstrow.getHeight());
			k++;
		}
		row.setHeight(firstrow.getHeight());
		//System.out.println("rowi="+i+"---"+xcolcount+"---"+rowCount);
		i++;
	}	
	//标题中固定值填充格式：e.g. <2,1>2012年12月份;<3,1>客户名称：浙江理工大学...
	grid_rs.beforeFirst();
	grid_rs.next();  //指针指向第一行
	if (!xheadercells.equals("")){
		//如果单元格内容中带@为变量，需要从第一行取对应的字段值替换@productname
		for (j=1;j<=xcolcount;j++) {  //处理一行中的每列
			field=fielddim[j-1];
	    	value=StringUtil.filterNull(grid_rs.getString(field)).trim().replace("'","\\'");
	    	xheadercells=xheadercells.replace("@"+field,value);
	    	//System.out.println(xheadercells+"**"+field+"****"+value);
	    }	
		x1=0;
		y1=-1;
		String valuedim[];
		valuedim=xheadercells.split(";");
		for (j=0;j<valuedim.length;j++){
			index1=valuedim[j].indexOf("<");
			index2=valuedim[j].indexOf(",");
			index3=valuedim[j].indexOf(">");
			s1="0";
			s2="0";
			if (index1==0 && index3>index2 && index2>index1){
				s1=valuedim[j].substring(1,index2);
				s2=valuedim[j].substring(index2+1,index3);
				value=valuedim[j].substring(index3+1);
				//System.out.println(s1+"**"+s2+"****"+value);
				y1=Integer.valueOf(s1).intValue()-1;		
				x1=Integer.valueOf(s2).intValue()-1;		
				//System.out.println(value+"---y1="+y1+"---x1="+x1+"***"+value);
				if (y1>=0 && x1>=0){
					HSSFRow rowx = sheet.getRow(( short ) y1);
					HSSFCell cellx = rowx.getCell(( short ) x1);
					cellx.setCellValue(value);
				}
			}		
		}
	}
	//写页脚footer的内容
	if (!xfootercells.equals("")){
		HSSFFooter footer=sheet.getFooter();
		//footer.setCenter("第"+HSSFFooter.page()+"页/共"+HSSFFooter.numPages()+"页");
		x1=0;
		y1=-1;
		String footerdim[];
		footerdim=xfootercells.split(";");
		//System.out.println(xfootercells+"====footer");
		for (j=0;j<footerdim.length;j++){
			s1=footerdim[j].toLowerCase();
			index1=s1.indexOf("<l>");
			index2=s1.indexOf("<c>");
			index3=s1.indexOf("<r>");
			if (index1>=0 || index2>=0 || index3>=0) s1=s1.substring(3);
			index4=s1.indexOf("pageno");
			index5=s1.indexOf("pagecount");
			if (index4>=0 || index5>=0){
				s1=s1.replace("pageno",HSSFFooter.page());
				s1=s1.replace("pagecount",HSSFFooter.numPages());
				s1=s1.replace("\"\"","\"");
				//s1=s1.substring(0,index4)+HSSFFooter.numPages()+s1.substring(index4+6);
				//s1="\""+s1.substring(0,index5)+"\"+HSSFFooter.numPages()+\""+s1.substring(index5+9)+"\"";
			}
			if (index1>=0) footer.setLeft(s1);
			else if (index2>=0)	footer.setCenter(s1);
			else footer.setRight(s1);
		}
	}
	if (!xregionrange.equals("")){  //删除多余的行
		rangedim=xregionrange.split(",");
		//System.out.println("regiomrange="+xregionrange);
		if (rangedim.length>=4){
			y1=Integer.parseInt(rangedim[0]);
			x1=Integer.parseInt(rangedim[1]);
			y2=Integer.parseInt(rangedim[2]);
			x2=Integer.parseInt(rangedim[3]);
			if (y2>=y1 && y1>0 && y2>0){ //删除模版中多余的行
	   		}
			//System.out.println("sheet.getLastRowNum="+(y2+1)+"--"+(sheet.getLastRowNum()+2)+"--"+(i));
			//sheet.shiftRows(y2+1, sheet.getLastRowNum()+2, y2-sheet.getLastRowNum()-1);
			//sheet.shiftRows(320, 520, -200);		
		}
	}
	//写文件到临时文件夹
    String filename=root+"\\system\\temp\\"+xtemplate;
    //System.out.println("excel 文件生成，存放在"+filename);
    FileOutputStream fo=new FileOutputStream(filename);
    wb.write(fo);
    fo.close();
    //System.out.println("{totalcount:\""+(i-1)+"\",filename:\""+filename+"\"}");
    filename="\\\\system\\\\temp\\\\"+xtemplate;  //需要4根斜杠。去掉root，在下载时自动会加上
	response.getWriter().write("[{\"totalcount\":\""+(i-1)+"\",\"filename\":\""+filename+"\"}]");
	grid_rs.close();
	stmt.close();
	connection.close();   
%>