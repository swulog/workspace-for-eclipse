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
import cn.com.enho.mg.dto.GoodsDto;
import cn.com.enho.mg.dto.QryGoodsListDto;
import cn.com.enho.mg.service.MgService;

/**
 * 		查询货源信息列表
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-9 下午2:25:52
 */
@Controller
@RequestMapping("/mg")
public class QryGoods4MgAction {

	@Autowired
	private MgService mgService;
	
	static Logger logger = Logger.getLogger(QryGoods4MgAction.class.getName());
	
	@RequestMapping(value="/qryGoodsList")
	@ResponseBody 
	public MgResult qryGoodsList(HttpServletRequest request,QryGoodsListDto qryGoodsListDto){
		logger.debug("*********************************************后台_查询货源信息列表	start*********************************************");
		
		MgResult result=new MgResult();
		try{
			//表单验证
			validParam(qryGoodsListDto,result);
			//验证成功
			if(result.getSuccess()){
				String baseurl=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+ request.getContextPath();
				qryGoodsListDto.setBaseurl(baseurl);
				this.mgService.qryGoodsList(qryGoodsListDto,result);
			}else{//验证失败
			}
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("查询异常");
			return result;
		}
		
	}
	
	@RequestMapping(value="/qryGoodsDtl")
	public ModelAndView qryGoodsDtl(GoodsDto goodsDto){
		logger.debug("*********************************************后台_查询货源详情	start*********************************************");
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
		mav.setViewName("admin/goodsdtl");
		return mav;
	}
	
	//表单验证
	public void validParam(QryGoodsListDto qryGoodsListDto,MgResult result){
		if(qryGoodsListDto.getPage()==null || qryGoodsListDto.getPage()<=0){
			qryGoodsListDto.setPage(Constants.DEFAULT_CURRENTPAGE);
		}
		if(qryGoodsListDto.getRows()==null || qryGoodsListDto.getRows()<=0){
			qryGoodsListDto.setRows(Constants.DEFAULT_PAGESIZE);
		}
		result.setSuccess(true);
		result.setMsg("验证成功");
		return;
	}
	
}
