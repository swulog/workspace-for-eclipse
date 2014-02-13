package cn.com.enho.mg.dto;

/**
 * 		查询规则组
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-9-22 下午5:27:39
 */
public class QryRGroupListDto {

	private Integer page; //请求页
	private Integer rows; //每页记录数
	private String name;//规则组名称
	private Integer isabled;//是否启用
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
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public Integer getIsabled() {
		return isabled;
	}
	public void setIsabled(Integer isabled) {
		this.isabled = isabled;
	}
	
}
