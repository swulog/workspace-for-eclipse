package com.ivorytower.app.entity;

import java.sql.Timestamp;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import org.hibernate.annotations.GenericGenerator;

/**
 * Userexpandinfo entity. @author MyEclipse Persistence Tools
 */
@Entity
@Table(name = "userexpandinfo", catalog = "itdb")
public class Userexpandinfo implements java.io.Serializable {

	// Fields
	private static final long serialVersionUID = 1L;
	private Integer ueiId;
	private String ueiNickname;
	private Integer ueiSex;
	private Integer ueiAge;
	private Integer ueiScore;
	private Integer ueiCoin;
	private Integer ueiLevel;
	private String ueiTelephone;
	private String ueiAvatar;
	private String ueiMood;
	private Integer ueiVisible;
	private Timestamp ueiCreatetime;
	private Integer ueiOnline;
	private String ueiSession;
	

	// Constructors

	/** default constructor */
	public Userexpandinfo() {
	}

	/** full constructor */
	public Userexpandinfo(String ueiNickname, Integer ueiSex, Integer ueiAge,
			Integer ueiScore, Integer ueiCoin, Integer ueiLevel,
			String ueiTelephone, String ueiAvatar, String ueiMood,
			Integer ueiVisible, Timestamp ueiCreatetime, Integer ueiOnline,String ueiSession) {
		this.ueiNickname = ueiNickname;
		this.ueiSex = ueiSex;
		this.ueiAge = ueiAge;
		this.ueiScore = ueiScore;
		this.ueiCoin = ueiCoin;
		this.ueiLevel = ueiLevel;
		this.ueiTelephone = ueiTelephone;
		this.ueiAvatar = ueiAvatar;
		this.ueiMood = ueiMood;
		this.ueiVisible = ueiVisible;
		this.ueiCreatetime = ueiCreatetime;
		this.ueiOnline = ueiOnline;
		this.ueiSession = ueiSession;
	}

	// Property accessors
	@GenericGenerator(name = "generator", strategy = "identity")
	@Id
	@GeneratedValue(generator = "generator")
	@Column(name = "uei_id", unique = true, nullable = false)
	public Integer getUeiId() {
		return this.ueiId;
	}

	public void setUeiId(Integer ueiId) {
		this.ueiId = ueiId;
	}

	@Column(name = "uei_nickname", nullable = false, length = 30)
	public String getUeiNickname() {
		return this.ueiNickname;
	}

	public void setUeiNickname(String ueiNickname) {
		this.ueiNickname = ueiNickname;
	}

	@Column(name = "uei_sex", nullable = false)
	public Integer getUeiSex() {
		return this.ueiSex;
	}

	public void setUeiSex(Integer ueiSex) {
		this.ueiSex = ueiSex;
	}

	@Column(name = "uei_age", nullable = false)
	public Integer getUeiAge() {
		return this.ueiAge;
	}

	public void setUeiAge(Integer ueiAge) {
		this.ueiAge = ueiAge;
	}

	@Column(name = "uei_score", nullable = false)
	public Integer getUeiScore() {
		return this.ueiScore;
	}

	public void setUeiScore(Integer ueiScore) {
		this.ueiScore = ueiScore;
	}

	@Column(name = "uei_coin", nullable = false)
	public Integer getUeiCoin() {
		return this.ueiCoin;
	}

	public void setUeiCoin(Integer ueiCoin) {
		this.ueiCoin = ueiCoin;
	}

	@Column(name = "uei_level", nullable = false)
	public Integer getUeiLevel() {
		return this.ueiLevel;
	}

	public void setUeiLevel(Integer ueiLevel) {
		this.ueiLevel = ueiLevel;
	}

	@Column(name = "uei_telephone", nullable = false, length = 11)
	public String getUeiTelephone() {
		return this.ueiTelephone;
	}

	public void setUeiTelephone(String ueiTelephone) {
		this.ueiTelephone = ueiTelephone;
	}

	@Column(name = "uei_avatar", nullable = false, length = 200)
	public String getUeiAvatar() {
		return this.ueiAvatar;
	}

	public void setUeiAvatar(String ueiAvatar) {
		this.ueiAvatar = ueiAvatar;
	}

	@Column(name = "uei_mood", nullable = false, length = 500)
	public String getUeiMood() {
		return this.ueiMood;
	}

	public void setUeiMood(String ueiMood) {
		this.ueiMood = ueiMood;
	}

	@Column(name = "uei_visible", nullable = false)
	public Integer getUeiVisible() {
		return this.ueiVisible;
	}

	public void setUeiVisible(Integer ueiVisible) {
		this.ueiVisible = ueiVisible;
	}

	@Column(name = "uei_createtime", nullable = false, length = 19)
	public Timestamp getUeiCreatetime() {
		return this.ueiCreatetime;
	}

	public void setUeiCreatetime(Timestamp ueiCreatetime) {
		this.ueiCreatetime = ueiCreatetime;
	}

	@Column(name = "uei_online", nullable = false)
	public Integer getUbiOnline() {
		return ueiOnline;
	}

	public void setUbiOnline(Integer ueiOnline) {
		this.ueiOnline = ueiOnline;
	}
	@Column(name = "uei_session", nullable = false)
	public String getUbiSession() {
		return ueiSession;
	}

	public void setUbiSession(String ueiSession) {
		this.ueiSession = ueiSession;
	}

}