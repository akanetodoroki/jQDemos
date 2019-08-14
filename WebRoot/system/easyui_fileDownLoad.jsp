<%@page contentType="application/x-msdownload" %>
<%@page language="java" import="java.util.*" pageEncoding="utf-8" %>
<%@page import="com.StringUtil" import="java.io.*" %>
<%@page import="java.io.BufferedInputStream" %>
<%@page import="java.io.BufferedOutputStream" %>
<%@page import="java.net.URLEncoder" %>
<%
	//输入两个参数：一个源文件名称sourcefile，一个目标文件名targetfile
	String root = application.getRealPath("/");
	String sourcefile = StringUtil.getToUtf8(request.getParameter("source"));
	String targetfile = StringUtil.getToUtf8(request.getParameter("target"));
	targetfile=URLEncoder.encode(targetfile,"UTF8");  //必须转换，否则中文乱码
	String result="";
	String fileext=sourcefile.substring(sourcefile.lastIndexOf(".")+1,sourcefile.length()).toLowerCase();//文件扩展名
	if (targetfile.indexOf(".")<0) targetfile+="."+fileext; 
	String s=root+sourcefile;
	String s1=s.substring(0,s.lastIndexOf("\\"));  //所在文件夹
	String s2=s.substring(s.lastIndexOf("\\")+1,s.length());
	//System.out.println(s1+",-----"+s2+"-----target="+targetfile);
	File f=new File(s1,s2); 
	if (!f.exists()) {
		result="源文件没有找到，下载失败！";
		//System.out.println(s2+",file not found");
	} 	
	response.setHeader("Content-Type","application/x-msdownload;");
	response.setHeader("Content-disposition","attachment; filename="+targetfile+"");
	BufferedInputStream bis = null;
	BufferedOutputStream bos = null;
	try {
		bis = new BufferedInputStream(new FileInputStream(root+sourcefile));
		bos = new BufferedOutputStream(response.getOutputStream());
		byte[] buff = new byte[10 * 1024];
		int bytesRead;
    	while ( -1 != (bytesRead = bis.read(buff, 0, buff.length))) {
			bos.write(buff, 0, bytesRead);
		}
    	bos.flush();
	} catch (IOException ioe) {
		//System.out.println("下载错误：" + ioe);
		result="文件下载错误：<BR>"+ioe;
	} finally {
		if (bis != null) bis.close();
	    if (bos != null) bos.close();
	}
	if (bos !=null ){
		bos.flush();
		bos.close();
	}
	bos = null;
	response.flushBuffer(); 	
	out.clear();
	out = pageContext.pushBody();
	//response.getWriter().write("{success:true,status:'"+result+"'}");	
%>

