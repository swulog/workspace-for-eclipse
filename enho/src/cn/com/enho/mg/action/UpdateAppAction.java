package cn.com.enho.mg.action;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import cn.com.enho.comm.MgResult;
import cn.com.enho.mg.dto.AppDto;
import cn.com.enho.mg.service.MgService;

/**
 * 		修改app
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-9-27 下午12:50:02
 */
@Controller
@RequestMapping("/mg")
public class UpdateAppAction {

	@Autowired
	private MgService mgService;
	
	static Logger logger = Logger.getLogger(UpdateAppAction.class.getName());
	
	@RequestMapping(value="/updateAppPre")
	public ModelAndView updateAppPre(AppDto appDto){
		logger.debug("*********************************************后台_修改app页面加载	start*********************************************");
		ModelAndView mav=new ModelAndView();
		mav.addObject("id", appDto.getId());
		mav.addObject("name", appDto.getName());
		mav.addObject("key", appDto.getKey());
		mav.addObject("version", appDto.getVersion());
		mav.addObject("url", appDto.getUrl());
		mav.addObject("size", appDto.getSize());
		mav.addObject("desc", appDto.getDesc());
		mav.addObject("createtime", appDto.getCreatetime());
		mav.addObject("lastupdatetime", appDto.getLastupdatetime());
		mav.addObject("gridid", appDto.getGridid());
		mav.setViewName("admin/appupdate");
		return mav;
	}
	
	@SuppressWarnings("deprecation")
	@RequestMapping(value="/updateApp")
	@ResponseBody 
	public MgResult updateApp(HttpServletRequest request,AppDto appDto){
		logger.debug("*********************************************修改app	start*********************************************");
		
		MgResult result=new MgResult();
		try{
			//表单验证
			validParam(appDto,result);
			//验证成功
			if(result.getSuccess()){
					MultipartHttpServletRequest multipartRequest=(MultipartHttpServletRequest)request;  
					MultipartFile file=multipartRequest.getFile("appfile");
					if(file!=null && !file.isEmpty()){
						String filename=file.getOriginalFilename();
						if(!"apk".equalsIgnoreCase(filename.substring(filename.lastIndexOf(".")+1))){
							result.setSuccess(false);
							result.setMsg("请上传apk文件");
							return result;
						}
						
						long size=file.getSize();
						
						String newfilename=appDto.getKey()+"_"+appDto.getVersion()+".apk";//新文件名称
						String desdir=request.getServletContext().getAttribute("appdir").toString();//目标目录
						String aurl=request.getRealPath(desdir)+"/"+newfilename;//物理路径
						String rurl=desdir+"/"+newfilename;//相对路径
						
						File desfile=new File(aurl);
						if(!desfile.exists()){
							try {
								desfile.createNewFile();
							} catch (IOException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
								result.setSuccess(false);
								result.setMsg("文件创建失败");
								return result;
							}
						}
						//文件复制
						FileCopyUtils.copy(file.getInputStream(), new FileOutputStream(desfile));
						
						//将APP信息插入数据库
						appDto.setSize(size);
						appDto.setUrl(rurl);
					}
					this.mgService.updateApp(appDto, result);
					
					//将版本信息放入context,appkey_version作为key
					request.getServletContext().setAttribute(appDto.getKey()+"_version",appDto.getVersion());
					
					return result;
			}else{//验证失败
			}
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("修改异常");
			return result;
		}
		
	}
	
	//表单验证
	public void validParam(AppDto appDto,MgResult result){
		if(StringUtils.isEmpty(appDto.getId())){
			result.setSuccess(false);
			result.setMsg("id不能为空");
			return;
		}else if(StringUtils.isEmpty(appDto.getKey())){
			result.setSuccess(false);
			result.setMsg("App key不能为空");
			return;
		}else if(appDto.getKey().length()>20){
			result.setSuccess(false);
			result.setMsg("App key不能超过20个字符");
			return;
		}else if(StringUtils.isEmpty(appDto.getVersion())){
			result.setSuccess(false);
			result.setMsg("App版本不能为空");
			return;
		}else if(appDto.getVersion().length()>10){
			result.setSuccess(false);
			result.setMsg("App版本不能超过10字符");
			return;
		}else if(!StringUtils.isEmpty(appDto.getName()) && appDto.getName().length()>20){
			result.setSuccess(false);
			result.setMsg("App名称不能超过20字符");
			return;
		}else if(!StringUtils.isEmpty(appDto.getDesc()) && appDto.getDesc().length()>200){
			result.setSuccess(false);
			result.setMsg("App描述不能超过200字符");
			return;
		}else{
			result.setSuccess(true);
			result.setMsg("验证成功");
			return;
		}
	}
}
