package com;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import javax.servlet.ServletInputStream;


public class LoadUpFile {

	ServletInputStream in=null;
    String fpath="C://";
    public LoadUpFile()
    {
        fpath="C://";
        in=null;
    }

    public void setInputStream(ServletInputStream in)
    {
        this.in=in;
    }
    public void setFpath(String p)
    {
        this.fpath=p;
    }
    public String getFpath()
    {
        return fpath;
    }
    public String getParameter()
    {
        String r=null;
        try
        {
            r=getParameter(in);
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
        return r;
    }
    public long getFileUpload()
    {
        long r=-1;
        try
        {
            r=getFileUpload(in,fpath);
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
        return r;
    }
     
    public String getParameter(ServletInputStream in)// 只能按顺序提取
            throws Exception
    {
        int l = 0;
        byte[] b = new byte[1024];
        l = in.readLine(b, 0, b.length);// 依次是读取属性的开始符、名称、属性值的类型、属性的值
        String si = new String(b);
        if (si.startsWith("----------------------------"))
        {// 表示是从开始符开始读，否则应为刚读取文件后的一个属性，此时应少读一次
            l = in.readLine(b, 0, b.length);
        }
        l = in.readLine(b, 0, b.length);
        l = in.readLine(b, 0, b.length);
        String value = new String(b, 0, l);
        return value;
    }
 
    public long getFileUpload(ServletInputStream in, String fpath)// 需要提供输入流和存储路径
            throws Exception
    {
        // out.println("文件信息:<br>");
        long begin = System.currentTimeMillis();// 传送时间计时开始
        int l = 0;
        byte[] b = new byte[1024];
        l = in.readLine(b, 0, b.length);
        String sign = new String(b, 0, l);// eg.-----------------------------7d9dd29630a34
        l = in.readLine(b, 0, b.length);
        String info = new String(b, 0, l);// eg.Content-Disposition:form-data;
        // name="file";
        l = in.readLine(b, 0, b.length);
        // String type=new
        // String(b,0,l);//eg.Content-Type:application/octet-stream(程序文件)
        l = in.readLine(b, 0, b.length);
        // String nulll=new String(b,0,l);//此值应为空
        int nIndex = info.toLowerCase().indexOf("filename=\"");
        int nLastIndex = info.toLowerCase().indexOf("\"", nIndex + 10);
        String filepath = info.substring(nIndex + 10, nLastIndex);
        int na = filepath.lastIndexOf("\\");
        String filename = filepath.substring(na + 1);
        // out.println("文件绝对路径："+filepath+"<br>");
        // out.println("文件名："+filename+"<br><br>");
        String path=fpath + filename;
        File fi = new File(path);// 建立目标文件
        if (!fi.exists()&&!fi.createNewFile())
            return -2;
        BufferedOutputStream f = new BufferedOutputStream(new FileOutputStream(
                fi));
        while ((l = in.readLine(b, 0, b.length)) > 0)
        {
            if (l == sign.length())
            {
                String sign1 = new String(b, 0, sign.length());
                // out.println(sign1+"<br>");
                if (sign1.startsWith(sign))// 比对是否文件已传完
                    break;
            }
            f.write(b, 0, l);
            f.flush();
        }
        f.flush();
        f.close();
        long end = System.currentTimeMillis();// 传送时间计时结束
        // out.println("上传文件用时："+(end-begin)+"毫秒<br>");
        return end - begin;
    }
}
