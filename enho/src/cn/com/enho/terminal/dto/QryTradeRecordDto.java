package cn.com.enho.terminal.dto;

/**
 * 		查询交易记录参数
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-25 上午10:55:13
 */
public class QryTradeRecordDto {

	private String userid;
	private Integer usertype;
	private Integer currentpage; //请求页
	private Integer pagesize; //每页记录数
	public String getUserid() {
		return userid;
	}
	public void setUserid(String userid) {
		this.userid = userid;
	}
	public Integer getCurrentpage() {
		return currentpage;
	}
	public void setCurrentpage(Integer currentpage) {
		this.currentpage = currentpage;
	}
	public Integer getPagesize() {
		return pagesize;
	}
	public void setPagesize(Integer pagesize) {
		this.pagesize = pagesize;
	}
	public Integer getUsertype() {
		return usertype;
	}
	public void setUsertype(Integer usertype) {
		this.usertype = usertype;
	}
	
}
