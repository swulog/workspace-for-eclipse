package cn.com.enho.terminal.action;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.com.enho.comm.Result;
import cn.com.enho.comm.constants.Constants;
import cn.com.enho.terminal.dto.QryFocusUserListDto;
import cn.com.enho.terminal.service.FocusService;

/**
 * 		查询已关注用户列表
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-15 上午11:13:40
 */
@Controller
@RequestMapping("/terminal")
public class QryFocusUserListAction {

	@Autowired
	private FocusService focusService;
	
	static Logger logger = Logger.getLogger(QryFocusUserListAction.class.getName());
	
	
	@RequestMapping(value="/qryFocusUserList")
	@ResponseBody 
	public Result qryFocusUserList(QryFocusUserListDto qryFocusUserListDto){
		logger.debug("*********************************************查询已关注用户列表	start*********************************************");
		
		Result result=new Result();
		try{
			//表单验证
			validParam(qryFocusUserListDto,result);
			//验证成功
			if(result.getSuccess()){
				this.focusService.qryFocusUserList(qryFocusUserListDto,result);
			}else{//验证失败
			}
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("查询关注用户列表异常");
			return result;
		}
		
	}
	
	//表单验证
	public void validParam(QryFocusUserListDto qryFocusUserListDto,Result result){
		if(StringUtils.isEmpty(qryFocusUserListDto.getUserid())){
			result.setSuccess(false);
			result.setMsg("用户id不能为空");
			return;
		}else{
			if(qryFocusUserListDto.getCurrentpage()==null || qryFocusUserListDto.getCurrentpage()<=0){
				qryFocusUserListDto.setCurrentpage(Constants.DEFAULT_CURRENTPAGE);
			}
			if(qryFocusUserListDto.getPagesize()==null || qryFocusUserListDto.getPagesize()<=0){
				qryFocusUserListDto.setPagesize(Constants.DEFAULT_PAGESIZE);
			}
			result.setSuccess(true);
			result.setMsg("验证成功");
			return;
		}
	}
}
