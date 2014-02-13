package cn.com.enho.terminal.dto;

/**
 * 		发布反馈信息参数
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-16 上午11:44:21
 */
public class PubFeedBackDto {

	private String userid;//用户id
	private String content;//反馈内容
	public String getUserid() {
		return userid;
	}
	public void setUserid(String userid) {
		this.userid = userid;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
}
