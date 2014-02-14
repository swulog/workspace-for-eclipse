package com.ivorytower.app.action;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ivorytower.app.entity.Postlistinfo;
import com.ivorytower.app.entity.Userbaseinfo;
import com.ivorytower.app.entity.Userexpandinfo;
import com.ivorytower.app.service.UserbaseinfoService;
import com.ivorytower.comm.Result;







@Controller
@RequestMapping("/comm")
public class TestAction {

	static Logger logger = Logger.getLogger(TestAction.class.getName());
	
	@Autowired
	private UserbaseinfoService userbaseinfoService;
	
	@RequestMapping(value="/test")
	@ResponseBody 
	public Result test(){
		
		Result result=new Result();
		try{
//			Userbaseinfo userbaseinfo=new Userbaseinfo();
//			userbaseinfo.setUbiUsername("龙超");
//			Timestamp ts = new Timestamp(Calendar.getInstance().getTime().getTime());
//			userbaseinfo.setUbiCreatetime(ts);
//			userbaseinfo.setUbiPwd("dfgdf");
//			userbaseinfo.setUbiStatus(2);
//			this.userbaseinfoService.addUserbaseinfo(userbaseinfo);
			
			
//			Userbaseinfo userbaseinfo = this.userbaseinfoService.getUserbaseinfoById(1);
//			result.getData().put("username", userbaseinfo.getUbiUsername());
//			result.setSuccess(true);
//			result.setMsg("测试成功");
//			
//			Userexpandinfo userexpandinfo = userbaseinfo.getUserExpand();
//			System.out.println(userexpandinfo.getUeiNickname());
			
			List<Postlistinfo> postlist = this.userbaseinfoService.findUserPostListById(1);
			List<Object> listData=new ArrayList<Object>();
			if (postlist.size() > 0) {
				for (int i=0;i<postlist.size();i++) {
					Map<Object,Object> mapData=new HashMap<Object,Object>();
					mapData.put("content", postlist.get(i).getPliContent());
					mapData.put("createtime", postlist.get(i).getPliCreatetime());
					mapData.put("pid", postlist.get(i).getPliId());
					mapData.put("istop", postlist.get(i).getPliIstop());
					mapData.put("pttid", postlist.get(i).getPliPtiid());
					mapData.put("replynum", postlist.get(i).getPliReplynum());
					mapData.put("reportnum", postlist.get(i).getPliReportnum());
					mapData.put("status", postlist.get(i).getPliStatus());
					mapData.put("title", postlist.get(i).getPliTitle());
					mapData.put("userid", postlist.get(i).getPliUserid());
					listData.add(mapData);
				}
			}
			
			result.getData().put("list", listData);
			result.setMsg("成功");
			result.setSuccess(true);
			
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("test出现异常");
			return result;
		}
	}
	
}
