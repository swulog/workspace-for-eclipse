package cn.com.enho.terminal.service;

import cn.com.enho.base.service.BaseService;
import cn.com.enho.comm.Result;
import cn.com.enho.terminal.dto.QryFocusUserListDto;

/**
 * 		关注用户Service接口
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-15 上午11:21:00
 */
public interface FocusService extends BaseService{

	public void addFocusrelation(String userid1,String userid2,Result result);//添加关注关系
	public void qryFocusUserList(QryFocusUserListDto qryFocusUserListDto,Result result);//添加关注关系
	public void deleteFocusUser(String focuseid,Result result);//删除已关注用户
}
