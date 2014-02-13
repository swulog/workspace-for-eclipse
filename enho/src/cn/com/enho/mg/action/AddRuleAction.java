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
 * 		新增规则
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-9-17 下午2:56:53
 */
@Controller
@RequestMapping("/mg")
public class AddRuleAction {

	@Autowired
	private MgService mgService;
	
	static Logger logger = Logger.getLogger(AddRuleAction.class.getName());
	
	@RequestMapping(value="/addRulePre")
	public ModelAndView addRulePre(RuleDto ruleDto){
		ModelAndView mav=new ModelAndView();
		mav.addObject("gridid",ruleDto.getGridid());
		mav.setViewName("admin/ruleadd");
		return mav;
	}
	
	@RequestMapping(value="/addRule")
	@ResponseBody 
	public MgResult addRule(HttpServletRequest request,RuleDto ruleDto){
		logger.debug("*********************************************新增规则	start*********************************************");
		
		MgResult result=new MgResult();
		try{
			//表单验证
			validParam(ruleDto,result);
			//验证成功
			if(result.getSuccess()){
				this.mgService.addRule(ruleDto, result);
				//新增成功后rule放入内存
				request.getServletContext().setAttribute(ruleDto.getKey(),ruleDto.getValue());
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
	public void validParam(RuleDto ruleDto,MgResult result){
		if(StringUtils.isEmpty(ruleDto.getName())){
			result.setSuccess(false);
			result.setMsg("规则名称不能为空");
			return;
		}else if(ruleDto.getName().length()>20){
			result.setSuccess(false);
			result.setMsg("规则名称不能超过20个字符");
			return;
		}else if(StringUtils.isEmpty(ruleDto.getKey())){
			result.setSuccess(false);
			result.setMsg("规则key不能为空");
			return;
		}else if(ruleDto.getKey().length()>20){
			result.setSuccess(false);
			result.setMsg("规则key不能超过20个字符");
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
