package cn.com.enho.comm.listener;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Iterator;
import java.util.Properties;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.apache.log4j.Logger;

import cn.com.enho.comm.util.FileUtil;

/**
 * 		配置文件加载监听器类
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-15 下午5:09:47
 */
public class ConfigLoad4FileListener implements ServletContextListener{

	//配置文件存放目录
	private static final String CONFIG_DIR="/WEB-INF/config";
	
	static Logger logger = Logger.getLogger(ConfigLoad4FileListener.class.getName());
	
	@Override
	public void contextDestroyed(ServletContextEvent sce) {
		// TODO Auto-generated method stub
		
	}

	@SuppressWarnings("rawtypes")
	@Override
	public void contextInitialized(ServletContextEvent sce) {
		// TODO Auto-generated method stub
		logger.debug("*******************开始读取配置文件********************");
		
		logger.debug(sce.getServletContext().getRealPath(CONFIG_DIR));
		
		File[] files=FileUtil.getFiles(sce.getServletContext().getRealPath("/WEB-INF/config"), ".properties");
		
		if(files!=null && files.length>0){
			for(int i=0,len=files.length;i<len;i++){
				try {
					Properties prop = new Properties();
					InputStream is = new FileInputStream(files[i]);
					BufferedReader br=new BufferedReader(new InputStreamReader(is,"utf-8")); 
					prop.load(br);
					for(Iterator it=prop.keySet().iterator();it.hasNext();){
						String key=(String)it.next();
						String value=(String)prop.get(key);
						sce.getServletContext().setAttribute(key,value);
					}
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
					logger.debug("属性文件加载异常");
				}
			}
			
		}
		logger.debug("*******************成功读取配置文件********************");
	}

}
