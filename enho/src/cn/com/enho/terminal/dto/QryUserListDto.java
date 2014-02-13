package cn.com.enho.terminal.dto;

/**
 * 		查询用户列表参数
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-14 上午10:26:13
 */
public class QryUserListDto {

	private Integer currentpage; //请求页
	private Integer pagesize; //每页记录数
	private Integer usertype;//用户类型
	private Integer isabled;//是否启用
	private Integer usersrc;//用户来源（1：android，2：ios，3：web，4：后台手动添加）
	
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
	public Integer getIsabled() {
		return isabled;
	}
	public void setIsabled(Integer isabled) {
		this.isabled = isabled;
	}
	public Integer getUsersrc() {
		return usersrc;
	}
	public void setUsersrc(Integer usersrc) {
		this.usersrc = usersrc;
	}
}
