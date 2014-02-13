package cn.com.enho.mg.dto;

public class QryAppListDto {

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
}
