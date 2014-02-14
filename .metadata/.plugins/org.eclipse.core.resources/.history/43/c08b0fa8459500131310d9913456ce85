package com.ivorytower.app.entity;

import java.sql.Timestamp;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import org.hibernate.annotations.GenericGenerator;

/**
 * Postlistinfo entity. @author MyEclipse Persistence Tools
 */
@Entity
@Table(name = "postlistinfo", catalog = "itdb")
public class Postlistinfo implements java.io.Serializable {

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
	public Postlistinfo() {
	}

	/** full constructor */
	public Postlistinfo(Integer pliPtiid, String pliTitle, String pliContent,
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
	@GenericGenerator(name = "generator", strategy = "identity")
	@Id
	@GeneratedValue(generator = "generator")
	@Column(name = "pli_id", unique = true, nullable = false)
	public Integer getPliId() {
		return this.pliId;
	}

	public void setPliId(Integer pliId) {
		this.pliId = pliId;
	}

	@Column(name = "pli_ptiid", nullable = false)
	public Integer getPliPtiid() {
		return this.pliPtiid;
	}

	public void setPliPtiid(Integer pliPtiid) {
		this.pliPtiid = pliPtiid;
	}

	@Column(name = "pli_title", nullable = false, length = 30)
	public String getPliTitle() {
		return this.pliTitle;
	}

	public void setPliTitle(String pliTitle) {
		this.pliTitle = pliTitle;
	}

	@Column(name = "pli_content", nullable = false, length = 65535)
	public String getPliContent() {
		return this.pliContent;
	}

	public void setPliContent(String pliContent) {
		this.pliContent = pliContent;
	}

	@Column(name = "pli_userid", nullable = false)
	public Integer getPliUserid() {
		return this.pliUserid;
	}

	public void setPliUserid(Integer pliUserid) {
		this.pliUserid = pliUserid;
	}

	@Column(name = "pli_istop", nullable = false)
	public Integer getPliIstop() {
		return this.pliIstop;
	}

	public void setPliIstop(Integer pliIstop) {
		this.pliIstop = pliIstop;
	}

	@Column(name = "pli_replynum", nullable = false)
	public Integer getPliReplynum() {
		return this.pliReplynum;
	}

	public void setPliReplynum(Integer pliReplynum) {
		this.pliReplynum = pliReplynum;
	}

	@Column(name = "pli_createtime", nullable = false, length = 19)
	public Timestamp getPliCreatetime() {
		return this.pliCreatetime;
	}

	public void setPliCreatetime(Timestamp pliCreatetime) {
		this.pliCreatetime = pliCreatetime;
	}

	@Column(name = "pli_status", nullable = false)
	public Integer getPliStatus() {
		return this.pliStatus;
	}

	public void setPliStatus(Integer pliStatus) {
		this.pliStatus = pliStatus;
	}

	@Column(name = "pli_reportnum", nullable = false)
	public Integer getPliReportnum() {
		return this.pliReportnum;
	}

	public void setPliReportnum(Integer pliReportnum) {
		this.pliReportnum = pliReportnum;
	}

}