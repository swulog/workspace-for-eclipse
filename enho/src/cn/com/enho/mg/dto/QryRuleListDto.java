package cn.com.enho.mg.dto;

/**
 * 		查询规则
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-9-17 下午4:05:08
 */
public class QryRuleListDto {

	private String key;
	private String name;
	private String groupid;
	private Integer isabled;
	private Integer page; //请求页
	private Integer rows; //每页记录数
	public String getKey() {
		return key;
	}
	public void setKey(String key) {
		this.key = key;
	}
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
	public String getGroupid() {
		return groupid;
	}
	public void setGroupid(String groupid) {
		this.groupid = groupid;
	}
	public Integer getIsabled() {
		return isabled;
	}
	public void setIsabled(Integer isabled) {
		this.isabled = isabled;
	}
	
}
