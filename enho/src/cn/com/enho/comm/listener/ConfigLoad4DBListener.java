package cn.com.enho.comm.listener;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Properties;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.apache.log4j.Logger;

/**
 * 		配置文件加载监听器类
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-15 下午5:09:47
 */
public class ConfigLoad4DBListener implements ServletContextListener{

	//配置文件存放目录
	private static final String DB_FILE="/WEB-INF/Hibernate.properties";
	static Logger logger = Logger.getLogger(ConfigLoad4DBListener.class.getName());

	@Override
	public void contextDestroyed(ServletContextEvent sce) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void contextInitialized(ServletContextEvent sce) {
		// TODO Auto-generated method stub
		logger.debug("*******************开始读取数据库数据********************");
		
		logger.debug(sce.getServletContext().getRealPath(DB_FILE));
		try{
			//读取数据库属性配置文件
			File file=new File(sce.getServletContext().getRealPath(DB_FILE));
			Properties prop = new Properties();
			InputStream is = new FileInputStream(file);
			BufferedReader br=new BufferedReader(new InputStreamReader(is,"utf-8")); 
			prop.load(br);
			
			//获取相关数据库属性
			String driverClass=prop.get("driverClass").toString();
			String jdbcUrl=prop.get("jdbcUrl").toString();
			String user=prop.get("user").toString();
			String password=prop.get("password").toString();
			
			//数据库查询
			Class.forName(driverClass);
			Connection conn=DriverManager.getConnection(jdbcUrl, user, password);
			Statement stmt = conn.createStatement();
			ResultSet rs = stmt.executeQuery( "select t_rule_key,t_rule_value from t_rule where t_rule_isabled=1" );
			
			//把结果写入内存
			while (rs.next()){
				String key=rs.getString("t_rule_key");
				String value=rs.getString("t_rule_value");
				if(key!=null && !"".equals(key)){
					sce.getServletContext().setAttribute(key,value);
				}
			}
			
			logger.debug("数据库规则加载成功。。。");
		}catch(Exception e){
			e.printStackTrace();
			logger.debug("数据库规则加载失败。。。");
		}
	}
}
