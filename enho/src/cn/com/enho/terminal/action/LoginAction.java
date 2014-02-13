package cn.com.enho.terminal.action;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.com.enho.comm.Result;
import cn.com.enho.terminal.dto.LoginDto;
import cn.com.enho.terminal.service.UserService;


/**
 * 		用户登录
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-8 上午10:14:54
 */
@Controller
@RequestMapping("/comm")
public class LoginAction {
	
	@Autowired
	private UserService userService;
	
	static Logger logger = Logger.getLogger(LoginAction.class.getName());

	/**
	 * 注册
	 * @param registDto
	 * @return
	 */
	@RequestMapping(value="/login")
	@ResponseBody 
	public Result login(HttpServletRequest request,LoginDto loginDto){
		logger.debug("*********************************************登录	start*********************************************");
		
		Result result=new Result();
		try{
			//表单验证
			validParam(loginDto,result);
			//验证成功
			if(result.getSuccess()){
				String baseurl=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+ request.getContextPath();
				loginDto.setBaseurl(baseurl);
				this.userService.login(loginDto,result);
			}else{//验证失败
			}
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("登陆出现异常");
			return result;
		}
		
	}
	
	//表单验证
	public void validParam(LoginDto loginDto,Result result){
		if(StringUtils.isEmpty(loginDto.getPhoneno())){
			result.setSuccess(false);
			result.setMsg("手机号不能为空");
			return;
		}else if(StringUtils.isEmpty(loginDto.getUserpwd())){
			result.setSuccess(false);
			result.setMsg("用户密码不能为空");
			return;
		}else{
			result.setSuccess(true);
			result.setMsg("验证成功");
			return;
		}
	}
}
