package com.ivorytower.app.action;

import java.sql.Timestamp;
import java.util.Calendar;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ivorytower.app.entity.Userbaseinfo;
import com.ivorytower.app.entity.Userexpandinfo;
import com.ivorytower.app.service.UserbaseinfoService;
import com.ivorytower.comm.Result;







@Controller
@RequestMapping("/comm")
public class TestAction {

	static Logger logger = Logger.getLogger(TestAction.class.getName());
	
	@Autowired
	private UserbaseinfoService userbaseinfoService;
	
	@RequestMapping(value="/test")
	@ResponseBody 
	public Result test(){
		
		Result result=new Result();
		try{
//			Userbaseinfo userbaseinfo=new Userbaseinfo();
//			userbaseinfo.setUbiUsername("龙超");
//			Timestamp ts = new Timestamp(Calendar.getInstance().getTime().getTime());
//			userbaseinfo.setUbiCreatetime(ts);
//			userbaseinfo.setUbiPwd("dfgdf");
//			userbaseinfo.setUbiSession("dfgdf");
//			userbaseinfo.setUbiStatus(2);
			//this.userbaseinfoService.addUserbaseinfo(userbaseinfo);
			
			
			Userbaseinfo userbaseinfo = this.userbaseinfoService.getUserbaseinfoById(1);
			result.getData().put("username", userbaseinfo.getUbiUsername());
			result.setSuccess(true);
			result.setMsg("测试成功");
			
			Userexpandinfo userexpandinfo = userbaseinfo.getUserExpand();
			System.out.println(userexpandinfo.getUeiNickname());
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("test出现异常");
			return result;
		}
	}
	
}
