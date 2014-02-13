package cn.com.enho.mg.action;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.com.enho.comm.MgResult;
import cn.com.enho.mg.dto.GoodsDto;
import cn.com.enho.mg.service.MgService;

/**
 * 修改货源
 * 
 * @author xionglei
 *
 */
@Controller
@RequestMapping("/mg")
public class UpdateGoods4MgAction {

	@Autowired
	private MgService mgService;
	
	static Logger logger = Logger.getLogger(UpdateGoods4MgAction.class.getName());
	
	@RequestMapping(value="/updateGoodsPre")
	public ModelAndView updateGoodsPre(GoodsDto goodsDto){
		logger.debug("*********************************************后台_修改用户信息页面加载	start*********************************************");
		ModelAndView mav=new ModelAndView();
		mav.addObject("startp", goodsDto.getStartp());
		mav.addObject("startc", goodsDto.getStartc());
		mav.addObject("startd", goodsDto.getStartd());
		mav.addObject("endp", goodsDto.getEndp());
		mav.addObject("endc", goodsDto.getEndc());
		mav.addObject("endd", goodsDto.getEndd());
		mav.addObject("weight", goodsDto.getWeight());
		mav.addObject("carlength", goodsDto.getCarlength());
		mav.addObject("username", goodsDto.getUsername());
		mav.addObject("userphone", goodsDto.getUserphone());
		mav.addObject("usertel", goodsDto.getUsertel());
		mav.addObject("status", goodsDto.getStatus());
		mav.addObject("createtime", goodsDto.getCreatetime());
		mav.addObject("lastupdatetime", goodsDto.getLastupdatetime());
		mav.addObject("id", goodsDto.getId());
		//mav.addObject("image", goodsDto.getImage());
		mav.addObject("desc", goodsDto.getDesc());
		mav.addObject("sendtime", goodsDto.getSendtime());
		mav.addObject("userid", goodsDto.getUserid());
		mav.addObject("longitude", goodsDto.getLongitude());
		mav.addObject("latitude", goodsDto.getLatitude());
		mav.addObject("remark", goodsDto.getRemark());
		mav.addObject("infotype", goodsDto.getInfotype());
		mav.setViewName("admin/goodsupdate");
		return mav;
	}
	
	
	@RequestMapping(value="/updateGoods")
	@ResponseBody 
	public MgResult updateGoods(GoodsDto goodsDto){
		logger.debug("*********************************************后台_修改用户信息	start*********************************************");
		
		MgResult result=new MgResult();
		try{
			//表单验证
			validParam(goodsDto,result);
			//验证成功
			if(result.getSuccess()){
				this.mgService.updateGoods(goodsDto, result);
			}else{//验证失败
			}
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("修改出现异常");
			return result;
		}
		
	}
	
	//表单验证
	public void validParam(GoodsDto goodsDto,MgResult result){
		if(StringUtils.isEmpty(goodsDto.getId())){
			result.setSuccess(false);
			result.setMsg("货源信息id不能为空");
			return;
		}else if(StringUtils.isEmpty(goodsDto.getStartp())){
			result.setSuccess(false);
			result.setMsg("出发地（省）不能为空");
			return;
		}else if(StringUtils.isEmpty(goodsDto.getEndp())){
			result.setSuccess(false);
			result.setMsg("到达地（省）不能为空");
			return;
		}else if(StringUtils.isEmpty(goodsDto.getDesc())){
			result.setSuccess(false);
			result.setMsg("货源描述不能为空");
			return;
		}else if(StringUtils.isEmpty(goodsDto.getWeight())){
			result.setSuccess(false);
			result.setMsg("货源重量不能为空");
			return;
		}else if(StringUtils.isEmpty(goodsDto.getCarlength())){
			result.setSuccess(false);
			result.setMsg("所需车长不能为空");
			return;
		}else if(StringUtils.isEmpty(goodsDto.getUsername())){
			result.setSuccess(false);
			result.setMsg("联系人姓名不能为空");
			return;
		}else if(StringUtils.isEmpty(goodsDto.getUserphone())){
			result.setSuccess(false);
			result.setMsg("联系人手机号不能为空");
			return;
		}else{
			result.setSuccess(true);
			result.setMsg("验证成功");
			return;
		}
	}
}
