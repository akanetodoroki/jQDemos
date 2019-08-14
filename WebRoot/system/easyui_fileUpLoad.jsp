<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,com.*"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="org.apache.commons.fileupload.FileItem"%>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@ page import="java.text.NumberFormat" %>
<%
	//点击工程+propertity+输入java compiler选择5.0
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
	String realpath=getServletContext().getRealPath("/");
	request.setCharacterEncoding("UTF-8");
	response.setCharacterEncoding("UTF-8");
	String targetpath = request.getParameter("targetpath");  //目标路径
	String targetname = request.getParameter("targetname");  //目标文件名称
	//System.out.println("targetpath="+targetpath);
	//System.out.println("targetname="+targetname);
	//得到上传文件的保存目录，将上传的文件存放于WEB-INF目录下，不允许外界直接访问，保证上传文件的安全
	String savePath = this.getServletContext().getRealPath(targetpath);
	String error = ""; //消息提示
	String targetfilename="";
	String targetpdffilename="";
	String filename="";
	String fileext="";
	long xsize=0;
	File file = new File(savePath);
	//判断上传文件的保存目录是否存在
	if (!file.exists() && !file.isDirectory()) {
		System.out.println(savePath+"目录不存在，需要创建");
		file.mkdir(); //创建目录
	}
	try{
		//使用Apache文件上传组件处理文件上传步骤：
		//1、创建一个DiskFileItemFactory工厂
		DiskFileItemFactory factory = new DiskFileItemFactory();
		//2、创建一个文件上传解析器
		ServletFileUpload upload = new ServletFileUpload(factory);
		//解决上传文件名的中文乱码
		upload.setHeaderEncoding("UTF-8"); 
		//3、判断提交上来的数据是否是上传表单的数据
		if(!ServletFileUpload.isMultipartContent(request)){
			//按照传统方式获取数据
			return;
		}
		//4、使用ServletFileUpload解析器解析上传数据，解析结果返回的是一个List<FileItem>集合，每一个FileItem对应一个Form表单的输入项
		List<FileItem> list = upload.parseRequest(request);  //compiler5.0级以上支持
		for(FileItem item : list){
			//如果fileitem中封装的是普通输入项的数据
			if(item.isFormField()){
				String name = item.getFieldName();
				//解决普通输入项的数据的中文乱码问题
				String value = item.getString("UTF-8");
				//value = new String(value.getBytes("iso8859-1"),"UTF-8");
				//System.out.println(name + "=" + value);
			}else{//如果fileitem中封装的是上传文件
				//得到上传的文件名称，
				filename = item.getName();
				fileext=filename.substring(filename.lastIndexOf(".")+1,filename.length()).toLowerCase();//文件扩展名
				targetfilename=filename;
				if (!targetname.trim().equals("")){
					targetfilename=targetname+"."+fileext;  //目标文件名
				}
				if(filename==null || filename.trim().equals("")){
					continue;
				}
				//System.out.println("targetname=" + targetname);
				//System.out.println("targetfilename=" + targetfilename);
				//注意：不同的浏览器提交的文件名是不一样的，有些浏览器提交上来的文件名是带有路径的，如：  c:\a\b\1.txt，而有些只是单纯的文件名，如：1.txt
				//处理获取到的上传文件的文件名的路径部分，只保留文件名部分
				filename = filename.substring(filename.lastIndexOf("\\")+1);
				//获取item中的上传文件的输入流
				InputStream in = item.getInputStream();
				//创建一个文件输出流
				//FileOutputStream out1 = new FileOutputStream(savePath + "\\" + filename);
				FileOutputStream out1 = new FileOutputStream(savePath + "\\" + targetfilename);
				//创建一个缓冲区
				byte buffer[] = new byte[1024];
				//判断输入流中的数据是否已经读完的标识
				int len = 0;
				//循环将输入流读入到缓冲区当中，(len=in.read(buffer))>0就表示in里面还有数据
				while((len=in.read(buffer))>0){
					//使用FileOutputStream输出流将缓冲区的数据写入到指定的目录(savePath + "\\" + filename)当中
					out1.write(buffer, 0, len);
				}
				in.close();  //关闭输入流
				out1.close();  //关闭输出流
				item.delete(); //删除处理文件上传时生成的临时文件
				error = "";
				File xfile = new File(savePath + "\\" + targetfilename);
				xsize=xfile.length();
			}
		}
	}catch (Exception e) {
		error = "文件上传失败！";
		e.printStackTrace();
	}
	/*
	if (error.equals("")){
		String file1=realpath+targetpath+targetfilename;
		String file2=file1.substring(0,file1.lastIndexOf("."))+".pdf";
		fileext=file1.substring(file1.lastIndexOf(".")+1,file1.length()).toLowerCase();//文件扩展名
		if (fileext.equals("doc") || fileext.equals("docx") || fileext.equals("xls") || fileext.equals("xlsx") || fileext.equals("ppt") || fileext.equals("pptx")){
			error=office2pdf.word2pdf(file1, file2);
			System.out.println("pdf1="+file1);
			System.out.println("pdf2="+file2+"---"+error);
		}
	}
	*/
	//确定返回内容json格式,好像没有运行到这一步.????????
	Map map = new HashMap();
	//System.out.println("filename:"+error+"---"+filename+"---"+targetfilename+"---"+targetpath+"---"+xsize);
	map.put("error", error);
	map.put("sourcefile", filename);
	map.put("targetfile", targetfilename);
	map.put("targetpath", targetpath);
	map.put("fileext", fileext);
	map.put("filesize", xsize);
	map.put("fileosname",targetpath+targetfilename);
	double x;
	if (xsize<=1024) x=xsize;
	else if (xsize<=1024*1024) x=xsize/1024.00;
	else if (xsize<=1024*1024*1024) x=xsize/1024.00/1024.0;
	else x=xsize/1024/1024.00/1024.0;
	x=(double)((int)((x+0.005)*100))/100;
	if (xsize<=1024) map.put("filesizedesc", (int)x+"B");
	else if (xsize<=1024*1024) map.put("filesizedesc", x+"KB");
	else if (xsize<=1024*1024*1024) map.put("filesizedesc", x+"MB");
	else map.put("filesizedesc", x+"GB");
	JSONObject json = JSONObject.fromObject(map);
	response.setContentType("text/html; charset=utf-8");
	PrintWriter pw = response.getWriter();  
	//System.out.print(json.toString());
	pw.write(json.toString()); 
%>
