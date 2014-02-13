package cn.com.enho.terminal.dto;

/**
 * 		评分参数
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-25 下午1:19:24
 */
public class MarkDto {

	private Integer usertype;
	private String tradeid;//交易记录id
	private String goodserid;//交易的货主id
	private String carerid;//交易的车主id
	private Double score;//分值
	public String getTradeid() {
		return tradeid;
	}
	public void setTradeid(String tradeid) {
		this.tradeid = tradeid;
	}
	
	public Double getScore() {
		return score;
	}
	public void setScore(Double score) {
		this.score = score;
	}
	public String getGoodserid() {
		return goodserid;
	}
	public void setGoodserid(String goodserid) {
		this.goodserid = goodserid;
	}
	public String getCarerid() {
		return carerid;
	}
	public void setCarerid(String carerid) {
		this.carerid = carerid;
	}
	public Integer getUsertype() {
		return usertype;
	}
	public void setUsertype(Integer usertype) {
		this.usertype = usertype;
	}
	
}
