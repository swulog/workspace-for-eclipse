package cn.com.enho.terminal.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * 		app文档实体类
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-10-28 下午4:07:39
 */
@Entity
@Table(name="t_doc")
public class Doc {

	private String t_doc_id;
	private Integer t_doc_type;
	private String t_doc_name;
	private String t_doc_title;
	private String t_doc_content;
	private String t_doc_createtime;
	private String t_doc_lastupdatetime;
	
	@Id
	public String getT_doc_id() {
		return t_doc_id;
	}
	public void setT_doc_id(String t_doc_id) {
		this.t_doc_id = t_doc_id;
	}
	public String getT_doc_name() {
		return t_doc_name;
	}
	public void setT_doc_name(String t_doc_name) {
		this.t_doc_name = t_doc_name;
	}
	public String getT_doc_title() {
		return t_doc_title;
	}
	public void setT_doc_title(String t_doc_title) {
		this.t_doc_title = t_doc_title;
	}
	public String getT_doc_content() {
		return t_doc_content;
	}
	public void setT_doc_content(String t_doc_content) {
		this.t_doc_content = t_doc_content;
	}
	public String getT_doc_createtime() {
		return t_doc_createtime;
	}
	public void setT_doc_createtime(String t_doc_createtime) {
		this.t_doc_createtime = t_doc_createtime;
	}
	public String getT_doc_lastupdatetime() {
		return t_doc_lastupdatetime;
	}
	public void setT_doc_lastupdatetime(String t_doc_lastupdatetime) {
		this.t_doc_lastupdatetime = t_doc_lastupdatetime;
	}
	
	@Column(nullable=false)
	public Integer getT_doc_type() {
		return t_doc_type;
	}
	public void setT_doc_type(Integer t_doc_type) {
		this.t_doc_type = t_doc_type;
	}
}
