package cn.com.enho.terminal.action;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.com.enho.comm.Result;
import cn.com.enho.terminal.service.GoodsService;

/**
 * 		删除货源信息
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-9 下午4:43:23
 */
@Controller
@RequestMapping("/terminal")
public class DelGoodsAction {

	@Autowired
	private GoodsService goodsService;
	
	static Logger logger = Logger.getLogger(DelGoodsAction.class.getName());
	
	
	@SuppressWarnings("deprecation")
	@RequestMapping(value="/deleteGoods")
	@ResponseBody 
	public Result deleteGoods(HttpServletRequest request,String goodsid){
		logger.debug("*********************************************删除货源信息	start*********************************************");
		
		Result result=new Result();
		try{
			//表单验证
			validParam(goodsid,result);
			//验证成功
			if(result.getSuccess()){
				String desdir=request.getServletContext().getAttribute("goodsimg").toString();//目标目录
				desdir=request.getRealPath(desdir);//绝对路径
				this.goodsService.deleteGoods(goodsid,desdir,result);
			}else{//验证失败
			}
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("删除异常");
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
