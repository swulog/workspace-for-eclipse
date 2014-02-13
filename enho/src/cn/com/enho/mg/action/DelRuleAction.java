package cn.com.enho.mg.action;

import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.com.enho.comm.MgResult;
import cn.com.enho.mg.dto.DelDto;
import cn.com.enho.mg.entity.Rule;
import cn.com.enho.mg.service.MgService;

/**
 * 		删除规则
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-9-17 下午2:57:37
 */
@Controller
@RequestMapping("/mg")
public class DelRuleAction {

	@Autowired
	private MgService mgService;
	
	static Logger logger = Logger.getLogger(DelRuleAction.class.getName());
	
	
	@RequestMapping(value="/delRule")
	@ResponseBody 
	public MgResult delRule(HttpServletRequest request,DelDto delDto){
		logger.debug("*********************************************删除规则	start*********************************************");
		
		MgResult result=new MgResult();
		try{
			//表单验证
			validParam(delDto,result);
			//验证成功
			if(result.getSuccess()){
				this.mgService.delRule(delDto, result);
				
				//删除缓存中的规则
				ServletContext sc=request.getServletContext();
				List<Rule> list=(List<Rule>)this.mgService.qryRuleList(delDto);
				if(list!=null && list.size()>0){
					for(int i=0,len=list.size();i<len;i++){
						sc.removeAttribute(list.get(i).getT_rule_key());
					}
				}
				
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
