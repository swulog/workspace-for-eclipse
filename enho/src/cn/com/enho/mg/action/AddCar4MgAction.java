package cn.com.enho.mg.action;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.com.enho.comm.MgResult;
import cn.com.enho.mg.dto.CarDto;
import cn.com.enho.mg.service.MgService;

/**
 * 新增车源
 * @author xionglei
 *
 */
@Controller
@RequestMapping("/mg")
public class AddCar4MgAction {

	@Autowired
	private MgService mgService;
	
	static Logger logger = Logger.getLogger(AddCar4MgAction.class.getName());
	
	@RequestMapping(value="/addCarPre")
	public ModelAndView addCarPre(CarDto carDto){
		ModelAndView mav=new ModelAndView();
		mav.addObject("gridid",carDto.getGridid());
		mav.setViewName("admin/caradd");
		return mav;
	}
	
	@RequestMapping(value="/addCar")
	@ResponseBody 
	public MgResult addCar(CarDto carDto){
		logger.debug("*********************************************后台_新增车源	start*********************************************");
		
		MgResult result=new MgResult();
		try{
			//表单验证
			validParam(carDto,result);
			//验证成功
			if(result.getSuccess()){
				this.mgService.addCar(carDto, result);
			}else{//验证失败
			}
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("新增出现异常");
			return result;
		}
		
	}
	
	//表单验证
	public void validParam(CarDto carDto,MgResult result){
		if(StringUtils.isEmpty(carDto.getStartp())){
			result.setSuccess(false);
			result.setMsg("出发地（省）不能为空");
			return;
		}else if(StringUtils.isEmpty(carDto.getEndp())){
			result.setSuccess(false);
			result.setMsg("到达地（省）不能为空");
			return;
		}else if(StringUtils.isEmpty(carDto.getCarno())){
			result.setSuccess(false);
			result.setMsg("车牌号不能为空");
			return;
		}else if(StringUtils.isEmpty(carDto.getDesc())){
			result.setSuccess(false);
			result.setMsg("车源信息描述不能为空");
			return;
		}else if(StringUtils.isEmpty(carDto.getWeight())){
			result.setSuccess(false);
			result.setMsg("载重不能为空");
			return;
		}else if(StringUtils.isEmpty(carDto.getCarlength())){
			result.setSuccess(false);
			result.setMsg("车长不能为空");
			return;
		}else if(StringUtils.isEmpty(carDto.getSendtime())){
			result.setSuccess(false);
			result.setMsg("出车时间不能为空");
			return;
		}else if(StringUtils.isEmpty(carDto.getUsername())){
			result.setSuccess(false);
			result.setMsg("联系人姓名不能为空");
			return;
		}else if(StringUtils.isEmpty(carDto.getUserphone())){
			result.setSuccess(false);
			result.setMsg("联系人手机号不能为空");
			return;
		}else if(StringUtils.isEmpty(carDto.getUserid())){
			result.setSuccess(false);
			result.setMsg("发布人id不能为空");
			return;
		}else{
			result.setSuccess(true);
			result.setMsg("验证成功");
			return;
		}
	}
}
