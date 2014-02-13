package cn.com.enho.terminal.dto;

/**
 * 		交易确认参数
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-23 上午11:25:18
 */
public class TradeConfirmDto {

	private String infoid;//信息id
	private Integer infotype;//信息类型
	private String requserid;//请求人id
	private Integer flag;//是否成功
	public String getInfoid() {
		return infoid;
	}
	public void setInfoid(String infoid) {
		this.infoid = infoid;
	}
	public Integer getInfotype() {
		return infotype;
	}
	public void setInfotype(Integer infotype) {
		this.infotype = infotype;
	}
	public String getRequserid() {
		return requserid;
	}
	public void setRequserid(String requserid) {
		this.requserid = requserid;
	}
	public Integer getFlag() {
		return flag;
	}
	public void setFlag(Integer flag) {
		this.flag = flag;
	}
	
}
