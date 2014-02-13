package cn.com.enho.terminal.action;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.com.enho.comm.Result;
import cn.com.enho.comm.constants.Constants;
import cn.com.enho.terminal.dto.QryCollectCarListDto;
import cn.com.enho.terminal.service.CollectCarService;

/**
 * 		查询收藏的车源信息列表
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-15 下午2:40:48
 */
@Controller
@RequestMapping("/terminal")
public class QryCollectCarListAction {

	@Autowired
	private CollectCarService collectCarService;
	
	static Logger logger = Logger.getLogger(QryCollectCarListAction.class.getName());
	
	
	@RequestMapping(value="/qryCollectCarList")
	@ResponseBody 
	public Result qryCollectCarList(QryCollectCarListDto qryCollectCarListDto){
		logger.debug("*********************************************查询收藏的车源信息列表	start*********************************************");
		
		Result result=new Result();
		try{
			//表单验证
			validParam(qryCollectCarListDto,result);
			//验证成功
			if(result.getSuccess()){
				this.collectCarService.qryCollectCarList(qryCollectCarListDto,result);
			}else{//验证失败
			}
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("查询收藏的车源信息列表出现异常");
			return result;
		}
		
	}
	
	//表单验证
	public void validParam(QryCollectCarListDto qryCollectCarListDto,Result result){
		if(StringUtils.isEmpty(qryCollectCarListDto.getUserid())){
			result.setSuccess(false);
			result.setMsg("用户id不能为空");
			return;
		}else{
			if(qryCollectCarListDto.getCurrentpage()==null || qryCollectCarListDto.getCurrentpage()<=0){
				qryCollectCarListDto.setCurrentpage(Constants.DEFAULT_CURRENTPAGE);
			}
			if(qryCollectCarListDto.getPagesize()==null || qryCollectCarListDto.getPagesize()<=0){
				qryCollectCarListDto.setPagesize(Constants.DEFAULT_PAGESIZE);
			}
			result.setSuccess(true);
			result.setMsg("验证成功");
			return;
		}
	}
}
