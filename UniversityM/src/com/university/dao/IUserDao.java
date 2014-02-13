package com.university.dao;

import com.university.model.UserBaseInfo;
import com.university.model.UserExpandInfo;


/**
 * 用户Dao
 * 用户类信息接口
 */
public interface IUserDao {
	
	/**
	 * 基本信息表
	 * @param su
	 * @return
	 */
	public boolean addUser(UserBaseInfo ubi);
	public boolean deleteUser(UserBaseInfo ubi);
	public boolean ModifyUser(UserBaseInfo ubi);
	public boolean getUser(UserBaseInfo ubi);
	
	/**
	 * 扩展信息表
	 * @param su
	 * @return
	 */
	public boolean addUserExpand(UserExpandInfo uei);
	public boolean deleteUserExpand(UserExpandInfo uei);
	public boolean ModifyUserExpand(UserExpandInfo uei);
	public boolean getUserExpand(UserExpandInfo uei);
	

}