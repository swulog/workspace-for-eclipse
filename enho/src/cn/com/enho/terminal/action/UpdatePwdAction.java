package cn.com.enho.terminal.action;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.com.enho.comm.Result;
import cn.com.enho.terminal.dto.UpdatePwdDto;
import cn.com.enho.terminal.service.UserService;

/**
 * 		修改密码
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-25 下午3:59:57
 */
@Controller
@RequestMapping("/terminal")
public class UpdatePwdAction {

	@Autowired
	private UserService userService;
	
	static Logger logger = Logger.getLogger(UpdatePwdAction.class.getName());
	
	
	@RequestMapping(value="/updatePwd")
	@ResponseBody 
	public Result updatePwd(UpdatePwdDto updatePwdDto){
		logger.debug("*********************************************修改密码   start*********************************************");
		
		Result result=new Result();
		try{
			//表单验证
			validParam(updatePwdDto,result);
			//验证成功
			if(result.getSuccess()){
				this.userService.updatePwd(updatePwdDto,result);
			}else{//验证失败
			}
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("用户信息修改异常");
			return result;
		}
		
	}
	
	//表单验证
	public void validParam(UpdatePwdDto updatePwdDto,Result result){
		if(StringUtils.isEmpty(updatePwdDto.getUserid())){
			result.setSuccess(false);
			result.setMsg("用户id不能为空");
			return;
		}else if(StringUtils.isEmpty(updatePwdDto.getUseroldpwd())){
			result.setSuccess(false);
			result.setMsg("旧密码不能为空");
			return;
		}else if(StringUtils.isEmpty(updatePwdDto.getUsernewpwd())){
			result.setSuccess(false);
			result.setMsg("新密码不能为空");
			return;
		}else if(StringUtils.isEmpty(updatePwdDto.getConfirmpwd())){
			result.setSuccess(false);
			result.setMsg("确认密码不能为空");
			return;
		}else if(!updatePwdDto.getConfirmpwd().equals(updatePwdDto.getUsernewpwd())){
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
