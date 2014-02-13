package cn.com.enho.terminal.dto;

/**
 * 		举报参数
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-16 下午1:50:54
 */
public class TipoffDto {

	private String userid; //用户id
	private String reportphone; //被举报人手机号码
	private String reportname; //被举报人名称
	private String reporttype; //举报类型
	private String content; //举报内容
	public String getUserid() {
		return userid;
	}
	public void setUserid(String userid) {
		this.userid = userid;
	}
	public String getReportphone() {
		return reportphone;
	}
	public void setReportphone(String reportphone) {
		this.reportphone = reportphone;
	}
	public String getReportname() {
		return reportname;
	}
	public void setReportname(String reportname) {
		this.reportname = reportname;
	}
	public String getReporttype() {
		return reporttype;
	}
	public void setReporttype(String reporttype) {
		this.reporttype = reporttype;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
}
