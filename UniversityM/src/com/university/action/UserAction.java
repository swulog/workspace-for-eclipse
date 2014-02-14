package com.university.action;

import org.springframework.web.servlet.HttpServletBean;

import com.opensymphony.xwork2.ActionSupport;
import com.university.dao.IUserDao;

public class UserAction extends ActionSupport {
	
	private IUserDao userdao;
	
	
	
	
	public IUserDao getUserdao() {
		return userdao;
	}

	public void setUserdao(IUserDao userdao) {
		this.userdao = userdao;
	}
}
