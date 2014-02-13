package cn.com.enho.terminal.dto;

/**
 * 		获取手机号码参数
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-21 下午5:48:05
 */
public class GetPhoneDto {

	private String infoid;//信息id
	private Integer infotype;//信息类型
	private String requserid;//请求用户id
	private String requserphone;//请求用户手机号码
	private String requsername;//请求用户名称
	public String getInfoid() {
		return infoid;
	}
	public void setInfoid(String infoid) {
		this.infoid = infoid;
	}
	public String getRequserid() {
		return requserid;
	}
	public void setRequserid(String requserid) {
		this.requserid = requserid;
	}
	public String getRequserphone() {
		return requserphone;
	}
	public void setRequserphone(String requserphone) {
		this.requserphone = requserphone;
	}
	public String getRequsername() {
		return requsername;
	}
	public void setRequsername(String requsername) {
		this.requsername = requsername;
	}
	public Integer getInfotype() {
		return infotype;
	}
	public void setInfotype(Integer infotype) {
		this.infotype = infotype;
	}
}
