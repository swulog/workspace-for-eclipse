package com.university.model;

import java.sql.Timestamp;

/**
 * UserExpandInfo entity. @author MyEclipse Persistence Tools
 */

public class UserExpandInfo implements java.io.Serializable {

	// Fields

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
	private Integer ueiStatus;

	// Constructors

	/** default constructor */
	public UserExpandInfo() {
	}

	/** full constructor */
	public UserExpandInfo(String ueiNickname, Integer ueiSex, Integer ueiAge,
			Integer ueiScore, Integer ueiCoin, Integer ueiLevel,
			String ueiTelephone, String ueiAvatar, String ueiMood,
			Integer ueiVisible, Timestamp ueiCreatetime, Integer ueiStatus) {
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
		this.ueiStatus = ueiStatus;
	}

	// Property accessors

	public Integer getUeiId() {
		return this.ueiId;
	}

	public void setUeiId(Integer ueiId) {
		this.ueiId = ueiId;
	}

	public String getUeiNickname() {
		return this.ueiNickname;
	}

	public void setUeiNickname(String ueiNickname) {
		this.ueiNickname = ueiNickname;
	}

	public Integer getUeiSex() {
		return this.ueiSex;
	}

	public void setUeiSex(Integer ueiSex) {
		this.ueiSex = ueiSex;
	}

	public Integer getUeiAge() {
		return this.ueiAge;
	}

	public void setUeiAge(Integer ueiAge) {
		this.ueiAge = ueiAge;
	}

	public Integer getUeiScore() {
		return this.ueiScore;
	}

	public void setUeiScore(Integer ueiScore) {
		this.ueiScore = ueiScore;
	}

	public Integer getUeiCoin() {
		return this.ueiCoin;
	}

	public void setUeiCoin(Integer ueiCoin) {
		this.ueiCoin = ueiCoin;
	}

	public Integer getUeiLevel() {
		return this.ueiLevel;
	}

	public void setUeiLevel(Integer ueiLevel) {
		this.ueiLevel = ueiLevel;
	}

	public String getUeiTelephone() {
		return this.ueiTelephone;
	}

	public void setUeiTelephone(String ueiTelephone) {
		this.ueiTelephone = ueiTelephone;
	}

	public String getUeiAvatar() {
		return this.ueiAvatar;
	}

	public void setUeiAvatar(String ueiAvatar) {
		this.ueiAvatar = ueiAvatar;
	}

	public String getUeiMood() {
		return this.ueiMood;
	}

	public void setUeiMood(String ueiMood) {
		this.ueiMood = ueiMood;
	}

	public Integer getUeiVisible() {
		return this.ueiVisible;
	}

	public void setUeiVisible(Integer ueiVisible) {
		this.ueiVisible = ueiVisible;
	}

	public Timestamp getUeiCreatetime() {
		return this.ueiCreatetime;
	}

	public void setUeiCreatetime(Timestamp ueiCreatetime) {
		this.ueiCreatetime = ueiCreatetime;
	}

	public Integer getUeiStatus() {
		return this.ueiStatus;
	}

	public void setUeiStatus(Integer ueiStatus) {
		this.ueiStatus = ueiStatus;
	}

}