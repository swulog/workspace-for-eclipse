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
 * 删除货源信息
 * 
 * @author xionglei
 *
 */
@Controller
@RequestMapping("/mg")
public class DelGoods4MgAction {

	@Autowired
	private MgService mgService;
	
	static Logger logger = Logger.getLogger(DelUser4MgAction.class.getName());
	
	
	@RequestMapping(value="/delGoods")
	@ResponseBody 
	public MgResult delGoods(DelDto delDto){
		logger.debug("*********************************************删除货源	start*********************************************");
		
		MgResult result=new MgResult();
		try{
			//表单验证
			validParam(delDto,result);
			//验证成功
			if(result.getSuccess()){
				this.mgService.delGoods(delDto, result);
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
