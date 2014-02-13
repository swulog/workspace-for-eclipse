package cn.com.enho.terminal.entity;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

/**
 * 		关注关系实体类
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-15 上午10:36:08
 */
@Entity
@Table(name="t_focus")
public class Focusrelation implements Serializable{

	private static final long serialVersionUID = 1L;
	/**
	 * id
	 */
	private String t_focus_id;
	/**
	 * 是否启用（1：启用，2：停用）
	 */
	private Integer t_focus_isabled=1;
	/**
	 * 创建时间
	 */
	private String t_focus_createtime;
	/**
	 * 关注者
	 */
	private User user_focus;
	/**
	 * 被关注者
	 */
	private User user_focused;
	
	@Id
	public String getT_focus_id() {
		return t_focus_id;
	}
	public void setT_focus_id(String t_focus_id) {
		this.t_focus_id = t_focus_id;
	}
	public Integer getT_focus_isabled() {
		return t_focus_isabled;
	}
	public void setT_focus_isabled(Integer t_focus_isabled) {
		this.t_focus_isabled = t_focus_isabled;
	}
	@Column(nullable=false)
	public String getT_focus_createtime() {
		return t_focus_createtime;
	}
	public void setT_focus_createtime(String t_focus_createtime) {
		this.t_focus_createtime = t_focus_createtime;
	}
	@ManyToOne
	@JoinColumn(name="t_focus_userid1")
	public User getUser_focus() {
		return user_focus;
	}
	public void setUser_focus(User user_focus) {
		this.user_focus = user_focus;
	}
	@ManyToOne
	@JoinColumn(name="t_focus_userid2")
	public User getUser_focused() {
		return user_focused;
	}
	public void setUser_focused(User user_focused) {
		this.user_focused = user_focused;
	}
}
