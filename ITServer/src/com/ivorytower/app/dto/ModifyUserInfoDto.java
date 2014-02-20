package com.ivorytower.app.dto;

public class ModifyUserInfoDto {
	
	private int userid;
	private String usernickname;
	private String usermood;
	private int usersex;
	private int userage;
	private String usertelephone;
	private String userimage;
	
	public int getUserid() {
		return userid;
	}
	public void setUserid(int userid) {
		this.userid = userid;
	}
	public String getUsernickname() {
		return usernickname;
	}
	public void setUsernickname(String usernickname) {
		this.usernickname = usernickname;
	}
	public String getUsermood() {
		return usermood;
	}
	public void setUsermood(String usermood) {
		this.usermood = usermood;
	}
	public int getUsersex() {
		return usersex;
	}
	public void setUsersex(int usersex) {
		this.usersex = usersex;
	}
	public int getUserage() {
		return userage;
	}
	public void setUserage(int userage) {
		this.userage = userage;
	}
	public String getUsertelephone() {
		return usertelephone;
	}
	public void setUsertelephone(String usertelephone) {
		this.usertelephone = usertelephone;
	}
	public String getUserimage() {
		return userimage;
	}
	public void setUserimage(String userimage) {
		this.userimage = userimage;
	}

}
