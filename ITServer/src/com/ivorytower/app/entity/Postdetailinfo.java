package com.ivorytower.app.entity;

import java.sql.Timestamp;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import org.hibernate.annotations.GenericGenerator;

/**
 * Postdetailinfo entity. @author MyEclipse Persistence Tools
 */
@Entity
@Table(name = "postdetailinfo", catalog = "itdb")
public class Postdetailinfo implements java.io.Serializable {

	// Fields

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Integer pdiId;
	private Integer pdiPpostid;
	private String pdiTitle;
	private String pdiContent;
	private String pdiPicture;
	private Integer pdiUserid;
	private Integer pdiLevel;
	private Timestamp pdiCreatetime;

	// Constructors

	/** default constructor */
	public Postdetailinfo() {
	}

	/** full constructor */
	public Postdetailinfo(Integer pdiPpostid, String pdiTitle,
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
	@GenericGenerator(name = "generator", strategy = "identity")
	@Id
	@GeneratedValue(generator = "generator")
	@Column(name = "pdi_id", unique = true, nullable = false)
	public Integer getPdiId() {
		return this.pdiId;
	}

	public void setPdiId(Integer pdiId) {
		this.pdiId = pdiId;
	}

	@Column(name = "pdi_ppostid", nullable = false)
	public Integer getPdiPpostid() {
		return this.pdiPpostid;
	}

	public void setPdiPpostid(Integer pdiPpostid) {
		this.pdiPpostid = pdiPpostid;
	}

	@Column(name = "pdi_title", nullable = false, length = 30)
	public String getPdiTitle() {
		return this.pdiTitle;
	}

	public void setPdiTitle(String pdiTitle) {
		this.pdiTitle = pdiTitle;
	}

	@Column(name = "pdi_content", nullable = false, length = 65535)
	public String getPdiContent() {
		return this.pdiContent;
	}

	public void setPdiContent(String pdiContent) {
		this.pdiContent = pdiContent;
	}

	@Column(name = "pdi_picture", nullable = false, length = 200)
	public String getPdiPicture() {
		return this.pdiPicture;
	}

	public void setPdiPicture(String pdiPicture) {
		this.pdiPicture = pdiPicture;
	}

	@Column(name = "pdi_userid", nullable = false)
	public Integer getPdiUserid() {
		return this.pdiUserid;
	}

	public void setPdiUserid(Integer pdiUserid) {
		this.pdiUserid = pdiUserid;
	}
	
	@Column(name = "pdi_level", nullable = false)
	public Integer getPdiLevel() {
		return pdiLevel;
	}

	public void setPdiLevel(Integer pdiLevel) {
		this.pdiLevel = pdiLevel;
	}

	@Column(name = "pdi_createtime", nullable = false, length = 19)
	public Timestamp getPdiCreatetime() {
		return this.pdiCreatetime;
	}

	public void setPdiCreatetime(Timestamp pdiCreatetime) {
		this.pdiCreatetime = pdiCreatetime;
	}

}