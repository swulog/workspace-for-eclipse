package cn.com.enho.comm.util;

import java.util.List;

import net.sf.json.JSONArray;

/**
 * 		json工具类
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-10-17 下午2:27:18
 */
public class JSONUtil {

	/**
	 * 将数组格式的json字符串转换为java对象
	 * @param str
	 */
	@SuppressWarnings({ "static-access", "rawtypes" })
	public static List strToJson(String str,Class c){
		if(str!=null && !"".equals(str)){
			JSONArray ja=JSONArray.fromObject(str);
			List list=ja.toList(ja, c);
			return list;
		}else{
			return null;
		}
	}
	
}
