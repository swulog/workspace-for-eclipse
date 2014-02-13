package cn.com.enho.mg.action;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.com.enho.comm.MgResult;
import cn.com.enho.comm.constants.Constants;
import cn.com.enho.mg.dto.CarDto;
import cn.com.enho.mg.dto.QryCarListDto;
import cn.com.enho.mg.service.MgService;

/**
 * 		查询车源信息列表
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-12 上午10:06:39
 */
@Controller
@RequestMapping("/mg")
public class QryCar4MgAction {

	@Autowired
	private MgService mgService;
	
	static Logger logger = Logger.getLogger(QryCar4MgAction.class.getName());
	
	
	@RequestMapping(value="/qryCarList")
	@ResponseBody 
	public MgResult qryCarList(HttpServletRequest request,QryCarListDto qryCarListDto){
		logger.debug("*********************************************后台_查询车源信息列表	start*********************************************");
		
		MgResult result=new MgResult();
		try{
			//表单验证
			validParam(qryCarListDto,result);
			//验证成功
			if(result.getSuccess()){
				String baseurl=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+ request.getContextPath();
				qryCarListDto.setBaseurl(baseurl);
				this.mgService.qryCarList(qryCarListDto, result);
			}else{//验证失败
			}
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("查询出现异常");
			return result;
		}
		
	}
	
	@RequestMapping(value="/qryCarDtl")
	public ModelAndView qryCarDtl(CarDto carDto){
		logger.debug("*********************************************后台_查询车源详情	start*********************************************");
		ModelAndView mav=new ModelAndView();
		mav.addObject("startp", carDto.getStartp());
		mav.addObject("startc", carDto.getStartc());
		mav.addObject("startd", carDto.getStartd());
		mav.addObject("endp", carDto.getEndp());
		mav.addObject("endc", carDto.getEndc());
		mav.addObject("endd", carDto.getEndd());
		mav.addObject("weight", carDto.getWeight());
		mav.addObject("carlength", carDto.getCarlength());
		mav.addObject("username", carDto.getUsername());
		mav.addObject("userphone", carDto.getUserphone());
		mav.addObject("usertel", carDto.getUsertel());
		mav.addObject("status", carDto.getStatus());
		mav.addObject("createtime", carDto.getCreatetime());
		mav.addObject("lastupdatetime", carDto.getLastupdatetime());
		mav.addObject("id", carDto.getId());
		//mav.addObject("image", carDto.getImage());
		mav.addObject("desc", carDto.getDesc());
		mav.addObject("sendtime", carDto.getSendtime());
		mav.addObject("userid", carDto.getUserid());
		mav.addObject("longitude", carDto.getLongitude());
		mav.addObject("latitude", carDto.getLatitude());
		mav.addObject("remark", carDto.getRemark());
		mav.addObject("infotype", carDto.getInfotype());
		mav.addObject("carno", carDto.getCarno());
		mav.setViewName("admin/cardtl");
		return mav;
	}
	
	
	//表单验证
	public void validParam(QryCarListDto qryCarListDto,MgResult result){
		if(qryCarListDto.getPage()==null || qryCarListDto.getPage()<=0){
			qryCarListDto.setRows(Constants.DEFAULT_CURRENTPAGE);
		}
		if(qryCarListDto.getRows()==null || qryCarListDto.getRows()<=0){
			qryCarListDto.setRows(Constants.DEFAULT_PAGESIZE);
		}
		result.setSuccess(true);
		result.setMsg("验证成功");
		return;
	}
	
}
