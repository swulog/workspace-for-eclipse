package cn.com.enho.terminal.action;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.com.enho.comm.Result;
import cn.com.enho.terminal.service.CarService;

/**
 * 		删除车源信息
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-12 下午12:08:45
 */
@Controller
@RequestMapping("/terminal")
public class DelCarAction {

	@Autowired
	private CarService carService;
	
	static Logger logger = Logger.getLogger(DelCarAction.class.getName());
	
	
	@SuppressWarnings("deprecation")
	@RequestMapping(value="/deleteCar")
	@ResponseBody 
	public Result deleteCar(HttpServletRequest request,String carid){
		logger.debug("*********************************************删除车源信息	start*********************************************");
		
		Result result=new Result();
		try{
			//表单验证
			validParam(carid,result);
			//验证成功
			if(result.getSuccess()){
				String desdir=request.getServletContext().getAttribute("carimg").toString();//目标目录
				desdir=request.getRealPath(desdir);
				this.carService.deleteCar(carid,desdir,result);
			}else{//验证失败
			}
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("删除异常");
			return result;
		}
		
	}
	
	//表单验证
	public void validParam(String carid,Result result){
		if(StringUtils.isEmpty(carid)){
			result.setSuccess(false);
			result.setMsg("车源信息id不能为空");
			return;
		}else{
			result.setSuccess(true);
			result.setMsg("验证成功");
			return;
		}
	}
}
