package cn.com.enho.comm.util;

import java.util.List;
import java.util.Map;

/**
 * 		集合工具类
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-9-16 下午3:37:21
 */
public class CollectionUtil {

	public static List<Map<Object,Object>> sort(List<Map<Object,Object>> list){
		if(list!=null && list.size()>0){
			int len=list.size();
			boolean flag=false;
			for(int i=0;i<len-1;i++){
				for(int j=i;j<len-1;j++){
					int sort1=Integer.parseInt(list.get(j).get("order").toString());
					int sort2=Integer.parseInt(list.get(j+1).get("order").toString());
					if(sort1>sort2){
						list.get(j).put("order", sort2);
						list.get(j+1).put("order", sort1);
						flag=true;
					}
				}
				if(flag==false){
					break;
				}
			}
		}
		return list;
	}
}
