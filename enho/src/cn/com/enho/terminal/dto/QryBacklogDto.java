package cn.com.enho.terminal.dto;

/**
 * 		查询待确认交易参数
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-9-2 下午2:16:46
 */
public class QryBacklogDto {

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
	public Integer getUsertype() {
		return usertype;
	}
	public void setUsertype(Integer usertype) {
		this.usertype = usertype;
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
	
}
