package com.ivorytower.app.dto;

public class ReplyPostDto {
	
	//for request
	private int userid;
	private int postid;
	private String title;
	private String atlist;
	
	public int getUserid() {
		return userid;
	}
	public void setUserid(int userid) {
		this.userid = userid;
	}
	public int getPostid() {
		return postid;
	}
	public void setPostid(int postid) {
		this.postid = postid;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getAtlist() {
		return atlist;
	}
	public void setAtlist(String atlist) {
		this.atlist = atlist;
	}

}
