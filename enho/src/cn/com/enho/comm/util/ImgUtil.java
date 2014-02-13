package cn.com.enho.comm.util;

import java.io.BufferedInputStream;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.Calendar;
import java.util.Iterator;

import javax.imageio.ImageIO;
import javax.imageio.ImageReader;
import javax.imageio.stream.MemoryCacheImageInputStream;

import net.coobird.thumbnailator.Thumbnails;

import com.sun.imageio.plugins.bmp.BMPImageReader;
import com.sun.imageio.plugins.gif.GIFImageReader;
import com.sun.imageio.plugins.jpeg.JPEGImageReader;
import com.sun.imageio.plugins.png.PNGImageReader;

public class ImgUtil {

	private static final int IMAGE_SIZE = 120;
	
	/**
	 * 创建缩略图
	 * @param srcFile
	 * @param destFile
	 */
	public static void createPreviewImage(InputStream src, File fo) {    
		try {
			Thumbnails.of(src)   
			.size(IMAGE_SIZE, IMAGE_SIZE)   
			.keepAspectRatio(false)   
			.toFile(fo);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
    }  
	
	/**
	 * 获取图片格式
	 * @param fis
	 * @return
	 * @throws IOException
	 */
	@SuppressWarnings("rawtypes")
	public static String getImageType(InputStream fis) throws IOException {  
		 int leng = fis.available();  
		 BufferedInputStream buff = new BufferedInputStream(fis);  
		 byte[] mapObj = new byte[leng];  
		 buff.read(mapObj, 0, leng);  
		
		 String type = "";  
		 ByteArrayInputStream bais = null;  
		 MemoryCacheImageInputStream mcis = null;  
		 try {  
		     bais = new ByteArrayInputStream(mapObj);  
		     mcis = new MemoryCacheImageInputStream(bais);  
		     Iterator itr = ImageIO.getImageReaders(mcis);  
		     while (itr.hasNext()) {  
		    	 ImageReader reader = (ImageReader)  itr.next();  
		         if (reader instanceof GIFImageReader) {  
		             type = "gif";  
		         } else if (reader instanceof JPEGImageReader) {  
		             type = "jpeg";  
		         } else if (reader instanceof PNGImageReader) {  
		             type = "png";  
		         } else if (reader instanceof BMPImageReader) {  
		             type = "bmp";  
		         } else{
		        	 type="";
		         }
		     }  
		 } finally {  
		     if (bais != null) {  
		         try {  
		             bais.close();  
		         } catch (IOException ioe) {  
		         }  
		     }  
		     if (mcis != null) {  
		         try {  
		             mcis.close();  
		         } catch (IOException ioe) {  
		
		         }  
		     }  
		 }  
		 return type;  
	}  
	
	public static String getFileName(){
		int year=Calendar.getInstance().get(Calendar.YEAR);
		int month=Calendar.getInstance().get(Calendar.MONTH)+1;
		int date=Calendar.getInstance().get(Calendar.DATE);
		int hour=Calendar.getInstance().get(Calendar.HOUR_OF_DAY);
		int mintue=Calendar.getInstance().get(Calendar.MINUTE);
		int second=Calendar.getInstance().get(Calendar.SECOND);
		int millisecond=Calendar.getInstance().get(Calendar.MILLISECOND);
		return ""+year+month+date+hour+mintue+second+millisecond+(int)(Math.random()*9999);
	}
}
