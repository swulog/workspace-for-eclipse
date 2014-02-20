package com.ivorytower.app.dto;

public class LoginDto {
	
	//for request
	private int username;
	private String userpwd;
	
	public int getUsername() {
		return username;
	}
	public void setUsername(int username) {
		this.username = username;
	}
	public String getUserpwd() {
		return userpwd;
	}
	public void setUserpwd(String userpwd) {
		this.userpwd = userpwd;
	}

}
