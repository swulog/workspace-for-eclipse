package com.ivorytower.app.service;

import com.ivorytower.app.dto.LoginDto;
import com.ivorytower.app.dto.LogoutDto;
import com.ivorytower.app.dto.ModifyUserInfoDto;
import com.ivorytower.app.dto.QryOnlineUsersListDto;
import com.ivorytower.app.dto.QryPersonalMoreInfoDto;
import com.ivorytower.app.dto.QryUserInfoDto;
import com.ivorytower.app.dto.RegisterDto;
import com.ivorytower.comm.Result;

public interface UserService extends BaseService {
	
	public void queryOnlineUsersList(QryOnlineUsersListDto dto,Result result);
	
	public void register(RegisterDto dto,Result result);
	public void modifyUserInfo(ModifyUserInfoDto dto,Result result);
	
	public void login(LoginDto dto,Result result);
	public void logout(LogoutDto dto,Result result);
	
	public void queryPersonalMoreInfo(QryPersonalMoreInfoDto dto,Result result);
	public void queryUserInfo(QryUserInfoDto dto,Result result);
	
}
