package cn.com.enho.base.service.impl;

import cn.com.enho.base.dao.BaseDao;
import cn.com.enho.base.service.BaseService;

/**
 * 		通用service实现类
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-7 下午5:06:14
 */
public class BaseServiceImpl implements BaseService{

	private BaseDao baseDao;

	public BaseDao getBaseDao() {
		return baseDao;
	}

	public void setBaseDao(BaseDao baseDao) {
		this.baseDao = baseDao;
	}
}
