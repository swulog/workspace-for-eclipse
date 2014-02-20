package com.ivorytower.app.service.impl;

import org.springframework.stereotype.Service;

import com.ivorytower.app.dto.LoginDto;
import com.ivorytower.app.dto.LogoutDto;
import com.ivorytower.app.dto.ModifyUserInfoDto;
import com.ivorytower.app.dto.QryOnlineUsersListDto;
import com.ivorytower.app.dto.QryPersonalMoreInfoDto;
import com.ivorytower.app.dto.QryUserInfoDto;
import com.ivorytower.app.dto.RegisterDto;
import com.ivorytower.app.service.UserService;
import com.ivorytower.comm.Result;

@Service("userserivce")
public class UserServiceImpl extends BaseServiceImpl implements UserService {

	@Override
	public void queryOnlineUsersList(QryOnlineUsersListDto dto, Result result) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void register(RegisterDto dto, Result result) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void modifyUserInfo(ModifyUserInfoDto dto, Result result) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void login(LoginDto dto, Result result) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void logout(LogoutDto dto, Result result) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void queryPersonalMoreInfo(QryPersonalMoreInfoDto dto, Result result) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void queryUserInfo(QryUserInfoDto dto, Result result) {
		// TODO Auto-generated method stub
		
	}

}
