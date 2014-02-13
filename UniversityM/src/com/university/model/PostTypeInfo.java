package com.university.model;

import java.sql.Timestamp;

/**
 * PostTypeInfo entity. @author MyEclipse Persistence Tools
 */

public class PostTypeInfo implements java.io.Serializable {

	// Fields

	private Integer ptiId;
	private Integer ptiNum;
	private Integer ptiPnum;
	private String ptiTitle;
	private Timestamp ptiCreatetime;

	// Constructors

	/** default constructor */
	public PostTypeInfo() {
	}

	/** full constructor */
	public PostTypeInfo(Integer ptiNum, Integer ptiPnum, String ptiTitle,
			Timestamp ptiCreatetime) {
		this.ptiNum = ptiNum;
		this.ptiPnum = ptiPnum;
		this.ptiTitle = ptiTitle;
		this.ptiCreatetime = ptiCreatetime;
	}

	// Property accessors

	public Integer getPtiId() {
		return this.ptiId;
	}

	public void setPtiId(Integer ptiId) {
		this.ptiId = ptiId;
	}

	public Integer getPtiNum() {
		return this.ptiNum;
	}

	public void setPtiNum(Integer ptiNum) {
		this.ptiNum = ptiNum;
	}

	public Integer getPtiPnum() {
		return this.ptiPnum;
	}

	public void setPtiPnum(Integer ptiPnum) {
		this.ptiPnum = ptiPnum;
	}

	public String getPtiTitle() {
		return this.ptiTitle;
	}

	public void setPtiTitle(String ptiTitle) {
		this.ptiTitle = ptiTitle;
	}

	public Timestamp getPtiCreatetime() {
		return this.ptiCreatetime;
	}

	public void setPtiCreatetime(Timestamp ptiCreatetime) {
		this.ptiCreatetime = ptiCreatetime;
	}

}