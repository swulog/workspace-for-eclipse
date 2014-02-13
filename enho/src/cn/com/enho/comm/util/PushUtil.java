package cn.com.enho.comm.util;

import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;

import cn.com.enho.comm.jpush.ErrorCodeEnum;
import cn.com.enho.comm.jpush.JPushClient;
import cn.com.enho.comm.jpush.MessageResult;

/**
 * 		推送
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-22 下午2:09:56
 */
public class PushUtil {

	static Logger logger = Logger.getLogger(PushUtil.class.getName());
	
	/**
	 * 推送通知
	 * @param appkey
	 * @param masterSecret
	 * @param timeToLive
	 * @param title
	 * @param content
	 * @return
	 */
	public static boolean pushNotice(String appkey,String masterSecret,long timeToLive,String alias,String title,String content,Map<String, Object> extra){
		try{
			JPushClient jpush = new JPushClient(masterSecret, appkey, timeToLive);
			//随机产生发送号
			int sendNo=(int)((Integer.MAX_VALUE/2)+((Integer.MAX_VALUE-Integer.MIN_VALUE)*Math.random()));
			MessageResult mr=jpush.sendNotificationWithAlias(sendNo, alias, title, content, 0, extra);
			if(mr!=null){
				if (mr.getErrcode() == ErrorCodeEnum.NOERROR.value()) {
					logger.debug("发送成功， sendNo=" + mr.getSendno());
					return true;
				} else {
					logger.debug("发送失败， 错误代码=" + mr.getErrcode() + ", 错误消息=" + mr.getErrmsg());
					return false;
				}
			}else{
				logger.debug("无法获取数据");
				return false;
			}
		}catch(Exception e){
			logger.debug(e.getMessage());
			return false;
		}
	}
	
	public static void main(String[] args) {
		JPushClient jpush = new JPushClient("c663ed976cd0c1da7246d213", "900116c042a8b9bff5591863", 60 * 60 * 24);
		//jpush.sendNotificationWithAlias(44562, "15683129389", "", "尊敬的蒋先生，你是sb？");
		//jpush.sendNotificationWithAlias(445621, "18996229198", "", "尊敬的龙先生，你是sb？");
		//jpush.sendNotificationWithAlias(445621, "18996229198", "您有新信息", "014a54ad-5d77-471d-96fc-4f52fea4855f,014a54ad-5d77-471d-96fc-4f52fea4855f,1,13629790326");
		Map<String, Object> map=new HashMap<String, Object>();
		map.put("info", "请您确认与136****0326的交易,谢谢");
		jpush.sendNotificationWithAlias((int)(Math.random()*10000), "15223161736", "", "您有新信息", 0, map);
		//jpush.sendNotificationWithAlias((int)(Math.random()*10000), "18996229198", "", "您有新信息", 0, map); 
	}
}
