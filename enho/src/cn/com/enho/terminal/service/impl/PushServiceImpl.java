package cn.com.enho.terminal.service.impl;

import java.io.Serializable;
import java.util.Map;

import cn.com.enho.base.service.impl.BaseServiceImpl;
import cn.com.enho.comm.util.PushUtil;
import cn.com.enho.terminal.service.PushService;

/**
 * 		推送服务
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-23 上午10:14:32
 */
public class PushServiceImpl extends BaseServiceImpl implements PushService,Serializable{

	private static final long serialVersionUID = 1L;

	/**
	 * 推送通知
	 * @param appkey
	 * @param masterSecret
	 * @param timeToLive
	 * @param alias
	 * @param title
	 * @param content
	 * @return
	 */
	public boolean pushNotice(String appkey, String masterSecret,
			long timeToLive, String alias, String title, String content,Map<String, Object> extra) {
		// TODO Auto-generated method stub
		return PushUtil.pushNotice(appkey, masterSecret, timeToLive, alias, title, content,extra);
		
	}

}
