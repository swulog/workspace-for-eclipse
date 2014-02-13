package cn.com.enho.web.action;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Iterator;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.servlet.ModelAndView;

import cn.com.enho.comm.Result;
import cn.com.enho.comm.constants.Constants;
import cn.com.enho.comm.util.ImgUtil;
import cn.com.enho.comm.util.StringUtil;
import cn.com.enho.web.dto.UploadDto;

/**
 * 		附件上传
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-9-9 下午2:42:39
 */
@Controller
@RequestMapping("/web")
public class UploadAction {

	static Logger logger = Logger.getLogger(UploadAction.class.getName());
	
	
	@RequestMapping(value="/uploadpre")
	public ModelAndView uploadpre(){
		logger.debug("*********************************************附件上传页面加载	start*********************************************");
		
		ModelAndView mav=new ModelAndView();
		mav.setViewName("web/upload");
		return mav;
		
	}
	
	@SuppressWarnings({ "deprecation", "rawtypes" })
	@RequestMapping(value="/uploadimg")
	@ResponseBody 
	public Result uploadimg(HttpServletRequest request,@RequestParam(value="attach1",required = false)MultipartFile card,@RequestParam(value="attach2",required = false)MultipartFile card1,UploadDto uploadDto){
		logger.debug("*********************************************上传附件	start*********************************************");
		
		Result result=new Result();
		try{
			//表单验证
			validParam(uploadDto,result);
			//验证成功
			if(result.getSuccess()){
				//boolean flag=card.isEmpty();
				//boolean flag1=card1.isEmpty();
				//boolean flag1=card1.isEmpty();
				MultipartHttpServletRequest multipartRequest=(MultipartHttpServletRequest)request;  
				Map files=multipartRequest.getFileMap();
				Iterator fields=multipartRequest.getFileNames();
				//MultipartFile file=multipartRequest.getFile("attach");
				//String filename=file.getOriginalFilename();
				
				for(; fields.hasNext();){
					String field=(String)fields.next();
					CommonsMultipartFile file = (CommonsMultipartFile)files.get(field);
					String filename=file.getOriginalFilename();
					if(file==null || filename==null || "".equals(filename)){
						result.setSuccess(false);
						result.setMsg("附件不能为空");
						return result;
					}
					
					//验证图片格式
					String suff=filename.substring(filename.lastIndexOf(".")+1);
					String type=ImgUtil.getImageType(file.getInputStream());
					if(!StringUtil.isContain(Constants.imgtypes, suff) || !StringUtil.isContain(Constants.imgtypes,type)){
						result.setSuccess(false);
						result.setMsg("图片格式不正确");
						return result;
					}
					
					//String appurl=request.getRealPath((String)request.getServletContext().getAttribute("imgdir"));//   "/app"
					String descdir=request.getRealPath((String)request.getServletContext().getAttribute("imgdir"));//图片存放目录
					String nfname=ImgUtil.getFileName();//新文件名称
					String rurl=descdir+"/r"+nfname+"."+type;//原图存放路径
					String surl=descdir+"/s"+nfname+"."+type;//缩略图存放路径
					String rrurl=request.getServletContext().getAttribute("imgdir").toString()+"/r"+nfname+"."+type;//原图存放相对路径
					String rsurl=request.getServletContext().getAttribute("imgdir").toString()+"/s"+nfname+"."+type;//缩略图存放相对路径
					
					File rfile=new File(rurl);
					File sfile=new File(surl);
					
					if(!rfile.exists()){
						try {
							rfile.createNewFile();
						} catch (IOException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
							result.setSuccess(false);
							result.setMsg("目标文件创建失败");
							return result;
						}
					}
					if(!sfile.exists()){
						try {
							sfile.createNewFile();
						} catch (IOException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
							result.setSuccess(false);
							result.setMsg("目标文件创建失败");
							return result;
						}
					}
					
					FileCopyUtils.copy(file.getInputStream(), new FileOutputStream(rfile));
					ImgUtil.createPreviewImage(file.getInputStream(), sfile);
					
					String rcard= request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+ request.getContextPath()+rrurl;
					String scard= request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+ request.getContextPath()+rsurl;
					logger.debug("\n原图地址："+rcard);
					logger.debug("\n缩略图地址："+scard);
					result.getData().put("url", rcard);
				}
				
				result.setMsg("文件上传成功");
				result.setSuccess(true);
				return result;
			}else{//验证失败
			}
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("上传出现异常");
			return result;
		}
		
	}
	
	//表单验证
	public void validParam(UploadDto uploadDto,Result result){
		result.setSuccess(true);
		result.setMsg("验证成功");
		return;
	}
}
