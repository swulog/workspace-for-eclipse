package cn.com.enho.mg.action;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.com.enho.comm.MgResult;
import cn.com.enho.comm.constants.Constants;
import cn.com.enho.mg.dto.QryRuleListDto;
import cn.com.enho.mg.dto.RuleDto;
import cn.com.enho.mg.service.MgService;

/**
 * 		查询规则
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-9-17 下午2:57:20
 */
@Controller
@RequestMapping("/mg")
public class QryRuleAction {

	@Autowired
	private MgService mgService;
	
	static Logger logger = Logger.getLogger(QryRuleAction.class.getName());
	
	
	@RequestMapping(value="/qryRuleList")
	@ResponseBody 
	public MgResult qryRuleList(QryRuleListDto qryRuleListDto){
		logger.debug("*********************************************查询规则列表	start*********************************************");
		
		MgResult result=new MgResult();
		try{
			//表单验证
			validParam(qryRuleListDto,result);
			//验证成功
			if(result.getSuccess()){
				this.mgService.qryRuleList(qryRuleListDto,result);
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
	
	@RequestMapping(value="/qryRuleDtl")
	public ModelAndView qryRuleDtl(RuleDto ruleDto){
		logger.debug("*********************************************后台_查询规则详情	start*********************************************");
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
		mav.setViewName("admin/ruledtl");
		return mav;
	}
	
	//表单验证
	public void validParam(QryRuleListDto qryRuleListDto,MgResult result){
		if(!StringUtils.isEmpty(qryRuleListDto.getName()) && qryRuleListDto.getName().length()>20){
			result.setSuccess(false);
			result.setMsg("规则名称不能超过20个字符");
			return;
		}else if(!StringUtils.isEmpty(qryRuleListDto.getKey()) && qryRuleListDto.getKey().length()>20){
			result.setSuccess(false);
			result.setMsg("规则key不能超过20个字符");
			return;
		}else{
			if(qryRuleListDto.getPage()==null || qryRuleListDto.getPage()<=0){
				qryRuleListDto.setPage(Constants.DEFAULT_CURRENTPAGE);
			}
			if(qryRuleListDto.getRows()==null || qryRuleListDto.getRows()<=0){
				qryRuleListDto.setRows(Constants.DEFAULT_PAGESIZE);
			}
			result.setSuccess(true);
			result.setMsg("验证成功");
			return;
		}
	}
}
