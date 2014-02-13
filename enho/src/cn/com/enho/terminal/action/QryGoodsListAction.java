package cn.com.enho.terminal.action;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.com.enho.comm.Result;
import cn.com.enho.comm.constants.Constants;
import cn.com.enho.terminal.dto.QryGoodsListDto;
import cn.com.enho.terminal.service.GoodsService;

/**
 * 		查询货源信息列表
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-9 下午2:25:52
 */
@Controller
@RequestMapping("/comm")
public class QryGoodsListAction {

	@Autowired
	private GoodsService goodsService;
	
	static Logger logger = Logger.getLogger(QryGoodsListAction.class.getName());
	
	@RequestMapping(value="/qryGoodsList")
	@ResponseBody 
	public Result qryGoodsList(HttpServletRequest request,QryGoodsListDto qryGoodsListDto){
		logger.debug("*********************************************查询货源信息列表	start*********************************************");
		
		Result result=new Result();
		try{
			//表单验证
			validParam(qryGoodsListDto,result);
			//验证成功
			if(result.getSuccess()){
				String baseurl=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+ request.getContextPath();
				qryGoodsListDto.setBaseurl(baseurl);
				this.goodsService.qryGoodsList(qryGoodsListDto,result);
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
	
	//表单验证
	public void validParam(QryGoodsListDto qryGoodsListDto,Result result){
		if(qryGoodsListDto.getCurrentpage()==null || qryGoodsListDto.getCurrentpage()<=0){
			qryGoodsListDto.setCurrentpage(Constants.DEFAULT_CURRENTPAGE);
		}
		if(qryGoodsListDto.getPagesize()==null || qryGoodsListDto.getPagesize()<=0){
			qryGoodsListDto.setPagesize(Constants.DEFAULT_PAGESIZE);
		}
		result.setSuccess(true);
		result.setMsg("验证成功");
		return;
	}
	
}
