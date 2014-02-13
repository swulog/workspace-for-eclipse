package com.ivorytower.app.entity;

import java.sql.Timestamp;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.GenericGenerator;

/**
 * Userbaseinfo entity. @author MyEclipse Persistence Tools
 */
@Entity
@Table(name = "userbaseinfo", catalog = "itdb")
public class Userbaseinfo implements java.io.Serializable {

	// Fields

	private Integer ubiId;
	private String ubiUsername;
	private String ubiPwd;
	private Integer ubiStatus;
	private Timestamp ubiCreatetime;
	private String ubiSession;

	// Constructors

	/** default constructor */
	public Userbaseinfo() {
	}

	/** full constructor */
	public Userbaseinfo(String ubiUsername, String ubiPwd, Integer ubiStatus,
			Timestamp ubiCreatetime, String ubiSession) {
		this.ubiUsername = ubiUsername;
		this.ubiPwd = ubiPwd;
		this.ubiStatus = ubiStatus;
		this.ubiCreatetime = ubiCreatetime;
		this.ubiSession = ubiSession;
	}

	// Property accessors
	@GenericGenerator(name = "generator", strategy = "identity")
	@Id
	@GeneratedValue(generator = "generator")
	@Column(name = "ubi_id", unique = true, nullable = false)
	public Integer getUbiId() {
		return this.ubiId;
	}

	public void setUbiId(Integer ubiId) {
		this.ubiId = ubiId;
	}

	@Column(name = "ubi_username", nullable = false, length = 11)
	public String getUbiUsername() {
		return this.ubiUsername;
	}

	public void setUbiUsername(String ubiUsername) {
		this.ubiUsername = ubiUsername;
	}

	@Column(name = "ubi_pwd", nullable = false, length = 50)
	public String getUbiPwd() {
		return this.ubiPwd;
	}

	public void setUbiPwd(String ubiPwd) {
		this.ubiPwd = ubiPwd;
	}

	@Column(name = "ubi_status", nullable = false)
	public Integer getUbiStatus() {
		return this.ubiStatus;
	}

	public void setUbiStatus(Integer ubiStatus) {
		this.ubiStatus = ubiStatus;
	}

	@Column(name = "ubi_createtime", nullable = false, length = 19)
	public Timestamp getUbiCreatetime() {
		return this.ubiCreatetime;
	}

	public void setUbiCreatetime(Timestamp ubiCreatetime) {
		this.ubiCreatetime = ubiCreatetime;
	}

	@Column(name = "ubi_session", nullable = false, length = 30)
	public String getUbiSession() {
		return this.ubiSession;
	}

	public void setUbiSession(String ubiSession) {
		this.ubiSession = ubiSession;
	}

}