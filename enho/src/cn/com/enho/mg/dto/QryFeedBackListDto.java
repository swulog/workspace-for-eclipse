package cn.com.enho.mg.dto;

/**
 * 		查询反馈信息
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-9-17 下午2:28:24
 */
public class QryFeedBackListDto {

	private String phone;
	private Integer page; //请求页
	private Integer rows; //每页记录数
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
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	
}
