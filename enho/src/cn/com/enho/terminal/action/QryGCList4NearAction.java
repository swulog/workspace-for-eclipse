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
import cn.com.enho.terminal.dto.QryGCList4NearDto;
import cn.com.enho.terminal.service.CommService;

/**
 * 查询附近的货源车源列表
 * @author xionglei
 *
 */
@Controller
@RequestMapping("/comm")
public class QryGCList4NearAction {

	@Autowired
	private CommService commService;
	
	static Logger logger = Logger.getLogger(QryGCList4NearAction.class.getName());
	
	
	@RequestMapping(value="/qryGCList4Near")
	@ResponseBody 
	public Result qryGCList4Near(HttpServletRequest request,QryGCList4NearDto qryGCList4NearDto){
		logger.debug("*********************************************查询附近的车源货源信息列表	start*********************************************");
		
		Result result=new Result();
		try{
			//表单验证
			validParam(qryGCList4NearDto,result);
			//验证成功
			if(result.getSuccess()){
				String baseurl=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+ request.getContextPath();
				this.commService.qryGCList4Near(qryGCList4NearDto,baseurl,result);
			}else{//验证失败
			}
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("查询出现异常");
			return result;
		}
		
	}
	
	//表单验证
	public void validParam(QryGCList4NearDto qryGCList4NearDto,Result result){
		if(StringUtil.nullToDouble(qryGCList4NearDto.getLongitude())==0 || StringUtil.nullToDouble(qryGCList4NearDto.getLatitude())==0){
			result.setSuccess(false);
			result.setMsg("没有获取到当前位置");
			return;
		}else{
			if(qryGCList4NearDto.getFlag()==null || qryGCList4NearDto.getFlag()==Constants.PAGING){//分页
				if(qryGCList4NearDto.getCurrentpage()==null || qryGCList4NearDto.getCurrentpage()<=0){
					qryGCList4NearDto.setCurrentpage(Constants.DEFAULT_CURRENTPAGE);
				}
				if(qryGCList4NearDto.getPagesize()==null || qryGCList4NearDto.getPagesize()<=0){
					qryGCList4NearDto.setPagesize(Constants.DEFAULT_PAGESIZE);
				}
			}
			
			result.setSuccess(true);
			result.setMsg("验证成功");
			return;
		}
	}
}
