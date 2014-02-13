package cn.com.enho.terminal.dto;

/**
 * 		查询关注用户列表参数
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-15 上午11:47:41
 */
public class QryFocusUserListDto {

	/**
	 * userid
	 */
	private String userid;
	/**
	 * 请求页
	 */
	private Integer currentpage;
	/**
	 * 每页记录数
	 */
	private Integer pagesize;
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
}
