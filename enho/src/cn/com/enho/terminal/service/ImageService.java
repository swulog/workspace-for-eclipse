package cn.com.enho.terminal.service;

import cn.com.enho.base.service.BaseService;
import cn.com.enho.comm.Result;
import cn.com.enho.terminal.dto.QryShareImgListBySelfDto;
import cn.com.enho.terminal.dto.QryShareImgListDto;
import cn.com.enho.terminal.dto.ShareImgDto;

/**
 * 		图片操作Service接口
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-16 上午10:28:06
 */
public interface ImageService extends BaseService{

	public void qryShareImgList(QryShareImgListDto qryShareImgListDto,Result result);
	public void qryShareImgList(QryShareImgListBySelfDto qryShareImgListBySelfDto,Result result);
	public void shareImg(ShareImgDto shareImgDto,Result result);
}
