package cn.com.enho.mg.action;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import cn.com.enho.comm.ExcelUserBean;
import cn.com.enho.comm.Result;
import cn.com.enho.comm.util.ExcelUtil;
import cn.com.enho.mg.dto.UserDto;
import cn.com.enho.mg.service.MgService;

/**
 * 		批量导入用户
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-10-23 上午10:44:37
 */
@Controller
@RequestMapping("/mg")
public class ImportUser {

	@Autowired
	private MgService mgService;
	
	static Logger logger = Logger.getLogger(ImportUser.class.getName());
	
	@RequestMapping(value="/importUserPre")
	public ModelAndView addUserPre(UserDto userDto){
		ModelAndView mav=new ModelAndView();
		mav.addObject("gridid",userDto.getGridid());
		mav.setViewName("admin/importUserPre");
		return mav;
	}
	
	@RequestMapping(value="/importUserConfirm")
	@ResponseBody 
	public Result importUserConfirm(HttpServletRequest request,@RequestParam MultipartFile batchuser){
		logger.debug("*********************************************批量导入用户	start*********************************************");
		
		Result result=new Result();
		try{
			//文件校验
			if(batchuser==null){
				result.setSuccess(false);
				result.setMsg("Excel文件为空");
				return result;
			}
			
			//文件名称校验
			String filename=batchuser.getOriginalFilename();
			//如果文件名称为空
			if(filename==null || "".equals(filename)){
				result.setSuccess(false);
				result.setMsg("文件名称不能为空");
				return result;
			}
			
			//验证文件格式
			String suff=filename.substring(filename.lastIndexOf(".")+1);
			if(!"xls".equalsIgnoreCase(suff) && !"xlsx".equalsIgnoreCase(suff)){
				result.setSuccess(false);
				result.setMsg("文件格式应为xls/xlsx");
				return result;
			}
			List<ExcelUserBean> list=ExcelUtil.readXls(batchuser.getInputStream());
			String baseurl=request.getServletContext().getAttribute("userimg").toString()+"/";
			this.mgService.importUser(list,baseurl,result);
			
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("批量导入异常");
			return result;
		}
		
	}
}
