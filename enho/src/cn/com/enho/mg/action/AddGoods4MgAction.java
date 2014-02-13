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
 * 新增车源
 * @author xionglei
 *
 */
@Controller
@RequestMapping("/mg")
public class AddGoods4MgAction {

	@Autowired
	private MgService mgService;
	
	static Logger logger = Logger.getLogger(AddGoods4MgAction.class.getName());
	
	@RequestMapping(value="/addGoodsPre")
	public ModelAndView addGoodsPre(GoodsDto goodsDto){
		ModelAndView mav=new ModelAndView();
		mav.addObject("gridid",goodsDto.getGridid());
		mav.setViewName("admin/goodsadd");
		return mav;
	}
	
	@RequestMapping(value="/addGoods")
	@ResponseBody 
	public MgResult addGoods(GoodsDto goodsDto){
		logger.debug("*********************************************后台_新增货源	start*********************************************");
		
		MgResult result=new MgResult();
		try{
			//表单验证
			validParam(goodsDto,result);
			//验证成功
			if(result.getSuccess()){
				this.mgService.addGoods(goodsDto, result);
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
	public void validParam(GoodsDto goodsDto,MgResult result){
		if(StringUtils.isEmpty(goodsDto.getStartp())){
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
		}else if(StringUtils.isEmpty(goodsDto.getSendtime())){
			result.setSuccess(false);
			result.setMsg("发货时间不能为空");
			return;
		}else if(StringUtils.isEmpty(goodsDto.getUsername())){
			result.setSuccess(false);
			result.setMsg("联系人姓名不能为空");
			return;
		}else if(StringUtils.isEmpty(goodsDto.getUserphone())){
			result.setSuccess(false);
			result.setMsg("联系人手机号不能为空");
			return;
		}else if(StringUtils.isEmpty(goodsDto.getUser())){
			result.setSuccess(false);
			result.setMsg("发布人手机不能为空");
			return;
		}else{
			result.setSuccess(true);
			result.setMsg("验证成功");
			return;
		}
	}
}
