package com.university.interceptor;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class LoginFilter implements Filter{

	public void destroy() {
		
	}

	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain chain) throws IOException, ServletException {
		
		//获取session中的数据
		HttpServletRequest req = (HttpServletRequest)request;
		Object obj  = req.getSession().getAttribute("user");
		if(obj==null){
			//剔除出
			((HttpServletResponse)response).sendRedirect(req.getContextPath()+"/login.jsp");
		}else{
			//继续下一步
			chain.doFilter(request, response);
		}				
	}

	public void init(FilterConfig arg0) throws ServletException {
		
	}
}
