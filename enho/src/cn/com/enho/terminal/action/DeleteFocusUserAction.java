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
 * 		删除已关注用户
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-15 下午2:17:23
 */
@Controller
@RequestMapping("/terminal")
public class DeleteFocusUserAction {

	@Autowired
	private FocusService focusService;
	
	static Logger logger = Logger.getLogger(DeleteFocusUserAction.class.getName());
	
	
	@RequestMapping(value="/deleteFocusUser")
	@ResponseBody 
	public Result deleteFocusUser(@RequestParam String focuseid){
		logger.debug("*********************************************关注用户	start*********************************************");
		
		Result result=new Result();
		try{
			//表单验证
			validParam(focuseid,result);
			//验证成功
			if(result.getSuccess()){
				this.focusService.deleteFocusUser(focuseid, result);
			}else{//验证失败
			}
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("删除已关注用户异常");
			return result;
		}
		
	}
	
	//表单验证
	public void validParam(String focuseid,Result result){
		if(StringUtils.isEmpty(focuseid)){
			result.setSuccess(false);
			result.setMsg("关注关系id不能为空");
			return;
		}else{
			result.setSuccess(true);
			result.setMsg("验证成功");
			return;
		}
	}
}
