package com.university.dao.impl;

import com.university.dao.IBaseDAO;
import com.university.dao.IUserDao;
import com.university.model.UserBaseInfo;
import com.university.model.UserExpandInfo;

public class UserDaoImpl implements IUserDao {
	
	private IBaseDAO dao;	
	private String hql;
	
	public IBaseDAO getDao() {
		return dao;
	}

	public void setDao(IBaseDAO dao) {
		this.dao = dao;
	}

	@Override
	public boolean addUser(UserBaseInfo ubi) {
		// TODO Auto-generated method stub
		dao.save(ubi);
		return true;
	}

	@Override
	public boolean deleteUser(UserBaseInfo ubi) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean ModifyUser(UserBaseInfo ubi) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean getUser(UserBaseInfo ubi) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean addUserExpand(UserExpandInfo uei) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean deleteUserExpand(UserExpandInfo uei) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean ModifyUserExpand(UserExpandInfo uei) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean getUserExpand(UserExpandInfo uei) {
		// TODO Auto-generated method stub
		return false;
	}

}
