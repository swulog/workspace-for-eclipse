package cn.com.enho.terminal.action;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.com.enho.comm.Result;
import cn.com.enho.comm.constants.Constants;
import cn.com.enho.terminal.dto.QryCarListDto;
import cn.com.enho.terminal.service.CarService;

/**
 * 		查询车源信息列表
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-12 上午10:06:39
 */
@Controller
@RequestMapping("/comm")
public class QryCarListAction {

	@Autowired
	private CarService carService;
	
	static Logger logger = Logger.getLogger(QryCarListAction.class.getName());
	
	
	@RequestMapping(value="/qryCarList")
	@ResponseBody 
	public Result qryCarList(HttpServletRequest request,QryCarListDto qryCarListDto){
		logger.debug("*********************************************查询车源信息列表	start*********************************************");
		
		Result result=new Result();
		try{
			//表单验证
			validParam(qryCarListDto,result);
			//验证成功
			if(result.getSuccess()){
				String baseurl=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+ request.getContextPath();
				qryCarListDto.setBaseurl(baseurl);
				this.carService.qryCarList(qryCarListDto, result);
			}else{//验证失败
			}
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("查询车源信息列表出现异常");
			return result;
		}
		
	}
	
	//表单验证
	public void validParam(QryCarListDto qryCarListDto,Result result){
		if(qryCarListDto.getCurrentpage()==null || qryCarListDto.getCurrentpage()<=0){
			qryCarListDto.setCurrentpage(Constants.DEFAULT_CURRENTPAGE);
		}
		if(qryCarListDto.getPagesize()==null || qryCarListDto.getPagesize()<=0){
			qryCarListDto.setPagesize(Constants.DEFAULT_PAGESIZE);
		}
		result.setSuccess(true);
		result.setMsg("验证成功");
		return;
	}
	
}
