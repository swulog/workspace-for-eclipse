package com.university.model;

import java.sql.Timestamp;

/**
 * UserNotesInfo entity. @author MyEclipse Persistence Tools
 */

public class UserNotesInfo implements java.io.Serializable {

	// Fields

	private Integer uniId;
	private Integer uniUserid;
	private String uniTitle;
	private String uniContent;
	private Timestamp uniCreatetime;

	// Constructors

	/** default constructor */
	public UserNotesInfo() {
	}

	/** full constructor */
	public UserNotesInfo(Integer uniUserid, String uniTitle, String uniContent,
			Timestamp uniCreatetime) {
		this.uniUserid = uniUserid;
		this.uniTitle = uniTitle;
		this.uniContent = uniContent;
		this.uniCreatetime = uniCreatetime;
	}

	// Property accessors

	public Integer getUniId() {
		return this.uniId;
	}

	public void setUniId(Integer uniId) {
		this.uniId = uniId;
	}

	public Integer getUniUserid() {
		return this.uniUserid;
	}

	public void setUniUserid(Integer uniUserid) {
		this.uniUserid = uniUserid;
	}

	public String getUniTitle() {
		return this.uniTitle;
	}

	public void setUniTitle(String uniTitle) {
		this.uniTitle = uniTitle;
	}

	public String getUniContent() {
		return this.uniContent;
	}

	public void setUniContent(String uniContent) {
		this.uniContent = uniContent;
	}

	public Timestamp getUniCreatetime() {
		return this.uniCreatetime;
	}

	public void setUniCreatetime(Timestamp uniCreatetime) {
		this.uniCreatetime = uniCreatetime;
	}

}