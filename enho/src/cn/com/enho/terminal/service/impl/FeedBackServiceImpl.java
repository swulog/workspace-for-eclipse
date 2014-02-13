package cn.com.enho.terminal.service.impl;

import org.springframework.beans.factory.annotation.Autowired;

import cn.com.enho.base.service.impl.BaseServiceImpl;
import cn.com.enho.comm.Result;
import cn.com.enho.comm.util.DateUtil;
import cn.com.enho.comm.util.UUIDUtil;
import cn.com.enho.terminal.dao.FeedBackDao;
import cn.com.enho.terminal.dto.PubFeedBackDto;
import cn.com.enho.terminal.entity.FeedBack;
import cn.com.enho.terminal.entity.User;
import cn.com.enho.terminal.service.FeedBackService;

/**
 * 		反馈信息操作Service实现类
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-16 上午11:38:57
 */
public class FeedBackServiceImpl extends BaseServiceImpl implements FeedBackService{

	@Autowired
	private FeedBackDao feedBackDao;
	
	/**
	 * 发布反馈信息
	 */
	@Override
	public void addFeedBack(PubFeedBackDto pubFeedBackDto, Result result) {
		// TODO Auto-generated method stub
		FeedBack fb=new FeedBack();
		fb.setT_feedback_id(UUIDUtil.getUUID());//id
		fb.setT_feedback_content(pubFeedBackDto.getContent());//内容
		fb.setT_feedback_createtime(DateUtil.getCurrentTime4Str());//反馈时间
		
		User user=new User();
		user.setT_user_id(pubFeedBackDto.getUserid());
		fb.setUser(user);
		
		this.feedBackDao.insert(fb);
		
		//发布成功
		result.setSuccess(true);
		result.setMsg("发布成功");
	}

}
