package cn.com.enho.terminal.action;

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

import cn.com.enho.comm.Result;
import cn.com.enho.comm.constants.Constants;
import cn.com.enho.comm.util.ImgUtil;
import cn.com.enho.comm.util.StringUtil;
import cn.com.enho.terminal.dto.UpdateUserDto;
import cn.com.enho.terminal.service.UserService;

/**
 * 		修改用户信息
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-14 上午10:22:49
 */
@Controller
@RequestMapping("/terminal")
public class UpdateUserAction {

	@Autowired
	private UserService userService;
	
	static Logger logger = Logger.getLogger(UpdateUserAction.class.getName());
	
	
	@SuppressWarnings("deprecation")
	@RequestMapping(value="/updateUser")
	@ResponseBody 
	public Result updateUser(HttpServletRequest request,@RequestParam(value="card",required = false)MultipartFile card,@RequestParam(value="bcard",required = false)MultipartFile bcard,
			@RequestParam(value="blicense",required = false)MultipartFile blicense,@RequestParam(value="dlicense",required = false)MultipartFile dlicense,@RequestParam(value="rlicense",required = false)MultipartFile rlicense,
			UpdateUserDto updateUserDto){
		logger.debug("*********************************************修改用户信息	start*********************************************");
		
		Result result=new Result();
		try{
			//表单验证
			validParam(updateUserDto,result);
			//验证成功
			if(result.getSuccess()){
				this.userService.qryUserDtl(updateUserDto.getUserid(),"", result);
				String cardurl=result.getData().get("cardurl")==null?"":result.getData().get("cardurl").toString();
				String bcardurl=result.getData().get("bcardurl")==null?"":result.getData().get("bcardurl").toString();
				String blicenseurl=result.getData().get("blicenseurl")==null?"":result.getData().get("blicenseurl").toString();
				String dlicenseurl=result.getData().get("dlicenseurl")==null?"":result.getData().get("dlicenseurl").toString();
				String rlicenseurl=result.getData().get("rlicenseurl")==null?"":result.getData().get("rlicenseurl").toString();
				result.clear();
				
				//商家或者货运部
				if(updateUserDto.getUsertype()==Constants.USER_GE || updateUserDto.getUsertype()==Constants.USER_CE){
					//名片正面
					if("1".equals(updateUserDto.getCardurl())){
						if(card!=null && !card.isEmpty()){
							uploadImage(request,card,cardurl,result);
							if(result.getSuccess()){
								updateUserDto.setCardurl(result.getData().get("url").toString());//相对路径
							}else{
								return result;
							}
						}
					}else if("3".equals(updateUserDto.getCardurl())){
						if(cardurl!=null && !"".equals(cardurl)){
							String desdir=request.getServletContext().getAttribute("userimg").toString();//目标目录
							File oldfile=new File(request.getRealPath(desdir)+cardurl.substring(cardurl.lastIndexOf("/")));
							//如果存在则删除
							if(oldfile.exists()){
								oldfile.delete();
							}
						}
						updateUserDto.setCardurl("");//相对路径
					}else{
					}
					
					
					//名片背面
					if("1".equals(updateUserDto.getBcardurl())){
						if(bcard!=null && !bcard.isEmpty()){
							uploadImage(request,bcard,bcardurl,result);
							if(result.getSuccess()){
								updateUserDto.setBcardurl(result.getData().get("url").toString());//相对路径
							}else{
								return result;
							}
						}
					}else if("3".equals(updateUserDto.getBcardurl())){
						if(bcardurl!=null && !"".equals(bcardurl)){
							String desdir=request.getServletContext().getAttribute("userimg").toString();//目标目录
							File oldfile=new File(request.getRealPath(desdir)+bcardurl.substring(bcardurl.lastIndexOf("/")));
							//如果存在则删除
							if(oldfile.exists()){
								oldfile.delete();
							}
						}
						updateUserDto.setBcardurl("");//相对路径
					}else{
					}
					
					//营业执照
					if("1".equals(updateUserDto.getBlicenseurl())){
						if(blicense!=null && !blicense.isEmpty()){
							uploadImage(request,blicense,blicenseurl,result);
							if(result.getSuccess()){
								updateUserDto.setBlicenseurl(result.getData().get("url").toString());//相对路径
							}else{
								return result;
							}
						}
					}else if("3".equals(updateUserDto.getBlicenseurl())){
						if(blicenseurl!=null && !"".equals(blicenseurl)){
							String desdir=request.getServletContext().getAttribute("userimg").toString();//目标目录
							File oldfile=new File(request.getRealPath(desdir)+blicenseurl.substring(blicenseurl.lastIndexOf("/")));
							//如果存在则删除
							if(oldfile.exists()){
								oldfile.delete();
							}
						}
						updateUserDto.setBlicenseurl("");//相对路径
					}else{
					}
					
				}else if(updateUserDto.getUsertype()==Constants.USER_CP){//司机
					//身份证
					if("1".equals(updateUserDto.getCardurl())){
						if(card!=null && !card.isEmpty()){
							uploadImage(request,card,cardurl,result);
							if(result.getSuccess()){
								updateUserDto.setCardurl(result.getData().get("url").toString());//相对路径
							}else{
								return result;
							}
						}
					}else if("3".equals(updateUserDto.getCardurl())){
						if(cardurl!=null && !"".equals(cardurl)){
							String desdir=request.getServletContext().getAttribute("userimg").toString();//目标目录
							File oldfile=new File(request.getRealPath(desdir)+cardurl.substring(cardurl.lastIndexOf("/")));
							//如果存在则删除
							if(oldfile.exists()){
								oldfile.delete();
							}
						}
						updateUserDto.setCardurl("");//相对路径
					}else{
					}
					
					//驾驶证
					if("1".equals(updateUserDto.getDlicenseurl())){
						if(dlicense!=null && !dlicense.isEmpty()){
							uploadImage(request,dlicense,dlicenseurl,result);
							if(result.getSuccess()){
								updateUserDto.setDlicenseurl(result.getData().get("url").toString());//相对路径
							}else{
								return result;
							}
						}
					}else if("3".equals(updateUserDto.getDlicenseurl())){
						if(dlicenseurl!=null && !"".equals(dlicenseurl)){
							String desdir=request.getServletContext().getAttribute("userimg").toString();//目标目录
							File oldfile=new File(request.getRealPath(desdir)+dlicenseurl.substring(dlicenseurl.lastIndexOf("/")));
							//如果存在则删除
							if(oldfile.exists()){
								oldfile.delete();
							}
						}
						updateUserDto.setDlicenseurl("");//相对路径
					}else{
					}
					
					//行驶证
					if("1".equals(updateUserDto.getRlicenseurl())){
						if(rlicense!=null && !rlicense.isEmpty()){
							uploadImage(request,rlicense,rlicenseurl,result);
							if(result.getSuccess()){
								updateUserDto.setRlicenseurl(result.getData().get("url").toString());//相对路径
							}else{
								return result;
							}
						}
					}else if("3".equals(updateUserDto.getRlicenseurl())){
						if(rlicenseurl!=null && !"".equals(rlicenseurl)){
							String desdir=request.getServletContext().getAttribute("userimg").toString();//目标目录
							File oldfile=new File(request.getRealPath(desdir)+rlicenseurl.substring(rlicenseurl.lastIndexOf("/")));
							//如果存在则删除
							if(oldfile.exists()){
								oldfile.delete();
							}
						}
						updateUserDto.setRlicenseurl("");//相对路径
					}else{
						
					}
				}else{
				}
				
				this.userService.updateUser(updateUserDto,result);
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
				File oldfile=new File(request.getRealPath(desdir)+oldurl.substring(oldurl.lastIndexOf("/")));
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
	public void validParam(UpdateUserDto updateUserDto,Result result){
		if(StringUtils.isEmpty(updateUserDto.getUserid())){
			result.setSuccess(false);
			result.setMsg("用户id不能为空");
			return;
		}else{
			result.setSuccess(true);
			result.setMsg("验证成功");
			return;
		}
	}
}
