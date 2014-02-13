package cn.com.enho.terminal.action;

import javax.servlet.ServletContext;
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
 * 		短信验证码相关操作
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-15 下午4:51:28
 */
@Controller
@RequestMapping("/comm")
public class VerificationcodeAction {

	@Autowired
	private UserService userService;
	
	static Logger logger = Logger.getLogger(VerificationcodeAction.class.getName());
	
	/**
	 * 注册获取短信验证码
	 * @param request
	 * @param phoneno
	 * @return
	 */
	@RequestMapping(value="/getVerificationcode4Regist")
	@ResponseBody 
	public Result getVerificationcode4Regist(HttpServletRequest request,@RequestParam String phoneno){
		logger.debug("*********************************************获取短信验证码（注册）	start*********************************************");
		
		Result result=new Result();
		try{
			//表单验证
			validParam(phoneno,result);
			//验证成功
			if(result.getSuccess()){
				ServletContext servletContext=request.getServletContext();
				String sms_url_utf8=servletContext.getAttribute("sms_url_utf8")==null?"":servletContext.getAttribute("sms_url_utf8").toString();
				String sms_url_gbk=servletContext.getAttribute("sms_url_gbk")==null?"":servletContext.getAttribute("sms_url_gbk").toString();
				String sms_username=servletContext.getAttribute("sms_username")==null?"":servletContext.getAttribute("sms_username").toString();
				String sms_password=servletContext.getAttribute("sms_password")==null?"":servletContext.getAttribute("sms_password").toString();
				this.userService.getVerificationcode4Regist(sms_username,sms_password,sms_url_utf8,sms_url_gbk,phoneno.trim(),result);
			}else{//验证失败
			}
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("短信验证码获取异常");
			return result;
		}
		
	}
	
	/**
	 * 找回密码获取短信验证码
	 * @param request
	 * @param phoneno
	 * @return
	 */
	@RequestMapping(value="/getVerificationcode4Pwd")
	@ResponseBody 
	public Result getVerificationcode4Pwd(HttpServletRequest request,@RequestParam String phoneno){
		logger.debug("*********************************************获取短信验证码（找回密码）	start*********************************************");
		
		Result result=new Result();
		try{
			//表单验证
			validParam(phoneno,result);
			//验证成功
			if(result.getSuccess()){
				ServletContext servletContext=request.getServletContext();
				String sms_url_utf8=servletContext.getAttribute("sms_url_utf8")==null?"":servletContext.getAttribute("sms_url_utf8").toString();
				String sms_url_gbk=servletContext.getAttribute("sms_url_gbk")==null?"":servletContext.getAttribute("sms_url_gbk").toString();
				String sms_username=servletContext.getAttribute("sms_username")==null?"":servletContext.getAttribute("sms_username").toString();
				String sms_password=servletContext.getAttribute("sms_password")==null?"":servletContext.getAttribute("sms_password").toString();
				this.userService.getVerificationcode4Pwd(sms_username,sms_password,sms_url_utf8,sms_url_gbk,phoneno.trim(),result);
			}else{//验证失败
			}
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("短信验证码获取异常");
			return result;
		}
		
	}
	
	//表单验证
	public void validParam(String phoneno,Result result){
		if(StringUtils.isEmpty(phoneno)){
			result.setSuccess(false);
			result.setMsg("手机号码不能为空");
			return;
		}else{
			result.setSuccess(true);
			result.setMsg("验证成功");
			return;
		}
	}
}
