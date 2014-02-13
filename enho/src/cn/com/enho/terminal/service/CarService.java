package cn.com.enho.terminal.service;

import java.util.List;

import cn.com.enho.base.service.BaseService;
import cn.com.enho.comm.Result;
import cn.com.enho.terminal.dto.PubCarDto;
import cn.com.enho.terminal.dto.QryCarList4NearDto;
import cn.com.enho.terminal.dto.QryCarListDto;
import cn.com.enho.terminal.dto.UpdateCarDto;

/**
 * 		车源信息Service接口
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-9 上午11:30:43
 */
public interface CarService extends BaseService{

	public void addCar(PubCarDto pubCarDto,Result result);//发布车源信息
	public List<String> qryPhone4SendMsg(QryCarListDto qryCarListDto);//查询需要发送短信的手机号码
	public void qryCarList(QryCarListDto qryCarListDto,Result result);//查询车源信息列表
	public void qryCarDtl(String carid,String baseurl,Result result);//查询车源信息详情
	public void updateCar(UpdateCarDto updateCarDto,Result result);//修改车源信息
	public void deleteCar(String carid,String desdir,Result result);//删除车源信息
	public void qryCarList4Near(QryCarList4NearDto qryCarList4NearDto,Result result);//查询附近的车源信息列表
} 
