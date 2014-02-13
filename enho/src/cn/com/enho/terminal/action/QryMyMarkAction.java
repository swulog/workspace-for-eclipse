package cn.com.enho.terminal.action;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.com.enho.comm.Result;
import cn.com.enho.comm.constants.Constants;
import cn.com.enho.terminal.dto.QryMyMarkDto;
import cn.com.enho.terminal.service.BusService;

/**
 * 		查询给我评分的记录（车主）
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-25 下午3:19:17
 */
@Controller
@RequestMapping("/terminal")
public class QryMyMarkAction {

	@Autowired
	private BusService busService;
	
	static Logger logger = Logger.getLogger(QryMyMarkAction.class.getName());
	
	
	@RequestMapping(value="/qryMyMark")
	@ResponseBody 
	public Result qryMyMark(QryMyMarkDto qryMyMarkDto){
		logger.debug("*********************************************查询给我评分记录	start*********************************************");
		
		Result result=new Result();
		try{
			//表单验证
			validParam(qryMyMarkDto,result);
			//验证成功
			if(result.getSuccess()){
				this.busService.qryMyMark(qryMyMarkDto,result);
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
	public void validParam(QryMyMarkDto qryMyMarkDto,Result result){
		if(StringUtils.isEmpty(qryMyMarkDto.getUserid())){
			result.setSuccess(false);
			result.setMsg("用户id不能为空");
			return;
		}else if(StringUtils.isEmpty(qryMyMarkDto.getUsertype())){
			result.setSuccess(false);
			result.setMsg("用户类型不能为空");
			return;
		}else if(qryMyMarkDto.getUsertype()!=Constants.USER_GE && qryMyMarkDto.getUsertype()!=Constants.USER_GP && qryMyMarkDto.getUsertype()!=Constants.USER_CE && qryMyMarkDto.getUsertype()!=Constants.USER_CP){
			result.setSuccess(false);
			result.setMsg("用户类型不正确");
			return;
		}else{
			if(qryMyMarkDto.getCurrentpage()==null || qryMyMarkDto.getCurrentpage()<=0){
				qryMyMarkDto.setCurrentpage(Constants.DEFAULT_CURRENTPAGE);
			}
			if(qryMyMarkDto.getPagesize()==null || qryMyMarkDto.getPagesize()<=0){
				qryMyMarkDto.setPagesize(Constants.DEFAULT_PAGESIZE);
			}
			result.setSuccess(true);
			result.setMsg("验证成功");
			return;
		}
	}
}
