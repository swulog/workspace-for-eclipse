package cn.com.enho.comm.util;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import sun.misc.BASE64Encoder;



/**
 * md5加密工具类
 * @author xionglei
 *
 */
public class Md5Util {

	/**
	 * md5加密
	 * @param str
	 * @return
	 */
	public static String encodeByMd5(String str){
		String newstr="";
		try {
			MessageDigest md5 = MessageDigest.getInstance("MD5");
			BASE64Encoder base64en = new BASE64Encoder();
			newstr = base64en.encode(md5.digest(str.getBytes("utf-8")));
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}catch (NoSuchAlgorithmException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return newstr;
	}
}
