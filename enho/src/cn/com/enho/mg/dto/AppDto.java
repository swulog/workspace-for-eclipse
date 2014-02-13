package cn.com.enho.mg.dto;

public class AppDto {

	private String id;
	private String name;
	private String key;
	private String version;
	private String url;//相对路径
	private Long size;
	private String createtime;
	private String lastupdatetime;
	private String desc;
	private String gridid;
	private String oldappfileurl;
	private String appfileurl;
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
	public String getKey() {
		return key;
	}
	public void setKey(String key) {
		this.key = key;
	}
	public String getVersion() {
		return version;
	}
	public void setVersion(String version) {
		this.version = version;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public Long getSize() {
		return size;
	}
	public void setSize(Long size) {
		this.size = size;
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
	public String getDesc() {
		return desc;
	}
	public void setDesc(String desc) {
		this.desc = desc;
	}
	public String getGridid() {
		return gridid;
	}
	public void setGridid(String gridid) {
		this.gridid = gridid;
	}
	public String getOldappfileurl() {
		return oldappfileurl;
	}
	public void setOldappfileurl(String oldappfileurl) {
		this.oldappfileurl = oldappfileurl;
	}
	public String getAppfileurl() {
		return appfileurl;
	}
	public void setAppfileurl(String appfileurl) {
		this.appfileurl = appfileurl;
	}
}
