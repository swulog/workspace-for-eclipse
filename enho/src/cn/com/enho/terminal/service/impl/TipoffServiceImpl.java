package cn.com.enho.terminal.service.impl;
import org.springframework.beans.factory.annotation.Autowired;

import cn.com.enho.base.service.impl.BaseServiceImpl;
import cn.com.enho.comm.Result;
import cn.com.enho.comm.util.DateUtil;
import cn.com.enho.comm.util.StringUtil;
import cn.com.enho.comm.util.UUIDUtil;
import cn.com.enho.terminal.dao.TipoffDao;
import cn.com.enho.terminal.dto.TipoffDto;
import cn.com.enho.terminal.entity.Tipoff;
import cn.com.enho.terminal.entity.User;
import cn.com.enho.terminal.service.TipoffService;

/**
 * 		举报Service实现类
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-16 下午2:01:12
 */
public class TipoffServiceImpl extends BaseServiceImpl implements TipoffService{

	@Autowired
	private TipoffDao tipoffDao;
	
	/**
	 * 举报
	 */
	@Override
	public void addTipoff(TipoffDto tipoffDto, Result result) {
		// TODO Auto-generated method stub
		Tipoff tipoff=new Tipoff();
		tipoff.setT_report_id(UUIDUtil.getUUID());//id
		tipoff.setT_report_reported_phone(tipoffDto.getReportphone());//被举报手机号码
		tipoff.setT_report_reported_name(StringUtil.nullToStr(tipoffDto.getReportname()));//被举报人名称
		tipoff.setT_report_type(StringUtil.nullToStr(tipoffDto.getReporttype()));//举报类型
		tipoff.setT_report_content(tipoffDto.getContent());//举报内容
		tipoff.setT_report_createtime(DateUtil.getCurrentTime4Str());//举报时间
		
		User user=new User();
		user.setT_user_id(tipoffDto.getUserid());
		tipoff.setUser(user);
		
		this.tipoffDao.insert(tipoff);
		
		//举报成功
		result.setSuccess(true);
		result.setMsg("举报成功");
	}

}
