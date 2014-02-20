package com.ivorytower.app.dto;

public class AddNewPostDto {
	
	//for request
	private int userid;
	private String title;
	private String content;
	private String atlist;
	private int posttype;
	
	public int getUserid() {
		return userid;
	}
	public void setUserid(int userid) {
		this.userid = userid;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getAtlist() {
		return atlist;
	}
	public void setAtlist(String atlist) {
		this.atlist = atlist;
	}
	public int getPosttype() {
		return posttype;
	}
	public void setPosttype(int posttype) {
		this.posttype = posttype;
	}
	

}
