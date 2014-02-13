package cn.com.enho.terminal.dto;

/**
 * 		android版本检测参数
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-9-9 下午2:46:38
 */
public class CheckUpdateDto {

	private String appid;
	private String version;
	public String getAppid() {
		return appid;
	}
	public void setAppid(String appid) {
		this.appid = appid;
	}
	public String getVersion() {
		return version;
	}
	public void setVersion(String version) {
		this.version = version;
	}
}
