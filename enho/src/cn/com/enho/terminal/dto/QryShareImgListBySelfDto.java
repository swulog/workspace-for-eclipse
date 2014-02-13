package cn.com.enho.terminal.dto;

/**
 * 		查询自己分享的图片参数
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-16 上午10:53:17
 */
public class QryShareImgListBySelfDto {

	private String userid; //用户id
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
