package cn.com.enho.terminal.service;

import cn.com.enho.base.service.BaseService;
import cn.com.enho.comm.Result;
import cn.com.enho.terminal.dto.TipoffDto;

/**
 * 		举报Service接口
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-16 下午2:00:48
 */
public interface TipoffService extends BaseService{

	public void addTipoff(TipoffDto tipoffDto,Result result);
}
