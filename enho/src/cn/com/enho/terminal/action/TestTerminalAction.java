package cn.com.enho.terminal.action;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.com.enho.comm.Result;

@Controller
@RequestMapping("/comm")
public class TestTerminalAction {
	@Autowired
	//private CommService commService;
	
	static Logger logger = Logger.getLogger(TestTerminalAction.class.getName());
	
	
	@RequestMapping(value="/terminaltest")
	@ResponseBody 
	public Result collectCar(){
		logger.debug("*********************************************test	start*********************************************");
		
		Result result=new Result();
		try{
			//this.commService.f();
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("test出现异常");
			return result;
		}
		
	}
}
