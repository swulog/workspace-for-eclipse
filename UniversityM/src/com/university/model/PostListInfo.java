package com.university.model;

import java.sql.Timestamp;

/**
 * PostListInfo entity. @author MyEclipse Persistence Tools
 */

public class PostListInfo implements java.io.Serializable {

	// Fields

	private Integer pliId;
	private Integer pliPtiid;
	private String pliTitle;
	private String pliContent;
	private Integer pliUserid;
	private Integer pliIstop;
	private Integer pliReplynum;
	private Timestamp pliCreatetime;
	private Integer pliStatus;
	private Integer pliReportnum;

	// Constructors

	/** default constructor */
	public PostListInfo() {
	}

	/** full constructor */
	public PostListInfo(Integer pliPtiid, String pliTitle, String pliContent,
			Integer pliUserid, Integer pliIstop, Integer pliReplynum,
			Timestamp pliCreatetime, Integer pliStatus, Integer pliReportnum) {
		this.pliPtiid = pliPtiid;
		this.pliTitle = pliTitle;
		this.pliContent = pliContent;
		this.pliUserid = pliUserid;
		this.pliIstop = pliIstop;
		this.pliReplynum = pliReplynum;
		this.pliCreatetime = pliCreatetime;
		this.pliStatus = pliStatus;
		this.pliReportnum = pliReportnum;
	}

	// Property accessors

	public Integer getPliId() {
		return this.pliId;
	}

	public void setPliId(Integer pliId) {
		this.pliId = pliId;
	}

	public Integer getPliPtiid() {
		return this.pliPtiid;
	}

	public void setPliPtiid(Integer pliPtiid) {
		this.pliPtiid = pliPtiid;
	}

	public String getPliTitle() {
		return this.pliTitle;
	}

	public void setPliTitle(String pliTitle) {
		this.pliTitle = pliTitle;
	}

	public String getPliContent() {
		return this.pliContent;
	}

	public void setPliContent(String pliContent) {
		this.pliContent = pliContent;
	}

	public Integer getPliUserid() {
		return this.pliUserid;
	}

	public void setPliUserid(Integer pliUserid) {
		this.pliUserid = pliUserid;
	}

	public Integer getPliIstop() {
		return this.pliIstop;
	}

	public void setPliIstop(Integer pliIstop) {
		this.pliIstop = pliIstop;
	}

	public Integer getPliReplynum() {
		return this.pliReplynum;
	}

	public void setPliReplynum(Integer pliReplynum) {
		this.pliReplynum = pliReplynum;
	}

	public Timestamp getPliCreatetime() {
		return this.pliCreatetime;
	}

	public void setPliCreatetime(Timestamp pliCreatetime) {
		this.pliCreatetime = pliCreatetime;
	}

	public Integer getPliStatus() {
		return this.pliStatus;
	}

	public void setPliStatus(Integer pliStatus) {
		this.pliStatus = pliStatus;
	}

	public Integer getPliReportnum() {
		return this.pliReportnum;
	}

	public void setPliReportnum(Integer pliReportnum) {
		this.pliReportnum = pliReportnum;
	}

}