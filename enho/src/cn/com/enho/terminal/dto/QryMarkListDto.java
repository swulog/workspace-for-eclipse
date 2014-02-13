package cn.com.enho.terminal.dto;

/**
 * 		查询评分列表参数
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-25 上午11:53:03
 */
public class QryMarkListDto {

	private String userid;//用户id
	private Integer usertype;//用户类型
	private Integer currentpage; //请求页
	private Integer pagesize; //每页记录数
	private Integer qrytype;//查询类型（所有（默认，1），已评分（3），未评分（2））
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
	public Integer getQrytype() {
		return qrytype;
	}
	public void setQrytype(Integer qrytype) {
		this.qrytype = qrytype;
	}
	
}
