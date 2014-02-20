package com.ivorytower.app.dto;


public class QryPostsListDto {
	
	

	//for request
	private int posttypeid;
	private int pageno;
	private int pagesize;
	
	public int getPosttypeid() {
		return posttypeid;
	}
	public void setPosttypeid(int posttypeid) {
		this.posttypeid = posttypeid;
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
