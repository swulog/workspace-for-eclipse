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
import cn.com.enho.terminal.dto.UpdateCarDto;
import cn.com.enho.terminal.service.CarService;

/**
 * 		修改车源信息
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-12 上午11:20:04
 */
@Controller
@RequestMapping("/terminal")
public class UpdateCarAction {

	@Autowired
	private CarService carService;
	
	static Logger logger = Logger.getLogger(UpdateCarAction.class.getName());
	
	
	@SuppressWarnings("deprecation")
	@RequestMapping(value="/updateCar")
	@ResponseBody 
	public Result updateCar(HttpServletRequest request,@RequestParam(value="image1",required = false)MultipartFile image1,@RequestParam(value="image2",required = false)MultipartFile image2,
			@RequestParam(value="image3",required = false)MultipartFile image3,UpdateCarDto updateCarDto){
		logger.debug("*********************************************修改车源信息	start*********************************************");
		
		Result result=new Result();
		try{
			//表单验证
			validParam(updateCarDto,result);
			//验证成功
			if(result.getSuccess()){
				this.carService.qryCarDtl(updateCarDto.getCarid(),"", result);
				String imageurl1=result.getData().get("imageurl1")==null?"":result.getData().get("imageurl1").toString();
				String imageurl2=result.getData().get("imageurl2")==null?"":result.getData().get("imageurl2").toString();
				String imageurl3=result.getData().get("imageurl3")==null?"":result.getData().get("imageurl3").toString();
				result.clear();
				
				if("1".equals(updateCarDto.getImageurl1())){
					if(image1!=null && !image1.isEmpty()){
						uploadImage(request,image1,imageurl1,result);
						if(result.getSuccess()){
							updateCarDto.setImageurl1(result.getData().get("url").toString());//相对路径
						}else{
							return result;
						}
					}
				}else if("3".equals(updateCarDto.getImageurl1())){
					if(imageurl1!=null && !"".equals(imageurl1)){
						String desdir=request.getServletContext().getAttribute("carimg").toString();//目标目录
						File oldfile=new File(request.getRealPath(desdir)+imageurl1.substring(imageurl1.lastIndexOf("/")));
						//如果存在则删除
						if(oldfile.exists()){
							oldfile.delete();
						}
					}
					updateCarDto.setImageurl1("");//相对路径
				}else{
				}
				
				if("1".equals(updateCarDto.getImageurl2())){
					if(image2!=null && !image2.isEmpty()){
						uploadImage(request,image2,imageurl2,result);
						if(result.getSuccess()){
							updateCarDto.setImageurl2(result.getData().get("url").toString());//相对路径
						}else{
							return result;
						}
					}
				}else if("3".equals(updateCarDto.getImageurl2())){
					if(imageurl2!=null && !"".equals(imageurl2)){
						String desdir=request.getServletContext().getAttribute("carimg").toString();//目标目录
						File oldfile=new File(request.getRealPath(desdir)+imageurl2.substring(imageurl2.lastIndexOf("/")));
						//如果存在则删除
						if(oldfile.exists()){
							oldfile.delete();
						}
					}
					updateCarDto.setImageurl2("");//相对路径
				}else{
				}
				
				if("1".equals(updateCarDto.getImageurl3())){
					if(image3!=null && !image3.isEmpty()){
						uploadImage(request,image3,imageurl3,result);
						if(result.getSuccess()){
							updateCarDto.setImageurl3(result.getData().get("url").toString());//相对路径
						}else{
							return result;
						}
					}
				}else if("3".equals(updateCarDto.getImageurl3())){
					if(imageurl3!=null && !"".equals(imageurl3)){
						String desdir=request.getServletContext().getAttribute("carimg").toString();//目标目录
						File oldfile=new File(request.getRealPath(desdir)+imageurl3.substring(imageurl3.lastIndexOf("/")));
						//如果存在则删除
						if(oldfile.exists()){
							oldfile.delete();
						}
					}
					updateCarDto.setImageurl3("");//相对路径
				}else{
				}
				
				this.carService.updateCar(updateCarDto, result);
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
			String desdir=request.getServletContext().getAttribute("carimg").toString();//目标目录
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
	public void validParam(UpdateCarDto updateCarDto,Result result){
		if(StringUtils.isEmpty(updateCarDto.getCarid())){
			result.setSuccess(false);
			result.setMsg("车源信息id不能为空");
		}else if(StringUtils.isEmpty(updateCarDto.getWayline())){
			result.setSuccess(false);
			result.setMsg("路线不能为空");
			return;
		}else if(StringUtils.isEmpty(updateCarDto.getCarno())){
			result.setSuccess(false);
			result.setMsg("车牌号不能为空");
			return;
		}else if(StringUtils.isEmpty(updateCarDto.getCardesc())){
			result.setSuccess(false);
			result.setMsg("车源信息描述不能为空");
			return;
		}else if(StringUtils.isEmpty(updateCarDto.getCarweight())){
			result.setSuccess(false);
			result.setMsg("载重不能为空");
			return;
		}else if(StringUtils.isEmpty(updateCarDto.getCarlength())){
			result.setSuccess(false);
			result.setMsg("车长不能为空");
			return;
		}else if(StringUtils.isEmpty(updateCarDto.getCarusername())){
			result.setSuccess(false);
			result.setMsg("联系人姓名不能为空");
			return;
		}else if(StringUtils.isEmpty(updateCarDto.getCaruserphone())){
			result.setSuccess(false);
			result.setMsg("联系人手机号不能为空");
			return;
		}else{
			result.setSuccess(true);
			result.setMsg("验证成功");
			return;
		}
	}
}
