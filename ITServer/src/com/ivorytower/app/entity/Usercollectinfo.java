package com.ivorytower.app.entity;

import java.sql.Timestamp;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import org.hibernate.annotations.GenericGenerator;

/**
 * Usercollectinfo entity. @author MyEclipse Persistence Tools
 */
@Entity
@Table(name = "usercollectinfo", catalog = "itdb")
public class Usercollectinfo implements java.io.Serializable {

	// Fields
	private static final long serialVersionUID = 1L;
	private Integer ucliId;
	private Integer ucliUserid;
	private String ucliPostids;
	private Timestamp ucliCreatetime;

	// Constructors

	/** default constructor */
	public Usercollectinfo() {
	}

	/** full constructor */
	public Usercollectinfo(Integer ucliUserid, String ucliPostids,
			Timestamp ucliCreatetime) {
		this.ucliUserid = ucliUserid;
		this.ucliPostids = ucliPostids;
		this.ucliCreatetime = ucliCreatetime;
	}

	// Property accessors
	@GenericGenerator(name = "generator", strategy = "identity")
	@Id
	@GeneratedValue(generator = "generator")
	@Column(name = "ucli_id", unique = true, nullable = false)
	public Integer getUcliId() {
		return this.ucliId;
	}

	public void setUcliId(Integer ucliId) {
		this.ucliId = ucliId;
	}

	@Column(name = "ucli_userid", nullable = false)
	public Integer getUcliUserid() {
		return this.ucliUserid;
	}

	public void setUcliUserid(Integer ucliUserid) {
		this.ucliUserid = ucliUserid;
	}

	@Column(name = "ucli_postids", nullable = false, length = 200)
	public String getUcliPostids() {
		return this.ucliPostids;
	}

	public void setUcliPostids(String ucliPostids) {
		this.ucliPostids = ucliPostids;
	}

	@Column(name = "ucli_createtime", nullable = false, length = 19)
	public Timestamp getUcliCreatetime() {
		return this.ucliCreatetime;
	}

	public void setUcliCreatetime(Timestamp ucliCreatetime) {
		this.ucliCreatetime = ucliCreatetime;
	}

}