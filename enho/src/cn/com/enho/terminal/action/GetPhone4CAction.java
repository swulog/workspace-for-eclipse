package cn.com.enho.terminal.action;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.com.enho.comm.Result;
import cn.com.enho.terminal.dto.GetPhoneDto;
import cn.com.enho.terminal.service.BusService;

/**
 * 		获取车主的电话号码
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-21 下午5:03:12
 */
@Controller
@RequestMapping("/terminal")
public class GetPhone4CAction {
	
	@Autowired
	private BusService busService;
	
	static Logger logger = Logger.getLogger(GetPhone4CAction.class.getName());
	
	
	@RequestMapping(value="/getPhone4C")
	@ResponseBody 
	public synchronized Result getPhone(HttpServletRequest request,GetPhoneDto getPhoneDto){
		logger.debug("*********************************************获取联系方式	start*********************************************");
		
		Result result=new Result();
		try{
			//表单验证
			validParam(getPhoneDto,result);
			//验证成功
			if(result.getSuccess()){
				ServletContext servletContext=request.getServletContext();
				String push_appkey=servletContext.getAttribute("push_appkey")==null?"":servletContext.getAttribute("push_appkey").toString();
				String push_masterSecret=servletContext.getAttribute("push_masterSecret")==null?"":servletContext.getAttribute("push_masterSecret").toString();
				long push_timeToLive=servletContext.getAttribute("push_timeToLive")==null?0:Long.parseLong(servletContext.getAttribute("push_timeToLive").toString());
				this.busService.requestPhone4C(push_appkey,push_masterSecret,push_timeToLive,getPhoneDto,result);
			}else{//验证失败
			}
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("获取联系方式出现异常");
			return result;
		}
		
	}
	
	//表单验证
	public void validParam(GetPhoneDto getPhoneDto,Result result){
		if(StringUtils.isEmpty(getPhoneDto.getInfoid())){
			result.setSuccess(false);
			result.setMsg("信息id不能为空");
			return;
		}else if(StringUtils.isEmpty(getPhoneDto.getRequserid())){
			result.setSuccess(false);
			result.setMsg("请求人id不能为空");
			return;
		}else if(StringUtils.isEmpty(getPhoneDto.getInfotype())){
			result.setSuccess(false);
			result.setMsg("信息类型不能为空");
			return;
		}else if(StringUtils.isEmpty(getPhoneDto.getRequserphone())){
			result.setSuccess(false);
			result.setMsg("用户手机号码不能为空");
			return;
		}else{
			result.setSuccess(true);
			result.setMsg("验证成功");
			return;
		}
	}
}
