package cn.com.enho.terminal.action;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.com.enho.comm.Result;
import cn.com.enho.comm.constants.Constants;
import cn.com.enho.terminal.dto.QryBacklogDto;
import cn.com.enho.terminal.service.BusService;

/**
 * 		查询待确认交易
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-9-2 下午1:58:39
 */
@Controller
@RequestMapping("/terminal")
public class QryBacklogAction {

	@Autowired
	private BusService busService;
	
	static Logger logger = Logger.getLogger(QryBacklogAction.class.getName());
	
	
	@RequestMapping(value="/qryBacklog")
	@ResponseBody 
	public Result qryBacklog(QryBacklogDto qryBacklogDto){
		logger.debug("*********************************************查询待确认交易	start*********************************************");
		
		Result result=new Result();
		try{
			//表单验证
			validParam(qryBacklogDto,result);
			//验证成功
			if(result.getSuccess()){
				this.busService.qryBacklog(qryBacklogDto,result);
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
	public void validParam(QryBacklogDto qryBacklogDto,Result result){
		if(StringUtils.isEmpty(qryBacklogDto.getUserid())){
			result.setSuccess(false);
			result.setMsg("用户id不能为空");
			return;
		}else if(StringUtils.isEmpty(qryBacklogDto.getUsertype())){
			result.setSuccess(false);
			result.setMsg("用户类型不能为空");
			return;
		}else if(qryBacklogDto.getUsertype()!=Constants.USER_GE && qryBacklogDto.getUsertype()!=Constants.USER_GP && qryBacklogDto.getUsertype()!=Constants.USER_CE && qryBacklogDto.getUsertype()!=Constants.USER_CP){
			result.setSuccess(false);
			result.setMsg("用户类型不正确");
			return;
		}else{
			if(qryBacklogDto.getCurrentpage()==null || qryBacklogDto.getCurrentpage()<=0){
				qryBacklogDto.setCurrentpage(Constants.DEFAULT_CURRENTPAGE);
			}
			if(qryBacklogDto.getPagesize()==null || qryBacklogDto.getPagesize()<=0){
				qryBacklogDto.setPagesize(Constants.DEFAULT_PAGESIZE);
			}
			result.setSuccess(true);
			result.setMsg("验证成功");
			return;
		}
	}
}
