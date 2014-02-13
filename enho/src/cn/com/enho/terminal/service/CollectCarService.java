package cn.com.enho.terminal.service;

import cn.com.enho.base.service.BaseService;
import cn.com.enho.comm.Result;
import cn.com.enho.terminal.dto.QryCollectCarListDto;

/**
 * 		车源信息收藏Service接口
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-15 下午2:58:14
 */
public interface CollectCarService extends BaseService{

	public void addCollectCar(String userid,String carid,Result result);
	public void qryCollectCarList(QryCollectCarListDto qryCollectCarListDto,Result result);
	public void deleteCollectCar(String user_car_collectid,Result result);
}
