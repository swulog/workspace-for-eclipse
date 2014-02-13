package cn.com.enho.mg.action;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.com.enho.comm.MgResult;
import cn.com.enho.mg.dto.AppdocDto;
import cn.com.enho.mg.service.MgService;

/**
 * 		修改app
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-9-27 下午12:50:02
 */
@Controller
@RequestMapping("/mg")
public class UpdateAppdocAction {

	@Autowired
	private MgService mgService;
	
	static Logger logger = Logger.getLogger(UpdateAppdocAction.class.getName());
	
	@RequestMapping(value="/updateAppdocPre")
	public ModelAndView updateAppdocPre(AppdocDto appdocDto){
		logger.debug("*********************************************后台_修改app doc 页面加载	start*********************************************");
		ModelAndView mav=new ModelAndView();
		mav.addObject("id", appdocDto.getId());
		mav.addObject("type", appdocDto.getType());
		mav.addObject("name", appdocDto.getName());
		mav.addObject("title", appdocDto.getTitle());
		mav.addObject("createtime", appdocDto.getCreatetime());
		mav.addObject("lastupdatetime", appdocDto.getLastupdatetime());
		mav.addObject("content", appdocDto.getContent());
		mav.setViewName("admin/appdocupdate");
		return mav;
	}
	
	@RequestMapping(value="/updateAppdoc")
	@ResponseBody 
	public MgResult updateAppdoc(HttpServletRequest request,AppdocDto appdocDto){
		logger.debug("*********************************************修改app doc	start*********************************************");
		
		MgResult result=new MgResult();
		try{
			//表单验证
			validParam(appdocDto,result);
			//验证成功
			if(result.getSuccess()){
				this.mgService.updateAppdoc(appdocDto,result);
			}else{//验证失败
			}
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("修改异常");
			return result;
		}
		
	}
	
	//表单验证
	public void validParam(AppdocDto appdocDto,MgResult result){
		if(StringUtils.isEmpty(appdocDto.getContent())){
			result.setSuccess(false);
			result.setMsg("内容不能为空");
			return;
		}else if(!StringUtils.isEmpty(appdocDto.getName()) && appdocDto.getName().length()>50){
			result.setSuccess(false);
			result.setMsg("名称不能超过50字");
			return;
		}else if(!StringUtils.isEmpty(appdocDto.getTitle()) && appdocDto.getTitle().length()>50){
			result.setSuccess(false);
			result.setMsg("标题不能超过50字");
			return;
		}else if(!StringUtils.isEmpty(appdocDto.getContent()) && appdocDto.getContent().length()>65535){
			result.setSuccess(false);
			result.setMsg("内容不能超过64K");
			return;
		}else{
			result.setSuccess(true);
			result.setMsg("验证成功");
			return;
		}
	}
}
