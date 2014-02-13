package cn.com.enho.comm.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

/**
 * 		日期工具类
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-8 上午10:49:15
 */
public class DateUtil {
	
	private static final SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

	/**
	 * 获取当前时间
	 * @return
	 */
	public static String getCurrentTime4Str(){
		return sdf.format(Calendar.getInstance().getTime());
	}
	
	/**
	 * 获取当前时间
	 * @return
	 */
	public static Date getCurrentTime4Date(){
		Date date=Calendar.getInstance().getTime();
		try {
			date=sdf.parse(sdf.format(date));
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return date;
	}
	
	/**
	 * 将字符串时间转换为Date
	 * @param str
	 * @return
	 */
	public static Date strToDate(String str){
		Date date=null;
		try {
			date=sdf.parse(str);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return date;
	}
	
	/**
	 * 将Date时间转换为字符串时间
	 * @param date
	 * @return
	 */
	public static String dateToStr(Date date){
		return sdf.format(date);
	}
	
	public static Date dateFormat(Date date){
		Date date1=null;
		if(date!=null){
			try {
				date1=sdf.parse(sdf.format(date));
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return date1;
	}
}
