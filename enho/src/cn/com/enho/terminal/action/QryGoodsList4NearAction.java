package cn.com.enho.terminal.action;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.com.enho.comm.Result;
import cn.com.enho.comm.constants.Constants;
import cn.com.enho.comm.util.StringUtil;
import cn.com.enho.terminal.dto.QryGoodsList4NearDto;
import cn.com.enho.terminal.service.GoodsService;

/**
 * 		查询附近的货源信息列表
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-12 下午4:46:48
 */
@Controller
@RequestMapping("/comm")
public class QryGoodsList4NearAction {

	@Autowired
	private GoodsService goodsService;
	
	static Logger logger = Logger.getLogger(QryGoodsList4NearAction.class.getName());
	
	
	@RequestMapping(value="/qryGoodsList4Near")
	@ResponseBody 
	public Result qryGoodsList4Near(HttpServletRequest request,QryGoodsList4NearDto qryGoodsList4NearDto){
		logger.debug("*********************************************查询附近的货源信息列表	start*********************************************");
		
		Result result=new Result();
		try{
			//表单验证
			validParam(qryGoodsList4NearDto,result);
			//验证成功
			if(result.getSuccess()){
				String baseurl=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+ request.getContextPath();
				qryGoodsList4NearDto.setBaseurl(baseurl);
				this.goodsService.qryGoodsList4Near(qryGoodsList4NearDto,result);
			}else{//验证失败
			}
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("附近的货源列表查询出现异常");
			return result;
		}
		
	}
	
	//表单验证
	public void validParam(QryGoodsList4NearDto qryGoodsList4NearDto,Result result){
		if(StringUtil.nullToDouble(qryGoodsList4NearDto.getLongitude())==0 || StringUtil.nullToDouble(qryGoodsList4NearDto.getLatitude())==0){
			result.setSuccess(false);
			result.setMsg("没有获取到当前位置");
			return;
		}else{
			if(qryGoodsList4NearDto.getFlag()==null || qryGoodsList4NearDto.getFlag()==Constants.PAGING){//分页
				if(qryGoodsList4NearDto.getCurrentpage()==null || qryGoodsList4NearDto.getCurrentpage()<=0){
					qryGoodsList4NearDto.setCurrentpage(Constants.DEFAULT_CURRENTPAGE);
				}
				if(qryGoodsList4NearDto.getPagesize()==null || qryGoodsList4NearDto.getPagesize()<=0){
					qryGoodsList4NearDto.setPagesize(Constants.DEFAULT_PAGESIZE);
				}
			}
			
			result.setSuccess(true);
			result.setMsg("验证成功");
			return;
		}
	}
	
}
