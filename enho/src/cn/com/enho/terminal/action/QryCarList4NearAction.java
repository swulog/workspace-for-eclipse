package cn.com.enho.terminal.action;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.com.enho.comm.Result;
import cn.com.enho.comm.constants.Constants;
import cn.com.enho.comm.util.StringUtil;
import cn.com.enho.terminal.dto.QryCarList4NearDto;
import cn.com.enho.terminal.service.CarService;

/**
 * 		查询附近的车源信息列表
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-13 上午10:27:38
 */
@Controller
@RequestMapping("/comm")
public class QryCarList4NearAction {

	@Autowired
	private CarService carService;
	
	static Logger logger = Logger.getLogger(QryCarList4NearAction.class.getName());
	
	
	@RequestMapping(value="/qryCarList4Near")
	@ResponseBody 
	public Result qryCarList4Near(HttpServletRequest request,QryCarList4NearDto qryCarList4NearDto){
		logger.debug("*********************************************查询附近的车源信息列表	start*********************************************");
		
		Result result=new Result();
		try{
			//表单验证
			validParam(qryCarList4NearDto,result);
			//验证成功
			if(result.getSuccess()){
				String baseurl=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+ request.getContextPath();
				qryCarList4NearDto.setBaseurl(baseurl);
				this.carService.qryCarList4Near(qryCarList4NearDto,result);
			}else{//验证失败
			}
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("附近的车源列表查询出现异常");
			return result;
		}
		
	}
	
	//表单验证
	public void validParam(QryCarList4NearDto qryCarList4NearDto,Result result){
		if(StringUtil.nullToDouble(qryCarList4NearDto.getLongitude())==0 || StringUtil.nullToDouble(qryCarList4NearDto.getLatitude())==0){
			result.setSuccess(false);
			result.setMsg("没有获取到当前位置");
			return;
		}else{
			if(qryCarList4NearDto.getFlag()==null || qryCarList4NearDto.getFlag()==Constants.PAGING){//分页
				if(qryCarList4NearDto.getCurrentpage()==null || qryCarList4NearDto.getCurrentpage()<=0){
					qryCarList4NearDto.setCurrentpage(Constants.DEFAULT_CURRENTPAGE);
				}
				if(qryCarList4NearDto.getPagesize()==null || qryCarList4NearDto.getPagesize()<=0){
					qryCarList4NearDto.setPagesize(Constants.DEFAULT_PAGESIZE);
				}
			}
			
			result.setSuccess(true);
			result.setMsg("验证成功");
			return;
		}
	}
}
