package cn.com.enho.mg.action;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.com.enho.comm.MgResult;
import cn.com.enho.mg.dto.RGroupDto;
import cn.com.enho.mg.service.MgService;

/**
 * 		新增规则组
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-9-22 下午3:53:02
 */
@Controller
@RequestMapping("/mg")
public class AddRGroupAction {

	@Autowired
	private MgService mgService;
	
	static Logger logger = Logger.getLogger(AddRGroupAction.class.getName());
	
	@RequestMapping(value="/addRGroupPre")
	public ModelAndView addRGroupPre(RGroupDto rGroupDto){
		ModelAndView mav=new ModelAndView();
		mav.addObject("gridid",rGroupDto.getGridid());
		mav.setViewName("admin/rgroupadd");
		return mav;
	}
	
	@RequestMapping(value="/addRGroup")
	@ResponseBody 
	public MgResult addRGroup(RGroupDto rGroupDto){
		logger.debug("*********************************************新增规则组	start*********************************************");
		
		MgResult result=new MgResult();
		try{
			//表单验证
			validParam(rGroupDto,result);
			//验证成功
			if(result.getSuccess()){
				this.mgService.addRGroup(rGroupDto, result);
			}else{//验证失败
			}
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("新增出现异常");
			return result;
		}
		
	}
	
	//表单验证
	public void validParam(RGroupDto rGroupDto,MgResult result){
		if(StringUtils.isEmpty(rGroupDto.getName())){
			result.setSuccess(false);
			result.setMsg("规则组名称不能为空");
			return;
		}else{
			result.setSuccess(true);
			result.setMsg("验证成功");
			return;
		}
	}
}
