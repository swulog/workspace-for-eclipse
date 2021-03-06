package com.ivorytower.app.entity;

import java.sql.Timestamp;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import org.hibernate.annotations.GenericGenerator;

/**
 * Usercourseinfo entity. @author MyEclipse Persistence Tools
 */
@Entity
@Table(name = "usercourseinfo", catalog = "itdb")
public class Usercourseinfo implements java.io.Serializable {

	// Fields
	private static final long serialVersionUID = 1L;
	private Integer uciId;
	private Integer uciUserid;
	private Timestamp uciCreatetme;
	private String uciCorsecontent;

	// Constructors

	/** default constructor */
	public Usercourseinfo() {
	}

	/** full constructor */
	public Usercourseinfo(Integer uciUserid, Timestamp uciCreatetme,
			String uciCorsecontent) {
		this.uciUserid = uciUserid;
		this.uciCreatetme = uciCreatetme;
		this.uciCorsecontent = uciCorsecontent;
	}

	// Property accessors
	@GenericGenerator(name = "generator", strategy = "identity")
	@Id
	@GeneratedValue(generator = "generator")
	@Column(name = "uci_id", unique = true, nullable = false)
	public Integer getUciId() {
		return this.uciId;
	}

	public void setUciId(Integer uciId) {
		this.uciId = uciId;
	}

	@Column(name = "uci_userid", nullable = false)
	public Integer getUciUserid() {
		return this.uciUserid;
	}

	public void setUciUserid(Integer uciUserid) {
		this.uciUserid = uciUserid;
	}

	@Column(name = "uci_createtme", nullable = false, length = 19)
	public Timestamp getUciCreatetme() {
		return this.uciCreatetme;
	}

	public void setUciCreatetme(Timestamp uciCreatetme) {
		this.uciCreatetme = uciCreatetme;
	}

	@Column(name = "uci_corsecontent", nullable = false, length = 65535)
	public String getUciCorsecontent() {
		return this.uciCorsecontent;
	}

	public void setUciCorsecontent(String uciCorsecontent) {
		this.uciCorsecontent = uciCorsecontent;
	}

}