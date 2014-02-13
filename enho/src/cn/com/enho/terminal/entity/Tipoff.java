package cn.com.enho.terminal.entity;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

/**
 * 		举报信息实体类
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-16 下午1:52:36
 */
@Entity
@Table(name="t_report")
public class Tipoff implements Serializable{

	private static final long serialVersionUID = 1L;
	private String t_report_id;//id
	private String t_report_reported_phone;//被举报人手机号码
	private String t_report_reported_name;//被举报人名称
	private String t_report_type;//举报类型
	private String t_report_content;//举报内容
	private String t_report_createtime;//举报时间
	private User user;//举报人
	
	@Id
	public String getT_report_id() {
		return t_report_id;
	}
	public void setT_report_id(String t_report_id) {
		this.t_report_id = t_report_id;
	}
	@Column(nullable=false)
	public String getT_report_reported_phone() {
		return t_report_reported_phone;
	}
	public void setT_report_reported_phone(String t_report_reported_phone) {
		this.t_report_reported_phone = t_report_reported_phone;
	}
	public String getT_report_reported_name() {
		return t_report_reported_name;
	}
	public void setT_report_reported_name(String t_report_reported_name) {
		this.t_report_reported_name = t_report_reported_name;
	}
	public String getT_report_type() {
		return t_report_type;
	}
	public void setT_report_type(String t_report_type) {
		this.t_report_type = t_report_type;
	}
	@Column(nullable=false)
	public String getT_report_content() {
		return t_report_content;
	}
	public void setT_report_content(String t_report_content) {
		this.t_report_content = t_report_content;
	}
	@Column(nullable=false)
	public String getT_report_createtime() {
		return t_report_createtime;
	}
	public void setT_report_createtime(String t_report_createtime) {
		this.t_report_createtime = t_report_createtime;
	}
	@ManyToOne(fetch=FetchType.LAZY)
	@JoinColumn(name="t_image_userid")
	public User getUser() {
		return user;
	}
	public void setUser(User user) {
		this.user = user;
	}
}
