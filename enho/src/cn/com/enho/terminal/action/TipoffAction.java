package cn.com.enho.terminal.action;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.com.enho.comm.Result;
import cn.com.enho.terminal.dto.TipoffDto;
import cn.com.enho.terminal.service.TipoffService;

/**
 * 		举报
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-16 下午1:50:29
 */
@Controller
@RequestMapping("/terminal")
public class TipoffAction {

	@Autowired
	private TipoffService tipoffService;
	
	static Logger logger = Logger.getLogger(TipoffAction.class.getName());
	
	
	@RequestMapping(value="/tipoff")
	@ResponseBody 
	public Result tipoff(TipoffDto tipoffDto){
		logger.debug("*********************************************举报	start*********************************************");
		
		Result result=new Result();
		try{
			//表单验证
			validParam(tipoffDto,result);
			//验证成功
			if(result.getSuccess()){
				this.tipoffService.addTipoff(tipoffDto, result);
			}else{//验证失败
			}
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("举报出现异常");
			return result;
		}
		
	}
	
	//表单验证
	public void validParam(TipoffDto tipoffDto,Result result){
		if(StringUtils.isEmpty(tipoffDto.getUserid())){
			result.setSuccess(false);
			result.setMsg("用户id不能为空");
			return;
		}else if(StringUtils.isEmpty(tipoffDto.getReportphone())){
			result.setSuccess(false);
			result.setMsg("被举报人手机号码不能为空");
			return;
		}else if(StringUtils.isEmpty(tipoffDto.getContent())){
			result.setSuccess(false);
			result.setMsg("举报内容不能为空");
			return;
		}else{
			result.setSuccess(true);
			result.setMsg("验证成功");
			return;
		}
	}
}
