package cn.com.enho.terminal.action;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.com.enho.comm.Result;
import cn.com.enho.terminal.dto.ForgetPwdDto;
import cn.com.enho.terminal.service.UserService;

/**
 * 		找回密码
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-16 下午4:34:18
 */
@Controller
@RequestMapping("/comm")
public class ForgetPwdAction {

	@Autowired
	private UserService userService;
	
	static Logger logger = Logger.getLogger(ForgetPwdAction.class.getName());
	
	
	@RequestMapping(value="/forgetPwd")
	@ResponseBody 
	public Result forgetPwd(HttpServletRequest request,ForgetPwdDto forgetPwdDto){
		logger.debug("*********************************************找回密码	start*********************************************");
		
		Result result=new Result();
		try{
			//表单验证
			validParam(forgetPwdDto,result);
			//验证成功
			if(result.getSuccess()){
				//String sms_url=request.getAttribute("sms_url")==null?"":request.getAttribute("sms_url").toString();
				//String sms_username=request.getAttribute("sms_username")==null?"":request.getAttribute("sms_username").toString();
				//String sms_password=request.getAttribute("sms_password")==null?"":request.getAttribute("sms_password").toString();
				//this.userService.forgetPwd(sms_username,sms_password,sms_url,forgetPwdDto,result);
				this.userService.forgetPwd(forgetPwdDto,result);
			}else{//验证失败
			}
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("找回密码出现异常");
			return result;
		}
		
	}
	
	//表单验证
	public void validParam(ForgetPwdDto forgetPwdDto,Result result){
		if(StringUtils.isEmpty(forgetPwdDto.getPhoneno())){
			result.setSuccess(false);
			result.setMsg("手机号码不能为空");
			return;
		}else if(StringUtils.isEmpty(forgetPwdDto.getVerificationcode())){
			result.setSuccess(false);
			result.setMsg("短信验证码不能为空");
			return;
		}else if(StringUtils.isEmpty(forgetPwdDto.getNewpwd())){
			result.setSuccess(false);
			result.setMsg("密码不能为空");
			return;
		}else if(StringUtils.isEmpty(forgetPwdDto.getConfirmpwd())){
			result.setSuccess(false);
			result.setMsg("确认密码不能为空");
			return;
		}else if(!forgetPwdDto.getNewpwd().equals(forgetPwdDto.getConfirmpwd())){
			result.setSuccess(false);
			result.setMsg("密码不一致");
			return;
		}else{
			result.setSuccess(true);
			result.setMsg("验证成功");
			return;
		}
	}
}
