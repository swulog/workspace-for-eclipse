package com.university.model;

import java.sql.Timestamp;

/**
 * PostDetailInfo entity. @author MyEclipse Persistence Tools
 */

public class PostDetailInfo implements java.io.Serializable {

	// Fields

	private Integer pdiId;
	private Integer pdiPpostid;
	private String pdiTitle;
	private String pdiContent;
	private String pdiPicture;
	private Integer pdiUserid;
	private Timestamp pdiCreatetime;

	// Constructors

	/** default constructor */
	public PostDetailInfo() {
	}

	/** full constructor */
	public PostDetailInfo(Integer pdiPpostid, String pdiTitle,
			String pdiContent, String pdiPicture, Integer pdiUserid,
			Timestamp pdiCreatetime) {
		this.pdiPpostid = pdiPpostid;
		this.pdiTitle = pdiTitle;
		this.pdiContent = pdiContent;
		this.pdiPicture = pdiPicture;
		this.pdiUserid = pdiUserid;
		this.pdiCreatetime = pdiCreatetime;
	}

	// Property accessors

	public Integer getPdiId() {
		return this.pdiId;
	}

	public void setPdiId(Integer pdiId) {
		this.pdiId = pdiId;
	}

	public Integer getPdiPpostid() {
		return this.pdiPpostid;
	}

	public void setPdiPpostid(Integer pdiPpostid) {
		this.pdiPpostid = pdiPpostid;
	}

	public String getPdiTitle() {
		return this.pdiTitle;
	}

	public void setPdiTitle(String pdiTitle) {
		this.pdiTitle = pdiTitle;
	}

	public String getPdiContent() {
		return this.pdiContent;
	}

	public void setPdiContent(String pdiContent) {
		this.pdiContent = pdiContent;
	}

	public String getPdiPicture() {
		return this.pdiPicture;
	}

	public void setPdiPicture(String pdiPicture) {
		this.pdiPicture = pdiPicture;
	}

	public Integer getPdiUserid() {
		return this.pdiUserid;
	}

	public void setPdiUserid(Integer pdiUserid) {
		this.pdiUserid = pdiUserid;
	}

	public Timestamp getPdiCreatetime() {
		return this.pdiCreatetime;
	}

	public void setPdiCreatetime(Timestamp pdiCreatetime) {
		this.pdiCreatetime = pdiCreatetime;
	}

}