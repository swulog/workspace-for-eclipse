package cn.com.enho.terminal.service;

import cn.com.enho.base.service.BaseService;

/**
 * 		状态检测服务
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-23 上午10:15:40
 */
public interface StatusCheckService extends BaseService{

	public void check(String infoid,int infotype);
}
