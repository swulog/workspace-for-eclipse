package com.university.action;


import com.opensymphony.xwork2.ActionSupport;
import com.university.dao.ISysUserDao;
import com.university.model.SysUser;
import com.university.utils.BaseUtils;

public class SysUserAction extends ActionSupport{

	private SysUser sysuser;
	private ISysUserDao sysUserDao;	
	
	/**
	 * 登录的方法
	 * @return
	 */
	public String loginSysUser(){
		if(BaseUtils.isEmptyOrNull(sysuser.getUserName())&&BaseUtils.isEmptyOrNull(sysuser.getPassWord())){
			boolean result = sysUserDao.Ilogin(sysuser);
			if(result){
				return "login_success";
			}else{
				return "login_failure";
			}			
		}else{
			return "login_failure";
		}
	}

	public SysUser getSysuser() {
		return sysuser;
	}

	public void setSysuser(SysUser sysuser) {
		this.sysuser = sysuser;
	}

	public ISysUserDao getSysUserDao() {
		return sysUserDao;
	}

	public void setSysUserDao(ISysUserDao sysUserDao) {
		this.sysUserDao = sysUserDao;
	}
}
