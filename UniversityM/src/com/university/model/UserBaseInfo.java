package com.university.model;

import java.sql.Timestamp;

/**
 * UserBaseInfo entity. @author MyEclipse Persistence Tools
 */

public class UserBaseInfo implements java.io.Serializable {

	// Fields

	private Integer ubiId;
	private String ubiUsername;
	private String ubiPwd;
	private Integer ubiStatus;
	private Timestamp ubiCreatetime;
	private String ubiSession;

	// Constructors

	/** default constructor */
	public UserBaseInfo() {
	}

	/** full constructor */
	public UserBaseInfo(String ubiUsername, String ubiPwd, Integer ubiStatus,
			Timestamp ubiCreatetime, String ubiSession) {
		this.ubiUsername = ubiUsername;
		this.ubiPwd = ubiPwd;
		this.ubiStatus = ubiStatus;
		this.ubiCreatetime = ubiCreatetime;
		this.ubiSession = ubiSession;
	}

	// Property accessors

	public Integer getUbiId() {
		return this.ubiId;
	}

	public void setUbiId(Integer ubiId) {
		this.ubiId = ubiId;
	}

	public String getUbiUsername() {
		return this.ubiUsername;
	}

	public void setUbiUsername(String ubiUsername) {
		this.ubiUsername = ubiUsername;
	}

	public String getUbiPwd() {
		return this.ubiPwd;
	}

	public void setUbiPwd(String ubiPwd) {
		this.ubiPwd = ubiPwd;
	}

	public Integer getUbiStatus() {
		return this.ubiStatus;
	}

	public void setUbiStatus(Integer ubiStatus) {
		this.ubiStatus = ubiStatus;
	}

	public Timestamp getUbiCreatetime() {
		return this.ubiCreatetime;
	}

	public void setUbiCreatetime(Timestamp ubiCreatetime) {
		this.ubiCreatetime = ubiCreatetime;
	}

	public String getUbiSession() {
		return this.ubiSession;
	}

	public void setUbiSession(String ubiSession) {
		this.ubiSession = ubiSession;
	}

}