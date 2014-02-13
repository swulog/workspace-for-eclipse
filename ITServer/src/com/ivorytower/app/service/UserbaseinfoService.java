package com.ivorytower.app.service;

import java.util.List;

import com.ivorytower.app.entity.Userbaseinfo;

public interface UserbaseinfoService extends BaseService{

	public void addUserbaseinfo(Userbaseinfo userbaseinfo);
	public Userbaseinfo getUserbaseinfoById(int id);
	public List<Userbaseinfo> findUserbaseinfoByName(String name);
}
