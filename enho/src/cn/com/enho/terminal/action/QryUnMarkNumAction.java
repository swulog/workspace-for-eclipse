package cn.com.enho.terminal.action;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.com.enho.comm.Result;
import cn.com.enho.terminal.service.BusService;

/**
 * 		查询待评分记录数
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-9-3 下午12:06:37
 */
@Controller
@RequestMapping("/terminal")
public class QryUnMarkNumAction {

	@Autowired
	private BusService busService;
	
	static Logger logger = Logger.getLogger(QryUnMarkNumAction.class.getName());
	
	
	@RequestMapping(value="/qryUnMarkNum")
	@ResponseBody 
	public Result qryUnMarkNum(@RequestParam String userid,@RequestParam Integer usertype){
		logger.debug("*********************************************查询待评分记录数	start*********************************************");
		
		Result result=new Result();
		try{
			//表单验证
			validParam(userid,usertype,result);
			//验证成功
			if(result.getSuccess()){
				this.busService.qryUnMarkNum(userid,usertype,result);
			}else{//验证失败
			}
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("查询待评分记录数出现异常");
			return result;
		}
		
	}
	
	//表单验证
	public void validParam(String userid,Integer usertype,Result result){
		if(StringUtils.isEmpty(userid)){
			result.setSuccess(false);
			result.setMsg("用户id不能为空");
			return;
		}else if(StringUtils.isEmpty(usertype)){
			result.setSuccess(false);
			result.setMsg("用户类型不能为空");
			return;
		}else{
			result.setSuccess(true);
			result.setMsg("验证成功");
			return;
		}
	}
}
