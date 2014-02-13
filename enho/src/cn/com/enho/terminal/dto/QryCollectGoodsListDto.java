package cn.com.enho.terminal.dto;

/**
 * 		查询收藏的货源列表参数
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-15 下午3:39:25
 */
public class QryCollectGoodsListDto {
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
