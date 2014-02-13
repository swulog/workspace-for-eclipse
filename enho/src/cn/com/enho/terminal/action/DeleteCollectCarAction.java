package cn.com.enho.terminal.action;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.com.enho.comm.Result;
import cn.com.enho.terminal.service.CollectCarService;

/**
 * 		删除已收藏的车源信息
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-15 下午2:41:29
 */
@Controller
@RequestMapping("/terminal")
public class DeleteCollectCarAction {

	@Autowired
	private CollectCarService collectCarService;
	
	static Logger logger = Logger.getLogger(DeleteCollectCarAction.class.getName());
	
	
	@RequestMapping(value="/deleteCollectCar")
	@ResponseBody 
	public Result deleteCollectCar(String user_car_collectid){
		logger.debug("*********************************************查询收藏的车源信息列表	start*********************************************");
		
		Result result=new Result();
		try{
			//表单验证
			validParam(user_car_collectid,result);
			//验证成功
			if(result.getSuccess()){
				this.collectCarService.deleteCollectCar(user_car_collectid,result);
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
	public void validParam(String user_car_collectid,Result result){
		if(StringUtils.isEmpty(user_car_collectid)){
			result.setSuccess(false);
			result.setMsg("关系id不能为空");
			return;
		}else{
			result.setSuccess(true);
			result.setMsg("验证成功");
			return;
		}
	}
}
