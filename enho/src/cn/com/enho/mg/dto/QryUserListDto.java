package cn.com.enho.mg.dto;

/**
 * 		查询用户列表参数
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-14 上午10:26:13
 */
public class QryUserListDto {

	private Integer page; //请求页
	private Integer rows; //每页记录数
	private Integer usertype;//用户类型
	private String phoneno;
	private Integer isabled;
	
	private String baseurl;
	
	public Integer getPage() {
		return page;
	}
	public void setPage(Integer page) {
		this.page = page;
	}
	public Integer getRows() {
		return rows;
	}
	public void setRows(Integer rows) {
		this.rows = rows;
	}
	public Integer getUsertype() {
		return usertype;
	}
	public void setUsertype(Integer usertype) {
		this.usertype = usertype;
	}
	public String getPhoneno() {
		return phoneno;
	}
	public void setPhoneno(String phoneno) {
		this.phoneno = phoneno;
	}
	public Integer getIsabled() {
		return isabled;
	}
	public void setIsabled(Integer isabled) {
		this.isabled = isabled;
	}
	public String getBaseurl() {
		return baseurl;
	}
	public void setBaseurl(String baseurl) {
		this.baseurl = baseurl;
	}
}
