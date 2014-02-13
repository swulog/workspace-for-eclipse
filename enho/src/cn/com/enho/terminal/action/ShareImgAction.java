package cn.com.enho.terminal.action;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.com.enho.comm.Result;
import cn.com.enho.terminal.dto.ShareImgDto;
import cn.com.enho.terminal.service.ImageService;

/**
 * 		分享图片
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-16 上午11:03:53
 */
@Controller
@RequestMapping("/terminal")
public class ShareImgAction {

	@Autowired
	private ImageService imageService;
	
	static Logger logger = Logger.getLogger(ShareImgAction.class.getName());
	
	@RequestMapping(value="/shareImg")
	@ResponseBody 
	public Result shareImg(ShareImgDto shareImgDto){
		logger.debug("*********************************************分享图片	start*********************************************");
		
		Result result=new Result();
		try{
			//表单验证
			validParam(shareImgDto,result);
			//验证成功
			if(result.getSuccess()){
				this.imageService.shareImg(shareImgDto,result);
			}else{//验证失败
			}
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("分享图片出现异常");
			return result;
		}
		
	}
	
	//表单验证
	public void validParam(ShareImgDto shareImgDto,Result result){
		if(StringUtils.isEmpty(shareImgDto.getUserid())){
			result.setSuccess(false);
			result.setMsg("用户id不能为空");
			return;
		}else if(StringUtils.isEmpty(shareImgDto.getImgurl())){
			result.setSuccess(false);
			result.setMsg("图片url不能为空");
			return;
		}else{
			result.setSuccess(true);
			result.setMsg("验证成功");
			return;
		}
	}
}
