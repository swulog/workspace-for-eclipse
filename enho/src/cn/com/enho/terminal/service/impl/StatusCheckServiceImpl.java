package cn.com.enho.terminal.service.impl;

import java.io.Serializable;

import org.springframework.beans.factory.annotation.Autowired;

import cn.com.enho.base.service.impl.BaseServiceImpl;
import cn.com.enho.comm.constants.Constants;
import cn.com.enho.terminal.dao.StatusCheckDao;
import cn.com.enho.terminal.entity.CarInfo;
import cn.com.enho.terminal.entity.GoodsInfo;
import cn.com.enho.terminal.service.StatusCheckService;

/**
 * 		状态检测服务
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-23 上午10:15:25
 */
public class StatusCheckServiceImpl extends BaseServiceImpl implements StatusCheckService,Serializable{

	@Autowired
	private  StatusCheckDao checkServiceDao;
	
	private static final long serialVersionUID = 1L;

	/**
	 * 信息状态检测（默认处理--如果状态为锁定，则修改为下架）
	 */
	public void check(String infoid, int infotype) {
		// TODO Auto-generated method stub
		//如果是货源信息
		if(infotype==Constants.INFO_G){
			GoodsInfo goodsInfo=(GoodsInfo)this.checkServiceDao.get(GoodsInfo.class, infoid);
			if(goodsInfo!=null){
				int status=goodsInfo.getT_goods_status();
				if(status==Constants.STATUS_LOCK){
					goodsInfo.setT_goods_status(Constants.STATUS_DOWN);
					this.checkServiceDao.update(goodsInfo);
					return;
				}
			}
		}
		//如果是车源信息
		if(infotype==Constants.INFO_C){
			CarInfo carInfo=(CarInfo)this.checkServiceDao.get(CarInfo.class, infoid);
			if(carInfo!=null){
				int status=carInfo.getT_car_status();
				if(status==Constants.STATUS_LOCK){
					carInfo.setT_car_status(Constants.STATUS_DOWN);
					this.checkServiceDao.update(carInfo);
					return;
				}
			}
		}
	}

}
