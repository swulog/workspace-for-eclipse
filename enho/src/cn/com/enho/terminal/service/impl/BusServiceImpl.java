package cn.com.enho.terminal.service.impl;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.quartz.JobDetail;
import org.quartz.Scheduler;
import org.quartz.SchedulerException;
import org.quartz.SimpleTrigger;
import org.springframework.beans.factory.annotation.Autowired;

import cn.com.enho.base.service.impl.BaseServiceImpl;
import cn.com.enho.comm.Result;
import cn.com.enho.comm.constants.Constants;
import cn.com.enho.comm.util.DateUtil;
import cn.com.enho.comm.util.StringUtil;
import cn.com.enho.comm.util.UUIDUtil;
import cn.com.enho.terminal.dao.BusDao;
import cn.com.enho.terminal.dto.GetPhoneDto;
import cn.com.enho.terminal.dto.MarkDto;
import cn.com.enho.terminal.dto.QryBacklogDto;
import cn.com.enho.terminal.dto.QryMarkListDto;
import cn.com.enho.terminal.dto.QryMyMarkDto;
import cn.com.enho.terminal.dto.QryTradeRecordDto;
import cn.com.enho.terminal.dto.TradeConfirmDto;
import cn.com.enho.terminal.entity.CarInfo;
import cn.com.enho.terminal.entity.GoodsInfo;
import cn.com.enho.terminal.entity.TradeInfo;
import cn.com.enho.terminal.entity.User;
import cn.com.enho.terminal.service.BusService;

/**
 * 		业务服务
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-23 上午10:21:00
 */
public class BusServiceImpl extends BaseServiceImpl implements BusService{

	@Autowired
	private BusDao busDao;
	
	private Scheduler scheduler; 
	private JobDetail pushJobDetail;
	private JobDetail checkJobDetail;
	
	public Scheduler getScheduler() {
		return scheduler;
	}

	public void setScheduler(Scheduler scheduler) {
		this.scheduler = scheduler;
	}

	public JobDetail getPushJobDetail() {
		return pushJobDetail;
	}

	public void setPushJobDetail(JobDetail pushJobDetail) {
		this.pushJobDetail = pushJobDetail;
	}

	public JobDetail getCheckJobDetail() {
		return checkJobDetail;
	}

	public void setCheckJobDetail(JobDetail checkJobDetail) {
		this.checkJobDetail = checkJobDetail;
	}

	/**
	 * 获取联系方式(获取货主的联系方式)
	 * @throws SchedulerException 
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Override
	public void requestPhone4G(String appkey,String masterSecret,long timeToLive,GetPhoneDto getPhoneDto, Result result) throws SchedulerException {
		// TODO Auto-generated method stub
		String infoid=getPhoneDto.getInfoid();//信息id
		int infotype=getPhoneDto.getInfotype();// 信息类型
		String requestid=getPhoneDto.getRequserid();//请求用户id
		String requestphone=getPhoneDto.getRequserphone();//请求用户手机号码
		
		//货源信息
		if(infotype==Constants.INFO_G){
			//获取货源信息
			GoodsInfo goodsInfo=(GoodsInfo)this.busDao.get(GoodsInfo.class, infoid);
			if(goodsInfo==null){
				result.setSuccess(false);
				result.setMsg("货源信息不存在");
				return;
			}
			int status=goodsInfo.getT_goods_status();
			//如果已下架
			if(status==Constants.STATUS_DOWN){
				result.setSuccess(false);
				result.setMsg("您请求的货源信息已下架");
				return;
			}
			//如果已锁定
			if(status==Constants.STATUS_LOCK){
				result.setSuccess(false);
				result.setMsg("您请求的货源信息正在交易中");
				return;
			}
			//如果正常
			if(status==Constants.STATUS_NORMAL){
				String phoneno=goodsInfo.getT_goods_userid().getT_user_phone();//发布人手机
				String contractphoneno=goodsInfo.getT_goods_contactsphone();//联系人手机
				String tel=goodsInfo.getT_goods_contactstel();//联系人电话
				
				//修改信息状态为锁定
				goodsInfo.setT_goods_status(Constants.STATUS_LOCK);
				//修改请求人
				//User user=new User();
				//user.setT_user_id(requestid);
				goodsInfo.setT_goods_requserid(requestid);
				//修改请求时间
				goodsInfo.setT_goods_reqtime(DateUtil.getCurrentTime4Str());
				this.busDao.update(goodsInfo);
				
				//开启推送任务（3）
				Map param=new HashMap();
				//appkey, masterSecret, timeToLive, alias, title, content
				param.put("appkey", appkey);
				param.put("masterSecret", masterSecret);
				param.put("timeToLive", timeToLive);
				param.put("alias", phoneno);
				param.put("title", "");
				param.put("content", "您有新消息");
				Map<String, Object> extra=new HashMap<String, Object>();//推送内容
				//extra.put("infoid", infoid);//信息id
				//extra.put("requestid", requestid);//请求用户id
				//extra.put("infotype", Constants.INFO_G);//信息类型（货源信息）
				extra.put("info", "请您确认与用户"+StringUtil.replaceStr(requestphone, 3, 7, "****")+"的交易，谢谢");//请求用户手机号码
				param.put("extra", extra);
				pushJobDetail.setName(UUIDUtil.getUUID());
				pushJobDetail.getJobDataMap().putAll(param);
				
				Calendar calendar=Calendar.getInstance();
				calendar.add(Calendar.MINUTE, Constants.DEFAULT_PUSH_INTERVAL);
				//calendar.add(Calendar.SECOND, 5);
				SimpleTrigger simpleTrigger = new  SimpleTrigger(UUIDUtil.getUUID(),Scheduler.DEFAULT_GROUP); 
				simpleTrigger.setStartTime(calendar.getTime());
				simpleTrigger.setRepeatCount(0);
				
		        scheduler.scheduleJob(pushJobDetail,simpleTrigger);  
				
				
				//开启状态检测任务(13)
		        checkJobDetail.setName(UUIDUtil.getUUID());
		        checkJobDetail.getJobDataMap().put("infoid", infoid);
		        checkJobDetail.getJobDataMap().put("infotype", infotype);
		        
		        Calendar calendar1=Calendar.getInstance();
				calendar1.add(Calendar.MINUTE, Constants.DEFAULT_CHECK_INTERVAL);
				SimpleTrigger simpleTrigger1 = new  SimpleTrigger(infoid,Scheduler.DEFAULT_GROUP); //将信息id作为触发器名称
				simpleTrigger1.setStartTime(calendar1.getTime());
				simpleTrigger1.setRepeatCount(0);
		        
				scheduler.scheduleJob(checkJobDetail,simpleTrigger1);  
				
				//返回结果
				result.setSuccess(true);
				result.setMsg("获取成功");
				result.getData().put("phoneno", contractphoneno);//联系人手机
				result.getData().put("tel", tel);
				return;
			}
		}else{
			result.setSuccess(false);
			result.setMsg("信息类型不正确");
			return;
		}
	}

	
	/**
	 * 获取联系方式(获取车主的联系方式)
	 * @throws SchedulerException 
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Override
	public void requestPhone4C(String appkey,String masterSecret,long timeToLive,GetPhoneDto getPhoneDto, Result result) throws SchedulerException {
		// TODO Auto-generated method stub
		String infoid=getPhoneDto.getInfoid();//信息id
		int infotype=getPhoneDto.getInfotype();// 信息类型
		String requestid=getPhoneDto.getRequserid();//请求用户id
		String requestphone=getPhoneDto.getRequserphone();//请求用户手机号码
		
		//车源信息
		if(infotype==Constants.INFO_C){
			//获取车源信息
			CarInfo carInfo=(CarInfo)this.busDao.get(CarInfo.class, infoid);
			if(carInfo==null){
				result.setSuccess(false);
				result.setMsg("车源信息不存在");
				return;
			}
			int status=carInfo.getT_car_status();
			//如果已下架
			if(status==Constants.STATUS_DOWN){
				result.setSuccess(false);
				result.setMsg("您请求的车源信息已下架");
				return;
			}
			//如果已锁定
			if(status==Constants.STATUS_LOCK){
				result.setSuccess(false);
				result.setMsg("您请求的车源信息正在交易中");
				return;
			}
			//如果正常
			if(status==Constants.STATUS_NORMAL){
				
				//String phoneno=carInfo.getT_car_userid().getT_user_phone();//发布人手机
				String contractphoneno=carInfo.getT_car_contactsphone();//联系人手机
				String tel=carInfo.getT_car_contactstel();//联系人电话
				
				//修改信息状态为锁定
				//carInfo.setT_car_status(Constants.STATUS_LOCK);
				
				//修改请求人
				//User user=new User();
				//user.setT_user_id(requestid);
				carInfo.setT_car_requserid(requestid);
				//修改请求时间
				carInfo.setT_car_reqtime(DateUtil.getCurrentTime4Str());
				this.busDao.update(carInfo);
				
				//开启推送任务（3）
				Map param=new HashMap();
				//appkey, masterSecret, timeToLive, alias, title, content
				param.put("appkey", appkey);
				param.put("masterSecret", masterSecret);
				param.put("timeToLive", timeToLive);
				param.put("alias", requestphone);//推送给货主
				param.put("title", "");
				param.put("content", "您有新消息");
				
				Map<String, Object> extra=new HashMap<String, Object>();//推送内容
				//extra.put("infoid", infoid);//信息id
				//extra.put("requestid", requestid);//请求用户id
				//extra.put("infotype", Constants.INFO_C);//信息类型（车源信息）
				extra.put("info", "请您确认与用户"+StringUtil.replaceStr(contractphoneno, 3, 7, "****")+"的交易,谢谢");//请求用户手机号码
				param.put("extra", extra);
				
				//String u1=String.valueOf(Math.random());
				//System.out.println("***********************************************   u1: "+u1+"        ******************************************");
				pushJobDetail.setName(UUIDUtil.getUUID());
				pushJobDetail.getJobDataMap().putAll(param);
				
				Calendar calendar=Calendar.getInstance();
				calendar.add(Calendar.MINUTE, Constants.DEFAULT_PUSH_INTERVAL);
				//calendar.add(Calendar.SECOND, 5);
				
				//String u2=String.valueOf(Math.random());
				//System.out.println("***********************************************   u2: "+u1+"        ******************************************");
				SimpleTrigger simpleTrigger = new  SimpleTrigger(UUIDUtil.getUUID(),Scheduler.DEFAULT_GROUP); 
				simpleTrigger.setStartTime(calendar.getTime());
				simpleTrigger.setRepeatCount(0);
				
				scheduler.scheduleJob(pushJobDetail,simpleTrigger);  
				
				
				//开启状态检测任务(13)
				/*checkJobDetail.setName(UUIDUtil.getUUID());
				checkJobDetail.getJobDataMap().put("infoid", infoid);
				checkJobDetail.getJobDataMap().put("infotype", infotype);
				
				Calendar calendar1=Calendar.getInstance();
				calendar1.add(Calendar.MINUTE, Constants.DEFAULT_CHECK_INTERVAL);
				SimpleTrigger simpleTrigger1 = new  SimpleTrigger(UUIDUtil.getUUID(),Scheduler.DEFAULT_GROUP); 
				simpleTrigger1.setStartTime(calendar1.getTime());
				simpleTrigger1.setRepeatCount(0);
				
				scheduler.scheduleJob(checkJobDetail,simpleTrigger1);  */
				
				//返回结果
				result.setSuccess(true);
				result.setMsg("获取成功");
				result.getData().put("phoneno", contractphoneno);//联系人手机号码
				result.getData().put("tel", tel);
				return;
			}
		}else{
			result.setSuccess(false);
			result.setMsg("信息类型不正确");
			return;
		}
		
		
	}
	
	/**
	 * 交易确认
	 * @throws SchedulerException 
	 */
	@Override
	public void tradeConfirm(TradeConfirmDto tradeConfirmDto, Result result) throws SchedulerException {
		// TODO Auto-generated method stub
		int infotype=tradeConfirmDto.getInfotype();
		int tradeflag=tradeConfirmDto.getFlag();
		
		//货源
		if(infotype==Constants.INFO_G){
			//如果交易成功
			if(tradeflag==Constants.TRADE_FLAG_SUCCESS){
				GoodsInfo goodsInfo=(GoodsInfo)this.busDao.get(GoodsInfo.class, tradeConfirmDto.getInfoid());//货源信息
				User user=(User)this.busDao.get(User.class, tradeConfirmDto.getRequserid());//请求人（车主）
				
				//修改货源信息状态为下架
				goodsInfo.setT_goods_status(Constants.STATUS_DOWN);
				//goodsInfo.setT_goods_requserid(null);
				//goodsInfo.setT_goods_reqtime("");
				this.busDao.update(goodsInfo);
				
				//插入交易记录
				TradeInfo tradeInfo=new TradeInfo();
				tradeInfo.setT_trade_id(UUIDUtil.getUUID());//id
				tradeInfo.setT_trade_goodsid(goodsInfo.getT_goods_userid().getT_user_id());//货主id
				tradeInfo.setT_trade_carid(tradeConfirmDto.getRequserid());//车主id
				tradeInfo.setT_trade_goodsname(goodsInfo.getT_goods_contactsname());//货主名称
				tradeInfo.setT_trade_carname(user.getT_user_name());//车主名称
				tradeInfo.setT_trade_goodsphone(goodsInfo.getT_goods_contactsphone());//货主phone
				tradeInfo.setT_trade_carphone(user.getT_user_phone());//车主phone
				tradeInfo.setT_trade_type(Constants.TRADE_TYPE_CG);//车主请求货源
				tradeInfo.setT_trade_createtime(DateUtil.getCurrentTime4Str());//交易时间
				this.busDao.insert(tradeInfo);
				
				//给货主增加积分
				User goodser=goodsInfo.getT_goods_userid();
				goodser.setT_user_integral(goodser.getT_user_integral()+Constants.DEFAULT_TRADE_CG);
				this.busDao.update(goodser);
				
			}
			//如果交易失败
			if(tradeflag==Constants.TRADE_FLAG_FAIL){
				//修改货源信息状态为正常
				GoodsInfo goodsInfo=(GoodsInfo)this.busDao.get(GoodsInfo.class, tradeConfirmDto.getInfoid());//货源信息
				goodsInfo.setT_goods_status(Constants.STATUS_NORMAL);
				goodsInfo.setT_goods_requserid(null);//请求人置空
				goodsInfo.setT_goods_reqtime("");//请求时间置空
				this.busDao.update(goodsInfo);
			}
			
			this.scheduler.unscheduleJob(tradeConfirmDto.getInfoid(), Scheduler.DEFAULT_GROUP);//终止状态检测定时器
			
			result.setSuccess(true);
			result.setMsg("确认成功");
			return;
		}
		//车源
		if(infotype==Constants.INFO_C){
			//如果交易成功
			if(tradeflag==Constants.TRADE_FLAG_SUCCESS){
				CarInfo carInfo=(CarInfo)this.busDao.get(CarInfo.class, tradeConfirmDto.getInfoid());//车源信息
				User user=(User)this.busDao.get(User.class, tradeConfirmDto.getRequserid());//请求人（货主）
				/*String csp=StringUtil.nullToStr(carInfo.getT_car_startp());
				String csc=StringUtil.nullToStr(carInfo.getT_car_startc());
				String csd=StringUtil.nullToStr(carInfo.getT_car_startd());
				
				String cep=StringUtil.nullToStr(carInfo.getT_car_endp());
				String cec=StringUtil.nullToStr(carInfo.getT_car_endc());
				String ced=StringUtil.nullToStr(carInfo.getT_car_endd());
				
				//修改请求货主发布的对应路线的货源状态为下架
				List<GoodsInfo> list=user.getGoodsList();
				if(list!=null && list.size()>0){
					for(int i=0,len=list.size();i<len;i++){
						GoodsInfo goodsInfo=list.get(i);
						String gsp=StringUtil.nullToStr(goodsInfo.getT_goods_startp());
						String gsc=StringUtil.nullToStr(goodsInfo.getT_goods_startc());
						String gsd=StringUtil.nullToStr(goodsInfo.getT_goods_startd());
						
						String gep=StringUtil.nullToStr(goodsInfo.getT_goods_endp());
						String gec=StringUtil.nullToStr(goodsInfo.getT_goods_endc());
						String ged=StringUtil.nullToStr(goodsInfo.getT_goods_endd());
						
						//如果货主请求的车源出发地和到达地都与货主发布的某个货源信息相同，则下架此货源信息
						if(gsp.equalsIgnoreCase(csp) && gsc.equalsIgnoreCase(csc) && gsd.equalsIgnoreCase(csd) && gep.equalsIgnoreCase(cep) && gec.equalsIgnoreCase(cec) && ged.equalsIgnoreCase(ced)){
							goodsInfo.setT_goods_status(Constants.STATUS_DOWN);
							this.busDao.update(goodsInfo);
						}
					}
				}*/
				
				carInfo.setT_car_requserid(null);//请求人置空
				carInfo.setT_car_reqtime("");//请求时间置空
				this.busDao.update(carInfo);
				
				//插入交易记录
				TradeInfo tradeInfo=new TradeInfo();
				tradeInfo.setT_trade_id(UUIDUtil.getUUID());//id
				tradeInfo.setT_trade_goodsid(tradeConfirmDto.getRequserid());//货主id
				tradeInfo.setT_trade_carid(carInfo.getT_car_userid().getT_user_id());//车主id
				tradeInfo.setT_trade_goodsname(user.getT_user_name());//货主名称
				tradeInfo.setT_trade_carname(carInfo.getT_car_contactsname());//车主名称
				tradeInfo.setT_trade_goodsphone(user.getT_user_phone());//货主手机号码
				tradeInfo.setT_trade_carphone(carInfo.getT_car_contactsphone());//车主手机号码
				tradeInfo.setT_trade_createtime(DateUtil.getCurrentTime4Str());//交易时间
				tradeInfo.setT_trade_type(Constants.TRADE_TYPE_GC);//货主请求车源信息
				this.busDao.insert(tradeInfo);
				
				//给货主增加积分
				user.setT_user_integral(user.getT_user_integral()+Constants.DEFAULT_TRADE_GC);
				this.busDao.update(user);
			}
			
			//如果交易失败
			if(tradeflag==Constants.TRADE_FLAG_FAIL){
				CarInfo carInfo=(CarInfo)this.busDao.get(CarInfo.class, tradeConfirmDto.getInfoid());//车源信息
				
				carInfo.setT_car_requserid(null);//请求人置空
				carInfo.setT_car_reqtime("");//请求时间置空
				this.busDao.update(carInfo);
			}
			
			result.setSuccess(true);
			result.setMsg("确认成功");
			return;
		}
	}

	/**
	 * 查询交易记录
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void qryTradeRecord(QryTradeRecordDto qryTradeRecordDto, Result result) {
		// TODO Auto-generated method stub
		int usertype=qryTradeRecordDto.getUsertype();
		StringBuilder sb=new StringBuilder();
		
		if(usertype==Constants.USER_GE || usertype==Constants.USER_GP){//货主
			sb.append("from TradeInfo t where t.t_trade_goodsid='"+qryTradeRecordDto.getUserid()+"'");
		}else if(usertype==Constants.USER_CP){//车主
			sb.append("from TradeInfo t where t.t_trade_carid='"+qryTradeRecordDto.getUserid()+"'");
		}else if(usertype==Constants.USER_CE){//货运部
			sb.append("from TradeInfo t where t.t_trade_goodsid='"+qryTradeRecordDto.getUserid()+"' or t.t_trade_carid='"+qryTradeRecordDto.getUserid()+"'");
		}else{
			result.setSuccess(false);
			result.setMsg("用户类型不正确");
			return;
		}
		sb.append(" order by t.t_trade_createtime desc");
		
		List<TradeInfo> list=(List<TradeInfo>)this.busDao.findByHql(sb.toString(), (qryTradeRecordDto.getCurrentpage()-1)*qryTradeRecordDto.getPagesize(), qryTradeRecordDto.getPagesize());
		List<Object> listData=new ArrayList<Object>();
		if(list!=null && list.size()>0){
			for(int i=0,len=list.size();i<len;i++){
				Map<Object,Object> mapData=new HashMap<Object,Object>();
				if(usertype==Constants.USER_GE || usertype==Constants.USER_GP){//货主
					mapData.put("tradeobjphone", StringUtil.replaceStr(list.get(i).getT_trade_carphone(), 3, 7, "****"));//交易对象phone
				}else if(usertype==Constants.USER_CP){//车主
					mapData.put("tradeobjphone", StringUtil.replaceStr(list.get(i).getT_trade_goodsphone(), 3, 7, "****"));//交易对象phone
				}else if(usertype==Constants.USER_CE){
					if(qryTradeRecordDto.getUserid().equals(list.get(i).getT_trade_goodsid())){//如果货运部是货主
						mapData.put("tradeobjphone", StringUtil.replaceStr(list.get(i).getT_trade_carphone(), 3, 7, "****"));//交易对象phone
					}else if(qryTradeRecordDto.getUserid().equals(list.get(i).getT_trade_carid())){//如果货运部是车主
						mapData.put("tradeobjphone", StringUtil.replaceStr(list.get(i).getT_trade_goodsphone(), 3, 7, "****"));//交易对象phone
					}else{
					}
				}else{
					result.setSuccess(false);
					result.setMsg("用户类型不正确");
					return;
				}
				mapData.put("tradetype", list.get(i).getT_trade_type());//交易类型
				mapData.put("tradetime", list.get(i).getT_trade_createtime());//交易时间
				listData.add(mapData);
			}
		}
		
		//查询成功
		result.setSuccess(true);
		result.setMsg("查询成功");
		result.getData().put("list", listData);
		return;
	}

	/**
	 * 查询评分列表（货主）
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void qryMarkList(QryMarkListDto qryMarkListDto, Result result) {
		// TODO Auto-generated method stub
		int usertype=qryMarkListDto.getUsertype();
		StringBuilder sb=new StringBuilder();
		
		//货主、货运部
		if(usertype==Constants.USER_GE || usertype==Constants.USER_GP || usertype==Constants.USER_CE){//货主
			sb.append("from TradeInfo t where t.t_trade_goodsid=?");
			
			//查询类型
			if(qryMarkListDto.getQrytype()==null || qryMarkListDto.getQrytype()==Constants.QRYMARK_ALL){//所有
				
			}else if(qryMarkListDto.getQrytype()==Constants.QRYMARK_ALREADY){//已评分
				sb.append(" and t.t_trade_ismark_gc="+Constants.MARK_ALREADY);
			}else if(qryMarkListDto.getQrytype()==Constants.QRYMARK_NOT){//未评分
				sb.append(" and t.t_trade_ismark_gc="+Constants.MARK_NOT);
			}else{
			}
		}else{
			result.setSuccess(false);
			result.setMsg("用户类型不正确");
			return;
		}
		
		sb.append(" order by t.t_trade_createtime desc");
		
		List<TradeInfo> list=(List<TradeInfo>)this.busDao.findByHql(sb.toString(), (qryMarkListDto.getCurrentpage()-1)*qryMarkListDto.getPagesize(), qryMarkListDto.getPagesize(), qryMarkListDto.getUserid());
		
		List<Object> listData=new ArrayList<Object>();
		if(list!=null && list.size()>0){
			for(int i=0,len=list.size();i<len;i++){
				Map<Object,Object> mapData=new HashMap<Object,Object>();
				mapData.put("tradeobjphone", StringUtil.replaceStr(list.get(i).getT_trade_carphone(), 3, 7, "****"));//交易对象phone
				String tradeobjname="司机";
				mapData.put("tradeobjname", tradeobjname);//交易对象name
				mapData.put("score", list.get(i).getT_trade_score_gc());//分值
				mapData.put("ismark", list.get(i).getT_trade_ismark_gc());//是否已评分
				mapData.put("tradetype", list.get(i).getT_trade_type());//交易类型
				mapData.put("tradetime", list.get(i).getT_trade_createtime());//交易时间
				mapData.put("tradeinfoid", list.get(i).getT_trade_id());//id
				mapData.put("goodserid", list.get(i).getT_trade_goodsid());//货主id
				mapData.put("carerid", list.get(i).getT_trade_carid());//车主id
				listData.add(mapData);
			}
		}
		
		//查询成功
		result.setSuccess(true);
		result.setMsg("查询成功");
		result.getData().put("list", listData);
		return;
	}

	/**
	 * 评分（货主）
	 */
	@Override
	public void mark(MarkDto markDto, Result result) {
		// TODO Auto-generated method stub
		StringBuilder sb=new StringBuilder();
		StringBuilder sb2=new StringBuilder();
		
		//修改交易记录评分状态
		if(markDto.getUsertype()==Constants.USER_GE || markDto.getUsertype()==Constants.USER_GP || markDto.getUsertype()==Constants.USER_CE){//货主、货运部
			sb.append("update TradeInfo t set t.t_trade_ismark_gc=?,t.t_trade_marktime=?,t_trade_score_gc=? where t.t_trade_id=?");
		}else{
			result.setSuccess(false);
			result.setMsg("用户类型不正确");
			return;
		}
		this.busDao.updateByHql(sb.toString(), Constants.MARK_ALREADY,DateUtil.getCurrentTime4Str(),markDto.getScore(),markDto.getTradeid());
		
		//累计积分，平均信誉值
		User carer=(User)this.busDao.get(User.class, markDto.getCarerid());
		double creditrating=(carer.getT_user_creditrating()+markDto.getScore())/(((carer.getT_user_markcount()==null)?0:carer.getT_user_markcount())+1);
		carer.setT_user_creditrating(creditrating);
		carer.setT_user_integral(carer.getT_user_integral()+markDto.getScore()*Constants.DEFAULT_STAR_SCORE);
		carer.setT_user_markcount(((carer.getT_user_markcount()==null)?0:carer.getT_user_markcount())+1);
		this.busDao.update(carer);
		
		//货主修改积分
		sb2.append("update User u set u.t_user_integral=u.t_user_integral + ? where u.t_user_id=?");
		this.busDao.updateByHql(sb2.toString(), Constants.DEFAULT_MARK_GC,markDto.getGoodserid());
		
		//评分成功
		result.setSuccess(true);
		result.setMsg("评分成功");
		result.getData().put("tradeid", markDto.getTradeid());
		result.getData().put("score",markDto.getScore().toString());
		return;
	}

	/**
	 * 查询我的得分记录（车主）
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void qryMyMark(QryMyMarkDto qryMyMarkDto, Result result) {
		// TODO Auto-generated method stub
		int averagescore=0;
		int usertype=qryMyMarkDto.getUsertype();
		
		//查询车主得分列表
		StringBuilder sb=new StringBuilder();
		if(usertype==Constants.USER_CE || usertype==Constants.USER_CP){//车主或者货运部
			sb.append("from TradeInfo t where t.t_trade_carid=? and t.t_trade_ismark_gc=? order by t.t_trade_marktime desc");
		}else{
			result.setSuccess(false);
			result.setMsg("用户类型不正确");
			return;
		}
		
		List<TradeInfo> list=(List<TradeInfo>)this.busDao.findByHql(sb.toString(), (qryMyMarkDto.getCurrentpage()-1)*qryMyMarkDto.getPagesize(), qryMyMarkDto.getPagesize(), qryMyMarkDto.getUserid(),Constants.MARK_ALREADY);
		
		List<Object> listData=new ArrayList<Object>();
		if(list!=null && list.size()>0){
			for(int i=0,len=list.size();i<len;i++){
				Map<Object,Object> mapData=new HashMap<Object,Object>();
				String tradeobjname="货主";
				mapData.put("tradeobjname",tradeobjname);//交易对象name
				mapData.put("tradeobjphone",StringUtil.replaceStr(list.get(i).getT_trade_goodsphone(), 3, 7, "****"));//交易对象phone
				mapData.put("score", list.get(i).getT_trade_score_gc());//分值
				listData.add(mapData);
			}
		}
		
		/**
		 * 计算平均评星
		 */
		User user=(User)this.busDao.get(User.class,qryMyMarkDto.getUserid());
		double creditrating=user.getT_user_creditrating();
		int markcount=user.getT_user_markcount();
		if(markcount==0){
			averagescore=0;
		}else{
			averagescore=(int)Math.round(creditrating);
		}
		
		//查询成功
		result.setSuccess(true);
		result.setMsg("查询成功");
		result.getData().put("averagescore",averagescore);
		result.getData().put("list", listData);
		return;
	}

	/**
	 * 查询待确认交易列表(只有货主有)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void qryBacklog(QryBacklogDto qryBacklogDto, Result result) {
		// TODO Auto-generated method stub
		String userid=qryBacklogDto.getUserid();
		StringBuilder sb=new StringBuilder();
		
		//货主、货运部
		if(qryBacklogDto.getUsertype()==Constants.USER_GE || qryBacklogDto.getUsertype()==Constants.USER_GP || qryBacklogDto.getUsertype()==Constants.USER_CE){
			sb.append("select gc.id,gc.type,gc.requserid,gc.reqtime,gc.contactsphone,gc.userid from goods_carview gc where ((gc.userid=? and gc.status=?) or (gc.requserid=? and (gc.status=? or gc.status=?))) and gc.isabled=? order by gc.reqtime desc");
			List<Object[]> list=(List<Object[]>)this.busDao.findBySql(sb.toString(), (qryBacklogDto.getCurrentpage()-1)*qryBacklogDto.getPagesize(), qryBacklogDto.getPagesize(),userid,Constants.STATUS_LOCK,userid,Constants.STATUS_LOCK,Constants.STATUS_NORMAL,Constants.ABLE_YES);
			
			List<Object> listData=new ArrayList<Object>();
			if(list!=null && list.size()>0){
				for(int i=0,len=list.size();i<len;i++){
					Map<Object,Object> mapData=new HashMap<Object,Object>();
					int infotype=Integer.valueOf((String)list.get(i)[1]);
					String phone="";
					//货源信息
					if(infotype==Constants.INFO_G){
						String requserid=(String)list.get(i)[2];//请求用户id（车主）
						User user=(User)this.busDao.get(User.class,requserid);
						phone=StringUtil.replaceStr(user.getT_user_phone(),3,7,"****");
						mapData.put("info", "司机("+phone+")联系了您,是否完成了交易?");
						mapData.put("info1", "请您确认与用户"+phone+"的交易，谢谢");
						mapData.put("requserid", requserid);
					}
					//车源信息
					if(infotype==Constants.INFO_C){
						phone=StringUtil.replaceStr((String)list.get(i)[4],3,7,"****");
						mapData.put("info", "您联系了司机("+phone+"),是否完成了交易?");
						mapData.put("info1", "请您确认与用户"+phone+"的交易，谢谢");
						mapData.put("requserid", userid);
					}
					mapData.put("infoid", list.get(i)[0]);
					mapData.put("infotype", infotype);
					mapData.put("reqtime", list.get(i)[3]);
					mapData.put("requsername", "司机");
					mapData.put("requserphone", phone);
					listData.add(mapData);
				}
			}
			result.setSuccess(true);
			result.setMsg("查询成功");
			result.getData().put("list", listData);
			return;
		
		}else{
			result.setSuccess(false);
			result.setMsg("用户类型不正确");
			return;
		}
	}
	
	/**
	 * 查询未评分记录数(货主)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void qryUnMarkNum(String userid,Integer usertype, Result result) {
		// TODO Auto-generated method stub
		int count=0;
		StringBuilder sb=new StringBuilder();
		
		//货主货主货运部
		if(usertype==Constants.USER_GE || usertype==Constants.USER_GP || usertype==Constants.USER_CE){//货主
			sb.append("from TradeInfo t where t.t_trade_goodsid=? and t.t_trade_ismark_gc=?");
		}else{
			result.setSuccess(false);
			result.setMsg("用户类型不正确");
			return;
		}
		
		List<TradeInfo> list=(List<TradeInfo>)this.busDao.findByHql(sb.toString(),userid,Constants.MARK_NOT);
		if(list!=null && list.size()>0){
			count=list.size();
		}
		
		//查询成功
		result.setSuccess(true);
		result.setMsg("查询成功");
		result.getData().put("count", count);
		return;
	}
	
}
