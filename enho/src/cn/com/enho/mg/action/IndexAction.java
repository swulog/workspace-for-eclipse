package cn.com.enho.mg.action;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import cn.com.enho.mg.dto.AppDto;

/**
 * 		后台管理首页
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-9-27 上午11:32:13
 */
@Controller
@RequestMapping("/mg")
public class IndexAction {
	
	static Logger logger = Logger.getLogger(IndexAction.class.getName());
	
	@RequestMapping(value="/index")
	public ModelAndView addAppPre(AppDto appDto){
		ModelAndView mav=new ModelAndView();
		mav.setViewName("admin/index");
		return mav;
	}
}
