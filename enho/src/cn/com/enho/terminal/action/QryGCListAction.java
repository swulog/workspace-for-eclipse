package cn.com.enho.terminal.action;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.com.enho.comm.Result;
import cn.com.enho.comm.constants.Constants;
import cn.com.enho.terminal.dto.QryGCListDto;
import cn.com.enho.terminal.service.CommService;

/**
 * 查询附近的货源车源列表
 * @author xionglei
 *
 */
@Controller
@RequestMapping("/comm")
public class QryGCListAction {

	@Autowired
	private CommService commService;
	
	static Logger logger = Logger.getLogger(QryGCListAction.class.getName());
	
	
	@RequestMapping(value="/qryGCList")
	@ResponseBody 
	public Result qryGCList(HttpServletRequest request,QryGCListDto qryGCListDto){
		logger.debug("*********************************************查询车源货源信息列表	start*********************************************");
		
		Result result=new Result();
		try{
			//表单验证
			validParam(qryGCListDto,result);
			//验证成功
			if(result.getSuccess()){
				String baseurl=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+ request.getContextPath();
				this.commService.qryGCList(qryGCListDto,baseurl,result);
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
	public void validParam(QryGCListDto qryGCListDto,Result result){
		if(qryGCListDto.getCurrentpage()==null || qryGCListDto.getCurrentpage()<=0){
			qryGCListDto.setCurrentpage(Constants.DEFAULT_CURRENTPAGE);
		}
		if(qryGCListDto.getPagesize()==null || qryGCListDto.getPagesize()<=0){
			qryGCListDto.setPagesize(Constants.DEFAULT_PAGESIZE);
		}
		result.setSuccess(true);
		result.setMsg("验证成功");
		return;
	}
}
