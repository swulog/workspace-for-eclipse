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
 * 		图片实体类
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-16 上午10:20:55
 */
@Entity
@Table(name="t_image")
public class Image implements Serializable{

	private static final long serialVersionUID = 1L;
	/**
	 * id
	 */
	private String t_image_id;
	/**
	 * url
	 */
	private String t_image_url;
	/**
	 * 描述
	 */
	private String t_image_desc;
	/**
	 * user
	 */
	private User user;
	/**
	 * 时间
	 */
	private String t_image_createtime;
	
	@Id
	public String getT_image_id() {
		return t_image_id;
	}
	public void setT_image_id(String t_image_id) {
		this.t_image_id = t_image_id;
	}
	@Column(nullable=false)
	public String getT_image_url() {
		return t_image_url;
	}
	public void setT_image_url(String t_image_url) {
		this.t_image_url = t_image_url;
	}
	public String getT_image_desc() {
		return t_image_desc;
	}
	public void setT_image_desc(String t_image_desc) {
		this.t_image_desc = t_image_desc;
	}
	@ManyToOne(fetch=FetchType.LAZY)
	@JoinColumn(name="t_image_userid")
	public User getUser() {
		return user;
	}
	public void setUser(User user) {
		this.user = user;
	}
	@Column(nullable=false)
	public String getT_image_createtime() {
		return t_image_createtime;
	}
	public void setT_image_createtime(String t_image_createtime) {
		this.t_image_createtime = t_image_createtime;
	}
}
