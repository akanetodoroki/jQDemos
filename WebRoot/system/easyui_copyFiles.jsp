<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="java.io.*"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="org.apache.commons.fileupload.FileItem"%>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%
		String path = request.getContextPath();
		String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		String sourcefile = request.getParameter("sourcefile");  //目标路径
		String targetfile = request.getParameter("targefile");  //目标文件名称
		String action = request.getParameter("action");  //文件处理方式
		System.out.println("targetpath="+sourcefile);
		System.out.println("targetpath="+targetfile);
		System.out.println("path="+path);
		System.out.println("basepath="+basePath);

		String fileext=sourcefile.substring(sourcefile.lastIndexOf(".")+1,sourcefile.length()).toLowerCase();//文件扩展名
		//String savePath = this.getServletContext().getRealPath(targetpath);
		String message = ""; //消息提示
		int error = 0;
		String targetfilename="";
		String filename="";
		long xsize=0;
		File file1 = new File(path+sourcefile);
		File file2 = new File(path+targetfile);
		//判断上传文件的保存目录是否存在
		if (file2.exists()) {
			file2.delete();
		} 
		PrintWriter pw = response.getWriter();  
		//System.out.print(json.toString());
		pw.write(""); 
%>
