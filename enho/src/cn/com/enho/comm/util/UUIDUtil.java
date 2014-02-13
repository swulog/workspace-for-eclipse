package cn.com.enho.comm.util;

/**
 * 		uuid工具类
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-8 上午10:25:06
 */
public class UUIDUtil {
	
	/**
	 * 获取UUID
	 * @return
	 */
	public static String getUUID(){
		return java.util.UUID.randomUUID().toString();
	}
}
