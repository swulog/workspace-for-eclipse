package com.ivorytower.app.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;

import com.ivorytower.app.entity.Userbaseinfo;
import com.ivorytower.app.service.UserbaseinfoService;

@Service("userbaseinfoService")
public class UserbaseinfoServiceImpl extends BaseServiceImpl implements UserbaseinfoService{

	@Override
	public void addUserbaseinfo(Userbaseinfo userbaseinfo) {
		// TODO Auto-generated method stub
		this.getBaseDao().insert(userbaseinfo);
	}

	@Override
	public Userbaseinfo getUserbaseinfoById(int id) {
		// TODO Auto-generated method stub
		return (Userbaseinfo)this.getBaseDao().get(Userbaseinfo.class, id);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Userbaseinfo> findUserbaseinfoByName(String name) {
		// TODO Auto-generated method stub
		String hql="from Userbaseinfo u where u.ubiUsername=?";
		return (List<Userbaseinfo>)this.getBaseDao().findByHql(hql, name);
	}


}
