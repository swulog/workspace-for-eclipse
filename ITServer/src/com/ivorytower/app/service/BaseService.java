package com.ivorytower.app.service;

import com.ivorytower.app.dao.BaseDao;




/**
 * 		通用service接口
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-7 下午5:04:49
 */
public interface BaseService extends Service{

	public BaseDao getBaseDao();
}
