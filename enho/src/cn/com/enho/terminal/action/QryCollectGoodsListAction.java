package cn.com.enho.terminal.action;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.com.enho.comm.Result;
import cn.com.enho.comm.constants.Constants;
import cn.com.enho.terminal.dto.QryCollectGoodsListDto;
import cn.com.enho.terminal.service.CollectGoodsService;

/**
 * 		查询收藏的货源信息列表
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-15 下午2:40:28
 */
@Controller
@RequestMapping("/terminal")
public class QryCollectGoodsListAction {

	@Autowired
	private CollectGoodsService collectGoodsService;
	
	static Logger logger = Logger.getLogger(QryCollectGoodsListAction.class.getName());
	
	
	@RequestMapping(value="/qryCollectGoodsList")
	@ResponseBody 
	public Result qryCollectGoodsList(QryCollectGoodsListDto qryCollectGoodsListDto){
		logger.debug("*********************************************查询收藏的货源信息列表	start*********************************************");
		
		Result result=new Result();
		try{
			//表单验证
			validParam(qryCollectGoodsListDto,result);
			//验证成功
			if(result.getSuccess()){
				this.collectGoodsService.qryCollectGoodsList(qryCollectGoodsListDto,result);
			}else{//验证失败
			}
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("查询收藏的货源信息列表出现异常");
			return result;
		}
		
	}
	
	//表单验证
	public void validParam(QryCollectGoodsListDto qryCollectGoodsListDto,Result result){
		if(StringUtils.isEmpty(qryCollectGoodsListDto.getUserid())){
			result.setSuccess(false);
			result.setMsg("用户id不能为空");
			return;
		}else{
			if(qryCollectGoodsListDto.getCurrentpage()==null || qryCollectGoodsListDto.getCurrentpage()<=0){
				qryCollectGoodsListDto.setCurrentpage(Constants.DEFAULT_CURRENTPAGE);
			}
			if(qryCollectGoodsListDto.getPagesize()==null || qryCollectGoodsListDto.getPagesize()<=0){
				qryCollectGoodsListDto.setPagesize(Constants.DEFAULT_PAGESIZE);
			}
			result.setSuccess(true);
			result.setMsg("验证成功");
			return;
		}
	}
}
