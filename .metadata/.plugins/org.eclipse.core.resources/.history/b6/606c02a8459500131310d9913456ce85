package com.ivorytower.app.entity;

import java.sql.Timestamp;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import org.hibernate.annotations.GenericGenerator;

/**
 * Posttypeinfo entity. @author MyEclipse Persistence Tools
 */
@Entity
@Table(name = "posttypeinfo", catalog = "itdb")
public class Posttypeinfo implements java.io.Serializable {

	// Fields

	private Integer ptiId;
	private Integer ptiNum;
	private Integer ptiPnum;
	private String ptiTitle;
	private Timestamp ptiCreatetime;

	// Constructors

	/** default constructor */
	public Posttypeinfo() {
	}

	/** full constructor */
	public Posttypeinfo(Integer ptiNum, Integer ptiPnum, String ptiTitle,
			Timestamp ptiCreatetime) {
		this.ptiNum = ptiNum;
		this.ptiPnum = ptiPnum;
		this.ptiTitle = ptiTitle;
		this.ptiCreatetime = ptiCreatetime;
	}

	// Property accessors
	@GenericGenerator(name = "generator", strategy = "identity")
	@Id
	@GeneratedValue(generator = "generator")
	@Column(name = "pti_id", unique = true, nullable = false)
	public Integer getPtiId() {
		return this.ptiId;
	}

	public void setPtiId(Integer ptiId) {
		this.ptiId = ptiId;
	}

	@Column(name = "pti_num", nullable = false)
	public Integer getPtiNum() {
		return this.ptiNum;
	}

	public void setPtiNum(Integer ptiNum) {
		this.ptiNum = ptiNum;
	}

	@Column(name = "pti_pnum", nullable = false)
	public Integer getPtiPnum() {
		return this.ptiPnum;
	}

	public void setPtiPnum(Integer ptiPnum) {
		this.ptiPnum = ptiPnum;
	}

	@Column(name = "pti_title", nullable = false, length = 30)
	public String getPtiTitle() {
		return this.ptiTitle;
	}

	public void setPtiTitle(String ptiTitle) {
		this.ptiTitle = ptiTitle;
	}

	@Column(name = "pti_createtime", nullable = false, length = 19)
	public Timestamp getPtiCreatetime() {
		return this.ptiCreatetime;
	}

	public void setPtiCreatetime(Timestamp ptiCreatetime) {
		this.ptiCreatetime = ptiCreatetime;
	}

}