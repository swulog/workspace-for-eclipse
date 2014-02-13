package cn.com.enho.terminal.action;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.com.enho.comm.Result;
import cn.com.enho.comm.constants.Constants;
import cn.com.enho.terminal.dto.RegistDto;
import cn.com.enho.terminal.service.UserService;

/**
 * 		用户注册
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-8 上午10:14:25
 */
@Controller
@RequestMapping("/comm")
public class RegistAction {

	@Autowired
	private UserService userService;
	
	static Logger logger = Logger.getLogger(RegistAction.class.getName());
	
	/**
	 * 注册
	 * @param registDto
	 * @return
	 */
	@RequestMapping(value="/regist")
	@ResponseBody 
	public Result regist(RegistDto registDto){
		logger.debug("*********************************************注册	start*********************************************");
		
		Result result=new Result();
		try{
			//表单验证
			validParam(registDto,result);
			//验证成功
			if(result.getSuccess()){
				this.userService.regist(registDto,result);
			}else{//验证失败
			}
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("注册出现异常");
			return result;
		}
		
	}
	
	//表单验证
	public void validParam(RegistDto registDto,Result result){
		if(StringUtils.isEmpty(registDto.getPhoneno())){
			result.setSuccess(false);
			result.setMsg("手机号码不能为空");
			return;
		}else if(StringUtils.isEmpty(registDto.getUserpwd())){
			result.setSuccess(false);
			result.setMsg("用户密码不能为空");
			return;
		}else if(registDto.getUserpwd().length()<6 || registDto.getUserpwd().length()>12){
			result.setSuccess(false);
			result.setMsg("用户密码长度应为6-12位");
			return;
		}else if(StringUtils.isEmpty(registDto.getConfirmpwd())){
			result.setSuccess(false);
			result.setMsg("用户确认密码不能为空");
			return;
		}else if(!registDto.getUserpwd().equals(registDto.getConfirmpwd())){
			result.setSuccess(false);
			result.setMsg("两次输入的密码不同");
			return;
		}else if(StringUtils.isEmpty(registDto.getUsertype())){
			result.setSuccess(false);
			result.setMsg("用户类型不能为空");
			return;
		}else if(registDto.getUsertype()!=Constants.USER_GE && registDto.getUsertype()!=Constants.USER_GP && registDto.getUsertype()!=Constants.USER_CE && registDto.getUsertype()!=Constants.USER_CP){
			result.setSuccess(false);
			result.setMsg("用户类型不正确");
			return;
		}else if(StringUtils.isEmpty(registDto.getVerificationcode())){
			result.setSuccess(false);
			result.setMsg("短信验证码不能为空");
			return;
		}else{
			result.setSuccess(true);
			result.setMsg("验证成功");
			return;
		}
	}
}
