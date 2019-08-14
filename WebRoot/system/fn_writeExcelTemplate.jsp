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
	String xtitlerange=StringUtil.getUrlCHN(request.getParameter("titlerange"));
	String xheadercells = StringUtil.getUrlCHN(request.getParameter("headercells"));
	String xfootercells = StringUtil.getUrlCHN(request.getParameter("footercells"));
	String xregionrange=StringUtil.getUrlCHN(request.getParameter("regionrange"));  //sheet最大的行和列数
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
	grid_rs.last();
	int rowCount=grid_rs.getRow();
	ResultSetMetaData rsmd=grid_rs.getMetaData();
	int xcolcount=0;
	int i=1;
	int j=0;
	int k=0;
	int totalrowflag=0;  //是否有合计行
	String field="";
	String value="";
	for (j=1;j<=rsmd.getColumnCount();j++) {
		field=rsmd.getColumnName(j).toLowerCase();
    	if (!field.equals("totalrmb") && !field.equals("sortflag")){
    		xcolcount++;
    	}else if (field.equals("totalrmb")){
    		totalrowflag=j;
		}
    }	
	String s1="";
	String s2="";
	int index1=-1;
	int index2=-1;
	int index3=-1;
	int index4=-1;
	int index5=-1;
	int x1=0;
	int y1=-1;
	int x2=xcolcount-1;
	int y2=-1;
	String rmbstr="";  //大写汉字提示字符
	String rmbdim[];
	String rangedim[];
	//定义poi
	POIFSFileSystem fs=new POIFSFileSystem(new FileInputStream(templatefile));     
	HSSFWorkbook wb = new HSSFWorkbook(fs);     
	HSSFSheet sheet = wb.getSheetAt(0);
	//HSSFCellStyle cellSytle = wb.createCellStyle();
	//人民币大写行字体对齐设置
	HSSFCellStyle rmbStyle= wb.createCellStyle();
   	rmbStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框
	rmbStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框
	rmbStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框
	rmbStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框
	rmbStyle.setAlignment(HSSFCellStyle.ALIGN_LEFT);
	rmbStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);  //垂直居中
	HSSFFont rmbFont = wb.createFont();
	//合计行字体对齐设置
	HSSFCellStyle totalStyle= wb.createCellStyle();
   	totalStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框
	totalStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框
	totalStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框
	totalStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框
	totalStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
	totalStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);  //垂直居中
	HSSFFont totalFont = wb.createFont();
	//HSSFCell.CELL_TYPE_NUMERIC
	//处理标题
	int firstcellrow=-1;
	int maxrowno=-1;
	if (!xtitlerange.equals("")){
		rangedim=xtitlerange.split(";");
		for (i=0;i<rangedim.length;i++){
			index1=rangedim[i].indexOf("-");
			s1=rangedim[i].substring(0,index1);
			s2=rangedim[i].substring(index1+1);
			//System.out.println("s1="+s1+"---s2="+s2);
			index2=s1.indexOf("<");
			index3=s1.indexOf(">");
			if (index2>=0 && index3>=0){
				y1=Integer.valueOf(s1.substring(index2+1,index3)).intValue()-1;		
			}
			index2=s2.indexOf("<");
			index3=s2.indexOf(">");
			if (index2>=0 && index3>=0){
				y2=Integer.valueOf(s2.substring(index2+1,index3)).intValue()-1;		
			}
			if (y1>=0 && y2>=y1){
				wb.setRepeatingRowsAndColumns(0,x1,x2,y1,y2);  //每页重复打印这个区域
				if (firstcellrow<0) firstcellrow=y2+1;  //第一次最后一行为准
			}
		}
	}
	if (firstcellrow<1) firstcellrow=1;
	//前台无法传非字段型字符汉字，只能传英文
	//amount表示“金额合计",amounttax表示‘价税合计’,$total$表示‘合计’
	HSSFRow row = null;
	HSSFCell cell = null;
	HSSFRow firstrow = sheet.getRow(firstcellrow);  //单元格格式已第一行为标准
	grid_rs.beforeFirst();
	while(grid_rs.next()) { //遍历记录进行数据组合
		//判断并处理合计行
		if (totalrowflag>0 && i==rowCount){  //最后一行
			//如果有合计行而且是最后一行，则先插入空行填满，再写最后行。
			value=StringUtil.filterNull(grid_rs.getString("totalrmb")).trim().replace("'","\\'");		
			rmbdim=value.split(";");
			if (rmbdim.length>=3 && Integer.parseInt(rmbdim[0])>0){
				if (rmbdim[1].equals("amounttax")) rmbstr="价税合计";
				else rmbstr="金额合计";
				stmt1.executeQuery("select dbo.sys_floattormb("+rmbdim[2]+") as rmb");
				ResultSet rs=stmt1.getResultSet();
				rs.last();
				//System.out.println("rmb="+rs.getString("rmb").trim());
				rmbstr+="（人民币大写）："+rs.getString("rmb").trim(); //StringUtil.myRmb(rmbamt);
				rmbstr+="      （小写）￥"+rmbdim[2];
				rs.close();
				stmt1.close();
				int linesperpage=Integer.valueOf(rmbdim[0]).intValue();
				int n=i%linesperpage;
				int p=n-1;
				//循环填写空行
				for (p=n-1;p<linesperpage-1;p++){
					row = sheet.createRow(firstcellrow+i+p-n);
					for (j=1;j<=xcolcount;j++) {
						cell = row.createCell((short) j-1);
		    			cell.setCellValue(new HSSFRichTextString(""));
						cell.setCellStyle(firstrow.getCell(j-1).getCellStyle());
						cell.setCellType(firstrow.getCell(j-1).getCellType());
					}				
					row.setHeight(firstrow.getHeight());
				}
				y1=firstcellrow+i+p-n; //记录最后一行的行号
				i=i+p-n; //记录打印最后行
			}
		}  //空行处理结束
		//处理数据库中正常的行
		if (i==1){
			row = sheet.getRow(firstcellrow+i-1);
		}else{
			row = sheet.createRow(firstcellrow+i-1);
			//row.setRowStyle(firstrow.getRowStyle());
		}
		k=1;     
		for (j=1;j<=rsmd.getColumnCount();j++) {
			if (i==1){
				cell = row.getCell((short) k-1);
			}else{
				cell = row.createCell((short) k-1);
			} 
			field=rsmd.getColumnName(j).toLowerCase();
	    	value=StringUtil.filterNull(grid_rs.getString(field)).trim().replace("'","\\'");
	    	if (!field.equals("totalrmb") && !field.equals("sortflag")){
	    		//去掉前台合计行中的html标记
		    	value=value.replace("<center>","");
		    	value=value.replace("</center>","");
	    		value=value.replace("<b>","");
	    		value=value.replace("</b>","");
		    	value=value.replace("&nbsp;","  ");
		    	//处理合计行，使其居中。
		    	if (value.indexOf("$total$")>0){
		    		value=value.replace("$total$","合  计");
			    	totalFont.setFontHeightInPoints(firstrow.getCell(0).getCellStyle().getFont(wb).getFontHeightInPoints());
			    	totalFont.setFontName(firstrow.getCell(0).getCellStyle().getFont(wb).getFontName());
					totalStyle.setFont(totalFont);
					cell.setCellStyle(totalStyle);
		    	}else{
		    		//将第一行的cellstyle复制过来放在新的行中
					cell.setCellStyle(firstrow.getCell(k-1).getCellStyle());
					cell.setCellType(firstrow.getCell(k-1).getCellType());
		    	} 
		    	cell.setCellValue(new HSSFRichTextString(value));
		    	//设置行高，否则会行高会发生变化
				row.setHeight(firstrow.getHeight());
				k++;
			}
		}
		row.setHeight(firstrow.getHeight());
		//System.out.println("rowi="+i+"---"+xcolcount+"---"+rowCount);
		i++;
	}	
	//处理人民币大写合计行。rrrrrrr
	if (y1>0 && totalrowflag>0 && !rmbstr.equals("")){
		x1=0;
		x2=xcolcount-1;
		row = sheet.createRow(y1);
		for (j=1;j<=xcolcount;j++){
			cell = row.createCell((short) j-1);
			cell.setCellValue(" ");
			cell.setCellStyle(firstrow.getCell(0).getCellStyle());
			cell.setCellType(firstrow.getCell(0).getCellType());
		}
		//合并单元格
		cell = row.getCell((short) 0);
		//设计人民币大写行的字体和style
		rmbFont.setFontName("楷体");
		int fontheight=firstrow.getCell(0).getCellStyle().getFont(wb).getFontHeightInPoints();
		if (fontheight<10) rmbFont.setFontHeightInPoints((short) 10);
		else rmbFont.setFontHeightInPoints((short) fontheight);
		rmbFont.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);	
		rmbStyle.setFont(rmbFont);
		cell.setCellStyle(rmbStyle);
		//合并单元格为一格
		Region region1=new Region((short)y1, (short)0, (short)y1, (short)(xcolcount-1) ); 
		sheet.addMergedRegion(region1);
		//System.out.println("rmbrmbrmb="+rmbstr);
		cell.setCellValue("  "+rmbstr);
		row.setHeight(firstrow.getHeight());  //设置行高
	}
	//标题中固定值填充
	if (!xheadercells.equals("")){
		x1=0;
		y1=-1;
		String valuedim[];
		valuedim=xheadercells.split(";");
		for (j=0;j<valuedim.length;j++){
			s1=valuedim[j];
			index1=s1.indexOf(">");
			if (index1>=0){
				s1=valuedim[j].substring(1,index1);
				String valuex=valuedim[j].substring(index1+1);
				//System.out.println(valuex.length());
				index2=s1.indexOf(",");
				if (index2>=0){
					y1=Integer.valueOf(s1.substring(0,index2)).intValue()-1;		
					x1=Integer.valueOf(s1.substring(index2+1)).intValue()-1;		
				}
				//System.out.println(value+"---y1="+y1+"---x1="+x1);
				if (y1>=0 && x1>=0){
					HSSFRow rowx = sheet.getRow(( short ) y1);
					HSSFCell cellx = rowx.getCell(( short ) x1);
					cellx.setCellValue(valuex);
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
		for (j=0;j<footerdim.length;j++){
			s1=footerdim[j];
			index1=s1.indexOf("<l>");
			if (index1<0) index1=s1.indexOf("<L>");  
			index2=s1.indexOf("<c>");
			if (index2<0) index2=s1.indexOf("<C>"); 
			index3=s1.indexOf("<r>");
			if (index3<0) index3=s1.indexOf("<R>");
			if (index1>=0 || index2>=0 || index3>=0) s1=s1.substring(3);
			index4=s1.indexOf("pageno");
			if (index4>=0){
				s1="\""+s1.substring(0,index4)+"\"+HSSFFooter.page()+\""+s1.substring(index4+6)+"\"";
			}
			System.out.println("s1="+s1);
			index5=s1.indexOf("pagecount");
			if (index5>=0){
				s1="\""+s1.substring(0,index5)+"\"+HSSFFooter.numPages()+\""+s1.substring(index5+9)+"\"";
			}
			if (index4>=0 || index5>=0){
				s1=s1.replace("\"\"","\"");
				//value=;
			}else{
				value=s1;
			}
			if (index1>=0){
				//value=s1.substring(3);
				footer.setLeft(value);
			}else if (index2>=0){
				//value=s1.substring(3);
				footer.setCenter(value);
			}else{
				//value=s1.substring(3);
				footer.setRight(value);
			}
			System.out.println("s1="+s1+","+index1+","+index2+","+index3);
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
    filename="\\system\\temp\\"+xtemplate;  //去掉root，在下载时自动会加上
	response.getWriter().write("{totalcount:\""+(i-1)+"\",filename:\""+filename+"\"}");
	grid_rs.close();
	stmt.close();
	connection.close();   
%>