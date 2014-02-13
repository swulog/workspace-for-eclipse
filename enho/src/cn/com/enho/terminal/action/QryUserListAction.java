package cn.com.enho.terminal.action;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.com.enho.comm.Result;
import cn.com.enho.comm.constants.Constants;
import cn.com.enho.terminal.dto.QryUserListDto;
import cn.com.enho.terminal.service.UserService;

/**
 * 		查询用户列表
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-14 上午10:22:21
 */
@Controller
@RequestMapping("/terminal")
public class QryUserListAction {

	@Autowired
	private UserService userService;
	
	static Logger logger = Logger.getLogger(QryUserListAction.class.getName());
	
	
	@RequestMapping(value="/qryUserList")
	@ResponseBody 
	public Result qryUserList(QryUserListDto qryUserListDto){
		logger.debug("*********************************************查询用户信息列表	start*********************************************");
		
		Result result=new Result();
		try{
			//表单验证
			validParam(qryUserListDto,result);
			//验证成功
			if(result.getSuccess()){
				this.userService.qryUserList(qryUserListDto,result);
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
	public void validParam(QryUserListDto qryUserListDto,Result result){
		if(StringUtils.isEmpty(qryUserListDto.getUsertype())){
			result.setSuccess(false);
			result.setMsg("用户类型不能为空");
			return;
		}else if(qryUserListDto.getUsertype()!=Constants.USER_GE && qryUserListDto.getUsertype()!=Constants.USER_GP && qryUserListDto.getUsertype()!=Constants.USER_CE && qryUserListDto.getUsertype()!=Constants.USER_CP){
			result.setSuccess(false);
			result.setMsg("用户类型不正确");
			return;
		}else{
			if(qryUserListDto.getCurrentpage()==null || qryUserListDto.getCurrentpage()<=0){
				qryUserListDto.setCurrentpage(Constants.DEFAULT_CURRENTPAGE);
			}
			if(qryUserListDto.getPagesize()==null || qryUserListDto.getPagesize()<=0){
				qryUserListDto.setPagesize(Constants.DEFAULT_PAGESIZE);
			}
			result.setSuccess(true);
			result.setMsg("验证成功");
			return;
		}
	}
}
