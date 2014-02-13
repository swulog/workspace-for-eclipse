package cn.com.enho.terminal.dto;

/**
 * 		分享图片参数
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-16 上午11:15:03
 */
public class ShareImgDto {

	private String userid; //用户id
	private String imgurl; //图片地址
	private String imgdesc; //图片描述
	public String getUserid() {
		return userid;
	}
	public void setUserid(String userid) {
		this.userid = userid;
	}
	public String getImgurl() {
		return imgurl;
	}
	public void setImgurl(String imgurl) {
		this.imgurl = imgurl;
	}
	public String getImgdesc() {
		return imgdesc;
	}
	public void setImgdesc(String imgdesc) {
		this.imgdesc = imgdesc;
	}
}
