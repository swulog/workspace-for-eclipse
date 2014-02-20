package com.ivorytower.app.dto;

public class QryOnlineUsersListDto {
	
	//for request
	private int sorttype;
	private int usersex;
	private int userlevel;
	private int pageno;
	private int pagesize;
	
	public int getSorttype() {
		return sorttype;
	}
	public void setSorttype(int sorttype) {
		this.sorttype = sorttype;
	}
	public int getUsersex() {
		return usersex;
	}
	public void setUsersex(int usersex) {
		this.usersex = usersex;
	}
	public int getUserlevel() {
		return userlevel;
	}
	public void setUserlevel(int userlevel) {
		this.userlevel = userlevel;
	}
	public int getPageno() {
		return pageno;
	}
	public void setPageno(int pageno) {
		this.pageno = pageno;
	}
	public int getPagesize() {
		return pagesize;
	}
	public void setPagesize(int pagesize) {
		this.pagesize = pagesize;
	}

}
