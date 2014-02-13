package cn.com.enho.comm.util;


/**
 * 		字符串工具类
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-9 下午1:27:33
 */
public class StringUtil {

	/**
	 * 将String类型的null转换为""
	 * @param str
	 * @return
	 */
	public static String nullToStr(String str){
		if(str==null || "(null)".equals(str) || "null".equals(str)){
			return "";
		}
		
		return str.trim();
	}
	
	/**
	 * 将Double类型的null转换为"0.0"
	 * @param d
	 * @return
	 */
	public static Double nullToDouble(Double d){
		if(d==null){
			return new Double(0.0);
		}
		return d;
	}
	
	/**
	 * 将Integer类型的null转换为"0"
	 * @param i
	 * @return
	 */
	public static Integer nullToInteger(Integer i){
		if(i==null){
			return new Integer(0);
		}
		return i;
	}
	
	/**
	 * 产生随机验证码(5位)
	 * @return
	 */
	public static String getVerificationcode(){
		String str=String.valueOf((int)(Math.random()*100000));
		if(str!=null && str.length()!=5){
			switch(str.length()){
				case 0: str+="00000";break;
				case 1: str+="0000";break;
				case 2: str+="000";break;
				case 3: str+="00";break;
				case 4: str+="0";break;
				default:str="12345";break;
			}
			return str;
		}else{
			return str;
		}
	}
	
	/**
	 * arr数组中是否包含str
	 * @param arr
	 * @param str
	 * @return
	 */
	public static boolean isContain(String arr[],String str){
		boolean flag=false;
		if(arr!=null && arr.length>0){
			for(int i=0,len=arr.length;i<len;i++){
				if(str.equalsIgnoreCase(arr[i])){
					flag=true;
					break;
				}
			}
		}
		return flag;
	}
	
	/**
	 * 
	 * @param 替换字符串
	 * @return
	 */
	public static String replaceStr(String str,int start,int end,String replaceStr){
		if(str==null){
			return "";
		}
		if(start<0 || end>str.length()){
			return str;
		}
		StringBuilder sb=new StringBuilder(str);
		sb.replace(start, end, replaceStr);
		return sb.toString();
	}
	
	/**
	 * 产生邀请码
	 * @return
	 */
	public static String getInvitecode(){
		String str=String.valueOf((int)(Math.random()*99999));
		if(str!=null && str.length()!=5){
			switch(str.length()){
				case 0: str+="98765";break;
				case 1: str+="1234";break;
				case 2: str+="876";break;
				case 3: str+="54";break;
				case 4: str+="8";break;
				default:str="12345";break;
			}
			return str;
		}else{
			return str;
		}
	}
	
	/**
	 * 产生随机密码(6位)
	 * @return
	 */
	public static String getPwd(){
		String str=String.valueOf((int)(Math.random()*1000000));
		if(str!=null && str.length()!=6){
			switch(str.length()){
				case 0: str+="000000";break;
				case 1: str+="00000";break;
				case 2: str+="0000";break;
				case 3: str+="000";break;
				case 4: str+="00";break;
				case 5: str+="0";break;
				default:str="123456";break;
			}
			return str;
		}else{
			return str;
		}
	}
	
	public static void main(String args[]){
		/*String str="龙超";
		int l=str.length();
		System.out.println(str.length());
		System.out.println(replaceStr(str,1,l,"司机"));*/
		System.out.println(getInvitecode());
		//System.out.println(getVerificationcode());
	}
}
