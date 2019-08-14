package com;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class FileUploadServlet extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("gbk");
		response.setContentType("text/html;charset=gbk");
		String filePath = request.getParameter("filePath");
		System.out.println(filePath);
		int index1 = filePath.lastIndexOf("\\");
		int index2 = filePath.lastIndexOf(".");
		String fileName = filePath.substring(index1 + 1);
		String fileType = filePath.substring(index2);
		File file = new File(filePath);
		long fileSize = file.length();
		if (fileSize >=2 * 1024 * 1024) {
			response.sendRedirect("uploaderror.jsp");
		} else {
			FileInputStream fin = new FileInputStream(file);
			BufferedInputStream bin = new BufferedInputStream(fin);
			//FileUploadDao fileUploadDao = new FileUploadDao();
			Date date = new Date();			
			String fileNameEn = "file" + date.getTime() + fileType;
			System.out.println(fileNameEn);
			//fileUploadDao.saveFile(fileName, fin.available(),fileNameEn);

			FileOutputStream fout = new FileOutputStream("../webapps/JSP_Yilong_FileUpload/file/" + fileNameEn);//当前路径为tomcat安装目录下的bin文件夹(servlet的当前路径)
			BufferedOutputStream bout = new BufferedOutputStream(fout);
			int b = bin.read();
			while (b != -1) {
				bout.write(b);
				b = bin.read();
			}
			bout.close();
			fout.close();
			bin.close();
			fin.close();
			response.sendRedirect("uploadsuccess.jsp");
		}
	}

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}
}