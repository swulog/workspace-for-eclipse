package cn.com.enho.mg.action;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.com.enho.comm.MgResult;
import cn.com.enho.mg.dto.RuleDto;
import cn.com.enho.mg.service.MgService;

/**
 * 		修改规则
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-9-17 下午2:57:05
 */
@Controller
@RequestMapping("/mg")
public class UpdateRuleAction {

	@Autowired
	private MgService mgService;
	
	static Logger logger = Logger.getLogger(UpdateRuleAction.class.getName());
	
	@RequestMapping(value="/updateRulePre")
	public ModelAndView updateRulePre(RuleDto ruleDto){
		logger.debug("*********************************************后台_修改规则页面加载	start*********************************************");
		ModelAndView mav=new ModelAndView();
		mav.addObject("id", ruleDto.getId());
		mav.addObject("name", ruleDto.getName());
		mav.addObject("key", ruleDto.getKey());
		mav.addObject("value", ruleDto.getValue());
		mav.addObject("desc", ruleDto.getDesc());
		mav.addObject("isabled", ruleDto.getIsabled());
		mav.addObject("createtime", ruleDto.getCreatetime());
		mav.addObject("lastupdatetime", ruleDto.getLastupdatetime());
		mav.addObject("groupid", ruleDto.getGroupid());
		mav.addObject("groupname", ruleDto.getGroupname());
		mav.addObject("gridid", ruleDto.getGridid());
		mav.setViewName("admin/ruleupdate");
		return mav;
	}
	
	@RequestMapping(value="/updateRule")
	@ResponseBody 
	public MgResult updateRule(HttpServletRequest request,RuleDto ruleDto){
		logger.debug("*********************************************修改规则	start*********************************************");
		
		MgResult result=new MgResult();
		try{
			//表单验证
			validParam(ruleDto,result);
			//验证成功
			if(result.getSuccess()){
				this.mgService.updateRule(ruleDto, result);
				//修改成功后rule放入内存
				request.getServletContext().setAttribute(ruleDto.getKey(), ruleDto.getValue());
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
	public void validParam(RuleDto ruleDto,MgResult result){
		if(StringUtils.isEmpty(ruleDto.getName())){
			result.setSuccess(false);
			result.setMsg("规则名称不能为空");
			return;
		}else if(ruleDto.getName().length()>20){
			result.setSuccess(false);
			result.setMsg("规则名称不能超过20个字符");
			return;
		}else if((!StringUtils.isEmpty(ruleDto.getValue())) && (ruleDto.getValue().length()>20)){
			result.setSuccess(false);
			result.setMsg("规则value不能超过20个字符");
			return;
		}else if(StringUtils.isEmpty(ruleDto.getGroupid())){
			result.setSuccess(false);
			result.setMsg("所属组不能为空");
			return;
		}else if((!StringUtils.isEmpty(ruleDto.getDesc())) && (ruleDto.getDesc().length()>20)){
			result.setSuccess(false);
			result.setMsg("所属组不能为空");
			return;
		}else{
			result.setSuccess(true);
			result.setMsg("验证成功");
			return;
		}
	}
}
