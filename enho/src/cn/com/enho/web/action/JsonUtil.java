package cn.com.enho.web.action;

import java.util.Iterator;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.util.JSONBuilder;
import net.sf.json.util.JSONStringer;
/**
 * 把数据封装成JSON格式以字符串形式返回
 * @author Administrator
 *
 */

public class JsonUtil {
	
	//单个对象的封装
	@SuppressWarnings("rawtypes")
	public static String jsonObject(Map map){
		JSONStringer json = new JSONStringer();
		Iterator iter = map.keySet().iterator();
		String str = "";
		JSONBuilder jb =  json.object();
		while(iter.hasNext()){
			String key = iter.next().toString();
			Object value = map.get(key);
			jb.key(key).value(value);
		}
		
		str = jb.endObject().toString();
		return str;
	}
	
	//List的封装
	@SuppressWarnings("rawtypes")
	public static String jsonList(List list){
		 JSONArray jsonArray = JSONArray.fromObject(list);
	     return jsonArray.toString();
	}
	
	//数组的封装
	 public static JSONArray toJSONArray(Object object){
	        return JSONArray.fromObject(object);
	    }
	 
}
