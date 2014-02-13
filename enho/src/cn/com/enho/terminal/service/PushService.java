package cn.com.enho.terminal.service;

import java.util.Map;

import cn.com.enho.base.service.BaseService;

/**
 * 		推送服务
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-23 上午10:14:00
 */
public interface PushService extends BaseService{

	public boolean pushNotice(String appkey,String masterSecret,long timeToLive,String alias,String title,String content,Map<String, Object> extra);
}
