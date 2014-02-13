package cn.com.enho.terminal.action;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.com.enho.comm.Result;
import cn.com.enho.mg.entity.AppInfo;
import cn.com.enho.terminal.dto.CheckUpdateDto;
import cn.com.enho.terminal.service.CommService;

/**
 * 		android版本检测
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-9-9 下午2:42:39
 */
@Controller
@RequestMapping("/comm")
public class CheckUpdateAction {

	@Autowired
	private CommService commService;
	
	static Logger logger = Logger.getLogger(CheckUpdateAction.class.getName());
	
	@RequestMapping(value="/checkUpdate")
	@ResponseBody 
	public Result checkUpdate(CheckUpdateDto checkUpdateDto,HttpServletRequest request){
		logger.debug("*********************************************android版本检测	start*********************************************");
		
		Result result=new Result();
		try{
			//表单验证
			validParam(checkUpdateDto,result);
			//验证成功
			if(result.getSuccess()){
				String appkey=checkUpdateDto.getAppid();//appkey
				
				String baseurl=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath();
				String url="";
				
				//从内存中获取服务端版本
				//内存中app版本key为appkey+“_version”
				/*String key=appkey+"_version";
				String sversion=(String)request.getServletContext().getAttribute(key);*/
				
				String cversion=checkUpdateDto.getVersion();//客户端版本
				
				List<AppInfo> list=this.commService.qryApp(appkey);
				if(list==null || list.size()<=0){
					result.setSuccess(false);
					result.setMsg("没有新版本");
					return result;
				}
				
				url=list.get(0).getT_app_url();//app url
				String sversion=list.get(0).getT_app_version();//服务端版本
				
				//版本比较
				if(cversion!=null && !"".equals(cversion)){
					if(!sversion.equalsIgnoreCase(cversion)){
						if("".equals(url)){
							result.setSuccess(false);
							result.setMsg("更新失败");
							return result;
						}else{
							result.setSuccess(true);
							result.setMsg("更新成功");
							result.getData().put("url", baseurl+url);
							result.getData().put("version", sversion);
							return result;
						}
					}else{
						result.setSuccess(false);
						result.setMsg("没有新版本");
						return result;
					}
				}else{
					if("".equals(url)){
						result.setSuccess(false);
						result.setMsg("更新失败");
						return result;
					}else{
						result.setSuccess(true);
						result.setMsg("更新成功");
						result.getData().put("url", baseurl+url);
						result.getData().put("version", sversion);
						return result;
					}
				}
				
			}else{//验证失败
			}
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("更新异常");
			return result;
		}
		
	}
	
	//表单验证
	public void validParam(CheckUpdateDto checkUpdateDto,Result result){
		if(StringUtils.isEmpty(checkUpdateDto.getAppid())){
			result.setSuccess(false);
			result.setMsg("App id不能为空");
			return;
		}else{
			result.setSuccess(true);
			result.setMsg("验证成功");
			return;
		}
	}
}
