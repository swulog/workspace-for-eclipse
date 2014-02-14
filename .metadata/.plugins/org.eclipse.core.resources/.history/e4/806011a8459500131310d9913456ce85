package com.ivorytower.app.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import org.hibernate.annotations.GenericGenerator;

/**
 * Userrelationshipinfo entity. @author MyEclipse Persistence Tools
 */
@Entity
@Table(name = "userrelationshipinfo", catalog = "itdb")
public class Userrelationshipinfo implements java.io.Serializable {

	// Fields

	private Integer uriId;
	private Integer uriUsera;
	private Integer uriUserb;
	private Integer uriType;

	// Constructors

	/** default constructor */
	public Userrelationshipinfo() {
	}

	/** full constructor */
	public Userrelationshipinfo(Integer uriUsera, Integer uriUserb,
			Integer uriType) {
		this.uriUsera = uriUsera;
		this.uriUserb = uriUserb;
		this.uriType = uriType;
	}

	// Property accessors
	@GenericGenerator(name = "generator", strategy = "identity")
	@Id
	@GeneratedValue(generator = "generator")
	@Column(name = "uri_id", unique = true, nullable = false)
	public Integer getUriId() {
		return this.uriId;
	}

	public void setUriId(Integer uriId) {
		this.uriId = uriId;
	}

	@Column(name = "uri_usera", nullable = false)
	public Integer getUriUsera() {
		return this.uriUsera;
	}

	public void setUriUsera(Integer uriUsera) {
		this.uriUsera = uriUsera;
	}

	@Column(name = "uri_userb", nullable = false)
	public Integer getUriUserb() {
		return this.uriUserb;
	}

	public void setUriUserb(Integer uriUserb) {
		this.uriUserb = uriUserb;
	}

	@Column(name = "uri_type", nullable = false)
	public Integer getUriType() {
		return this.uriType;
	}

	public void setUriType(Integer uriType) {
		this.uriType = uriType;
	}

}