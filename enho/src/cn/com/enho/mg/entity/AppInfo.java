package cn.com.enho.mg.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * 		app实体类
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-9-27 上午10:19:20
 */
@Entity
@Table(name="t_app")
public class AppInfo {

	private String t_app_id;
	private String t_app_key;
	private String t_app_name;
	private String t_app_version;
	private String t_app_url;
	private Long t_app_size;
	private String t_app_desc;
	private String t_app_createtime;
	private String t_app_lastupdatetime;
	
	@Id
	public String getT_app_id() {
		return t_app_id;
	}
	public void setT_app_id(String t_app_id) {
		this.t_app_id = t_app_id;
	}
	@Column(nullable=true, unique=true)
	public String getT_app_key() {
		return t_app_key;
	}
	public void setT_app_key(String t_app_key) {
		this.t_app_key = t_app_key;
	}
	public String getT_app_name() {
		return t_app_name;
	}
	public void setT_app_name(String t_app_name) {
		this.t_app_name = t_app_name;
	}
	@Column(nullable=true)
	public String getT_app_version() {
		return t_app_version;
	}
	public void setT_app_version(String t_app_version) {
		this.t_app_version = t_app_version;
	}
	public String getT_app_url() {
		return t_app_url;
	}
	public void setT_app_url(String t_app_url) {
		this.t_app_url = t_app_url;
	}
	public Long getT_app_size() {
		return t_app_size;
	}
	public void setT_app_size(Long t_app_size) {
		this.t_app_size = t_app_size;
	}
	public String getT_app_desc() {
		return t_app_desc;
	}
	public void setT_app_desc(String t_app_desc) {
		this.t_app_desc = t_app_desc;
	}
	public String getT_app_createtime() {
		return t_app_createtime;
	}
	public void setT_app_createtime(String t_app_createtime) {
		this.t_app_createtime = t_app_createtime;
	}
	public String getT_app_lastupdatetime() {
		return t_app_lastupdatetime;
	}
	public void setT_app_lastupdatetime(String t_app_lastupdatetime) {
		this.t_app_lastupdatetime = t_app_lastupdatetime;
	}
}
