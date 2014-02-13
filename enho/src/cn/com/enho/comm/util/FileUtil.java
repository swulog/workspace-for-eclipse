package cn.com.enho.comm.util;

import java.io.File;
import java.io.FileFilter;

/**
 * 		文件工具类
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-8 上午11:15:50
 */
public class FileUtil {

	/**
	 * 获取指定目录下指定类型的文件列表
	 * @param dirpath
	 * @param suffix
	 * @return
	 */
	public static File[] getFiles(String dirpath,final String suffix){
		if(dirpath==null || "".equals(dirpath)){
			return null;
		}
		File dir=new File(dirpath);
		if(!dir.exists()){
			return null;
		}
		if(!dir.isDirectory()){
			return null;
		}
		
		File[] files=dir.listFiles(new FileFilter() {
			@Override
			public boolean accept(File file) {
				// TODO Auto-generated method stub
				return (file.isFile() && file.getName().endsWith(suffix));
			}
		});
		return files;
	}
	
	
}
