package cn.com.enho.terminal.action;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.com.enho.comm.Result;
import cn.com.enho.terminal.dto.PubFeedBackDto;
import cn.com.enho.terminal.service.FeedBackService;

/**
 * 		发布反馈信息
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-16 上午11:28:37
 */
@Controller
@RequestMapping("/terminal")
public class PubFeedBackAction {

	@Autowired
	private FeedBackService feedBackService;
	
	static Logger logger = Logger.getLogger(PubFeedBackAction.class.getName());
	
	
	@RequestMapping(value="/pubFeedBack")
	@ResponseBody 
	public Result pubFeedBack(PubFeedBackDto pubFeedBackDto){
		logger.debug("*********************************************发布反馈信息	start*********************************************");
		
		Result result=new Result();
		try{
			//表单验证
			validParam(pubFeedBackDto,result);
			//验证成功
			if(result.getSuccess()){
				this.feedBackService.addFeedBack(pubFeedBackDto,result);
			}else{//验证失败
			}
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("发布反馈信息出现异常");
			return result;
		}
		
	}
	
	//表单验证
	public void validParam(PubFeedBackDto pubFeedBackDto,Result result){
		if(StringUtils.isEmpty(pubFeedBackDto.getUserid())){
			result.setSuccess(false);
			result.setMsg("用户id不能为空");
			return;
		}else if(StringUtils.isEmpty(pubFeedBackDto.getContent())){
			result.setSuccess(false);
			result.setMsg("反馈内容不能为空");
			return;
		}else{
			result.setSuccess(true);
			result.setMsg("验证成功");
			return;
		}
	}
}
