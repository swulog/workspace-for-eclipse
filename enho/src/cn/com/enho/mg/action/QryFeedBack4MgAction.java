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
import cn.com.enho.mg.dto.FeedBackDto;
import cn.com.enho.mg.dto.QryFeedBackListDto;
import cn.com.enho.mg.service.MgService;

/**
 * 		查询反馈信息
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-9-17 下午2:34:36
 */
@Controller
@RequestMapping("/mg")
public class QryFeedBack4MgAction {

	@Autowired
	private MgService mgService;
	
	static Logger logger = Logger.getLogger(QryFeedBack4MgAction.class.getName());
	
	
	@RequestMapping(value="/qryFeedbackList")
	@ResponseBody 
	public MgResult qryFeedBackList(QryFeedBackListDto qryFeedBackDto){
		logger.debug("*********************************************查询反馈信息列表	start*********************************************");
		
		MgResult result=new MgResult();
		try{
			//表单验证
			validParam(qryFeedBackDto,result);
			//验证成功
			if(result.getSuccess()){
				this.mgService.qryFeedBackList(qryFeedBackDto, result);
			}else{//验证失败
			}
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("查询出现异常");
			return result;
		}
		
	}
	
	@RequestMapping(value="/qryFeedbackDtl")
	public ModelAndView qryFeedBackDtl(FeedBackDto feedBackDto){
		logger.debug("*********************************************查询反馈详情	start*********************************************");
		ModelAndView mav=new ModelAndView();
		mav.addObject("id", feedBackDto.getId());
		mav.addObject("content", feedBackDto.getContent());
		mav.addObject("createtime", feedBackDto.getCreatetime());
		mav.addObject("phone", feedBackDto.getPhone());
		mav.setViewName("admin/feedbackdtl");
		return mav;
	}
	
	//表单验证
	public void validParam(QryFeedBackListDto qryFeedBackDto,MgResult result){
		if(!StringUtils.isEmpty(qryFeedBackDto.getPhone()) && !qryFeedBackDto.getPhone().matches("^(1(([35][0-9])|(47)|[8][0123456789]))\\d{8}$")){
			result.setSuccess(false);
			result.setMsg("手机号码格式不正确");
			return;
		}else{
			if(qryFeedBackDto.getPage()==null || qryFeedBackDto.getPage()<=0){
				qryFeedBackDto.setRows(Constants.DEFAULT_CURRENTPAGE);
			}
			if(qryFeedBackDto.getRows()==null || qryFeedBackDto.getRows()<=0){
				qryFeedBackDto.setRows(Constants.DEFAULT_PAGESIZE);
			}
			result.setSuccess(true);
			result.setMsg("验证成功");
			return;
		}
	}
}
