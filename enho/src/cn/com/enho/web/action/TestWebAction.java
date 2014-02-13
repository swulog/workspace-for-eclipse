package cn.com.enho.web.action;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

/**
 * 		附件上传
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-9-9 下午2:42:39
 */
@Controller
@RequestMapping("/web")
public class TestWebAction {

	static Logger logger = Logger.getLogger(TestWebAction.class.getName());
	
	
	@RequestMapping(value="/webtest")
	public ModelAndView test(){
		logger.debug("*********************************************测试	start*********************************************");
		
		ModelAndView mav=new ModelAndView();
		mav.addObject("aa", "hello");
		mav.setViewName("web/test2");
		return mav;
		
	}
}
