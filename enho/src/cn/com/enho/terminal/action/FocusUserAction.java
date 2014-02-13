package cn.com.enho.terminal.action;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.com.enho.comm.Result;
import cn.com.enho.terminal.service.FocusService;

/**
 * 		关注用户
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-15 上午10:32:32
 */
@Controller
@RequestMapping("/terminal")
public class FocusUserAction {

	@Autowired
	private FocusService focusService;
	
	static Logger logger = Logger.getLogger(FocusUserAction.class.getName());
	
	
	@RequestMapping(value="/focusUser")
	@ResponseBody 
	public Result focusUser(@RequestParam String userid1,@RequestParam String userid2){
		logger.debug("*********************************************关注用户	start*********************************************");
		
		Result result=new Result();
		try{
			//表单验证
			validParam(userid1,userid2,result);
			//验证成功
			if(result.getSuccess()){
				this.focusService.addFocusrelation(userid1, userid2, result);
			}else{//验证失败
			}
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("关注用户异常");
			return result;
		}
		
	}
	
	//表单验证
	public void validParam(String userid1, String userid2,Result result){
		if(StringUtils.isEmpty(userid1)){
			result.setSuccess(false);
			result.setMsg("关注者id不能为空");
			return;
		}else if(StringUtils.isEmpty(userid2)){
			result.setSuccess(false);
			result.setMsg("被关注者id不能为空");
			return;
		}else{
			result.setSuccess(true);
			result.setMsg("验证成功");
			return;
		}
	}
}
