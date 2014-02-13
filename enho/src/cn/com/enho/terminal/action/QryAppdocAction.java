package cn.com.enho.terminal.action;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.com.enho.comm.Result;
import cn.com.enho.comm.constants.Constants;
import cn.com.enho.terminal.service.CommService;

/**
 * 		查询app文档
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-10-28 下午4:17:34
 */
@Controller
@RequestMapping("/comm")
public class QryAppdocAction {

	@Autowired
	private CommService commService;
	
	static Logger logger = Logger.getLogger(QryAppdocAction.class.getName());
	
	
	@RequestMapping(value="/qryAppdoc")
	@ResponseBody 
	public Result qryAppdoc(@RequestParam Integer type){
		logger.debug("*********************************************查询App文档	start*********************************************");
		
		Result result=new Result();
		try{
			//表单验证
			validParam(type,result);
			//验证成功
			if(result.getSuccess()){
				this.commService.qryAppdoc(type,result);
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
	
	//表单验证
	public void validParam(Integer type,Result result){
		if(StringUtils.isEmpty(type)){
			result.setSuccess(false);
			result.setMsg("类型不能为空");
			return;
		}else if(type!=Constants.APPDOC_TYPE_ABOUTUS && type!=Constants.APPDOC_TYPE_DISC){
			result.setSuccess(false);
			result.setMsg("类型不正确");
			return;
		}else{
			result.setSuccess(true);
			result.setMsg("验证成功");
			return;
		}
	}
}
