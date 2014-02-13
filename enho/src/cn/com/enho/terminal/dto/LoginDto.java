package cn.com.enho.terminal.dto;

/**
 * 		登陆参数
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-13 上午11:31:11
 */
public class LoginDto {

	private String phoneno;//手机号码（非空）
	private String userpwd;//用户密码（非空）
	private Double longitude;//经度
	private Double latitude;//纬度
	
	private String baseurl;
	public String getPhoneno() {
		return phoneno;
	}
	public void setPhoneno(String phoneno) {
		this.phoneno = phoneno;
	}
	public String getUserpwd() {
		return userpwd;
	}
	public void setUserpwd(String userpwd) {
		this.userpwd = userpwd;
	}
	public Double getLongitude() {
		return longitude;
	}
	public void setLongitude(Double longitude) {
		this.longitude = longitude;
	}
	public Double getLatitude() {
		return latitude;
	}
	public void setLatitude(Double latitude) {
		this.latitude = latitude;
	}
	public String getBaseurl() {
		return baseurl;
	}
	public void setBaseurl(String baseurl) {
		this.baseurl = baseurl;
	}
	
}
