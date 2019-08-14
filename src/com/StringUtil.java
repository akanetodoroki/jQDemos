package com;

import java.io.UnsupportedEncodingException;

/**
 * ����jdk1.5�Ŀɱ��������, ��Ƶ��ַ�����
 *
 * @author xiaofeng
 * 2007-11-23 ����01:20:58
 */
public class StringUtil {
	
	public static int count(String s, String text) {
        if ((s == null) || (text == null)) {
                return 0;
        }

        int count = 0;

        int pos = s.indexOf(text);

        while (pos != -1) {
                pos = s.indexOf(text, pos + text.length());
                count++;
        }

        return count;
	}
	
//

public static String myRmb(double amount) {
		String rmb="";
		if (amount<0) amount=-amount;
		amount=1000000000000.00+amount*1.0;
		String s=""+amount;
		System.out.println("s="+s);
		String s1=s.substring(0,13);
		String s2=s.substring(14);
		String s11=s1.substring(1,5);  //-取亿的数量值，即0020
		String s12=s1.substring(5,9);  //--取万的数量值，即6058
		String s13=s1.substring(9,14); //--取万以下的数量值，即0096
		if (s11!="0000"){  //如果金额在“亿”部分中有值
			s11=s11.substring(0,1)+"仟"+s11.substring(1,2)+"佰"+s11.substring(2,3)+"拾"+s11.substring(3);
			s11=s11.replace("0仟","0");
			s11=s11.replace("0佰","0");
			s11=s11.replace("0拾","0");  //此时s11的值为：002拾0。
	    	rmb=s11+"亿";   /* 此时rmb的值为：002拾0亿。*/
		}
		if (s12!="0000"){  //如果金额在“万”部分中有值
			s12=s12.substring(0,1)+"仟"+s12.substring(1,2)+"佰"+s12.substring(2,3)+"拾"+s12.substring(3);
			s12=s12.replace("0仟","0");
			s12=s12.replace("0佰","0");
			s12=s12.replace("0拾","0"); 
			rmb=rmb+s12+"万";
		}else{
			rmb=rmb+"0";	
		}
		if (s13!="0000"){  //如果金额在“万”以下部分中有值
			s13=s13.substring(0,1)+"仟"+s13.substring(1,2)+"佰"+s13.substring(2,3)+"拾"+s13.substring(3);
			s13=s13.replace("0仟","0");
			s13=s13.replace("0佰","0");
			s13=s13.replace("0拾","0"); 
			rmb=rmb+s13+"元";
		}else{
			rmb=rmb+"元";
		}
		while (rmb.indexOf("00")>=0) rmb=rmb.replace("00","0");
		if (amount>=1){
			rmb=rmb.replace("0亿","亿0");
			rmb=rmb.replace("0万","万0");
			rmb=rmb.replace("0元","元0");
		 }
		while (rmb.indexOf("00")>=0)  rmb=rmb.replace("00","0");
		if (rmb.substring(0,1)=="0" && amount>=1)  rmb=rmb.substring(1);
	  	if (s2.substring(0,1)!="0") rmb=rmb+s2.substring(0,1)+"角";
	  	if (s2.substring(s2.length()-1)!="0"){ 
	    	if (s2.substring(0,1)=="0") rmb=rmb+"0";
	    	rmb=rmb+s2.substring(s2.length()-1)+"分";
		}else{
			rmb=rmb+"整";
		}
		while (rmb.indexOf("0")>=0) rmb=rmb.replace("0","零");
		while (rmb.indexOf("1")>=0) rmb=rmb.replace("1","壹");
		while (rmb.indexOf("2")>=0) rmb=rmb.replace("2","贰");
		while (rmb.indexOf("3")>=0) rmb=rmb.replace("3","叁");
		while (rmb.indexOf("4")>=0) rmb=rmb.replace("4","肆");
		while (rmb.indexOf("5")>=0) rmb=rmb.replace("5","伍");
		while (rmb.indexOf("6")>=0) rmb=rmb.replace("6","陆");
		while (rmb.indexOf("7")>=0) rmb=rmb.replace("7","柒");
		while (rmb.indexOf("8")>=0) rmb=rmb.replace("8","捌");
		while (rmb.indexOf("9")>=0) rmb=rmb.replace("9","玖");
		return(rmb);
	}
	
	public static String replace(String s, String oldSub, String newSub) {
        if ((s == null) || (oldSub == null) || (newSub == null)) {
                return null;
        }

        int y = s.indexOf(oldSub);

        if (y >= 0) {
                StringBuffer sb = new StringBuffer();
                int length = oldSub.length();
                int x = 0;

                while (x <= y) {
                        sb.append(s.substring(x, y));
                        sb.append(newSub);
                        x = y + length;
                        y = s.indexOf(oldSub, x);
                }
                sb.append(s.substring(x));
                return sb.toString();
        }
        else {
                return s;
        }
	}
	
	/**
     * ��html��textarea�еĿո�ͻ����Լ���������ת����html���ַ�ĸ�ʽ
     * @param txt String
     * @return String
     */
    public static String txt2html(String txt){
        txt = txt.replaceAll(" ","&nbsp;");
        txt = txt.replaceAll("\n","<br>");
        txt = txt.replaceAll("\t","&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
        return txt;
    }

    /**
     * �ж�url�Ƿ�����http://��ʼ���������http://��ʼ�������ǰ׺http://������ַΪ�վͷ��ؿմ�
     * @param url String
     * @return String
     */
    public static String getURL(String url){
    	url = StringUtil.filterNull(url);
        if(url.length() == 0){
            return "";
        }else if(url.startsWith("http://")){
            return url;
        }else if(url.startsWith("www")){
            url = "http://" + url;
            return url;
        }else{
            return url;
        }
    }
    
    /**
     * ���˶����Ƿ�Ϊnull, '', NULLֵ, nullֵ, &nbsp;����� �� return "" , �����򷵻ض�����
     * @param obj ���˶���
     * @return ����toString()
     * @author HF-Winder
     */
    public static String filterNull (Object obj) {
    	if (obj == null) {
    		return "";
    	} else if (obj.toString().trim().length() == 0) {
    		return "";
    	} else if ("null".equals(obj.toString().trim()) || "NULL".equals(obj.toString().trim())){
    		return "";
    	} else if ("&nbsp;".equals(obj.toString().trim())) {
    		return "";
    	} else {
    		return obj.toString().trim();
    	}
    }
    
    /**
     * �ַ���ת�� <code> ISO-8859-1 -> GBK </code> <br/>
     * ת��get��ʽ�ύ��(ISO-8859-1)�����ַ� - GBK�����ַ� <br/>
     * ʹ�ã�StringKit.getISO8859ToGBK(isoStr);
     * @param isoStr ISO-8859-1�ַ� �� get�ύ�������ַ�
     * @return GBK�ַ�
     * @throws UnsupportedEncodingException
     */

    public static String getUrlCHN(String isoStr) throws UnsupportedEncodingException {
    	return new String(StringUtil.filterNull(isoStr).getBytes("ISO-8859-1"),"utf-8");
    }
    
    public static String getToGBK(String isoStr) throws UnsupportedEncodingException {
    	return new String(StringUtil.filterNull(isoStr).getBytes("ISO-8859-1"),"GBK");
    }

    public static String getToGB2312(String isoStr) throws UnsupportedEncodingException {
    	return new String(StringUtil.filterNull(isoStr).getBytes("ISO-8859-1"),"GB2312");
    }

    public static String getToUtf8(String isoStr) throws UnsupportedEncodingException {
    	return new String(StringUtil.filterNull(isoStr).getBytes("ISO-8859-1"),"utf-8");
    }
    
    
    /**
     * 替换值中含有的单引号'
     * 
     * */
    public static String replaceSingleQuotes(Object obj){
    	if (obj == null) {
    		return "";
    	} else if (obj.toString().trim().length() == 0) {
    		return "";
    	} else if ("null".equals(obj.toString().trim()) || "NULL".equals(obj.toString().trim())){
    		return "";
    	} else if ("&nbsp;".equals(obj.toString().trim())) {
    		return "";
    	} else {
    		if(obj.toString().trim().indexOf("'")!=-1){
    			return obj.toString().trim().replaceAll("'", "''");
    		}else{
    			return obj.toString().trim();
    		}
    	}
    }
    
    /**
     * �����ַ�س�����,������Ҫ�����Դ����������Ҫ�س�����󳤶Ⱥ�ʵ����Ҫ�س��ĳ��ȣ������ַ�ȣ������ؽس����Ӵ�
     * ������Ҫ�س�����󳤶�maxLen��subStrLen��suffix��maxLen��subStrLen���ȶ���˵�����ַ�ĳ���
     * @param sourceStr String
     * @param maxLen int
     * @param subStrLen int
     * @return String
     */
    public static String getSubString(String sourceStr,int maxLen,int subStrLen,String suffix) {
        /*
         * ���Ϊ�ջ��߶��󲻴��ڷ���Ϊ�մ�
         */
        if (sourceStr == null || "".equals(sourceStr)) {
            return "";
        }
        if(sourceStr.length()<=maxLen){
            return sourceStr;
        }
        /**
         * k����¼С��256���ַ�����ж�������������ַ�ʱ����������Ϊ��
         * sum����¼�ַ�Ĵ���256�ַ�ĸ���С��256���ַ�������һ����
         * i,j���Ǽ�¼��ѭ��������ַ��λ�õģ�
         * kk����jj��¼��sumֵ�����Ӵ�����ʱk��j��ֵ
         */
        int k = 0, sum = 0, i = 0, j = 0, jj = 0;
        boolean flag = true;       //�ڽس��ļ�¼λ�ã����ڼ�¼����ƶ����ַ�λ��
        char[] charSource = new char[sourceStr.length()];
        for (i = 0; i < charSource.length; i++) {
            j++;
            charSource[i] = sourceStr.charAt(i);
            /**
             * �����С��256���ַ����Ҫ����������ַ����һ�������ַ�
             */
            if (((int) charSource[i]) <= 256) {
                if (k % 2 == 0) {
                    k = 0;
                } else {
                    sum++;
                }
                k++;           //���ڼ�¼�����˼���intֵС��256���ַ������۵�����������¼intֵ����256���ַ��sum�����ͼ�һ
            } else {
                sum++;
            }
            if (sum == subStrLen) {    //�ж�sumֵ�Ƿ���ڽس��Ӵ��ĳ��ȣ������Ⱦͼ�¼��ʱ��Դ����λ��
                if((i+1)==charSource.length){
                    return sourceStr;
                }
                if(flag){      //�ж��Ƿ��Ѿ���¼�ˣ�����Ѿ���¼�ˣ��Ͳ��ڼ�¼�س���λ����
                    if(charSource[i]>256){
                        if(k % 2 == 1){          //�ڽس����Ӵ����Ⱥ�����һ��Ӣ���ַ��һ�������ַ�
                            jj = j-1;
                        }else{                   //�ڽس����Ӵ����Ⱥ�����һ�������ַ�,��ͽس����������Ҫ���ж���
                            jj = j;
                        }
                    }else{                        //�ڽس�����󳤶Ⱥ��������ַ���Ӣ���ַ�
                        jj = j;
                    }
                    flag = false;
                }
            }
            if (sum == maxLen) {       //�ж��Ƿ�sumֵ�Ƿ�����Ӵ����Ϻ�׺�ĳ����ܺ�
                if((i+1)==charSource.length){
                    if(k % 2 == 0){         //Դ���պõ��ڽس�����󳤶�
                        return sourceStr;
                    } else if(k % 2 == 1){
//                        if(charSource[i]>256){   //Դ���ĳ����ǽس���󳤶ȼ�һ��Ӣ���ַ�����Ӣ���ַ���ǰ�ټ���һ�������ַ�����
//                            j = j - 2;
//                        }else{                   //Դ���ĳ����ǽس���󳤶ȼ�һ��Ӣ���ַ����Ǻ����ַ���ǰ�ټ���һ��Ӣ���ַ�����
//                            j = j - 2;
//                        }
                        sum++;             //��������س����������
                        break;
                    }
                }
                if((i+2)==charSource.length){          //��󳤶ȼ���һ��Ӣ���ַ�
                    sum++;               //��������س����������
                    break;
                }
            }
            if(sum < maxLen){
                if((i+1)==charSource.length){
                    return sourceStr;
                }
            }
            if (sum > maxLen) {
                break;
            }
        }
        if(sum > maxLen){               //�Ӵ������趨����󳤶ȣ�Ӧ�ý�ȡ����
            j = jj;
        }
        return sourceStr.substring(0, j)+suffix;
    }
}



