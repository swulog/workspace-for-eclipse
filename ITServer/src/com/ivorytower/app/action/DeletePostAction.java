package com.ivorytower.app.action;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ivorytower.app.dto.DeletePostDto;
import com.ivorytower.app.service.PostService;
import com.ivorytower.comm.Result;

@Controller
@RequestMapping("/comm")
public class DeletePostAction {
	
	static Logger logger = Logger.getLogger(TestAction.class.getName());
	
	@Autowired
	private PostService postservice;

	@RequestMapping(value="/deletePost")
	@ResponseBody 
	public Result test(HttpServletRequest request,DeletePostDto dto){
		Result result=new Result();
		
		try {
			validParam(dto,result);
			if(result.getSuccess()){
				this.postservice.deletePost(dto,result);
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
	public void validParam(DeletePostDto dto,Result result){
		result.setSuccess(true);
		result.setMsg("成功");
		return;
	}

}
