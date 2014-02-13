package cn.com.enho.terminal.action;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.com.enho.comm.Result;
import cn.com.enho.terminal.service.UserService;

/**
 * 		查询用户详情
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-14 上午10:22:33
 */
@Controller
@RequestMapping("/terminal")
public class QryUserDtlAction {

	@Autowired
	private UserService userService;
	
	static Logger logger = Logger.getLogger(QryUserDtlAction.class.getName());
	
	
	@RequestMapping(value="/qryUserDtl")
	@ResponseBody 
	public Result qryUserDtl(HttpServletRequest request,@RequestParam String userid){
		logger.debug("*********************************************查询用户详细信息	start*********************************************");
		
		Result result=new Result();
		try{
			//表单验证
			validParam(userid,result);
			//验证成功
			if(result.getSuccess()){
				String baseurl=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+ request.getContextPath();
				this.userService.qryUserDtl(userid.trim(),baseurl,result);
			}else{//验证失败
			}
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("查询异常");
			return result;
		}
		
	}
	
	//表单验证
	public void validParam(String userid,Result result){
		if(StringUtils.isEmpty(userid)){
			result.setSuccess(false);
			result.setMsg("用户id不能为空");
			return;
		}else{
			result.setSuccess(true);
			result.setMsg("验证成功");
			return;
		}
	}
}
