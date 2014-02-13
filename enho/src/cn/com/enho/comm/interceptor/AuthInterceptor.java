package cn.com.enho.comm.interceptor;

import java.io.PrintWriter;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.ehcache.Cache;
import net.sf.ehcache.Element;
import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import cn.com.enho.comm.Result;

/**
 * 		权限拦截器
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-15 上午9:38:40
 */
public class AuthInterceptor extends HandlerInterceptorAdapter {

	@Autowired
	private Cache sessioncache;
	
	static Logger logger = Logger.getLogger(AuthInterceptor.class.getName());
	
	@SuppressWarnings("rawtypes")
	public boolean preHandle(HttpServletRequest request,HttpServletResponse response, Object handler) throws Exception {
		
		logger.debug("*************************************       进入拦截器                                 ************************************************");
		
		//uuid空验证
		String uuid=request.getParameter("uuid");
		if(uuid==null || "".equals(uuid)){
			logger.debug("**********************************         uuid不能为空                         **************************************");
			response.setCharacterEncoding("utf-8");
			response.setContentType("text/html; charset=utf-8");
			PrintWriter pw=response.getWriter();
			Result result=new Result();
			result.setSuccess(false);
			result.setMsg("请登录");
			pw.write(JSONObject.fromObject(result).toString());
			pw.flush();
			return false;
		}
		
		/**
		 * 遍历sessioncache查询uuid是否存在
		 */
		List list=sessioncache.getKeys();
		if(list!=null && list.size()>0){
			for(int i=0,len=list.size();i<len;i++){
				Element ele=sessioncache.get(list.get(i));
				if(ele!=null){
					Object obj=ele.getObjectValue();
					if(obj!=null){
						String uuid4cache=(String)obj;
						if(uuid.equals(uuid4cache)){
							return true;
						}
					}
				}
			}
		}
		
		response.setCharacterEncoding("utf-8");
		response.setContentType("text/html; charset=utf-8");
		PrintWriter pw=response.getWriter();
		Result result=new Result();
		result.setSuccess(false);
		result.setMsg("请登陆");
		pw.write(JSONObject.fromObject(result).toString());
		pw.flush();
		return false;
	}
}
