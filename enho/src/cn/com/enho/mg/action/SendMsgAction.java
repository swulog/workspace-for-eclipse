package cn.com.enho.mg.action;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.com.enho.comm.MgResult;
import cn.com.enho.comm.util.SMSUtil;
import cn.com.enho.mg.dto.NoticeDto;

/**
 * 		发送短信
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-10-24 下午4:25:57
 */
@Controller
@RequestMapping("/mg")
public class SendMsgAction {

	static Logger logger = Logger.getLogger(SendMsgAction.class.getName());
	
	@RequestMapping(value="/sendMsgPre")
	public ModelAndView sendMsgPre(NoticeDto noticeDto){
		ModelAndView mav=new ModelAndView();
		mav.addObject("gridid",noticeDto.getGridid());
		mav.setViewName("admin/sendmsgpre");
		return mav;
	}
	
	@RequestMapping(value="/sendMsg")
	@ResponseBody 
	public MgResult addApp(HttpServletRequest request,NoticeDto noticeDto){
		logger.debug("*********************************************发送短信	start*********************************************");
		
		MgResult result=new MgResult();
		try{
			//表单验证
			validParam(noticeDto,result);
			//验证成功
			if(result.getSuccess()){
				ServletContext servletContext=request.getServletContext();
				String sms_url_utf8=servletContext.getAttribute("sms_url_utf8")==null?"":servletContext.getAttribute("sms_url_utf8").toString();
				String sms_url_gbk=servletContext.getAttribute("sms_url_gbk")==null?"":servletContext.getAttribute("sms_url_gbk").toString();
				String sms_username=servletContext.getAttribute("sms_username")==null?"":servletContext.getAttribute("sms_username").toString();
				String sms_password=servletContext.getAttribute("sms_password")==null?"":servletContext.getAttribute("sms_password").toString();
				boolean flag=SMSUtil.sendSMS(sms_username,sms_password,sms_url_utf8,sms_url_gbk,noticeDto.getPhonenos(),noticeDto.getMsgcontent());
				if(flag){
					result.setSuccess(true);
					result.setMsg("发送成功");
				}else{
					result.setSuccess(false);
					result.setMsg("发送失败");
				}
				return result;
			}else{//验证失败
			}
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("发送异常");
			return result;
		}
		
	}
	
	//表单验证
	public void validParam(NoticeDto noticeDto,MgResult result){
		if(StringUtils.isEmpty(noticeDto.getPhonenos())){
			result.setSuccess(false);
			result.setMsg("手机号码不能为空");
		}else if(!noticeDto.getPhonenos().matches("^((1(([35][0-9])|(47)|[8][0123456789]))\\d{8})(\\,(1(([35][0-9])|(47)|[8][0123456789]))\\d{8})*$")){
			result.setSuccess(false);
			result.setMsg("手机号码格式不正确");
		}else if(noticeDto.getPhonenos().split(",").length>100){
			result.setSuccess(false);
			result.setMsg("手机号码不能超过100个");
		}else if(StringUtils.isEmpty(noticeDto.getMsgcontent())){
			result.setSuccess(false);
			result.setMsg("短信内容不能为空");
		}else if(noticeDto.getMsgcontent().length()>300){
			result.setSuccess(false);
			result.setMsg("短信内容不能超过300个字");
		}else{
			result.setSuccess(true);
			result.setMsg("发送成功");
		}
	}
}
