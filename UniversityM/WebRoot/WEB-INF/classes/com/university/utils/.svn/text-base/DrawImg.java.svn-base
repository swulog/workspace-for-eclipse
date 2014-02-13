package com.university.utils;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.util.Random;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts2.ServletActionContext;

public class DrawImg {
	private Color getRandColor(int s, int e) {  
        Random random = new Random();  
        if (s > 255)  
            s = 255;  
        if (e > 255)  
            e = 255;  
        int r = random.nextInt(e - s) + s; // 随机生成RGB中的R值  
        int g = random.nextInt(e - s) + s; // 随机生成RGB中的G值  
        int b = random.nextInt(e - s) + s; // 随机生成RGB中的B值  
        return new Color(r, g, b);  
    }  
         
     public static Font getRandomFont() {    
            //String[] fonts = {"Georgia", "Verdana", "Arial", "Tahoma", "Time News Roman", "Courier New", "Arial Black", "Quantzite"};    
            String[] fonts = {"a_TrianglerCmUp","Astarisborn","WishfulWaves"};  
            Random r = new  Random();  
           int fontIndex = r.nextInt(fonts.length);  
            return new Font(fonts[fontIndex],  r.nextInt(3),50-r.nextInt(20));    
        }  
     
     @SuppressWarnings({ "static-access", "unused" })
	public void doRandom() throws Exception{
    	 HttpServletResponse response=ServletActionContext.getResponse();
    	 HttpServletRequest request=ServletActionContext.getRequest();
    	 response.setHeader("Pragma", "No-cache");  
	        response.setHeader("Cache-Control", "No-cache");  
	        response.setDateHeader("Expires", 0);  
	        //指定生成的响应图片  
	        response.setContentType("image/jpeg");  
	        int width = 120;                            //指定生成验证码图片的宽度  
	        int heigh = 65;                         //指定生成验证码图片的高度  
	            //获得图像数据缓冲对象  
	        BufferedImage bi = new BufferedImage(width,heigh,BufferedImage.TYPE_INT_RGB);  
	            //获得图形上下文的抽象基类  
	        Graphics g = bi.getGraphics();  
	        Random r = new Random();  
	        Font f = new Font("黑体",Font.PLAIN,60);  //定义字体样式  
	        g.setColor(getRandColor(200, 250));     //设置背景颜色  
	        g.fillRect(0, 0, width, heigh);         //绘制背景  
	        g.setFont(f);                           //设置字体  
	        g.setColor(getRandColor(180, 200));     //设置前景颜色  
	          
	          
	        Graphics2D g2d = (Graphics2D) g;  
	        //画一条折线       
	        //BasicStroke bs=new BasicStroke(5f,BasicStroke.CAP_BUTT,BasicStroke.JOIN_BEVEL); //创建一个供画笔选择线条粗细的对象  
	        //g2d.setStroke(bs);              //改变线条的粗细  
	        g2d.setColor(Color.DARK_GRAY);      //设置当前颜色为预定义颜色中的深灰色  
	        int[] xPoints=new int[8];  
	        int[] yPoints=new int[8];  
	        for(int j=0;j<8;j++){  
	            xPoints[j]=r.nextInt(width - 1);  
	            yPoints[j]=r.nextInt(heigh - 1);  
	        }  
	        g2d.drawPolyline(xPoints, yPoints,8);  
	          
	        String sRand = "";  
	        String ctmp = "";  
	        int itmp = 0;  
	        for (int i = 0; i < 4; i++) {  
	            switch (r.nextInt(2)) {  
	            case 1:  
	                itmp = r.nextInt(26) + 65; // 生成A~Z的字母  
	                ctmp = String.valueOf((char) itmp);  
	                break;  
	            default:  
	                itmp = r.nextInt(10) + 48; // 生成0~9的数字  
	                ctmp = String.valueOf((char) itmp);  
	                break;  
	            }  
	            sRand += ctmp;  
	            //设置每个字符的随机颜色  
	            Color color = new Color(20 + r.nextInt(210), 20 + r.nextInt(210), 20 + r.nextInt(210));  
	            g2d.setColor(color);  
	            //设置每个字符的随机字体  
	            g2d.setFont(this.getRandomFont());  
	            //设置每个字符的随机旋转  
	           // AffineTransform at = new AffineTransform();  
	            int number = r.nextInt(3)-1;  
	            double role = number*r.nextDouble()*(Math.PI/4);  
	            //at.setToRotation(role,25*i+5,55-r.nextInt(20)); //role:旋转角度,后面两个参数是设置围绕坐标点旋转  
	            //g2d.setTransform(at);  
	            g2d.drawString(ctmp, 25*i+5,55-r.nextInt(20));  
	        }  
	           HttpSession session = request.getSession(true);  
	           session.setMaxInactiveInterval(10*60);//设置session对象5分钟失效  
	           session.setAttribute("code", sRand.toString());  
	           g2d.dispose();  
	           System.out.println(sRand);
	           request.getSession().setAttribute("sRand", sRand);
	           ImageIO.write(bi, "JPEG", response.getOutputStream()); 
     	}  
}  

