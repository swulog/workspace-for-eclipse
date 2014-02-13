package cn.com.enho.mg.action;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.com.enho.comm.MgResult;
import cn.com.enho.comm.constants.Constants;
import cn.com.enho.mg.dto.AppdocDto;
import cn.com.enho.mg.dto.QryAppdocListDto;
import cn.com.enho.mg.service.MgService;

/**
 * 		查询app
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-9-27 上午11:12:31
 */
@Controller
@RequestMapping("/mg")
public class QryAppdoc4MgAction {

	@Autowired
	private MgService mgService;
	
	static Logger logger = Logger.getLogger(QryAppdoc4MgAction.class.getName());
	
	
	@RequestMapping(value="/qryAppdocList")
	@ResponseBody 
	public MgResult qryAppdocList(QryAppdocListDto qryAppdocListDto){
		logger.debug("*********************************************查询app doc列表	start*********************************************");
		
		MgResult result=new MgResult();
		try{
			//表单验证
			validParam(qryAppdocListDto,result);
			//验证成功
			if(result.getSuccess()){
				this.mgService.qryAppdocList(qryAppdocListDto,result);
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
	
	@RequestMapping(value="/qryAppdocDtl")
	public ModelAndView qryAppdocDtl(AppdocDto appdocDto){
		logger.debug("*********************************************后台_查询app详情	start*********************************************");
		ModelAndView mav=new ModelAndView();
		mav.addObject("id", appdocDto.getId());
		mav.addObject("type", appdocDto.getType());
		mav.addObject("name", appdocDto.getName());
		mav.addObject("title", appdocDto.getTitle());
		mav.addObject("createtime", appdocDto.getCreatetime());
		mav.addObject("lastupdatetime", appdocDto.getLastupdatetime());
		mav.addObject("content", appdocDto.getContent());
		mav.setViewName("admin/appdocdtl");
		return mav;
	}
	
	//表单验证
	public void validParam(QryAppdocListDto qryAppdocListDto,MgResult result){
		if(qryAppdocListDto.getPage()==null || qryAppdocListDto.getPage()<=0){
			qryAppdocListDto.setPage(Constants.DEFAULT_CURRENTPAGE);
		}
		if(qryAppdocListDto.getRows()==null || qryAppdocListDto.getRows()<=0){
			qryAppdocListDto.setRows(Constants.DEFAULT_PAGESIZE);
		}
		result.setSuccess(true);
		result.setMsg("验证成功");
		return;
	}
}
