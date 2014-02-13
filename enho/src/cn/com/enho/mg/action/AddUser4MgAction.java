package cn.com.enho.mg.action;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import cn.com.enho.comm.Result;
import cn.com.enho.comm.constants.Constants;
import cn.com.enho.comm.util.ImgUtil;
import cn.com.enho.comm.util.StringUtil;
import cn.com.enho.mg.dto.UserDto;
import cn.com.enho.mg.service.MgService;

/**
 * 		新增用户
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-9-17 下午2:56:53
 */
@Controller
@RequestMapping("/mg")
public class AddUser4MgAction {

	@Autowired
	private MgService mgService;
	
	static Logger logger = Logger.getLogger(AddUser4MgAction.class.getName());
	
	@RequestMapping(value="/addUserPre")
	public ModelAndView addUserPre(UserDto userDto){
		ModelAndView mav=new ModelAndView();
		mav.addObject("gridid",userDto.getGridid());
		mav.setViewName("admin/useradd");
		return mav;
	}
	
	@RequestMapping(value="/addUser")
	@ResponseBody 
	public Result addUser(HttpServletRequest request,@RequestParam(value="card",required = false)MultipartFile card,@RequestParam(value="bcard",required = false)MultipartFile bcard,
			@RequestParam(value="blicense",required = false)MultipartFile blicense,@RequestParam(value="idcard",required = false)MultipartFile idcard,@RequestParam(value="dlicense",required = false)MultipartFile dlicense,@RequestParam(value="rlicense",required = false)MultipartFile rlicense,UserDto userDto){
		logger.debug("*********************************************后台_新增用户	start*********************************************");
		
		Result result=new Result();
		try{
			//表单验证
			validParam(userDto,result);
			//验证成功
			if(result.getSuccess()){
				//企业商家或企业车主
				if(userDto.getType()==Constants.USER_GE || userDto.getType()==Constants.USER_CE){
					if(card!=null && !card.isEmpty()){//名片正面
						uploadImage(request,card,"",result);
						if(result.getSuccess()){
							userDto.setCardurl(result.getData().get("url").toString());
						}else{
							return result;
						}
					}
					if(bcard!=null && !bcard.isEmpty()){//名片背面
						uploadImage(request,bcard,"",result);
						if(result.getSuccess()){
							userDto.setBcardurl(result.getData().get("url").toString());
						}else{
							return result;
						}
					}
					if(blicense!=null && !blicense.isEmpty()){//营业执照
						uploadImage(request,blicense,"",result);
						if(result.getSuccess()){
							userDto.setBlicenseurl(result.getData().get("url").toString());
						}else{
							return result;
						}
					}
				//个人车主
				}else if(userDto.getType()==Constants.USER_CP){
					if(idcard!=null && !idcard.isEmpty()){//名片正面
						uploadImage(request,idcard,"",result);
						if(result.getSuccess()){
							userDto.setIdcardurl(result.getData().get("url").toString());
						}else{
							return result;
						}
					}
					if(dlicense!=null && !dlicense.isEmpty()){//驾驶证
						uploadImage(request,dlicense,"",result);
						if(result.getSuccess()){
							userDto.setDlicenseurl(result.getData().get("url").toString());
						}else{
							return result;
						}
					}
					if(rlicense!=null && !rlicense.isEmpty()){//行驶证
						uploadImage(request,rlicense,"",result);
						if(result.getSuccess()){
							userDto.setRlicenseurl(result.getData().get("url").toString());
						}else{
							return result;
						}
					}
				}else{}
				
				this.mgService.addUser(userDto, result);
				return result;
			}else{//验证失败
			}
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("新增异常");
			return result;
		}
		
	}
	
	/**
	 * 上传图片
	 * @throws IOException 
	 * @throws FileNotFoundException 
	 */
	@SuppressWarnings("deprecation")
	public Result uploadImage(HttpServletRequest request,MultipartFile file,String oldurl,Result result){
		File dfile=null;//目标文件
		try{
			String filename=file.getOriginalFilename();
			//如果文件名称为空
			if(filename==null || "".equals(filename)){
				result.setSuccess(false);
				result.setMsg("文件名称不能为空");
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
			
			//上传图片
			String newFilename=ImgUtil.getFileName();//新文件名称
			String desdir=request.getServletContext().getAttribute("userimg").toString();//目标目录
			String aurl=request.getRealPath(desdir)+"/"+newFilename+filename.substring(filename.lastIndexOf("."));//物理路径
			String rurl=desdir+"/"+newFilename+filename.substring(filename.lastIndexOf("."));//相对路径
			
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
					
			//当图片上传成功后删除原来的图片
			if(oldurl!=null && !"".equals(oldurl)){
				File oldfile=new File(request.getRealPath(desdir)+oldurl.lastIndexOf("/"));
				//如果存在则删除
				if(oldfile.exists()){
					oldfile.delete();
				}
			}
			
			result.setSuccess(true);
			result.setMsg("上传成功");
			result.getData().put("url",rurl);
			return result;
		}catch(Exception e){
			e.printStackTrace();
			if(dfile!=null && dfile.isFile() && dfile.exists()){
				dfile.delete();
			}
			result.setSuccess(false);
			result.setMsg("上传异常");
			return result;
		}
	}
	
	//表单验证
	public void validParam(UserDto userDto,Result result){
		if(StringUtils.isEmpty(userDto.getPhone())){
			result.setSuccess(false);
			result.setMsg("手机号码不能为空");
			return;
		}else if(!userDto.getPhone().matches("^(1(([35][0-9])|(47)|[8][0123456789]))\\d{8}$")){
			result.setSuccess(false);
			result.setMsg("手机号码格式不正确");
			return;
		}else if(StringUtils.isEmpty(userDto.getPwd())){
			result.setSuccess(false);
			result.setMsg("密码不能为空");
			return;
		}else if(userDto.getPwd().length()<6 || userDto.getPwd().length()>12){
			result.setSuccess(false);
			result.setMsg("用户密码长度应为6-12位");
			return;
		}else if(userDto.getType()!=Constants.USER_GE && userDto.getType()!=Constants.USER_GP && userDto.getType()!=Constants.USER_CE && userDto.getType()!=Constants.USER_CP){
			result.setSuccess(false);
			result.setMsg("用户类型不正确");
			return;
		}else if(!StringUtils.isEmpty(userDto.getName()) && userDto.getName().length()>50){
			result.setSuccess(false);
			result.setMsg("用户名称不能超过50个字符");
			return;
		}else if(!StringUtils.isEmpty(userDto.getTel()) && userDto.getTel().length()>20){
			result.setSuccess(false);
			result.setMsg("电话号码不能超过50个字符");
			return;
		}else{
			result.setSuccess(true);
			result.setMsg("验证成功");
			return;
		}
	}
}
