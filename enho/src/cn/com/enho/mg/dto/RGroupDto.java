package cn.com.enho.mg.dto;

/**
 * 		规则组
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-9-22 下午3:56:09
 */
public class RGroupDto {

	private String id;
	private String code;
	private String name;
	private String desc;
	private Integer isabled;
	private String createtime;
	private String lastupdatetime;
	private String gridid;
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getDesc() {
		return desc;
	}
	public void setDesc(String desc) {
		this.desc = desc;
	}
	public Integer getIsabled() {
		return isabled;
	}
	public void setIsabled(Integer isabled) {
		this.isabled = isabled;
	}
	public String getCreatetime() {
		return createtime;
	}
	public void setCreatetime(String createtime) {
		this.createtime = createtime;
	}
	public String getLastupdatetime() {
		return lastupdatetime;
	}
	public void setLastupdatetime(String lastupdatetime) {
		this.lastupdatetime = lastupdatetime;
	}
	public String getGridid() {
		return gridid;
	}
	public void setGridid(String gridid) {
		this.gridid = gridid;
	}
}
