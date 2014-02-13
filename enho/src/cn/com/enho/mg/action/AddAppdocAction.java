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
import cn.com.enho.mg.dto.AppDto;
import cn.com.enho.mg.dto.AppdocDto;
import cn.com.enho.mg.service.MgService;

/**
 * 		新增app
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-9-27 上午11:32:13
 */
@Controller
@RequestMapping("/mg")
public class AddAppdocAction {
	@Autowired
	private MgService mgService;
	
	static Logger logger = Logger.getLogger(AddAppdocAction.class.getName());
	
	@RequestMapping(value="/addAppdocPre")
	public ModelAndView addAppPre(AppDto appDto){
		ModelAndView mav=new ModelAndView();
		mav.addObject("gridid",appDto.getGridid());
		mav.setViewName("admin/appdocadd");
		return mav;
	}
	
	@RequestMapping(value="/addAppdoc")
	@ResponseBody 
	public MgResult addAppdoc(HttpServletRequest request,AppdocDto appdocDto){
		logger.debug("*********************************************新增app doc	start*********************************************");
		
		MgResult result=new MgResult();
		try{
			//表单验证
			validParam(appdocDto,result);
			//验证成功
			if(result.getSuccess()){
				this.mgService.addAppdoc(appdocDto,result);
			}else{//验证失败
			}
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("新增异常");
			return result;
		}
		
	}
	
	//表单验证
	public void validParam(AppdocDto appdocDto,MgResult result){
		if(StringUtils.isEmpty(appdocDto.getType())){
			result.setSuccess(false);
			result.setMsg("类型不能为空");
			return;
		}else if(StringUtils.isEmpty(appdocDto.getContent())){
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
