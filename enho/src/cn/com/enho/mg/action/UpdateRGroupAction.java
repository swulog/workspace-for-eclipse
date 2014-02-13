package cn.com.enho.mg.action;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.com.enho.comm.MgResult;
import cn.com.enho.mg.dto.RGroupDto;
import cn.com.enho.mg.service.MgService;

/**
 * 		修改规则组
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-9-22 下午3:52:50
 */
@Controller
@RequestMapping("/mg")
public class UpdateRGroupAction {

	@Autowired
	private MgService mgService;
	
	static Logger logger = Logger.getLogger(UpdateRGroupAction.class.getName());
	
	@RequestMapping(value="/updateRGroupPre")
	public ModelAndView updateRGroupPre(RGroupDto rGroupDto){
		logger.debug("*********************************************修改规则组页面加载	start*********************************************");
		ModelAndView mav=new ModelAndView();
		mav.addObject("id", rGroupDto.getId());
		mav.addObject("code", rGroupDto.getCode());
		mav.addObject("name", rGroupDto.getName());
		mav.addObject("desc", rGroupDto.getDesc());
		mav.addObject("isabled", rGroupDto.getIsabled());
		mav.addObject("createtime", rGroupDto.getCreatetime());
		mav.addObject("lastupdatetime", rGroupDto.getLastupdatetime());
		mav.addObject("gridid", rGroupDto.getGridid());
		mav.setViewName("admin/rgroupupdate");
		return mav;
	}
	
	
	@RequestMapping(value="/updateRGroup")
	@ResponseBody 
	public MgResult updateRGroup(RGroupDto rGroupDto){
		logger.debug("*********************************************修改规则组	start*********************************************");
		
		MgResult result=new MgResult();
		try{
			//表单验证
			validParam(rGroupDto,result);
			//验证成功
			if(result.getSuccess()){
				this.mgService.updateRGroup(rGroupDto, result);
			}else{//验证失败
			}
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("修改出现异常");
			return result;
		}
		
	}
	
	//表单验证
	public void validParam(RGroupDto rGroupDto,MgResult result){
		if(StringUtils.isEmpty(rGroupDto.getId())){
			result.setSuccess(false);
			result.setMsg("id不能为空");
			return;
		}else{
			result.setSuccess(true);
			result.setMsg("验证成功");
			return;
		}
	}
}
