package cn.com.enho.terminal.service;

import java.util.List;

import cn.com.enho.base.service.BaseService;
import cn.com.enho.comm.Result;
import cn.com.enho.mg.entity.AppInfo;
import cn.com.enho.terminal.dto.QryGCList4NearDto;
import cn.com.enho.terminal.dto.QryGCListDto;



/**
 * 		通用service
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-21 下午3:25:30
 */
public interface CommService extends BaseService{

	public void qryAppdoc(Integer type,Result result);
	public void qryGCList4Near(QryGCList4NearDto qryGCList4NearDto,String baseurl,Result result);//查询附近的货源车源信息列表
	public void qryGCList(QryGCListDto qryGCListDto,String baseurl,Result result);//查询货源车源信息列表
	public List<AppInfo> qryApp(String appkey);//查询app路径
}
