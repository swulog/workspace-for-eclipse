package cn.com.enho.terminal.service;

import java.util.List;

import cn.com.enho.base.service.BaseService;
import cn.com.enho.comm.Result;
import cn.com.enho.terminal.dto.ForgetPwdDto;
import cn.com.enho.terminal.dto.LoginDto;
import cn.com.enho.terminal.dto.QryUserList4NearDto;
import cn.com.enho.terminal.dto.QryUserListDto;
import cn.com.enho.terminal.dto.RegistDto;
import cn.com.enho.terminal.dto.UpdatePwdDto;
import cn.com.enho.terminal.dto.UpdateUserDto;
import cn.com.enho.terminal.entity.User;

/**
 * 		用户信息Service接口
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-7 下午4:55:21
 */
public interface UserService extends BaseService{
	public boolean getVerificationcode(String username,String password,String smsurl_utf8,String smsurl_gbk,String phoneno,Result result);
	public void getVerificationcode4Regist(String username,String password,String smsurl_utf8,String smsurl_gbk,String phoneno,Result result);
	public void regist(RegistDto registDto,Result result);
	public void login(LoginDto loginDto, Result result);
	public void getVerificationcode4Pwd(String username,String password,String smsurl_utf8,String smsurl_gbk,String phoneno,Result result);
	public void forgetPwd(ForgetPwdDto forgetPwdDto,Result result);
	public List<User> qryCUserList4Admin(boolean flag);
	public void qryUserList(QryUserListDto qryUserListDto,Result result);
	public void qryUserList4Near(QryUserList4NearDto qryUserList4NearDto,Result result);
	public void qryUserDtl(String userid,String baseurl,Result result);
	public void updateUser(UpdateUserDto updateUserDto,Result result);
	public void updatePwd(UpdatePwdDto updatePwdDto,Result result);
}
