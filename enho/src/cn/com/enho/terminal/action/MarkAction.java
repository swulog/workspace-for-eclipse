package cn.com.enho.terminal.action;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.com.enho.comm.Result;
import cn.com.enho.terminal.dto.MarkDto;
import cn.com.enho.terminal.service.BusService;

/**
 * 		评分
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-25 下午1:11:39
 */
@Controller
@RequestMapping("/terminal")
public class MarkAction {

	@Autowired
	private BusService busService;
	
	static Logger logger = Logger.getLogger(MarkAction.class.getName());
	
	
	@RequestMapping(value="/mark")
	@ResponseBody 
	public Result mark(MarkDto markDto){
		logger.debug("*********************************************评分	start*********************************************");
		
		Result result=new Result();
		try{
			//表单验证
			validParam(markDto,result);
			//验证成功
			if(result.getSuccess()){
				this.busService.mark(markDto,result);
			}else{//验证失败
			}
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("评分出现异常");
			return result;
		}
		
	}
	
	//表单验证
	public void validParam(MarkDto markDto,Result result){
		if(StringUtils.isEmpty(markDto.getTradeid())){
			result.setSuccess(false);
			result.setMsg("交易记录id不能为空");
			return;
		}else if(StringUtils.isEmpty(markDto.getScore())){
			result.setSuccess(false);
			result.setMsg("分值不能为空");
			return;
		}else{
			result.setSuccess(true);
			result.setMsg("验证成功");
			return;
		}
	}
}
