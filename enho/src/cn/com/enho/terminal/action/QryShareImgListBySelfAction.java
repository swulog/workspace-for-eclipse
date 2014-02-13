package cn.com.enho.terminal.action;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.com.enho.comm.Result;
import cn.com.enho.comm.constants.Constants;
import cn.com.enho.terminal.dto.QryShareImgListBySelfDto;
import cn.com.enho.terminal.service.ImageService;

/**
 * 		查询自己分享的图片
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-16 上午10:51:15
 */
@Controller
@RequestMapping("/terminal")
public class QryShareImgListBySelfAction {

	@Autowired
	private ImageService imageService;
	
	static Logger logger = Logger.getLogger(QryShareImgListBySelfAction.class.getName());
	
	@RequestMapping(value="/qryShareImgListBySelf")
	@ResponseBody 
	public Result qryShareImgListBySelf(QryShareImgListBySelfDto qryShareImgListBySelfDto){
		logger.debug("*********************************************查询自己分享的图片列表	start*********************************************");
		
		Result result=new Result();
		try{
			//表单验证
			validParam(qryShareImgListBySelfDto,result);
			//验证成功
			if(result.getSuccess()){
				this.imageService.qryShareImgList(qryShareImgListBySelfDto,result);
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
	public void validParam(QryShareImgListBySelfDto qryShareImgListBySelfDto,Result result){
		if(StringUtils.isEmpty(qryShareImgListBySelfDto.getUserid())){
			result.setSuccess(false);
			result.setMsg("用户id不能为空");
			return;
		}else{
			if(qryShareImgListBySelfDto.getCurrentpage()==null || qryShareImgListBySelfDto.getCurrentpage()<=0){
				qryShareImgListBySelfDto.setCurrentpage(Constants.DEFAULT_CURRENTPAGE);
			}
			if(qryShareImgListBySelfDto.getPagesize()==null || qryShareImgListBySelfDto.getPagesize()<=0){
				qryShareImgListBySelfDto.setPagesize(Constants.DEFAULT_PAGESIZE);
			}
			result.setSuccess(true);
			result.setMsg("验证成功");
			return;
		}
	}
}
