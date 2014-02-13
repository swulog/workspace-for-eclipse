package cn.com.enho.terminal.action;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.com.enho.comm.Result;
import cn.com.enho.terminal.service.CollectGoodsService;

/**
 * 		收藏货源信息
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-15 下午2:40:00
 */
@Controller
@RequestMapping("/terminal")
public class CollectGoodsAction {

	@Autowired
	private CollectGoodsService collectGoodsService;
	
	static Logger logger = Logger.getLogger(CollectGoodsAction.class.getName());
	
	
	@RequestMapping(value="/collectGoods")
	@ResponseBody 
	public Result collectGoods(@RequestParam String userid,@RequestParam String goodsid){
		logger.debug("*********************************************收藏货源信息	start*********************************************");
		
		Result result=new Result();
		try{
			//表单验证
			validParam(userid,goodsid,result);
			//验证成功
			if(result.getSuccess()){
				this.collectGoodsService.addCollectGoods(userid,goodsid,result);
			}else{//验证失败
			}
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("收藏货源信息出现异常");
			return result;
		}
		
	}
	
	//表单验证
	public void validParam(String userid,String goodsid,Result result){
		if(StringUtils.isEmpty(userid)){
			result.setSuccess(false);
			result.setMsg("用户id不能为空");
			return;
		}else if(StringUtils.isEmpty(goodsid)){
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
