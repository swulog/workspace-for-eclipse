package cn.com.enho.terminal.service;

import cn.com.enho.base.service.BaseService;
import cn.com.enho.comm.Result;
import cn.com.enho.terminal.dto.PubFeedBackDto;

/**
 * 		反馈信息操作Service
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-16 上午11:38:08
 */
public interface FeedBackService extends BaseService{

	public void addFeedBack(PubFeedBackDto pubFeedBackDto,Result result);
}
