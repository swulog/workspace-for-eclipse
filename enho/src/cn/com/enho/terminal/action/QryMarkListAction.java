package cn.com.enho.terminal.action;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.com.enho.comm.Result;
import cn.com.enho.comm.constants.Constants;
import cn.com.enho.terminal.dto.QryMarkListDto;
import cn.com.enho.terminal.service.BusService;

/**
 * 		查询评分列表（货主）
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-25 上午11:52:13
 */
@Controller
@RequestMapping("/terminal")
public class QryMarkListAction {

	@Autowired
	private BusService busService;
	
	static Logger logger = Logger.getLogger(QryMarkListAction.class.getName());
	
	
	@RequestMapping(value="/qryMarkList")
	@ResponseBody 
	public Result qryMarkList(QryMarkListDto qryMarkListDto){
		logger.debug("*********************************************查询评分列表	start*********************************************");
		
		Result result=new Result();
		try{
			//表单验证
			validParam(qryMarkListDto,result);
			//验证成功
			if(result.getSuccess()){
				this.busService.qryMarkList(qryMarkListDto,result);
			}else{//验证失败
			}
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("查询评分列表出现异常");
			return result;
		}
		
	}
	
	//表单验证
	public void validParam(QryMarkListDto qryMarkListDto,Result result){
		if(StringUtils.isEmpty(qryMarkListDto.getUserid())){
			result.setSuccess(false);
			result.setMsg("用户id不能为空");
			return;
		}else if(StringUtils.isEmpty(qryMarkListDto.getUsertype())){
			result.setSuccess(false);
			result.setMsg("用户类型不能为空");
			return;
		}else if(qryMarkListDto.getUsertype()!=Constants.USER_GE && qryMarkListDto.getUsertype()!=Constants.USER_GP && qryMarkListDto.getUsertype()!=Constants.USER_CE && qryMarkListDto.getUsertype()!=Constants.USER_CP){
			result.setSuccess(false);
			result.setMsg("用户类型不正确");
			return;
		}else{
			if(qryMarkListDto.getCurrentpage()==null || qryMarkListDto.getCurrentpage()<=0){
				qryMarkListDto.setCurrentpage(Constants.DEFAULT_CURRENTPAGE);
			}
			if(qryMarkListDto.getPagesize()==null || qryMarkListDto.getPagesize()<=0){
				qryMarkListDto.setPagesize(Constants.DEFAULT_PAGESIZE);
			}
			result.setSuccess(true);
			result.setMsg("验证成功");
			return;
		}
	}
}
