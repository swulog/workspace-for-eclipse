package cn.com.enho.terminal.action;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.task.TaskExecutor;
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
import cn.com.enho.comm.util.JSONUtil;
import cn.com.enho.comm.util.SMSUtil;
import cn.com.enho.comm.util.StringUtil;
import cn.com.enho.terminal.dto.PubGoodsDto;
import cn.com.enho.terminal.dto.QryCarListDto;
import cn.com.enho.terminal.entity.Wayline;
import cn.com.enho.terminal.service.CarService;
import cn.com.enho.terminal.service.GoodsService;

/**
 * 		发布货源信息
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-9 上午11:44:41
 */
@Controller
@RequestMapping("/terminal")
public class PubGoodsAction {
	
	@Autowired
	private GoodsService goodsService;
	
	@Autowired
	private CarService carService;
	
	@Autowired
	private TaskExecutor taskExecutor;//线程池
	
	static Logger logger = Logger.getLogger(PubGoodsAction.class.getName());
	
	
	@SuppressWarnings({ "unchecked"})
	@RequestMapping(value="/pubGoods")
	@ResponseBody 
	public Result pubGoods(HttpServletRequest request,@RequestParam(value="image1",required = false)MultipartFile image1,@RequestParam(value="image2",required = false)MultipartFile image2,
						@RequestParam(value="image3",required = false)MultipartFile image3,PubGoodsDto pubGoodsDto){
		logger.debug("*********************************************发布货源信息	start*********************************************");
		
		Result result=new Result();
		try{
			//表单验证
			validParam(pubGoodsDto,result);
			//验证成功
			if(result.getSuccess()){
				if(image1!=null && !image1.isEmpty()){
					uploadImage(request,image1,"",result);
					if(result.getSuccess()){
						pubGoodsDto.setImageurl1(result.getData().get("url").toString());//相对路径
					}else{
						return result;
					}
				}else{
					pubGoodsDto.setImageurl1("");//相对路径
				}
				
				if(image2!=null && !image2.isEmpty()){
					uploadImage(request,image2,"",result);
					if(result.getSuccess()){
						pubGoodsDto.setImageurl2(result.getData().get("url").toString());//相对路径
					}else{
						return result;
					}
				}else{
					pubGoodsDto.setImageurl2("");//相对路径
				}
				
				if(image3!=null && !image3.isEmpty()){
					uploadImage(request,image3,"",result);
					if(result.getSuccess()){
						pubGoodsDto.setImageurl3(result.getData().get("url").toString());//相对路径
					}else{
						return result;
					}
				}else{
					pubGoodsDto.setImageurl3("");//相对路径
				}
				
				//发布货源
				this.goodsService.addGoods(pubGoodsDto,result);
				
				//如果货源发布成功，则推送消息或者发布短信
				//路线列表
				List<Wayline> wayList=JSONUtil.strToJson(pubGoodsDto.getWayline(),Wayline.class);
				
				if(wayList!=null && wayList.size()>0){
					ServletContext servletContext=request.getServletContext();
					String sms_url_utf8=servletContext.getAttribute("sms_url_utf8")==null?"":servletContext.getAttribute("sms_url_utf8").toString();
					String sms_url_gbk=servletContext.getAttribute("sms_url_gbk")==null?"":servletContext.getAttribute("sms_url_gbk").toString();
					String sms_username=servletContext.getAttribute("sms_username")==null?"":servletContext.getAttribute("sms_username").toString();
					String sms_password=servletContext.getAttribute("sms_password")==null?"":servletContext.getAttribute("sms_password").toString();
					//开启一个线程来发送短信
					this.taskExecutor.execute(new PushMsgTask(this.carService,pubGoodsDto,wayList,sms_username,sms_password,sms_url_utf8,sms_url_gbk));
				}
				
				result.setMsg("发布成功");
				result.setSuccess(true);
				return result;
			}else{//验证失败
			}
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("发布异常");
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
			String desdir=request.getServletContext().getAttribute("goodsimg").toString();//目标目录
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
	public void validParam(PubGoodsDto pubGoodsDto,Result result){
		if(StringUtils.isEmpty(pubGoodsDto.getUsertype())){
			result.setSuccess(false);
			result.setMsg("用户类型不能为空");
			return;
		}else if(Constants.USER_GE != pubGoodsDto.getUsertype() && Constants.USER_GP != pubGoodsDto.getUsertype() && Constants.USER_CE != pubGoodsDto.getUsertype()){
			result.setSuccess(false);
			result.setMsg("用户类型不正确");
			return;
		}/*else if(StringUtils.isEmpty(pubGoodsDto.getWayline())){
			result.setSuccess(false);
			result.setMsg("路线不能为空");
			return;
		}*/else if(StringUtils.isEmpty(pubGoodsDto.getGoodsdesc())){
			result.setSuccess(false);
			result.setMsg("货源描述不能为空");
			return;
		}else if(StringUtils.isEmpty(pubGoodsDto.getGoodsweight())){
			result.setSuccess(false);
			result.setMsg("货源重量不能为空");
			return;
		}else if(StringUtils.isEmpty(pubGoodsDto.getGoodscarlength())){
			result.setSuccess(false);
			result.setMsg("所需车长不能为空");
			return;
		}else if(StringUtils.isEmpty(pubGoodsDto.getGoodssendtime())){
			result.setSuccess(false);
			result.setMsg("发货时间不能为空");
			return;
		}else if(StringUtils.isEmpty(pubGoodsDto.getGoodsusername())){
			result.setSuccess(false);
			result.setMsg("联系人姓名不能为空");
			return;
		}else if(StringUtils.isEmpty(pubGoodsDto.getGoodsuserphone())){
			result.setSuccess(false);
			result.setMsg("联系人手机号不能为空");
			return;
		}else if(StringUtils.isEmpty(pubGoodsDto.getGoodsuserid())){
			result.setSuccess(false);
			result.setMsg("发布人id不能为空");
			return;
		}else{
			result.setSuccess(true);
			result.setMsg("验证成功");
			return;
		}
	}
	
	/**
	 * 		短信推送任务
	 * 		author            ：      		xionglei   
	 * 		createtime        ：  		2013-10-21 下午2:23:35
	 */
	private class PushMsgTask implements Runnable {  
		private CarService carService;
		private PubGoodsDto pubGoodsDto ;
		private List<Wayline> wayList;
		private String username;
		private String password;
		private String utf8;
		private String gbk;
        public PushMsgTask(CarService carService,PubGoodsDto pubGoodsDto ,List<Wayline> wayList,String sms_username,String sms_password,String sms_url_utf8,String sms_url_gbk) {        
            this.carService = carService;
            this.pubGoodsDto=pubGoodsDto;
            this.wayList=wayList;
            this.username=sms_username;
            this.password=sms_password;
            this.utf8=sms_url_utf8;
            this.gbk=sms_url_gbk;
        }      
        public void run() {  
        	String phones="";
        	String phones2g="";
        	for(int i=0,len=wayList.size();i<len;i++){
        		phones="";
        		phones2g="";
        		
				QryCarListDto qryCarListDto=new QryCarListDto();
				String startp=wayList.get(i).getStartp();
				String startc=wayList.get(i).getStartc();
				String startd=wayList.get(i).getStartd();
				String endp=wayList.get(i).getEndp();
				String endc=wayList.get(i).getEndc();
				String endd=wayList.get(i).getEndd();
				
				//出发地到达地处理--start
				if(!StringUtils.isEmpty(startp) && !StringUtils.isEmpty(startc)){
					if(StringUtils.isEmpty(startd)){
						if(startp.equals(startc)){
							startc="";
						}
					}else{
						if(startp.equals(startc)){
							startc=startd;
							startd="";
						}
					}
				}
				
				if(!StringUtils.isEmpty(endp) && !StringUtils.isEmpty(endc)){
					if(StringUtils.isEmpty(endd)){
						if(endp.equals(endc)){
							endc="";
						}
					}else{
						if(endp.equals(endc)){
							endc=endd;
							endd="";
						}
					}
				}
				//出发地到达地处理--end
				qryCarListDto.setCarstartp(startp);
				qryCarListDto.setCarstartc(startc);
				qryCarListDto.setCarstartd(startd);
				qryCarListDto.setCarendp(endp);
				qryCarListDto.setCarendc(endc);
				qryCarListDto.setCarendd(endd);
				
				List<String> phoneList=this.carService.qryPhone4SendMsg(qryCarListDto);
				if(phoneList==null || phoneList.size()<=0){
					continue;
				}
				String start="";
				String end="";
				//出发地
				if(startp!=null && !"".equals(startp)){
					start+=startp;
				}
				if(startc!=null && !"".equals(startc)){
					start+="-"+startc;
				}
				if(startd!=null && !"".equals(startd)){
					start+="-"+startd;
				}
				
				//到达地
				if(endp!=null && !"".equals(endp)){
					end+=endp;
				}
				if(endc!=null && !"".equals(endc)){
					end+="-"+endc;
				}
				if(endd!=null && !"".equals(endd)){
					end+="-"+endd;
				}
				
				//短信内容
				phones="";
				String smstext=start+"到"+end+"有"+this.pubGoodsDto.getGoodsweight()+"吨货需"+this.pubGoodsDto.getGoodscarlength()+"米车,货主联系方式："+pubGoodsDto.getGoodsuserphone()+",找货就到http://www.enho.com.cn/download.jsp【重庆宏程万里科技有限公司】";
				if(phoneList!=null && phoneList.size()>0){
					//给车主发送短信
					phones=phoneList.get(0);
					for(int j=1,count=phoneList.size();j<count;j++){
						if(j%50==0){
							SMSUtil.sendSMS(this.username,this.password,this.utf8,this.gbk,phones,smstext);
							phones=phoneList.get(j);
						}else{
							phones+=","+phoneList.get(j);
						}
					}
					if(phones!=null && !"".equals(phones)){//不足50个手机号码
						SMSUtil.sendSMS(this.username,this.password,this.utf8,this.gbk,phones,smstext);
						phones="";
					}
					
					//给货主发送短信
					for(int m=0,len2=phoneList.size();m<len2;m++){
						if(m==len2-1){
							phones2g+=phoneList.get(m);
						}else{
							phones2g+=phoneList.get(m)+",";
						}
					}
					String smstext2g="车主"+phones2g+" 有"+start+"到"+end+"的专线,您可以主动与他们取得联系 【重庆宏程万里科技有限公司】";
					SMSUtil.sendSMS(this.username,this.password,this.utf8,this.gbk,pubGoodsDto.getGoodsuserphone(),smstext2g);
				}
			}
        }  
    }
}
