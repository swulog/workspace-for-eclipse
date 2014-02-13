package cn.com.enho.comm.scheduler;

import java.util.Date;
import java.util.Map;

import org.quartz.JobDetail;
import org.quartz.Scheduler;
import org.quartz.SchedulerException;
import org.quartz.SchedulerFactory;
import org.quartz.SimpleTrigger;
import org.quartz.impl.StdSchedulerFactory;

/**
 * 		任务处理工具类
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-22 下午3:10:06
 */
public class SchedulerUtil {

	private static 	SchedulerFactory schedulerFactory = new StdSchedulerFactory(); 
	/**
	 * 创建JobDetail
	 * @param name
	 * @param gname
	 * @param jobClass
	 * @param param
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	public static JobDetail createJobDetail(String name,String gname,Class jobClass,Map param){
		JobDetail jobDetail = new JobDetail(name,gname, jobClass);
		jobDetail.getJobDataMap().putAll(param);
		return jobDetail;
	}
	
	/**
	 * 创建触发器
	 * @param name
	 * @param gname
	 * @param starttime
	 * @param repeatCount
	 * @param repeatInterval
	 * @return
	 */
	public static SimpleTrigger createSimpleTrigger(String name,String gname,Date starttime,int repeatCount,long repeatInterval){
		SimpleTrigger simpleTrigger = new  SimpleTrigger(name,gname); 
		simpleTrigger.setStartTime(starttime);
		simpleTrigger.setRepeatCount(repeatCount);
		simpleTrigger.setRepeatInterval(repeatInterval); 
		return simpleTrigger;
	}
	
	/**
	 * 创建任务计划
	 * @param jobDetail
	 * @param simpleTrigger
	 * @return
	 * @throws SchedulerException
	 */
	public static Scheduler getScheduler(JobDetail jobDetail,SimpleTrigger simpleTrigger) throws SchedulerException{
		Scheduler scheduler = schedulerFactory.getScheduler();  
		scheduler.scheduleJob(jobDetail, simpleTrigger);
		return scheduler;
	}
}
