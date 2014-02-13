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

import cn.com.enho.comm.Result;
import cn.com.enho.comm.constants.Constants;
import cn.com.enho.comm.util.ImgUtil;
import cn.com.enho.comm.util.StringUtil;
/**
 * 		图片上传接口
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-10-15 下午5:57:18
 */
@Controller
@RequestMapping("/terminal")
public class FileUploadAction {

static Logger logger = Logger.getLogger(FileUploadAction.class.getName());
	
	/**
	 * file:上传的文件
	 */
	@SuppressWarnings("deprecation")
	@RequestMapping(value="/fileupload")
	@ResponseBody 
	public Result fileupload(HttpServletRequest request,@RequestParam(value="file")MultipartFile file,@RequestParam Integer utype,@RequestParam Integer fuse){
		logger.debug("*********************************************上传文件	start*********************************************");
		
		Result result=new Result();
		File dfile=null;//目标文件
		try{
			//表单验证
			validParam(file,utype,fuse,result);
			if(result.getSuccess()){
				String filename=file.getOriginalFilename();
				if(filename==null || "".equals(filename)){
					result.setSuccess(false);
					result.setMsg("文件名称不能为空");
					return result;
				}
				
				//如果是上传图片
				if(utype==1){
					//验证图片格式
					String suff=filename.substring(filename.lastIndexOf(".")+1);
					String type=ImgUtil.getImageType(file.getInputStream());
					if(!StringUtil.isContain(Constants.imgtypes, suff) || !StringUtil.isContain(Constants.imgtypes,type)){
						result.setSuccess(false);
						result.setMsg("图片格式不符合要求");
						return result;
					}
				}
				
				//目标目录
				String desdir="";
				if(fuse==1){//用途：用户信息
					desdir=request.getServletContext().getAttribute("userimg").toString();
				}else if(fuse==2){//用途：货源信息
					desdir=request.getServletContext().getAttribute("goodsimg").toString();
				}else if(fuse==3){//用途：车源信息
					desdir=request.getServletContext().getAttribute("carimg").toString();
				}else if(fuse==4){//用途：其它
					desdir=request.getServletContext().getAttribute("uploaddir").toString();
				}else{
					desdir=request.getServletContext().getAttribute("uploaddir").toString();
				}
				
				String aurl=request.getRealPath(desdir)+filename.substring(filename.lastIndexOf("/"));//物理路径
				//String rurl=desdir+filename.substring(filename.lastIndexOf("/"));//相对路径
				
				//文件上传
				dfile=new File(aurl);
				if(!dfile.exists()){
					try {
							dfile.createNewFile();
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
						result.setSuccess(false);
						result.setMsg("目标文件创建失败");
						return result;
					}
				}
				FileCopyUtils.copy(file.getInputStream(), new FileOutputStream(dfile));
				
				//String aurl= request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+ request.getContextPath()+rurl;//绝对路径
				result.setSuccess(true);
				result.setMsg("上传成功");
				return result;
			}else{//验证失败
			}
			return result;
		}catch(Exception e){
			e.printStackTrace();
			//如果文件已上传则删除
			if(dfile!=null && dfile.isFile() && dfile.exists()){
				dfile.delete();
			}
			result.setSuccess(false);
			result.setMsg("上传异常");
			return result;
		}
		
	}


	//表单验证
	public void validParam(MultipartFile file,Integer utype,Integer fuse,Result result){
		if(file==null || file.isEmpty()){
			result.setSuccess(false);
			result.setMsg("文件不能为空");
			return;
		}else if(utype==null){
			result.setSuccess(false);
			result.setMsg("传输类型不能为空");
			return;
		}else if(utype!=1 && utype!=2 && utype!=3 && utype!=4){
			result.setSuccess(false);
			result.setMsg("传输类型不正确");
			return;
		}else if(fuse==null){
			result.setSuccess(false);
			result.setMsg("文件用途不能为空");
			return;
		}else if(fuse!=1 && fuse!=2 && fuse!=3 && fuse!=4){
			result.setSuccess(false);
			result.setMsg("文件用途不正确");
			return;
		}else{
			result.setSuccess(true);
			result.setMsg("验证成功");
			return;
		}
	}
}
