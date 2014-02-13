package com.university.utils;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.DriverManager;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.struts2.ServletActionContext;

import com.mysql.jdbc.Connection;

/**
 * @todo TODO
 * @filename BaseUtils.java
 * @author tao jiajian
 * @createTime 2013-8-6 下午4:00:03
 * @updateTime 2013-8-6 下午4:00:03
 * @version V1.0
 */
public class BaseUtils {
	/**
	 * 定义requestCode的全局变量
	 */
	public static final String REQUESTCODE_101 = "101";
	public static final String REQUESTCODE_102 = "102";
	public static final String REQUESTCODE_103 = "103";
	public static final String REQUESTCODE_104 = "104";
	public static final String REQUESTCODE_105 = "105";
	public static final String REQUESTCODE_106 = "106";
	public static final String REQUESTCODE_107 = "107";
	public static final String REQUESTCODE_108 = "108";
	public static final String REQUESTCODE_109 = "109";
	public static final String REQUESTCODE_110 = "110";
	public static final String REQUESTCODE_111 = "111";
	public static final String REQUESTCODE_112 = "112";
	public static final String REQUESTCODE_113 = "113";
	public static final String REQUESTCODE_114 = "114";
	public static final String REQUESTCODE_115 = "115";
	public static final String REQUESTCODE_116 = "116";
	public static final String REQUESTCODE_117 = "117";
	public static final String REQUESTCODE_118 = "118";
	public static final String REQUESTCODE_119 = "119";
	public static final String REQUESTCODE_120 = "120";

	public static final SimpleDateFormat FORMAT = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	public static final SimpleDateFormat FORMAT1 = new SimpleDateFormat("yyyy-MM-dd");
	public static final Integer DEFAULT_PAGENUM_4 = 4;
	public static final Integer DEFAULT_PAGENUM_5 = 5;
	public static final Integer DEFAULT_PAGENUM_6 = 6;
	
	public static final Integer DEFAULT_SUBLENGTH = 200;//
	private static final double EARTH_RADIUS = 6378137.0;// 地球半径
	public static final Integer EVALUATETYPE = 1;// 评论顾问

	public static final String DEFAULT_IMGURL = "http://pic8.nipic.com/20100703/4887831_015505282659_2.jpg";

	
	/**
	 * 方法四
	 * 
	 *去掉字符串里面的html代码。
	 *要求数据要规范，比如大于小于号要配套,否则会被集体误杀。
	 *　
	 *@paramcontent内容
	 *@return去掉后的内容
	 *
	 */
	public static String stripHtml(String content){
		
		//<p> 段落替换为换行
		content = content.replaceAll("<p.*?>","");
		//<br><br/>替换为换行
		content = content.replaceAll("<brs*/?>","");
		//去掉其它的 <> 之间的东西
		content = content.replaceAll("<.*?>","");
		//还原HTML
		//content = HTMLDecoder.decode(content);
		
		return content;
	}
	
	/**
	 * 方法三 (正则表达式)
	 * 
	 * 去掉字符串(String)中的HTML代码
	 * 
	 * 能去掉HTML，但是问题和方法一一样
	 * @param htmlStr
	 * @return
	 */
	public static String delHTMLTag(String htmlStr){
		
	    String regEx_script="<script[^>]*?>[//s//S]*?<///script>"; //定义script的正则表达式
	    
	    String regEx_style="<style[^>]*?>[//s//S]*?<///style>"; //定义style的正则表达式
	    
	    String regEx_html="<[^>]+>"; //定义HTML标签的正则表达式
	    
	    Pattern p_script=Pattern.compile(regEx_script,Pattern.CASE_INSENSITIVE);
	    
	    Matcher m_script=p_script.matcher(htmlStr);
	    
	    htmlStr=m_script.replaceAll(""); //过滤script标签
	    
	    Pattern p_style=Pattern.compile(regEx_style,Pattern.CASE_INSENSITIVE);
	    
	    Matcher m_style=p_style.matcher(htmlStr);
	    
	    htmlStr=m_style.replaceAll(""); //过滤style标签
	    
	    Pattern p_html=Pattern.compile(regEx_html,Pattern.CASE_INSENSITIVE);
	    
	    Matcher m_html=p_html.matcher(htmlStr);
	    
	    htmlStr=m_html.replaceAll(""); //过滤html标签
	    
	    return htmlStr.trim(); //返回文本字符串
	}
	
	/**
	 * 方法二 (简单算法)
	 * 
	 * 去掉字符串(String)中的HTML代码
	 * 
	 * @param content
	 * @return
	 */
	public static String removeHTML(String content)
	  {
	    int before = content.indexOf('<');
	    int behind = content.indexOf('>');
	    if (before != -1 || behind != -1)
	    {
	      behind += 1;
	      content = content.substring(0, before).trim() + content.substring(behind, content.length()).trim();
	      content = removeHTML(content);
	      content = content.replace("&nbsp;", "");
	    }
	    return content;
	  }

	/**
	 * 方法一（正则表达式）
	 * 
	 * 去掉字符串(String)中的HTML代码
	 * 
	 * 这种方法只能截取掉字符串中的HTML代码，但是遗留下来的是之前HTML代码占的位置，导致很多空格，和很多换位符号，不理想
	 * 
	 * @param inputStr
	 *            需要处理的的字符串
	 * @param length
	 *            截取的长度
	 * @return
	 */
	public static String splitAndFilterString(String inputStr, int length) {
		if (inputStr == null || inputStr.trim().equals("")) {
			return "";
		}
		// 去掉所有HTML元素
		String str = inputStr.replaceAll("\\&[a-zA-Z]{1,10};", "").replaceAll("<[^>]*>", "");
		str = str.replaceAll("[(/>)<]", "");
		int len = str.length();
		if (len <= length) {
			return str;
		} else {
			str = str.substring(0, length);
			str += "......";
		}
		return str;
	}

	/**
	 * 根据地址解析出对应的精度和纬度
	 * 
	 * @param address
	 * @param city
	 * @return
	 * @author jiantao jia
	 */
	public static Map<String, Object> getGeoPoi(String address, String city) {
		String httpUrl = "http://api.map.baidu.com/geocoder/v2/?ak=1fd07420b2696d409fccb348bfd28dd0&output=json&address="
				+ address + "&city=" + city;
		StringBuffer sbf = null;
		try {
			URL url = new URL(httpUrl);
			BufferedReader in = new BufferedReader(new InputStreamReader(
					url.openStream()));
			sbf = new StringBuffer();
			String str = "";
			while ((str = in.readLine()) != null) {
				sbf.append(str);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		// {"status":0,"result":{"location":{"lng":106.5725402468,"lat":29.530635398337},"precise":0,"confidence":40,"level":""}}
		/*
		 * { "status": 0, "result": { "location": { "lng": 106.5725402468,
		 * "lat": 29.530635398337 }, "precise": 0, "confidence": 40, "level": ""
		 * } }
		 */
		System.out.println("sbf.toString() --->" + sbf.toString());
		String lat = "", lng = "";
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			JSONObject object = JSONObject.fromObject(sbf.toString());

			int status = object.optInt("status");
			String result = object.optString("result");
			JSONObject ob = JSONObject.fromObject(result);
			String location = ob.optString("location");
			JSONObject job = JSONObject.fromObject(location);
			lat = job.optString("lat");
			lng = job.optString("lng");

			map.put("lat", lat);
			map.put("lng", lng);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return map;
	}

	/**
	 * 比较两个时间差，然后返回提示相差多少天、小时、分钟
	 * 
	 * @param agoDate
	 * @return
	 */
	public static String dateShowStr(String agoDate) {

		String nowDate = BaseUtils.getNowStringDateTime(new Date());
		String str = "", str1 = "";
		try {
			Date d1 = FORMAT.parse("2013-08-22 16:18:00");// 2013-08-22 16:18:00

			System.out.println("d1 " + d1);

			Date d2 = FORMAT.parse(agoDate);// 2013-08-21 16:18:00

			System.out.println("d2 " + d2);

			long diff = d1.getTime() - d2.getTime();
			System.out.println("d1.getTime() " + d1.getTime());
			System.out.println("d2.getTime() " + d2.getTime());
			System.out.println("diff " + diff);

			long days = diff / (1000 * 60 * 60 * 24);
			long hour = (diff / (60 * 60 * 1000) - days * 24);
			long min = ((diff / (60 * 1000)) - days * 24 * 60 - hour * 60);
			long s = (diff / 1000 - days * 24 * 60 * 60 - hour * 60 * 60 - min * 60);

			String day_str = days == 0 ? "" : days + "天";
			String hour_str = hour == 0 ? "" : hour + "小时";
			String min_str = min == 0 ? "" : min + "分";
			String s_str = s == 0 ? "" : s + "秒";
			str = day_str + hour_str + min_str + s_str;
			System.out.println(str);

			diff = 86400000 - diff;

			long days1 = diff / (1000 * 60 * 60 * 24);
			long hour1 = (diff / (60 * 60 * 1000) - days1 * 24);
			long min1 = ((diff / (60 * 1000)) - days1 * 24 * 60 - hour1 * 60);
			long s1 = (diff / 1000 - days1 * 24 * 60 * 60 - hour1 * 60 * 60 - min1 * 60);

			String day_str1 = days1 == 0 ? "" : days1 + "天";
			String hour_str1 = hour1 == 0 ? "" : hour1 + "小时";
			String min_str1 = min1 == 0 ? "" : min1 + "分";
			String s_str1 = s1 == 0 ? "" : s1 + "秒";
			str1 = day_str1 + hour_str1 + min_str1 + s_str1;
			System.out.println(str1);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return str + "\n" + str1;
	}

	/**
	 * 验证字符串是否为空 1、进行验证非空null 2、字符串“null” 3、字符串“""”
	 * 
	 * @param str
	 * @return
	 */
	public static boolean isEmptyOrNull(String str) {
		boolean torf = false;
		if (str != null && !"null".equals(str) && !"".equals(str)) {
			torf = true;
		} else {
			torf = false;
		}
		return torf;
	}

	/**
	 * 获取Request对象
	 * 
	 * @return
	 */
	public static HttpServletRequest getRequest() {
		HttpServletRequest request = ServletActionContext.getRequest();
		return request;
	}

	/**
	 * 获取Response对象
	 * 
	 * @return
	 */
	public static HttpServletResponse getResponse() {
		HttpServletResponse response = ServletActionContext.getResponse();
		return response;
	}

	/**
	 * 截取字符串
	 * 
	 * @param str
	 *            需要截取的字符串
	 * @param beginIndex
	 *            开始位置
	 * @param endIndex
	 *            结束为止
	 * @return 返回截取之后的字符串
	 */
	public static String subString(String str, int beginIndex, int endIndex) {
		String newStr = "";
		if (endIndex > str.length()) {
			newStr = del_space(str).substring(beginIndex, str.length() / 2);
		} else {
			newStr = del_space(str).substring(beginIndex, endIndex);
		}
		return newStr;
	}

	/**
	 * 
	 * 定义返回json提示
	 * 
	 * @param jsonNum
	 *            0成功，1请求参数失败，-1下一页无数据，-2没有任何数据
	 * @param params
	 *            传递的请求参数
	 * @return
	 */
	public static String JsonString(int jsonNum, String params) {
		String json_str = "";
		switch (jsonNum) {
		case 0:// 成功
			json_str = "{\"msg\":\"查询成功\",\"responseCode\":\"0\",\"results\":"
					+ params + "}";
			break;
		case 1:// 失败
			json_str = "{\"msg\":\"请求参数" + params
					+ "错误\",\"responseCode\":\"1\"}";
			break;
		case -1:// 下一页 无数据
			json_str = "{\"msg\":\"当前第" + params
					+ "页没有更多数据\",\"responseCode\":\"-1\"}";
			break;
		case -2:// 无数据
			json_str = "{\"msg\":\"无数据\",\"responseCode\":\"-2\"}";
			break;
		case -4:// 失败
			json_str = "{\"msg\":\"请求参数" + params
					+ "\",\"responseCode\":\"1\"}";
			break;
		default:
			break;
		}
		return json_str;
	}

	/**
	 * MD5加密算法
	 * 
	 * @param plainText
	 *            要加密的字符串
	 * @return 加密后的字符串
	 */
	public static String Md5(String plainText) {
		try {
			MessageDigest md = MessageDigest.getInstance("MD5");
			md.update(plainText.getBytes());
			byte b[] = md.digest();
			int i;
			StringBuffer buf = new StringBuffer("");
			for (int offset = 0; offset < b.length; offset++) {
				i = b[offset];
				if (i < 0)
					i += 256;
				if (i < 16)
					buf.append("0");
				buf.append(Integer.toHexString(i));
			}
			return buf.toString();
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		}
		return plainText;
	}

	/**
	 * 去掉IP字符串前后所有的空格
	 * 
	 * @param IP
	 * @return
	 */
	public static String trimSpaces(String IP) {
		while (IP.startsWith(" ")) {
			IP = IP.substring(1, IP.length()).trim();
		}
		while (IP.endsWith(" ")) {
			IP = IP.substring(0, IP.length() - 1).trim();
		}
		return IP;
	}

	/**
	 * 判断是否是一个IP
	 * 
	 * @param IP
	 * @return
	 */
	public static boolean isIp(String IP) {
		boolean b = false;
		IP = trimSpaces(IP);
		if (IP.matches("\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}")) {
			String s[] = IP.split("\\.");
			if (Integer.parseInt(s[0]) < 255)
				if (Integer.parseInt(s[1]) < 255)
					if (Integer.parseInt(s[2]) < 255)
						if (Integer.parseInt(s[3]) < 255)
							b = true;
		}
		return b;
	}

	/**
	 * 计算距离
	 * 
	 * @param d
	 * @return
	 */
	private static double rad(double d) {
		return d * Math.PI / 180.0;
	}

	/**
	 * 
	 * @param longitude1
	 *            商家经度
	 * @param latitude1
	 *            商家纬度
	 * @param longitude2
	 *            对应当前经度
	 * @param latitude2
	 *            对应当前纬度
	 * @return
	 */
	public synchronized static double getDistance(double longitude1,
			double latitude1, double longitude2, double latitude2) {
		double Lat1 = rad(latitude1);
		double Lat2 = rad(latitude2);
		double a = Lat1 - Lat2;
		double b = rad(longitude1) - rad(longitude2);
		double s = 2 * Math.asin(Math.sqrt(Math.pow(Math.sin(a / 2), 2)
				+ Math.cos(Lat1) * Math.cos(Lat2)
				* Math.pow(Math.sin(b / 2), 2)));
		s = s * EARTH_RADIUS;
		s = Math.round(s * 10000) / 10000;

		System.out.println("s " + s);
		return s;
	}

	/**
	 * 
	 * @param dis
	 * @return
	 */
	public static String getDistanceStr(Double dis) {

		String dis_str = dis.toString();
		int index = dis_str.indexOf(".");
		dis_str = index > 0 ? dis_str.substring(0, index) : dis_str;
		if (Integer.parseInt(dis_str) > 1000) {
			DecimalFormat dt = (DecimalFormat) DecimalFormat.getInstance(); // 获得格式化类对象
			dt.applyPattern("0.00");// 设置小数点位数(两位) 余下的会四舍五入
			dis_str = dt.format(Double.valueOf(dis_str) / 1000) + "km";
		} else {
			dis_str = dis_str + "m";
		}
		return dis_str;
	}

	/**
	 * 去掉字符串中间的空格
	 * 
	 * @param str
	 * @return
	 */
	public static String del_space(String str) {
		if (str == null) {
			return null;
		}
		char[] str_old = str.toCharArray();
		StringBuffer str_new = new StringBuffer();

		int i = 0;
		for (char a : str_old) {
			if (a != ' ') {
				str_new.append(a);
				i++;
			}
		}
		return str_new.toString();
	}

	/**
	 * 判断是否是汉字
	 * 
	 * @param str
	 * @return
	 */
	public static boolean isChinaese(String str) {
		boolean flag = false;
		byte[] temp = null;
		try {
			temp = str.getBytes("ISO-8859-1");
		} catch (Exception e) {
			flag = false;
		}
		int i = 0;
		for (i = 0; i < temp.length; i++) {
			if (temp[i] < 0) {
				flag = true;
				i = temp.length;
			}
		}
		return flag;
	}

	// 根据Unicode编码完美的判断中文汉字和符号
	private static boolean isChinese1(char c) {
		Character.UnicodeBlock ub = Character.UnicodeBlock.of(c);
		if (ub == Character.UnicodeBlock.CJK_UNIFIED_IDEOGRAPHS
				|| ub == Character.UnicodeBlock.CJK_COMPATIBILITY_IDEOGRAPHS
				|| ub == Character.UnicodeBlock.CJK_UNIFIED_IDEOGRAPHS_EXTENSION_A
				|| ub == Character.UnicodeBlock.CJK_UNIFIED_IDEOGRAPHS_EXTENSION_B
				|| ub == Character.UnicodeBlock.CJK_SYMBOLS_AND_PUNCTUATION
				|| ub == Character.UnicodeBlock.HALFWIDTH_AND_FULLWIDTH_FORMS
				|| ub == Character.UnicodeBlock.GENERAL_PUNCTUATION) {
			return true;
		}
		return false;
	}

	// 完整的判断中文汉字和符号
	public static boolean isChinaese1(String strName) {
		char[] ch = strName.toCharArray();
		for (int i = 0; i < ch.length; i++) {
			char c = ch[i];
			if (isChinese1(c)) {
				return true;
			}
		}
		return false;
	}

	/**
	 * 客户端数据接口专用 根据执行结果，返回数据信息 用于生成json
	 * 
	 * @param result
	 */
	public static void responseInfo(String result) {
		try {
			System.out.println("responseInfo " + result);

			HttpServletResponse response = ServletActionContext.getResponse();
			response.setContentType("text/html;charset=utf-8");
			response.setCharacterEncoding("UTF-8");
			response.getWriter().write(result);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public static String getNowStringDateTime(int num, String date) {

		String newTime = "";
		try {
			if (!"".equals(date) || date != null) {
				newTime = FORMAT1.format(FORMAT1.parse(date));
			} else {
				newTime = FORMAT1.format(new Date());
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return newTime;
	}

	/**
	 * 获取系统当前时间
	 * 
	 * @param 传递String
	 * @return
	 */
	public static String getNowStringDateTime(String date) {

		String newTime = "";
		try {
			if (!"".equals(date) || date != null) {
				newTime = FORMAT.format(FORMAT.parse(date.toString()));
			} else {
				newTime = FORMAT.format(new Date());
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return newTime;
	}

	/**
	 * 获取系统当前时间
	 * 
	 * @param 传递Date对象
	 * @return
	 */
	public static String getNowStringDateTime(Date date) {

		String newTime = "";

		if (date != null) {
			newTime = FORMAT.format(date);
		} else {
			newTime = FORMAT.format(new Date());
		}
		System.out.println("getNowStringDateTime " + newTime);

		return newTime;
	}

	/**
	 * 
	 * 将字符串中的字母转化为小写
	 * 
	 * @return
	 */
	public static String updateZM(String sRand) {
		String str = new String();

		for (int i = 0; i < sRand.length(); i++) {
			char s = sRand.charAt(i);
			if (s >= 'A' && s <= 'Z') {
				s = (char) (s + 32);
			}
			str += s;
		}
		return str;
	}
}
