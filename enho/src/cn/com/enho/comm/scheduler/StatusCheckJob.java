package cn.com.enho.comm.scheduler;

import org.apache.log4j.Logger;
import org.quartz.JobDataMap;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.scheduling.quartz.QuartzJobBean;

import cn.com.enho.terminal.service.StatusCheckService;

/**
 * 		信息状态检测job
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-22 上午11:49:01
 */
public class StatusCheckJob extends QuartzJobBean{

	static Logger logger = Logger.getLogger(StatusCheckJob.class.getName());

	private StatusCheckService checkService;
	
	public StatusCheckService getCheckService() {
		return checkService;
	}

	public void setCheckService(StatusCheckService checkService) {
		this.checkService = checkService;
	}

	@Override
	protected void executeInternal(JobExecutionContext context)
			throws JobExecutionException {
		// TODO Auto-generated method stub
		logger.debug("*************************             状态检测触发开始                                       ********************************");
		JobDataMap jobDataMap=context.getJobDetail().getJobDataMap();
		if(jobDataMap!=null){
			//状态检测
			this.checkService.check(jobDataMap.getString("infoid"), jobDataMap.getInt("infotype"));
		}
	}

}
