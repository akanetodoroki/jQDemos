package com;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import java.io.BufferedWriter;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
//import org.apache.poi.hssf.usermodel.HSSFCell;
//import org.apache.poi.hssf.usermodel.HSSFRow;
//import org.apache.poi.hssf.usermodel.HSSFSheet;
//import org.apache.poi.hssf.usermodel.HSSFWorkbook;
//import org.apache.poi.poifs.filesystem.POIFSFileSystem;

import java.util.Properties;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.net.URLEncoder;
import java.io.*;


/*
 * */
public class DBConn {
	public DBConn(){
		
	}

	public Connection getConnection(String dbname){
		Connection conn = null;
		if (dbname=="") dbname="jqdemos";
		String host="localhost";
		String password="sql2008";
		String username="sa";
		String result="";
		String url = "jdbc:jtds:sqlserver://"+host+":1433;DatabaseName="+dbname;
		try{
			Class.forName("net.sourceforge.jtds.jdbc.Driver");
			conn = DriverManager.getConnection(url, username, password);
			result="success";
		}catch (ClassNotFoundException e){
			e.printStackTrace();
			result=e.getMessage();
		}catch (SQLException e){
			e.printStackTrace();
			result=e.getMessage();
		}
		return conn;
		//return result;
	}

	public String testConnection(){
		Connection conn = null;
		String dbname="master";
		String host="localhost";
		String password="sql2008";
		String username="sa";
		String result="";
		String url = "jdbc:jtds:sqlserver://"+host+":1433;DatabaseName="+dbname;
		try{
			Class.forName("net.sourceforge.jtds.jdbc.Driver");
			conn = DriverManager.getConnection(url, username, password);
		}catch (ClassNotFoundException e){
			e.printStackTrace();
			result=e.getMessage();
		}catch (SQLException e){
			e.printStackTrace();
			result=e.getMessage();
		}
		return result;
	}
	
}



