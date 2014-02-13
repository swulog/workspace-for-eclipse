package cn.com.enho.mg.action;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.com.enho.comm.MgResult;
import cn.com.enho.comm.constants.Constants;
import cn.com.enho.mg.dto.AppDto;
import cn.com.enho.mg.dto.QryAppListDto;
import cn.com.enho.mg.service.MgService;

/**
 * 		查询app
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-9-27 上午11:12:31
 */
@Controller
@RequestMapping("/mg")
public class QryAppAction {

	@Autowired
	private MgService mgService;
	
	static Logger logger = Logger.getLogger(QryAppAction.class.getName());
	
	
	@RequestMapping(value="/qryAppList")
	@ResponseBody 
	public MgResult qryAppList(QryAppListDto qryAppListDto){
		logger.debug("*********************************************查询app列表	start*********************************************");
		
		MgResult result=new MgResult();
		try{
			//表单验证
			validParam(qryAppListDto,result);
			//验证成功
			if(result.getSuccess()){
				this.mgService.qryAppList(qryAppListDto,result);
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
	
	@RequestMapping(value="/qryAppDtl")
	public ModelAndView qryAppDtl(AppDto appDto){
		logger.debug("*********************************************后台_查询app详情	start*********************************************");
		ModelAndView mav=new ModelAndView();
		mav.addObject("id", appDto.getId());
		mav.addObject("name", appDto.getName());
		mav.addObject("key", appDto.getKey());
		mav.addObject("version", appDto.getVersion());
		mav.addObject("url", appDto.getUrl());
		mav.addObject("size", appDto.getSize());
		mav.addObject("createtime", appDto.getCreatetime());
		mav.addObject("lastupdatetime", appDto.getLastupdatetime());
		mav.addObject("desc", appDto.getDesc());
		mav.setViewName("admin/appdtl");
		return mav;
	}
	
	//表单验证
	public void validParam(QryAppListDto qryAppListDto,MgResult result){
		if(qryAppListDto.getPage()==null || qryAppListDto.getPage()<=0){
				qryAppListDto.setPage(Constants.DEFAULT_CURRENTPAGE);
		}
		if(qryAppListDto.getRows()==null || qryAppListDto.getRows()<=0){
				qryAppListDto.setRows(Constants.DEFAULT_PAGESIZE);
		}
		result.setSuccess(true);
		result.setMsg("验证成功");
		return;
	}
}
