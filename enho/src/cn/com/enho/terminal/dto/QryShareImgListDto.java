package cn.com.enho.terminal.dto;

/**
 * 		查询所有分享的图片参数
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-16 上午10:32:31
 */
public class QryShareImgListDto {

	private Integer currentpage; //请求页
	private Integer pagesize; //每页记录数
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
