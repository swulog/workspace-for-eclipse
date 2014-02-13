package cn.com.enho.mg.action;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.com.enho.comm.MgResult;
import cn.com.enho.mg.dto.DelDto;
import cn.com.enho.mg.service.MgService;

/**
 * 		删除反馈信息
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-9-22 下午1:52:14
 */
@Controller
@RequestMapping("/mg")
public class DelFeedback4MgAction {

	@Autowired
	private MgService mgService;
	
	static Logger logger = Logger.getLogger(DelFeedback4MgAction.class.getName());
	
	
	@RequestMapping(value="/delFeedback")
	@ResponseBody 
	public MgResult delFeedback(DelDto delDto){
		logger.debug("*********************************************删除反馈信息	start*********************************************");
		
		MgResult result=new MgResult();
		try{
			//表单验证
			validParam(delDto,result);
			//验证成功
			if(result.getSuccess()){
				this.mgService.delFeedback(delDto, result);
			}else{//验证失败
			}
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("删除出现异常");
			return result;
		}
		
	}
	
	//表单验证
	public void validParam(DelDto delDto,MgResult result){
		if(delDto.getId()==null || delDto.getId().size()<=0){
			result.setSuccess(false);
			result.setMsg("请选择要删除的数据");
			return;
		}else{
			result.setSuccess(true);
			result.setMsg("验证成功");
			return;
		}
	}
}
