package cn.com.enho.terminal.action;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.com.enho.comm.Result;
import cn.com.enho.comm.constants.Constants;
import cn.com.enho.terminal.dto.QryShareImgListDto;
import cn.com.enho.terminal.service.ImageService;

/**
 * 		查询所有分享的图片
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-16 上午10:17:03
 */
@Controller
@RequestMapping("/terminal")
public class QryShareImgListAction {

	@Autowired
	private ImageService imageService;
	
	static Logger logger = Logger.getLogger(QryShareImgListAction.class.getName());
	
	@RequestMapping(value="/qryShareImgList")
	@ResponseBody 
	public Result qryShareImgList(QryShareImgListDto qryShareImgListDto){
		logger.debug("*********************************************查询所有分享的图片列表	start*********************************************");
		
		Result result=new Result();
		try{
			//表单验证
			validParam(qryShareImgListDto,result);
			//验证成功
			if(result.getSuccess()){
				this.imageService.qryShareImgList(qryShareImgListDto,result);
			}else{//验证失败
			}
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("查询出现异常");
			return result;
		}
		
	}
	
	//表单验证
	public void validParam(QryShareImgListDto qryShareImgListDto,Result result){
		if(qryShareImgListDto.getCurrentpage()==null || qryShareImgListDto.getCurrentpage()<=0){
			qryShareImgListDto.setCurrentpage(Constants.DEFAULT_CURRENTPAGE);
		}
		if(qryShareImgListDto.getPagesize()==null || qryShareImgListDto.getPagesize()<=0){
			qryShareImgListDto.setPagesize(Constants.DEFAULT_PAGESIZE);
		}
		result.setSuccess(true);
		result.setMsg("验证成功");
		return;
	}
}
