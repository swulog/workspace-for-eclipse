package cn.com.enho.terminal.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;

import cn.com.enho.base.service.impl.BaseServiceImpl;
import cn.com.enho.comm.Result;
import cn.com.enho.comm.util.DateUtil;
import cn.com.enho.comm.util.StringUtil;
import cn.com.enho.comm.util.UUIDUtil;
import cn.com.enho.terminal.dao.ImageDao;
import cn.com.enho.terminal.dto.QryShareImgListBySelfDto;
import cn.com.enho.terminal.dto.QryShareImgListDto;
import cn.com.enho.terminal.dto.ShareImgDto;
import cn.com.enho.terminal.entity.Image;
import cn.com.enho.terminal.entity.User;
import cn.com.enho.terminal.service.ImageService;

/**
 * 		图片操作Service实现类
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-16 上午10:20:04
 */
public class ImageServiceImpl extends BaseServiceImpl implements ImageService{

	@Autowired
	private ImageDao imageDao;
	
	/**
	 * 查询所有分享的图片
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void qryShareImgList(QryShareImgListDto qryShareImgListDto,
			Result result) {
		// TODO Auto-generated method stub
		StringBuilder sb=new StringBuilder();
		sb.append("from Image i order by i.t_image_createtime desc");
		List<Image> list=(List<Image>)this.imageDao.findByHql(sb.toString(), (qryShareImgListDto.getCurrentpage()-1)*qryShareImgListDto.getPagesize(), qryShareImgListDto.getPagesize());
		
		List<Object> listData=new ArrayList<Object>();
		if(list!=null && list.size()>0){
			for(int i=0,len=list.size();i<len;i++){
				Map<Object,Object> mapData=new HashMap<Object,Object>();
				mapData.put("imgid", list.get(i).getT_image_id());//id
				mapData.put("imgurl", StringUtil.nullToStr(list.get(i).getT_image_url()));//image url
				mapData.put("imgdesc", StringUtil.nullToStr(list.get(i).getT_image_desc()));//image 描述
				mapData.put("imguserid", list.get(i).getUser().getT_user_id());//分享用户id
				mapData.put("imgusername", StringUtil.nullToStr(list.get(i).getUser().getT_user_name()));//分享用户name
				mapData.put("createtime", list.get(i).getT_image_createtime());//分享时间
				listData.add(mapData);
			}
		}
		
		result.setSuccess(true);
		result.setMsg("查询成功");
		result.getData().put("list", listData);
	}

	/**
	 * 查询某一用户分享的图片
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void qryShareImgList(
			QryShareImgListBySelfDto qryShareImgListBySelfDto, Result result) {
		// TODO Auto-generated method stub
		StringBuilder sb=new StringBuilder();
		sb.append("from Image i where i.user.t_user_id=? order by i.t_image_createtime desc");
		List<Image> list=(List<Image>)this.imageDao.findByHql(sb.toString(), (qryShareImgListBySelfDto.getCurrentpage()-1)*qryShareImgListBySelfDto.getPagesize(), qryShareImgListBySelfDto.getPagesize(),qryShareImgListBySelfDto.getUserid());
		
		List<Object> listData=new ArrayList<Object>();
		if(list!=null && list.size()>0){
			for(int i=0,len=list.size();i<len;i++){
				Map<Object,Object> mapData=new HashMap<Object,Object>();
				mapData.put("imgid", list.get(i).getT_image_id());//id
				mapData.put("imgurl", StringUtil.nullToStr(list.get(i).getT_image_url()));//image url
				mapData.put("imgdesc", StringUtil.nullToStr(list.get(i).getT_image_desc()));//image 描述
				mapData.put("imguserid", list.get(i).getUser().getT_user_id());//分享用户id
				mapData.put("imgusername", StringUtil.nullToStr(list.get(i).getUser().getT_user_name()));//分享用户name
				mapData.put("createtime", list.get(i).getT_image_createtime());//分享时间
				listData.add(mapData);
			}
		}
		
		result.setSuccess(true);
		result.setMsg("查询成功");
		result.getData().put("list", listData);
	}

	/**
	 * 分享图片
	 */
	@Override
	public void shareImg(ShareImgDto shareImgDto, Result result) {
		// TODO Auto-generated method stub
		Image image=new Image();
		image.setT_image_id(UUIDUtil.getUUID());//id
		image.setT_image_url(shareImgDto.getImgurl());//url
		image.setT_image_desc(StringUtil.nullToStr(shareImgDto.getImgdesc()));//desc
		image.setT_image_createtime(DateUtil.getCurrentTime4Str());//分享时间
		
		User user=new User();
		user.setT_user_id(shareImgDto.getUserid());
		image.setUser(user);//userid
		
		this.imageDao.insert(image);
		
		//分享成功
		result.setSuccess(true);
		result.setMsg("分享成功");
	}

}
