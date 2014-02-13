package cn.com.enho.comm.util;

import java.io.IOException;
import java.util.Map;

import cn.com.enho.comm.HttpRequest;
import cn.com.enho.comm.HttpResponse;

/**
 * 		http接口请求工具类
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-14 下午4:23:22
 */
public class HttpUtil {

	public static void sendPost(String url,Map<String,String> params){
		HttpRequest request = new HttpRequest();  
	    HttpResponse hr;
		try {
			hr = request.sendPost(url, params);
			System.out.println(hr.getUrlString());  
		    System.out.println(hr.getProtocol());  
		    System.out.println(hr.getHost());  
		    System.out.println(hr.getPort());  
		    System.out.println(hr.getContentEncoding());  
		    System.out.println(hr.getMethod());  
		    System.out.println(hr.getContent());  
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}  
	}
	
	public static void main(String args[]){
		/*Map<String,String> map=new HashMap<String,String>();
		map.put("username", "enhong");
		map.put("password", "123456");
		map.put("phonelist", "13629790326");
		map.put("content", "hello,中国");
		T t1=new T();
		t1
		sendPost("http://www.106618.com/sms/?ctl=vipsendsms&act=do",map);*/
		
		
		
		/*Map<String,String> map=new HashMap<String,String>();
		map.put("phoneno","13888888888");
		map.put("userpwd", "qqq");
		HttpUtil.sendPost("http://192.168.1.155:8080/enho/comm/login.do",map);*/
		
		
		/*for(int i=0;i<100;i++){
			T t=new T();
			t.start();
		}*/
		
	}
	
}
/*class T extends Thread{
	public void run(){
		System.out.print("aa");
		Map<String,String> map=new HashMap<String,String>();
		map.put("infotype","2");
		map.put("infoid", "0f3c5ba6-c5b5-4a1f-a094-f63be64efb8c");
		map.put("requserid", "391c71ef-0d92-462a-b6bd-d15cdf7861a8");
		map.put("requserphone", "13888888888");
		map.put("uuid", "c44dd4f2-252c-4566-8043-89314f4988d4");
		HttpUtil.sendPost("http://192.168.1.155:8080/enho/terminal/getPhone4C.do",map);
	}
}*/
