package cn.com.enho.comm.util;

import java.io.IOException;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpException;
import org.apache.commons.httpclient.NameValuePair;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.log4j.Logger;

/**
 * 		短信发送工具类
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-14 下午4:35:57
 */
public class SMSUtil {

	static Logger logger = Logger.getLogger(SMSUtil.class.getName());
	
	/**
	 * 发送短信
	 * @param phoneNo
	 * @param content
	 * @throws IOException 
	 */
	public static boolean sendSMS(String username,String password,String smsurl_utf8,String smsurl_gbk,String phoneNo,String content){
		HttpClient client = new HttpClient();
		
		PostMethod post = new PostMethod(smsurl_utf8); 
		post.addRequestHeader("Content-Type","application/x-www-form-urlencoded;charset=utf8");//在头文件中设置转码
		NameValuePair[] data ={ new NameValuePair("Uid", username),new NameValuePair("Key", password),new NameValuePair("smsMob",phoneNo),new NameValuePair("smsText",content)};
		post.setRequestBody(data);
		
		try {
			client.executeMethod(post);
			//Header[] headers = post.getResponseHeaders();
			//返回状态码
			int statusCode = post.getStatusCode();
			if(statusCode>0){
				logger.debug("状态码:   "+statusCode);
				logger.debug("短信发送:   "+"成功发送"+1+"条短信");
				return true;
			}else if(statusCode==-1){
				logger.debug("短信发送:   "+"没有该用户账户");
			}else if(statusCode==-2){
				logger.debug("短信发送:   "+"密钥不正确");
			}else if(statusCode==-3){
				logger.debug("短信发送:   "+"短信数量不足");
			}else if(statusCode==-11){
				logger.debug("短信发送:   "+"该用户被禁用");
			}else if(statusCode==-14){
				logger.debug("短信发送:   "+"短信内容出现非法字符");
			}else if(statusCode==-4){
				logger.debug("短信发送:   "+"手机号格式不正确");
			}else if(statusCode==-41){
				logger.debug("短信发送:   "+"手机号码为空");
			}else if(statusCode==-42){
				logger.debug("短信发送:   "+"短信内容为空");
			}else{
				logger.debug("短信发送:   "+"未知错误");
			}
		} catch (HttpException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			return false;
		} catch (IOException e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
			
			PostMethod post1 = new PostMethod(smsurl_gbk); 
			post1.addRequestHeader("Content-Type","application/x-www-form-urlencoded;charset=gbk");//在头文件中设置转码
			NameValuePair[] data1 ={ new NameValuePair("Uid", username),new NameValuePair("Key", password),new NameValuePair("smsMob",phoneNo),new NameValuePair("smsText",content)};
			post1.setRequestBody(data1);
			try {
				client.executeMethod(post1);
				int statusCode1 = post1.getStatusCode();
				if(statusCode1>0){
					logger.debug("短信发送:   "+"成功发送"+1+"条短信");
					return true;
				}else if(statusCode1==-1){
					logger.debug("短信发送:   "+"没有该用户账户");
				}else if(statusCode1==-2){
					logger.debug("短信发送:   "+"密钥不正确");
				}else if(statusCode1==-3){
					logger.debug("短信发送:   "+"短信数量不足");
				}else if(statusCode1==-11){
					logger.debug("短信发送:   "+"该用户被禁用");
				}else if(statusCode1==-14){
					logger.debug("短信发送:   "+"短信内容出现非法字符");
				}else if(statusCode1==-4){
					logger.debug("短信发送:   "+"手机号格式不正确");
				}else if(statusCode1==-41){
					logger.debug("短信发送:   "+"手机号码为空");
				}else if(statusCode1==-42){
					logger.debug("短信发送:   "+"短信内容为空");
				}else{
					logger.debug("短信发送:   "+"未知错误");
				}
			} catch (HttpException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				return false;
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				return false;
			}
			return false;
		}
		//post.releaseConnection();
		return false;
	}
	
	public static void main(String args[]) throws HttpException, IOException{
		//sendSMS("enhong","123456","http://www.106618.com/sms/?ctl=vipsendsms&act=do","15683129389","hello 龙大神");
		//sendSMS("enho","erlang314159","http://utf8.sms.webchinese.cn/","18996229198","hello 龙大神  【重庆宏程万里科技有限公司】");
		//sendSMS("enho","c65c9aed70dbe4a50b14","http://utf8.sms.webchinese.cn/?aa=1","13629790326","hello 龙大神  【重庆宏程万里科技有限公司】");
		//sendSMS("enho","c65c9aed70dbe4a50b14","http://utf8.sms.webchinese.cn/?Uid=本站用户名&Key=接口安全密码&smsMob=手机号码&smsText=短信内容","15683129389","hello 龙大神  【重庆宏程万里科技有限公司】");
		/*HttpRequest request = new HttpRequest();  
		try {
			HttpResponse hr=request.sendPost(java.net.URLEncoder.encode("http://utf8.sms.webchinese.cn/?Uid=enho&Key=erlang314159&smsMob=15683129389&smsText=hello 龙大神  【重庆宏程万里科技有限公司】", "utf-8"));
			System.out.println(hr.getContent().trim());
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}*/
		
		
		/*HttpClient client = new HttpClient();
		PostMethod post = new PostMethod("http://utf8.sms.webchinese.cn/"); 
		post.addRequestHeader("Content-Type","application/x-www-form-urlencoded;charset=utf8");//在头文件中设置转码
		NameValuePair[] data ={ new NameValuePair("Uid", "enho"),new NameValuePair("Key", "c65c9aed70dbe4a50b14"),new NameValuePair("smsMob","13629790326"),new NameValuePair("smsText","hello 龙大神  【重庆宏程万里科技有限公司】")};
		post.setRequestBody(data);

		client.executeMethod(post);
		Header[] headers = post.getResponseHeaders();
		int statusCode = post.getStatusCode();
		System.out.println("statusCode:"+statusCode);
		for(Header h : headers)
		{
		System.out.println(h.toString());
		}
		String result = new String(post.getResponseBodyAsString().getBytes("utf8")); 
		System.out.println(result);


		post.releaseConnection();*/
		//SMSUtil.sendSMS("enho","c65c9aed70dbe4a50b14","http://utf8.sms.webchinese.cn/","http://gbk.sms.webchinese.cn/","15334509724,15989176279,13330200777,15023171079,13694238858,18028103777,18723192388","重庆到广州有30吨百货需17米车，货主联系方式：15023112923,即时货运部App下载地址：http://www.enho.com.cn/download.jsp 【重庆宏程万里科技有限公司】");
		//SMSUtil.sendSMS("enho","c65c9aed70dbe4a50b14","http://utf8.sms.webchinese.cn/","http://gbk.sms.webchinese.cn/","15023112923","车主15334509724,15989176279,13330200777,15023171079,13694238858,18028103777,18723192388 有重庆到广州的专线,您可以主动和他们取得联系 【重庆宏程万里科技有限公司】");

		}
	
}
