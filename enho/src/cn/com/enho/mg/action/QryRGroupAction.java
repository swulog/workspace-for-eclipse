package cn.com.enho.mg.action;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.com.enho.comm.MgResult;
import cn.com.enho.comm.constants.Constants;
import cn.com.enho.mg.dto.QryRGroupListDto;
import cn.com.enho.mg.dto.RGroupDto;
import cn.com.enho.mg.service.MgService;

/**
 * 		查询规则组
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-9-22 下午3:51:41
 */
@Controller
@RequestMapping("/mg")
public class QryRGroupAction {

	@Autowired
	private MgService mgService;
	
	static Logger logger = Logger.getLogger(QryRGroupAction.class.getName());
	
	/**
	 * 查询规则组列表
	 * @param qryUserListDto
	 * @return
	 */
	@RequestMapping(value="/qryRGroupList")
	@ResponseBody 
	public MgResult qryRGroupList(QryRGroupListDto qryRGroupDto){
		logger.debug("*********************************************查询规则组列表	start*********************************************");
		
		MgResult result=new MgResult();
		try{
			//表单验证
			validParam(qryRGroupDto,result);
			//验证成功
			if(result.getSuccess()){
				this.mgService.qryRGroupList(qryRGroupDto,result);
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
	
	@RequestMapping(value="/qryRGroupDtl")
	@ModelAttribute
	public ModelAndView qryRGroupDtl(RGroupDto rGroupDto){
		logger.debug("*********************************************查询规则组详情	start*********************************************");
		ModelAndView mav=new ModelAndView();
		mav.addObject("id", rGroupDto.getId());
		mav.addObject("code", rGroupDto.getCode());
		mav.addObject("name", rGroupDto.getName());
		mav.addObject("desc", rGroupDto.getDesc());
		mav.addObject("isabled", rGroupDto.getIsabled());
		mav.addObject("createtime", rGroupDto.getCreatetime());
		mav.addObject("lastupdatetime", rGroupDto.getLastupdatetime());
		mav.setViewName("admin/rgroupdtl");
		return mav;
	}
	
	//表单验证
	public void validParam(QryRGroupListDto qryRGroupDto,MgResult result){
		if(!StringUtils.isEmpty(qryRGroupDto.getName()) && qryRGroupDto.getName().length()>5){
			result.setSuccess(false);
			result.setMsg("规则组名称不能超过5个字符");
			return;
		}else{
			if(qryRGroupDto.getPage()==null || qryRGroupDto.getPage()<=0){
				qryRGroupDto.setPage(Constants.DEFAULT_CURRENTPAGE);
			}
			if(qryRGroupDto.getRows()==null || qryRGroupDto.getRows()<=0){
				qryRGroupDto.setRows(Constants.DEFAULT_PAGESIZE);
			}
			result.setSuccess(true);
			result.setMsg("验证成功");
			return;
		}
	}
}
