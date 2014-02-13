package cn.com.enho.terminal.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;

import cn.com.enho.base.service.impl.BaseServiceImpl;
import cn.com.enho.comm.Result;
import cn.com.enho.comm.constants.Constants;
import cn.com.enho.comm.util.DateUtil;
import cn.com.enho.comm.util.StringUtil;
import cn.com.enho.comm.util.UUIDUtil;
import cn.com.enho.terminal.dao.FocusDao;
import cn.com.enho.terminal.dto.QryFocusUserListDto;
import cn.com.enho.terminal.entity.Focusrelation;
import cn.com.enho.terminal.entity.User;
import cn.com.enho.terminal.service.FocusService;

/**
 * 		关注用户Service实现类
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-15 上午11:20:22
 */
public class FocusServiceImpl extends BaseServiceImpl implements FocusService{

	@Autowired
	private FocusDao focusDao;
	
	/**
	 * 添加关注关系
	 */
	@Override
	public void addFocusrelation(String userid1, String userid2, Result result) {
		// TODO Auto-generated method stub
		Focusrelation focusrelation=new Focusrelation();
		focusrelation.setT_focus_id(UUIDUtil.getUUID());//id
		User user1=new User();
		User user2=new User();
		user1.setT_user_id(userid1);//关注者id
		user2.setT_user_id(userid2);//被关注者id
		focusrelation.setUser_focus(user1);
		focusrelation.setUser_focused(user2);
		focusrelation.setT_focus_createtime(DateUtil.getCurrentTime4Str());//创建时间
		focusrelation.setT_focus_isabled(Constants.ABLE_YES);//是否启用
		this.focusDao.insert(focusrelation);
		
		//添加成功
		result.setSuccess(true);
		result.setMsg("关注成功");
	}

	/**
	 * 查询已关注用户列表
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void qryFocusUserList(QryFocusUserListDto qryFocusUserListDto,
			Result result) {
		// TODO Auto-generated method stub
		StringBuilder sb=new StringBuilder();
		sb.append("from Focusrelation f where f.user_focus.t_user_id=? and f.t_focus_isabled="+Constants.ABLE_YES);
		sb.append(" order by f.t_focus_createtime desc");
		List<Focusrelation> list=(List<Focusrelation>)this.focusDao.findByHql(sb.toString(), (qryFocusUserListDto.getCurrentpage()-1)*qryFocusUserListDto.getPagesize(), qryFocusUserListDto.getPagesize(), qryFocusUserListDto.getUserid());
		
		List<Object> listData=new ArrayList<Object>();
		if(list!=null && list.size()>0){
			for(int i=0,len=list.size();i<len;i++){
				Map<Object,Object> mapData=new HashMap<Object,Object>();
				mapData.put("focusid", list.get(i).getT_focus_id());//关系id
				mapData.put("userfocusid", list.get(i).getUser_focus().getT_user_id());//关注人id
				mapData.put("userfocusedid", list.get(i).getUser_focused().getT_user_id());//被关注人id
				mapData.put("username", StringUtil.nullToStr(list.get(i).getUser_focused().getT_user_name()));//名称
				mapData.put("userphone", StringUtil.nullToStr(list.get(i).getUser_focused().getT_user_phone()));//手机号码
				mapData.put("usertel", StringUtil.nullToStr(list.get(i).getUser_focused().getT_user_tel()));//电话号码
				listData.add(mapData);
			}
		}
		
		result.setSuccess(true);
		result.setMsg("查询成功");
		result.getData().put("list", listData);
	}

	/**
	 * 删除已关注用户
	 */
	@Override
	public void deleteFocusUser(String focuseid, Result result) {
		// TODO Auto-generated method stub
		Focusrelation focusrelation=new Focusrelation();
		focusrelation.setT_focus_id(focuseid);
		this.focusDao.delete(focusrelation);
		
		//删除成功
		result.setSuccess(true);
		result.setMsg("删除成功");
	}

}
