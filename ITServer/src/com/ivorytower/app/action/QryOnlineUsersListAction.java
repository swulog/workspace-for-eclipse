package com.ivorytower.app.action;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ivorytower.app.dto.QryOnlineUsersListDto;
import com.ivorytower.app.service.UserService;
import com.ivorytower.comm.Constants;
import com.ivorytower.comm.Result;

@Controller
@RequestMapping("/comm")
public class QryOnlineUsersListAction {
	
	static Logger logger = Logger.getLogger(TestAction.class.getName());
	
	@Autowired
	private UserService userservice;

	@RequestMapping(value="/queryonlineuserslist")
	@ResponseBody 
	public Result test(HttpServletRequest request,QryOnlineUsersListDto dto){
		Result result=new Result();
		
		try {
			validParam(dto,result);
			if(result.getSuccess()){
				this.userservice.queryOnlineUsersList(dto,result);
			}else{//验证失败
			}
			return result;
		} catch (Exception e) {
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("查询车源信息列表出现异常");
			return result;
		}
	}
	
	//表单验证
	public void validParam(QryOnlineUsersListDto dto,Result result){

		if(dto.getPageno()<=0){
			dto.setPageno(Constants.DEFAULT_PAGENO);
		}
		if(dto.getPagesize()<=0){
			dto.setPagesize(Constants.DEFAULT_PAGESIZE);
		}
		result.setSuccess(true);
		result.setMsg("成功");
		
		return;
	}

}
