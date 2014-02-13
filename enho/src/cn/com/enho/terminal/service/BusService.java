package cn.com.enho.terminal.service;

import org.quartz.SchedulerException;

import cn.com.enho.base.service.BaseService;
import cn.com.enho.comm.Result;
import cn.com.enho.terminal.dto.GetPhoneDto;
import cn.com.enho.terminal.dto.MarkDto;
import cn.com.enho.terminal.dto.QryBacklogDto;
import cn.com.enho.terminal.dto.QryMarkListDto;
import cn.com.enho.terminal.dto.QryMyMarkDto;
import cn.com.enho.terminal.dto.QryTradeRecordDto;
import cn.com.enho.terminal.dto.TradeConfirmDto;

/**
 * 		业务服务
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-23 上午10:21:17
 */
public interface BusService extends BaseService{

	public void requestPhone4G(String appkey,String masterSecret,long timeToLive,GetPhoneDto getPhoneDto, Result result) throws SchedulerException;
	public void requestPhone4C(String appkey,String masterSecret,long timeToLive,GetPhoneDto getPhoneDto, Result result) throws SchedulerException; 
	public void tradeConfirm(TradeConfirmDto tradeConfirmDto, Result result)throws SchedulerException;
	public void qryTradeRecord(QryTradeRecordDto qryTradeRecordDto,Result result);
	public void qryMarkList(QryMarkListDto qryMarkListDto,Result result);
	public void mark(MarkDto markDto,Result result);
	public void qryMyMark(QryMyMarkDto qryMyMarkDto,Result result);
	public void qryBacklog(QryBacklogDto qryBacklogDto,Result result);
	public void qryUnMarkNum(String userid,Integer usertype, Result result);
}
