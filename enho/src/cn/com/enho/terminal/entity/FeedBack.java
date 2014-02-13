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
 * 		反馈信息实体类
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-16 上午11:29:10
 */
@Entity
@Table(name="t_feedback")
public class FeedBack implements Serializable{

	private static final long serialVersionUID = 1L;
	private String t_feedback_id;
	private String t_feedback_content;
	private User user;
	private String t_feedback_createtime;
	
	@Id
	public String getT_feedback_id() {
		return t_feedback_id;
	}
	public void setT_feedback_id(String t_feedback_id) {
		this.t_feedback_id = t_feedback_id;
	}
	@Column(nullable=false)
	public String getT_feedback_content() {
		return t_feedback_content;
	}
	public void setT_feedback_content(String t_feedback_content) {
		this.t_feedback_content = t_feedback_content;
	}
	@ManyToOne(fetch=FetchType.LAZY)
	@JoinColumn(name="t_feedback_userid")
	public User getUser() {
		return user;
	}
	public void setUser(User user) {
		this.user = user;
	}
	@Column(nullable=false)
	public String getT_feedback_createtime() {
		return t_feedback_createtime;
	}
	public void setT_feedback_createtime(String t_feedback_createtime) {
		this.t_feedback_createtime = t_feedback_createtime;
	}
}
