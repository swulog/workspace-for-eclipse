package cn.com.enho.terminal.action;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.com.enho.comm.Result;
import cn.com.enho.terminal.service.CarService;

/**
 * 		查询车源信息详情
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-12 上午10:27:52
 */
@Controller
@RequestMapping("/comm")
public class QryCarDtlAction {

	@Autowired
	private CarService carService;
	
	static Logger logger = Logger.getLogger(QryCarDtlAction.class.getName());
	
	
	@RequestMapping(value="/qryCarDtl")
	@ResponseBody 
	public Result qryCarDtl(HttpServletRequest request,@RequestParam String carid){
		logger.debug("*********************************************查询车源信息详情	start*********************************************");
		
		Result result=new Result();
		try{
			//表单验证
			validParam(carid,result);
			//验证成功
			if(result.getSuccess()){
				String baseurl=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+ request.getContextPath();
				this.carService.qryCarDtl(carid,baseurl,result);
			}else{//验证失败
			}
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("查询车源信息详情出现异常");
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
