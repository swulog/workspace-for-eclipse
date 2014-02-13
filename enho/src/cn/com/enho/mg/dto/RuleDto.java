package cn.com.enho.mg.dto;

/**
 * 		新增规则
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-9-17 下午3:01:15
 */
public class RuleDto {

	private String id;
	private String name;
	private String key;
	private String value;
	private String desc;
	private int isabled;
	private String createtime;
	private String lastupdatetime;
	private String groupid;
	private String groupname;
	private String gridid;
	public String getKey() {
		return key;
	}
	public void setKey(String key) {
		this.key = key;
	}
	public String getValue() {
		return value;
	}
	public void setValue(String value) {
		this.value = value;
	}
	public int getIsabled() {
		return isabled;
	}
	public void setIsabled(int isabled) {
		this.isabled = isabled;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
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
	public String getGroupid() {
		return groupid;
	}
	public void setGroupid(String groupid) {
		this.groupid = groupid;
	}
	public String getGroupname() {
		return groupname;
	}
	public void setGroupname(String groupname) {
		this.groupname = groupname;
	}
	public String getGridid() {
		return gridid;
	}
	public void setGridid(String gridid) {
		this.gridid = gridid;
	}
}
