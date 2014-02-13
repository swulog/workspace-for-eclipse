package cn.com.enho.terminal.action;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.com.enho.comm.Result;
import cn.com.enho.comm.constants.Constants;
import cn.com.enho.comm.util.StringUtil;
import cn.com.enho.terminal.dto.QryUserList4NearDto;
import cn.com.enho.terminal.service.UserService;

/**
 * 		查询附近的用户信息列表
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-13 上午11:14:23
 */
@Controller
@RequestMapping("/terminal")
public class QryUserList4NearAction {

	@Autowired
	private UserService userService;
	
	static Logger logger = Logger.getLogger(QryUserList4NearAction.class.getName());
	
	
	@RequestMapping(value="/qryUserList4Near")
	@ResponseBody 
	public Result qryUserList4Near(QryUserList4NearDto qryUserList4NearDto){
		logger.debug("*********************************************查询附近的用户信息列表	start*********************************************");
		
		Result result=new Result();
		try{
			//表单验证
			validParam(qryUserList4NearDto,result);
			//验证成功
			if(result.getSuccess()){
				this.userService.qryUserList4Near(qryUserList4NearDto,result);
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
	public void validParam(QryUserList4NearDto qryUserList4NearDto,Result result){
		if(StringUtil.nullToDouble(qryUserList4NearDto.getLongitude())==0 || StringUtil.nullToDouble(qryUserList4NearDto.getLatitude())==0){
			result.setSuccess(false);
			result.setMsg("没有获取到当前位置");
			return;
		}else if(StringUtils.isEmpty(qryUserList4NearDto.getUsertype())){
			result.setSuccess(false);
			result.setMsg("用户类型不能为空");
			return;
		}else if(qryUserList4NearDto.getUsertype()!=Constants.USER_GE && qryUserList4NearDto.getUsertype()!=Constants.USER_GP && qryUserList4NearDto.getUsertype()!=Constants.USER_CE && qryUserList4NearDto.getUsertype()!=Constants.USER_CP){
			result.setSuccess(false);
			result.setMsg("用户类型不正确");
			return;
		}else{
			if(qryUserList4NearDto.getFlag()==null || qryUserList4NearDto.getFlag()==2){//分页
				if(qryUserList4NearDto.getCurrentpage()==null || qryUserList4NearDto.getCurrentpage()<=0){
					qryUserList4NearDto.setCurrentpage(Constants.DEFAULT_CURRENTPAGE);
				}
				if(qryUserList4NearDto.getPagesize()==null || qryUserList4NearDto.getPagesize()<=0){
					qryUserList4NearDto.setPagesize(Constants.DEFAULT_PAGESIZE);
				}
			}
			
			result.setSuccess(true);
			result.setMsg("验证成功");
			return;
		}
	}
}
