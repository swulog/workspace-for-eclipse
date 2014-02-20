package com.ivorytower.app.entity;

import java.sql.Timestamp;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import org.hibernate.annotations.GenericGenerator;

/**
 * Usernotesinfo entity. @author MyEclipse Persistence Tools
 */
@Entity
@Table(name = "usernotesinfo", catalog = "itdb")
public class Usernotesinfo implements java.io.Serializable {

	// Fields
	private static final long serialVersionUID = 1L;
	private Integer uniId;
	private Integer uniUserid;
	private String uniTitle;
	private String uniContent;
	private Timestamp uniCreatetime;

	// Constructors

	/** default constructor */
	public Usernotesinfo() {
	}

	/** full constructor */
	public Usernotesinfo(Integer uniUserid, String uniTitle, String uniContent,
			Timestamp uniCreatetime) {
		this.uniUserid = uniUserid;
		this.uniTitle = uniTitle;
		this.uniContent = uniContent;
		this.uniCreatetime = uniCreatetime;
	}

	// Property accessors
	@GenericGenerator(name = "generator", strategy = "identity")
	@Id
	@GeneratedValue(generator = "generator")
	@Column(name = "uni_id", unique = true, nullable = false)
	public Integer getUniId() {
		return this.uniId;
	}

	public void setUniId(Integer uniId) {
		this.uniId = uniId;
	}

	@Column(name = "uni_userid", nullable = false)
	public Integer getUniUserid() {
		return this.uniUserid;
	}

	public void setUniUserid(Integer uniUserid) {
		this.uniUserid = uniUserid;
	}

	@Column(name = "uni_title", nullable = false, length = 50)
	public String getUniTitle() {
		return this.uniTitle;
	}

	public void setUniTitle(String uniTitle) {
		this.uniTitle = uniTitle;
	}

	@Column(name = "uni_content", nullable = false, length = 65535)
	public String getUniContent() {
		return this.uniContent;
	}

	public void setUniContent(String uniContent) {
		this.uniContent = uniContent;
	}

	@Column(name = "uni_createtime", nullable = false, length = 19)
	public Timestamp getUniCreatetime() {
		return this.uniCreatetime;
	}

	public void setUniCreatetime(Timestamp uniCreatetime) {
		this.uniCreatetime = uniCreatetime;
	}

}