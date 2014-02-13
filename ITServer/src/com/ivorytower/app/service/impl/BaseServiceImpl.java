package com.ivorytower.app.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ivorytower.app.dao.BaseDao;
import com.ivorytower.app.service.BaseService;

/**
 * 		通用service实现类
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-7 下午5:06:14
 */
@Service("baseService")
public class BaseServiceImpl implements BaseService{

	@Autowired
	private BaseDao baseDao;

	public BaseDao getBaseDao() {
		return baseDao;
	}

}
