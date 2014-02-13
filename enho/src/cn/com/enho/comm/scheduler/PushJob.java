package cn.com.enho.comm.scheduler;

import java.util.Map;

import org.apache.log4j.Logger;
import org.quartz.JobDataMap;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.scheduling.quartz.QuartzJobBean;

import cn.com.enho.terminal.service.PushService;

/**
 * 		推送job
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-22 上午11:48:25
 */
public class PushJob extends QuartzJobBean{

	static Logger logger = Logger.getLogger(PushJob.class.getName());
	private PushService pushService;

	public PushService getPushService() {
		return pushService;
	}

	public void setPushService(PushService pushService) {
		this.pushService = pushService;
	}


	@SuppressWarnings("unchecked")
	@Override
	protected void executeInternal(JobExecutionContext context)
			throws JobExecutionException {
		// TODO Auto-generated method stub
		logger.debug("*************************             开始推送交易确认信息                                       ********************************");
		JobDataMap jobDataMap=context.getJobDetail().getJobDataMap();
		if(jobDataMap!=null){
			//推送信息
			this.pushService.pushNotice(jobDataMap.getString("appkey"), jobDataMap.getString("masterSecret"), jobDataMap.getLong("timeToLive"), jobDataMap.getString("alias"), jobDataMap.getString("title"), jobDataMap.getString("content"),(Map<String,Object>)jobDataMap.get("extra"));
		}
	}
}
