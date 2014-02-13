package cn.com.enho.terminal.action;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import cn.com.enho.comm.Result;
import cn.com.enho.comm.constants.Constants;
import cn.com.enho.comm.util.StringUtil;

/**
 * 		上传图片
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-16 下午3:33:50
 */
@Controller
@RequestMapping("/terminal")
public class UploadImageAction {

	static Logger logger = Logger.getLogger(UpdateUserAction.class.getName());
	
	/**
	 * 获取图片保存路径
	 * @param request
	 * @param imagetype
	 * @return
	 */
	public String getSavepth(HttpServletRequest request,Integer imagetype){
		Object savepath=null;
		if(Constants.IMAGE_TYPE_AVATAR==imagetype){//头像图片
			savepath=request.getServletContext().getAttribute("avatar_imgurl");
		}else if(Constants.IMAGE_TYPE_GOODS==imagetype){//货源图片
			savepath=request.getServletContext().getAttribute("goods_imgurl");
		}else if(Constants.IMAGE_TYPE_CAR==imagetype){//车源图片
			savepath=request.getServletContext().getAttribute("car_imgurl");
		}else if(Constants.IMAGE_TYPE_SHARE==imagetype){//分享图片
			savepath=request.getServletContext().getAttribute("share_imgurl");
		}else{
			
		}
		return savepath==null?"":savepath.toString();
	}
	
	
	@RequestMapping(value="/uploadImage")
	@ResponseBody 
	public Result uploadImage(HttpServletRequest request,@RequestParam String field,Integer imagetype){
		logger.debug("*************************         开始上传图片                     ***********************************");
		Result result=new Result();
		
		MultipartHttpServletRequest multipartRequest=(MultipartHttpServletRequest)request;  
		MultipartFile imgFile=multipartRequest.getFile(field); 
		String filename=imgFile.getOriginalFilename();
		if(filename !=null && !"".equals(filename)){
			//允许的文件类型
			String type=request.getServletContext().getAttribute("image_type")==null?"":request.getServletContext().getAttribute("image_type").toString();
			if(type!=null && !"".equals(type)){
				String[] arr=type.split(",");
				if(StringUtil.isContain(arr, filename.substring(filename.lastIndexOf(".")+1))){//图片类型验证
					String savepath=getSavepth(request,imagetype);//图片保存路径
					File desfile=new File(savepath);
					if(!desfile.exists()){
						try {
							desfile.createNewFile();
						} catch (IOException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
							result.setSuccess(false);
							result.setMsg("目标地址创建失败");
							return result;
						}
					}
					try {
						//文件复制
						FileCopyUtils.copy(imgFile.getInputStream(), new FileOutputStream(desfile));
						result.setSuccess(true);
						result.setMsg("图片上传成功");
						return result;
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
						result.setSuccess(false);
						result.setMsg("图片上传失败");
						return result;
					}
				}
			}
		}
		result.setSuccess(false);
		result.setMsg("文件上传失败");
		return result;
	}
	
}
