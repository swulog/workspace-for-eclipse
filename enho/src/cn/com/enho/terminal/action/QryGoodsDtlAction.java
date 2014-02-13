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
import cn.com.enho.terminal.service.GoodsService;

/**
 * 		查询货源信息详情
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-9 下午3:39:57
 */
@Controller
@RequestMapping("/comm")
public class QryGoodsDtlAction {

	@Autowired
	private GoodsService goodsService;
	
	static Logger logger = Logger.getLogger(QryGoodsDtlAction.class.getName());
	
	
	@RequestMapping(value="/qryGoodsDtl")
	@ResponseBody 
	public Result qryGoodsDtl(HttpServletRequest request,@RequestParam String goodsid){
		logger.debug("*********************************************查询货源信息详情	start*********************************************");
		
		Result result=new Result();
		try{
			//表单验证
			validParam(goodsid,result);
			//验证成功
			if(result.getSuccess()){
				String baseurl=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+ request.getContextPath();
				this.goodsService.qryGoodsDtl(goodsid,baseurl,result);
			}else{//验证失败
			}
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("货源信息详情查询出现异常");
			return result;
		}
		
	}
	
	//表单验证
	public void validParam(String goodsid,Result result){
		if(StringUtils.isEmpty(goodsid)){
			result.setSuccess(false);
			result.setMsg("货源信息id不能为空");
			return;
		}else{
			result.setSuccess(true);
			result.setMsg("验证成功");
			return;
		}
	}
}
