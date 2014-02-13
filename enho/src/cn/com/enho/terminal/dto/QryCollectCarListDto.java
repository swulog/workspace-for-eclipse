package cn.com.enho.terminal.dto;

/**
 * 		查询收藏的车源信息参数
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-15 下午3:32:14
 */
public class QryCollectCarListDto {

	private String userid;
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
}
