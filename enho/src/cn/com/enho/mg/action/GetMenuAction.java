package cn.com.enho.mg.action;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.com.enho.comm.Result;
import cn.com.enho.mg.service.MgService;

/**
 * 		获取菜单
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-9-16 下午12:09:06
 */
@Controller
@RequestMapping("/mg")
public class GetMenuAction {

	@Autowired
	private MgService mgService;
	
	static Logger logger = Logger.getLogger(GetMenuAction.class.getName());
	
	
	@RequestMapping(value="/getMenu")
	@ResponseBody 
	public Object getMenu(){
		logger.debug("*********************************************获取菜单	start*********************************************");
		
		Result result=new Result();
		try{
			this.mgService.getMenu(result);
			return result.getData().get("list");
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("查询出现异常");
			return result;
		}
		
	}
}
